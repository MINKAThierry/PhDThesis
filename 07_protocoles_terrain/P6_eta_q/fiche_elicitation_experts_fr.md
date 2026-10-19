# Fiche d'élicitation des experts (P6)

> **Statut : PROPOSITION — rôle des experts à arrêter** · Source : thèse, chapitre 4, §4.2.6 (« 40 experts et simulation ») ; critère $\eta_q$ du tableau `tab:criteres_refutation` (« l'IC 95 % de $\hat\eta_q$ exclut l'intervalle prédit avant l'expérience »)

[English version](fiche_elicitation_experts_en.md) · [Protocole P6](protocole_fr.md)

Le critère de réfutation portant sur $\eta_q$ exige un intervalle prédit **avant** l'expérience. La thèse donne des valeurs a priori, de 0,05 à 0,15 pour un support NISQ typique. Elle demande de les pré-enregistrer. Cette fiche propose de faire fixer cet intervalle par le panel de 40 experts prévu par la thèse, en deux tours, avant toute exécution du plan de simulation. Les experts ne voient aucune sortie du modèle jouet.

## 1. Panel

| Profil proposé | Effectif |
|---|---|
| Information quantique (théorie) | 10 |
| Matériel quantique (expérimentateurs) | 10 |
| Cryptographie post-quantique | 10 |
| Droit et institutions du numérique | 10 |

Codes `P6-EX-NN` **[répartition à arrêter par l'équipe]**.

## 2. Partie A. Intervalle prédit de $\eta_q$ (tour 1, puis tour 2 après retour anonymisé)

> **Scénario présenté.** Une preuve cryptographique est conservée ou vérifiée sur un support quantique. Le support subit un bruit comparable à celui du matériel actuel, avec les paramètres de la [fiche des paramètres](fiche_parametres_canaux_fr.md). Le coefficient $\eta_q$ mesure la part de l'information utile à une institution qui est perdue, rapportée à l'entropie contextuelle $H(C)$. Il vaut 0 si rien n'est perdu.
>
> On rappelle que $\eta_q \leq \log_2|\mathcal{V}|/H(C)$, soit au plus 0,19 avec 4 verdicts et $H(C) = 10{,}5$ bits.

| Canal | Votre meilleure estimation de $\eta_q$ | Borne basse (5 %) | Borne haute (95 %) | Confiance 0–10 |
|---|---|---|---|---|
| Dépolarisation, $p = 0{,}01$ | | | | |
| Déphasage, $p = 0{,}01$ | | | | |
| Amortissement, $\gamma = 0{,}01$ | | | | |
| Combiné (paramètres sourcés) | | | | |

Argument principal (trois lignes au plus)

______________________________________________________________________

Le plafond structurel est communiqué aux experts, car il découle de la définition. Les valeurs de la thèse ne leur sont pas communiquées **[à arrêter par l'équipe]**.

## 3. Partie B. Contrôle des paramètres

Pour chaque paramètre de la fiche des paramètres, l'expert indique s'il le juge représentatif du matériel actuel.

| Paramètre | Valeur proposée | Représentatif ☐ oui ☐ non | Valeur proposée à la place, avec source |
|---|---|---|---|
| $p_{\text{dep}}$ | | ☐ ☐ | |
| $p_{\text{deph}}$ | | ☐ ☐ | |
| $\gamma_{\text{AD}}$ | | ☐ ☐ | |
| Durée $t$ du scénario | | ☐ ☐ | |

## 4. Agrégation

| Élément | Règle proposée **[à arrêter par l'équipe]** |
|---|---|
| Intervalle prédit par canal | médiane des bornes basses et médiane des bornes hautes du tour 2 |
| Arrêt | deux tours. Un troisième tour seulement si l'écart interquartile des meilleures estimations dépasse la moitié de la médiane |
| Dépôt | intervalle et règle déposés dans le pré-enregistrement avant l'exécution du plan |

Le résumé de chaque tour peut réutiliser `cro_terrain.p2.delphi_round_summary`.

## 5. Intervalle déposé

| Canal | Intervalle prédit | Date de dépôt | Référence du pré-enregistrement |
|---|---|---|---|
| Dépolarisation | [____ ; ____] | __/__/____ | |
| Déphasage | [____ ; ____] | __/__/____ | |
| Amortissement | [____ ; ____] | __/__/____ | |
| Combiné | [____ ; ____] | __/__/____ | |

Licence CC BY 4.0.
