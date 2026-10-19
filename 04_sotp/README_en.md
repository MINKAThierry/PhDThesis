> **Status: PROPOSAL: construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Chapter 3 (§3.2 and §3.3) and Annex A

# 04_sotp: The SOTP family (Semantic One-Time Pad)

*Version française : [README_fr.md](README_fr.md)*

This folder gathers the SOTP construction of the thesis, which associates with each regime of contextual entropy a reference protocol organised according to the Gold-Iron-Clay paradigm (Gold for confidentiality, Iron for verification reliability, Clay for presenting the institutional context). It contains the specification of the algorithms, the game-based proofs of Annex A, a pedagogical Python reference implementation of SOTP-Low and SOTP-Base, and an executable implementation of SOTP-High.

The construction is a **proposal** submitted to IEEE Transactions on Information Theory. It is neither published nor deployed.

## Status of each statement

| Statement | Reference in the thesis | Status | Assumptions |
|---|---|---|---|
| Properties of S-OTP (confidentiality, $\mathsf{Rel}_{\mathrm{ver}}$, upper bound on $\mathsf{Opp}$) | Theorem `thm:proprietes_sotp` | proven | PRG, DLog |
| Computational confidentiality of SOTP-Low | Proposition `thm:saturation_sotp_low` (1); Annex A, Th. `thm:ann_sotp_low_conf` | proven | PRG |
| Verification reliability of SOTP-Low, $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ | Proposition `thm:saturation_sotp_low` (2); Annex A, Th. `thm:ann_sotp_low_rel` | proven | DLog |
| Computational confidentiality and $\mathsf{Rel}_{\mathrm{ver}}$ of SOTP-Base | Proposition `thm:saturation_sotp_base` | proven | PRG, DLog |
| JL distance preservation of SOTP-Base | Proposition `thm:saturation_sotp_base`; Annex A, Th. `thm:ann_sotp_base_opp` | proven (with probability $\geq 1-\delta$) | JL lemma |
| Confidentiality ($\mathsf{Conf} = 1$) and $\mathsf{Rel}_{\mathrm{ver}}$ of SOTP-High | Proposition `thm:saturation_sotp_high`; Annex A, Th. `thm:ann_sotp_high` | proven | q-SDH, q-PKE, DLog, honest setup ceremony |
| Opposability lower bounds $0.75\,\Delta/\lambda$, $0.5\min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$, $0.45\,\beta\log_2\lambda/\lambda$ | Remarks `rem:facteur_limitant_low`, `rem:heuristique_sotp_base`, `rem:heuristique_sotp_high` | **unproven design heuristics** | – |
| Optimality of S-OTP within the OTP class | Remark `thm:optimalite_sotp` | heuristic argument, proof open | – |
| Universal optimality of SOTP (constant $C_R \geq 1$) | Conjecture `conj:optimalite_universelle` | **conjecture** | Assumptions `ass:extraction_bornee`–`ass:regime` |
| Numerical values (296 bits, $0.998$, $0.205$, $0.050$, $0.037$, $d = 896{,}000$) | §3.2, §3.3 | analytical **illustrations**, not comparable with CLO products nor with the trilemma bound | – |

Opposability is not covered by any reduction. The Clay layer is a function of the public context, hence $I(V;\sigma_3\mid C) = 0$, and it is analysed as a presentation format (Remark `rem:statut_sotp`). The institutional parameters $\Delta$, $\alpha$, $\beta$ remain meaningful in the sizing ($d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$) and in the heuristics.

## Folder layout

| Subfolder | Content | Status |
|---|---|---|
| [specification/](specification/) | Specification of S-OTP, the Gold-Iron-Clay paradigm and the three variants (Setup/Prove/Open/Verify algorithms, regimes $H^*(\lambda) = \sqrt{\lambda}$ and $\lambda/\log\lambda$, propositions, heuristic remarks, conjecture, selection algorithm) | PROPOSAL — construction |
| [preuves_game_based/](preuves_game_based/) | Annex A in Markdown (IND-CONF, BIND-REL, EXT-OPP games, reductions, summary table, corollary) and the original LaTeX source | PROPOSAL — construction |
| [reference_low_base/](reference_low_base/) | Pedagogical Python reference implementation of SOTP-Low and SOTP-Base, with pytest tests | PROPOSAL — reference implementation |
| [high/](high/) | Executable implementation of SOTP-High (Circom/Groth16), produced separately | PROPOSAL — reference implementation |

## Note on languages

The specification and Annex A are available in French and English as Markdown. The LaTeX source of Annex A is provided unchanged as [preuves_game_based/gamebased_source_fr.tex](preuves_game_based/gamebased_source_fr.tex), in its original language (French). No English `.tex` version is provided; the English Markdown version [gamebased_en.md](preuves_game_based/gamebased_en.md) serves that purpose.

## Sources

- Manuscript, Chapter 3: [../00_these/manuscrit/chap3/](../00_these/manuscrit/chap3/) (`introduction_chap3.tex`, `sotp_base.tex`, `sotp_construction.tex`)
- Manuscript, Annex A: [../00_these/manuscrit/annexes/gamebased.tex](../00_these/manuscrit/annexes/gamebased.tex)

## Licence

Texts under CC BY 4.0, code under the MIT licence.
