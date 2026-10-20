> **Statut : PROPOSITION: construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, chapitre 3 (§3.2 et §3.3) et annexe A

# La famille SOTP (Semantic One-Time Pad)

*English version: [README_en.md](README_en.md)*

Ce dossier réunit la construction SOTP de la thèse, qui associe à chaque régime d'entropie contextuelle un protocole de référence organisé selon le paradigme Gold-Iron-Clay (Gold pour la confidentialité, Iron pour la fiabilité de vérification, Clay pour la présentation du contexte institutionnel). Il comprend la spécification des algorithmes, les preuves game-based de l'annexe A, une implémentation de référence pédagogique de SOTP-Low et SOTP-Base en Python et une implémentation exécutable de SOTP-High.

La construction est une **proposition** soumise à IEEE Transactions on Information Theory. Elle n'est ni publiée ni déployée.

## Statut de chaque énoncé

| Énoncé | Référence dans la thèse | Statut | Hypothèses |
|---|---|---|---|
| Propriétés de S-OTP (confidentialité, $\mathsf{Rel}_{\mathrm{ver}}$, majorant de $\mathsf{Opp}$) | Théorème `thm:proprietes_sotp` | prouvé | PRG, DLog |
| Confidentialité calculatoire de SOTP-Low | Proposition `thm:saturation_sotp_low` (1) ; annexe A, Th. `thm:ann_sotp_low_conf` | prouvée | PRG |
| Fiabilité de vérification de SOTP-Low, $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ | Proposition `thm:saturation_sotp_low` (2) ; annexe A, Th. `thm:ann_sotp_low_rel` | prouvée | DLog |
| Confidentialité calculatoire et $\mathsf{Rel}_{\mathrm{ver}}$ de SOTP-Base | Proposition `thm:saturation_sotp_base` | prouvées | PRG, DLog |
| Préservation des distances JL de SOTP-Base | Proposition `thm:saturation_sotp_base` ; annexe A, Th. `thm:ann_sotp_base_opp` | prouvée (avec probabilité $\geq 1-\delta$) | lemme JL |
| Confidentialité ($\mathsf{Conf} = 1$) et $\mathsf{Rel}_{\mathrm{ver}}$ de SOTP-High | Proposition `thm:saturation_sotp_high` ; annexe A, Th. `thm:ann_sotp_high` | prouvées | q-SDH, q-PKE, DLog, cérémonie de mise en place honnête |
| Minorations d'opposabilité $0{,}75\,\Delta/\lambda$, $0{,}5\min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$, $0{,}45\,\beta\log_2\lambda/\lambda$ | Remarques `rem:facteur_limitant_low`, `rem:heuristique_sotp_base`, `rem:heuristique_sotp_high` | **heuristiques de conception non prouvées** | – |
| Optimalité de S-OTP dans la classe OTP | Remarque `thm:optimalite_sotp` | argument heuristique, preuve ouverte | – |
| Optimalité universelle de SOTP (constante $C_R \geq 1$) | Conjecture `conj:optimalite_universelle` | **conjecture** | Hypothèses `ass:extraction_bornee`–`ass:regime` |
| Valeurs numériques (296 bits, $0{,}998$, $0{,}205$, $0{,}050$, $0{,}037$, $d = 896\,000$) | §3.2, §3.3 | **illustrations** analytiques, non comparables aux produits CLO ni à la borne du trilemme | – |

L'opposabilité n'est couverte par aucune réduction. La couche Clay est une fonction du contexte public, donc $I(V;\sigma_3\mid C) = 0$. Elle est analysée comme un format de présentation (Remarque `rem:statut_sotp`). Les paramètres institutionnels $\Delta$, $\alpha$, $\beta$ restent signifiants dans le dimensionnement ($d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$) et dans les heuristiques.

## Plan du dossier

| Sous-dossier | Contenu | Statut |
|---|---|---|
| [specification/](specification/) | Spécification de S-OTP, du paradigme Gold-Iron-Clay et des trois variantes (algorithmes Setup/Prove/Open/Verify, régimes $H^*(\lambda) = \sqrt{\lambda}$ et $\lambda/\log\lambda$, propositions, remarques heuristiques, conjecture, algorithme de sélection) | PROPOSITION — construction |
| [preuves_game_based/](preuves_game_based/) | Annexe A en Markdown (jeux IND-CONF, BIND-REL, EXT-OPP, réductions, tableau récapitulatif, corollaire) et source LaTeX d'origine | PROPOSITION — construction |
| [reference_low_base/](reference_low_base/) | Implémentation de référence pédagogique de SOTP-Low et SOTP-Base en Python, avec tests pytest | PROPOSITION — implémentation de référence |
| [high/](high/) | Implémentation exécutable de SOTP-High (Circom/Groth16), produite séparément | PROPOSITION — implémentation de référence |

## Note sur les langues

La spécification et l'annexe A existent en français et en anglais au format Markdown. La source LaTeX de l'annexe A est fournie telle quelle sous [preuves_game_based/gamebased_source_fr.tex](preuves_game_based/gamebased_source_fr.tex), dans sa langue d'origine (le français). Aucune version `.tex` anglaise n'est fournie, la version Markdown anglaise [gamebased_en.md](preuves_game_based/gamebased_en.md) en tient lieu.

## Sources

- Manuscrit, chapitre 3 : [../00_these/manuscrit/chap3/](../00_these/manuscrit/chap3/) (`introduction_chap3.tex`, `sotp_base.tex`, `sotp_construction.tex`)
- Manuscrit, annexe A : [../00_these/manuscrit/annexes/gamebased.tex](../00_these/manuscrit/annexes/gamebased.tex)

## Licence

Textes sous CC BY 4.0, code sous licence MIT.
