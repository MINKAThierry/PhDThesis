# Plan de simulation (P6)

> **Statut : PROPOSITION. scénario hypothétique, modèle jouet** · Source : thèse, chapitre 4, §4.2.6.2 et §4.2.6.3 (tableau `tab:val_canaux_quantiques`)

[English version](plan_simulation_en.md) · [Protocole P6](protocole_fr.md)

Le plan fixe, avant toute exécution, les modèles, les canaux, les niveaux de bruit et les contrôles. La version de référence est `plan-v0.1`, exécutée par `cro_terrain.quantum.run_plan`. Sa sortie est versionnée dans [sortie_plan_reference_fr.csv](sortie_plan_reference_fr.csv). Un test vérifie qu'elle est reproduite à l'identique.

## 1. Modèle

| Élément | Valeur de `plan-v0.1` | Rôle |
|---|---|---|
| Preuve | chaîne de $n$ bits codée sur $n$ qubits | $\rho_\Sigma$ |
| Nombre de qubits $n$ | 2 et 3 | taille du support |
| Base de codage | « conjuguée » (qubits alternativement en base Z et X) | rend le support sensible à tous les canaux |
| Verdicts | 4, liés à la preuve par une règle avec un taux d'erreur de 0,1 | $V^q$, $|\mathcal{V}| = 4$ |
| Contextes simulés | 2, équiprobables | indice $C$ de l'information conditionnelle |
| $H(C)$ du dénominateur | 10,5 et 20 bits (valeurs d'espèce et de domaine de ML-DSA, table de référence de la thèse) | normalisation de $\hat\eta_q$ |
| Information | quantité de Holevo conditionnelle, calcul exact | $I(V^q;\rho_\Sigma\mid C)$ |

$H(C)$ au dénominateur est l'entropie contextuelle institutionnelle fournie par P2 ou par la table de référence. Ce n'est pas l'entropie des deux contextes simulés.

## 2. Canaux et niveaux

| Canal | Niveaux de `plan-v0.1` | Plage de la thèse |
|---|---|---|
| Dépolarisation, globale sur les $n$ qubits, $(1-p)\rho + p\,I_d/d$ | 0 ; 0,001 ; 0,002 ; 0,005 ; 0,01 ; 0,02 ; 0,05 ; 0,1 | $[0{,}001 ; 0{,}1]$ |
| Déphasage, sur chaque qubit, $(1-p)\rho + p\,Z\rho Z$ | 0 ; 0,001 ; 0,002 ; 0,005 ; 0,01 ; 0,02 ; 0,05 | $[0{,}001 ; 0{,}05]$ |
| Amortissement d'amplitude, sur chaque qubit | 0 ; 0,001 ; 0,002 ; 0,005 ; 0,01 ; 0,02 | $[0{,}001 ; 0{,}02]$ |
| Combiné | facteur d'échelle 0 ; 0,25 ; 0,5 ; 1 appliqué à $(p_{\text{dep}}, p_{\text{deph}}, \gamma_{\text{AD}}) = (0{,}01 ; 0{,}01 ; 0{,}005)$, dans l'ordre amortissement, déphasage, dépolarisation | « NISQ typique » |

Les paramètres du canal combiné et leur ordre de composition sont provisoires. Ils doivent être remplacés par les valeurs de la [fiche des paramètres](fiche_parametres_canaux_fr.md) **[à arrêter par l'équipe]**.

## 3. Contrôles

| Contrôle | Mise en œuvre | Attendu |
|---|---|---|
| Négatif (prédiction 4) | même preuve lue et recopiée comme chaîne de bits, canal identité | $\hat\eta_q = 0$ exactement |
| Bruit nul | niveau 0 de chaque canal | $\hat\eta_q = 0$ |
| Plafond | $\hat\eta_q \leq I(V^q;\rho_\Sigma\mid C)/H(C)$ | toujours vérifié |
| Heuristique AFW (prédiction 2) | $\Delta I \leq 2\varepsilon\log_2|\mathcal{V}| + 2(1+\varepsilon)\,h(\varepsilon/(1+\varepsilon))$, avec $\varepsilon$ la distance de trace moyenne | indicatif |

Le contrôle AFW utilise la distance de trace moyenne entre états codés et états dégradés. La borne d'Alicki-Fannes-Winter porte en toute rigueur sur l'état joint. Le contrôle reste donc heuristique, comme dans la thèse.

## 4. Sorties

Une ligne par exécution dans le [gabarit](gabarit_simulation_fr.csv). Les colonnes sont `id_execution`, `graine` (version du plan), `canal`, `parametre_bruit`, `type_preuve`, `encodage` (`quantum` ou `bitstring`), `n_qubits`, `H_C_bits`, `I_avant_bits`, `I_apres_bits`, `delta_I_bits`, `eta_chapeau`, `fidelite_moyenne`, `distance_trace` et `remarques`.

`plan-v0.1` produit 200 lignes, soit 2 tailles × 2 valeurs de $H(C)$ × 25 niveaux × 2 encodages.

## 5. Synthèse

`cro_terrain.p6.summarize` regroupe les exécutions par canal, encodage, nombre de qubits et $H(C)$. Pour chaque groupe, elle donne $\hat\eta_q$ maximal, la pente de $\hat\eta_q$ en fonction du paramètre, la monotonie, le plafond et le respect de l'heuristique AFW. `p6.check_predictions` lit les quatre prédictions.

## 6. Modifications du plan

Toute modification (paramètres sourcés, nouveaux canaux, plus de qubits) crée une nouvelle version `plan-vX.Y`. Elle est consignée ici avant exécution, avec sa date et son motif.

| Version | Date | Modification | Motif |
|---|---|---|---|
| plan-v0.1 | 12/10/2026 | plan initial | proposition |
| | | | |

Licence CC BY 4.0.
