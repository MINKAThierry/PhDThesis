> **Status: PROPOSAL. illustrative calibration** · Source: thesis, Chapter 4 (reference parameter table, retrospective calibration)

# Illustrative calibration and numerical checks

*Version française : [README_fr.md](README_fr.md)*

This folder recomputes every numerical value of Chapter 4. The values are illustrative calibration parameters, not measurements. The deployed systems (ECDSA, Helios, zk-SNARKs, ML-DSA) are not instances of the theorem. Their only role is to check that the chosen orders of magnitude are mutually consistent.

| Item | Contents |
|---|---|
| [python/cro/](python/cro/) | Trilemma bounds (explicit and refined forms), information quantities, SOTP heuristics, data loading |
| [python/validate_sotp.py](python/validate_sotp.py) | classical and post-quantum calibration |
| [python/sensitivity_eta_q.py](python/sensitivity_eta_q.py) | sensitivity to the coefficient η_q (hypothetical scenario of a quantum medium) |
| [python/verifications.py](python/verifications.py) | numerical checks quoted in the thesis |
| [data/](data/) | reference table and post-quantum calibration, schema in [SCHEMA_en.md](data/SCHEMA_en.md) |
| [results/](results/) | reference outputs and SHA-256 fingerprints |
| [tests/](tests/) | 17 tests recomputing the values of the thesis |

## Running

```sh
pip install --break-system-packages -r python/requirements.txt
./reproduire.sh --sans-lean      # Python only
./reproduire.sh                  # Python and Lean build (../05_formalisation_lean)
```

Run of 12 October 2026: 17 tests passed.
