"""Toy classical-quantum simulator for the eta_q protocol (P6).

SCOPE. ML-DSA, SLH-DSA and Falcon signatures are classical bit strings, for
which eta_q = 0 (thesis rem:interpretation_physique_pq). This module only
serves the *hypothetical* scenario of a quantum storage or verification medium
(thesis §4.2.6). Values it produces are properties of the toy model, not
predictions about any deployed system.

Definition used (thesis def:perte_interp_quantique_pq, eq:eta_q_definition):
eta_q is the smallest real such that

    I(V ; Lambda(Sigma) | C) >= I(V ; Sigma | C) - eta_q H(C),

hence the estimator (eq:estimateur_eta_q)

    eta_q_hat = [ I(V ; Sigma | C) - I(V ; Lambda(Sigma) | C) ] / H(C).

Model. A proof is an n-bit string b, encoded on n qubits (basis "Z",
"X" or "conjugate" = alternating Z/X). For each context c, the verdict V is
correlated with b through a rule with error rate ``verdict_noise``. The
classical-quantum state is rho_{V Sigma | c} = sum_v p(v|c) |v><v| (x) rho_{v,c}
and I(V ; Sigma | C) = sum_c p(c) chi({p(v|c), rho_{v,c}}) (Holevo quantity).
H(C) in the estimator is the *institutional* context entropy supplied by the
protocol (e.g. 10.5 or 20 bits, thesis tab:parametres_reference), not the
entropy of the few simulated contexts.
"""

from __future__ import annotations

from dataclasses import dataclass
from functools import reduce
from itertools import product
from typing import Callable, Sequence

import numpy as np

I2 = np.eye(2, dtype=complex)
X = np.array([[0, 1], [1, 0]], dtype=complex)
Y = np.array([[0, -1j], [1j, 0]], dtype=complex)
Z = np.array([[1, 0], [0, -1]], dtype=complex)

CHANNELS = ("depolarizing", "dephasing", "amplitude_damping", "combined", "identity")


# ---------------------------------------------------------------------------
# Linear algebra helpers
# ---------------------------------------------------------------------------

def von_neumann_entropy(rho: np.ndarray) -> float:
    """S(rho) in bits."""
    w = np.linalg.eigvalsh((rho + rho.conj().T) / 2)
    w = w[w > 1e-14]
    return float(-np.sum(w * np.log2(w)))


def _psd_sqrt(rho: np.ndarray) -> np.ndarray:
    w, u = np.linalg.eigh((rho + rho.conj().T) / 2)
    w = np.clip(w, 0, None)
    return (u * np.sqrt(w)) @ u.conj().T


def fidelity(rho: np.ndarray, sigma: np.ndarray) -> float:
    """Uhlmann fidelity F(rho, sigma) = (tr sqrt(sqrt(rho) sigma sqrt(rho)))^2."""
    s = _psd_sqrt(rho)
    m = s @ sigma @ s
    w = np.clip(np.linalg.eigvalsh((m + m.conj().T) / 2), 0, None)
    return float(np.sum(np.sqrt(w)) ** 2)


def trace_distance(rho: np.ndarray, sigma: np.ndarray) -> float:
    """(1/2) || rho - sigma ||_1."""
    w = np.linalg.eigvalsh(((rho - sigma) + (rho - sigma).conj().T) / 2)
    return float(0.5 * np.sum(np.abs(w)))


def _kron_all(ops: Sequence[np.ndarray]) -> np.ndarray:
    return reduce(np.kron, ops)


def _apply_local_kraus(rho: np.ndarray, kraus: Sequence[np.ndarray], n_qubits: int) -> np.ndarray:
    """Apply the same single-qubit channel independently to every qubit."""
    for q in range(n_qubits):
        out = np.zeros_like(rho)
        for k in kraus:
            ops = [I2] * n_qubits
            ops[q] = k
            K = _kron_all(ops)
            out = out + K @ rho @ K.conj().T
        rho = out
    return rho


# ---------------------------------------------------------------------------
# Channels (thesis subsubsec:modeles_canaux)
# ---------------------------------------------------------------------------

def depolarizing(rho: np.ndarray, p: float) -> np.ndarray:
    """Global depolarizing channel (1-p) rho + p I/d (eq:canal_depolarisant_op)."""
    d = rho.shape[0]
    return (1 - p) * rho + p * np.eye(d, dtype=complex) / d


def dephasing(rho: np.ndarray, p: float, n_qubits: int) -> np.ndarray:
    """Local dephasing (1-p) rho + p Z rho Z on each qubit (def:canal_dephasage)."""
    kraus = [np.sqrt(1 - p) * I2, np.sqrt(p) * Z]
    return _apply_local_kraus(rho, kraus, n_qubits)


