"""Synthetic data generators with known ground truth (for tests and examples).

Nothing here is field data. The generators let the test-suite check that the
estimators recover known quantities.

1. ``extraction_model`` / ``simulate_extraction``  (protocols P1, P4, P5)
   M      message, uniform on k values (known to the experimenter only);
   U      message-dependent part of the proof: U = M with probability
          ``leak``, otherwise uniform (what the proof says about M);
   S      presentation variant of the proof, independent of M (format,
          metadata, ...): what can be read in the proof beyond the message;
   Sigma  = (U, S), coded as the string "U|S";
   C      context, uniform on ``n_contexts`` values;
   V      verdict on K values. With probability 1 - noise, the participant
          applies the rule (U + use_s * S + C) mod K, where use_s ~ Bernoulli(rho_s);
          otherwise V is uniform. If ``m_leak`` > 0 the participant uses M
          directly with that probability (non-admissible interpretation).
   The exact values of I(V;Sigma|M,C) (the target of Delta_hat), I(V;Sigma|C),
   H(V|C), Opp and I(V;M|Sigma,C) are computed by enumeration.

2. ``helios_model`` / ``simulate_helios_audit``  (protocol P3)
   n_proofs proofs, a fraction of which are control proofs (altered proofs
   from a test election, proposed in P3 [to be decided by the team]);
   each trustee gives a verdict in the 4-verdict space with probabilities that
   depend on the proof status only. The exact Opp = I(V;Sigma|C)/H(V|C) is
   returned (Sigma uniform on the proof identifiers).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from itertools import product

import numpy as np


def _h(p: np.ndarray) -> float:
    p = np.asarray(p, dtype=float).ravel()
    p = p[p > 0]
    return float(-np.sum(p * np.log2(p)))


def _cond_h(joint: np.ndarray, target_axes: tuple, cond_axes: tuple) -> float:
    """H(target | cond) from a joint pmf array."""
    all_axes = set(range(joint.ndim))
    keep_tc = tuple(sorted(set(target_axes) | set(cond_axes)))
    sum_tc = tuple(sorted(all_axes - set(keep_tc)))
    p_tc = joint.sum(axis=sum_tc) if sum_tc else joint
    if cond_axes:
        sum_c = tuple(sorted(all_axes - set(cond_axes)))
        p_c = joint.sum(axis=sum_c)
        return _h(p_tc) - _h(p_c)
    return _h(p_tc)


def _cmi(joint: np.ndarray, a: tuple, b: tuple, c: tuple) -> float:
    """I(A ; B | C) from a joint pmf array (axes given as tuples)."""
    return _cond_h(joint, a, c) - _cond_h(joint, a, tuple(sorted(set(b) | set(c))))


# ---------------------------------------------------------------------------
# Extraction model
# ---------------------------------------------------------------------------

@dataclass
class ExtractionModel:
    k_messages: int = 4
    n_variants: int = 2
    n_verdicts: int = 4
    n_contexts: int = 2
    leak: float = 0.6
    rho_s: float = 0.5
    noise: float = 0.1
    m_leak: float = 0.0

    def joint(self) -> np.ndarray:
        """Joint pmf p(c, m, u, s, v) as an array of shape (C, M, U, S, V)."""
        k, j, K, nc = self.k_messages, self.n_variants, self.n_verdicts, self.n_contexts
        P = np.zeros((nc, k, k, j, K))
        for c, m, u, s in product(range(nc), range(k), range(k), range(j)):
            pu = self.leak * (u == m) + (1 - self.leak) / k
            p = (1.0 / nc) * (1.0 / k) * pu * (1.0 / j)
            pv = np.full(K, self.noise / K)
            informed = 1 - self.noise
            pv[(m + c) % K] += informed * self.m_leak
            rest = informed * (1 - self.m_leak)
            pv[(u + s + c) % K] += rest * self.rho_s
            pv[(u + c) % K] += rest * (1 - self.rho_s)
            P[c, m, u, s, :] = p * pv
        return P

    def truth(self) -> dict:
        P = self.joint()
        C, M, U, S, V = 0, 1, 2, 3, 4
        sig = (U, S)
        i_v_sig_given_mc = _cmi(P, (V,), sig, (M, C))
        i_v_sig_given_c = _cmi(P, (V,), sig, (C,))
        h_v_c = _cond_h(P, (V,), (C,))
        i_v_m_given_sig_c = _cmi(P, (V,), (M,), (U, S, C))
        i_m_sig_given_c = _cmi(P, (M,), sig, (C,))
        return {
            "delta": i_v_sig_given_mc,                 # target of Delta_hat
            "i_v_sigma_given_c": i_v_sig_given_c,
            "h_v_given_c": h_v_c,
            "opp": i_v_sig_given_c / h_v_c if h_v_c > 0 else float("nan"),
            "i_v_m_given_sigma_c": i_v_m_given_sig_c,  # 0 iff admissible
            "i_m_sigma_given_c": i_m_sig_given_c,
        }


def simulate_extraction(model: ExtractionModel, n_participants: int = 40,
                        items_per_participant: int = 50, seed: int | None = 0,
                        participant_sd: float = 0.0) -> dict:
    """Draw a long-format data set (one row per participant x item).

    ``participant_sd`` > 0 makes rho_s vary between participants (logit-normal),
    which produces clustering for the participant bootstrap; the exact truth
    is then only approximate (it refers to the mean model).
    """
    rng = np.random.default_rng(seed)
    k, j, K, nc = model.k_messages, model.n_variants, model.n_verdicts, model.n_contexts
    rows = {"participant_id": [], "context_id": [], "message_m": [], "sigma_code": [],
            "verdict": [], "session": []}
    for p in range(n_participants):
        if participant_sd > 0:
            lo = np.log(model.rho_s / (1 - model.rho_s)) + rng.normal(0, participant_sd)
            rho = 1 / (1 + np.exp(-lo))
        else:
            rho = model.rho_s
        for _ in range(items_per_participant):
            c = int(rng.integers(nc))
            m = int(rng.integers(k))
            u = m if rng.random() < model.leak else int(rng.integers(k))
            s = int(rng.integers(j))
            if rng.random() < model.noise:
                v = int(rng.integers(K))
            elif rng.random() < model.m_leak:
                v = (m + c) % K
            elif rng.random() < rho:
                v = (u + s + c) % K
            else:
                v = (u + c) % K
            rows["participant_id"].append(f"P{p:03d}")
            rows["context_id"].append(f"C{c}")
            rows["message_m"].append(f"m{m}")
            rows["sigma_code"].append(f"{u}|{s}")
            rows["verdict"].append(str(v + 1))
            rows["session"].append("T1")
    return {k_: np.asarray(v, dtype=object) for k_, v in rows.items()}


# ---------------------------------------------------------------------------
# Helios audit model
# ---------------------------------------------------------------------------

HELIOS_VERDICTS = ("1", "2", "3", "4")  # valid, invalid, recount, investigation


@dataclass
class HeliosModel:
    n_proofs: int = 50
    control_fraction: float = 0.2
    p_authentic: tuple = (0.70, 0.02, 0.08, 0.20)
    p_altered: tuple = (0.10, 0.40, 0.15, 0.35)
    statuses: list = field(default_factory=list)

    def __post_init__(self):
        n_ctrl = int(round(self.control_fraction * self.n_proofs))
        self.statuses = ["altered"] * n_ctrl + ["authentic"] * (self.n_proofs - n_ctrl)

    def truth(self) -> dict:
        pa, pb = np.asarray(self.p_authentic), np.asarray(self.p_altered)
        n = self.n_proofs
        joint = np.array([(pb if st == "altered" else pa) / n for st in self.statuses])  # (Sigma, V)
        h_v = _h(joint.sum(axis=0))
        h_v_given_sig = _h(joint) - _h(joint.sum(axis=1))
        i = h_v - h_v_given_sig
        return {"i_v_sigma": i, "h_v": h_v, "opp": i / h_v}


def simulate_helios_audit(model: HeliosModel, n_trustees: int = 10, seed: int | None = 0,
                          trustee_sd: float = 0.0) -> dict:
    """Every trustee audits every proof once (thesis design: 10 x 50)."""
    rng = np.random.default_rng(seed)
    rows = {"session_id": [], "trustee_id": [], "proof_id": [], "proof_type": [], "context_id": [],
            "verdict": [], "confidence": [], "time_s": [], "reference_status": []}
    for t in range(n_trustees):
        shift = rng.normal(0, trustee_sd) if trustee_sd > 0 else 0.0
        for i, st in enumerate(model.statuses):
            p = np.asarray(model.p_altered if st == "altered" else model.p_authentic, dtype=float)
            if shift:
                p = p * np.exp(shift * np.array([1, -1, 0, 0]))
                p = p / p.sum()
            v = HELIOS_VERDICTS[int(rng.choice(4, p=p))]
            rows["session_id"].append("S1")
            rows["trustee_id"].append(f"T{t + 1:02d}")
            rows["proof_id"].append(f"B{i + 1:03d}")
            rows["proof_type"].append("ballot")
            rows["context_id"].append("ENSP")
            rows["verdict"].append(v)
            rows["confidence"].append(float(rng.integers(3, 11)))
            rows["time_s"].append(float(rng.integers(60, 400)))
            rows["reference_status"].append(st)
    return {k: np.asarray(v, dtype=object if k not in ("confidence", "time_s") else float)
            for k, v in rows.items()}
