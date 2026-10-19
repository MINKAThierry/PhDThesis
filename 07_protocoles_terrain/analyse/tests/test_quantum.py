"""Toy eta_q simulator (hypothetical quantum-medium scenario only)."""

import numpy as np
import pytest

from cro_terrain.quantum import (CQModel, amplitude_damping, dephasing, depolarizing, encode_bitstring,
                                 estimate_eta, eta_sweep, fidelity, trace_distance, von_neumann_entropy)
from cro_terrain.statistics import slope_through_origin


def test_channels_are_trace_preserving():
    rho = encode_bitstring((0, 1, 1), "conjugate")
    for out in (depolarizing(rho, 0.1), dephasing(rho, 0.05, 3), amplitude_damping(rho, 0.02, 3)):
        assert np.trace(out).real == pytest.approx(1.0)
        assert np.min(np.linalg.eigvalsh(out)) > -1e-12


def test_entropy_fidelity_trace_distance():
    rho = encode_bitstring((1, 0), "Z")
    assert von_neumann_entropy(rho) == pytest.approx(0.0, abs=1e-9)
    assert von_neumann_entropy(np.eye(4) / 4) == pytest.approx(2.0)
    assert fidelity(rho, rho) == pytest.approx(1.0)
    sigma = depolarizing(rho, 0.2)
    assert 0 <= trace_distance(rho, sigma) <= np.sqrt(1 - fidelity(rho, sigma)) + 1e-9


@pytest.mark.parametrize("channel", ["depolarizing", "dephasing", "amplitude_damping"])
def test_negative_control_bitstring_gives_zero(channel):
    res = estimate_eta(CQModel(), channel, 0.05, h_c=10.5, bitstring_control=True)
    assert res.eta_hat == pytest.approx(0.0, abs=1e-12)
    assert res.encoding == "bitstring"


@pytest.mark.parametrize("channel,params", [
    ("depolarizing", [0.001, 0.01, 0.05, 0.1]),
    ("dephasing", [0.001, 0.01, 0.03, 0.05]),
    ("amplitude_damping", [0.001, 0.005, 0.01, 0.02]),
])
def test_eta_increasing_and_nearly_linear_at_low_noise(channel, params):
    res = eta_sweep(CQModel(), channel, [0.0] + params, h_c=10.5)
    etas = [r.eta_hat for r in res]
    assert etas[0] == pytest.approx(0.0, abs=1e-12)
    assert all(b > a for a, b in zip(etas, etas[1:]))
    # near-linearity between the two lowest levels (thesis prediction 3)
    assert etas[2] / etas[1] == pytest.approx(params[1] / params[0], rel=0.25)
    assert slope_through_origin(params, etas[1:]) > 0


def test_dephasing_does_not_affect_computational_basis_encoding():
    res = estimate_eta(CQModel(basis="Z"), "dephasing", 0.05, h_c=10.5)
    assert res.eta_hat == pytest.approx(0.0, abs=1e-10)


def test_combined_channel_runs():
    res = estimate_eta(CQModel(), "combined", 1.0, h_c=10.5)
    assert res.eta_hat > 0


def test_run_plan_writes_readable_template(tmp_path):
    from cro_terrain.quantum import run_plan
    from cro_terrain.templates import read_template

    out = tmp_path / "plan.csv"
    n = run_plan(str(out), lang="en", h_c_values=(10.5,), n_qubits_values=(2,))
    d = read_template(out, "p6_simulation")
    assert len(d["eta_hat"]) == n
    ctrl = d["encoding"] == "bitstring"
    assert np.allclose(d["eta_hat"][ctrl], 0.0)
