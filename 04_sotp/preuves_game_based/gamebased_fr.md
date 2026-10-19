> **Statut : PROPOSITION — construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, annexe A (`chap:annexe_gamebased`), fichier [gamebased_source_fr.tex](gamebased_source_fr.tex)

# Sécurité game-based et réductions formelles pour la famille SOTP

*English version: [gamebased_en.md](gamebased_en.md)*

Transcription Markdown de l'annexe A de la thèse, dans sa version finale. Les énoncés, jeux, réductions et preuves sont reproduits sans modification. Les commentaires marginaux pédagogiques de la source (macros `\cmt` et `\cmtFormule`) sont omis ; ils figurent dans [gamebased_source_fr.tex](gamebased_source_fr.tex). Les renvois internes sont donnés par leur étiquette LaTeX et les références par leur clé. La spécification des algorithmes se trouve dans [../specification/sotp_specification_fr.md](../specification/sotp_specification_fr.md).

## Introduction

Le cadre CLO définit $\mathsf{Conf}$, $\mathsf{Rel}$ et $\mathsf{Opp}$ avec des termes issus de la théorie de l'information, à savoir les entropies conditionnelles, l'information mutuelle et la distance de variation totale [MINKA2026CLO]. Cette approche permet des résultats généraux (Théorème du Goulot d'étranglement Contextuel, Trilemme CRO Conditionnel), mais ne précise pas directement *ce qu'un adversaire calculatoirement borné peut ou ne peut pas faire*. En cryptographie computationnelle, la sécurité s'exprime classiquement via des *jeux* (games) entre un challenger et un adversaire probabiliste polynomial-time (PPT).

*Pourquoi cette annexe.* Le cadre CLO raisonne en bits et en entropies, alors que la cryptographie classique raisonne en jeux et en avantages d'adversaires. Cette annexe construit le pont entre les deux en capturant chaque métrique du cadre CLO par un jeu cryptographique, puis en reliant chaque jeu à une hypothèse de dureté standard (PRG, DLOG, JL, Groth16).

Cette annexe établit le **pont formel** entre les deux mondes en trois étapes.

1. Définir des jeux cryptographiques (*IND-CONF*, *BIND-REL*, *EXT-OPP*) capturant opérationnellement $\mathsf{Conf}$ (dans sa version calculatoire), $\mathsf{Rel}_{\mathrm{ver}}$ et $\mathsf{Opp}$
2. Prouver des *réductions* formelles établissant que, si un adversaire PPT gagne l'un de ces jeux, il résout un problème supposé difficile (PRG, logarithme discret, JL, Groth16)
3. Dériver une **minoration game-based du produit CLO** (Corollaire `cor:ann_cro_from_games`), à l'échelle opérationnelle (confidentialité calculatoire, fiabilité de vérification), qui ne se compare pas directement au Trilemme (Remarque `rem:ann_pas_de_contradiction`)

*Trois jeux, trois métriques.* **IND-CONF** capte la confidentialité en exigeant que l'adversaire ne puisse distinguer les preuves de deux messages. **BIND-REL** capte la fiabilité, puisque l'adversaire ne doit pas pouvoir ouvrir une preuve sur deux messages distincts. Enfin, **EXT-OPP** capte l'opposabilité, l'interprète institutionnel devant extraire le bon verdict depuis la preuve.

**Convention.** Tout adversaire $\mathcal{A}$ est probabiliste polynomial-time (PPT) en $\lambda$ sauf mention contraire. Le challenger est noté $\mathcal{C}$. Une réduction construit un algorithme $\mathcal{B}$ (réducteur) qui exploite $\mathcal{A}$ pour résoudre un problème difficile.

**Tableau `tab:ann_g_structure` — Structure de l'annexe**

| Section | Contenu | Propriété | Hypothèse |
|---|---|---|---|
| [A.1](#a1-primitives-cryptographiques-et-définitions-préalables) | Primitives et définitions préalables | – | – |
| [A.2](#a2-jeu-ind-conf--confidentialité-game-based) | Jeu IND-CONF + lien $\mathsf{Conf}$ | $\mathsf{Conf}$ | PRG |
| [A.3](#a3-jeu-bind-rel--fiabilité-game-based) | Jeu BIND-REL + lien $\mathsf{Rel}_{\mathrm{ver}}$ | $\mathsf{Rel}_{\mathrm{ver}}$ | DLOG |
| [A.4](#a4-jeu-ext-opp--opposabilité-game-based) | Jeu EXT-OPP + lien $\mathsf{Opp}$ | $\mathsf{Opp}$ | Fano |
| [A.5](#a5-réductions-formelles-pour-sotp-low) | Réductions SOTP-Low | $\mathsf{Conf}_{\mathrm{calc}}$, $\mathsf{Rel}_{\mathrm{ver}}$ | PRG, DLOG |
| [A.6](#a6-réduction-jl-pour-sotp-base) | Dimensionnement SOTP-Base | – | JL |
| [A.7](#a7-réductions-pour-sotp-high) | Réductions SOTP-High | $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ | Groth16 |
| [A.8](#a8-énoncés-complets-et-produit-cro-game-based) | Énoncés complets + produit CLO | $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ | Tous |
| [A.9](#a9-limitations-et-portée-des-réductions) | Limitations et portée | – | – |

---

## A.1 Primitives cryptographiques et définitions préalables

*Objectif de cette section.* Rappeler les quatre primitives cryptographiques utilisées dans la famille SOTP, à savoir le PRG (couche Gold), l'engagement de Pedersen (couche Iron), le zk-SNARK Groth16 (SOTP-High) et la transformation Johnson-Lindenstrauss (SOTP-Base), ainsi que deux outils théoriques, l'inégalité de Fano et le DPI.

### Générateur pseudo-aléatoire (PRG)

**Intuition.** Un PRG prend une graine courte $s \in \lbrace 0,1\rbrace^\lambda$ et produit une longue séquence $G(s) \in \lbrace 0,1\rbrace^{L(\lambda)}$, $L > \lambda$, indiscernable d'une séquence vraiment aléatoire. Il fonde la couche Gold de SOTP-Low, dans laquelle le pad $G(s)$ masque le message de sorte que, sans $s$, aucun adversaire PPT ne peut récupérer $m$ depuis $m \oplus G(s)$.

**Définition `def:ann_prg` (Sécurité PRG [GoldreichKrawczyk99]).** Une fonction calculable en temps polynomial $G : \lbrace 0,1\rbrace^\lambda \to \lbrace 0,1\rbrace^{L(\lambda)}$ avec $L(\lambda) > \lambda$ est un PRG sûr si, pour tout adversaire PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{A}}(\lambda) = \left| \Pr_{s \leftarrow \lbrace 0,1\rbrace^\lambda}\big[\mathcal{A}(G(s)) = 1\big] - \Pr_{y \leftarrow \lbrace 0,1\rbrace^{L(\lambda)}}\big[\mathcal{A}(y) = 1\big] \right| \leq \mathrm{negl}(\lambda)$$

**Implémentations pratiques.** SOTP-Low utilise ChaCha20/AES-CTR, deux PRG standardisés atteignant cette définition.

### Engagement de Pedersen

**Intuition.** L'engagement de Pedersen permet à un prouveur de « s'engager » sur $m$ sans le révéler (*perfect hiding*), tout en étant incapable de changer d'avis (*computational binding*). La construction $\mathsf{Com}(m, r) = g^m h^r$ exploite l'algèbre des groupes cycliques, de sorte que toute collision d'engagements permettrait de calculer $\log_g h$, résolvant le logarithme discret.

**Définition `def:ann_pedersen` (Engagement de Pedersen [Pedersen91]).** Soit $\mathbb{G}$ un groupe cyclique d'ordre premier $q$, $g, h \in \mathbb{G}$ deux générateurs tels que $\log_g h$ est inconnu.

- $\mathsf{Com}(m, r) = g^m h^r \in \mathbb{G}$, $m,r \in \mathbb{Z}_q$ (opération de groupe)
- $\mathsf{Open}(\sigma_2, m, r)$ accepte si $\sigma_2 = g^m h^r$

**Perfect Hiding.** Pour tout $m_0, m_1$, les engagements $\mathsf{Com}(m_0, r_0)$ et $\mathsf{Com}(m_1, r_1)$ sont identiquement distribués pour $r_0, r_1 \xleftarrow{\$} \mathbb{Z}_q$.

**Computational Binding.** Aucun adversaire PPT ne peut trouver $(m_0, r_0, m_1, r_1)$ avec $m_0 \neq m_1$ tel que $g^{m_0} h^{r_0} = g^{m_1} h^{r_1}$ dans $\mathbb{G}$.

**Rôle dans SOTP.** La couche Iron de toute variante SOTP est un engagement de Pedersen (sur la graine $s \in \mathbb{Z}_q$ pour SOTP-Low et SOTP-Base, sur $m$ pour SOTP-High). Il garantit la fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$, puisqu'une preuve ne peut pas être « ouverte » sur deux messages distincts.

### zk-SNARK Groth16

**Intuition.** Un zk-SNARK pour une relation $\mathcal{R}$ permet de prouver qu'on connaît un témoin $w$ tel que $(x,w) \in \mathcal{R}$, sans révéler $w$, en une preuve de taille constante. Une preuve Groth16 compte trois éléments de groupe, soit 128 octets (points compressés) sur BN254 ou 192 octets sur BLS12-381 ; elle se vérifie en $O(1)$ couplages.

**Définition `def:ann_groth16` (zk-SNARK Groth16 [Groth16]).** $(\mathsf{Setup}, \mathsf{Prove}, \mathsf{Verify})$ satisfait les propriétés suivantes.

**Complétude parfaite.** $\Pr[\mathsf{Verify}(\sigma_v,x,\pi)=1 \mid (x,w)\in\mathcal{R}] = 1$

**Solidité connaissance.** Pour tout PPT $\mathcal{A}$, il existe un extracteur $\mathcal{E}$ tel que

$$\Pr\left[ \mathsf{Verify}(\sigma_v,x,\pi)=1 \land (x,w)\notin\mathcal{R} \;:\; (x,\pi)\leftarrow\mathcal{A}(\sigma_p),\ w\leftarrow\mathcal{E}(\sigma_p) \right] \leq \mathrm{negl}(\lambda)$$

**Zéro-connaissance parfaite.** Il existe un simulateur $\mathcal{S}$ tel que pour tout $(x,w)\in\mathcal{R}$,

$$\lbrace\pi :  \pi \leftarrow \mathsf{Prove}(\sigma_p,x,w)\rbrace \equiv \lbrace\pi :  \pi \leftarrow \mathcal{S}(\sigma_p,x)\rbrace \quad\text{(distributions identiques)}$$

**Lecture pour SOTP-High.** La zéro-connaissance *parfaite*, jointe au masquage parfait de l'engagement $c_m$, implique que $(\pi, c_m)$ est indépendant de $m$ sachant $c$, d'où $\mathsf{Conf} = 1$ au sens statistique. La solidité connaissance implique la fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$ ; elle ne dit rien de la fiabilité de reconstruction, qui vaut $2^{-\lambda}$ lorsque $\mathsf{Conf} = 1$ (Remarque `rem:rel_ver`).

### Transformation Johnson-Lindenstrauss (JL)

**Intuition.** La JL-transform projette $N$ points de $\mathbb{R}^n$ dans $\mathbb{R}^d$ ($d \ll n$) en préservant approximativement toutes les distances par paires. Dans SOTP-Base, les contextes $c \in \mathbb{R}^n$ sont compressés en $\Phi c \in \mathbb{R}^d$, conservant la structure permettant l'extraction institutionnelle.

**Définition `def:ann_jl` (Transformation JL [JohnsonLindenstrauss84, DasguptaGupta03]).** Pour $0 < \varepsilon < 1$, $N > 0$, $S \subset \mathbb{R}^n$ avec $|S| = N$, il existe $\Phi : \mathbb{R}^n \to \mathbb{R}^d$ avec $d = O(\varepsilon^{-2} \log N)$ telle que, pour tout $x,y \in S$,

$$(1-\varepsilon)\|x-y\|^2 \leq \|\Phi x-\Phi y\|^2 \leq (1+\varepsilon)\|x-y\|^2$$

**Lemme de dimension pour SOTP-Base.** La dimension minimale $d$ pour préserver $\Delta$ bits d'extraction avec tolérance $\varepsilon^2$ est donnée par la condition

$$d \geq \frac{4\Delta H(\mathcal{C})}{\varepsilon^2} \qquad \text{(eq:ann\_jl\_dim)}$$

### Outils théoriques fondamentaux

**Lemme `lem:ann_g_fano` (Inégalité de Fano [CoverThomas06]).** Soit $X$ une variable à $k$ valeurs, $\hat{X}$ un estimateur, $p_e = \Pr[X \neq \hat{X}]$. Alors

$$H(X|\hat{X}) \leq h(p_e) + p_e \log_2(k-1)$$

**Lecture.** Faible erreur d'extraction $p_e$ $\Rightarrow$ faible incertitude résiduelle $H(X|\hat{X})$ $\Rightarrow$ grande information mutuelle extraite. Ce lemme est le pont direct entre le jeu EXT-OPP et la métrique $\mathsf{Opp}$.

**Lemme `lem:ann_dpi` (Traitement de l'information, DPI [CoverThomas06]).** Si $X \to Y \to Z$ forme une chaîne de Markov, alors $I(X;Z) \leq I(X;Y)$.

**Lecture.** Toute transformation de $Y$ ne peut qu'augmenter l'incertitude sur $X$. Un adversaire observant $\sigma$ ne peut extraire au plus que $I(M;\Sigma|C)$ bits sur $m$, fondation du lien entre $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}$ et $I(M;\Sigma|C)$.

## A.2 Jeu IND-CONF : confidentialité game-based

*Objectif de cette section.* Définir le jeu IND-CONF qui capture la confidentialité, puis établir son lien avec la métrique $\mathsf{Conf}$ du cadre CLO.

### Définition du jeu

**Intuition.** L'adversaire choisit deux messages $m_0, m_1$, reçoit la preuve de l'un des deux (au choix secret du challenger) puis doit deviner lequel. Si le protocole est confidentiel, l'adversaire ne fait pas mieux qu'une devinette aléatoire (avantage $\approx 0$).

**Définition `def:ann_ind_conf` (Jeu IND-CONF).** Pour un protocole $\mathcal{P} = (\mathsf{Setup},\mathsf{Prove}, \mathsf{Verify})$ et un adversaire $\mathcal{A}$, le jeu se déroule comme suit.

1. $\mathcal{A}$ reçoit $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ choisit $m_0,m_1 \in \mathcal{M}_\lambda$ ($|m_0|=|m_1|$) et $c \in \mathcal{C}_\lambda$ *(phase de défi)*
3. Le challenger tire $b \xleftarrow{\$} \lbrace 0,1\rbrace$ et calcule $\sigma \leftarrow \mathsf{Prove}(pp, m_b, c)$
4. $\mathcal{A}$ reçoit $\sigma$ et émet $b' \in \lbrace 0,1\rbrace$ *(phase de réponse)*
5. L'expérience produit 1 si $b' = b$, sinon 0

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) = \left|\Pr\left[ \mathsf{Exp}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) = 1\right] - \frac{1}{2}\right|$$

### Lien avec $\mathsf{Conf}$ au sens de la théorie de l'information

**Remarque `rem:ann_ind_conf_link` (Pont IND-CONF $\leftrightarrow$ $\mathsf{Conf}$).** Pour tout distingueur $\mathcal{A}$, même non borné en calcul, on a

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) \;\leq\; \frac{1 - \mathsf{Conf}(\mathcal{P})}{2},$$

avec égalité pour le test de Neyman–Pearson sur la paire la plus distinguable (Remarque `rem:jeu_ind_conf_link`). Un protocole avec $\mathsf{Conf} \geq 1 - \mathrm{negl}(\lambda)$ résiste donc au jeu IND-CONF. La réciproque est fausse, car la résistance à IND-CONF contre les adversaires PPT est une propriété calculatoire, compatible avec une confidentialité statistique faible. Les réductions de cette annexe établissent des garanties calculatoires, que nous notons $\mathsf{Conf}_{\mathrm{calc}}$ lorsqu'il faut les distinguer de $\mathsf{Conf}$.

## A.3 Jeu BIND-REL : fiabilité game-based

*Objectif de cette section.* Définir le jeu BIND-REL qui capture la fiabilité (non-équivocité), puis établir son lien avec la métrique $\mathsf{Rel}_{\mathrm{ver}}$.

### Définition du jeu

**Intuition.** Le jeu capture la *non-équivocité*, selon laquelle un adversaire ne doit pas pouvoir produire une preuve $\sigma$ ouvrable sur deux messages distincts $m_0 \neq m_1$. Contrairement à IND-CONF, l'adversaire choisit librement $(c, \sigma, s_0, s_1)$, modélisant un agent qui forge délibérément une preuve ambiguë.

**Définition `def:ann_bind_rel` (Jeu BIND-REL).** Pour un protocole $\mathcal{P}$ avec $\mathsf{Open}$ et un adversaire $\mathcal{A}$, le jeu se déroule comme suit.

1. $\mathcal{A}$ reçoit $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ produit $(c, \sigma, s_0, s_1)$
3. Calculer $m_i = \mathsf{Open}(pp, \sigma, s_i)$ pour $i \in \lbrace 0,1\rbrace$
4. $\mathcal{A}$ *gagne* si et seulement si $\mathsf{Verify}(pp,\sigma,c)=1$, $m_0 \neq m_1$, $m_0 \neq \bot$ et $m_1 \neq \bot$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) = \Pr\left[\mathcal{A} \text{ gagne dans } \mathsf{Exp}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) \right]$$

### Lien avec $\mathsf{Rel}_{\mathrm{ver}}$ (fiabilité de vérification)

**Remarque `rem:ann_bind_rel_link` (Pont BIND-REL $\leftrightarrow$ $\mathsf{Rel}_{\mathrm{ver}}$).** Pour un protocole complet dont la probabilité de gain BIND-REL est au plus $\varepsilon_{\mathsf{bind}}$, on a

$$\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$$

(Remarque `rem:jeu_bind_rel_link`). BIND-REL ne dit rien de la fiabilité de reconstruction $\mathsf{Rel}_{\mathrm{rec}}$, puisqu'un engagement parfaitement masquant et liant a $\mathsf{Rel}_{\mathrm{rec}} = 2^{-\lambda}$.

## A.4 Jeu EXT-OPP : opposabilité game-based

*Objectif de cette section.* Définir le jeu EXT-OPP qui capture l'opposabilité institutionnelle, puis établir son lien avec la métrique $\mathsf{Opp}$ via l'inégalité de Fano.

### Définition du jeu

**Intuition.** Le jeu modélise la capacité d'un interprète institutionnel à extraire le bon verdict depuis une preuve. L'« adversaire » ici est l'interprète lui-même (juge, régulateur), dont on mesure la probabilité d'*erreur*. Le verdict de référence $v^*$ est celui que l'institution rendrait en pleine connaissance de cause (Définition `def:interp_admissible`) ; l'institution doit rendre une décision alignée sur le contexte légal, au-delà de la seule vérification de la preuve.

**Définition `def:ann_ext_opp` (Jeu EXT-OPP).** Pour un protocole $\mathcal{P}$, un interprète $\mathsf{Interpret}$ de capacité $\Delta$ et une distribution $\mathcal{D}_C$ fixée à l'avance, le jeu se déroule comme suit.

1. Le challenger tire $c \leftarrow \mathcal{D}_C$, $m \leftarrow \mathcal{M}_\lambda$
2. Le challenger calcule $\sigma \leftarrow \mathsf{Prove}(pp,m,c)$
3. L'interprète reçoit $(\sigma,c)$ et produit $v \leftarrow \mathsf{Interpret}(pp,\sigma,c,\Delta)$
4. Soit $v^*$ le verdict de référence, réalisation de la variable $V$ (qui peut dépendre du message, du contexte et des ressources institutionnelles, Définition `def:interp_admissible`)
5. L'interprète *gagne* si $v = v^*$

$$\mathsf{Err}^{\mathsf{EXT\text{-}OPP}}_{\mathsf{Interpret},\mathcal{P},\mathcal{D}_C}(\lambda) = \Pr\left[ \mathsf{Interpret} \text{ perd dans } \mathsf{Exp}^{\mathsf{EXT\text{-}OPP}}\right]$$

**Pourquoi $\mathcal{D}_C$ est fixée à l'avance ?** L'opposabilité dépend du domaine institutionnel. Un protocole très opposable dans un contexte contractuel simple peut l'être peu dans un contexte réglementaire complexe. Fixer $\mathcal{D}_C$ paramétrise le jeu par le domaine.

### Lien avec $\mathsf{Opp}$ via Fano

**Remarque `rem:ann_ext_opp_link` (Pont EXT-OPP $\leftrightarrow$ $\mathsf{Opp}$).** Par Fano (Lemme `lem:ann_g_fano`) appliqué à l'estimation de $V$ à partir de $(\Sigma,C)$, on obtient

$$\mathsf{Opp} = 1 - \frac{H(V|\Sigma,C)}{H(V|C)} \geq 1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1)}{H(V|C)} \qquad \text{(eq:ann\_fano\_opp)}$$

où $\varepsilon_{\mathsf{ext}} = \mathsf{Err}^{\mathsf{EXT\text{-}OPP}}$ et $h(\cdot)$ est l'entropie binaire. Un interprète avec faible erreur d'extraction implique une forte opposabilité.

## A.5 Réductions formelles pour SOTP-Low

SOTP-Low opère dans le régime context-scarce ($H(\mathcal{C}) < H^*(\lambda)$). Ses deux réductions principales ciblent PRG (confidentialité) et logarithme discret (fiabilité).

*Objectif de cette section.* Établir les deux réductions formelles qui relient SOTP-Low aux hypothèses standard PRG (couche Gold) et DLOG (couche Iron).

### Réduction PRG pour la confidentialité

**Intuition.** La couche Gold chiffre $m$ par le pad $G(s)$. Si $\mathcal{A}$ distingue les preuves de $m_0$ vs $m_1$, il distingue nécessairement $G(s)$ d'une chaîne aléatoire, contredisant la sécurité PRG.

**Théorème `thm:ann_sotp_low_conf` (SOTP-Low, réduction PRG).** Soit $\mathcal{A}$ adversaire PPT contre IND-CONF de SOTP-Low avec avantage $\varepsilon$. Alors il existe un adversaire PPT $\mathcal{B}$ contre le PRG $G$ avec avantage $\geq \varepsilon/2 - \mathrm{negl}(\lambda)$.

**Preuve.**

*Construction du réducteur $\mathcal{B}$.* $\mathcal{B}$ reçoit un défi PRG (soit $G(s)$, soit uniforme) et simule l'environnement IND-CONF pour $\mathcal{A}$. Il utilise son défi comme pad masquant, puis observe si $\mathcal{A}$ devine correctement $b$.

**Construction de $\mathcal{B}$.** $\mathcal{B}$ reçoit un défi PRG $y \in \lbrace 0,1\rbrace^L$ (soit $G(s)$ soit uniforme) et simule le jeu IND-CONF pour $\mathcal{A}$ de la manière suivante.

1. Générer $(\mathbb{G},q,g,h)$ comme dans le Setup SOTP-Low
2. Quand $\mathcal{A}$ soumet $(m_0,m_1,c)$, choisir $b \xleftarrow{\$} \lbrace 0,1\rbrace$
3. Poser $\sigma_1 = m_b \oplus y$ (défi PRG comme pad)
4. Poser $\sigma_2 = g^{s'}h^\rho$ pour $s',\rho \xleftarrow{\$} \mathbb{Z}_q$ (Iron simulée)
5. Poser $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ (Clay déterministe)
6. Retourner $\sigma = (\sigma_1,\sigma_2,\sigma_3)$ à $\mathcal{A}$

Si $\mathcal{A}$ émet $b'=b$, $\mathcal{B}$ retourne 1 ; sinon 0.

**Analyse.**

- *Cas $y = G(s)$.* $\mathcal{A}$ voit une vraie preuve SOTP-Low, gagne avec proba $1/2 + \varepsilon$. $\mathcal{B}$ retourne 1 avec proba $1/2+\varepsilon$.
- *Cas $y$ uniforme.* $\sigma_1 = m_b \oplus U_{|m|}$ est un one-time pad parfait, $\mathcal{A}$ n'a aucune information sur $b$. $\mathcal{B}$ retourne 1 avec proba $1/2$.

Donc $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon/2 - \mathrm{negl}(\lambda)$. $\square$

### Réduction logarithme discret pour la fiabilité

**Intuition.** La couche Iron est $\sigma_2 = g^s h^\rho$. Pour gagner BIND-REL, l'adversaire doit trouver deux ouvertures $s_0 \neq s_1$ pour le même $\sigma_2$, ce qui implique $g^{s_0}h^{\rho_0} = g^{s_1}h^{\rho_1}$, permettant de calculer $\log_g h$, résolvant DLOG.

**Théorème `thm:ann_sotp_low_rel` (SOTP-Low, réduction DLOG).** On suppose la graine tirée dans $\mathbb{Z}_q$ et l'engagement de la forme $\sigma_2 = g^{s}h^{\rho}$ (Algorithme `alg:sotp_low`). Soit $\mathcal{A}$ PPT gagnant BIND-REL pour SOTP-Low (procédure d'ouverture $\mathsf{Open}$) avec probabilité $\varepsilon$. Alors il existe un adversaire PPT $\mathcal{B}$ résolvant DLOG dans $\mathbb{G}$ avec probabilité $\geq \varepsilon$.

**Preuve.**

*Construction du réducteur DLOG.* $\mathcal{B}$ reçoit une instance DLOG $(g, h)$ et utilise l'attaque de $\mathcal{A}$ contre BIND-REL pour extraire $\log_g h$. La clé est que deux ouvertures valides sur la même preuve donnent une équation algébrique résoluble.

Soit une instance DLOG $(g,h)$ avec $x = \log_g h$ inconnu.

1. $\mathcal{B}$ configure SOTP-Low avec $(g,h)$ donnés
2. $\mathcal{A}$ produit $(c,\,\sigma=(\sigma_1,\sigma_2,\sigma_3))$ et deux ouvertures acceptées $(m_0, s_0, \rho_0)$, $(m_1, s_1, \rho_1)$ avec $m_0 \neq m_1$
3. Comme $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ et $m_0 \neq m_1$, on a $\mathsf{PRG}(s_0) \neq \mathsf{PRG}(s_1)$, donc $s_0 \neq s_1$ dans $\mathbb{Z}_q$
4. Les deux ouvertures donnent $g^{s_0}h^{\rho_0} = g^{s_1}h^{\rho_1}$, donc $g^{s_0-s_1} = h^{\rho_1-\rho_0}$ ; comme $s_0 \neq s_1$ et $g$ engendre $\mathbb{G}$, on a $\rho_1 \neq \rho_0$
5. Calculer
$$x = \bigl(s_0-s_1\bigr)\cdot\bigl(\rho_1-\rho_0\bigr)^{-1} \bmod q$$

$\mathcal{B}$ réussit chaque fois que $\mathcal{A}$ produit une attaque valide, avec probabilité $\varepsilon$. $\square$

Le tirage de la graine dans $\mathbb{Z}_q$ est indispensable à l'étape 3, car avec une graine de $\lbrace 0,1\rbrace^\lambda$ engagée par $\mathsf{int}(s) \bmod q$, $s$ et $s+q$ donneraient le même engagement (commentaire de la source).

**Signification pratique.** Avec Curve25519 ($q \approx 2^{252}$, sécurité 128 bits), casser la fiabilité de SOTP-Low est aussi difficile que résoudre le DLP sur les courbes elliptiques.

## A.6 Réduction JL pour SOTP-Base

SOTP-Base opère dans le régime de transition ($H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log_2\lambda$). Sa couche Clay applique une projection JL $\Phi : \mathbb{R}^n \to \mathbb{R}^d$ avec $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$.

*Objectif de cette section.* Montrer que l'erreur d'extraction de l'interprète est directement reliée à la qualité de la préservation JL. Si la projection déforme trop les distances, l'extraction devient erronée.

**Intuition.** Si $\Phi$ déforme trop certaines distances, les contextes voisins deviennent indiscernables dans l'espace compressé, causant des erreurs d'extraction. La réduction ci-dessous quantifie précisément cette relation.

**Théorème `thm:ann_sotp_base_opp` (SOTP-Base, dimensionnement JL).** Soit $\mathcal{C} = \lbrace c_1,\ldots,c_N\rbrace$ l'ensemble des contextes plongés avec $N = 2^{H(\mathcal{C})}$. Soient $\delta, \varepsilon' \in (0,1)$. Si la dimension de projection vérifie

$$d \;\geq\; \frac{8}{\delta^2}\,\ln\left(\frac{N^2}{\varepsilon'}\right) = O\left(\delta^{-2}\bigl(H(\mathcal{C}) + \log(1/\varepsilon')\bigr)\right),$$

alors, avec probabilité au moins $1 - \varepsilon'$ sur le tirage de $\Phi$, $\Phi$ préserve toutes les distances par paires de $\mathcal{C}$ à un facteur $(1 \pm \delta)$ près.

**Preuve.** Par le lemme JL, pour chaque paire $(i,j)$,

$$\Pr\left[\,\left|\frac{\|\Phi c_i-\Phi c_j\|^2}{\|c_i-c_j\|^2} - 1\right| > \delta\,\right] \leq 2e^{-d\delta^2/8} ;$$

une borne de l'union sur les $N^2/2$ paires donne une probabilité d'échec au plus $N^2 e^{-d\delta^2/8}$, inférieure à $\varepsilon'$ dès que $d \geq (8/\delta^2)\ln(N^2/\varepsilon')$. La préservation des distances est une condition *nécessaire* pour qu'une fonction d'extraction fondée sur les distances distingue les contextes ; elle n'est pas suffisante pour garantir l'information extractible sur le verdict. Elle ne fournit donc aucune minoration de $\mathsf{Opp}$. Cette dimension, en $O(H(\mathcal{C}))$, est distincte de la règle de dimensionnement $\lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ du texte principal, qui est un choix de conception. $\square$

