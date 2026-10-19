# ePrint 2025/1348 - CRO Trilemma (forme antérieure)

> **Statut : PRÉPRINT (non évalué par les pairs)** · Source : Cryptology ePrint Archive, rapport 2025/1348

[English version](README_en.md)

## Référence

| Champ | Valeur |
|---|---|
| Titre | The CRO Trilemma: A Formal Incompatibility between Confidentiality, Reliability and Legal Opposability in Post-Quantum Proof Systems |
| Auteurs | T. E. Minka Mi Nguidjoï, F. S. Mani Onana, T. Djotio Ndié |
| Archive | Cryptology ePrint Archive, Report 2025/1348 |
| Lien | <https://eprint.iacr.org/2025/1348> |
| Reçu / approuvé | 2025-07-24 / 2025-07-25 |
| Catégorie ePrint | Fondements |
| Mots-clés | Confidentiality, reliability, legal opposability, explainability, post-quantum proofs, contextual entropy, leakage |
| Licence affichée sur ePrint | CC BY 4.0 (relevée le 2026-10-12) |
| Entrée BibTeX | [CITATION.bib](CITATION.bib) (clé `MINKA2025CRO`, reprise de la bibliographie de la thèse) |

Ce document est un préprint déposé sur l'archive ePrint de l'IACR. Il n'a pas fait l'objet d'une évaluation par les pairs et ses résultats ne doivent pas être cités comme validés.

## Résumé

Paraphrase fidèle du résumé officiel publié sur la page ePrint (consultée le 2026-10-12). Le texte original fait foi et se lit à l'adresse <https://eprint.iacr.org/2025/1348>.

L'article énonce le « Trilemme CRO », selon lequel aucun système de preuve post-quantique ne peut satisfaire simultanément, au-delà d'une probabilité d'échec négligeable, trois propriétés. Il s'agit de la confidentialité ($\mathrm{Priv} > 1 - \mathrm{negl}(\lambda)$), de la fiabilité ($\mathrm{Rel} > 1 - \mathrm{negl}(\lambda)$) et de l'opposabilité juridique, mesurée par une entropie contextuelle $H_{\mathrm{Opp}} \approx \log |V_J|$ où $V_J$ est l'espace de validation d'un vérificateur institutionnel $J$ en temps polynomial. Les auteurs formalisent un « paradoxe de l'authenticité invisible » à l'aide de l'entropie contextuelle $H(C)$ et d'une perte d'interprétabilité quantique $\eta_q(C)$. Sous des hypothèses quantiques standard, ils prouvent contre les adversaires QPT la borne d'impossibilité

$$H_{\mathrm{Opp}} \leq \frac{\mathrm{Priv}\cdot\mathrm{Rel}}{\varepsilon_{\mathrm{eff}}\cdot 2^{H(C)}} + \eta_q(C) + \mathrm{negl}(\lambda).$$

Ils introduisent un cadre composable comprenant un modèle avec vérificateur $J$ (algorithme 1) et un théorème de décomposition optimale de l'entropie (théorème 2.3). Le résumé fait état d'éléments empiriques montrant que la borne est systématiquement violée, avec $\Gamma_\text{CRO} > 0{,}8$, pour des finalistes du concours PQC du NIST (par exemple Dilithium) et des preuves à divulgation nulle structurées (STARKs, Groth16). La note de la page ePrint précise que ZK-NR (2025/1138) opère dans l'espace réalisable que délimite ce trilemme.

## Rôle dans la thèse

Antécédent direct du Trilemme CRO conditionnel classique. Le chapitre 2 ([chap2/cro_classique.tex](../../00_these/manuscrit/chap2/cro_classique.tex)) le cite conjointement avec l'article publié P2 ([01_publie/P2_CRO_IEEEAccess2026](../../01_publie/P2_CRO_IEEEAccess2026/)) à l'appui du Trilemme CRO conditionnel classique. Dans la thèse, la borne porte sur le produit $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ et s'exprime en fonction de la capacité d'extraction institutionnelle $\Delta$, de la granularité des verdicts $\alpha$ et du paramètre de sécurité $\lambda$. La discussion des limites du chapitre 5 (limite L3, [chap5/discussions.tex](../../00_these/manuscrit/chap5/discussions.tex)) range aussi ce préprint parmi les prépublications où sont développés les jeux cryptographiques (IND-CONF, BIND-REL, EXT-OPP) qui n'ont pas encore été publiés dans une revue à comité de lecture.

## Réserves formulées dans la thèse

Ce préprint contient une forme antérieure de la borne, exprimée sur $H_{\mathrm{Opp}}$ avec $\varepsilon_{\mathrm{eff}}$ et $\eta_q(C)$. Elle est remplacée par la forme publiée dans l'article P2 (IEEE Access 2026, [01_publie/P2_CRO_IEEEAccess2026](../../01_publie/P2_CRO_IEEEAccess2026/)), qui est la seule retenue par la thèse. Le préprint ne doit donc pas être cité comme source de la borne en vigueur. Le code d'origine qui accompagnait cette version n'a pas été conservé et les éléments empiriques annoncés dans le résumé ne sont pas reproductibles à partir de ce dépôt. L'indice $\Gamma_\text{CRO}$ mentionné dans le résumé n'est pas défini dans le cadre de la thèse.

## PDF et licence

Le PDF n'est pas joint à ce dossier. Il est disponible sur ePrint à l'adresse <https://eprint.iacr.org/2025/1348>. La page ePrint affiche la licence Creative Commons Attribution 4.0 (CC BY 4.0), qui autorise la redistribution avec attribution. Le PDF pourra donc être joint ultérieurement, accompagné de la mention d'attribution requise.
