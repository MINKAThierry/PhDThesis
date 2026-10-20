# Protocole de mesure de $\eta_q$, perte d'interprétabilité quantique

> **Statut : PROPOSITION. protocole non déployé, scénario hypothétique** · Source : thèse, chapitre 4, §4.2.6 (tableau `tab:val_canaux_quantiques`)

[English version](protocole_en.md) · [README du dossier](README_fr.md)

## 1. Objectif et définition

Mesurer le coefficient de perte d'interprétabilité quantique $\eta_q$, plus petit coefficient tel que

$$I(V^q;\Lambda(\rho_\Sigma)\mid C)_\rho \;\geq\; I(V^q;\rho_\Sigma\mid C)_\rho - \eta_q\,H(C)$$

(thèse, équation `eq:perte_interpretabilite_op`). L'estimateur est

$$\hat\eta_q = \frac{I(V^q;\rho_\Sigma\mid C)_\rho - I(V^q;\Lambda(\rho_\Sigma)\mid C)_\rho}{H(C)}$$

(équation `eq:estimateur_eta_q`).

## 2. Portée

Les signatures ML-DSA, SLH-DSA et Falcon sont des chaînes de bits classiques, pour lesquelles $\eta_q = 0$. Le protocole ne s'applique qu'à un scénario de stockage ou de vérification quantique, **hypothétique à ce jour** (thèse, §4.2.6.1). Toute valeur produite par P6 est une propriété d'un modèle de ce scénario, non une mesure sur un système déployé.

## 3. Deux volets

La thèse prévoit « 40 experts et simulation » (tableau `tab:programme_experimental`). La proposition distingue deux volets.

| Volet | Contenu | Instrument |
|---|---|---|
| Simulation | modèle classique-quantique jouet, canaux de dépolarisation, de déphasage et d'amortissement d'amplitude, calcul exact de $\hat\eta_q$ | `cro_terrain.quantum`, [plan de simulation](plan_simulation_fr.md), [fiche des paramètres](fiche_parametres_canaux_fr.md) |
| Experts | 40 experts fixent, **avant** la simulation, l'intervalle prédit de $\eta_q$ qui sert au critère de réfutation. Ils contrôlent aussi la calibration des paramètres de bruit sur le matériel quantique actuel. | [fiche d'élicitation](fiche_elicitation_experts_fr.md) |

Le rôle des 40 experts n'est pas précisé dans la thèse. La proposition le fait porter sur l'intervalle prédit, que la thèse demande de fixer avant l'expérience (critère $\eta_q$ du tableau `tab:criteres_refutation`) **[à arrêter par l'équipe]**. Une variante ferait juger par les experts des preuves dégradées, comme en phase 2 de P5.

## 4. Matériel (thèse, §4.2.6.2)