**Interprétation.** SOTP-Base choisit la dimension $d$ garantissant la préservation des distances avec la probabilité voulue ; le lien avec l'extraction du verdict reste une hypothèse de conception.

## A.7 Réductions pour SOTP-High

SOTP-High opère dans le régime context-rich ($H(\mathcal{C}) > \lambda/\log_2\lambda$) et s'appuie sur Groth16 pour sa couche Gold. Sa couche Clay encode $h_c = \mathsf{Poseidon}(c)$.

*Objectif de cette section.* Montrer que $\mathsf{Conf}$ et $\mathsf{Rel}_{\mathrm{ver}}$ de SOTP-High héritent des propriétés de Groth16 (zéro-connaissance parfaite, solidité connaissance) ; l'opposabilité n'est pas couverte par une réduction.

**Théorème `thm:ann_sotp_high` (SOTP-High, sécurité héritée de Groth16).** Pour la relation $\mathcal{R} = \lbrace((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = g^m h^\rho \wedge \mathsf{Conforme}(m,c) = 1\rbrace$, les deux propriétés suivantes sont vérifiées.

1. **Confidentialité.** La zéro-connaissance parfaite de Groth16 et le masquage parfait de $c_m$ donnent $\mathsf{Conf} = 1$.
2. **Fiabilité de vérification.** La solidité connaissance de Groth16 donne $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$.

**Preuve.**

**Confidentialité.** Par la ZK parfaite, les preuves honnêtes et les preuves simulées $\mathcal{S}(\sigma_p, (h_c, c_m))$ ont la même loi. Le simulateur n'utilise que les entrées publiques ; $h_c$ ne dépend que de $c$ tandis que $c_m$ est uniforme dans $\mathbb{G}$ quel que soit $m$. La loi de $\Sigma = (h_c, \pi, c_m, \mathsf{metadata})$ sachant $(M = m, C = c)$ ne dépend donc pas de $m$, d'où $\mathsf{Conf} = 1$.

**Fiabilité de vérification.** Pour tout $\mathcal{A}$ PPT produisant une preuve acceptante $\pi$, l'extracteur $\mathcal{E}$ de Groth16 (qui dispose du code de $\mathcal{A}$ et exploite l'hypothèse q-PKE ; ce n'est pas le vérificateur) produit un témoin $(m,c,\rho)$ avec $((h_c,c_m),(m,c,\rho)) \in \mathcal{R}$, sauf avec probabilité négligeable. Ainsi

$$\Pr\left[\mathsf{Verify}=1 \land (m,c,\rho)\notin\mathcal{R}\right] \leq \mathsf{Adv}^{\mathsf{sound}}(\lambda) \leq \mathrm{negl}(\lambda) \;\Rightarrow\; \mathsf{Rel}_{\mathrm{ver}} \geq 1-\mathrm{negl}(\lambda).$$

**Opposabilité.** Aucune borne n'est dérivée ici, car $h_c$ et les métadonnées sont des fonctions du contexte public, donc $I(V;h_c|C) = 0$ ; ce que la preuve apporte au verdict tient à l'assertion certifiée $\mathsf{Conforme}(m,c) = 1$ (Remarque `rem:heuristique_sotp_high`). $\square$

**Remarque (La ZK parfaite).** La ZK *parfaite* de Groth16 signifie que même un adversaire à calcul infini ne peut distinguer vraies preuves de simulées. C'est une garantie inconditionnelle une fois le CRS fixé, propriété remarquablement forte, qui fait de SOTP-High la variante la plus protectrice pour les contextes à haute entropie.

## A.8 Énoncés complets et produit CRO game-based

*Objectif de cette section.* Rassembler les bornes game-based des trois jeux et en déduire une borne inférieure sur le produit CRO. Cette borne complète le Trilemme CRO (borne supérieure) pour encadrer le produit réalisable.

### Sécurité complète de SOTP-Low

**Théorème `thm:ann_sotp_low_games` (SOTP-Low, bornes game-based complètes).** Sous PRG et DLOG dans $\mathbb{G}$ d'ordre $q$, on a, pour tout PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq 2\cdot\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_conf)}$$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_rel)}$$

**Remarque `rem:ann_sotp_low_opp_statut` (Opposabilité de SOTP-Low, pas de borne game-based).** La formulation initiale de ce théorème contenait une troisième inégalité, $\mathsf{Err}^{\mathsf{EXT\text{-}OPP}} \leq 1 - \Delta/(\alpha H(\mathcal{C}))$, tirée du fait que la couche Clay $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ détermine le verdict. La présente formulation ne la reprend pas, car $\sigma_3$ est une fonction du contexte public $C$, donc $I(V;\sigma_3|C) = 0$ ; elle ne contribue ainsi en rien à l'opposabilité au sens de la Définition `def:interp_admissible`. Ce que SOTP-Low apporte au verdict passe par l'ouverture $(m,s,\rho)$ fournie à l'institution, ce qui relève de l'heuristique de conception (Remarque `rem:facteur_limitant_low`), sans réduction associée.

### Tableau récapitulatif des réductions

**Tableau `tab:ann_g_reductions` — Synthèse des réductions game-based pour la famille SOTP**

| Variante | Propriété | Jeu | Hypothèse | Borne |
|---|---|---|---|---|
| SOTP-Low | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq 2\varepsilon_{\mathsf{PRG}} + 1/q$ |
| SOTP-Low | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + 1/q$ |
| SOTP-Low | $\mathsf{Opp}$ | – | – | aucune (Rem. `rem:ann_sotp_low_opp_statut`) |
| SOTP-Base | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq 2\varepsilon_{\mathsf{PRG}} + \mathrm{negl}$ |
| SOTP-Base | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + \mathrm{negl}$ |
| SOTP-Base | – | – | Lemme JL | dimensionnement de $d$ (Th. `thm:ann_sotp_base_opp`) |
| SOTP-High | $\mathsf{Conf}$ | IND-CONF | Groth16 ZK parfaite | $\mathsf{Conf} = 1$ |
| SOTP-High | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | Groth16 (q-PKE) | $\geq 1-\mathrm{negl}(\lambda)$ |
| SOTP-High | $\mathsf{Opp}$ | – | – | aucune (Rem. `rem:heuristique_sotp_high`) |

### Corollaire central : produit CRO game-based

**Corollaire `cor:ann_cro_from_games` (Produit CLO depuis les jeux).** Si IND-CONF, BIND-REL et EXT-OPP sont gagnés avec avantages respectifs au plus $\varepsilon_{\mathsf{ind}}$, $\varepsilon_{\mathsf{bind}}$, $\varepsilon_{\mathsf{ext}}$, alors

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq \left(1-2\varepsilon_{\mathsf{ind}}\right) \left(1-\varepsilon_{\mathsf{bind}}\right) \left(1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_product\_games)}$$

où $\mathsf{Conf}_{\mathrm{calc}} = 1 - 2\varepsilon_{\mathsf{ind}}$ désigne la confidentialité calculatoire. Pour $\varepsilon_{\mathsf{ind}},\varepsilon_{\mathsf{bind}}, \varepsilon_{\mathsf{ext}} \ll 1$, il vient

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq 1 - O\left(\varepsilon_{\mathsf{ind}} + \varepsilon_{\mathsf{bind}} + \varepsilon_{\mathsf{ext}}\log_2|\mathcal{V}_\lambda| + h(\varepsilon_{\mathsf{ext}})\right) \qquad \text{(eq:ann\_cro\_approx)}$$

**Preuve.** **Terme $\mathsf{Conf}_{\mathrm{calc}}$.** Définition, avec le jeu IND-CONF (Remarque `rem:ann_ind_conf_link`). **Terme $\mathsf{Rel}_{\mathrm{ver}}$.** La Remarque `rem:ann_bind_rel_link` donne $\mathsf{Rel}_{\mathrm{ver}} \geq 1-\varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$. **Terme $\mathsf{Opp}$.** Remarque `rem:ann_ext_opp_link` (inégalité de Fano, `eq:ann_fano_opp`). Le produit $(1-a)(1-b)(1-c) \geq 1-a-b-c$ pour $a,b,c \in [0,1]$ donne (`eq:ann_cro_approx`). $\square$

**Remarque `rem:ann_pas_de_contradiction` (Pourquoi ce corollaire ne contredit pas le Trilemme).** Le Trilemme CRO (Théorème `thm:trilemme_cro_conditionnel`) majore le produit $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp}$, où $\mathsf{Conf}$ est statistique et $\mathsf{Rel}_{\mathrm{rec}}$ mesure la reconstruction du message. Le corollaire minore un produit d'une autre nature, qui fait intervenir la confidentialité *calculatoire* et la fiabilité de *vérification*. Les deux échelles ne se comparent pas. Un protocole peut avoir $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ proche de 1 tout en obéissant au Trilemme, puisque $\mathsf{Rel}_{\mathrm{rec}}$ reste alors de l'ordre de $2^{-\lambda}$ (Remarque `rem:rel_ver`). L'hypothèse que $\varepsilon_{\mathsf{ext}}$ est petit est précisément ce que le Trilemme rend coûteux lorsque $\mathsf{Conf}$ statistique est proche de 1 ; la Remarque `rem:activite_delta` indique quelle quantité ($\Delta$ ou Fano) limite alors $\mathsf{Opp}$. La formulation initiale de ce paragraphe annonçait un « encadrement » du produit par $\Delta/(\alpha\lambda)$ et une constante $c \in [0{,}45;\,0{,}85]$ ; la présente formulation distingue les deux échelles.

