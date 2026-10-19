"""Worked example of the analysis chain on SIMULATED data (notebook-like script).

Status: PROPOSAL, reference implementation. Every number printed below comes
from synthetic data produced by ``cro_terrain.simulate``; none is a field
measurement and none should be quoted as a result.

Run from the ``analyse`` folder:
    python exemple_analyse.py
Cells are separated by ``# %%`` so the script can be opened as a notebook.
"""

# %% Imports
import tempfile
from pathlib import Path

import numpy as np

from cro_terrain import bounds, information as inf, quantum, refutation, reliability, statistics
from cro_terrain.sampling import draw_sample, seed_from_parts
from cro_terrain.simulate import (ExtractionModel, HeliosModel, simulate_extraction,
                                  simulate_helios_audit)
from cro_terrain.templates import read_template, write_rows

RNG_SEED = 2026
TMP = Path(tempfile.mkdtemp(prefix="cro_terrain_"))
print(f"Temporary folder for simulated CSV files: {TMP}")


def show(title, value):
    print(f"  {title:<48} {value}")


# %% P3 - Helios post-election audit (thesis §4.2.3)
print("\n=== P3: Helios audit at ENSP (simulated) ===")
# 1. Reproducible sample of 50 proofs out of ~500 (10 %), seed published beforehand.
ballots = [f"B{i:03d}" for i in range(1, 501)]
seed = seed_from_parts("SIMULATED-bulletin-board-fingerprint", "31 07 19 88 42")
sample = draw_sample(ballots, 50, seed)
show("first three sampled proofs", [x for x, _ in sample[:3]])

# 2. Simulated audit: 10 trustees x 50 proofs, 20 % control proofs (proposal).
model = HeliosModel(n_proofs=50, control_fraction=0.2)
sim = simulate_helios_audit(model, n_trustees=10, seed=RNG_SEED, trustee_sd=0.3)
rows = [dict(zip(sim.keys(), vals)) for vals in zip(*sim.values())]
p3_csv = TMP / "audit_preuves_fr.csv"
write_rows(p3_csv, "p3_audit", "fr", rows)
audit = read_template(p3_csv, "p3_audit")          # same path as for field data
show("rows read back from the French template", len(audit["verdict"]))


# 3. Opp_emp = I(V;Sigma|C) / H(V|C), Sigma coded by the proof identifier.
#    With 50 proofs rated 10 times each, the Miller-Madow plug-in is strongly
#    biased upwards; the shuffle-corrected numerator is the proposed primary
#    estimator [to be decided by the team].
def opp_mm(d):
    return inf.opp_emp(d["verdict"], d["proof_id"], d["context_id"], method="mm", alphabet_size=4)


def opp_sc(d):
    return inf.opp_emp_shuffle(d["verdict"], d["proof_id"], d["context_id"], n_shuffle=20, seed=0,
                               alphabet_size=4)


show("true Opp of the simulation model", f"{model.truth()['opp']:.3f}")
show("Opp_emp, Miller-Madow plug-in (biased here)", f"{opp_mm(audit):.3f}")
b_proofs = statistics.cluster_bootstrap(audit, opp_sc, cluster="proof_id", n_boot=300, seed=1)
show("Opp_emp, shuffle-corrected", f"{b_proofs.estimate:.3f}")
show("95 % CI, bootstrap over the 50 proofs", f"[{b_proofs.low:.3f}, {b_proofs.high:.3f}]")
b_trust = statistics.cluster_bootstrap(audit, opp_sc, cluster="trustee_id", n_boot=300, seed=2)
show("95 % CI, bootstrap over the 10 trustees (thesis)", f"[{b_trust.low:.3f}, {b_trust.high:.3f}]")
show("robustness: Sigma coded by status (lower bound)",
     f"{inf.opp_emp(audit['verdict'], audit['reference_status'], method='mm', alphabet_size=4):.3f}")
dec = refutation.criterion_opp_helios(b_proofs.estimate, (b_proofs.low, b_proofs.high))
show("decision against Opp_predicted = 0.50", dec.detail)

# %% P4 - joint estimation of Delta and alpha (thesis §4.2.4)
print("\n=== P4: joint estimation of Delta and alpha (simulated) ===")
ext_model = ExtractionModel(k_messages=4, n_variants=2, n_verdicts=4, n_contexts=2,
                            leak=0.6, rho_s=0.5, noise=0.1)
ext = simulate_extraction(ext_model, n_participants=30, items_per_participant=60, seed=RNG_SEED,
                          participant_sd=0.3)


def delta_stat(d):
    return inf.delta_hat(d["verdict"], d["sigma_code"], d["message_m"], d["context_id"],
                         method="mm", alphabet_size=4)


perm = statistics.admissibility_permutation_test(ext["verdict"], ext["message_m"], ext["sigma_code"],
                                                 ext["context_id"], n_perm=499, seed=2)
