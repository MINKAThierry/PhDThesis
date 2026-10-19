# Apports de la thèse par rapport aux articles publiés

> **Statut : PROPOSITION: résultat de thèse** · Source : thèse, chapitres 2, 3 et 4 (sources dans [`../00_these/manuscrit/`](../00_these/manuscrit/))

[English version](resultats_these_en.md)

Ce document recense, énoncé par énoncé, ce que la thèse ajoute ou précise par rapport aux trois articles publiés P1 (cadre CLO), P2 (Trilemme CRO conditionnel) et P3 (extension post-quantique), décrits dans [`../01_publie/`](../01_publie/). Chaque entrée donne le label LaTeX de l'énoncé dans les sources de la thèse, sa numérotation et sa section dans le PDF de dépôt, l'article concerné et la formule exacte. Les articles publiés ne sont pas réécrits. Tant que la thèse n'est pas soutenue, chaque entrée garde le statut de proposition ; certaines entrées portent en plus une sous-étiquette plus précise (construction, conjecture, calibration illustrative, protocole non déployé), indiquée en tête de l'entrée.

Notations. $M$ est le message, $C$ le contexte institutionnel, $\Sigma$ la preuve, $V$ le verdict, $\lambda$ le paramètre de sécurité. Les paramètres institutionnels sont la capacité d'extraction $\Delta$, la granularité des verdicts $\alpha$, la régularité $\beta$, la constante de régime $\kappa$ et $\gamma=\alpha H(C)-1$ ; leurs analogues quantiques sont $\Delta_q$, $\alpha_q$, $\beta_q$, $\theta_q$, $\gamma_q=\theta_q\alpha_q H(C)$ et la perte d'interprétabilité $\eta_q$.

## Vue d'ensemble

| N° | Énoncé | Label principal | Section | Article | Nature |
|---|---|---|---|---|---|
| R1 | Fiabilités $\mathrm{Rel}_{\mathrm{rec}}$ et $\mathrm{Rel}_{\mathrm{ver}}$ | `def:fiabilite_clo`, `rem:rel_ver` | §2.2.2.2 | P1, P2 | Précision |
| R2 | Goulot contextuel $\le\alpha H(C)$ | `thm:goulot_contexte` | §2.2.3 | P1 | Formulation précisée |
| R3 | Verdict déterministe $\Rightarrow\mathrm{Opp}=1$ | `rem:verdict_deterministe` | §2.2.3 | P1 | Ajout |
| R4 | Règles de composition précisées | `thm:composition_sequentielle` | §2.2.3 | P1 | Formulation précisée |
| R5 | Interprète admissible (option A) | `def:interp_admissible` | §2.3.1.2 | P1, P2 | Ajout |
| R6 | Proposition de fondement de l'Hypothèse 1 | `prop:fondement_extraction` | §2.3.1.2 | P2 | Ajout |
| R7 | Trilemme classique sous hypothèses explicites | `thm:trilemme_cro_conditionnel` | §2.3.1.2, §2.3.2 | P2 | Formulation précisée |
| R8 | Forme raffinée, seuil $H^\sharp$, régimes rare et riche | `eq:trilemme_cro_raffine`, `rem:activite_delta` | §2.3.2, §2.3.4 | P2 | Ajout |
| R9 | Portée des cas d'étude | `rem:portee_cas_etude` | §2.3.3, §2.3.5 | P1, P2, P3 | Précision |
| R10 | Définition unique de $\eta_q$ | `def:perte_interp_quantique_pq` | §2.2.4.2, §2.4.2.3 | P3 | Formulation précisée |
| R11 | Trilemme quantique sous hypothèses explicites | `thm:trilemme_pq` | §2.4.3, §2.4.4 | P3 | Formulation précisée |
| R12 | Forme raffinée quantique et seuil $H^\sharp_q$ | `rem:forme_raffinee_pq` | §2.4.4, §2.4.5 | P3 | Ajout |
| R13 | Statut des résultats SOTP | `rem:statut_sotp`, `conj:optimalite_universelle` | §3.1 à §3.3 | P1 | Requalification |
| R14 | Table unique des paramètres de référence | `tab:parametres_reference` | §4.1.3 | P1, P2, P3 | Ajout |
| R15 | Estimateur $\hat\Delta=\hat I(V;\Sigma\mid M,C)$ | `eq:estimateur_delta` | §4.2.1 | P2 | Ajout |
| R16 | Critères de réfutation pré-enregistrés | `tab:criteres_refutation` | §4.2.7.3 | P2, P3 | Ajout |