## A.9 Limitations et portée des réductions

*Objectif de cette section.* Énumérer les cinq limitations des réductions game-based, à savoir la conditionnalité, l'interprète honnête, la réduction one-way, le terme $1/q$ et la relation avec Lean4.

1. **Conditionnalité aux hypothèses calculatoires.** La sécurité de SOTP-Low est prouvée sous PRG et DLOG. SOTP-High via Groth16 repose sur la difficulté des couplages sur BN254, non post-quantique. Une extension aux primitives résistantes aux quantiques (STARKs, réseaux euclidiens) est une direction de recherche ouverte (section `sec:sotp_construction`).
2. **Modèle d'interprète honnête dans EXT-OPP.** Le jeu suppose que l'interprète tente sincèrement d'extraire le bon verdict. Un interprète *adversarial* (juge corrompu) n'est pas modélisé. Des extensions game-théoriques (régulateur vs entité auditée) sont identifiées comme direction future (section `sec:sotp_construction`).
3. **Réduction SOTP-Base one-way.** Le Théorème `thm:ann_sotp_base_opp` garantit seulement l'implication *dimension suffisante $\Rightarrow$ préservation JL*. Il ne garantit pas que la préservation des distances permette d'extraire le verdict, car cela dépend de la fonction $f_\Delta$ choisie par l'institution, dont ni l'existence ni la calculabilité efficace ne sont établies.
4. **Terme $1/q$ dans les bornes SOTP-Low.** Les équations (`eq:ann_sotp_low_conf`) et (`eq:ann_sotp_low_rel`) contiennent $1/q$ (probabilité de deviner l'exposant). Il est négligeable en $\lambda$ au sens strict dès que l'ordre du groupe vérifie $\log_2 q \geq \lambda$, ce qui est le cas des paramètres utilisés ($q \approx 2^{252}$, soit $1/q \approx 10^{-76}$). Le terme est conservé pour que les bornes restent exactes à $\lambda$ fixé.
5. **Relation avec la formalisation Lean4 (Annexe `chap:annexe_lean4`).** Les deux annexes se complètent de la manière suivante.
   - **Lean4 (Annexe `chap:annexe_lean4`)** certifie mécaniquement la dérivation algébrique de la borne $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp} \leq \Delta/\lambda + K/\lambda^2 + \varepsilon(\lambda)$ (Théorème `thm:conditional_CRO_trilemma`), en posant Fano et Pinsker comme propriétés de chaque instance et l'extraction bornée comme hypothèse
   - **Annexe `chap:annexe_gamebased` (ici)** établit les propriétés cryptographiques de la famille SOTP (confidentialité calculatoire, fiabilité de vérification) sous PRG, DLOG et Groth16 ; elle n'instancie pas les hypothèses du Trilemme, qui portent sur $\mathsf{Conf}$ statistique et $\mathsf{Rel}_{\mathrm{rec}}$

   Les deux niveaux sont donc complémentaires sans se composer en une preuve unique, puisque le niveau *formel* certifie la logique de la dérivation du Trilemme tandis que le niveau *game-based* justifie les garanties cryptographiques des constructions.

## Notes de transcription

- Dans cette annexe, $d$ désigne la dimension de sortie de la projection ; dans l'Algorithme `alg:sotp_base`, la dimension de sortie est notée $k$ et $d$ est la dimension du plongement (note T4 de la spécification).
