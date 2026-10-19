"""P6 (eta_q, hypothetical quantum medium): summary of simulation runs, predictions.

Status: PROPOSAL, reference implementation for thesis Chapter 4, section 4.2.6.
The simulation itself is ``cro_terrain.quantum`` (toy classical-quantum
model, ``run_plan``); this module reads the resulting ``p6_simulation`` table.

* eta_q_hat per run is Delta I / H(C) (eq:estimateur_eta_q, regression model
  Delta I = eta_q H(C) of phase 3).
* ``summarize`` groups runs by (channel, encoding, n_qubits, H(C)) and fits
  the slope of eta_q_hat on the noise parameter (prediction 3).
* ``afw_bound`` gives the Alicki-Fannes-Winter continuity bound used as a
  heuristic comparison (prediction 2).
* ``eta_ceiling`` makes explicit a structural limit: since
  0 <= I(V ; Lambda(Sigma) | C) <= I(V ; Sigma | C) <= log2 |V|,
  one always has eta_q_hat <= I(V ; Sigma | C) / H(C) <= log2 |V| / H(C).
"""

from __future__ import annotations

from collections import defaultdict
from typing import Mapping, Sequence

import numpy as np

from .statistics import ols_slope

PREDICTED_NISQ = (0.05, 0.15)  # prediction 1, thesis section 4.2.6.6
CONTROL_TOLERANCE = 1e-9       # deterministic toy model: eta must be 0 for the bit-string control


def h2(x: float) -> float:
    """Binary entropy in bits."""
    if x <= 0 or x >= 1:
        return 0.0
    return float(-x * np.log2(x) - (1 - x) * np.log2(1 - x))


def afw_bound(eps: float, d_v: int) -> float:
    """Alicki-Fannes-Winter bound on |I(V;B|C)_rho - I(V;B|C)_sigma| in bits,
    for eps = (1/2)||rho - sigma||_1 and a classical register V of dimension d_v:
    2 eps log2 d_v + 2 (1 + eps) h2(eps / (1 + eps))."""
    if not 0 <= eps <= 1:
        raise ValueError("eps must lie in [0, 1]")
    return 2 * eps * np.log2(d_v) + 2 * (1 + eps) * h2(eps / (1 + eps))


def eta_ceiling(i_before: float, h_c: float) -> float:
    """Largest eta_q_hat attainable when all the information is lost: I(V;Sigma|C) / H(C)."""
    if h_c <= 0:
        raise ValueError("H(C) must be positive")
    return i_before / h_c


def summarize(data: Mapping[str, Sequence], d_v: int = 4) -> list[dict]:
    """One summary per (channel, encoding, n_qubits, H(C)) group of a ``p6_simulation`` table."""
    groups = defaultdict(list)
    keys = ("channel", "encoding", "n_qubits", "h_c")
    n = len(data["run_id"])
    for i in range(n):
        groups[tuple(str(data[k][i]) for k in keys)].append(i)
    out = []
    for g, idx in sorted(groups.items()):
        p = np.asarray([float(data["noise_param"][i]) for i in idx])
        eta = np.asarray([float(data["eta_hat"][i]) for i in idx])
        di = np.asarray([float(data["delta_i"][i]) for i in idx])
        td = np.asarray([float(data["trace_distance"][i]) for i in idx])
        i0 = np.asarray([float(data["i_before"][i]) for i in idx])
        order = np.argsort(p)
        p, eta, di, td, i0 = p[order], eta[order], di[order], td[order], i0[order]
        slope = ols_slope(p, eta)[1] if len(set(p)) > 1 else float("nan")
        afw = np.asarray([afw_bound(min(t, 1.0), d_v) for t in td])
        out.append({
            "channel": g[0], "encoding": g[1], "n_qubits": int(float(g[2])), "h_c": float(g[3]),
            "params": p.tolist(), "eta": eta.tolist(), "eta_max": float(eta.max()),
            "slope_eta_per_unit_param": float(slope),
            "monotone_increasing": bool(np.all(np.diff(eta) >= -1e-12)),
            "eta_ceiling": float(eta_ceiling(float(i0.max()), float(g[3]))),
            "within_afw": bool(np.all(di <= afw + 1e-9)),
        })
    return out


def check_predictions(summary: Sequence[dict], predicted: tuple = PREDICTED_NISQ) -> dict:
    """Descriptive reading of predictions 1 to 4 of section 4.2.6.6 on a simulation summary."""
    quantum = [s for s in summary if s["encoding"] == "quantum"]
    control = [s for s in summary if s["encoding"] == "bitstring"]
    combined = [s for s in quantum if s["channel"] == "combined"]
    lo, hi = predicted
    res = {
        "1_combined_in_predicted_range": (None if not combined else
                                          all(lo <= s["eta_max"] <= hi for s in combined)),
        "1_predicted_range_reachable": (None if not combined else
                                        all(s["eta_ceiling"] >= lo for s in combined)),
        "2_within_afw_heuristic": all(s["within_afw"] for s in quantum) if quantum else None,
        "3_increasing_in_noise": (all(s["monotone_increasing"] and s["slope_eta_per_unit_param"] > 0
                                      for s in quantum if s["channel"] != "identity")
                                  if quantum else None),
        "4_negative_control_zero": (all(max(abs(e) for e in s["eta"]) <= CONTROL_TOLERANCE
                                        for s in control) if control else None),
    }
    return res