show("admissibility test: I(V;M|Sigma,C), p-value", f"{perm.statistic:.4f}, p = {perm.p_value:.3f}")
b_delta = statistics.cluster_bootstrap(ext, delta_stat, "participant_id", n_boot=500, seed=3)
show("Delta_hat = I(V;Sigma|M,C) [bits]", f"{b_delta.estimate:.3f}  CI [{b_delta.low:.3f}, {b_delta.high:.3f}]")
show("true Delta of the simulation model [bits]", f"{ext_model.truth()['delta']:.3f}")
H_C = 8.0  # case-scale context entropy supplied by P2 (here an arbitrary simulated value)
show("alpha_hat = log2|V| / H(C)", f"{inf.alpha_hat(4, H_C):.3f}")

# Test-retest on 3 contexts after two weeks: simulated confidence scores.
rng = np.random.default_rng(RNG_SEED)
t1 = rng.integers(3, 11, size=30).astype(float)
t2 = np.clip(t1 + rng.normal(0, 0.8, size=30), 0, 10)
icc = reliability.icc_2_1(np.column_stack([t1, t2]))
# Inter-rater agreement: two participants of the same profile on 60 shared items.
a = ext["verdict"][:60]
b = np.where(rng.random(60) < 0.85, a, rng.choice(["1", "2", "3", "4"], 60))
kap = reliability.cohen_kappa(a, b)
for name, r in reliability.reliability_verdict(icc=icc, kappa=kap).items():
    show(f"{name} (threshold {r['threshold']})", f"{r['value']:.3f} satisfied={r['satisfied']}")

# %% P5 - Delta_q under the four noise conditions (thesis §4.2.5)
print("\n=== P5: Delta_q under conditions A-D (simulated, hypothetical quantum medium) ===")
conditions = {"A": 0.0, "B": 0.001, "C": 0.01, "D": 0.1}
dq = {}
for cond, p in conditions.items():
    # toy mapping: the simulated quantum noise adds verdict noise proportional to p
    m = ExtractionModel(leak=0.6, rho_s=0.5, noise=min(0.1 + 4 * p, 1.0))
    d = simulate_extraction(m, 80, 30, seed=RNG_SEED + int(1000 * p))
    dq[cond] = inf.delta_hat(d["verdict"], d["sigma_code"], d["message_m"], d["context_id"],
                             method="mm", alphabet_size=4)
    show(f"condition {cond} (p = {p})", f"Delta_q_hat = {dq[cond]:.3f} bits")
a0, slope = statistics.ols_slope(list(conditions.values()), list(dq.values()))
show("slope of Delta_q_hat on p", f"{slope:.3f} bits per unit of p")

# %% P6 - eta_q by simulation of quantum channels (thesis §4.2.6)
print("\n=== P6: eta_q, toy classical-quantum model (hypothetical scenario) ===")
cq = quantum.CQModel(n_qubits=3, n_verdicts=4, n_contexts=2, verdict_noise=0.1, basis="conjugate")
H_C_ETA = 10.5  # ML-DSA-65 case-scale value of tab:parametres_reference, used as an example
for ch, rng_ in [("depolarizing", [0.001, 0.01, 0.1]), ("dephasing", [0.001, 0.01, 0.05]),
                 ("amplitude_damping", [0.001, 0.01, 0.02])]:
    res = quantum.eta_sweep(cq, ch, rng_, H_C_ETA)
    show(ch, ", ".join(f"p={r.param}: eta={r.eta_hat:.4f}" for r in res))
ctrl = quantum.estimate_eta(cq, "depolarizing", 0.1, H_C_ETA, bitstring_control=True)
show("negative control (bit string): eta_hat", f"{ctrl.eta_hat:.2e}")

# %% P7 - confrontation with the refined bound and refutation criteria (thesis §4.2.7)
print("\n=== P7: confrontation with the refined bounds (illustrative inputs) ===")
rep = bounds.report_classical(lam=128, kappa=1, delta=5, alpha=1.0, h_c=20)
show("classical: gamma, H_sharp, binding", f"{rep.gamma:.1f}, {rep.h_threshold:.2f}, {rep.binding}")
show("classical refined bound", f"{rep.bound:.6f}")
rep_q = bounds.report_pq(lam=192, kappa=1, delta_q=10, theta_q=0.5, alpha_q=1.0, h_c=40)
show("PQ: gamma_q, H_sharp_q, binding", f"{rep_q.gamma:.1f}, {rep_q.h_threshold:.2f}, {rep_q.binding}")
show("PQ refined bound", f"{rep_q.bound:.6f}")
decisions = refutation.apply_criteria({
    "delta_ci_low": b_delta.low, "delta_prereg": 1.0,
    "admissibility_p": perm.p_value, "admissibility_informative_strata": perm.n_informative_strata,
    "h_v_c_ci_high": 2.0, "alpha": 1.0, "h_c": 20,
    "eta_ci": (0.02, 0.04), "eta_predicted": (0.05, 0.15),
    "product_ci_low": 0.0015, "hypotheses_verified": False, "lam": 128, "kappa": 1, "capacity": 5,
})
for d in decisions:
    show(d.criterion, f"{d.status}: {d.detail}")
print("\nReminder: simulated data only; no protocol has been deployed.")