---

## R1. Fiabilité de reconstruction et fiabilité de vérification

- **Labels** : `def:fiabilite_clo` (Définition 2.3, équation `eq:rel_clo`), `rem:rel_ver` (Remarque 2.2, équation `eq:rel_ver`)
- **Section** : §2.2.2.2, fichier `chap2/clo.tex`
- **Articles** : P1 (fiabilité opérationnelle), P2 (fiabilité utilisée dans l'étape de Fano)

La thèse distingue deux notions que les articles confondaient. La fiabilité de reconstruction est celle du trilemme,

$$\mathrm{Rel}(\mathcal P):=\mathrm{Rel}_{\mathrm{rec}}(\mathcal P)=1-\min_{\mathsf{Dec}}\Pr\bigl[\mathsf{Dec}(\Sigma,C)\neq M\bigr].$$

La fiabilité opérationnelle de P1 est la complétude de la vérification, assortie de sa solidité,

$$\mathrm{Rel}_{\mathrm{ver}}(\mathcal P)=\min_{m,c}\Pr\bigl[\mathsf{Verify}(pk,\mathsf{Prove}(sk,m,c),c)=1\bigr].$$

Pour $M$ uniforme sur $\{0,1\}^\lambda$, $\mathrm{Conf}=1$ entraîne $\Sigma\perp M\mid C$ et donc $\mathrm{Rel}_{\mathrm{rec}}=2^{-\lambda}$, alors que $\mathrm{Rel}_{\mathrm{ver}}$ peut valoir 1 (engagement parfaitement masquant). Le trilemme porte sur $\mathrm{Rel}_{\mathrm{rec}}$, seule notion à laquelle s'applique l'inégalité de Fano.

## R2. Goulot contextuel plafonné par $\alpha H(C)$

- **Label** : `thm:goulot_contexte` (Théorème 2.2, équation `eq:goulot_contextuel`)
- **Section** : §2.2.3, fichier `chap2/clo.tex`
- **Article** : P1 (théorème de goulot contextuel, extraction plafonnée par $H(C)$)

$$I(V;\Sigma\mid C)\le\min\bigl\{H(\Sigma\mid C),\,H(V\mid C)\bigr\}\le\log_2\lvert\mathcal V_\lambda\rvert\le\alpha\,H(C).$$

Le plafond de l'information extractible est fixé par la granularité institutionnelle des verdicts $\alpha$, rapportée à la richesse du contexte. La version de P1 plafonnait l'extraction par $H(C)$ seul.

## R3. Verdict déterministe et opposabilité triviale

- **Label** : `rem:verdict_deterministe` (Remarque 2.4)
- **Section** : §2.2.3, fichier `chap2/clo.tex` ; extension Lean au §3.4.8
- **Article** : P1 (interprétation $V=\mathsf{Interpret}(\Sigma,C)$ déterministe)

Si $V$ est une fonction déterministe de $(\Sigma,C)$, alors $H(V\mid\Sigma,C)=0$ et $I(V;\Sigma\mid C)=H(V\mid C)$, de sorte que $\mathrm{Opp}=1$ dès que $H(V\mid C)>0$, quel que soit le protocole. La mesure $\mathrm{Opp}$ ne discrimine donc les protocoles que pour des interprétations admissibles (R5). Sous les Hypothèses 1 et 2′, un verdict déterministe impose en outre $\Delta\ge\gamma-I(M;\Sigma\mid C)$, ce qui place l'institution dans le régime où la borne se réduit à celle de Fano (R8). Ces deux faits sont certifiés en Lean (`opp_eq_one_of_deterministic`, `deterministic_forces_capacity`).

## R4. Règles de composition précisées

- **Labels** : `thm:composition_sequentielle` (Théorème 2.3, équations `eq:comp_seq_conf`, `eq:comp_seq_rel`, `eq:comp_par_conf`, `eq:comp_par_rel`), `rem:composition_opp` (Remarque 2.5)
- **Section** : §2.2.3, fichier `chap2/clo.tex`
- **Article** : P1 (théorèmes de composition séquentielle et parallèle)

Pour la composition séquentielle $\mathcal P_1\circ\mathcal P_2$, qui publie un post-traitement $\Sigma_2=\mathcal P_2(\Sigma_1)$ indépendant de $M$ sachant $(\Sigma_1,C)$,

$$\mathrm{Conf}(\mathcal P_1\circ\mathcal P_2)\ge\mathrm{Conf}(\mathcal P_1),\qquad \mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1\circ\mathcal P_2)\le\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1).$$