def amplitude_damping(rho: np.ndarray, g: float, n_qubits: int) -> np.ndarray:
    """Local amplitude damping with parameter g on each qubit (def:canal_amortissement)."""
    e0 = np.array([[1, 0], [0, np.sqrt(1 - g)]], dtype=complex)
    e1 = np.array([[0, np.sqrt(g)], [0, 0]], dtype=complex)
    return _apply_local_kraus(rho, [e0, e1], n_qubits)


def make_channel(name: str, param: float, n_qubits: int,
                 combined: dict | None = None) -> Callable[[np.ndarray], np.ndarray]:
    """Return rho -> Lambda(rho).

    ``combined`` (for name == "combined") gives the three parameters
    {"p_dep", "p_deph", "g_ad"}; ``param`` then scales them jointly
    (param = 1 uses them as given). The composition order
    (amplitude damping, then dephasing, then depolarizing) is a proposal
    [to be decided by the team].
    """
    if name == "identity":
        return lambda r: r
    if name == "depolarizing":
        return lambda r: depolarizing(r, param)
    if name == "dephasing":
        return lambda r: dephasing(r, param, n_qubits)
    if name == "amplitude_damping":
        return lambda r: amplitude_damping(r, param, n_qubits)
    if name == "combined":
        c = combined or {"p_dep": 0.01, "p_deph": 0.01, "g_ad": 0.005}
        return lambda r: depolarizing(
            dephasing(amplitude_damping(r, param * c["g_ad"], n_qubits), param * c["p_deph"], n_qubits),
            param * c["p_dep"])
    raise ValueError(f"unknown channel {name!r}; expected one of {CHANNELS}")


# ---------------------------------------------------------------------------
# Classical-quantum model
# ---------------------------------------------------------------------------

def encode_bitstring(bits: Sequence[int], basis: str = "conjugate") -> np.ndarray:
    """Density matrix of the product encoding of ``bits``."""
    plus = np.array([1, 1], dtype=complex) / np.sqrt(2)
    minus = np.array([1, -1], dtype=complex) / np.sqrt(2)
    zero = np.array([1, 0], dtype=complex)
    one = np.array([0, 1], dtype=complex)
    vecs = []
    for i, b in enumerate(bits):
        use_x = basis == "X" or (basis == "conjugate" and i % 2 == 1)
        if basis not in ("Z", "X", "conjugate"):
            raise ValueError("basis must be 'Z', 'X' or 'conjugate'")
        vecs.append((minus if b else plus) if use_x else (one if b else zero))
    psi = _kron_all(vecs)
    return np.outer(psi, psi.conj())


@dataclass
class CQModel:
    n_qubits: int = 3
    n_verdicts: int = 4
    n_contexts: int = 2
    verdict_noise: float = 0.1
    basis: str = "conjugate"

    def bitstrings(self):
        return list(product([0, 1], repeat=self.n_qubits))

    def rule(self, bits, c) -> int:
        """Deterministic part of the verdict: value of the leading bits, shifted by context."""
        k = int(np.ceil(np.log2(self.n_verdicts)))
        val = int("".join(str(b) for b in bits[:k]), 2) if k > 0 else 0
        return (val + c) % self.n_verdicts

    def p_v_given_b_c(self, bits, c) -> np.ndarray:
        p = np.full(self.n_verdicts, self.verdict_noise / self.n_verdicts)
        p[self.rule(bits, c)] += 1 - self.verdict_noise
        return p

    def conditional_states(self, c: int):
        """Return p(v|c) and the list of rho_{v,c} (proof states given verdict)."""
        bs = self.bitstrings()
        pb = 1.0 / len(bs)
        d = 2 ** self.n_qubits
        pv = np.zeros(self.n_verdicts)
        rhos = [np.zeros((d, d), dtype=complex) for _ in range(self.n_verdicts)]
        for b in bs:
            rho_b = encode_bitstring(b, self.basis)
            pvb = self.p_v_given_b_c(b, c)
            for v in range(self.n_verdicts):
                w = pb * pvb[v]
                pv[v] += w
                rhos[v] += w * rho_b
        rhos = [r / pv[v] if pv[v] > 0 else r for v, r in enumerate(rhos)]
        return pv, rhos


def holevo(pv: np.ndarray, rhos: Sequence[np.ndarray]) -> float:
    avg = sum(p * r for p, r in zip(pv, rhos))
    return von_neumann_entropy(avg) - float(sum(p * von_neumann_entropy(r) for p, r in zip(pv, rhos)))


def conditional_holevo_information(model: CQModel,
                                   channel: Callable[[np.ndarray], np.ndarray] | None = None) -> float:
    """I(V ; Lambda(Sigma) | C) for the model (contexts equiprobable)."""
    total = 0.0
    for c in range(model.n_contexts):
        pv, rhos = model.conditional_states(c)
        if channel is not None:
            rhos = [channel(r) for r in rhos]
        total += holevo(pv, rhos) / model.n_contexts
    return total


