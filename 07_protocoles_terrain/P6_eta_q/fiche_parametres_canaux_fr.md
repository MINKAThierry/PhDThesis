# Fiche des paramètres de canaux (P6)

> **Statut : PROPOSITION — scénario hypothétique** · Source : thèse, chapitre 4, §4.2.6.2 (« paramètres de bruit calibrés sur les spécifications de matériel quantique actuel (IBM Quantum, IonQ, etc.) »)

[English version](fiche_parametres_canaux_en.md) · [Protocole P6](protocole_fr.md) · [Plan de simulation](plan_simulation_fr.md)

La fiche relève, pour chaque plateforme retenue, les taux d'erreur publiés par le fournisseur, puis leur conversion en paramètres de canal. **Aucune valeur n'est préremplie.** Les spécifications changent souvent et chaque valeur doit porter sa source et sa date de consultation.

## 1. Relevé par plateforme

| Plateforme | Processeur ou modèle | Source (URL ou document) | Date de consultation | Erreur à 1 qubit | Erreur à 2 qubits | $T_1$ | $T_2$ | Durée d'une porte | Erreur de lecture |
|---|---|---|---|---|---|---|---|---|---|
| | | | __/__/____ | | | | | | |
| | | | __/__/____ | | | | | | |
| | | | __/__/____ | | | | | | |

Relevé fait par ______ et vérifié par ______.

## 2. Conversion en paramètres de canal

Conversions usuelles, à vérifier par l'équipe et à citer dans le pré-enregistrement **[à arrêter par l'équipe]**.

| Paramètre du modèle | Conversion proposée | Valeur retenue |
|---|---|---|
| $p_{\text{dep}}$ (dépolarisation globale sur $d = 2^n$ dimensions) | erreur moyenne de porte $r$ du registre, $p_{\text{dep}} = r\,d/(d-1)$ pour le canal $(1-p)\rho + p\,I_d/d$ (soit $2r$ pour un qubit) | ______ |
| $\gamma_{\text{AD}}$ (amortissement) | $\gamma = 1 - e^{-t/T_1}$ pour une durée de stockage ou de traitement $t$ | ______ (avec $t =$ ______) |
| $p_{\text{deph}}$ (déphasage) | déphasage pur $1/T_\phi = 1/T_2 - 1/(2T_1)$, $p = \tfrac12\bigl(1 - e^{-t/T_\phi}\bigr)$ | ______ |
| Durée $t$ du scénario | durée de stockage ou de vérification supposée | ______ |

## 3. Paramètres du canal combiné

| Paramètre | Valeur provisoire de `plan-v0.1` | Valeur sourcée retenue | Source |
|---|---|---|---|
| $p_{\text{dep}}$ | 0,01 | | |
| $p_{\text{deph}}$ | 0,01 | | |
| $\gamma_{\text{AD}}$ | 0,005 | | |
| Ordre de composition | amortissement, déphasage, dépolarisation | | |

## 4. Contrôle par les experts

Les paramètres retenus sont soumis au panel d'experts avec la [fiche d'élicitation](fiche_elicitation_experts_fr.md), partie B.

Accord du panel sur les paramètres ☐ oui ☐ avec modifications, consignées ci-dessous

______________________________________________________________________

Licence CC BY 4.0.
