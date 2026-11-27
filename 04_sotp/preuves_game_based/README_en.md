> **Status: PROPOSAL. construction (submitted to IEEE Transactions on Information Theory, withdrawal requested in November 2026)** · Source: thesis, Annex A

# Game-based security of the SOTP family

*Version française : [README_fr.md](README_fr.md)*

| File | Content |
|---|---|
| [gamebased_fr.md](gamebased_fr.md) | Annex A in Markdown, French |
| [gamebased_en.md](gamebased_en.md) | Annex A in Markdown, English (equivalent content) |
| [gamebased_source_fr.tex](gamebased_source_fr.tex) | LaTeX source of Annex A in the final version of the manuscript, copied unchanged (French) |
| [lean/GameBasedSOTP.lean](lean/GameBasedSOTP.lean) | Lean 4 mechanisation of the SOTP-Low reductions in a reduced setting, version 1.3 (Mathlib only, checkable on <https://live.lean-lang.org>): Iron layer in the confidentiality game (Theorem A.5), truncation mask (Remark 3.5), SOTP-Base (Lemma 2.2, Theorem A.3, Corollary A.1), SOTP-High (Theorem A.4) and statement of Conjecture 3.1; build log [lean/results/lean_build_v1.3.log](lean/results/lean_build_v1.3.log) |
| [lean/VERIFICATION_en.md](lean/VERIFICATION_en.md) | Verification dossier modelled on the repository of the Riemann proof: statements without proof (`Verification/Enonces.lean`), entry point (`Principal.lean`), non-vacuity tests (`Coherence.lean`), script `verifier.sh` and GitHub workflow `verification_lean_sotp.yml` |

Content of the annex: IND-CONF, BIND-REL and EXT-OPP games; bridges to $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ and $\mathsf{Opp}$; reductions of SOTP-Low to the PRG and to the discrete logarithm; design rule and JL sizing theorem for SOTP-Base; security of SOTP-High inherited from Groth16; corollary on the SOTP-Base reductions; summary table; corollary on the game-based CLO product and remark on non-contradiction with the trilemma; mechanisation in a reduced setting; limitations.

No English `.tex` version is provided; the English Markdown version serves that purpose. The `.tex` file uses the manuscript macros (`\cmt`, `\Conf`, `\Relver`, …) and compiles within [../../00_these/manuscrit/](../../00_these/manuscrit/).

The games and their bridges to the CLO metrics are proved on finite distributions in [`../../05_formalisation_lean/ConditionalCRO.lean`](../../05_formalisation_lean/ConditionalCRO.lean), version 3.8, Section 18.

The reductions establish guarantees of confidentiality and verification reliability. Confidentiality is computational under PRG and becomes statistical when the mask is truncated (Remark `rem:masque_troncature`). They provide no lower bound on opposability and are not comparable with the trilemma bound, which concerns statistical confidentiality and reconstruction reliability.
