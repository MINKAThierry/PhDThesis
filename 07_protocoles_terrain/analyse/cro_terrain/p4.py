"""P4: standardised joint estimation of (Delta_hat, alpha_hat).

Status: PROPOSAL, reference implementation of algorithm
``alg:estimation_conjointe`` (thesis, Chapter 4, section 4.2.4) for a protocol
that has not been deployed.

    Require : institutional agreement, ethics approval, n >= 30 participants
    Step 1  : data collection (verdicts, confidence, time)
    Step 2  : matching of each verdict with the committed message m
    Step 3  : admissibility test V independent of M given (Sigma, C)
    Step 4  : Delta_hat = I(V ; Sigma | M, C)
    Step 5  : alpha_hat = log2 |V| / H(C), computed independently of Delta_hat
    Step 6  : validation, ICC >= 0.8 and kappa >= 0.7

``estimation_conjointe`` runs the six steps on a ``p4_verdicts`` table
(French or English template) and returns a report in which every step keeps
its own status, so that a failure at one step is visible and does not
silently contaminate the next ones. The thesis does not give an estimator of
beta in this algorithm; beta is therefore not computed here.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from dataclasses import dataclass, field
from typing import Mapping, Sequence

import numpy as np

from . import information as inf
from .refutation import criterion_admissibility, criterion_delta, criterion_gamma
from .reliability import cohen_kappa, icc_2_1, reliability_verdict
from .statistics import admissibility_permutation_test, cluster_bootstrap

MIN_PARTICIPANTS = 30  # thesis, Require line of alg:estimation_conjointe
ADMISSIBILITY_THRESHOLD = 0.01


@dataclass
class Prerequisites:
    institutional_agreement: bool
    ethics_approval: bool
    n_participants: int

    def satisfied(self) -> bool:
        return (self.institutional_agreement and self.ethics_approval
                and self.n_participants >= MIN_PARTICIPANTS)

    def missing(self) -> list[str]:
        out = []
        if not self.institutional_agreement:
            out.append("institutional agreement")
        if not self.ethics_approval:
            out.append("ethics approval")
        if self.n_participants < MIN_PARTICIPANTS:
            out.append(f"n >= {MIN_PARTICIPANTS} participants (observed {self.n_participants})")
        return out


@dataclass
class Report:
    prerequisites: Prerequisites
    steps: dict = field(default_factory=dict)

    def summary(self) -> list[str]:
        lines = [f"Require: {'satisfied' if self.prerequisites.satisfied() else 'NOT satisfied'}"
                 + ("" if self.prerequisites.satisfied()
                    else " (" + "; ".join(self.prerequisites.missing()) + ")")]
        for k in sorted(self.steps):
            lines.append(f"Step {k}: {self.steps[k]['status']} - {self.steps[k]['detail']}")
        return lines


# ---------------------------------------------------------------------------
# Verdict space (alpha numerator)
# ---------------------------------------------------------------------------

def verdict_space_size(space: Mapping[str, Sequence], institution_id: str,
                       context_id: str | None = None) -> int:
    """|V| from a ``p4_verdict_space`` table: number of distinct retained verdict codes.

    ``retained`` accepts oui/yes/1/true (case-insensitive). If ``context_id`` is
    None, the verdicts of all contexts of the institution are pooled. When rows
    whose ``notes`` start with "consolid" (consolidated list) exist, only those
    rows are counted; otherwise all rows are pooled.
    """
    yes = {"oui", "yes", "1", "true", "o", "y"}
    notes = space.get("notes", [""] * len(space["institution_id"]))
    rows = [(str(ctx), str(code), str(kept).strip().lower(), str(n).strip().lower())
            for inst, ctx, code, kept, n in zip(space["institution_id"], space["context_id"],
                                                 space["verdict_code"], space["retained"], notes)
            if str(inst) == institution_id and (context_id is None or str(ctx) == context_id)]
    consolidated = [r for r in rows if r[3].startswith(("consolid",))]
    if consolidated:
        rows = consolidated
    return len({code for _, code, kept, _ in rows if kept in yes})


# ---------------------------------------------------------------------------
# Reliability inputs (step 6)
# ---------------------------------------------------------------------------

def _item_key(data, i):
    return (str(data["context_id"][i]), str(data["proof_id"][i]), str(data["sigma_code"][i]))


def retest_pairs(data: Mapping[str, Sequence], first: str = "1", second: str = "2",
                 value: str = "confidence"):
    """Pairs (session 1, session 2) per (participant, context, proof, sigma) for ICC and kappa.

    Returns (values_first, values_second, verdicts_first, verdicts_second).
    Raises ValueError if an item appears twice for a participant in one session,
    since the pairing would then be ambiguous.
    """
    by = defaultdict(dict)
    for i, (p, sess) in enumerate(zip(data["participant_id"], data["session"])):
        key = (str(p),) + _item_key(data, i)
        if str(sess) in by[key]:
            raise ValueError(f"item {key} appears twice in session {sess}")
        by[key][str(sess)] = i
    a, b, va, vb = [], [], [], []
    for d in by.values():
        if first in d and second in d:
            i, j = d[first], d[second]
            a.append(float(data[value][i]))
            b.append(float(data[value][j]))
            va.append(str(data["verdict"][i]))
            vb.append(str(data["verdict"][j]))
    return np.asarray(a), np.asarray(b), va, vb


def pairwise_inter_rater_kappa(data: Mapping[str, Sequence], session: str = "1",
                               min_common: int = 5) -> float:
    """Mean Cohen kappa over pairs of participants of the same stratum on common items.

    An item is a stimulus (context, proof), whatever the proof variant sigma
    shown, as in the analysis plan (section 7): in P1 the participants of a
    stratum who see the same pair receive different variants by design.
    """
    items = defaultdict(dict)  # participant -> item -> verdict
    strat = {}
    for i, (p, st, v, sess) in enumerate(zip(data["participant_id"], data["stratum"],
                                             data["verdict"], data["session"])):
        if str(sess) != session:
            continue
        items[str(p)][_item_key(data, i)[:2]] = str(v)
        strat[str(p)] = str(st)
    parts = sorted(items)
    ks = []
    for x in range(len(parts)):
        for y in range(x + 1, len(parts)):
            p, q = parts[x], parts[y]
            if strat[p] != strat[q]:
                continue
            common = sorted(set(items[p]) & set(items[q]))
            if len(common) < min_common:
                continue
            k = cohen_kappa([items[p][i] for i in common], [items[q][i] for i in common])
            if np.isfinite(k):
                ks.append(k)
    return float(np.mean(ks)) if ks else float("nan")


# ---------------------------------------------------------------------------
# Algorithm alg:estimation_conjointe
# ---------------------------------------------------------------------------

def _select(data, mask):
    return {k: (np.asarray(v, dtype=object)[mask] if not k.startswith("_") else v)
            for k, v in data.items()}


def estimation_conjointe(data: Mapping[str, Sequence], *, n_verdicts: int, h_c: float,
                         delta_prereg: float | None = None,
                         institutional_agreement: bool, ethics_approval: bool,
                         main_session: str = "1", retest_session: str = "2",
                         n_perm: int = 999, n_boot: int = 1000, seed: int = 0,
                         alphabet_size: int | None = None) -> Report:
    """Run the six steps of alg:estimation_conjointe on a ``p4_verdicts`` table.

    ``n_verdicts`` is |V| (``verdict_space_size``); ``h_c`` comes from P2 or
    from the reference table of the thesis; ``delta_prereg`` is the capacity
    registered before the experiment for the population (refutation criterion).
    """
    sess = np.asarray([str(s) for s in data["session"]])
    main = _select(data, sess == main_session)
    n_part = len(set(str(p) for p in main["participant_id"]))
    rep = Report(Prerequisites(institutional_agreement, ethics_approval, n_part))

    # Step 1: collection completeness
    v = np.asarray([str(x) for x in main["verdict"]])
    missing = int(sum(1 for x in v if x in ("", "nan")))
    rep.steps[1] = {"status": "done", "detail": f"{len(v)} answers, {n_part} participants, "
                    f"{missing} missing verdicts", "n_answers": len(v), "n_participants": n_part}
    keep = np.asarray([x not in ("", "nan") for x in v])
    main = _select(main, keep)

    # Step 2: matching with the ground truth m
    m = np.asarray([str(x) for x in main["message_m"]])
    unmatched = int(sum(1 for x in m if x in ("", "nan")))
    rep.steps[2] = {"status": "done" if unmatched == 0 else "incomplete",
                    "detail": f"{unmatched} answers without ground-truth message"}
    main = _select(main, np.asarray([x not in ("", "nan") for x in m]))

    # Step 3: admissibility
    perm = admissibility_permutation_test(main["verdict"], main["message_m"], main["sigma_code"],
                                          main["context_id"], n_perm=n_perm, seed=seed)
    dec = criterion_admissibility(perm.p_value, perm.n_informative_strata)
    rep.steps[3] = {"status": dec.status, "detail": f"I(V;M|Sigma,C) = {perm.statistic:.4f}, "
                    f"p = {perm.p_value:.4f}, informative strata = {perm.n_informative_strata}",
                    "p_value": perm.p_value, "statistic": perm.statistic,
                    "n_informative_strata": perm.n_informative_strata}

    # Step 4: Delta_hat with participant bootstrap
    def stat(d):
        return inf.delta_hat(d["verdict"], d["sigma_code"], d["message_m"], d["context_id"],
                             method="mm", alphabet_size=alphabet_size)

    b = cluster_bootstrap(main, stat, "participant_id", n_boot=n_boot, seed=seed + 1)
    s4 = {"status": "done", "detail": f"Delta_hat = {b.estimate:.3f} bits, 95% CI "
          f"[{b.low:.3f}, {b.high:.3f}], {b.n_clusters} participants",
          "delta_hat": b.estimate, "ci": (b.low, b.high)}
    if delta_prereg is not None:
        d = criterion_delta(b.low, delta_prereg)
        s4["criterion"] = d.status
        s4["detail"] += f"; criterion vs {delta_prereg} bits: {d.status}"
    if perm.rejects(ADMISSIBILITY_THRESHOLD):
        s4["detail"] += "; admissibility rejected, Delta_hat not interpretable as extraction"
    rep.steps[4] = s4

    # Step 5: alpha_hat, independent of Delta_hat; gamma criterion with NSB H(V|C)
    a = inf.alpha_hat(n_verdicts, h_c)

    def hv(d):
        return inf.h_v_given_c(d["verdict"], d["context_id"], method="nsb",
                               alphabet_size=n_verdicts)

    bh = cluster_bootstrap(main, hv, "participant_id", n_boot=n_boot, seed=seed + 2)
    g = criterion_gamma(bh.high, a, h_c)
    rep.steps[5] = {"status": "done", "detail": f"alpha_hat = {a:.4f} (|V| = {n_verdicts}, "
                    f"H(C) = {h_c} bits); H(V|C) = {bh.estimate:.3f} bits, CI high {bh.high:.3f}; "
                    f"gamma criterion: {g.status}", "alpha_hat": a, "h_v_c": bh.estimate,
                    "h_v_c_ci": (bh.low, bh.high), "gamma_criterion": g.status}

    # Step 6: reliability
    x1, x2, v1, v2 = retest_pairs(data, main_session, retest_session)
    icc = icc_2_1(np.column_stack([x1, x2])) if len(x1) >= 2 else float("nan")
    k_rt = cohen_kappa(v1, v2) if len(v1) >= 2 else float("nan")
    k_ir = pairwise_inter_rater_kappa(data, main_session)
    rv = reliability_verdict(icc=icc, kappa=k_ir)
    ok = rv["icc"]["satisfied"] and rv["kappa"]["satisfied"]
    if not (np.isfinite(icc) and np.isfinite(k_ir)):
        status = "not computable"
    else:
        status = "satisfied" if ok else "insufficient reliability"
    rep.steps[6] = {"status": status,
                    "detail": f"ICC test-retest = {icc:.3f} (n = {len(x1)}), kappa inter-rater = "
                              f"{k_ir:.3f}, kappa test-retest = {k_rt:.3f}",
                    "icc": icc, "kappa_inter_rater": k_ir, "kappa_retest": k_rt}
    return rep


def p1_to_p4(p1: Mapping[str, Sequence], institution_type: str = "") -> dict:
    """Map a ``p1_answers`` table onto the ``p4_verdicts`` columns (P4 reuses P1 data).

    The verdict is the overall verdict Q01; sessions are the P1 phases.
    """
    n = len(p1["participant_id"])
    return {
        "participant_id": np.asarray(p1["participant_id"], dtype=object),
        "stratum": np.asarray(p1["stratum"], dtype=object),
        "institution_type": np.asarray([institution_type] * n, dtype=object),
        "context_id": np.asarray(p1["context_id"], dtype=object),
        "proof_id": np.asarray(p1["stimulus_id"], dtype=object),
        "sigma_code": np.asarray(p1["sigma_id"], dtype=object),
        "proof_type": np.asarray(p1["proof_type"], dtype=object),
        "message_m": np.asarray(p1["message_id"], dtype=object),
        "verdict": np.asarray([("" if not np.isfinite(float(x)) else str(int(float(x))))
                               for x in p1["verdict_v"]], dtype=object),
        "confidence": np.asarray(p1["confidence"], dtype=float),
        "time_s": np.asarray(p1["time_s"], dtype=float),
        "session": np.asarray([str(int(float(x))) for x in p1["phase"]], dtype=object),
        "date": np.asarray([""] * n, dtype=object),
        "notes": np.asarray([""] * n, dtype=object),
    }


def count_by(values: Sequence) -> Counter:
    return Counter(str(v) for v in values)