| Élément (thèse) | Mise en œuvre proposée |
|---|---|
| Simulateur de canaux quantiques (dépolarisation, déphasage, amortissement d'amplitude) | `cro_terrain.quantum.make_channel`, dépolarisation globale (équation `eq:canal_depolarisant_op`), déphasage et amortissement appliqués qubit par qubit, plus un canal combiné |
| Paramètres de bruit calibrés sur le matériel actuel (IBM Quantum, IonQ, etc.) | [fiche des paramètres](fiche_parametres_canaux_fr.md), valeurs à relever avec leur source et leur date |
| Protocoles PQC avec et sans assistance quantique | modèle jouet où la preuve est codée sur $n$ qubits (base « conjuguée », alternance Z et X), avec pour contrôle négatif la même preuve lue comme chaîne de bits |

Plages testées (tableau `tab:val_canaux_quantiques`).

| Canal | Paramètre | Plage testée | $\eta_q$ attendu (thèse) |
|---|---|---|---|
| Dépolarisation | $p_{\text{dep}}$ | $[0{,}001 ; 0{,}1]$ | 0,02 à 0,20 |
| Déphasage | $p_{\text{deph}}$ | $[0{,}001 ; 0{,}05]$ | 0,01 à 0,10 |
| Amortissement | $\gamma_{\text{AD}}$ | $[0{,}001 ; 0{,}02]$ | 0,005 à 0,05 |
| Combiné (NISQ typique) | — | — | 0,05 à 0,15 |

## 5. Procédure (thèse, §4.2.6.3)

1. **Calibration.** Ligne de base sans bruit, $I(V^q;\rho_\Sigma\mid C)$ pour chaque type de preuve.
2. **Dégradation contrôlée.** Application de canaux à paramètres croissants, par exemple $\Lambda_{\text{dep}}(\rho) = (1-p)\rho + p\,I_d/d$ (équation `eq:canal_depolarisant_op`). Mesure de $I(V^q;\Lambda(\rho_\Sigma)\mid C)$ à chaque niveau.
3. **Régression.** Ajustement de $\Delta I = \eta_q\,H(C)$ pour extraire $\hat\eta_q$.

Trois métriques complémentaires sont calculées (thèse, §4.2.6.4), la fidélité moyenne $F_{\text{avg}}$, la distance de trace et la perte d'information par bit contextuel $\Delta I/H(C)$. Toutes sont écrites dans le [gabarit](gabarit_simulation_fr.csv).

```sh
cd ../analyse
python3 -m cro_terrain.quantum --out ../P6_eta_q/sortie_plan_reference_fr.csv --lang fr
```

## 6. Prédictions (thèse, §4.2.6.5)

1. $\hat\eta_q \in [0{,}05 ; 0{,}15]$ pour un support simulé aux taux d'erreur du matériel actuel (valeurs a priori, à pré-enregistrer).
2. Ordre de grandeur de $\hat\eta_q\,H(C)$ compatible avec la borne de continuité d'Alicki, Fannes et Winter, exprimée en fonction de la distance de trace (heuristique).
3. Relation croissante, approximativement linéaire pour un bruit faible, entre $p_{\text{dep}}$ et $\hat\eta_q$.
4. $\hat\eta_q = 0$, aux fluctuations d'échantillonnage près, lorsque la preuve est lue comme chaîne de bits (contrôle négatif).

La fonction `cro_terrain.p6.check_predictions` en donne une lecture descriptive. Le critère de réfutation porte sur l'intervalle prédit fixé par les experts (section 3).

## 7. Points de vigilance

1. **Plafond structurel.** Comme $0 \leq I(V^q;\Lambda(\rho_\Sigma)\mid C) \leq I(V^q;\rho_\Sigma\mid C) \leq \log_2|\mathcal{V}|$, on a toujours $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C) \leq \log_2|\mathcal{V}|/H(C)$ (`p6.eta_ceiling`). Avec quatre verdicts et $H(C) = 10{,}5$ bits, $\hat\eta_q \leq 0{,}19$. Avec $H(C) = 20$ bits, $\hat\eta_q \leq 0{,}10$. Atteindre l'intervalle prédit de 0,05 à 0,15 suppose de perdre une grande part de l'information extraite.
2. **Ce que donne le modèle jouet.** Sur le [plan de référence](sortie_plan_reference_fr.csv), $\hat\eta_q$ croît avec le bruit, respecte l'heuristique d'Alicki-Fannes-Winter et vaut exactement 0 pour le contrôle négatif. Avec $H(C) = 10{,}5$ bits, il atteint au plus 0,030 (dépolarisation à $p = 0{,}1$) et 0,009 pour le canal combiné par défaut. Le modèle jouet reste donc très en dessous des valeurs attendues du tableau `tab:val_canaux_quantiques`. Cet écart est une propriété du modèle, avec 2 ou 3 qubits et des paramètres combinés provisoires. Ce n'est pas un résultat sur le scénario quantique.
3. **Paramètres du canal combiné.** Ils sont provisoires ($p_{\text{dep}} = 0{,}01$, $p_{\text{deph}} = 0{,}01$, $\gamma_{\text{AD}} = 0{,}005$, puis multipliés par un facteur d'échelle). Ils doivent être remplacés par des valeurs sourcées ([fiche des paramètres](fiche_parametres_canaux_fr.md)) avant tout pré-enregistrement.
4. **Pas d'intervalle de confiance en simulation exacte.** Le modèle est déterministe. L'intervalle de $\hat\eta_q$ vient de la variation des paramètres incertains (calibration), non d'un échantillonnage. Le critère de réfutation s'applique à cet intervalle **[à arrêter par l'équipe]**.

## 8. Durée et ressources

La thèse prévoit 4 mois, 40 experts et la simulation, pour un coût estimé de 8 000 000 FCFA (tableau `tab:programme_experimental`), dans la fenêtre A19–A30 (tableau `tab:calendrier_experimental`).

## 9. Prérequis

☐ Paramètres des canaux relevés et sourcés ([fiche](fiche_parametres_canaux_fr.md))
☐ Intervalle prédit fixé par les experts et déposé ([fiche](fiche_elicitation_experts_fr.md))
☐ Plan de simulation figé (version, $H(C)$, nombre de qubits, bases)
☐ Pré-enregistrement déposé ([modèle](../00_commun/preenregistrement_fr.md))

Licence CC BY 4.0.
