"""P7: combined post-quantum validation, algorithm alg:protocole_combine.

Status: PROPOSAL, reference implementation for thesis Chapter 4, section 4.2.7,
for a protocol that has not been deployed.

    Part A  Delta_q_hat without noise (from P5, condition A)
    Part B  eta_q_hat by regression on channel intensity (from P6 or P5 phase 2)
    Part C  check the hypotheses of the CRO^q theorem; only if they hold,
            compare Conf^q Rel^q Opp^q with the refined bound eq:trilemme_pq_raffine
    Part D  cross-validation: prediction versus measurement per standard,
            relative error and confidence intervals

The algorithm lists beta_q_hat among its outputs. Regularity (ass:regularite_quantique)
is a property of the protocol states rho_Sigma^{m,c}, not of the participants'
answers; ``beta_q_min`` computes, for given states, the smallest beta_q
compatible with zeta_q = 0. For a signature, distinct messages give states with
disjoint supports, D = +inf and the protocol is not quantum-regular: this is the
expected outcome for ML-DSA and SLH-DSA (rem:portee_cas_etude).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Mapping, Sequence

import numpy as np

from .bounds import borne_raffinee_pq, gamma_pq
from .refutation import (criterion_admissibility, criterion_bound, criterion_delta,
                         criterion_eta_q, NOT_PROBATIVE)

LAMBDA_MIN = 64


# ---------------------------------------------------------------------------
# Quantum relative entropy and regularity (Part C, ass:regularite_quantique)
# ---------------------------------------------------------------------------

def relative_entropy(rho: np.ndarray, sigma: np.ndarray, tol: float = 1e-12) -> float:
    """Umegaki relative entropy D(rho || sigma) in bits; +inf if supp(rho) is not in supp(sigma)."""
    rho = (rho + rho.conj().T) / 2
    wr, ur = np.linalg.eigh(rho)
    ws, us = np.linalg.eigh((sigma + sigma.conj().T) / 2)
    ker = us[:, ws <= tol]
    if ker.size and float(np.real(np.trace(ker.conj().T @ rho @ ker))) > 1e-9:
        return float("inf")
    log_r = (ur * np.log2(np.clip(wr, tol, None))) @ ur.conj().T
    pos = ws > tol
    log_s = (us[:, pos] * np.log2(ws[pos])) @ us[:, pos].conj().T
    return float(np.real(np.trace(rho @ (log_r - log_s))))


def _entropy(rho: np.ndarray) -> float:
    w = np.linalg.eigvalsh((rho + rho.conj().T) / 2)
    w = w[w > 1e-14]
    return float(-np.sum(w * np.log2(w)))


def holevo_chi(probs: Sequence[float], states: Sequence[np.ndarray]) -> float:
    avg = sum(p * s for p, s in zip(probs, states))
    return _entropy(avg) - float(sum(p * _entropy(s) for p, s in zip(probs, states)))


def beta_q_min(ensembles: Mapping[str, tuple[Sequence[float], Sequence[np.ndarray]]]) -> dict:
    """Smallest beta_q with zeta_q = 0 such that, for every context c and pair (m0, m1),
    D(rho^{m0,c} || rho^{m1,c}) <= beta_q chi(E_{m,c}).

    ``ensembles`` maps a context to (p(m|c), [rho_Sigma^{m,c}]). Returns
    beta_q (possibly +inf), chi_max and the worst context.
    """
    beta, chi_max, worst = 0.0, 0.0, None
    for c, (probs, states) in ensembles.items():
        chi = holevo_chi(probs, states)
        chi_max = max(chi_max, chi)
        for a in range(len(states)):
            for b in range(len(states)):
                if a == b:
                    continue
                d = relative_entropy(states[a], states[b])
                if d == 0:
                    continue
                r = float("inf") if (np.isinf(d) or chi <= 1e-15) else d / chi
                if r > beta:
                    beta, worst = r, c
    return {"beta_q": max(beta, 1.0) if np.isfinite(beta) else float("inf"),
            "chi_max": chi_max, "worst_context": worst}


# ---------------------------------------------------------------------------
# Part C: hypotheses of the CRO^q theorem
# ---------------------------------------------------------------------------

@dataclass
class Hypotheses:
    """Inputs for ass:extraction_quantique, ass:verdict_quantique,
    ass:regularite_quantique, ass:regime_quantique and admissibility."""
    lam: float
    kappa: float
    delta_q_ci_low: float          # lower CI bound of I(V;Sigma|M,C)
    delta_q_prereg: float          # capacity registered before the experiment
    admissibility_p: float
    admissibility_informative_strata: int
    log2_verdicts: float           # log2 k_lambda
    alpha_q: float
    theta_q: float
    h_c: float
    h_v_c_ci: tuple[float, float]  # CI of H(V|C)
    beta_q: float                  # from beta_q_min or the protocol analysis
    chi_max: float                 # max_c chi(E_{m,c})
    checks: dict = field(default_factory=dict)

    def evaluate(self) -> dict:
        g = gamma_pq(self.theta_q, self.alpha_q, self.h_c)
        c = {}
        c["lambda_ge_64"] = self.lam >= LAMBDA_MIN
        c["H1q_extraction"] = criterion_delta(self.delta_q_ci_low, self.delta_q_prereg).status == "not_refuted"
        adm = criterion_admissibility(self.admissibility_p, self.admissibility_informative_strata)
        c["admissibility"] = adm.status == "not_refuted"
        c["H2q_verdict_space"] = self.log2_verdicts <= self.alpha_q * self.h_c + 1e-12
        c["H2q_gamma_q_ge_1"] = g >= 1
        c["H2q_efficient_verdict"] = self.h_v_c_ci[1] >= g  # not refuted at 95 %
        c["H3q_regularity"] = bool(np.isfinite(self.beta_q) and self.beta_q >= 1)
        c["H4q_regime"] = self.chi_max <= self.kappa / self.lam
        self.checks = c
        return c

    def all_hold(self) -> bool:
        return all((self.checks or self.evaluate()).values())


# ---------------------------------------------------------------------------
# Part D: prediction versus measurement
# ---------------------------------------------------------------------------

def relative_error(predicted: float, measured: float) -> float:
    if predicted == 0:
        return float("inf") if measured != 0 else 0.0
    return (measured - predicted) / abs(predicted)


def cross_validation(rows: Sequence[Mapping]) -> list[dict]:
    """``rows``: dicts with standard, parameter, predicted, measured, ci_low, ci_high.
    Adds relative_error and whether the prediction lies in the CI."""
    out = []
    for r in rows:
        lo, hi = r.get("ci_low", np.nan), r.get("ci_high", np.nan)
        inside = bool(np.isfinite(lo) and np.isfinite(hi) and lo <= r["predicted"] <= hi)
        out.append(dict(r, relative_error=relative_error(r["predicted"], r["measured"]),
                        prediction_in_ci=inside))
    return out


# ---------------------------------------------------------------------------
# Whole algorithm
# ---------------------------------------------------------------------------

def protocole_combine(*, hyp: Hypotheses, eta_ci: tuple[float, float],
                      eta_predicted: tuple[float, float], product_ci_low: float | None,
                      cross_rows: Sequence[Mapping] = ()) -> dict:
    """Parts A to D. Part C compares with the refined bound only if all hypotheses hold."""
    checks = hyp.evaluate()
    report = {"A_delta_q": {"ci_low": hyp.delta_q_ci_low, "prereg": hyp.delta_q_prereg,
                            "decision": criterion_delta(hyp.delta_q_ci_low, hyp.delta_q_prereg).status},
              "B_eta_q": {"ci": eta_ci, "predicted": eta_predicted,
                          "decision": criterion_eta_q(eta_ci, eta_predicted).status}}
    if hyp.all_hold() and product_ci_low is not None:
        b = borne_raffinee_pq(hyp.lam, hyp.kappa, hyp.delta_q_prereg, hyp.theta_q, hyp.alpha_q,
                              hyp.h_c)
        dec = criterion_bound(product_ci_low, b, True)
        report["C_bound"] = {"hypotheses": checks, "bound": b, "decision": dec.status}
    else:
        failed = [k for k, v in checks.items() if not v]
        report["C_bound"] = {"hypotheses": checks, "bound": None, "decision": NOT_PROBATIVE,
                             "reason": "hypotheses not satisfied: " + ", ".join(failed)
                             if failed else "no measured product"}
    report["D_cross_validation"] = cross_validation(cross_rows)
    return report
