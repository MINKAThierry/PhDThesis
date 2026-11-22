> **Statut : PROPOSITION — construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, chapitre 3, §3.1 (introduction), §3.2 (`sec:sotp_base`) et §3.3 (`sec:sotp_construction`)

# Spécification de la famille SOTP

*English version: [sotp_specification_en.md](sotp_specification_en.md)*

Ce document reprend fidèlement les constructions S-OTP et SOTP de la thèse. Les énoncés (théorème, propositions, remarques, conjecture) et les algorithmes sont recopiés sans modification de fond. Les renvois internes à la thèse sont donnés par leur étiquette LaTeX (par exemple `rem:rel_ver`) et les références bibliographiques par leur clé (par exemple [Pedersen91]). Les notes de transcription signalent les points où le texte source présente une incohérence ou une ambiguïté ; elles ne modifient aucun énoncé.

## Table des matières

1. [Statut des résultats](#1-statut-des-résultats)
2. [Le paradigme Gold-Iron-Clay](#2-le-paradigme-gold-iron-clay)
3. [S-OTP, prototype](#3-s-otp-prototype)
4. [Architecture commune de la famille SOTP](#4-architecture-commune-de-la-famille-sotp)
5. [SOTP-Low quand le contexte exact est requis](#5-sotp-low-quand-le-contexte-exact-est-requis)
6. [SOTP-Base quand la proximité entre contextes compte](#6-sotp-base-quand-la-proximité-entre-contextes-compte)
7. [SOTP-High au-delà du seuil de capacité](#7-sotp-high-au-delà-du-seuil-de-capacité)
8. [Synthèse et sélection de variante](#8-synthèse-et-sélection-de-variante)
9. [Conjecture d'optimalité universelle et analyse de sensibilité](#9-conjecture-doptimalité-universelle-et-analyse-de-sensibilité)
10. [Extension quantique](#10-extension-quantique)
11. [Notes de transcription](#11-notes-de-transcription)

---

## 1. Statut des résultats

Le seuil $H^\sharp$ du théorème sépare deux régimes. SOTP-Low et SOTP-Base servent de référence en contexte rare ($H(\mathcal{C}) \leq H^\sharp$), selon que l'institution a besoin du contexte exact ou d'une représentation qui préserve la proximité entre contextes. SOTP-High sert de référence en contexte riche. Leurs propriétés cryptographiques sont prouvées ; leur optimalité, qui porte sur l'opposabilité des protocoles à fuite négligeable, reste une conjecture.

**Remarque `rem:statut_sotp` (Statut des résultats de ce chapitre).** Les constructions S-OTP et SOTP sont évaluées sur l'échelle opérationnelle CLO, qui combine confidentialité statistique, fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$ (Remarque `rem:rel_ver`) et opposabilité sous des conventions d'interprétation explicites. Ces métriques ne sont pas comparées à la borne du Théorème `thm:trilemme_cro_conditionnel`, qui porte sur $\mathsf{Rel}_{\mathrm{rec}}$ et énonce que, pour tout protocole à confidentialité statistique $1-\mathrm{negl}(\lambda)$, $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$. Que les variantes SOTP atteignent, à une constante près, la meilleure opposabilité permise aux protocoles à fuite négligeable est formulé comme conjecture (Conjecture `conj:optimalite_universelle`). Les composantes de preuve qui ne dépendent que du contexte public $C$ n'apportent aucune information conditionnelle, puisque $I(V; g(C) \mid C) = 0$ pour toute fonction $g$. La couche Clay est donc analysée comme un *format de présentation* qui facilite l'interprétation (baisse du coût cognitif) sans ajouter d'information au sens de $\mathsf{Opp}$. Les facteurs $0{,}75$, $0{,}5$ et $0{,}45$ des formulations initiales sont des heuristiques de conception, sans statut de minoration prouvée. Ils n'interviennent pas dans l'énoncé de la conjecture.

| Énoncé | Statut |
|---|---|
| Confidentialité (SOTP-Low, SOTP-Base) | statistique avec masque tronqué (Remarque `rem:masque_troncature`), calculatoire sous PRG sinon (Propositions `thm:saturation_sotp_low`, `thm:saturation_sotp_base`) |
| $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ (SOTP-Low, SOTP-Base) | prouvée sous DLog |
| Confidentialité et $\mathsf{Rel}_{\mathrm{ver}}$ (SOTP-High) | prouvées sous la solidité de connaissance de Groth16 (modèle du groupe générique ou algébrique), DLog, résistance aux collisions de Poseidon et cérémonie honnête (Proposition `thm:saturation_sotp_high`) |
| Préservation des distances JL (SOTP-Base) | lemme de Johnson-Lindenstrauss, probabilité $\geq 1-\delta$ |
| Minorations $0{,}75\,\Delta/\lambda$, $0{,}5\min\{\cdot\}$, $0{,}45\,\beta\log_2\lambda/\lambda$ | heuristiques de conception non prouvées |
| Optimalité universelle de SOTP, sur l'opposabilité des protocoles à fuite négligeable | conjecture |
| Valeurs numériques (ECDSA, Helios, zk-SNARKs, budget de 296 bits) | illustrations analytiques, non comparables aux produits CLO |

## 2. Le paradigme Gold-Iron-Clay

Source : §`subsec:gold_iron_clay` et §`subsec:principes_conception`.

Les trois métriques étant définies, il faut une méthodologie pour concevoir des protocoles qui les équilibrent [Shoup01, Damgard87]. Le paradigme **Gold-Iron-Clay** structure cette conception en trois couches fonctionnelles. Sa dénomination, inspirée de la métallurgie médiévale, reflète la relation entre malléabilité et résistance.

| Couche | Propriété | Moyens | Question à laquelle elle répond |
|---|---|---|---|
| **Gold** (Or) | confidentialité, $\mathsf{Conf} \to 1$ | masquage par one-time pads fondés sur un PRG, chiffrements sémantiquement sûrs [GoldwasserMicali84, Bellare97], preuves zero-knowledge [GMR85, BenOr88] | « Comment rendre $\sigma$ indiscernable entre deux messages ? » |
| **Iron** (Fer) | fiabilité, $\mathsf{Rel}_{\mathrm{ver}} \to 1$ | engagements liants (*binding*) permettant la récupération vérifiable, engagements de Pedersen [Pedersen91, ChaumPedersen92], accumulateurs [CamenischLysyanskaya02], signatures | « Comment garantir que $\sigma$ permet de retrouver $m$ avec probabilité $1 - \mathrm{negl}(\lambda)$ ? » |
| **Clay** (Argile) | opposabilité, $\mathsf{Opp} \to \max$ | encodage préservant le contexte institutionnel pour l'extraction d'information par des interprètes aux ressources bornées [Miller56, Simon82], par encodage déterministe, projection Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03] ou hachage déterministe | « Comment permettre à $\mathsf{Interpret}$ d'extraire un maximum d'information sur $V$ depuis $(c, \sigma)$ ? » |

Note de la figure `fig:gold_iron_clay`. La couche **Or** ($\mathsf{Conf}$) assure le masquage cryptographique, la couche **Fer** ($\mathsf{Rel}_{\mathrm{ver}}$) garantit le liage et la vérification fiable, tandis que la couche **Argile** ($\mathsf{Opp}$) présente le contexte sous une forme interprétable ; elle n'accroît $\mathsf{Opp}$ que si elle transmet une information que l'institution ne détient pas déjà (Remarque `rem:statut_sotp`).

### Budget entropique

Un protocole CLO optimal alloue son budget entropique selon les exigences applicatives. Le budget total défini par

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget\_clo)}$$

vaut par exemple $296$ bits pour $\lambda = 128$ et un contexte de vote Helios à $H(\mathcal{C}) = 40$ bits.

Lorsque l'application priorise la confidentialité ($\mathsf{Conf}_{\min} = 0{,}9$), l'allocation recommandée affecte $60\%$ du budget à la couche Gold ($\approx 180$ bits), $30\%$ à Iron ($\approx 90$ bits) et les $10\%$ restants à Clay (compression agressive du contexte). Lorsqu'au contraire l'opposabilité prime ($\mathsf{Opp}_{\min} = 0{,}8$), les proportions s'inversent, avec $20\%$ pour Gold (masquage minimal), $30\%$ pour Iron (binding standard) et $50\%$ pour Clay (préservation riche du contexte).

L'indépendance modulaire des couches est nécessaire, car Gold, Iron et Clay doivent pouvoir être substitués sans refonte complète [canetti2001, Goldreich02]. Remplacer le PRG par AES-GCM n'affecte pas Iron ni Clay ; remplacer Pedersen par un accumulateur RSA laisse Gold et Clay intacts ; remplacer le hachage contextuel par une représentation JL ne modifie pas les deux premières couches. Cette modularité facilite l'adaptation aux évolutions cryptographiques (post-quantique, homomorphe) et réglementaires [NISTPQC, Kyber2022, Dilithium2022].

## 3. S-OTP, prototype

Source : §`subsec:construction_sotp` et §`subsec:metriques_sotp`.

Le paradigme Gold-Iron-Clay est instanciable dans la classe des protocoles fondés sur le XOR. La construction **Semantic One-Time Pad (S-OTP)** en fournit l'instance. Elle sert de prototype à la famille SOTP.

**Théorème `thm:proprietes_sotp` (Propriétés de sécurité S-OTP).** Sous difficulté du logarithme discret (DLog) dans $\mathbb{G}$ et, lorsque le masque est pseudo-aléatoire, sous hypothèse PRG [BlumMicali84, Yao82], on a

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Opp}(\text{S-OTP}) \leq \frac{H(h \mid C)}{H(V\mid C)}$$

où $h$ est la composante auxiliaire de la preuve qui porte l'information contextuelle. Avec un masque uniforme, comme dans la preuve ci-dessous, $\mathsf{Conf}(\text{S-OTP}) = 1$ sans hypothèse calculatoire.

**Remarque `rem:portee_sotp` (Portée du Théorème `thm:proprietes_sotp`).** La fiabilité établie est la fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$ ; la fiabilité de reconstruction vérifie $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ dès que $I(M;\Sigma|C) \leq \kappa/\lambda$ (Remarque `rem:rel_ver`). Si $h$ est une fonction du contexte public $C$, alors $H(h|C) = 0$ et $\mathsf{Opp}(\text{S-OTP}) = 0$. L'opposabilité de S-OTP suppose donc que $h$ transmette une information contextuelle que l'institution ne détient pas déjà (contexte d'espèce privé). L'expression $H(\mathcal{C})/\lambda$ de [MINKA2026CLO] correspond à la convention $H(h|C) = H(\mathcal{C})$ et $H(V|C) \approx \lambda$.

### Preuve (confidentialité)

Par la construction du masquage one-time pad, $M^* = m \oplus \mathsf{mask}_m$ où $\mathsf{mask}_m \xleftarrow{\$} \lbrace 0,1\rbrace^{|m|}$. Pour tout couple $(m_0, m_1) \in \mathcal{M}$, on a

$$\mathrm{TV}(P_{M^*|M=m_0}, P_{M^*|M=m_1}) = 0$$

car les deux distributions sont uniformes sur $\lbrace 0,1\rbrace^{|m|}$. L'engagement $c_\Sigma = \mathsf{Com}(M^*)$ hérite de cette indiscernabilité, car l'engagement de Pedersen est *parfaitement* masquant sans hypothèse calculatoire [Pedersen91]. Il en résulte que

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \max_{m_0,m_1} \mathrm{TV}(P_{\Sigma|M=m_0}, P_{\Sigma|M=m_1}) = 1 - \mathrm{negl}(\lambda).$$

### Preuve (fiabilité)

La complétude suit directement de la complétude du schéma d'engagement. Pour tout $(m, c)$, on a

$$\Pr[\mathsf{Verify}(pk, \mathsf{Prove}(sk,m,c), c) = 1] = 1 - \delta_{\mathsf{Com}}$$

où $\delta_{\mathsf{Com}} = \mathrm{negl}(\lambda)$ est l'erreur d'engagement. Pour établir la *soundness*, supposons qu'un adversaire $\mathcal{A}$ produise $\sigma^* = (c_\Sigma^*, h^*, \ldots)$ avec $\mathsf{Verify}(\sigma^*, c) = 1$ sans passer par $\mathsf{Prove}$. Alors $\mathcal{A}$ aurait ouvert l'engagement $c_\Sigma^*$ sur un contenu valide ; cela contredit la propriété de *binding* calculatoire du schéma de Pedersen sous l'hypothèse DLog (probabilité $\leq \mathrm{negl}(\lambda)$) [Pedersen91]. Donc $\mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda)$.

### Preuve (opposabilité)

L'information auxiliaire $h$ encode $\ell_{\text{aux}} = H(\mathcal{C})$ bits de contexte. Si l'interprète ne lit la preuve qu'à travers $(h, C)$, soit la chaîne $V - (h, C) - \Sigma$, on a

$$I(V;\Sigma|C) \leq I(V;h|C) = H(h|C) - H(h|V,C) \leq H(h|C).$$

En divisant par $H(V|C)$, on obtient

$$\mathsf{Opp}(\text{S-OTP}) = \frac{I(V;\Sigma|C)}{H(V|C)} \leq \frac{H(h|C)}{H(V|C)}.$$

**Remarque `thm:optimalite_sotp` (Argument heuristique d'optimalité de S-OTP dans la classe OTP).** Parmi les protocoles qui masquent le message par un one-time pad et n'encodent le contexte que dans une composante auxiliaire $h$, S-OTP semble réaliser le meilleur compromis. Tout protocole de ce type consacre en effet $|m| = \lambda$ bits d'aléa au masquage pour la sécurité parfaite. Son opposabilité reste bornée par $H(h|C)/H(V|C)$, par le même argument que ci-dessus. Une preuve d'optimalité demanderait de définir formellement la classe OTP et d'y démontrer une borne supérieure uniforme ; nous la laissons ouverte. Selon cet argument heuristique, une construction atteignant une opposabilité supérieure devrait soit (i) abandonner la confidentialité information-théorique au profit d'hypothèses calculatoires, soit (ii) utiliser des protocoles interactifs multi-tours, soit (iii) employer des primitives différentes, au-delà du paradigme OTP.

### Métriques CLO atteintes (illustration)

Pour les paramètres typiques $\lambda = 128$, $\Delta = 50$ bits, $H(\mathcal{C}) = 30$ bits, sous le seuil $H^\sharp \approx 51$ bits pour $\alpha = 1$, on obtient

$$\mathsf{Conf}(\text{S-OTP}) \approx 0{,}999, \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) \approx 0{,}999, \qquad \mathsf{Opp}(\text{S-OTP}) \approx \min\left\lbrace 1,\ \frac{50}{30}\right\rbrace = 1.$$

Ces valeurs sont des estimations théoriques calculées sous les hypothèses PRG et DLog [Goldreich01, KatzLindell14], sans mesure empirique contrôlée. Le produit vaut alors

$$\mathsf{Conf} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \approx 0{,}998.$$

Cette valeur porte sur la fiabilité de vérification et sur une opposabilité calculée sous la convention $\mathsf{Opp} = \min\lbrace 1,\Delta/H(\mathcal{C})\rbrace$ de [MINKA2026CLO]. Cette convention ne se déduit pas du théorème et suppose que $h$ transmet un contexte d'espèce inconnu de l'institution. La valeur obtenue n'est pas comparable à la borne du Théorème `thm:trilemme_cro_conditionnel`. En fiabilité de reconstruction, la confidentialité statistique de S-OTP impose $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ (Remarque `rem:rel_ver`), tandis que [MINKA2026CLO] donne un produit de l'ordre de $H(\mathcal{C})/\lambda$. Ce produit élevé n'est réalisable que sous le seuil, soit $H(\mathcal{C}) \leq H^\sharp$. Au-delà, l'opposabilité est majorée par $(\kappa/\lambda + \Delta)/\gamma \approx \Delta/(\alpha H(\mathcal{C})) < 1$, quantité qui décroît en $1/H(\mathcal{C})$ (preuve de la Proposition `prop:borne_aigue`, étape 6). Cela motive la variante SOTP-High, SOTP-Base répondant sous le seuil au besoin de proximité entre contextes.

La Remarque `thm:optimalite_sotp` indique que S-OTP serait optimal dans sa classe, sans le démontrer. Cette optimalité, même établie, resterait restreinte, car les variantes SOTP-Base et SOTP-High utilisent des techniques au-delà des protocoles XOR (projection JL, zk-SNARKs) et répondent à d'autres besoins.

## 4. Architecture commune de la famille SOTP

Source : §`sec:sotp_construction` (introduction) et §`subsec:philosophie_sotp`.

La famille SOTP propose trois constructions de référence pour les deux régimes de richesse contextuelle. Sous le seuil $H^\sharp$ du théorème, SOTP-Low et SOTP-Base répondent à deux besoins, le contexte exact ou la proximité entre contextes. Au-delà, SOTP-High prend le relais.

Trois couches fonctionnelles structurent chaque protocole. La couche **Gold** accomplit le masquage cryptographique au moyen d'un masque jetable, tronqué ou pseudo-aléatoire, pour SOTP-Low et SOTP-Base [Shannon49, BlumMicali84]. Elle recourt aux preuves zero-knowledge pour SOTP-High [GMR85, BenOr88]. La couche **Iron** assure le binding via des commitments contraignants, Pedersen [Pedersen91, ChaumPedersen92] pour SOTP-Low/Base, Groth16 [Groth16, BCTV14] pour SOTP-High, permettant l'ouverture vérifiable du message. La couche **Clay** enfin présente le contexte institutionnel sous une forme que des interprètes à capacité bornée $\Delta$ peuvent exploiter pour rendre leurs verdicts [Simon82, Miller56] ; elle n'accroît $\mathsf{Opp}$ que si elle transmet une information que l'institution ne détient pas déjà (Remarque `rem:statut_sotp`).

L'apport propre à la famille tient à son **adaptation au régime et au besoin de l'institution**. Chaque variante SOTP spécialise la couche Clay par un encodage déterministe, une représentation Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03, Vempala05] ou un hachage SNARK Poseidon [Groth16, Poseidon2019].

### Correspondance entre métriques CLO et propriétés cryptographiques

| Métrique CLO | Propriété cryptographique | Hypothèses |
|---|---|---|
| $\mathsf{Conf}$ (notion statistique) | pendant calculatoire, l'indistinguabilité sémantique [GoldwasserMicali84, MicaliRackoff91] : pour toute paire $(m_0, m_1)$ dans le même contexte $c$, nul adversaire polynomial ne distingue la preuve de $m_0$ de celle de $m_1$ avec avantage non négligeable | PRG [BlumMicali84, Yao82] lorsque le masque est pseudo-aléatoire |
| $\mathsf{Rel}_{\mathrm{ver}}$ (Remarque `rem:rel_ver`) | binding [Pedersen91, Damgard87] : aucun adversaire polynomial ne produit deux ouvertures distinctes d'un même commitment sur des messages différents avec probabilité non négligeable | DLog [DiffieHellman76] ; solidité de connaissance de Groth16 dans le modèle du groupe générique ou algébrique [Groth16, FKL18] |
| $\mathsf{Opp}$ | fraction d'information extractible sur le verdict, $I(V;\Sigma\mid C)/H(V\mid C)$, quantifiée via la capacité d'extraction institutionnelle $\Delta$ (Définition `def:delta_extraction`) | aucune réduction ; dépend de l'interprétation institutionnelle |

Les garanties de confidentialité et de fiabilité de vérification résultent de réductions formelles à des hypothèses cryptographiques standard. L'opposabilité, elle, dépend de l'interprétation institutionnelle et ces réductions ne la minorent pas.

### Couche Clay par régime

| Régime et besoin | Condition | Technique Clay |
|---|---|---|
| rare, contexte exact requis (SOTP-Low) | $H(\mathcal{C}) \leq H^\sharp$ | encodage déterministe $\phi:\mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$, qui transmet le contexte sans perte [Shannon48] |
| rare, proximité entre contextes requise (SOTP-Base) | $H(\mathcal{C}) \leq H^\sharp$ | représentation JL [JohnsonLindenstrauss84, Achlioptas2003], qui plonge le contexte dans $\mathbb{R}^d$ puis le projette dans $\mathbb{R}^k$ ; pour $N$ contextes, $k = O(\log N/\varepsilon^2)$ suffit à préserver les distances à $\varepsilon$ près |
| riche (SOTP-High) | $H(\mathcal{C}) > H^\sharp$ | hachage Poseidon [Poseidon2019, Grassi2021] d'un contexte arbitrairement complexe en un condensé de taille fixe ($256$ bits), avec métadonnées structurées |

Le seuil qui sépare les régimes est celui du théorème (Remarque `rem:activite_delta`),

$$H^\sharp = \frac{\Delta + 1 + \kappa/\lambda}{\alpha}.$$

Sous ce seuil, la capacité de l'institution couvre le contexte. Un critère fonctionnel départage alors SOTP-Low et SOTP-Base. La formalisation Lean certifie le seuil dans les deux sens.

Le budget entropique total de chaque preuve SOTP s'écrit

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget)}$$

Pour $\lambda = 128$ et $H(\mathcal{C}) = 40$ bits (vote type Helios [Adida08]), cela donne $\approx 296$ bits. Ce budget compte l'entropie de la preuve et non sa longueur ; la représentation JL de SOTP-Base occupe ainsi $k$ coordonnées réelles. Il contraint la couche Clay, car préserver trop de contexte peut corréler $\Sigma$ avec $m$, réduisant $\mathsf{Conf}$ ; compresser trop agressivement réduit $\mathsf{Opp}$ parce que l'interprète ne peut plus extraire les verdicts [Smith09, Alvim12].

## 5. SOTP-Low quand le contexte exact est requis

Source : §`subsec:sotp_low`.

Pour le cas où l'institution a besoin du contexte exact, la thèse propose une construction déterministe simple dont elle établit les propriétés cryptographiques (Remarque `rem:statut_sotp`).

Le régime cible est celui où la capacité de l'institution couvre le contexte, $H(\mathcal{C}) \leq H^\sharp$ (Remarque `rem:activite_delta`). L'institution y a besoin du contexte exact. Sous ce seuil, la borne raffinée se réduit à celle de Fano, ce que la formalisation Lean certifie dans les deux sens. Les signatures contractuelles ECDSA [Johnson01, NIST.FIPS.186-5] en sont le cas d'école. Un contrat standardisé et ses parties sont souvent paramétrés par un contexte d'entropie $H(\mathcal{C}) \approx 20$ bits [Mason07, Kerr04], sous le seuil $H^\sharp \approx 36$ bits obtenu avec $\Delta \approx 35$ bits et $\alpha = 1$.

L'idée consiste à encoder le contexte *déterministiquement* dans la couche Clay, ce qui n'entraîne ni perte de compression ni circuit coûteux. La preuve se compose d'un masque PRG (Gold), d'un commitment Pedersen (Iron) et d'un triplet $(\phi(c), \mathsf{Hash}(c), V(c))$ (Clay). Cette dernière composante révèle le contexte sans révéler le message, puisque $M \perp C$ par construction.

### Algorithme 1 — SOTP-Low (`alg:sotp_low`)

```text
 1  Paramètres : λ, (Δ, α, β), H(C) ≤ H♯, contexte exact requis
 2  Setup(1^λ) :
 3      Générer groupe cyclique (G, q) avec |q| ≥ 2λ et DLog difficile
 4      échantillonner g, h ←$ G tels que log_g h inconnu
 5      Choisir PRG  PRG : Z_q → {0,1}^λ
 6      Choisir Hash : C → {0,1}^λ résistante aux collisions
 7      Définir encodage déterministe φ : C → {0,1}^{H(C)}
 8      Retourner pk = (G, q, g, h, PRG, Hash, φ)
 9  Prove(pk, m, c) :
10      // Gold
11      s ←$ Z_q ;  σ1 ← m ⊕ PRG(s)
12      // Iron
13      ρ ←$ Z_q ;  σ2 ← g^s · h^ρ                      [Pedersen91]
14      // Clay
15      σ3 ← (φ(c), Hash(c), V(c))
16      Retourner σ = (σ1, σ2, σ3) ; témoin secret (s, ρ)
17  Verify(pk, σ, c) :
18      Vérifier Hash(c) =? σ3.hc  et  φ(c) =? σ3.h_c  et  σ2 ∈ G
19  Open(pk, σ, c, (m, s, ρ)) :
20      Accepter ssi σ2 = g^s h^ρ  et  σ1 = m ⊕ PRG(s)
```

Points de construction relevés dans le texte de la thèse.

- L'encodage déterministe $\phi$ sérialise le contexte institutionnel $c$ sur exactement $H(\mathcal{C})$ bits. Ce point est spécifique à SOTP-Low, qui transmet le contexte exact.
- Tirer la graine dans $\mathbb{Z}_q$ est nécessaire. Avec $s \in \lbrace 0,1\rbrace^\lambda$ et un engagement sur $\mathsf{int}(s) \bmod q$, deux graines $s$ et $s+q$ donneraient en effet le même engagement, ce qui ferait perdre le caractère liant.
- La phase $\mathsf{Verify}$ ne vérifie pas la cohérence entre $\sigma_1$ et $\sigma_2$, car ce lien n'est contrôlé que lors de l'ouverture ($\mathsf{Open}$), qui requiert le témoin $(m, s, \rho)$ ; sans ouverture, $\sigma_1$ et $\sigma_2$ ne sont pas liés, de sorte que $\mathsf{Verify}$ seul accepte toute paire bien formée. L'arbitre peut donc vérifier la forme de la preuve sans accéder au message $m$ ; la garantie de liaison porte sur l'ouverture.
- La couche Clay présente le contexte sous une forme lisible, mais, étant une fonction du contexte public $c$, elle n'apporte aucune information conditionnelle au sens de $\mathsf{Opp}$ (Remarque `rem:statut_sotp`).

### Proposition `thm:saturation_sotp_low` (Propriétés cryptographiques de SOTP-Low)

Sous sécurité PRG [BlumMicali84, Yao82] et difficulté DLog [DiffieHellman76] :

1. tout adversaire PPT a un avantage IND-CONF négligeable contre SOTP-Low (confidentialité calculatoire) ;
2. la complétude est parfaite et, pour la procédure d'ouverture, la probabilité de gain BIND-REL est négligeable, donc $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$ au sens de la Remarque `rem:jeu_bind_rel_link`.

**Remarque `rem:facteur_limitant_low` (Heuristique de conception de SOTP-Low, non prouvée).** La formulation initiale de ce résultat énonçait la minoration $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0{,}75 \cdot \min\lbrace\Delta, H(\mathcal{C})\rbrace/\lambda$. La formalisation a conduit à la remplacer, pour trois raisons. (i) La composante $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ est une fonction du contexte public, donc $I(V;\sigma_3|C) = 0$ ; (ii) le passage par $H(V|C) \approx \lambda$ contredit l'Hypothèse `ass:verdicts_efficace` ($\log_2|\mathcal{V}_\lambda| \leq \alpha H(\mathcal{C})$) ; (iii) une telle minoration dépasserait le majorant du Théorème `thm:trilemme_cro_conditionnel` dès que $\gamma > 4/3$ tout en portant sur $\mathsf{Rel}_{\mathrm{ver}}$ au lieu de $\mathsf{Rel}_{\mathrm{rec}}$. L'expression $0{,}75\,\Delta/\lambda$ est conservée comme *heuristique de conception*, car elle décrit la fraction de la capacité d'extraction qu'un encodage entier de $\lfloor H(\mathcal{C}) \rfloor$ bits permettrait d'exploiter si ce contexte était un contexte d'espèce inconnu de l'institution ($1 - 1/\Delta \geq 0{,}75$ pour $\Delta \geq 4$). Sa justification rigoureuse, dans un modèle à contexte privé, est une perspective (chapitre `chap:resultats_discussions`).

### Preuve de la Proposition `thm:saturation_sotp_low`

Rappel de la construction.

$$\sigma_1 = m \oplus \mathsf{PRG}(s),\ s \xleftarrow{\$} \mathbb{Z}_q \ \text{(Gold)}, \qquad \sigma_2 = g^{s} \cdot h^\rho,\ \rho \xleftarrow{\$} \mathbb{Z}_q \ \text{(Iron)}, \qquad \sigma_3 = \bigl(\phi(c),\ \mathsf{Hash}(c),\ V(c)\bigr) \ \text{(Clay)}$$

où $(g, h)$ sont des générateurs du groupe $(\mathbb{G}, q)$ avec $\log_g h$ inconnu. Le témoin secret est $(s, \rho)$.

**Partie I. Confidentialité calculatoire.** La loi de $\sigma$ sachant $M = m_i$ ne dépend de $m_i$ que par $\sigma_1$. En effet, $\sigma_2$ est parfaitement masquant (pour tout $s$, $g^s h^\rho$ est uniforme dans $\mathbb{G}$ lorsque $\rho$ est uniforme) tandis que $\sigma_3$ ne dépend que de $c$, indépendant de $m$ ($M \perp C$). Supposons qu'un distingueur PPT $\mathcal{D}$ distingue $m_0 \oplus \mathsf{PRG}(s)$ de $m_1 \oplus \mathsf{PRG}(s)$ avec un avantage non négligeable $\mu(\lambda)$. L'adversaire $\mathcal{B}$ reçoit $y$ (sortie du PRG ou chaîne uniforme), tire $b$, soumet $m_b \oplus y$ à $\mathcal{D}$ et répond « PRG » si $\mathcal{D}$ retrouve $b$. Il distingue le PRG avec un avantage au moins $\mu(\lambda) - 1/q$ (Théorème `thm:ann_sotp_low_conf`), puisque si $y$ est uniforme, $m_b \oplus y$ ne contient aucune information sur $b$. Cela contredit la sécurité du PRG [BlumMicali84]. L'avantage IND-CONF de tout adversaire PPT est donc négligeable. La confidentialité est calculatoire. Au sens statistique de la Définition `def:confidentialite_clo`, elle est garantie dès que le masque est uniforme ou statistiquement proche de l'uniforme (Remarque `rem:masque_troncature`).

**Partie II. Fiabilité de vérification.** *Complétude.* Pour toute preuve honnête, $\mathsf{Hash}(c) = \sigma_3.\mathsf{hc}$ et $\phi(c) = \sigma_3.h_c$ par construction, $\sigma_2 \in \mathbb{G}$ par fermeture du groupe ; enfin $\mathsf{Open}$ accepte le témoin honnête $(m, s, \rho)$. La complétude est parfaite.

*Liaison (réduction à DLog).* Supposons qu'un adversaire PPT produise une preuve $\sigma$ et deux ouvertures acceptées $(m_0, s_0, \rho_0)$ et $(m_1, s_1, \rho_1)$ avec $m_0 \neq m_1$. Comme $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ et $m_0 \neq m_1$, on a $s_0 \neq s_1$ dans $\mathbb{Z}_q$. L'égalité $g^{s_0} h^{\rho_0} = g^{s_1} h^{\rho_1}$ impose alors $\rho_0 \neq \rho_1$ et

$$\log_g h = \frac{s_0 - s_1}{\rho_1 - \rho_0} \bmod q,$$

ce qui contredit la difficulté du logarithme discret [DiffieHellman76]. La probabilité de gain BIND-REL est donc négligeable, d'où $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$. $\square$

**Remarque `rem:masque_troncature` (Masque par troncature).** La graine $s$ est uniforme dans $\mathbb{Z}_q$ avec $|q| \geq 2\lambda$, donc plus longue que le masque de $\lambda$ bits. La fonction $G(s) = s \bmod 2^\lambda$ convient alors comme fonction de dérivation de masque. Avec $r = q \bmod 2^\lambda$, la distance statistique entre $G(s)$ et une chaîne uniforme vaut $r(2^\lambda - r)/(q\,2^\lambda) \leq 2^\lambda/(4q) \leq 2^{-\lambda-1}$. Pour $h \neq 1$, l'engagement $\sigma_2$ est uniforme et indépendant de $s$. Il en résulte $\mathrm{TV}(P_{\sigma|m_0,c}, P_{\sigma|m_1,c}) \leq 2^{-\lambda}$, d'où $\mathsf{Conf}(\mathrm{SOTP\text{-}Low}) \geq 1 - 2^{-\lambda}$ au sens statistique et une fuite $I(M;\Sigma|C)$ négligeable. Pour un groupe d'ordre $q \approx 2^{252}$ et $\lambda = 128$, la majoration $2^\lambda/(4q)$ donne $2^{-126}$, valeur encore négligeable. La confidentialité devient statistique, ce qui renforce la partie 1 de la Proposition `thm:saturation_sotp_low` sans la modifier. La liaison n'utilise aucune propriété de $G$ et reste inchangée. La réduction de la partie 1 est mécanisée en Lean, en situation réduite, pour toute fonction $G$ (annexe `chap:annexe_gamebased`).

### Illustration : signatures ECDSA

À titre d'illustration, sans valeur de validation (les métriques CLO d'ECDSA sont des estimations paramétriques analytiques issues des spécifications publiées [Johnson01, NIST.FIPS.186-5] et ECDSA n'est pas une instance du théorème, Remarque `rem:portee_cas_etude`), les paramètres $\Delta = 35$ bits, $\lambda = 128$ donnent pour l'heuristique de SOTP-Low la valeur $0{,}75 \times 35/128 \approx 0{,}205$. Cette valeur n'est pas comparable au produit CLO d'ECDSA ($0{,}273$).

## 6. SOTP-Base quand la proximité entre contextes compte

Source : §`subsec:sotp_base`.

Lorsque l'institution compare des contextes, la thèse propose une construction fondée sur la représentation Johnson-Lindenstrauss [JohnsonLindenstrauss84], qui préserve les distances entre contextes à $\varepsilon$ près.

Helios [Adida08, Adida09UCL] en est l'archétype. Le contexte électoral (registre des électeurs, règles du scrutin, procès-verbal) représente $H(\mathcal{C}) \approx 40$ bits pour une élection de taille moyenne (tableau `tab:parametres_reference`). La capacité d'un comité de garants spécialisés est estimée à $\Delta \approx 56$ bits, soit $H^\sharp \approx 48$ bits pour $\alpha = 1{,}2$. L'usage décide de la variante. La taille n'y intervient pas, puisque l'encodage exact tiendrait en quelques dizaines de bits. Les garants comparent des scrutins et repèrent des écarts, ce qui demande une représentation où deux contextes proches restent proches. Un scrutin dont le contexte dépasserait $H^\sharp$ relèverait de SOTP-High.

La représentation Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03, Achlioptas2003] plonge le contexte dans un espace de dimension $d = \Theta(\Delta \cdot H(\mathcal{C}))$ puis le projette dans $k = O(\log N/\varepsilon^2)$ dimensions par une matrice aléatoire $\Phi$, pour $N$ contextes, en préservant les distances à un facteur $1 \pm \varepsilon$ près. Que l'information extractible soit préservée dans la même proportion relève d'une hypothèse de conception que le lemme ne garantit pas.

### Algorithme 2 — Construction de SOTP-Base avec représentation JL (`alg:sotp_base`)

```text
 1  Paramètres : λ, (Δ, α), H(C) ≤ H♯, proximité entre contextes requise, ε = 0,1
 2  Setup(1^λ) :
 3      Générer (G, q, g, h), PRG, Hash comme SOTP-Low
 4      Recevoir d = ⌈4 Δ H(C) / ε²⌉ de l'Algorithme 4 (alg:selection_variante_sotp)
 5      Fixer k ← ⌈4 ln N / (ε²/2 − ε³/3)⌉,  N = 2^{H(C)}
 6      Générer matrice JL Φ ←$ N(0, 1/k)^{k×d}      [DasguptaGupta03, Vempala05]
 7      Retourner pk = (G, q, g, h, PRG, Hash, Φ, k, d)
 8  Prove(pk, m, c) :
 9      Couches Gold et Iron identiques à SOTP-Low
10      // Clay JL
11      c⃗ ← embed(c) ∈ R^d
12      σ3 ← Φ c⃗ ∈ R^k
13      Retourner σ = (σ1, σ2, σ3)
14  Verify(pk, σ, c) :
15      Vérifier σ3 = Φ · embed(c)  (à l'arrondi de représentation près)
16      Vérifier σ2 ∈ G
```

Points de construction relevés dans le texte de la thèse.

- SOTP-Base partage avec SOTP-Low les couches Gold et Iron inchangées. La couche Clay remplace l'encodage déterministe bijectif par une représentation Johnson-Lindenstrauss. Cette substitution répond à un besoin fonctionnel. L'institution compare des contextes et doit retrouver dans la preuve leur proximité, que l'encodage exact ne rend pas apparente.
- La dimension de plongement $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ (ligne 4) calibre l'espace de représentation intermédiaire sur le produit de la capacité d'extraction institutionnelle $\Delta$ et de l'entropie contextuelle. Plus le contexte est riche et plus l'institution peut en extraire, plus la représentation doit être large pour préserver les distances sémantiques pertinentes.
- La dimension d'arrivée (ligne 5) vaut $k = \lceil 4\ln N/(\varepsilon^2/2 - \varepsilon^3/3) \rceil$, avec $N = 2^{H(\mathcal{C})}$ contextes supposés équiprobables. Elle détermine la taille de la couche Clay transmise dans la preuve. Elle est calibrée sur la borne de Dasgupta et Gupta [DasguptaGupta03] (Lemme `lem:johnson_lindenstrauss`), qui garantit qu'une projection préservant les distances à $\varepsilon = 0{,}1$ près existe. Une marge sur $k$ rend cette préservation très probable pour toutes les paires (Théorème `thm:ann_sotp_base_opp`).
- La matrice $\Phi$ (ligne 6) est tirée aléatoirement selon une gaussienne centrée de variance $1/k$. Cette normalisation assure que les normes euclidiennes sont préservées en espérance, propriété sur laquelle repose la garantie JL.
- La fonction $\mathsf{embed}$ (ligne 11) traduit la structure sémantique du contexte en vecteur de réels, de sorte que deux contextes proches sémantiquement produisent des vecteurs proches au sens de la distance euclidienne. La ligne 12 projette ce vecteur de $d$ dimensions vers un espace de $k \ll d$ dimensions. La preuve transmise $\sigma_3$ est donc la projection du contexte, distincte du contexte lui-même et de son encodage exact.
- La phase $\mathsf{Verify}$ (lignes 14 à 16) recalcule $\Phi \cdot \mathsf{embed}(c)$ et le compare à $\sigma_3$. La matrice $\Phi$ est publique et fixée au $\mathsf{Setup}$, de sorte que l'égalité est exacte ; la tolérance ne couvre que l'arrondi de la représentation des réels. Le paramètre $\varepsilon$ gouverne la distorsion des distances entre contextes et n'intervient pas dans la vérification. Il règle le compromis entre la fidélité de la représentation et la dimension $k$ de la preuve transmise.
- Avec $\varepsilon = 0{,}1$, $\Delta = 56$ et $H(\mathcal{C}) = 40$, la dimension de plongement vaut $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil = 896\,000$ et la dimension d'arrivée $k = 23\,766$. Préserver toutes les paires avec probabilité $1 - 10^{-6}$ demande $k \approx 83\,100$ (Théorème `thm:ann_sotp_base_opp`).

### Proposition `thm:saturation_sotp_base` (Propriétés cryptographiques de SOTP-Base)

Sous sécurité PRG [BlumMicali84] et difficulté DLog [DiffieHellman76], les couches Gold et Iron de SOTP-Base étant identiques à celles de SOTP-Low, SOTP-Base vérifie les deux propriétés de la Proposition `thm:saturation_sotp_low`, à savoir la confidentialité calculatoire et $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$ pour la procédure d'ouverture. De plus, pour tous contextes $c, c'$, avec probabilité au moins $1 - \delta$ sur le tirage de $\Phi$, où $\delta \leq 2/N^2$ pour le $k$ de la ligne 5,

$$\|\Phi\,\mathsf{embed}(c) - \Phi\,\mathsf{embed}(c')\|^2 \in (1 \pm \varepsilon)\|\mathsf{embed}(c) - \mathsf{embed}(c')\|^2$$

(Lemme `lem:johnson_lindenstrauss`).

*Preuve.* Les arguments de la Proposition `thm:saturation_sotp_low` s'appliquent sans changement aux couches Gold et Iron ; la couche Clay n'intervient ni dans la confidentialité (elle ne dépend que de $c$, indépendant de $m$) ni dans la liaison. La dernière propriété est le lemme de Johnson–Lindenstrauss appliqué à l'ensemble fini des plongements de contextes. $\square$

**Remarque `rem:heuristique_sotp_base` (Heuristique de conception de SOTP-Base, non prouvée).** La formulation initiale de ce résultat énonçait $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0{,}5 \cdot \min\lbrace\Delta/d,\ \beta\log_2 d/d\rbrace$. La formalisation a conduit à la remplacer pour les raisons exposées à la Remarque `rem:facteur_limitant_low`. En effet, $\sigma_3 = \Phi\,\mathsf{embed}(c)$ est une fonction du contexte public, donc $I(V;\sigma_3|C) = 0$ ; la préservation des distances n'implique pas celle de l'information extractible ; enfin une minoration ne peut se déduire d'une majoration. L'expression $0{,}5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$, forme de dimensionnement distincte de la formulation initiale, est conservée comme heuristique de dimensionnement de la couche Clay. Dès que $d > \beta\log_2 d$, elle se réduit à $0{,}5\,\Delta/d$.

### Illustration : vote électronique Helios

À titre d'illustration, l'heuristique de SOTP-Base pour les paramètres analytiques de Helios [Adida08, MINKA2026CRO] ($\Delta = 56$ bits, $\beta = 1{,}4$, $d = 560$) donne $0{,}5 \times \min\lbrace 56/560,\ 56/(1{,}4 \log_2 560)\rbrace \approx 0{,}050$. Cette valeur n'est pas comparable au produit CLO de Helios ($0{,}437$), qui porte sur $\mathsf{Rel}_{\mathrm{ver}}$ et n'est pas une instance du théorème (Remarque `rem:portee_cas_etude`). La dimension $d = 560$ retenue ici est un choix de dimensionnement, distinct de la règle $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$.

## 7. SOTP-High au-delà du seuil de capacité

Source : §`subsec:sotp_high`.

Pour les contextes riches, la thèse propose une construction fondée sur les zk-SNARKs succincts Groth16, qui protège le témoin (divulgation nulle de connaissance) au prix d'une opposabilité réduite.

La conformité financière via zk-SNARKs [Groth16, Garratt15, BaselIII] illustre ce régime, où transactions complexes, réglementations multi-juridictionnelles et historiques longs produisent $H(\mathcal{C}) \approx 70$–$90$ bits, au-delà du seuil $H^\sharp \approx 49$ bits obtenu avec $\Delta \approx 73$ bits et $\alpha = 1{,}5$. La capacité de l'institution ne couvre plus l'entropie des verdicts, $\gamma = \alpha H(\mathcal{C}) - 1 = 104$ bits pour $H(\mathcal{C}) = 70$ [Simon82, Miller56]. Lui transmettre le contexte ou sa représentation ne servirait plus le verdict ; il faut certifier une assertion sur ce contexte sans révéler le message.

Les zk-SNARKs succincts (Groth16 [Groth16, BCTV14, Gennaro13]) lèvent cet obstacle en produisant une preuve de taille constante ($128$ octets sur BN254 [BarretoNaehrig2006], en points compressés) indépendante de la complexité du circuit vérifié. Le caractère succinct brise le couplage linéaire entre $H(\mathcal{C})$ et la taille de preuve. Cette solution a une double contrepartie. Une étape de mise en place de confiance (*trusted setup*) est requise [Bowe2017]. L'opposabilité est aussi réduite, plafonnée par la perte entropique du hachage compressant le contexte en 256 bits.

*Note de bas de page du manuscrit.* BN254 est retenue pour la taille de ses preuves. Depuis les cribles de corps de nombres en tour étendue [KimBarbulescu2016], elle offre environ $100$ bits de sécurité ; la valeur $\lambda = 128$ y est donc nominale. De même, l'ordre $q \approx 2^{252}$ des groupes utilisés ne satisfait la condition $|q| \geq 2\lambda$ qu'à quelques bits près.

### Algorithme 3 — Construction de SOTP-High avec zk-SNARKs Groth16 (`alg:sotp_high`)

```text
 1  Paramètres : λ, (Δ, α), H(C) > H♯, circuit C_circuit
 2  Setup(1^λ, C_circuit) :
 3      échantillonner τ, α_s, β_s, γ_s, δ_s ←$ F_p^*  (toxiques)
 4      Construire pk_prove et vk_verify (CRS Groth16)      [Groth16, BCTV14]
 5      // Détruire toxiques : τ, α_s, β_s, γ_s, δ_s
 6      (g, h) ←$ G² pour couche Iron
 7      Retourner pk = (pk_prove, vk_verify, g, h)
 8  Prove(pk, m, c) :
 9      // Gold + Iron (Groth16 + Pedersen)
10      ρ ←$ Z_q ;  c_m ← g^m · h^ρ                         [Pedersen91]
11      h_c ← Poseidon(c) [Poseidon2019, Grassi2021] ;  π ← Groth16.Prove(pk_prove, (h_c, c_m), (m, c, ρ))
12      relation : h_c = Poseidon(c) ∧ c_m = g^m h^ρ ∧ Conforme(m, c) = 1
13      // Clay : condensé hash + métadonnées
14      Retourner σ = (h_c, π, c_m, metadata)
15  Verify(σ, c) :
16      b0 ← [h_c = Poseidon(c)] ;  b1 ← Groth16.Verify(vk_verify, (h_c, c_m), π)
17      b2 ← [c_m ∈ G]
18      Retourner b0 ∧ b1 ∧ b2
```

Points de construction relevés dans le texte de la thèse.

- Dans le régime $H(\mathcal{C}) > H^\sharp$, la capacité de l'institution ne couvre plus le contexte et une représentation fidèle du contexte dans la preuve ne servirait plus le verdict. Le seuil est celui du théorème, certifié en Lean dans les deux sens. Au lieu de transmettre le contexte ou sa représentation, on transmet une *preuve de connaissance* d'un message conforme au contexte via un zk-SNARK Groth16.
- La ligne 5 est un impératif de sécurité. Si l'un quelconque des cinq scalaires toxiques $\tau, \alpha_s, \beta_s, \gamma_s, \delta_s$ subsistait après le $\mathsf{Setup}$, son détenteur pourrait forger des preuves valides pour n'importe quelle assertion. En pratique, cette destruction est réalisée via une étape multi-partite où la compromission simultanée de tous les participants serait nécessaire pour reconstituer les toxiques. La paire $(g, h)$ de la couche Iron est indépendante du CRS Groth16.
- La preuve $\pi$ atteste que le prouveur connaît $(m, c, \rho)$ tels que $h_c = \mathsf{Poseidon}(c)$, $c_m = g^m h^\rho$ et que le prédicat de conformité $\mathsf{Conforme}(m, c)$ est satisfait ; cette relation lie l'engagement au contexte et à l'assertion prouvée.
- La phase $\mathsf{Verify}$ reçoit le contexte public $c$, comme dans le modèle CLO. Elle contrôle d'abord que $h_c = \mathsf{Poseidon}(c)$ ($b_0$), puis la validité de la preuve Groth16 ($b_1$) et l'appartenance de $c_m$ au groupe ($b_2$). La conjonction $b_0 \wedge b_1 \wedge b_2$ suffit à établir que le prouveur connaissait un message $m$ conforme à un contexte de condensé $h_c$. Ce contexte est $c$, sauf collision de $\mathsf{Poseidon}$.
- L'information contextuelle que l'arbitre peut extraire de $h_c$ est bornée par la taille du condensé ($256$ bits). Elle est même nulle si $c$ est déjà connu de l'institution. Ce que la preuve apporte au verdict tient à l'assertion certifiée ($\mathsf{Conforme}(m,c) = 1$), non au condensé.

Une implémentation exécutable de cet algorithme (Circom/Groth16) est fournie séparément dans [`../high/`](../high/).

### Proposition `thm:saturation_sotp_high` (Propriétés cryptographiques de SOTP-High)

Sous la *knowledge soundness* de Groth16, établie dans le modèle du groupe générique [Groth16] et dans le modèle du groupe algébrique sous q-DLog [FKL18], de la difficulté DLog, de la résistance aux collisions de $\mathsf{Poseidon}$ [Poseidon2019] et d'une cérémonie de mise en place de confiance honnête [Bowe2017] :

1. la preuve $\pi$ est à divulgation nulle de connaissance parfaite et $c_m$ est parfaitement masquant, de sorte que $(\pi, c_m)$ ne révèle rien de $m$ au-delà des entrées publiques ;
2. la complétude est parfaite et, par la *knowledge soundness*, pour tout prouveur PPT qui fait accepter $\sigma$, il existe un *extracteur* (qui exploite la représentation algébrique des éléments produits par le prouveur, contrairement au vérificateur) produisant un témoin $(m, c, \rho)$ satisfaisant la relation ; d'où $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$.

La confidentialité s'entend entre messages conformes au même contexte, seuls messages pour lesquels $\mathsf{Prove}$ est défini. L'hypothèse $M \perp C$ demande alors que la loi de $M$ ne charge que des messages conformes à tous les contextes possibles.

*Preuve (résumé du manuscrit).* (1) Avec un CRS honnête, Groth16 est à divulgation nulle parfaite et l'engagement de Pedersen $c_m$ a une loi uniforme sur $\mathbb{G}$ quel que soit $m$. Le couple $(\pi, c_m)$ a donc la même loi qu'un engagement uniforme accompagné d'une preuve simulée à partir des seules entrées publiques. (2) La *knowledge soundness* fournit un extracteur. La résistance aux collisions de $\mathsf{Poseidon}$ garantit que le contexte du témoin extrait est le contexte public $c$ contrôlé par $b_0$. Le liant de $c_m$, sous DLog, interdit que deux témoins extraits portent sur des messages distincts. $\square$

**Remarque `rem:heuristique_sotp_high` (Heuristique de conception de SOTP-High, non prouvée).** La formulation initiale de ce résultat énonçait $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0{,}45 \cdot \beta\log_2\lambda/\lambda$, avec une constante $0{,}45$ « calibrée » sur les systèmes déployés. La formalisation a conduit à la remplacer, pour quatre raisons. Le condensé $h_c = \mathsf{Poseidon}(c)$ et les métadonnées sont des fonctions du contexte public ($I(V;h_c|C) = 0$). Trois éléments de groupe représentent $\Theta(\lambda)$ bits et non $O(\log\lambda)$. Le vérificateur ne peut extraire le témoin, faute de quoi la preuve ne serait pas à divulgation nulle. Enfin une constante ajustée sur des données n'a pas sa place dans un énoncé de théorème. L'expression $0{,}45\,\beta\log_2\lambda/\lambda$ est conservée comme heuristique de conception ; $\beta$ y désigne la constante de régularité du protocole (Définition `def:beta_regularite`).

### Illustration : conformité zk-SNARKs

Pour les paramètres analytiques $\Delta = 73$ bits, $\alpha = 1{,}5$, $\beta = 1{,}5$, $\lambda = 128$ (estimations paramétriques sans mesure empirique contrôlée), l'heuristique de SOTP-High donne $0{,}45 \times 1{,}5 \times 7/128 \approx 0{,}037$. Cette valeur n'est pas comparable au produit CLO des zk-SNARKs de conformité ($\approx 0{,}572$), qui porte sur $\mathsf{Rel}_{\mathrm{ver}}$ et n'est pas une instance du théorème (Remarque `rem:portee_cas_etude`).

## 8. Synthèse et sélection de variante

Source : §`subsec:synthese_selection`.

### Tableau `tab:comparaison_sotp_construction` — Comparaison des variantes SOTP

| Critère | SOTP-Low | SOTP-Base | SOTP-High |
|---|---|---|---|
| ***Régime opérationnel*** | | | |
| Entropie $H(\mathcal{C})$ | $\leq H^\sharp$, contexte exact requis | $\leq H^\sharp$, proximité requise | $> H^\sharp$ |
| Calibration ($\lambda = 128$) | $20 \leq 36$ bits | $40 \leq 48$ bits | $70 > 49$ bits |
| ***Techniques cryptographiques*** | | | |
| Couche Gold | masque tronqué ou PRG [BlumMicali84] | idem | ZK parfait (Groth16) [Groth16] |
| Couche Iron | Pedersen [Pedersen91] | Pedersen [Pedersen91] | knowledge soundness (GGM ou AGM) [Groth16, FKL18] |
| Couche Clay | $\phi:\mathcal{C}\to\lbrace 0,1\rbrace^{H(\mathcal{C})}$ | JL $\Phi:\mathbb{R}^d\to\mathbb{R}^k$ [JohnsonLindenstrauss84] | Poseidon + SNARK [Poseidon2019] |
| Primitives | SHA-256, Pedersen | Gaussienne, Pedersen | Groth16, Poseidon, BN254 [BarretoNaehrig2006] |
| ***Métriques CLO atteintes*** | | | |
| Confidentialité | statistique (troncature) ou calculatoire (PRG) | idem | ZK parfait |
| $\mathsf{Rel}_{\mathrm{ver}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{KS}} - \epsilon_{\text{DLog}}$ |
| $\mathsf{Opp}$ | dépend du contexte d'espèce transmis | idem | idem |
| ***Heuristique de conception (non prouvée)*** | | | |
| Expression | $0{,}75 \cdot \Delta/\lambda$ | $0{,}5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ | $0{,}45 \cdot \beta\log_2\lambda/\lambda$ |
| Trusted setup | Non | Non | Oui [Bowe2017] |
| ***Illustration (non comparable aux produits CLO)*** | | | |
| Système de référence | ECDSA [Johnson01] | Helios [Adida08] | zk-SNARKs conformité [Groth16] |
| Valeur de l'heuristique | $\approx 0{,}205$ | $\approx 0{,}050$ | $\approx 0{,}037$ |
| Produit CLO (échelle $\mathsf{Rel}_{\mathrm{ver}}$) | $\approx 0{,}273$ | $\approx 0{,}437$ | $\approx 0{,}572$ |

Dans le tableau, $\epsilon_{\text{KS}}$ désigne l'avantage d'un prouveur contre la solidité de connaissance de Groth16 et $\epsilon_{\text{DLog}}$ celui d'un adversaire contre le logarithme discret. L'association de chaque système de référence à une variante est illustrative. Elle suit le seuil $H^\sharp$ et le critère fonctionnel de l'Algorithme `alg:selection_variante_sotp`, avec les paramètres de la calibration (tableau `tab:parametres_reference`).

Les trois variantes couvrent l'ensemble du spectre d'entropie contextuelle. SOTP-Low privilégie la lisibilité du contexte exact sous le seuil $H^\sharp$. Elle est adaptée aux applications juridiques ou contractuelles [Mason07, Kerr04]. SOTP-Base préserve la proximité entre contextes, ce qui la destine aux applications gouvernementales et électorales [Adida08, Goodman15]. SOTP-High sacrifie l'opposabilité au profit de la confidentialité parfaite et du passage à l'échelle. Elle répond aux applications financières ou médicales à contexte très riche [Garratt15, BaselIII].

### Algorithme 4 — Sélection automatique de variante SOTP (`alg:selection_variante_sotp`)

```text
 1  Entrées : H(C), Δ, α, κ, λ, Besoin ∈ {exact, proximité}, TrustedSetup_OK
 2  H♯ ← (Δ + 1 + κ/λ) / α
 3  si TrustedSetup_OK = False et H(C) > H♯ alors
 4      ALERTE : SOTP-High requis mais trusted setup indisponible   [Bowe2017]
 5      Recommander : variante du besoin avec perte d'opposabilité, ou déployer MPC
 6      Retourner SOTP-Low si Besoin = exact, sinon SOTP-Base
 7  fin si
 8  si H(C) > H♯ alors
 9      Retourner SOTP-High ;  compiler circuit C_circuit
10  sinon si Besoin = exact alors
11      Retourner SOTP-Low
12  sinon
13      Retourner SOTP-Base ;  d ← ⌈4 Δ H(C) / ε²⌉
14  fin si
```

Cet algorithme est un méta-algorithme de déploiement, distinct des constructions cryptographiques. Il prend en entrée les paramètres du contexte institutionnel et retourne la variante SOTP adaptée, en tenant compte des propriétés mathématiques du contexte et des contraintes opérationnelles de l'environnement de déploiement.

La ligne 2 calcule le seuil $H^\sharp$ du théorème (Remarque `rem:activite_delta`). Il sépare le régime où la capacité de l'institution couvre le contexte de celui où elle devient la contrainte liante. La formalisation Lean le certifie dans les deux sens. Il croît avec $\Delta$ et décroît avec $\alpha$. Sous ce seuil, le choix entre SOTP-Low et SOTP-Base est fonctionnel. Il dépend de ce dont l'institution a besoin, le contexte exact ou la proximité entre contextes. Les grandeurs $\sqrt{\lambda}$ et $\lambda/\log_2\lambda$ des formulations initiales ne définissent pas les régimes ; elles restent des indications sur la taille des encodages.

Les lignes 3 à 7 constituent la garde de sécurité opérationnelle, qui est la partie la plus importante de l'algorithme du point de vue du déploiement. SOTP-High requiert une étape de configuration de confiance (*trusted setup*) pour générer le CRS Groth16. Cette étape peut ne pas avoir été conduite, faute de ressources pour organiser un protocole multi-parties ou parce que le contexte réglementaire ne l'autorise pas. Si le contexte dépasse néanmoins $H^\sharp$, l'algorithme émet une alerte explicite et ne dégrade pas silencieusement la sécurité. Il recommande alors soit d'accepter la variante qui répond au besoin de l'institution, SOTP-Low ou SOTP-Base, avec la perte d'opposabilité associée à un contexte qui dépasse le seuil, soit de déployer un protocole MPC pour réaliser le trusted setup de manière distribuée.

Les lignes 8 à 14 réalisent la sélection proprement dite. Si $H(\mathcal{C})$ dépasse $H^\sharp$ et que le trusted setup est disponible, SOTP-High est sélectionné. Sous le seuil, SOTP-Low est retenu lorsque l'institution a besoin du contexte exact, sans paramètre supplémentaire. Sinon SOTP-Base est sélectionné et la dimension de plongement $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ est calculée immédiatement. Ce calcul est effectué à la sélection et non dans le $\mathsf{Setup}$ pour permettre d'adapter $d$ à la valeur effective de $H(\mathcal{C})$ observée au moment du déploiement. Pour SOTP-High, le circuit arithmétique $\mathcal{C}_{\text{circuit}}$ est compilé. Cette compilation étant l'opération la plus coûteuse du processus, elle n'est déclenchée que si le contexte dépasse le seuil.

La logique de sélection suit ainsi deux critères. Sous le seuil, le besoin de l'institution décide. SOTP-Low sert le contexte exact (coût minimal, pas de dépendance externe) et SOTP-Base la proximité entre contextes (sans trusted setup). SOTP-High n'est déployé que lorsque la richesse contextuelle le rend inévitable et que les conditions opérationnelles le permettent.

### Méthodologie de conception en cinq phases

1. **Analyse applicative.** Estimer $H(\mathcal{C})$ et identifier les exigences minimales $\mathsf{Conf}_{\min}$, $\mathsf{Rel}_{\min}$, $\mathsf{Opp}_{\min}$.
2. **Évaluation institutionnelle.** Estimer $\Delta$ (capacité de délibération, expertise, mémoire institutionnelle) et $\alpha$ (granularité des verdicts). Ces estimations sont analytiques, car une mesure directe via protocoles cognitifs contrôlés reste un travail futur.
3. **Test de faisabilité.** Vérifier l'inégalité
   $$\mathsf{Conf}_{\min} \cdot \mathsf{Rel}_{\mathrm{rec},\min} \cdot \mathsf{Opp}_{\min} \stackrel{?}{\leq} \frac{1+\kappa/\lambda}{\lambda}\,\min\left\lbrace 1, \frac{\kappa/\lambda + \Delta}{\gamma}\right\rbrace \qquad \text{(eq:test\_faisabilite\_sotp)}$$
   pour les exigences exprimées en fiabilité de reconstruction (équation `eq:trilemme_cro_raffine`). Si l'inégalité est violée, il est possible de relaxer une exigence, d'augmenter $\Delta$ par investissement dans la formation institutionnelle (effectif seulement si $\Delta < \gamma$) ou de réviser la granularité des verdicts. Les exigences exprimées en fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$ ne sont pas contraintes par ce test.
4. **Sélection et paramétrage.** Appliquer l'Algorithme `alg:selection_variante_sotp` et optimiser les primitives Gold/Iron/Clay dans le régime identifié.
5. **Preuves et validation.** Établir les réductions formelles aux hypothèses standard, puis mesurer $\Delta$ et l'opposabilité obtenue selon les protocoles du chapitre `chap:experimentation`.

## 9. Conjecture d'optimalité universelle et analyse de sensibilité

Source : §`subsec:optimalite_sensibilite`.

**Conjecture `conj:optimalite_universelle` (Optimalité universelle SOTP).** On se place dans un modèle où la couche Clay transmet un contexte d'espèce que l'institution ne détient pas. Sous les Hypothèses `ass:extraction_bornee`–`ass:regime`, pour chaque régime de richesse contextuelle, il existe une variante SOTP et une constante $C_R \geq 1$ indépendante de $\lambda$, de $\Delta$ et de $\gamma$ telles que, pour tout protocole CLO $\mathcal{P}'$ du même régime dont la fuite $I(M;\Sigma|C)$ est négligeable (en particulier $\kappa = 0$),

$$\mathsf{Opp}(\mathcal{P}') \ \leq\ C_R \cdot \mathsf{Opp}(\text{SOTP}). \qquad \text{(eq:optimalite\_universelle)}$$

Pour ces protocoles, la fiabilité de reconstruction est négligeable (Proposition `prop:borne_aigue`) et l'opposabilité est majorée par $\min\lbrace 1, (\kappa/\lambda + \Delta)/\gamma\rbrace$. Les variantes SOTP-Low et SOTP-Base appartiennent à cette classe dès que le masque est tronqué (Remarque `rem:masque_troncature`). SOTP-High y appartient par divulgation nulle parfaite.

**Remarque `rem:statut_optimalite` (Statut et argument heuristique).** La formulation initiale de cet énoncé était présentée comme théorème sous la forme $\text{produit}(\mathcal{P}') \leq c \cdot \text{produit}(\text{SOTP}) + o(1)$ avec $c \in [0{,}45;\,0{,}75]$. Elle a été remplacée par une formulation plus précise, pour quatre raisons. (i) Avec $c < 1$ et $\mathcal{P}' = \text{SOTP}$, elle donnerait $\text{produit} \leq 0{,}75 \times \text{produit}$, ce qui impose $C_R \geq 1$ ; (ii) le terme additif $o(1)$ domine des produits tous en $O(1/\lambda)$ ; (iii) son argument invoquait le trilemme sans l'Hypothèse `ass:regime` ; (iv) elle s'appuyait sur les minorations des Remarques `rem:facteur_limitant_low`, `rem:heuristique_sotp_base` et `rem:heuristique_sotp_high`, qui relèvent d'heuristiques de conception. L'énoncé retenu compare les opposabilités à fuite négligeable. Pour ces protocoles, l'opposabilité est majorée par $\min\lbrace 1, (\kappa/\lambda + \Delta)/\gamma\rbrace$ et la loi explicite de la Remarque `rem:temoin_realisable`, prise avec $\min\lbrace \Delta, \gamma\rbrace$ bits, atteint $\min\lbrace 1, \Delta/\gamma\rbrace$. L'argument vise donc à minorer l'opposabilité de la variante SOTP du régime par une fraction constante de cette valeur. La constante $C_R$ ne dépend ni de $\lambda$, ni de $\Delta$, ni de $\gamma$. Sans cette exigence, l'énoncé serait vrai dès que $\mathsf{Opp}(\text{SOTP})$ est positive et ne dépend pas de $\lambda$, avec $C_R = 1/\mathsf{Opp}(\text{SOTP})$. Cette étape reste ouverte. Dans le modèle actuel, la couche Clay est une fonction du contexte public et l'opposabilité de SOTP est nulle (Remarque `rem:facteur_limitant_low`). L'énoncé y serait faux face à la loi explicite. La conjecture est donc posée dans un modèle où la couche Clay transmet un contexte d'espèce que l'institution ne détient pas (perspective développée au chapitre `chap:resultats_discussions`).

*Justification des raisons (i) et (ii), d'après le manuscrit.* (i) Avec $\mathcal{P}' = \text{SOTP}$, la forme multiplicative donne $p \leq C_R\,p$ pour l'opposabilité $p > 0$ de la variante, ce qui impose $C_R \geq 1$. Avec un facteur $c < 1$ et sans terme additif, elle donnerait $p \leq c\,p < p$, ce qui est impossible. (ii) Les produits sont majorés par $(1+\kappa/\lambda)/\lambda = O(1/\lambda)$ (Remarque `rem:activite_delta`). Un terme additif $o(1)$ comme $\lambda^{-1/2}$ dépasse cette quantité pour $\lambda$ grand et rend l'inégalité vide.

### Analyse de sensibilité

L'analyse porte sur la borne raffinée (`eq:trilemme_cro_raffine`), qui est le seul énoncé prouvé, ainsi que sur les heuristiques de conception.

- **Sensibilité à $\Delta$.** Dans le régime à contexte riche ($\Delta < \gamma$), la borne est proportionnelle à $\kappa/\lambda + \Delta$. Augmenter $\Delta$ de $50$ à $65$ bits (formation intensive des garants [Ericsson95]) relève la borne d'environ $30\%$. Dans le régime à contexte rare ($\Delta \geq \gamma$), la borne est celle de Fano et ne dépend pas de $\Delta$.
- **Sensibilité à $\alpha$.** Dans le régime à contexte riche, la borne varie en $1/\gamma = 1/(\alpha H(\mathcal{C}) - 1)$, de sorte que des verdicts plus grossiers (passer de 12 niveaux à 6) relèvent la borne et peuvent faire basculer l'institution dans le régime à contexte rare. Les institutions à verdicts très nuancés (échelles de risque fines, montants d'amendes gradués) paient ainsi une pénalité réelle. L'optimum entre précision décisionnelle et compromis CRO dépend des priorités applicatives.
- **Sensibilité à $\beta$.** La constante $\beta$ n'apparaît pas dans la borne ; elle intervient dans la garantie de confidentialité du Lemme `lem:confidentiality_guarantee`, où un protocole plus régulier (plus petit $\beta$) resserre cette garantie. Dans l'heuristique de SOTP-High, qui est proportionnelle à $\beta$, passer de $\beta = 1{,}5$ à $\beta = 1{,}2$ *diminue* la valeur de $20\%$. $\beta$ est une propriété des lois de preuve (divergence KL) et ne dépend pas de la fonction de hachage utilisée dans le circuit.

## 10. Extension quantique

Source : §`subsec:extension_postquantique_sotp`.

- **SOTP-Low post-quantique.** La couche Gold peut intégrer des PRG basés sur les fonctions de hachage (dont l'algorithme de Grover [Grover96] réduit la sécurité de $\lambda$ à $\lambda/2$ bits). L'engagement de Pedersen reste parfaitement masquant, mais son caractère liant repose sur DLog, que l'algorithme de Shor résout. Il doit donc être remplacé par un engagement post-quantique, par exemple à base de réseaux sous SIS/LWE [Peikert2016].
- **SOTP-Base post-quantique.** La projection JL est indépendante du modèle adversaire [JohnsonLindenstrauss84, DasguptaGupta03]. Les adaptations concernent les couches Gold et Iron avec des primitives post-quantiques (engagement à base de réseaux [Peikert2016], signatures ML-DSA [Dilithium2022]).
- **SOTP-High post-quantique.** Les zk-SNARKs Groth16 nécessitent une attention particulière [Unruh2016, Chatterjee2021]. Leur solidité de connaissance est établie dans les modèles du groupe générique et algébrique (sous q-DLog). Elle repose sur des groupes à couplage dont l'algorithme de Shor résout le logarithme discret. Les STARKs [BenSasson2019], qui ne reposent que sur des fonctions de hachage, constituent l'alternative post-quantique ; les Bulletproofs [Bulletproofs2018] reposent sur DLog et ne sont pas post-quantiques.

Le coefficient de perte d'interprétabilité $\eta_q$ (Définition `def:perte_interp_quantique`) s'applique à toutes les variantes lorsque la preuve transite par un support quantique

$$\mathsf{Opp}^q \geq \mathsf{Opp} - \eta_q\,\frac{H(C)}{H(V|C)},$$

et $\eta_q = 0$ lorsque la preuve reste une chaîne de bits classique.

## 11. Notes de transcription

Ces notes signalent des points du texte source sans modifier les énoncés.

<a id="t4"></a>**T4 (résolue).** Dans la version antérieure, l'annexe A notait la projection $\Phi : \mathbb{R}^n \to \mathbb{R}^d$, avec $d$ comme dimension de sortie. La ligne 5 de l'Algorithme 2 ne précisait pas non plus la base du logarithme. Le manuscrit révisé unifie les notations. Partout, $d$ est la dimension de plongement et $k$ la dimension d'arrivée ($\Phi : \mathbb{R}^d \to \mathbb{R}^k$). La ligne 5 donne désormais $k$ explicitement par la borne de Dasgupta et Gupta, avec le logarithme népérien. Le théorème de dimensionnement de l'annexe A porte sur $k$, avec la constante $12$.
