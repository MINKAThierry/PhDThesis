> **Status: PROPOSAL — reference implementation** · Source: thesis, Chapter 4 (estimators, refutation criteria)

# analyse — Field data analysis chain

*Version française : [README_fr.md](README_fr.md)*

The `cro_terrain` package implements the estimators that protocols P1 to P7 would apply to the collected data. No protocol has been deployed. The tests and the example use simulated data only, and none of their figures should be quoted as a result.

| Module | Role |
|---|---|
| `information.py` | discrete conditional mutual information, estimator Δ̂ = Î(V;Σ\|M,C) with Miller–Madow correction, Ĥ(V\|C), empirical Opp |
| `statistics.py` | participant-level bootstrap (95 % CI), permutation test of admissibility V ⊥ M \| (Σ,C) |
| `reliability.py` | ICC(2,1), Cohen's and Fleiss' kappa |
| `bounds.py` | refined bound, classical and post-quantum, thresholds H♯ and H♯_q |
| `quantum.py` | estimation of η_q and negative control |
| `refutation.py` | application of the pre-registered refutation criteria |
| `p1.py` | P1: attention checks, exclusions, verdict vector, rotation lists, domains of the 50 pairs |
| `p2.py` | P2: structural decomposition, MDS volume (unit dependence), Delphi summary and stopping rule |
| `p4.py` | P4: six-step algorithm `alg:estimation_conjointe`, prerequisites, counting $\mathcal{V}$, reliability, conversion of P1 data |
| `p5.py` | P5: $\hat\Delta_q$ per noise condition and aid modality, $\hat\eta_q$ by regression, interpretation errors, interface noise model, Williams order |
| `p6.py` | P6: simulation summary, structural ceiling of $\hat\eta_q$, Alicki-Fannes-Winter heuristic, reading of the predictions |
| `p7.py` | P7: algorithm `alg:protocole_combine`, hypothesis check, $\hat\beta_q$ by relative entropy, bound comparison, cross-validation |
| `sampling.py` | reproducible random draw (published seed) |
| `simulate.py` | synthetic data generator with known Δ |
| `templates.py` | loading of the protocols' CSV templates |

## Running

```sh
pip install --break-system-packages -r requirements.txt
python3 -m pytest -q tests        # 111 tests passed on 13 October 2026
python3 exemple_analyse.py        # commented example on simulated data
```