Pour la composition parallèle $\mathcal P_1\Vert\mathcal P_2$, qui publie $(\Sigma_1,\Sigma_2)$ produits indépendamment sachant $(M,C)$,

$$\mathrm{Conf}(\mathcal P_1\Vert\mathcal P_2)\le\min\{\mathrm{Conf}(\mathcal P_1),\mathrm{Conf}(\mathcal P_2)\},\qquad \mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1\Vert\mathcal P_2)\ge\max\{\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_1),\mathrm{Rel}_{\mathrm{rec}}(\mathcal P_2)\}.$$

Pour l'opposabilité, la chaîne $V$–$(\Sigma_1,C)$–$(\Sigma_2,C)$ donne $\mathrm{Opp}(\mathcal P_1\circ\mathcal P_2)\le\mathrm{Opp}(\mathcal P_1)$ à verdict fixé. Aucune règle générale ne vaut en parallèle. Les règles de P1 ($\mathrm{Opp}\ge\min$ en séquentiel, $\mathrm{Opp}\approx$ produit en parallèle) sont traitées comme des heuristiques. La minoration par le produit, tirée de l'inégalité de Fréchet, est écartée, car cette inégalité donne $ab\ge a+b-1$ dans l'autre sens.

## R5. Interprète admissible (option A)

- **Label** : `def:interp_admissible` (Définition 2.13, équation `eq:interp_admissible`)
- **Section** : §2.3.1.2, fichier `chap2/cro_classique.tex`
- **Articles** : P1 (verdict déterministe), P2 (Hypothèse 1 posée sans fondement structurel)

Une interprétation est admissible si le verdict s'écrit $V=\mathsf{Interpret}(\Sigma,C,K)$, où $K$ représente les ressources propres de l'institution (jurisprudence, expertise, délibération, aléas de décision) et vérifie

$$K\perp M\mid(\Sigma,C).$$

L'institution n'accède au message que par la preuve, de sorte que $M\to(\Sigma,C)\to V$ est une chaîne de Markov. Le verdict peut être stochastique. Cette définition fonde l'Hypothèse 1 plus directement que la dérivation initiale, qui passait par une règle de chaîne moins précise.

## R6. Proposition de fondement de l'Hypothèse d'extraction bornée

- **Label** : `prop:fondement_extraction` (Proposition 2.1, équations `eq:fondement_extraction`, `eq:extraction_bornee_forte`)
- **Section** : §2.3.1.2, fichier `chap2/cro_classique.tex`
- **Article** : P2 (Hypothèse 1, $I(V;\Sigma\mid C)\le I(M;\Sigma\mid C)+\Delta$)

Pour toute interprétation admissible,

$$I(V;\Sigma\mid C)=I(V;M\mid C)+I(V;\Sigma\mid M,C)\le I(M;\Sigma\mid C)+I(V;\Sigma\mid M,C).$$