@dataclass
class EtaResult:
    channel: str
    param: float
    encoding: str           # "quantum" or "bitstring" (negative control)
    h_c: float
    i_before: float
    i_after: float
    delta_i: float
    eta_hat: float
    fidelity_avg: float
    trace_distance_avg: float


def estimate_eta(model: CQModel, channel_name: str, param: float, h_c: float,
                 bitstring_control: bool = False, combined: dict | None = None) -> EtaResult:
    """eta_q_hat for one channel and one noise level.

    With ``bitstring_control=True`` the proof is read and copied as a
    classical bit string, so Lambda is the identity and eta_q_hat must be 0
    (thesis §4.2.6.6, prediction 4, negative control).
    """
    if h_c <= 0:
        raise ValueError("H(C) must be positive")
    name = "identity" if bitstring_control else channel_name
    lam = make_channel(name, param, model.n_qubits, combined)
    i0 = conditional_holevo_information(model, None)
    i1 = conditional_holevo_information(model, lam)
    fids, tds = [], []
    for b in model.bitstrings():
        r = encode_bitstring(b, model.basis)
        lr = lam(r)
        fids.append(fidelity(r, lr))
        tds.append(trace_distance(r, lr))
    di = i0 - i1
    return EtaResult(channel_name, param, "bitstring" if bitstring_control else "quantum", h_c,
                     i0, i1, di, di / h_c, float(np.mean(fids)), float(np.mean(tds)))


def eta_sweep(model: CQModel, channel_name: str, params: Sequence[float], h_c: float,
              bitstring_control: bool = False, combined: dict | None = None) -> list[EtaResult]:
    return [estimate_eta(model, channel_name, p, h_c, bitstring_control, combined) for p in params]


# Parameter ranges of thesis tab:val_canaux_quantiques (tested range, expected eta_q)
THESIS_CHANNEL_TABLE = {
    "depolarizing": {"range": (0.001, 0.1), "expected_eta": (0.02, 0.20)},
    "dephasing": {"range": (0.001, 0.05), "expected_eta": (0.01, 0.10)},
    "amplitude_damping": {"range": (0.001, 0.02), "expected_eta": (0.005, 0.05)},
    "combined": {"range": None, "expected_eta": (0.05, 0.15)},
}


# ---------------------------------------------------------------------------
# Default simulation plan of P6 (P6_eta_q/plan_simulation_canaux)
# ---------------------------------------------------------------------------

DEFAULT_PLAN = {
    "depolarizing": [0.0, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1],
    "dephasing": [0.0, 0.001, 0.002, 0.005, 0.01, 0.02, 0.05],
    "amplitude_damping": [0.0, 0.001, 0.002, 0.005, 0.01, 0.02],
    "combined": [0.0, 0.25, 0.5, 1.0],
}


def run_plan(out_csv: str, lang: str = "fr", h_c_values=(10.5, 20.0), n_qubits_values=(2, 3),
             bases=("conjugate",), verdict_noise: float = 0.1, proof_type: str = "toy-cq") -> int:
    """Run the default plan and write the P6 CSV template (French or English
    header). Returns the number of rows written. The model is deterministic,
    so the 'seed' column only records the plan version."""
    from .templates import write_rows

    rows = []
    run = 0
    for nq in n_qubits_values:
        for basis in bases:
            model = CQModel(n_qubits=nq, n_verdicts=4, n_contexts=2, verdict_noise=verdict_noise,
                            basis=basis)
            for h_c in h_c_values:
                for ch, params in DEFAULT_PLAN.items():
                    for control in (False, True):
                        for p in params:
                            r = estimate_eta(model, ch, p, h_c, bitstring_control=control)
                            run += 1
                            rows.append({
                                "run_id": f"R{run:04d}", "seed": "plan-v0.1", "channel": ch,
                                "noise_param": p, "proof_type": proof_type, "encoding": r.encoding,
                                "n_qubits": nq, "h_c": h_c, "i_before": f"{r.i_before:.6f}",
                                "i_after": f"{r.i_after:.6f}", "delta_i": f"{r.delta_i:.6f}",
                                "eta_hat": f"{r.eta_hat:.6f}", "fidelity_avg": f"{r.fidelity_avg:.6f}",
                                "trace_distance": f"{r.trace_distance_avg:.6f}",
                                "notes": f"basis={basis}; verdict_noise={verdict_noise}",
                            })
    write_rows(out_csv, "p6_simulation", lang, rows)
    return len(rows)


if __name__ == "__main__":
    import argparse

    ap = argparse.ArgumentParser(description="Run the default eta_q simulation plan (protocol P6)")
    ap.add_argument("--out", required=True, help="output CSV path")
    ap.add_argument("--lang", choices=["fr", "en"], default="fr")
    a = ap.parse_args()
    n = run_plan(a.out, a.lang)
    print(f"{n} rows written to {a.out}")
