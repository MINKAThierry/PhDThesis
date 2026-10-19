"""cro_terrain: analysis code for the field protocols of the thesis (chapter 4).

Status: PROPOSAL, reference implementation. No protocol has been deployed and
no field data exist; the package is tested on simulated data only.

Modules
-------
information  discrete entropies and (conditional) mutual information
             (plug-in, Miller-Madow, NSB), Delta_hat, Opp_emp, alpha_hat
statistics   admissibility permutation test, participant bootstrap, slopes
reliability  ICC(2,1), Cohen's and Fleiss' kappa, thesis thresholds
bounds       refined classical and post-quantum bounds, H_sharp thresholds
refutation   pre-registered refutation criteria, Helios agreement rule
quantum      toy classical-quantum simulator for eta_q (hypothetical scenario)
p1           P1 attention checks, exclusions, verdict vector, rotation lists
p2           P2 structural decomposition, MDS volume, Delphi summaries and stop rule
p4           P4 six-step joint estimation of (Delta_hat, alpha_hat), alg:estimation_conjointe
p5           P5 Delta_q per noise condition, eta_q regression, verifier noise model
p6           P6 summary of eta_q simulation runs, structural ceiling, AFW heuristic
p7           P7 combined PQ validation: hypotheses, beta_q, bound comparison, cross-validation
templates    reading of the CSV templates (French or English headers)
simulate     synthetic data generators with known ground truth
sampling     reproducible SHA-256 sampling of proofs (P3)
"""

from .information import (alpha_hat, conditional_entropy, conditional_mutual_information,
                          delta_hat, entropy, gamma_from_alpha, h_v_given_c, opp_emp,
                          opp_emp_shuffle, shuffle_corrected_cmi)
from .statistics import admissibility_permutation_test, cluster_bootstrap, slope_through_origin
from .reliability import cohen_kappa, fleiss_kappa, fleiss_kappa_from_table, icc_2_1
from .bounds import (borne_raffinee, borne_raffinee_pq, h_sharp, h_sharp_q, refined_bound,
                     refined_bound_pq)
from .refutation import apply_criteria, criterion_opp_helios
from .templates import read_template
from .sampling import draw_sample

__version__ = "0.1.0"

__all__ = [
    "alpha_hat", "conditional_entropy", "conditional_mutual_information", "delta_hat", "entropy",
    "gamma_from_alpha", "h_v_given_c", "opp_emp", "opp_emp_shuffle", "shuffle_corrected_cmi",
    "admissibility_permutation_test", "cluster_bootstrap", "slope_through_origin", "cohen_kappa", "fleiss_kappa",
    "fleiss_kappa_from_table", "icc_2_1", "borne_raffinee", "borne_raffinee_pq", "h_sharp",
    "h_sharp_q", "refined_bound", "refined_bound_pq", "apply_criteria", "criterion_opp_helios",
    "read_template", "draw_sample",
]