L'Hypothèse 1 est donc satisfaite dès que $I(V;\Sigma\mid M,C)\le\Delta$. La capacité $\Delta$ s'interprète exactement comme l'information que l'institution tire de la preuve au-delà du message. La preuve applique deux fois la règle de chaîne à $I(V;M,\Sigma\mid C)$, utilise $I(V;M\mid\Sigma,C)=0$ (admissibilité) puis l'inégalité de traitement des données sur $M\to(\Sigma,C)\to V$.

## R7. Trilemme classique sous hypothèses explicites

- **Labels** : `ass:verdicts_efficace` (Hypothèse 2.2), `ass:regime` (Hypothèse 2.4), `lem:confidentiality_guarantee` (Lemme 2.3), `thm:trilemme_cro_conditionnel` (Théorème 2.4, équations `eq:trilemme_cro_conditionnel`, `eq:trilemme_cro_explicite`), `rem:scope_trilemme_classique` (Remarque 2.17), `rem:constante_c0` (Remarque 2.15)
- **Section** : §2.3.1.2 et §2.3.2, fichier `chap2/cro_classique.tex` ; formulations alternatives retracées au §3.4.9
- **Article** : P2 (Lemme 4, Hypothèse 2, Théorème 1, Remarque 10)

Ces formulations sont aussi le contenu du document soumis pour P2 ([`../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/)).

- Le lemme de confidentialité devient une minoration, $\mathrm{Conf}(\mathcal P)\ge 1-\sqrt{c_0\beta\, I(M;\Sigma\mid C)}$, avec $c_0=1/(2\ln 2)$ valide mais non serrée.
- L'efficacité du verdict est posée explicitement, $\lvert\mathcal V_\lambda\rvert\le 2^{\alpha H(C)}$ et $H(V\mid C)\ge\alpha H(C)-1=:\gamma\ge 1$.
- Le régime de fuite est posé explicitement, $I(M;\Sigma\mid C)\le\kappa/\lambda$, car la résolution alternative de l'optimisation qui devait le produire ne le fournit pas.

Sous les Hypothèses 1, 2′, 3 et 4, pour $\lambda\ge 64$, $H(M)=\lambda$ et $M\perp C$,

$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1}{\gamma}\left(\frac{\Delta}{\lambda}+\frac{\kappa(\Delta+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$

L'Hypothèse 4 est nécessaire. Le protocole qui révèle $M$ avec probabilité $1/2$ et produit sinon une preuve uniforme satisfait les Hypothèses 1 à 3 avec $\beta\le 1{,}04$ et vérifie $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\approx 1/4$ pour tout $\lambda$ (voir [`../05_formalisation_lean/cas_limite/`](../05_formalisation_lean/cas_limite/) et le contrôle V6 de [`../06_calcul/`](../06_calcul/)). Le noyau algébrique est certifié en Lean (`trilemma_explicit`, `conditional_CRO_trilemma`, `regime_assumption_necessary`).

## R8. Forme raffinée du trilemme, seuil $H^\sharp$ et régimes

- **Labels** : `eq:trilemme_cro_raffine` (Théorème 2.4), `rem:activite_delta` (Remarque 2.16, équation `eq:seuil_activite`), `subsec:regimes_operationnels`, `tab:regimes_operationnels` (Tableau 2.1)
- **Section** : §2.3.2 et §2.3.4, fichier `chap2/cro_classique.tex` ; extension Lean au §3.4.8
- **Article** : P2 (absent)

Sous les mêmes hypothèses,

$$\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}\le\frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda+\Delta}{\gamma}\right\}.$$

Le facteur $\min\{\cdot\}$ est strictement inférieur à 1 si et seulement si

$$\Delta<\gamma-\frac{\kappa}{\lambda}\iff H(C)>H^\sharp:=\frac{\Delta+1+\kappa/\lambda}{\alpha}.$$

| Régime | Condition | Borne | Contrainte liante |
|---|---|---|---|
| Contexte rare | $H(C)\le H^\sharp$ | $(1+\kappa/\lambda)/\lambda$ (Fano) | fiabilité de reconstruction |
| Contexte riche | $H(C)>H^\sharp$ | $\frac{1+\kappa/\lambda}{\lambda}\cdot\frac{\kappa/\lambda+\Delta}{\gamma}$ | capacité institutionnelle $\Delta$ |

Dans l'exemple de la thèse ($\Delta=5$, $\alpha=1$, $H(C)=20$, $\gamma=19$, $\kappa=1$, $\lambda=128$), la forme raffinée donne environ $2{,}1\cdot10^{-3}$ contre $7{,}9\cdot10^{-3}$ pour Fano seul. Avec $\Delta=35$ dans le même contexte, $\Delta>\gamma$ et la borne retombe sur celle de Fano. Certifié en Lean (`trilemma_refined`, `refined_bound_is_fano_when_delta_ge_gamma`).

## R9. Portée des cas d'étude

> Sous-étiquette : **calibration illustrative**

- **Labels** : `rem:portee_cas_etude` (Remarque 2.19), `tab:validation_cro_classique` (Tableau 2.2), `subsec:analyse_coherence_pq` (tableaux `tab:validation_classiques_pq`, `tab:validation_pqc`)
- **Section** : §2.3.3, §2.3.5 et §2.4.6, fichiers `chap2/cro_classique.tex` et `chap2/cro_pq.tex`
- **Articles** : P1 (études de cas), P2 (tableau 2, capacités implicites 35 à 73 bits), P3 (tableaux 8 à 10)

Sous l'Hypothèse 4, l'étape de Fano donne $\mathrm{Rel}_{\mathrm{rec}}\le(1+\kappa/\lambda)/\lambda\approx 0{,}008$ à $\lambda=128$. Les systèmes déployés de référence (Helios, zk-SNARKs, ECDSA, signatures NIST PQC), dont la fiabilité $\mathrm{Rel}_{\mathrm{ver}}$ est proche de 1, ne sont donc pas des instances du théorème. Leurs métriques CLO sont exprimées sur l'échelle opérationnelle de P1. Les capacités implicites, définies par $\Delta:=\lambda\cdot(\mathrm{Conf}\cdot\mathrm{Rel}_{\mathrm{ver}}\cdot\mathrm{Opp})$, sont une calibration illustrative des ordres de grandeur, circulaire par construction ; elles ne valident ni ne réfutent la borne. Le théorème s'applique aux protocoles à fuite contrôlée, dont les engagements parfaitement masquants et les preuves à divulgation nulle de connaissance sont les exemples canoniques.

## R10. Définition unique de $\eta_q$

- **Labels** : `def:perte_interp_quantique` (Définition 2.9, équation `eq:def_eta_q`), `def:perte_interp_quantique_pq` (Définition 2.27, équation `eq:eta_q_definition`), `rem:interpretation_physique_pq` (Remarque 2.22), `ass:regularite_quantique` (Hypothèse 2.7)
- **Section** : §2.2.4.2 et §2.4.2.3, fichiers `chap2/clo.tex` et `chap2/cro_pq.tex`
- **Article** : P3 ($\eta_q$ défini par une distance de trace normalisée et employé aussi comme constante de régularité)

Soit $\Lambda$ une application CPTP représentant les effets d'un canal quantique sur le support de la preuve. La perte d'interprétabilité quantique $\eta_q\in[0,1]$ est le plus petit réel tel que

$$I(V;\Lambda(\Sigma)\mid C)\ge I(V;\Sigma\mid C)-\eta_q\,H(C).$$

C'est l'unique définition de $\eta_q$ employée dans la thèse. Par l'inégalité de traitement des données, un canal ne peut que réduire l'opposabilité et $\eta_q$ mesure l'ampleur maximale de cette réduction. Pour une preuve qui est une chaîne de bits classique, y compris les signatures ML-DSA, SLH-DSA et Falcon, $\Lambda$ est l'identité et $\eta_q=0$ ; les valeurs $\eta_q>0$ décrivent un scénario hypothétique de support ou de vérificateur quantique. La constante de régularité de l'Hypothèse de régularité quantique est renommée $\zeta_q$, distincte de $\eta_q$.

## R11. Trilemme quantique sous hypothèses explicites

- **Labels** : `rem:retrait_lemma6` (Remarque 2.27), `lem:q_conf_mi_pq` (Lemme 2.8), `rem:interp_lemme7` (Remarque 2.28), `ass:verdict_quantique` (Hypothèse 2.6), `ass:regime_quantique` (Hypothèse 2.8), `thm:trilemme_pq` (Théorème 2.5), `rem:scope_trilemme_pq` (Remarque 2.29)
- **Section** : §2.4.3 et §2.4.4, fichier `chap2/cro_pq.tex`
- **Article** : P3 (Lemmes 6 et 7, Hypothèses 4 et 5, Théorème 2, Remarque 17)

La plupart de ces formulations sont aussi le contenu du document soumis pour P3 ([`../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/`](../01_publie/P3_PQCRO_IEEEAccess2026/formulations_precisees/)).

- La formulation se passe du Lemme 6 (cas limite des états orthogonaux) et de la majoration (72) du Lemme 7.
- Le lemme de confidentialité quantique s'énonce avec l'information de Holevo, $\mathrm{Conf}^q(\mathcal P)\ge 1-\tfrac12\sqrt{2\beta_q\chi_{\max}+2\zeta_q D_{\max}}$.
- L'efficacité du verdict est posée explicitement, $H(V\mid C)\ge\theta_q\alpha_q H(C)=:\gamma_q\ge 1$.
- Le régime de fuite est posé explicitement lui aussi, $\chi_{\max}\le\kappa/\lambda$.

Sous ces hypothèses, pour $\lambda\ge 64$, $H(M)=\lambda$ et $M\perp C$,

$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1}{\gamma_q}\left(\frac{\Delta_q}{\lambda}+\frac{\kappa(\Delta_q+1)}{\lambda^2}+\frac{\kappa^2}{\lambda^3}\right)\le\frac{\Delta_q+\eta_q H(C)}{\lambda}+O(\lambda^{-2})+\mathrm{negl}(\lambda).$$

Le terme $\eta_q H(C)$ n'apparaît que dans la majoration affaiblie. La thèse va plus loin que le document soumis sur un point. Pour une preuve classique de $n$ bits, $D_{\max}=n-H(\Sigma\mid C=c)$ vaut plusieurs milliers de bits pour les signatures NIST PQC (plus de $2{,}6\cdot10^4$ bits pour ML-DSA-65, dont la signature compte 3 309 octets) ; leur confidentialité doit donc être établie par le lemme classique appliqué à l'issue classique. Le document soumis pose encore $D_{\max}=\mathrm{negl}(\lambda)$ pour ces schémas.

## R12. Forme raffinée quantique et seuil $H^\sharp_q$

- **Labels** : `rem:forme_raffinee_pq` (Remarque 2.31, équation `eq:trilemme_pq_raffine`), `subsec:regimes_quantiques`, `tab:regimes_quantiques_comp` (Tableau 2.4)
- **Section** : §2.4.4 et §2.4.5, fichier `chap2/cro_pq.tex`
- **Article** : P3 (absent)

$$\mathrm{Conf}^q\cdot\mathrm{Rel}^q\cdot\mathrm{Opp}^q\le\frac{1+\kappa/\lambda}{\lambda}\,\min\left\{1,\;\frac{\kappa/\lambda+\Delta_q}{\gamma_q}\right\}.$$

La capacité quantique est contraignante si et seulement si $\Delta_q<\gamma_q-\kappa/\lambda$, soit

$$H(C)>H^\sharp_q:=\frac{\Delta_q+\kappa/\lambda}{\theta_q\alpha_q}.$$

Le coefficient $\eta_q$ n'intervient ni dans cette forme ni dans la distinction des régimes. Les profils de migration (début de migration, institutions formées, institutions expertes) décrivent des niveaux de capacité et restent illustratifs.

## R13. Statut des résultats SOTP

> Sous-étiquettes : **construction** (familles S-OTP et SOTP) et **conjecture** (optimalité universelle)

- **Labels** : `rem:statut_sotp` (Remarque 3.1), `thm:proprietes_sotp` (Théorème 3.1), `thm:optimalite_sotp` (Remarque 3.3), `thm:saturation_sotp_low`, `thm:saturation_sotp_base`, `thm:saturation_sotp_high` (Propositions 3.1 à 3.3), `rem:facteur_limitant_low`, `rem:heuristique_sotp_base`, `rem:heuristique_sotp_high` (Remarques 3.4 à 3.6), `conj:optimalite_universelle` (Conjecture 3.1), `rem:statut_optimalite` (Remarque 3.7)
- **Section** : §3.1, §3.2, §3.3.2.3, §3.3.3.3, §3.3.4.3 et §3.3.6, fichiers `chap3/introduction_chap3.tex`, `chap3/sotp_base.tex`, `chap3/sotp_construction.tex`
- **Article** : P1 (optimalité de S-OTP dans la classe OTP) ; la famille SOTP elle-même relève d'une soumission distincte (voir [`../04_sotp/`](../04_sotp/))

| Énoncé | Statut dans la thèse |
|---|---|
| Propriétés cryptographiques de S-OTP, SOTP-Low, SOTP-Base, SOTP-High (confidentialité, $\mathrm{Rel}_{\mathrm{ver}}=1-\mathrm{negl}(\lambda)$, préservation JL des distances) | Propositions prouvées sous PRG, DLog, q-SDH et q-PKE |
| Minorations d'opposabilité $0{,}75\,\Delta/\lambda$, $0{,}5\min\{\Delta/d,\Delta/(\beta\log_2 d)\}$, $0{,}45\,\beta\log_2\lambda/\lambda$ | Heuristiques de conception, non prouvées |
| Optimalité de S-OTP dans la classe OTP | Argument heuristique ; la preuve demande une définition formelle de la classe |
| Optimalité universelle de la famille SOTP | Conjecture |

Les métriques SOTP sont exprimées sur l'échelle opérationnelle ($\mathrm{Rel}_{\mathrm{ver}}$) et ne sont pas comparées à la borne. Les composantes de preuve qui ne dépendent que du contexte public $C$ n'apportent aucune information conditionnelle, puisque $I(V;g(C)\mid C)=0$ ; la couche Clay est analysée comme un format de présentation. La conjecture s'énonce ainsi. Sous les Hypothèses 1 à 4, pour chaque régime, il existe une variante SOTP et une constante $C_R\ge 1$ indépendante de $\lambda$ telles que, pour tout protocole CLO $\mathcal P'$ du même régime,

$$\mathrm{Conf}(\mathcal P')\,\mathrm{Rel}_{\mathrm{rec}}(\mathcal P')\,\mathrm{Opp}(\mathcal P')\le C_R\cdot\mathrm{Conf}(\mathrm{SOTP})\,\mathrm{Rel}_{\mathrm{rec}}(\mathrm{SOTP})\,\mathrm{Opp}(\mathrm{SOTP}).$$

## R14. Table unique des paramètres de référence

> Sous-étiquette : **calibration illustrative**

- **Labels** : `subsec:parametres_reference`, `tab:parametres_reference` (Tableau 4.2)
- **Section** : §4.1.3, fichier `chap4/introduction_chap4.tex` ; données dans [`../06_calcul/data/parametres_reference.csv`](../06_calcul/data/parametres_reference.csv) et [`../06_calcul/data/calibration_pq.csv`](../06_calcul/data/calibration_pq.csv)
- **Articles** : P1, P2, P3 (jeux de valeurs incompatibles pour $H(C)$ et $\Delta_q$ dans les formulations initiales)

| Système | $H(C)$ domaine | $H(C)$ espèce | $\alpha$ | $\Delta$ | $\Delta_q$ / $\eta_q$ |
|---|---|---|---|---|---|
| ECDSA (contrat) | 20 | 20 | 1,0 | 35 | — |
| Helios (scrutin) | 40 | 8 | 1,2 | 56 | — |
| zk-SNARKs (AML) | 70 | 11 | 1,5 | 73 | — |
| ML-DSA-65 (contrat) | 20 | 10,5 | 1,0 | — | 28 (hyp.) / 0 |

Entropies en bits. Le contexte « domaine » désigne la richesse du contexte institutionnel général ; le contexte « espèce » celui d'une décision particulière (§4.3). Pour ML-DSA-65, $\eta_q=0$ car la signature est une chaîne de bits classique. La valeur $\Delta_q=28$ bits est une hypothèse de travail à estimer par le protocole du §4.2.5. Toute valeur employée ailleurs dans la thèse renvoie à cette table.

## R15. Estimateur de la capacité d'extraction

> Sous-étiquette : **protocole non déployé**

- **Labels** : `eq:estimateur_delta` (équation 4.2), `def:capacite_extraction_op` (Définition 4.1) ; analogue quantique `eq:estimateur_delta_q` (équation 4.7)
- **Section** : §4.2.1 et §4.2.5, fichier `chap4/protocoles.tex`
- **Article** : P2 (protocole de validation fondé sur une différence d'informations)

Par la Proposition de fondement (R6), la quantité contrôlée par l'Hypothèse 1 est $I(V;\Sigma\mid M,C)$. L'estimateur retenu est

$$\hat\Delta=\hat I(V;\Sigma\mid M,C),$$

calculé sur les triplets $(v_i,\sigma_i,m_i)$ recueillis à contexte $c$ fixé, avec un estimateur plug-in corrigé de Miller–Madow ou de type NSB pour les petits échantillons. Le message $m_i$ est connu de l'expérimentateur mais non des participants. L'intervalle de confiance est obtenu par bootstrap non paramétrique sur les participants. L'estimateur de la formulation initiale, $I_{\mathrm{emp}}(V;\Sigma\mid C)-I_{\mathrm{vrai}}(M;\Sigma\mid C)$, est remplacé, car il est systématiquement négatif pour un protocole fiable. L'analogue quantique est $\hat\Delta_q=\hat I(V^q;\Sigma\mid M,C)$. Aucune mesure n'a été réalisée.

## R16. Critères de réfutation pré-enregistrés

> Sous-étiquette : **protocole non déployé**

- **Label** : `tab:criteres_refutation` (Tableau 4.7)
- **Section** : §4.2.7.3, fichier `chap4/protocoles.tex`
- **Articles** : P2, P3 (pistes de validation sans critères de réfutation)

| Paramètre | L'hypothèse est réfutée si… |
|---|---|
| $\Delta$ (Hypothèse 1) | la borne inférieure de l'IC à 95 % de $\hat I(V;\Sigma\mid M,C)$ dépasse la capacité fixée avant l'expérience pour la population étudiée |
| Admissibilité (Définition `def:interp_admissible`) | un test de permutation rejette $V\perp M\mid(\Sigma,C)$ au seuil 0,01 |
| $\gamma$ (Hypothèse 2′) | la borne supérieure de l'IC à 95 % de $\hat H(V\mid C)$ est inférieure à $\alpha H(C)-1$ |
| $\eta_q$ (scénario quantique) | l'IC à 95 % de $\hat\eta_q$ exclut l'intervalle prédit avant l'expérience |
| Borne (hypothèses vérifiées) | le produit mesuré dépasse la forme raffinée de la borne avec une confiance de 95 % |

Les valeurs seuils sont indicatives et seront arrêtées lors du pré-enregistrement ; leur forme constitue l'engagement méthodologique. Les protocoles de mesure correspondants sont décrits dans [`../07_protocoles_terrain/`](../07_protocoles_terrain/).
