"""P1 (measurement of Delta): attention checks, exclusions and verdict variables.

Status: PROPOSAL, reference implementation for a protocol that has not been
deployed. The rules implement section 8 of the pre-registration template
(00_commun/preenregistrement_*.md) and the coding rules of the P1 verdict
extraction questionnaire (P1_delta/questionnaire_extraction_verdict_*.md).

* Q09 expects 3, Q18 expects 0, Q28 expects the domain of the stimulus
  (1 contract, 2 election, 3 financial control, 4 other).
* An answer to a context is excluded when at least 2 of the 3 checks fail.
* V_glob is Q01; the verdict vector V is (Q01, Q02..Q25 except Q09, Q18).

The domain of each of the 50 context-proof pairs is the one listed in
P1_delta/stimuli/catalogue_stimuli_*.md.
"""

from __future__ import annotations

from typing import Mapping

import numpy as np

from .templates import P1_DIMENSION_ITEMS

Q09_EXPECTED = 3
Q18_EXPECTED = 0
EXCLUSION_THRESHOLD = 2  # failures out of 3 (pre-registration, section 8)

PROOF_TYPES = ("ECD", "HEL", "G16", "PSS", "EGC")

# Domain code of each context, in the order C01..C10 (catalogue, section 2).
_DOMAINS = {
    "ECD": (1, 1, 1, 1, 1, 3, 3, 3, 2, 1),
    "HEL": (2,) * 10,
    "G16": (3, 3, 3, 3, 2, 1, 3, 3, 1, 3),
    "PSS": (1, 1, 1, 3, 3, 1, 4, 3, 1, 4),
    "EGC": (1, 1, 2, 2, 3, 3, 1, 2, 3, 4),
}
CATALOGUE_DOMAINS: dict[str, int] = {
    f"{t}-C{k + 1:02d}": d for t, doms in _DOMAINS.items() for k, d in enumerate(doms)
}

# Verdict-space template per domain: A acts (1, 4), B votes (2), C financial control (3).
VERDICT_SPACE = {1: "A", 2: "B", 3: "C", 4: "A"}


def expected_domain(stimulus_ids) -> np.ndarray:
    """Expected answer to Q28 for each stimulus id (KeyError if unknown)."""
    return np.asarray([CATALOGUE_DOMAINS[str(s)] for s in stimulus_ids], dtype=float)


def attention_failures(q09, q18, q28, stimulus_ids, missing_is_failure: bool = True) -> np.ndarray:
    """Number of failed attention checks (0 to 3) for each answered context.

    A missing answer to a check counts as a failure by default; the
    alternative (``missing_is_failure=False``) must be fixed before data
    collection [to be decided by the team].
    """
    q09 = np.asarray(q09, dtype=float)
    q18 = np.asarray(q18, dtype=float)
    q28 = np.asarray(q28, dtype=float)
    dom = expected_domain(stimulus_ids)
    if not (len(q09) == len(q18) == len(q28) == len(dom)):
        raise ValueError("columns must have the same length")
    fails = np.zeros(len(dom), dtype=int)
    for col, target in ((q09, Q09_EXPECTED), (q18, Q18_EXPECTED), (q28, dom)):
        missing = ~np.isfinite(col)
        wrong = np.where(missing, missing_is_failure, col != target)
        fails += wrong.astype(int)
    return fails


def excluded(failures) -> np.ndarray:
    """1 if the answer is excluded (at least 2 failed checks out of 3), else 0."""
    return (np.asarray(failures) >= EXCLUSION_THRESHOLD).astype(int)


def add_computed_columns(data: Mapping[str, np.ndarray], **kwargs) -> dict[str, np.ndarray]:
    """Return a copy of a ``p1_answers`` table with attention_failures and excluded filled."""
    out = dict(data)
    f = attention_failures(data["q09_attention"], data["q18_attention"], data["q28_attention"],
                           data["stimulus_id"], **kwargs)
    out["attention_failures"] = f.astype(float)
    out["excluded"] = excluded(f).astype(float)
    return out


def verdict_vector(data: Mapping[str, np.ndarray]) -> list[tuple]:
    """Verdict vector V = (Q01, Q02..Q25 without the two checks) as hashable labels.

    Missing answers are kept as NaN-free labels ``None`` so that the vector
    remains a valid discrete label; rows with missing answers should be
    handled according to the analysis plan before estimation.
    """
    cols = [data["verdict_v"]] + [data[q] for q in P1_DIMENSION_ITEMS]
    n = len(cols[0])

    def lab(x):
        return None if not np.isfinite(x) else int(x)

    return [tuple(lab(c[i]) for c in cols) for i in range(n)]


def rotation_blocks(list_number: int) -> dict[str, tuple[str, str]]:
    """Contexts assigned by rotation list r (1..5): block r for ECD, r+1 for HEL, ... mod 5."""
    if list_number not in range(1, 6):
        raise ValueError("rotation list must be in 1..5")
    out = {}
    for shift, t in enumerate(PROOF_TYPES):
        b = (list_number - 1 + shift) % 5  # block index 0..4
        out[t] = (f"{t}-C{2 * b + 1:02d}", f"{t}-C{2 * b + 2:02d}")
    return out
