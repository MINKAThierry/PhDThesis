> **Statut : PROPOSITION — construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, chapitre 3, §3.1 (introduction), §3.2 (`sec:sotp_base`) et §3.3 (`sec:sotp_construction`)

# Spécification de la famille SOTP

*English version: [sotp_specification_en.md](sotp_specification_en.md)*

Ce document reprend fidèlement les constructions S-OTP et SOTP de la thèse. Les énoncés (théorème, propositions, remarques, conjecture) et les algorithmes sont recopiés sans modification de fond. Les renvois internes à la thèse sont donnés par leur étiquette LaTeX (par exemple `rem:rel_ver`) et les références bibliographiques par leur clé (par exemple [Pedersen91]). Les notes de transcription signalent les points où le texte source présente une incohérence ou une ambiguïté ; elles ne modifient aucun énoncé.

## Table des matières

1. [Statut des résultats](#1-statut-des-résultats)
2. [Le paradigme Gold-Iron-Clay](#2-le-paradigme-gold-iron-clay)
3. [S-OTP, prototype](#3-s-otp-prototype)
4. [Architecture commune de la famille SOTP](#4-architecture-commune-de-la-famille-sotp)
5. [SOTP-Low (régime à contexte rare)](#5-sotp-low-régime-à-contexte-rare)
6. [SOTP-Base (régime de transition)](#6-sotp-base-régime-de-transition)
7. [SOTP-High (régime à contexte riche)](#7-sotp-high-régime-à-contexte-riche)
8. [Synthèse et sélection de variante](#8-synthèse-et-sélection-de-variante)
9. [Conjecture d'optimalité universelle et analyse de sensibilité](#9-conjecture-doptimalité-universelle-et-analyse-de-sensibilité)
10. [Extension quantique](#10-extension-quantique)
11. [Notes de transcription](#11-notes-de-transcription)

---

## 1. Statut des résultats

**Remarque `rem:statut_sotp` (Statut des résultats de ce chapitre).** Les constructions S-OTP et SOTP sont évaluées sur l'échelle opérationnelle CLO, qui combine confidentialité statistique, fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$ (Remarque `rem:rel_ver`) et opposabilité sous des conventions d'interprétation explicites. Ces métriques ne sont pas comparées à la borne du Théorème `thm:trilemme_cro_conditionnel`, qui porte sur $\mathsf{Rel}_{\mathrm{rec}}$ et énonce que, pour tout protocole à confidentialité statistique $1-\mathrm{negl}(\lambda)$, $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$. L'existence de protocoles qui approchent la borne raffinée (`eq:trilemme_cro_raffine`) est formulée comme conjecture (Conjecture `conj:optimalite_universelle`). Les composantes de preuve qui ne dépendent que du contexte public $C$ n'apportent aucune information conditionnelle, puisque $I(V; g(C) \mid C) = 0$ pour toute fonction $g$. La couche Clay est donc analysée comme un *format de présentation* qui facilite l'interprétation (baisse du coût cognitif) ; elle ne constitue pas une source d'information au sens de $\mathsf{Opp}$. Les expressions numériques de saturation (facteurs $0{,}75$, $0{,}5$, $0{,}45$) sont des heuristiques de conception, non des minorations prouvées.

| Énoncé | Statut |
|---|---|
| Confidentialité calculatoire (SOTP-Low, SOTP-Base) | prouvée sous PRG (Propositions `thm:saturation_sotp_low`, `thm:saturation_sotp_base`) |
| $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ (SOTP-Low, SOTP-Base) | prouvée sous DLog |
| Confidentialité et $\mathsf{Rel}_{\mathrm{ver}}$ (SOTP-High) | prouvées sous q-SDH, q-PKE, DLog et cérémonie honnête (Proposition `thm:saturation_sotp_high`) |
| Préservation des distances JL (SOTP-Base) | lemme de Johnson-Lindenstrauss, probabilité $\geq 1-\delta$ |
| Minorations $0{,}75\,\Delta/\lambda$, $0{,}5\min\{\cdot\}$, $0{,}45\,\beta\log_2\lambda/\lambda$ | heuristiques de conception non prouvées |
| Optimalité universelle de SOTP | conjecture |
| Valeurs numériques (ECDSA, Helios, zk-SNARKs, budget de 296 bits) | illustrations analytiques, non comparables aux produits CLO |

## 2. Le paradigme Gold-Iron-Clay

Source : §`subsec:gold_iron_clay` et §`subsec:principes_conception`.

Les trois métriques étant définies, il faut une méthodologie pour concevoir des protocoles qui les équilibrent [Shoup01, Damgard87]. Le paradigme **Gold-Iron-Clay** structure cette conception en trois couches fonctionnelles, la dénomination, inspirée de la métallurgie médiévale, reflète la relation entre malléabilité et résistance.

| Couche | Propriété | Moyens | Question à laquelle elle répond |
|---|---|---|---|
| **Gold** (Or) | confidentialité, $\mathsf{Conf} \to 1$ | masquage par one-time pads fondés sur un PRG, chiffrements sémantiquement sûrs [GoldwasserMicali84, Bellare97], preuves zero-knowledge [GMR85, BenOr88] | « Comment rendre $\sigma$ indiscernable entre deux messages ? » |
| **Iron** (Fer) | fiabilité, $\mathsf{Rel}_{\mathrm{ver}} \to 1$ | engagements liants (*binding*) permettant la récupération vérifiable, engagements de Pedersen [Pedersen91, ChaumPedersen92], accumulateurs [CamenischLysyanskaya02], signatures | « Comment garantir que $\sigma$ permet de retrouver $m$ avec probabilité $1 - \mathrm{negl}(\lambda)$ ? » |
| **Clay** (Argile) | opposabilité, $\mathsf{Opp} \to \max$ | encodage préservant le contexte institutionnel pour l'extraction d'information par des interprètes aux ressources bornées [Miller56, Simon82], par encodage déterministe, compression Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03] ou hachage déterministe | « Comment permettre à $\mathsf{Interpret}$ d'extraire un maximum d'information sur $V$ depuis $(c, \sigma)$ ? » |

Note de la figure `fig:gold_iron_clay`. La couche **Or** ($\mathsf{Conf}$) assure le masquage cryptographique, la couche **Fer** ($\mathsf{Rel}_{\mathrm{ver}}$) garantit le liage et la vérification fiable, tandis que la couche **Argile** ($\mathsf{Opp}$) présente le contexte sous une forme interprétable ; elle n'accroît $\mathsf{Opp}$ que si elle transmet une information que l'institution ne détient pas déjà (Remarque `rem:statut_sotp`).

### Budget entropique

Un protocole CLO optimal alloue son budget entropique selon les exigences applicatives. Le budget total défini par

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget\_clo)}$$

vaut par exemple $296$ bits pour $\lambda = 128$ et un contexte de vote Helios à $H(\mathcal{C}) = 40$ bits.

Lorsque l'application priorise la confidentialité ($\mathsf{Conf}_{\min} = 0{,}9$), l'allocation recommandée affecte $60\%$ du budget à la couche Gold ($\approx 180$ bits), $30\%$ à Iron ($\approx 90$ bits) et les $10\%$ restants à Clay (compression agressive du contexte). Lorsqu'au contraire l'opposabilité prime ($\mathsf{Opp}_{\min} = 0{,}8$), les proportions s'inversent, avec $20\%$ pour Gold (masquage minimal), $30\%$ pour Iron (binding standard) et $50\%$ pour Clay (préservation riche du contexte).

L'indépendance modulaire des couches est essentielle, car Gold, Iron et Clay doivent pouvoir être substitués sans refonte complète [canetti2001, Goldreich02]. Remplacer le PRG par AES-GCM n'affecte pas Iron ni Clay ; remplacer Pedersen par un accumulateur RSA laisse Gold et Clay intacts ; remplacer le hachage contextuel par une compression JL n'impacte pas les deux premières couches.

## 3. S-OTP, prototype

Source : §`subsec:construction_sotp` et §`subsec:metriques_sotp`.

Le paradigme Gold-Iron-Clay est atteignable dans la classe des protocoles basés XOR, via la construction **Semantic One-Time Pad (S-OTP)**, prototype de la famille SOTP.

**Théorème `thm:proprietes_sotp` (Propriétés de sécurité S-OTP).** Sous hypothèses PRG (générateur pseudo-aléatoire) et difficulté du logarithme discret (DLog) dans $\mathbb{G}$ [BlumMicali84, Yao82], on a

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Opp}(\text{S-OTP}) \leq \frac{H(h \mid C)}{H(V\mid C)}$$

où $h$ est la composante auxiliaire de la preuve qui porte l'information contextuelle.

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

L'information auxiliaire $h$ encode $\ell_{\text{aux}} = H(\mathcal{C})$ bits de contexte. Par construction, on a

$$I(V;\Sigma|C) \leq I(V;h|C) = H(h|C) - H(h|V,C) \leq H(h|C).$$

En divisant par $H(V|C)$, on obtient

$$\mathsf{Opp}(\text{S-OTP}) = \frac{I(V;\Sigma|C)}{H(V|C)} \leq \frac{H(h|C)}{H(V|C)}.$$

**Remarque `thm:optimalite_sotp` (Optimalité de S-OTP dans la classe OTP, argument heuristique).** Parmi les protocoles qui masquent le message par un one-time pad et n'encodent le contexte que dans une composante auxiliaire $h$, S-OTP semble réaliser le meilleur compromis, puisque tout protocole de ce type consacre $|m| = \lambda$ bits d'aléa au masquage pour la sécurité parfaite et voit son opposabilité bornée par $H(h|C)/H(V|C)$ (même argument que ci-dessus). Une preuve d'optimalité demanderait de définir formellement la classe OTP et d'y démontrer une borne supérieure uniforme ; nous la laissons ouverte. Toute construction atteignant une opposabilité supérieure doit soit (i) abandonner la confidentialité information-théorique au profit d'hypothèses calculatoires, soit (ii) utiliser des protocoles interactifs multi-tours, soit (iii) employer des primitives différentes, au-delà du paradigme OTP.

### Métriques CLO atteintes (illustration)

Pour les paramètres typiques $\lambda = 128$, $\Delta = 50$ bits, $H(\mathcal{C}) = 30$ bits (régime contexte rare), on obtient

$$\mathsf{Conf}(\text{S-OTP}) \approx 0{,}999, \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) \approx 0{,}999, \qquad \mathsf{Opp}(\text{S-OTP}) \approx \min\left\lbrace 1,\ \frac{50}{30}\right\rbrace = 1.$$

Ces valeurs sont des estimations théoriques calculées sous les hypothèses PRG et DLog [Goldreich01, KatzLindell14] ; elles ne constituent pas des mesures empiriques contrôlées. Le produit vaut alors

$$\mathsf{Conf} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \approx 0{,}998.$$

Cette valeur porte sur la fiabilité de vérification et sur une opposabilité calculée sous la convention $\mathsf{Opp} = \min\lbrace 1,\Delta/H(\mathcal{C})\rbrace$, qui suppose que $h$ transmet un contexte d'espèce inconnu de l'institution ; elle n'est pas comparable à la borne du Théorème `thm:trilemme_cro_conditionnel`. En fiabilité de reconstruction, la confidentialité statistique de S-OTP impose $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ (Remarque `rem:rel_ver`), tandis que [MINKA2026CLO] donne un produit de l'ordre de $H(\mathcal{C})/\lambda$. Ce produit élevé n'est réalisable qu'en régime contexte rare ($H(\mathcal{C}) \leq \Delta$). Dès que le contexte s'enrichit ($H(\mathcal{C}) \gg \Delta$), l'opposabilité s'effondre à $\mathsf{Opp} \approx \Delta / H(\mathcal{C}) \ll 1$, ce qui motive les variantes SOTP-Base et SOTP-High.

La Remarque `thm:optimalite_sotp` indique que S-OTP serait optimal dans sa classe, sans le démontrer. Cette optimalité, même établie, resterait restreinte, car les variantes SOTP-Base et SOTP-High utilisent des techniques au-delà des protocoles XOR (compression JL, zk-SNARKs) et surpassent S-OTP dans les régimes appropriés.

## 4. Architecture commune de la famille SOTP

Source : §`subsec:philosophie_sotp`.

Trois couches fonctionnelles structurent chaque protocole. La couche **Gold** accomplit le masquage cryptographique au moyen de one-time pads pseudo-aléatoires dans les régimes bas et intermédiaire [Shannon49, BlumMicali84], preuves zero-knowledge dans le régime riche [GMR85, BenOr88]. La couche **Iron** assure le binding via des commitments contraignants, Pedersen [Pedersen91, ChaumPedersen92] pour SOTP-Low/Base, Groth16 [Groth16, BCTV14] pour SOTP-High, permettant l'ouverture vérifiable du message. La couche **Clay** enfin présente le contexte institutionnel sous une forme que des interprètes à capacité bornée $\Delta$ peuvent exploiter pour rendre leurs verdicts [Simon82, Miller56] ; elle n'accroît $\mathsf{Opp}$ que si elle transmet une information que l'institution ne détient pas déjà (Remarque `rem:statut_sotp`).

L'apport propre à la famille tient à son **adaptation par régime**, puisque chaque variante SOTP spécialise la couche Clay selon l'entropie contextuelle $H(\mathcal{C})$, substituant encodage déterministe, compression Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03, Vempala05] ou hachage SNARK Poseidon [Groth16, Poseidon2019] selon la richesse du contexte.

### Correspondance entre métriques CLO et propriétés cryptographiques

| Métrique CLO | Propriété cryptographique | Hypothèses |
|---|---|---|
| $\mathsf{Conf}$ (notion statistique) | indistinguabilité sémantique [GoldwasserMicali84, MicaliRackoff91] : pour toute paire $(m_0, m_1)$ dans le même contexte $c$, nul adversaire polynomial ne distingue la preuve de $m_0$ de celle de $m_1$ avec avantage non négligeable | PRG [BlumMicali84, Yao82] |
| $\mathsf{Rel}_{\mathrm{ver}}$ (Remarque `rem:rel_ver`) | binding [Pedersen91, Damgard87] : aucun adversaire polynomial ne produit deux ouvertures distinctes d'un même commitment sur des messages différents avec probabilité non négligeable | DLog [DiffieHellman76], q-SDH/q-PKE [BonehBoyen08] |
| $\mathsf{Opp}$ | fraction d'information extractible sur le verdict, $I(V;\Sigma\mid C)/H(V\mid C)$, quantifiée via la capacité d'extraction institutionnelle $\Delta$ (Définition `def:delta_extraction`) | aucune réduction ; dépend de l'interprétation institutionnelle |

Les garanties de confidentialité et de fiabilité de vérification résultent de réductions formelles à des hypothèses cryptographiques standard ; l'opposabilité, elle, dépend de l'interprétation institutionnelle et n'est pas minorée par ces réductions.

### Couche Clay par régime

| Régime | Condition | Technique Clay |
|---|---|---|
| rare | $H(\mathcal{C}) < H^*(\lambda)$ | encodage déterministe $\phi:\mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$, sans perte [Shannon48] |
| transition | $H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log\lambda$ | compression JL [JohnsonLindenstrauss84, Achlioptas2003] depuis $d = \Theta(\Delta \cdot H(\mathcal{C}))$ vers $k = O(\log n/\epsilon^2)$ dimensions, distances préservées à $\epsilon$ près |
| riche | $H(\mathcal{C}) > \lambda/\log\lambda$ | hachage Poseidon [Poseidon2019, Grassi2021] en un condensé de $256$ bits, avec métadonnées structurées |

Les deux seuils de construction sont

$$H^*(\lambda) = \sqrt{\lambda} \qquad\text{et}\qquad H^{**}(\lambda) = \frac{\lambda}{\log_2 \lambda},$$

soit environ $11$ bits et $18$ bits pour $\lambda = 128$. Le seuil $H^*(\lambda)$ est un critère de construction, distinct du seuil $H^\sharp$ du théorème (Remarque `rem:activite_delta`).

Le budget entropique total de chaque preuve SOTP s'écrit

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget)}$$

Pour $\lambda = 128$ et $H(\mathcal{C}) = 40$ bits (vote type Helios [Adida08]), cela donne $\approx 296$ bits. Ce budget contraint la couche Clay, car préserver trop de contexte peut corréler $\Sigma$ avec $m$, réduisant $\mathsf{Conf}$ ; compresser trop agressivement réduit $\mathsf{Opp}$ parce que l'interprète ne peut plus extraire les verdicts [Smith09, Alvim12].

## 5. SOTP-Low (régime à contexte rare)

Source : §`subsec:sotp_low`.

Le régime cible est celui des contextes que l'on peut encoder intégralement dans la preuve, $H(\mathcal{C}) < H^*(\lambda)$, avec $H^*(\lambda) = \sqrt{\lambda}$ comme critère de construction (environ $11$ bits à $\lambda = 128$). Les signatures contractuelles ECDSA [Johnson01, NIST.FIPS.186-5] en sont le cas d'école, puisqu'un contrat standardisé et ses parties sont souvent paramétrés par un contexte d'entropie $H(\mathcal{C}) \approx 20$ bits [Mason07, Kerr04]. Dès lors que $\Delta \gtrsim H(\mathcal{C})$, la capacité institutionnelle absorbe l'intégralité du contexte de sorte que l'opposabilité peut approcher 1.

### Algorithme 1 — SOTP-Low (`alg:sotp_low`)

```text
 1  Paramètres : λ, H(C) < H*(λ), (Δ, α, β)
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

- Tirer la graine dans $\mathbb{Z}_q$ est essentiel. Avec $s \in \lbrace 0,1\rbrace^\lambda$ et un engagement sur $\mathsf{int}(s) \bmod q$, deux graines $s$ et $s+q$ donneraient en effet le même engagement, ce qui ferait perdre le caractère liant.
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

**Partie I. Confidentialité calculatoire.** La loi de $\sigma$ sachant $M = m_i$ ne dépend de $m_i$ que par $\sigma_1$. En effet, $\sigma_2$ est parfaitement masquant (pour tout $s$, $g^s h^\rho$ est uniforme dans $\mathbb{G}$ lorsque $\rho$ est uniforme) tandis que $\sigma_3$ ne dépend que de $c$, indépendant de $m$ ($M \perp C$). Supposons qu'un distingueur PPT $\mathcal{D}$ distingue $m_0 \oplus \mathsf{PRG}(s)$ de $m_1 \oplus \mathsf{PRG}(s)$ avec un avantage non négligeable $\mu(\lambda)$. L'adversaire $\mathcal{B}$ qui reçoit $y$ (sortie du PRG ou chaîne uniforme), tire $b$, soumet $m_b \oplus y$ à $\mathcal{D}$ et répond « PRG » si $\mathcal{D}$ retrouve $b$, distingue le PRG avec un avantage $\mu(\lambda)/2$, puisque si $y$ est uniforme, $m_b \oplus y$ ne contient aucune information sur $b$. Cela contredit la sécurité du PRG [BlumMicali84]. L'avantage IND-CONF de tout adversaire PPT est donc négligeable. La confidentialité est calculatoire. Au sens statistique de la Définition `def:confidentialite_clo`, elle n'est garantie que si le PRG est remplacé par un masque uniforme.

**Partie II. Fiabilité de vérification.** *Complétude.* Pour toute preuve honnête, $\mathsf{Hash}(c) = \sigma_3.\mathsf{hc}$ et $\phi(c) = \sigma_3.h_c$ par construction, $\sigma_2 \in \mathbb{G}$ par fermeture du groupe ; enfin $\mathsf{Open}$ accepte le témoin honnête $(m, s, \rho)$. La complétude est parfaite.

*Liaison (réduction à DLog).* Supposons qu'un adversaire PPT produise une preuve $\sigma$ et deux ouvertures acceptées $(m_0, s_0, \rho_0)$ et $(m_1, s_1, \rho_1)$ avec $m_0 \neq m_1$. Comme $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ et $m_0 \neq m_1$, on a $s_0 \neq s_1$ dans $\mathbb{Z}_q$. L'égalité $g^{s_0} h^{\rho_0} = g^{s_1} h^{\rho_1}$ impose alors $\rho_0 \neq \rho_1$ et

$$\log_g h = \frac{s_0 - s_1}{\rho_1 - \rho_0} \bmod q,$$

ce qui contredit la difficulté du logarithme discret [DiffieHellman76]. La probabilité de gain BIND-REL est donc négligeable, d'où $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$. $\square$

### Illustration : signatures ECDSA

À titre d'illustration (et non de validation, car les métriques CLO d'ECDSA sont des estimations paramétriques analytiques issues des spécifications publiées [Johnson01, NIST.FIPS.186-5] et ECDSA n'est pas une instance du théorème, Remarque `rem:portee_cas_etude`), les paramètres $\Delta = 35$ bits, $\lambda = 128$ donnent pour l'heuristique de SOTP-Low la valeur $0{,}75 \times 35/128 \approx 0{,}205$. Cette valeur n'est pas comparable au produit CLO d'ECDSA ($0{,}273$).

## 6. SOTP-Base (régime de transition)

Source : §`subsec:sotp_base`.

Helios [Adida08, Adida09UCL] est l'archétype de ce régime, puisque le contexte électoral (registre des électeurs, règles du scrutin, procès-verbal) représente $H(\mathcal{C}) \approx 40$–$50$ bits pour une élection de taille moyenne, la capacité d'un comité de garants spécialisés étant estimée à $\Delta \approx 56$ bits. La compression Johnson-Lindenstrauss [JohnsonLindenstrauss84, DasguptaGupta03, Achlioptas2003] permet de projeter le contexte depuis la dimension $d = \Theta(\Delta \cdot H(\mathcal{C}))$ vers $k = O(\log n/\epsilon^2)$ dimensions via une matrice aléatoire $\Phi$, préservant les distances à un facteur $1 \pm \epsilon$ près. Que l'information extractible soit préservée dans la même proportion est une hypothèse de conception, non une conséquence du lemme.

### Algorithme 2 — SOTP-Base, construction avec compression JL (`alg:sotp_base`)

```text
 1  Paramètres : λ, H*(λ) ≤ H(C) ≤ λ/log λ, ε = 0,1
 2  Setup(1^λ) :
 3      Générer (G, q, g, h), PRG, Hash comme SOTP-Low
 4      Fixer d ← ⌈4 Δ H(C) / ε²⌉
 5      Fixer k ← ⌈8 log(2^{H(C)}) / ε²⌉
 6      Générer matrice JL Φ ←$ N(0, 1/k)^{k×d}      [DasguptaGupta03, Vempala05]
 7      Retourner pk = (G, q, g, h, PRG, Hash, Φ, k, d)
 8  Prove(pk, m, c) :
 9      Couches Gold et Iron identiques à SOTP-Low
10      // Clay JL
11      c⃗ ← embed(c) ∈ R^d
12      σ3 ← Φ c⃗ ∈ R^k
13      Retourner σ = (σ1, σ2, σ3)
14  Verify(pk, σ, c) :
15      Vérifier ‖Φ · embed(c) − σ3‖ ≤ ε
16      Vérifier σ2 ∈ G et cohérence Gold
```

Points de construction relevés dans le texte de la thèse.

- La dimension $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ (ligne 4) calibre l'espace de représentation intermédiaire sur le produit de la capacité d'extraction institutionnelle $\Delta$ et de l'entropie contextuelle. La dimension de sortie $k$ (ligne 5) détermine la taille de la couche Clay transmise ; elle est calibrée pour que le lemme JL garantisse la préservation des distances à $\varepsilon = 0{,}1$ près avec haute probabilité. La matrice $\Phi$ (ligne 6) est tirée selon une gaussienne centrée de variance $1/k$, normalisation qui préserve les normes euclidiennes en espérance.
- La fonction $\mathsf{embed}$ (ligne 11) traduit la structure sémantique du contexte en vecteur de réels, de sorte que deux contextes proches sémantiquement produisent des vecteurs proches au sens de la distance euclidienne.
- La vérification (ligne 15) porte sur la proximité $\|\Phi \cdot \mathsf{embed}(c) - \sigma_3\| \leq \varepsilon$ et non sur l'égalité exacte. Avec $\varepsilon = 0{,}1$, $\Delta = 56$ et $H(\mathcal{C}) = 40$, la dimension intermédiaire vaut $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil = 896\,000$.

### Proposition `thm:saturation_sotp_base` (Propriétés cryptographiques de SOTP-Base)

Sous sécurité PRG [BlumMicali84] et difficulté DLog [DiffieHellman76], les couches Gold et Iron de SOTP-Base étant identiques à celles de SOTP-Low, SOTP-Base vérifie les deux propriétés de la Proposition `thm:saturation_sotp_low`, à savoir la confidentialité calculatoire et $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$ pour la procédure d'ouverture. De plus, pour tous contextes $c, c'$, avec probabilité au moins $1 - \delta$ sur le tirage de $\Phi$,

$$\|\Phi\,\mathsf{embed}(c) - \Phi\,\mathsf{embed}(c')\|^2 \in (1 \pm \varepsilon)\|\mathsf{embed}(c) - \mathsf{embed}(c')\|^2$$

(Lemme `lem:johnson_lindenstrauss`).

*Preuve.* Les arguments de la Proposition `thm:saturation_sotp_low` s'appliquent sans changement aux couches Gold et Iron ; la couche Clay n'intervient ni dans la confidentialité (elle ne dépend que de $c$, indépendant de $m$) ni dans la liaison. La dernière propriété est le lemme de Johnson–Lindenstrauss appliqué à l'ensemble fini des plongements de contextes. $\square$

**Remarque `rem:heuristique_sotp_base` (Heuristique de conception de SOTP-Base, non prouvée).** La formulation initiale de ce résultat énonçait $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0{,}5 \cdot \min\lbrace\Delta/d,\ \beta\log_2 d/d\rbrace$. La formalisation a conduit à la remplacer pour les raisons exposées à la Remarque `rem:facteur_limitant_low`. En effet, $\sigma_3 = \Phi\,\mathsf{embed}(c)$ est une fonction du contexte public, donc $I(V;\sigma_3|C) = 0$ ; la préservation des distances n'implique pas celle de l'information extractible ; enfin la dérivation déduisait une minoration d'une majoration. L'expression $0{,}5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ est conservée comme heuristique de dimensionnement de la couche Clay.

### Illustration : vote électronique Helios

À titre d'illustration, l'heuristique de SOTP-Base pour les paramètres analytiques de Helios [Adida08, MINKA2026CRO] ($\Delta = 56$ bits, $\beta = 1{,}4$, $d = 560$) donne $0{,}5 \times \min\lbrace 56/560,\ 56/(1{,}4 \log_2 560)\rbrace \approx 0{,}050$. Cette valeur n'est pas comparable au produit CLO de Helios ($0{,}437$), qui porte sur $\mathsf{Rel}_{\mathrm{ver}}$ et n'est pas une instance du théorème (Remarque `rem:portee_cas_etude`). La dimension $d = 560$ retenue ici est un choix de dimensionnement, distinct de la règle $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$.

## 7. SOTP-High (régime à contexte riche)

Source : §`subsec:sotp_high`.

La conformité financière via zk-SNARKs [Groth16, Garratt15, BaselIII] illustre ce régime, où transactions complexes, réglementations multi-juridictionnelles et historiques longs produisent $H(\mathcal{C}) \approx 70$–$90$ bits. Les zk-SNARKs succincts (Groth16 [Groth16, BCTV14, Gennaro13]) produisent une preuve de taille constante ($\approx 128$–$200$ octets) indépendante de la complexité du circuit vérifié. Cette solution a une double contrepartie. Une étape de mise en place de confiance (*trusted setup*) est requise [Bowe2017] ; par ailleurs l'opposabilité, plafonnée par la perte entropique du hachage compressant le contexte en 256 bits, est réduite.

### Algorithme 3 — SOTP-High, construction avec zk-SNARKs Groth16 (`alg:sotp_high`)

```text
 1  Paramètres : λ, H(C) > λ/log λ, circuit C_circuit
 2  Setup(1^λ, C_circuit) :
 3      échantillonner τ, α_s, β_s, γ, δ ←$ F_p^*  (toxiques)
 4      Construire pk_prove et vk_verify (CRS Groth16)      [Groth16, BCTV14]
 5      // Détruire toxiques : τ, α_s, β_s, γ, δ
 6      (g, h) ←$ G² pour couche Iron
 7      Retourner pk = (pk_prove, vk_verify, g, h)
 8  Prove(pk, m, c) :
 9      // Gold + Iron (Groth16 + Pedersen)
10      ρ ←$ Z_q ;  c_m ← g^m · h^ρ                         [Pedersen91]
11      h_c ← Poseidon(c) ;  π ← Groth16.Prove(pk_prove, (h_c, c_m), (m, c, ρ))
12      relation : h_c = Poseidon(c) ∧ c_m = g^m h^ρ ∧ Conforme(m, c) = 1
13      // Clay : condensé hash + métadonnées
14      Retourner σ = (h_c, π, c_m, metadata)
15  Verify(σ) :
16      b1 ← Groth16.Verify(vk_verify, (h_c, c_m), π)
17      b2 ← [c_m ∈ G]
18      Retourner b1 ∧ b2
```

Points de construction relevés dans le texte de la thèse.

- La ligne 5 est un impératif de sécurité. Si l'un quelconque des cinq scalaires toxiques subsistait après le $\mathsf{Setup}$, son détenteur pourrait forger des preuves valides pour n'importe quelle assertion. En pratique, cette destruction est réalisée via une étape multi-partite où la compromission simultanée de tous les participants serait nécessaire pour reconstituer les toxiques.
- La preuve $\pi$ atteste que le prouveur connaît $(m, c, \rho)$ tels que $h_c = \mathsf{Poseidon}(c)$, $c_m = g^m h^\rho$ et que le prédicat de conformité $\mathsf{Conforme}(m, c)$ est satisfait.
- L'information contextuelle que l'arbitre peut extraire de $h_c$ est bornée par la taille du condensé ($256$ bits). Elle est même nulle si $c$ est déjà connu de l'institution. Ce que la preuve apporte au verdict tient à l'assertion certifiée ($\mathsf{Conforme}(m,c) = 1$), non au condensé.

Une implémentation exécutable de cet algorithme (Circom/Groth16) est fournie séparément dans [`../high/`](../high/).

### Proposition `thm:saturation_sotp_high` (Propriétés cryptographiques de SOTP-High)

Sous les hypothèses q-SDH et q-PKE (*knowledge soundness* de Groth16 [BonehBoyen08, BCTV14]), la difficulté DLog et une cérémonie de mise en place de confiance honnête [Bowe2017] :

1. la preuve $\pi$ est à divulgation nulle de connaissance parfaite et $c_m$ est parfaitement masquant, de sorte que $(\pi, c_m)$ ne révèle rien de $m$ au-delà des entrées publiques ;
2. la complétude est parfaite et, par la *knowledge soundness*, pour tout prouveur PPT qui fait accepter $\sigma$, il existe un *extracteur* (qui rembobine le prouveur ou exploite la trappe de l'hypothèse q-PKE, contrairement au vérificateur) produisant un témoin $(m, c, \rho)$ satisfaisant la relation ; d'où $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$.

**Remarque `rem:heuristique_sotp_high` (Heuristique de conception de SOTP-High, non prouvée).** La formulation initiale de ce résultat énonçait $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0{,}45 \cdot \beta\log_2\lambda/\lambda$, avec une constante $0{,}45$ « calibrée » sur les systèmes déployés. La formalisation a conduit à la remplacer. Le condensé $h_c = \mathsf{Poseidon}(c)$ et les métadonnées sont des fonctions du contexte public ($I(V;h_c|C) = 0$) ; trois éléments de groupe représentent $\Theta(\lambda)$ bits et non $O(\log\lambda)$ ; le vérificateur ne peut extraire le témoin, faute de quoi la preuve ne serait pas à divulgation nulle ; enfin une constante ajustée sur des données n'a pas sa place dans un énoncé de théorème. L'expression $0{,}45\,\beta\log_2\lambda/\lambda$ est conservée comme heuristique de conception ; $\beta$ y désigne la constante de régularité du protocole (Définition `def:beta_regularite`).

### Illustration : conformité zk-SNARKs

Pour les paramètres analytiques $\Delta = 73$ bits, $\alpha = 1{,}5$, $\beta = 1{,}5$, $\lambda = 128$ (estimations paramétriques, non mesure empirique contrôlée), l'heuristique de SOTP-High donne $0{,}45 \times 1{,}5 \times 7/128 \approx 0{,}037$. Cette valeur n'est pas comparable au produit CLO des zk-SNARKs de conformité ($\approx 0{,}572$), qui porte sur $\mathsf{Rel}_{\mathrm{ver}}$ et n'est pas une instance du théorème (Remarque `rem:portee_cas_etude`).

## 8. Synthèse et sélection de variante

Source : §`subsec:synthese_selection`.

### Tableau `tab:comparaison_sotp_construction` — Comparaison des variantes SOTP

| Critère | SOTP-Low | SOTP-Base | SOTP-High |
|---|---|---|---|
| ***Régime opérationnel*** | | | |
| Entropie $H(\mathcal{C})$ | $< H^*(\lambda) \approx O(\sqrt{\lambda})$ | $H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log\lambda$ | $> \lambda/\log\lambda$ |
| Valeurs ($\lambda = 128$) | $< 11$ bits | $11$–$18$ bits | $> 18$ bits |
| ***Techniques cryptographiques*** | | | |
| Couche Gold | PRG [BlumMicali84] | PRG [BlumMicali84] | Perfect ZK Groth16 [Groth16] |
| Couche Iron | Pedersen [Pedersen91] | Pedersen [Pedersen91] | q-SDH Soundness [BonehBoyen08] |
| Couche Clay | $\phi:\mathcal{C}\to\lbrace 0,1\rbrace^{H(\mathcal{C})}$ | JL $\Phi:\mathbb{R}^d\to\mathbb{R}^k$ [JohnsonLindenstrauss84] | Poseidon + SNARK [Poseidon2019] |
| Primitives | SHA-256, Pedersen | Gaussienne, Pedersen | Groth16, Poseidon, BLS12-381 [BLS12-381] |
| ***Métriques CLO atteintes*** | | | |
| Confidentialité | calculatoire (PRG) | calculatoire (PRG) | ZK parfait |
| $\mathsf{Rel}_{\mathrm{ver}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{q-SDH}}$ |
| $\mathsf{Opp}$ | dépend du contexte d'espèce transmis | idem | idem |
| ***Heuristique de conception (non prouvée)*** | | | |
| Expression | $0{,}75 \cdot \Delta/\lambda$ | $0{,}5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ | $0{,}45 \cdot \beta\log_2\lambda/\lambda$ |
| Trusted setup | Non | Non | Oui [Bowe2017] |
| ***Illustration (non comparable aux produits CLO)*** | | | |
| Système de référence | ECDSA [Johnson01] | Helios [Adida08] | zk-SNARKs conformité [Groth16] |
| Valeur de l'heuristique | $\approx 0{,}205$ | $\approx 0{,}050$ | $\approx 0{,}037$ |
| Produit CLO (échelle $\mathsf{Rel}_{\mathrm{ver}}$) | $\approx 0{,}273$ | $\approx 0{,}437$ | $\approx 0{,}572$ |

Les trois variantes forment un continuum adaptatif couvrant l'ensemble du spectre d'entropie contextuelle. SOTP-Low privilégie la lisibilité du contexte au prix d'une restriction sur $H(\mathcal{C})$, idéal pour applications juridiques ou contractuelles [Mason07, Kerr04]. SOTP-Base équilibre les trois métriques via compression adaptative, polyvalent pour applications gouvernementales et électorales [Adida08, Goodman15]. SOTP-High sacrifie l'opposabilité pour la confidentialité parfaite et la scalabilité, nécessaire pour applications financières ou médicales à contexte très riche [Garratt15, BaselIII].

### Algorithme 4 — Sélection automatique de variante SOTP (`alg:selection_variante_sotp`)

```text
 1  Entrées : H(C), Δ, λ, Priority, TrustedSetup_OK
 2  H*(λ) ← √λ ;  H**(λ) ← λ / log2 λ
 3  si TrustedSetup_OK = False et H(C) > H**(λ) alors
 4      ALERTE : SOTP-High requis mais trusted setup indisponible   [Bowe2017]
 5      Recommander : SOTP-Base avec perte d'opposabilité, ou déployer MPC
 6      Retourner SOTP-Base
 7  fin si
 8  si H(C) < H*(λ) alors
 9      Retourner SOTP-Low
10  sinon si H(C) ≤ H**(λ) alors
11      Retourner SOTP-Base ;  d ← ⌈4 Δ H(C) / ε²⌉
12  sinon
13      Retourner SOTP-High ;  compiler circuit C_circuit
14  fin si
```

Cet algorithme n'est pas une construction cryptographique mais un méta-algorithme de déploiement. Les lignes 3 à 7 constituent la garde de sécurité opérationnelle. Si le trusted setup n'a pas été conduit et que le contexte est néanmoins riche, l'algorithme émet une alerte explicite plutôt que de dégrader silencieusement la sécurité. Il recommande alors soit d'accepter SOTP-Base avec la perte d'opposabilité associée, soit de déployer un protocole MPC pour réaliser le trusted setup de manière distribuée. Le calcul de $d$ est effectué à la sélection et non dans le $\mathsf{Setup}$ pour permettre d'adapter $d$ à la valeur effective de $H(\mathcal{C})$ observée au moment du déploiement. La logique de sélection reflète une hiérarchie de préférences implicite. SOTP-Low est préféré quand il est applicable (coût minimal, pas de dépendance externe), SOTP-Base est le choix par défaut en régime intermédiaire (robuste, sans trusted setup), alors que SOTP-High n'est déployé que lorsque la richesse contextuelle le rend inévitable et que les conditions opérationnelles le permettent.

### Méthodologie de conception en cinq phases

1. **Analyse applicative.** Estimer $H(\mathcal{C})$ et identifier les exigences minimales $\mathsf{Conf}_{\min}$, $\mathsf{Rel}_{\min}$, $\mathsf{Opp}_{\min}$.
2. **Évaluation institutionnelle.** Estimer $\Delta$ (capacité de délibération, expertise, mémoire institutionnelle) et $\alpha$ (granularité des verdicts). Ces estimations sont analytiques, car une mesure directe via protocoles cognitifs contrôlés reste un travail futur.
3. **Test de faisabilité.** Vérifier l'inégalité
   $$\mathsf{Conf}_{\min} \cdot \mathsf{Rel}_{\mathrm{rec},\min} \cdot \mathsf{Opp}_{\min} \stackrel{?}{\leq} \frac{1+\kappa/\lambda}{\lambda}\,\min\left\lbrace 1, \frac{\kappa/\lambda + \Delta}{\gamma}\right\rbrace \qquad \text{(eq:test\_faisabilite\_sotp)}$$
   pour les exigences exprimées en fiabilité de reconstruction (équation `eq:trilemme_cro_raffine`). Si l'inégalité est violée, il est possible de relaxer une exigence ; augmenter $\Delta$ par investissement dans la formation institutionnelle (effectif seulement si $\Delta < \gamma$) ; ou réviser la granularité des verdicts. Les exigences exprimées en fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$ ne sont pas contraintes par ce test.
4. **Sélection et paramétrage.** Appliquer l'Algorithme `alg:selection_variante_sotp` et optimiser les primitives Gold/Iron/Clay dans le régime identifié.
5. **Preuves et validation.** Établir les réductions formelles aux hypothèses standard, puis mesurer $\Delta$ et l'opposabilité obtenue selon les protocoles du chapitre `chap:experimentation`.

## 9. Conjecture d'optimalité universelle et analyse de sensibilité

Source : §`subsec:optimalite_sensibilite`.

**Conjecture `conj:optimalite_universelle` (Optimalité universelle SOTP).** Sous les Hypothèses `ass:extraction_bornee`–`ass:regime`, pour chaque régime de richesse contextuelle, il existe une variante SOTP et une constante $C_R \geq 1$ indépendante de $\lambda$ telles que, pour tout protocole CLO $\mathcal{P}'$ du même régime,

$$\mathsf{Conf}(\mathcal{P}')\,\mathsf{Rel}_{\mathrm{rec}}(\mathcal{P}')\,\mathsf{Opp}(\mathcal{P}') \ \leq\ C_R \cdot \mathsf{Conf}(\text{SOTP})\,\mathsf{Rel}_{\mathrm{rec}}(\text{SOTP})\,\mathsf{Opp}(\text{SOTP}). \qquad \text{(eq:optimalite\_universelle)}$$

**Remarque `rem:statut_optimalite` (Statut et argument heuristique).** La formulation initiale de cet énoncé, présentée comme théorème sous la forme $\text{produit}(\mathcal{P}') \leq c \cdot \text{produit}(\text{SOTP}) + o(1)$ avec $c \in [0{,}45;\,0{,}75]$, a été remplacée par une formulation plus précise, pour quatre raisons. (i) Avec $c < 1$ et $\mathcal{P}' = \text{SOTP}$, elle donnerait $\text{produit} \leq 0{,}75 \times \text{produit}$, ce qui impose $C_R \geq 1$ ; (ii) le terme additif $o(1)$ domine des produits tous en $O(1/\lambda)$ ; (iii) son argument invoquait le trilemme sans l'Hypothèse `ass:regime` ; (iv) elle s'appuyait sur les minorations des Remarques `rem:facteur_limitant_low`, `rem:heuristique_sotp_base` et `rem:heuristique_sotp_high`, qui relèvent d'heuristiques de conception. La forme multiplicative ci-dessus, avec $C_R \geq 1$, est l'énoncé que l'argument vise. Celui-ci procède en trois temps, qui consistent à majorer le produit de tout $\mathcal{P}'$ par la forme raffinée (`eq:trilemme_cro_raffine`) ; minorer celui de la variante SOTP du régime ; former le ratio. La deuxième étape reste ouverte, car elle requiert un modèle dans lequel la couche Clay transmet un contexte d'espèce que l'institution ne détient pas (perspective développée au chapitre `chap:resultats_discussions`). Les rapports indicatifs que donneraient les heuristiques de conception, $1/0{,}75 \approx 1{,}33$ (SOTP-Low), $1/0{,}5 = 2$ (SOTP-Base) et $1/0{,}45 \approx 2{,}2$ (SOTP-High), fixent l'ordre de grandeur de $C_R$ visé.

### Analyse de sensibilité

L'analyse porte sur la borne raffinée (`eq:trilemme_cro_raffine`), qui est le seul énoncé prouvé, ainsi que sur les heuristiques de conception.

- **Sensibilité à $\Delta$.** Dans le régime à contexte riche ($\Delta < \gamma$), la borne est proportionnelle à $\kappa/\lambda + \Delta$. Augmenter $\Delta$ de $50$ à $65$ bits (formation intensive des garants [Ericsson95]) relève la borne d'environ $30\%$. Dans le régime à contexte rare ($\Delta \geq \gamma$), la borne est celle de Fano et ne dépend pas de $\Delta$.
- **Sensibilité à $\alpha$.** Dans le régime à contexte riche, la borne varie en $1/\gamma = 1/(\alpha H(\mathcal{C}) - 1)$, de sorte que des verdicts plus grossiers (passer de 12 niveaux à 6) relèvent la borne et peuvent faire basculer l'institution dans le régime à contexte rare. Les institutions à verdicts très nuancés (échelles de risque fines, montants d'amendes gradués) paient ainsi une pénalité réelle. L'optimum entre précision décisionnelle et compromis CRO dépend des priorités applicatives.
- **Sensibilité à $\beta$.** La constante $\beta$ n'apparaît pas dans la borne ; elle intervient dans la garantie de confidentialité du Lemme `lem:confidentiality_guarantee`, où un protocole plus régulier (plus petit $\beta$) resserre cette garantie. Dans l'heuristique de SOTP-High, qui est proportionnelle à $\beta$, passer de $\beta = 1{,}5$ à $\beta = 1{,}2$ *diminue* la valeur de $20\%$. $\beta$ est une propriété des lois de preuve (divergence KL) plutôt que de la fonction de hachage utilisée dans le circuit.

## 10. Extension quantique

Source : §`subsec:extension_postquantique_sotp`.

- **SOTP-Low post-quantique.** La couche Gold peut intégrer des PRG basés sur les fonctions de hachage (résistants aux attaques quantiques via l'algorithme de Grover [Grover96], qui réduit la sécurité de $\lambda$ à $\lambda/2$ bits). L'engagement de Pedersen reste parfaitement masquant, mais son caractère liant repose sur DLog, que l'algorithme de Shor résout. Il doit donc être remplacé par un engagement post-quantique, par exemple à base de réseaux sous SIS/LWE [Peikert2016].
- **SOTP-Base post-quantique.** La compression JL est indépendante du modèle adversaire [JohnsonLindenstrauss84, DasguptaGupta03]. Les adaptations concernent les couches Gold et Iron avec des primitives post-quantiques (engagement à base de réseaux [Peikert2016], signatures ML-DSA [Dilithium2022]).
- **SOTP-High post-quantique.** Les zk-SNARKs Groth16 nécessitent une attention particulière [Unruh2016, Chatterjee2021]. Les hypothèses q-SDH et q-PKE peuvent être affaiblies face à des adversaires quantiques (elles reposent sur des couplages, que l'algorithme de Shor compromet). Les STARKs [BenSasson2019], qui ne reposent que sur des fonctions de hachage, constituent l'alternative post-quantique ; les Bulletproofs [Bulletproofs2018] reposent sur DLog et ne sont pas post-quantiques.

Le coefficient de perte d'interprétabilité $\eta_q$ (Définition `def:perte_interp_quantique`) s'applique à toutes les variantes lorsque la preuve transite par un support quantique

$$\mathsf{Opp}^q \geq \mathsf{Opp} - \eta_q\,\frac{H(C)}{H(V|C)},$$

et $\eta_q = 0$ lorsque la preuve reste une chaîne de bits classique.

## 11. Notes de transcription

Ces notes signalent des points du texte source sans modifier les énoncés.

<a id="t4"></a>**T4.** Dans l'Algorithme 2, $d$ désigne la dimension du plongement et $k$ la dimension de sortie ($\Phi : \mathbb{R}^d \to \mathbb{R}^k$). L'annexe A note la projection $\Phi : \mathbb{R}^n \to \mathbb{R}^d$, où $d$ est la dimension de sortie. La ligne 5 ne précise pas la base du logarithme ; avec $N = 2^{H(\mathcal{C})}$ et le logarithme népérien, elle coïncide avec $(4/\varepsilon^2)\ln(N^2)$, c'est-à-dire la dimension du lemme de dimensionnement de l'annexe A sans son terme de probabilité d'échec.
