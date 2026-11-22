> **Statut : PROPOSITION — construction (soumise à IEEE Transactions on Information Theory)** · Source : thèse, annexe A (`chap:annexe_gamebased`), fichier [gamebased_source_fr.tex](gamebased_source_fr.tex)

# Sécurité game-based et réductions formelles pour la famille SOTP

*English version: [gamebased_en.md](gamebased_en.md)*

Transcription Markdown de l'annexe A de la thèse, dans sa version finale. Les énoncés, jeux, réductions et preuves sont reproduits sans modification. Les commentaires marginaux pédagogiques de la source (macros `\cmt` et `\cmtFormule`) sont omis ; ils figurent dans [gamebased_source_fr.tex](gamebased_source_fr.tex). Les renvois internes sont donnés par leur étiquette LaTeX et les références par leur clé. La spécification des algorithmes se trouve dans [../specification/sotp_specification_fr.md](../specification/sotp_specification_fr.md).

## Introduction

Le cadre CLO définit $\mathsf{Conf}$, $\mathsf{Rel}$ et $\mathsf{Opp}$ avec des termes issus de la théorie de l'information, à savoir les entropies conditionnelles, l'information mutuelle et la distance de variation totale [MINKA2026CLO]. Cette approche permet des résultats généraux (Théorème du Goulot d'étranglement Contextuel, Trilemme CRO Conditionnel), mais ne précise pas directement *ce qu'un adversaire calculatoirement borné peut ou ne peut pas faire*. En cryptographie calculatoire, la sécurité s'exprime classiquement par des *jeux* (games) entre un challenger et un adversaire probabiliste en temps polynomial (PPT).

*Pourquoi cette annexe.* Le cadre CLO raisonne en bits et en entropies, alors que la cryptographie classique raisonne en jeux et en avantages d'adversaires. Cette annexe construit le pont entre les deux. Elle traduit chaque métrique du cadre CLO en un jeu cryptographique puis relie chaque jeu à une hypothèse de dureté standard (PRG, DLOG, JL, Groth16).

Cette annexe établit le **pont formel** entre les deux mondes en trois étapes.

1. Définir des jeux cryptographiques (*IND-CONF*, *BIND-REL*, *EXT-OPP*) capturant opérationnellement $\mathsf{Conf}$ (dans sa version calculatoire), $\mathsf{Rel}_{\mathrm{ver}}$ et $\mathsf{Opp}$
2. Prouver des *réductions* formelles établissant que, si un adversaire PPT gagne l'un de ces jeux, il résout un problème supposé difficile (PRG, logarithme discret, JL, Groth16)
3. Établir une **minoration game-based du produit CLO** (Corollaire `cor:ann_cro_from_games`), à l'échelle opérationnelle (confidentialité calculatoire, fiabilité de vérification), qui ne se compare pas directement au Trilemme (Remarque `rem:ann_pas_de_contradiction`)

*Trois jeux, trois métriques.* **IND-CONF** capte la confidentialité en exigeant que l'adversaire ne puisse distinguer les preuves de deux messages. **BIND-REL** capte la fiabilité, puisque l'adversaire ne doit pas pouvoir ouvrir une preuve sur deux messages distincts. Enfin, **EXT-OPP** capte l'opposabilité, l'interprète institutionnel devant extraire le bon verdict depuis la preuve.

**Convention.** Tout adversaire $\mathcal{A}$ est probabiliste en temps polynomial (PPT) en $\lambda$ sauf mention contraire. Le challenger est noté $\mathcal{C}$. Une réduction construit un algorithme $\mathcal{B}$ (réducteur) qui exploite $\mathcal{A}$ pour résoudre un problème difficile.

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
| [A.9](#a9-mécanisation-en-situation-réduite) | Mécanisation en situation réduite | $\mathsf{Conf}_{\mathrm{calc}}$, $\mathsf{Rel}_{\mathrm{ver}}$ | PRG, DLOG |
| [A.10](#a10-limitations-et-portée-des-réductions) | Limitations et portée | – | – |

---

## A.1 Primitives cryptographiques et définitions préalables

*Objectif de cette section.* Rappeler les quatre primitives cryptographiques utilisées dans la famille SOTP, à savoir le PRG (couche Gold), l'engagement de Pedersen (couche Iron), le zk-SNARK Groth16 (SOTP-High) et la transformation Johnson-Lindenstrauss (SOTP-Base), ainsi que deux outils théoriques, l'inégalité de Fano et le DPI.

### Générateur pseudo-aléatoire (PRG)

**Intuition.** Un PRG prend une graine courte $s \in \lbrace 0,1\rbrace^\lambda$ et produit une longue séquence $G(s) \in \lbrace 0,1\rbrace^{L(\lambda)}$, $L > \lambda$, indiscernable d'une séquence vraiment aléatoire. Il fonde la couche Gold de SOTP-Low, dans laquelle le pad $G(s)$ masque le message de sorte que, sans $s$, aucun adversaire PPT ne peut récupérer $m$ depuis $m \oplus G(s)$.

**Définition `def:ann_prg` (Sécurité PRG [GoldreichKrawczyk99]).** Soit $\mathcal{S}_\lambda$ un ensemble fini de graines, par exemple $\lbrace 0,1\rbrace^\lambda$ ou $\mathbb{Z}_q$. Une fonction calculable en temps polynomial $G : \mathcal{S}_\lambda \to \lbrace 0,1\rbrace^{L(\lambda)}$ est sûre si, pour tout adversaire PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{A}}(\lambda) = \left| \Pr_{s \leftarrow \mathcal{S}_\lambda}\big[\mathcal{A}(G(s)) = 1\big] - \Pr_{y \leftarrow \lbrace 0,1\rbrace^{L(\lambda)}}\big[\mathcal{A}(y) = 1\big] \right| \leq \mathrm{negl}(\lambda)$$

**Loi de la graine.** SOTP-Low tire sa graine uniformément dans $\mathbb{Z}_q$ (Algorithme `alg:sotp_low`), condition nécessaire à la réduction au logarithme discret. C'est donc la loi $\mathcal{S}_\lambda = \mathbb{Z}_q$ qui figure dans les réductions de cette annexe. Pour IND-CONF, l'avantage est $|\Pr[b' = b] - 1/2|$ ; pour le PRG, c'est la différence des deux probabilités ci-dessus.

**Graine plus longue que la sortie.** La définition ne demande pas que $G$ étire la graine. Lorsque $L(\lambda) > \log_2|\mathcal{S}_\lambda|$, $G$ est un générateur pseudo-aléatoire au sens usuel et sa sûreté est une hypothèse calculatoire. Lorsque la graine est plus longue que la sortie, $G$ est une fonction de dérivation de masque et la condition peut être satisfaite au sens statistique. C'est le cas de SOTP-Low, où $s \in \mathbb{Z}_q$ avec $|q| \geq 2\lambda$ et $L(\lambda) = \lambda$. La troncature $s \bmod 2^\lambda$ y est à distance statistique au plus $2^{-\lambda-1}$ de l'uniforme (Remarque `rem:masque_troncature`).

**Implémentations pratiques.** Pour un message plus long, SOTP-Low dérive une clé de la graine puis utilise ChaCha20 ou AES-CTR, deux PRG standardisés atteignant cette définition.

### Engagement de Pedersen

**Intuition.** L'engagement de Pedersen permet à un prouveur de « s'engager » sur $m$ sans le révéler (*perfect hiding*), tout en étant incapable de changer d'avis (*computational binding*). La construction $\mathsf{Com}(m, r) = g^m h^r$ exploite l'algèbre des groupes cycliques, de sorte que toute collision d'engagements permettrait de calculer $\log_g h$, résolvant le logarithme discret.

**Définition `def:ann_pedersen` (Engagement de Pedersen [Pedersen91]).** Soit $\mathbb{G}$ un groupe cyclique d'ordre premier $q$, $g, h \in \mathbb{G}$ deux générateurs tels que $\log_g h$ est inconnu.

- $\mathsf{Com}(m, r) = g^m h^r \in \mathbb{G}$, $m,r \in \mathbb{Z}_q$ (opération de groupe)
- $\mathsf{Open}(\sigma_2, m, r)$ accepte si $\sigma_2 = g^m h^r$

**Perfect Hiding.** Pour tout $m_0, m_1$, les engagements $\mathsf{Com}(m_0, r_0)$ et $\mathsf{Com}(m_1, r_1)$ sont identiquement distribués pour $r_0, r_1 \xleftarrow{\$} \mathbb{Z}_q$.

**Computational Binding.** Aucun adversaire PPT ne peut trouver $(m_0, r_0, m_1, r_1)$ avec $m_0 \neq m_1$ tel que $g^{m_0} h^{r_0} = g^{m_1} h^{r_1}$ dans $\mathbb{G}$.

**Rôle dans SOTP.** La couche Iron de toute variante SOTP est un engagement de Pedersen (sur la graine $s \in \mathbb{Z}_q$ pour SOTP-Low et SOTP-Base, sur $m$ pour SOTP-High). Il garantit la fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}}$, puisqu'une preuve ne peut pas être « ouverte » sur deux messages distincts.

### zk-SNARK Groth16

**Intuition.** Un zk-SNARK pour une relation $\mathcal{R}$ permet de prouver qu'on connaît un témoin $w$ tel que $(x,w) \in \mathcal{R}$, sans révéler $w$, en une preuve de taille constante. Une preuve Groth16 compte trois éléments de groupe, soit 128 octets (points compressés) sur BN254 [BarretoNaehrig2006] ; elle se vérifie en $O(1)$ couplages.

**Définition `def:ann_groth16` (zk-SNARK Groth16 [Groth16]).** $(\mathsf{Setup}, \mathsf{Prove}, \mathsf{Verify})$ satisfait les propriétés suivantes.

**Complétude parfaite.** $\Pr[\mathsf{Verify}(\sigma_v,x,\pi)=1 \mid (x,w)\in\mathcal{R}] = 1$

**Solidité connaissance.** Pour tout PPT $\mathcal{A}$, il existe un extracteur $\mathcal{E}$ tel que

$$\Pr\left[ \mathsf{Verify}(\sigma_v,x,\pi)=1 \land (x,w)\notin\mathcal{R} \;:\; (x,\pi)\leftarrow\mathcal{A}(\sigma_p),\ w\leftarrow\mathcal{E}(\sigma_p) \right] \leq \mathrm{negl}(\lambda)$$

**Zéro-connaissance parfaite.** Il existe un simulateur $\mathcal{S}$ tel que pour tout $(x,w)\in\mathcal{R}$,

$$\lbrace\pi :  \pi \leftarrow \mathsf{Prove}(\sigma_p,x,w)\rbrace \equiv \lbrace\pi :  \pi \leftarrow \mathcal{S}(\sigma_p,x)\rbrace \quad\text{(distributions identiques)}$$

**Lecture pour SOTP-High.** La zéro-connaissance *parfaite*, jointe au masquage parfait de l'engagement $c_m$, implique que $(\pi, c_m)$ est indépendant de $m$ sachant $c$, d'où $\mathsf{Conf} = 1$ au sens statistique. La solidité connaissance implique la fiabilité de vérification $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$ ; elle ne dit rien de la fiabilité de reconstruction, qui vaut $2^{-\lambda}$ lorsque $\mathsf{Conf} = 1$ (Remarque `rem:rel_ver`).

### Transformation Johnson-Lindenstrauss (JL)

**Intuition.** La JL-transform projette $N$ points de $\mathbb{R}^d$ dans $\mathbb{R}^k$ ($k \ll d$) en préservant approximativement toutes les distances par paires. Dans SOTP-Base, les plongements de contextes $\mathsf{embed}(c) \in \mathbb{R}^d$ sont projetés en $\Phi\,\mathsf{embed}(c) \in \mathbb{R}^k$, conservant leur proximité.

**Définition `def:ann_jl` (Transformation JL [JohnsonLindenstrauss84, DasguptaGupta03]).** Pour $0 < \varepsilon < 1$, $N > 0$, $S \subset \mathbb{R}^d$ avec $|S| = N$, il existe $\Phi : \mathbb{R}^d \to \mathbb{R}^k$ avec $k = O(\varepsilon^{-2} \log N)$ telle que, pour tout $x,y \in S$,

$$(1-\varepsilon)\|x-y\|^2 \leq \|\Phi x-\Phi y\|^2 \leq (1+\varepsilon)\|x-y\|^2$$

**Règle de conception pour SOTP-Base.** La dimension de plongement retenue par conception est

$$d = \left\lceil \frac{4\Delta H(\mathcal{C})}{\varepsilon^2} \right\rceil \qquad \text{(eq:ann\_jl\_dim)}$$

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

**Intuition.** Le jeu capture la *non-équivocité*, selon laquelle un adversaire ne doit pas pouvoir produire une preuve $\sigma$ ouvrable sur deux messages distincts $m_0 \neq m_1$. Contrairement à IND-CONF, l'adversaire choisit librement $(c, \sigma, o_0, o_1)$, modélisant un agent qui forge délibérément une preuve ambiguë.

**Définition `def:ann_bind_rel` (Jeu BIND-REL).** Pour un protocole $\mathcal{P}$ avec $\mathsf{Open}$ et un adversaire $\mathcal{A}$, le jeu se déroule comme suit.

1. $\mathcal{A}$ reçoit $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ produit $(c, \sigma, o_0, o_1)$, où chaque ouverture $o_i = (m_i, s_i, \rho_i)$
3. Calculer $m_i = \mathsf{Open}(pp, \sigma, o_i)$ pour $i \in \lbrace 0,1\rbrace$
4. $\mathcal{A}$ *gagne* si et seulement si $\mathsf{Verify}(pp,\sigma,c)=1$, $m_0 \neq m_1$, $m_0 \neq \bot$ et $m_1 \neq \bot$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) = \Pr\left[\mathcal{A} \text{ gagne dans } \mathsf{Exp}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) \right]$$

### Lien avec $\mathsf{Rel}_{\mathrm{ver}}$ (fiabilité de vérification)

**Remarque `rem:ann_bind_rel_link` (Pont BIND-REL $\leftrightarrow$ $\mathsf{Rel}_{\mathrm{ver}}$).** Pour un protocole complet dont la probabilité de gain BIND-REL est au plus $\varepsilon_{\mathsf{bind}}$, on a

$$\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$$

(Remarque `rem:jeu_bind_rel_link`). BIND-REL ne dit rien de la fiabilité de reconstruction $\mathsf{Rel}_{\mathrm{rec}}$, puisqu'un engagement parfaitement masquant et liant a $\mathsf{Rel}_{\mathrm{rec}} = 2^{-\lambda}$.

## A.4 Jeu EXT-OPP : opposabilité game-based

*Objectif de cette section.* Définir le jeu EXT-OPP qui capture l'opposabilité institutionnelle, puis établir son lien avec la métrique $\mathsf{Opp}$ via l'inégalité de Fano.

### Définition du jeu

**Intuition.** Le jeu modélise la capacité d'un interprète institutionnel à extraire le bon verdict depuis une preuve. L'« adversaire » ici est l'interprète lui-même (juge, régulateur), dont on mesure la probabilité d'*erreur*. Le verdict de référence $v^*$ est celui que l'institution rendrait en pleine connaissance de cause (Définition `def:interp_admissible`) ; l'institution doit rendre une décision alignée sur le contexte juridique, au-delà de la seule vérification de la preuve.

**Définition `def:ann_ext_opp` (Jeu EXT-OPP).** Pour un protocole $\mathcal{P}$, un interprète $\mathsf{Interpret}$ de capacité $\Delta$ et une distribution $\mathcal{D}_C$ fixée à l'avance, le jeu se déroule comme suit.

1. Le challenger tire $c \leftarrow \mathcal{D}_C$, $m \leftarrow \mathcal{M}_\lambda$
2. Le challenger calcule $\sigma \leftarrow \mathsf{Prove}(pp,m,c)$
3. L'interprète reçoit $(\sigma,c)$, peut consulter ses ressources institutionnelles $K$ (Définition `def:interp_admissible`) et produit $v \leftarrow \mathsf{Interpret}(pp,\sigma,c,\Delta)$
4. Soit $v^*$ le verdict de référence, réalisation de la variable $V$ (qui peut dépendre du message, du contexte et des ressources institutionnelles, Définition `def:interp_admissible`)
5. L'interprète *gagne* si $v = v^*$

$$\mathsf{Err}^{\mathsf{EXT\text{-}OPP}}_{\mathsf{Interpret},\mathcal{P},\mathcal{D}_C}(\lambda) = \Pr\left[ \mathsf{Interpret} \text{ perd dans } \mathsf{Exp}^{\mathsf{EXT\text{-}OPP}}\right]$$

**Pourquoi $\mathcal{D}_C$ est fixée à l'avance ?** L'opposabilité dépend du domaine institutionnel. Un protocole très opposable dans un contexte contractuel simple peut l'être peu dans un contexte réglementaire complexe. Fixer $\mathcal{D}_C$ paramétrise le jeu par le domaine.

### Lien avec $\mathsf{Opp}$ via Fano

**Remarque `rem:ann_ext_opp_link` (Pont EXT-OPP $\leftrightarrow$ $\mathsf{Opp}$).** Par Fano (Lemme `lem:ann_g_fano`) appliqué à l'estimation de $V$ à partir de $(\Sigma,C,K)$, puis par la règle de chaîne $H(V|\Sigma,C) = H(V|\Sigma,C,K) + I(V;K|\Sigma,C)$ (Remarque `rem:jeu_ext_opp_link`), on obtient

$$\mathsf{Opp} = 1 - \frac{H(V|\Sigma,C)}{H(V|C)} \geq 1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1) + I(V;K|\Sigma,C)}{H(V|C)} \qquad \text{(eq:ann\_fano\_opp)}$$

où $\varepsilon_{\mathsf{ext}} = \mathsf{Err}^{\mathsf{EXT\text{-}OPP}}$ et $h(\cdot)$ est l'entropie binaire. Le terme $I(V;K|\Sigma,C)$ mesure ce que l'interprète tire de ses ressources propres $K$ et non de la preuve ; il est nul lorsque l'interprète ne lit que $(\Sigma,C)$. Un interprète avec faible erreur d'extraction, qui doit peu à ses ressources propres, implique une forte opposabilité.

## A.5 Réductions formelles pour SOTP-Low

SOTP-Low sert sous le seuil $H^\sharp$ lorsque l'institution a besoin du contexte exact. Ses deux réductions principales ciblent PRG (confidentialité) et logarithme discret (fiabilité).

*Objectif de cette section.* Établir les deux réductions formelles qui relient SOTP-Low aux hypothèses standard PRG (couche Gold) et DLOG (couche Iron).

### Réduction PRG pour la confidentialité

**Intuition.** La couche Gold chiffre $m$ par le pad $G(s)$. Si $\mathcal{A}$ distingue les preuves de $m_0$ vs $m_1$, il distingue nécessairement $G(s)$ d'une chaîne aléatoire, contredisant la sécurité PRG.

**Théorème `thm:ann_sotp_low_conf` (SOTP-Low, réduction PRG).** Soit $\mathcal{A}$ adversaire PPT contre IND-CONF de SOTP-Low avec avantage $\varepsilon$. Alors il existe un adversaire PPT $\mathcal{B}$ contre le PRG $G$ de même temps d'exécution que $\mathcal{A}$ à un terme polynomial près, tel que $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon - 1/q$.

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

- *Cas $y = G(s)$.* Lorsque $h \neq 1$, $h$ engendre $\mathbb{G}$ et $\sigma_2 = g^{s'}h^\rho$ est uniforme et indépendant de $s$, comme $g^{s}h^\rho$ dans le vrai jeu. $\mathcal{A}$ voit alors exactement une vraie preuve SOTP-Low. L'événement $h = 1$ a probabilité $1/q$. $\mathcal{B}$ retourne donc 1 avec une probabilité qui diffère de $\Pr[b' = b] = 1/2 \pm \varepsilon$ d'au plus $1/q$.
- *Cas $y$ uniforme.* $\sigma_1 = m_b \oplus U_{|m|}$ est un one-time pad parfait, $\mathcal{A}$ n'a aucune information sur $b$. $\mathcal{B}$ retourne 1 avec proba $1/2$.

Donc $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon - 1/q$. $\square$

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

SOTP-Base sert sous le seuil $H^\sharp$ lorsque l'institution a besoin de la proximité entre contextes. Sa couche Clay applique une projection JL $\Phi : \mathbb{R}^d \to \mathbb{R}^k$, où $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ est la dimension de plongement retenue par conception et $k$ la dimension d'arrivée (Algorithme `alg:sotp_base`).

*Objectif de cette section.* Montrer que l'erreur d'extraction de l'interprète est directement reliée à la qualité de la préservation JL. Si la projection déforme trop les distances, l'extraction devient erronée.

**Intuition.** Si $\Phi$ déforme trop certaines distances, les contextes voisins deviennent indiscernables dans l'espace d'arrivée, causant des erreurs d'extraction. La réduction ci-dessous quantifie précisément cette relation.

**Théorème `thm:ann_sotp_base_opp` (SOTP-Base, dimensionnement JL).** Soit $\mathcal{C} = \lbrace c_1,\ldots,c_N\rbrace$ l'ensemble des contextes plongés avec $N = 2^{H(\mathcal{C})}$. Soient $\delta, \varepsilon' \in (0,1)$. Si la dimension d'arrivée $k$ vérifie

$$k \;\geq\; \frac{12}{\delta^2}\,\ln\left(\frac{N^2}{\varepsilon'}\right) = O\left(\delta^{-2}\bigl(H(\mathcal{C}) + \log(1/\varepsilon')\bigr)\right),$$

alors, avec probabilité au moins $1 - \varepsilon'$ sur le tirage de $\Phi$, $\Phi$ préserve toutes les distances par paires de $\mathcal{C}$ à un facteur $(1 \pm \delta)$ près.

**Preuve.** Par le lemme JL, pour chaque paire $(i,j)$,

$$\Pr\left[\,\left|\frac{\|\Phi c_i-\Phi c_j\|^2}{\|c_i-c_j\|^2} - 1\right| > \delta\,\right] \leq 2e^{-k\delta^2/12} \quad \text{pour } 0 < \delta < 1$$

(preuve du Lemme `lem:johnson_lindenstrauss`). Une borne de l'union sur les $N^2/2$ paires donne une probabilité d'échec d'au plus $N^2 e^{-k\delta^2/12}$. Cette probabilité est inférieure à $\varepsilon'$ dès que $k \geq (12/\delta^2)\ln(N^2/\varepsilon')$. La préservation des distances est une condition *nécessaire* pour qu'une fonction d'extraction fondée sur les distances distingue les contextes ; elle n'est pas suffisante pour garantir l'information extractible sur le verdict. Elle ne fournit donc aucune minoration de $\mathsf{Opp}$. Cette dimension, en $O(H(\mathcal{C}))$, est distincte de la règle de dimensionnement $\lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ du texte principal, qui est un choix de conception. $\square$

**Interprétation.** SOTP-Base choisit la dimension d'arrivée $k$ garantissant la préservation des distances avec la probabilité voulue ; le lien avec l'extraction du verdict reste une hypothèse de conception.

**Corollaire `cor:ann_sotp_base_reductions` (Réductions pour SOTP-Base).** Sous PRG et DLOG dans $\mathbb{G}$ d'ordre $q$, pour tout PPT $\mathcal{A}$, $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Base}}(\lambda) \leq \mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + 1/q$ et $\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Base}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda)$.

**Preuve.** SOTP-Base partage avec SOTP-Low les couches Gold et Iron (Algorithme `alg:sotp_base`), et sa couche Clay, la projection JL du contexte, est une fonction publique de $c$ et du tirage public de $\Phi$. Les réducteurs des Théorèmes `thm:ann_sotp_low_conf` et `thm:ann_sotp_low_rel` calculent cette couche à partir de $c$. Leurs simulations et leurs analyses restent inchangées. $\square$

## A.7 Réductions pour SOTP-High

SOTP-High sert au-delà du seuil $H^\sharp$ et s'appuie sur Groth16 pour sa couche Gold. Sa couche Clay encode $h_c = \mathsf{Poseidon}(c)$.

*Objectif de cette section.* Montrer que $\mathsf{Conf}$ et $\mathsf{Rel}_{\mathrm{ver}}$ de SOTP-High héritent des propriétés de Groth16 (zéro-connaissance parfaite, solidité connaissance) ; l'opposabilité n'est pas couverte par une réduction.

**Théorème `thm:ann_sotp_high` (SOTP-High, sécurité héritée de Groth16).** Pour la relation $\mathcal{R} = \lbrace((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = g^m h^\rho \wedge \mathsf{Conforme}(m,c) = 1\rbrace$, les deux propriétés suivantes sont vérifiées.

1. **Confidentialité.** La zéro-connaissance parfaite de Groth16 et le masquage parfait de $c_m$ donnent $\mathsf{Conf} = 1$.
2. **Fiabilité de vérification.** La solidité de connaissance de Groth16, la résistance aux collisions de $\mathsf{Poseidon}$ et le caractère liant de l'engagement de Pedersen sous DLOG donnent $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$.

**Preuve.**

**Confidentialité.** Par la ZK parfaite, les preuves honnêtes et les preuves simulées $\mathcal{S}(\sigma_p, (h_c, c_m))$ ont la même loi. Le simulateur n'utilise que les entrées publiques ; $h_c$ ne dépend que de $c$ tandis que $c_m$ est uniforme dans $\mathbb{G}$ quel que soit $m$. La loi de $\Sigma = (h_c, \pi, c_m, \mathsf{metadata})$ sachant $(M = m, C = c)$ ne dépend donc pas de $m$, d'où $\mathsf{Conf} = 1$.

**Fiabilité de vérification.** Pour tout $\mathcal{A}$ PPT produisant une preuve acceptante $\pi$, l'extracteur $\mathcal{E}$ de Groth16 dont l'existence est démontrée dans le modèle du groupe générique [Groth16] et dans le modèle du groupe algébrique sous l'hypothèse q-DLog [FKL18] (ce n'est pas le vérificateur) produit un témoin $(m,c,\rho)$ avec $((h_c,c_m),(m,c,\rho)) \in \mathcal{R}$, sauf avec probabilité négligeable. Ainsi

$$\Pr\left[\mathsf{Verify}=1 \land (m,c,\rho)\notin\mathcal{R}\right] \leq \mathsf{Adv}^{\mathsf{sound}}(\lambda) \leq \mathrm{negl}(\lambda) \;\Rightarrow\; \mathsf{Rel}_{\mathrm{ver}} \geq 1-\mathrm{negl}(\lambda).$$

**Opposabilité.** Aucune borne n'est établie ici, car $h_c$ et les métadonnées sont des fonctions du contexte public, donc $I(V;h_c|C) = 0$ ; ce que la preuve apporte au verdict tient à l'assertion certifiée $\mathsf{Conforme}(m,c) = 1$ (Remarque `rem:heuristique_sotp_high`). $\square$

**Remarque (La ZK parfaite).** La ZK *parfaite* de Groth16 signifie que même un adversaire à calcul infini ne peut distinguer vraies preuves de simulées. C'est une garantie inconditionnelle une fois le CRS fixé, propriété remarquablement forte, qui fait de SOTP-High la variante la plus protectrice pour les contextes à haute entropie.

## A.8 Énoncés complets et produit CRO game-based

*Objectif de cette section.* Rassembler les bornes game-based des trois jeux et en déduire une borne inférieure sur le produit CRO. Cette borne complète le Trilemme CRO (borne supérieure) pour encadrer le produit réalisable.

### Sécurité complète de SOTP-Low

**Théorème `thm:ann_sotp_low_games` (SOTP-Low, bornes game-based complètes).** Sous PRG et DLOG dans $\mathbb{G}$ d'ordre $q$, on a, pour tout PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_conf)}$$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_rel)}$$

**Remarque `rem:ann_sotp_low_opp_statut` (Opposabilité de SOTP-Low, pas de borne game-based).** La formulation initiale de ce théorème contenait une troisième inégalité, $\mathsf{Err}^{\mathsf{EXT\text{-}OPP}} \leq 1 - \Delta/(\alpha H(\mathcal{C}))$, tirée du fait que la couche Clay $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ détermine le verdict. La présente formulation ne la reprend pas, car $\sigma_3$ est une fonction du contexte public $C$, donc $I(V;\sigma_3|C) = 0$ ; elle ne contribue ainsi en rien à l'opposabilité au sens de la Définition `def:interp_admissible`. Ce que SOTP-Low apporte au verdict passe par l'ouverture $(m,s,\rho)$ fournie à l'institution, ce qui relève de l'heuristique de conception (Remarque `rem:facteur_limitant_low`), sans réduction associée.

### Tableau récapitulatif des réductions

**Tableau `tab:ann_g_reductions` — Synthèse des réductions game-based pour la famille SOTP**

| Variante | Propriété | Jeu | Hypothèse | Borne |
|---|---|---|---|---|
| SOTP-Low | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq \varepsilon_{\mathsf{PRG}} + 1/q$ |
| SOTP-Low | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + 1/q$ |
| SOTP-Low | $\mathsf{Opp}$ | – | – | aucune (Rem. `rem:ann_sotp_low_opp_statut`) |
| SOTP-Base | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq \varepsilon_{\mathsf{PRG}} + 1/q$ (Cor. `cor:ann_sotp_base_reductions`) |
| SOTP-Base | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}}$ (Cor. `cor:ann_sotp_base_reductions`) |
| SOTP-Base | – | – | Lemme JL | dimensionnement de $k$ (Th. `thm:ann_sotp_base_opp`) |
| SOTP-High | $\mathsf{Conf}$ | IND-CONF | Groth16 ZK parfaite | $\mathsf{Conf} = 1$ |
| SOTP-High | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | Groth16 (GGM ou AGM), DLOG | $\geq 1-\mathrm{negl}(\lambda)$ |
| SOTP-High | $\mathsf{Opp}$ | – | – | aucune (Rem. `rem:heuristique_sotp_high`) |

### Corollaire central : produit CRO game-based

**Corollaire `cor:ann_cro_from_games` (Produit CLO depuis les jeux).** Si IND-CONF, BIND-REL et EXT-OPP sont gagnés avec avantages respectifs au plus $\varepsilon_{\mathsf{ind}}$, $\varepsilon_{\mathsf{bind}}$, $\varepsilon_{\mathsf{ext}}$, alors

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq \left(1-2\varepsilon_{\mathsf{ind}}\right) \left(1-\varepsilon_{\mathsf{bind}}\right) \left(1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1) + I(V;K|\Sigma,C)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_product\_games)}$$

où $\mathsf{Conf}_{\mathrm{calc}} = 1 - 2\varepsilon_{\mathsf{ind}}$ désigne la confidentialité calculatoire. Pour $\varepsilon_{\mathsf{ind}},\varepsilon_{\mathsf{bind}}, \varepsilon_{\mathsf{ext}} \ll 1$, il vient

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq 1 - O\left(\varepsilon_{\mathsf{ind}} + \varepsilon_{\mathsf{bind}} + \varepsilon_{\mathsf{ext}}\log_2|\mathcal{V}_\lambda| + h(\varepsilon_{\mathsf{ext}}) + \frac{I(V;K|\Sigma,C)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_approx)}$$

**Preuve.** **Terme $\mathsf{Conf}_{\mathrm{calc}}$.** Définition, avec le jeu IND-CONF (Remarque `rem:ann_ind_conf_link`). **Terme $\mathsf{Rel}_{\mathrm{ver}}$.** La Remarque `rem:ann_bind_rel_link` donne $\mathsf{Rel}_{\mathrm{ver}} \geq 1-\varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$. **Terme $\mathsf{Opp}$.** Remarque `rem:ann_ext_opp_link` (inégalité de Fano, `eq:ann_fano_opp`). Le produit $(1-a)(1-b)(1-c) \geq 1-a-b-c$ pour $a,b,c \in [0,1]$ donne (`eq:ann_cro_approx`). $\square$

**Remarque `rem:ann_pas_de_contradiction` (Pourquoi ce corollaire ne contredit pas le Trilemme).** Le Trilemme CRO (Théorème `thm:trilemme_cro_conditionnel`) majore le produit $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp}$, où $\mathsf{Conf}$ est statistique et $\mathsf{Rel}_{\mathrm{rec}}$ mesure la reconstruction du message. Le corollaire minore un produit d'une autre nature, qui fait intervenir la confidentialité *calculatoire* et la fiabilité de *vérification*. Les deux échelles ne se comparent pas. Un protocole peut avoir $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ proche de 1 tout en obéissant au Trilemme, puisque $\mathsf{Rel}_{\mathrm{rec}}$ reste alors de l'ordre de $2^{-\lambda}$ (Remarque `rem:rel_ver`). L'hypothèse que $\varepsilon_{\mathsf{ext}}$ est petit est précisément ce que le Trilemme rend coûteux lorsque $\mathsf{Conf}$ statistique est proche de 1 ; la Remarque `rem:activite_delta` indique quelle quantité ($\Delta$ ou Fano) limite alors $\mathsf{Opp}$. La formulation initiale de ce paragraphe annonçait un « encadrement » du produit par $\Delta/(\alpha\lambda)$ et une constante $c \in [0{,}45;\,0{,}85]$ ; la présente formulation distingue les deux échelles.

## A.9 Mécanisation en situation réduite

Cette section teste la mécanisation des preuves game-based de cette annexe sur une version réduite de SOTP-Low. Elle vise à montrer la faisabilité de la démarche ; la mécanisation complète des trois variantes suivra. Le fichier [lean/GameBasedSOTP.lean](lean/GameBasedSOTP.lean) n'utilise que Mathlib. Il a été vérifié le 22 novembre 2026 sur <https://live.lean-lang.org> et localement avec Lean v4.35.0 et Mathlib v4.35.0, sans erreur ni avertissement. Ses six `#print axioms` ne font apparaître que `propext`, `Classical.choice` et `Quot.sound`.

**Tableau `tab:ann_g_mecanisation` — Théorèmes game-based mécanisés en situation réduite**

| Théorème Lean | Énoncé | Énoncé de l'annexe |
|---|---|---|
| `otp_uniform` | la loi de $m + y$, $y$ uniforme, ne dépend pas de $m$ | masque jetable de la preuve du Théorème `thm:ann_sotp_low_conf` |
| `ind_conf_eq_prg` | $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}(\mathcal{A}) = \mathsf{Adv}^{\mathsf{PRG}}(\mathcal{B})$ | Théorème `thm:ann_sotp_low_conf` (couche Gold) |
| `ind_conf_perfect_otp` | avantage nul avec un masque uniforme | cas $y$ uniforme de la même preuve |
| `pedersen_extract` | $x = (s_0 - s_1)/(\rho_1 - \rho_0)$ | étapes 3 à 5 de la preuve du Théorème `thm:ann_sotp_low_rel` |
| `bind_rel_gives_dlog` | un gain BIND-REL donne le logarithme discret | Théorème `thm:ann_sotp_low_rel` |
| `win_bind_le_dlog` | $\mathsf{Win}^{\mathsf{BIND\text{-}REL}}(\mathcal{A}) \leq \mathsf{Adv}^{\mathsf{DLOG}}(\mathcal{B})$ | borne (`eq:ann_sotp_low_rel`) |

**Ce que signifie « situation réduite ».** Les probabilités sont des moyennes sur des ensembles finis munis de la loi uniforme. Les adversaires sont des fonctions dont l'aléa propre est absorbé dans leur description, ce qui suffit aux deux réductions. La graine est tirée dans un ensemble fini quelconque (Définition `def:ann_prg`), $\mathbb{Z}_q$ compris. Le groupe est un groupe quelconque engendré par un élément d'ordre premier $q$. La couche Iron n'entre pas dans le jeu de confidentialité, son masquage parfait correspondant au terme $1/q$, et la couche Clay n'est pas modélisée. Les hypothèses PRG et DLOG ne sont pas posées comme axiomes : les théorèmes relient l'avantage de l'adversaire à celui du réducteur construit à partir de lui.

**Ce qui reste à mécaniser.** Les adversaires probabilistes avec oracles, le terme $1/q$, SOTP-Base, SOTP-High, le jeu EXT-OPP et le Corollaire `cor:ann_cro_from_games`. Ces étapes demandent un cadre de jeux avec oracles, comme VCVio en Lean 4 [VCVio2026], et relèvent de l'article en préparation.

Le code source est reproduit ci-dessous (listing `lst:gamebased_lean`).

```lean
/-
  Preuves game-based de SOTP-Low en situation réduite — Annexe de thèse
  =====================================================================
  Version 1.0 (22 novembre 2026).

  OBJET
  Test de faisabilité de la mécanisation des preuves game-based de l'annexe A,
  sur une version réduite de SOTP-Low. Le fichier n'utilise que Mathlib et se
  vérifie sur https://live.lean-lang.org (projet Mathlib). Vérifié le 22 novembre
  2026 sur ce site et localement (Lean 4.35.0, Mathlib v4.35.0) : aucune erreur,
  aucun avertissement, six `#print axioms` limités à propext, Classical.choice et
  Quot.sound.

  CE QUI EST CERTIFIÉ
  1. Masque jetable : la loi de m + y, y uniforme, ne dépend pas de m.
  2. Confidentialité (couche Gold) : pour tout adversaire A contre IND-CONF, le
     réducteur B construit à partir de A vérifie Adv^IND-CONF(A) = Adv^PRG(B).
     La graine est tirée uniformément dans un ensemble fini quelconque S, par
     exemple Z_q comme dans l'Algorithme SOTP-Low.
  3. Fiabilité de vérification (couches Gold et Iron) : deux ouvertures acceptées
     d'une même preuve sur deux messages distincts donnent le logarithme discret
     de h en base g. Le réducteur B résout DLOG chaque fois que A gagne BIND-REL,
     d'où Win^BIND-REL(A) ≤ Adv^DLOG(B).

  SITUATION RÉDUITE
  • Les probabilités sont des moyennes sur des ensembles finis (lois uniformes).
  • Les adversaires sont des fonctions ; leur aléa propre est absorbé dans leur
    description, ce qui suffit pour les deux réductions ci-dessus.
  • La couche Iron n'est pas modélisée dans le jeu de confidentialité (son
    masquage parfait est le terme 1/q de l'annexe), la couche Clay n'est pas
    modélisée (fonction publique du contexte).
  • PRG et DLOG ne sont pas des axiomes : ce sont les avantages de B, que le
    théorème relie à ceux de A.
-/

import Mathlib

open Finset

namespace GameBasedSOTP

/-! ## 1. Probabilité uniforme sur un ensemble fini -/

/-- Espérance de `f` sous la loi uniforme sur `X`. -/
noncomputable def avg {X : Type*} [Fintype X] (f : X → ℝ) : ℝ :=
  (∑ x, f x) / Fintype.card X

/-- Indicatrice d'une proposition décidable. -/
def ind (p : Prop) [Decidable p] : ℝ := if p then 1 else 0

lemma avg_add {X : Type*} [Fintype X] (f g : X → ℝ) :
    avg (fun x => f x + g x) = avg f + avg g := by
  unfold avg; rw [sum_add_distrib, add_div]

lemma avg_const {X : Type*} [Fintype X] [Nonempty X] (c : ℝ) :
    avg (fun _ : X => c) = c := by
  unfold avg
  have h : (Fintype.card X : ℝ) ≠ 0 := by exact_mod_cast Fintype.card_ne_zero
  rw [sum_const, card_univ, nsmul_eq_mul]; field_simp

/-- On peut échanger l'ordre de deux tirages uniformes indépendants. -/
lemma avg_comm {X Y : Type*} [Fintype X] [Fintype Y] (f : X → Y → ℝ) :
    avg (fun x => avg (fun y => f x y)) = avg (fun y => avg (fun x => f x y)) := by
  unfold avg
  simp only [← Finset.sum_div, div_div]
  rw [Finset.sum_comm, mul_comm]

lemma avg_mono {X : Type*} [Fintype X] {f g : X → ℝ} (h : ∀ x, f x ≤ g x) :
    avg f ≤ avg g := by
  unfold avg
  apply div_le_div_of_nonneg_right (sum_le_sum fun x _ => h x) (Nat.cast_nonneg _)

/-! ## 2. Masque jetable -/

/-- **Masque jetable.** Pour tout groupe abélien fini M et tout message m, la loi de
    m + y, avec y uniforme, est la loi uniforme : pour toute statistique f,
    E_y[f(m + y)] = E_y[f(y)]. -/
theorem otp_uniform {M : Type*} [AddCommGroup M] [Fintype M] (m : M) (f : M → ℝ) :
    avg (fun y => f (m + y)) = avg f := by
  unfold avg
  congr 1
  exact Fintype.sum_equiv (Equiv.addLeft m) _ _ (fun _ => rfl)

/-! ## 3. Confidentialité de la couche Gold, réduction au PRG

Jeu IND-CONF réduit. Le challenger tire b uniforme dans Bool et la graine s
uniforme dans S, puis envoie σ₁ = m_b + G(s). L'adversaire A rend une estimation de b.
Avantage : |Pr[A(σ₁) = b] − 1/2|.

Jeu PRG. Le distingueur reçoit y = G(s), s uniforme dans S, ou y uniforme dans M.
Avantage : |Pr[B(G(s)) = 1] − Pr[B(y) = 1]|. -/

variable {S M : Type*} [Fintype S] [AddCommGroup M] [Fintype M]

/-- Probabilité de succès de A dans IND-CONF. -/
noncomputable def winIND (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  avg (fun b : Bool => avg (fun s : S => ind (A (m b + G s) = b)))

/-- Avantage de A dans IND-CONF. -/
noncomputable def advIND (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  |winIND G m A - 1 / 2|

/-- Réducteur B : sur le défi y, il tire b, envoie m_b + y à A et rend 1 si A trouve b.
    `accB y` est sa probabilité de rendre 1. -/
noncomputable def accB (m : Bool → M) (A : M → Bool) (y : M) : ℝ :=
  avg (fun b : Bool => ind (A (m b + y) = b))

/-- Avantage de B dans le jeu PRG. -/
noncomputable def advPRG (G : S → M) (m : Bool → M) (A : M → Bool) : ℝ :=
  |avg (fun s : S => accB m A (G s)) - avg (fun y : M => accB m A y)|

/-- Sur un défi uniforme, B rend 1 avec probabilité 1/2 (masque jetable). -/
lemma accB_uniform (m : Bool → M) (A : M → Bool) :
    avg (fun y : M => accB m A y) = 1 / 2 := by
  have hsw : avg (fun y : M => accB m A y)
      = avg (fun b : Bool => avg (fun y : M => ind (A (m b + y) = b))) := by
    unfold accB; exact avg_comm _
  rw [hsw]
  have hotp : ∀ b : Bool, avg (fun y : M => ind (A (m b + y) = b))
      = avg (fun y : M => ind (A y = b)) :=
    fun b => otp_uniform (m b) (fun z => ind (A z = b))
  simp only [hotp]
  have hpart : ∀ y : M, ind (A y = false) + ind (A y = true) = 1 := by
    intro y; unfold ind; cases A y <;> simp
  have h1 : avg (fun y : M => ind (A y = false)) + avg (fun y : M => ind (A y = true))
      = 1 := by
    rw [← avg_add]; simp only [hpart]
    have : Nonempty M := ⟨0⟩
    exact avg_const 1
  unfold avg at h1 ⊢
  simp only [Fintype.univ_bool, mem_singleton, Bool.true_eq_false, not_false_eq_true,
    sum_insert, sum_singleton, Fintype.card_bool, Nat.cast_ofNat]
  linarith

/-- **Théorème (réduction de la confidentialité de SOTP-Low au PRG).** Pour tout
    adversaire A contre IND-CONF, le réducteur B construit à partir de A a exactement
    le même avantage dans le jeu PRG : Adv^IND-CONF(A) = Adv^PRG(B). En particulier,
    si G est un PRG sûr, la couche Gold est IND-CONF. -/
theorem ind_conf_eq_prg (G : S → M) (m : Bool → M) (A : M → Bool) :
    advIND G m A = advPRG G m A := by
  unfold advIND advPRG
  rw [accB_uniform]
  congr 2
  unfold winIND accB
  exact avg_comm _

/-- Si le défi PRG est remplacé par un masque uniforme, l'avantage IND-CONF est nul :
    confidentialité parfaite du masque jetable. -/
theorem ind_conf_perfect_otp (m : Bool → M) (A : M → Bool) :
    |avg (fun b : Bool => avg (fun y : M => ind (A (m b + y) = b))) - 1 / 2| = 0 := by
  have h := accB_uniform m A
  unfold accB at h
  rw [avg_comm] at h
  rw [h]; simp

/-! ## 4. Fiabilité de vérification, réduction au logarithme discret

Groupe G engendré par g d'ordre premier q. Engagement de Pedersen
Com(s, ρ) = g^s · h^ρ avec h = g^x. Une ouverture de la preuve (σ₁, σ₂) est un triplet
(m, s, ρ) avec σ₁ = m + PRG(s) et σ₂ = Com(s, ρ). -/

section DLog

variable {q : ℕ} [Fact q.Prime] {Γ : Type*} [Group Γ]

/-- Puissance indexée par ZMod q. -/
def zpowq (g : Γ) (a : ZMod q) : Γ := g ^ a.val

/-- Engagement de Pedersen, h = g^x. -/
def com (g : Γ) (x s ρ : ZMod q) : Γ := zpowq g s * (zpowq g x) ^ ρ.val

lemma zpowq_natCast (g : Γ) (hg : orderOf g = q) (n : ℕ) :
    zpowq g (n : ZMod q) = g ^ n := by
  unfold zpowq
  rw [ZMod.val_natCast, ← hg, pow_mod_orderOf]

/-- L'engagement s'écrit g^(s + x·ρ). -/
lemma com_eq (g : Γ) (hg : orderOf g = q) (x s ρ : ZMod q) :
    com g x s ρ = zpowq g (s + x * ρ) := by
  have e : s + x * ρ = ((s.val + x.val * ρ.val : ℕ) : ZMod q) := by
    push_cast; simp
  rw [e, zpowq_natCast g hg]
  unfold com zpowq
  rw [← pow_mul, ← pow_add]

/-- g^a = g^b dans ZMod q implique a = b (g d'ordre q). -/
lemma zpowq_inj (g : Γ) (hg : orderOf g = q) {a b : ZMod q}
    (h : zpowq g a = zpowq g b) : a = b := by
  unfold zpowq at h
  rw [pow_eq_pow_iff_modEq, hg] at h
  apply ZMod.val_injective
  exact Nat.ModEq.eq_of_lt_of_lt h (ZMod.val_lt a) (ZMod.val_lt b)

/-- **Extraction du logarithme discret.** Deux ouvertures (s₀, ρ₀) ≠ (s₁, ρ₁) d'un même
    engagement, avec s₀ ≠ s₁, donnent ρ₀ ≠ ρ₁ et x = (s₀ − s₁)/(ρ₁ − ρ₀). -/
theorem pedersen_extract (g : Γ) (hg : orderOf g = q) {x s₀ ρ₀ s₁ ρ₁ : ZMod q}
    (hcol : com g x s₀ ρ₀ = com g x s₁ ρ₁) (hs : s₀ ≠ s₁) :
    ρ₀ ≠ ρ₁ ∧ x = (s₀ - s₁) / (ρ₁ - ρ₀) := by
  rw [com_eq g hg, com_eq g hg] at hcol
  have e := zpowq_inj g hg hcol
  have hρ : ρ₀ ≠ ρ₁ := by
    intro h; apply hs; rw [h] at e; linear_combination e
  refine ⟨hρ, ?_⟩
  have hd : ρ₁ - ρ₀ ≠ 0 := sub_ne_zero.mpr (Ne.symm hρ)
  rw [eq_div_iff hd]
  linear_combination -e

variable {S M : Type*} [AddCommGroup M]

/-- Une ouverture : message, graine, aléa de l'engagement. -/
structure Opening (S M : Type*) (q : ℕ) where
  m : M
  s : S
  ρ : ZMod q

/-- Ouverture acceptée de la preuve (σ₁, σ₂) pour la graine dans ZMod q. -/
def accepts (g : Γ) (x : ZMod q) (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ)
    (o : Opening (ZMod q) M q) : Prop :=
  σ₁ = o.m + PRG o.s ∧ σ₂ = com g x o.s o.ρ

/-- Victoire dans BIND-REL : deux ouvertures acceptées sur des messages distincts. -/
def winsBIND (g : Γ) (x : ZMod q) (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ)
    (o₀ o₁ : Opening (ZMod q) M q) : Prop :=
  accepts g x PRG σ₁ σ₂ o₀ ∧ accepts g x PRG σ₁ σ₂ o₁ ∧ o₀.m ≠ o₁.m

/-- Le réducteur DLOG : il calcule (s₀ − s₁)/(ρ₁ − ρ₀) à partir des deux ouvertures. -/
def extract (o₀ o₁ : Opening (ZMod q) M q) : ZMod q :=
  (o₀.s - o₁.s) / (o₁.ρ - o₀.ρ)

/-- **Théorème (réduction de la fiabilité de vérification de SOTP-Low au DLOG).**
    Si A gagne BIND-REL, le réducteur rend exactement le logarithme discret x de h.
    Les messages distincts forcent des graines distinctes, condition qui exige la
    graine dans ZMod q. -/
theorem bind_rel_gives_dlog (g : Γ) (hg : orderOf g = q) (x : ZMod q)
    (PRG : ZMod q → M) (σ₁ : M) (σ₂ : Γ) (o₀ o₁ : Opening (ZMod q) M q)
    (hw : winsBIND g x PRG σ₁ σ₂ o₀ o₁) : extract o₀ o₁ = x := by
  obtain ⟨⟨h₀, c₀⟩, ⟨h₁, c₁⟩, hm⟩ := hw
  have hs : o₀.s ≠ o₁.s := by
    intro h; apply hm
    have : o₀.m + PRG o₀.s = o₁.m + PRG o₁.s := h₀.symm.trans h₁
    rw [h] at this; exact add_right_cancel this
  exact ((pedersen_extract g hg (c₀.symm.trans c₁) hs).2).symm

/-- **Corollaire probabiliste.** Pour tout adversaire A qui, sur h = g^x, rend une preuve
    et deux ouvertures, la probabilité de victoire dans BIND-REL (x uniforme) est au plus
    la probabilité de succès du réducteur contre DLOG : Win^BIND-REL(A) ≤ Adv^DLOG(B). -/
theorem win_bind_le_dlog (g : Γ) (hg : orderOf g = q) (PRG : ZMod q → M)
    (A : Γ → M × Γ × Opening (ZMod q) M q × Opening (ZMod q) M q)
    [∀ x, Decidable (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
      (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2)] :
    avg (fun x : ZMod q => ind (winsBIND g x PRG (A (zpowq g x)).1 (A (zpowq g x)).2.1
        (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2))
      ≤ avg (fun x : ZMod q =>
          ind (extract (A (zpowq g x)).2.2.1 (A (zpowq g x)).2.2.2 = x)) := by
  apply avg_mono
  intro x
  unfold ind
  split_ifs with h1 h2
  · exact le_rfl
  · exact absurd (bind_rel_gives_dlog g hg x PRG _ _ _ _ h1) h2
  · norm_num
  · exact le_rfl

end DLog

end GameBasedSOTP

/-! ## Bloc de vérification -/

#print axioms GameBasedSOTP.otp_uniform
#print axioms GameBasedSOTP.ind_conf_eq_prg
#print axioms GameBasedSOTP.ind_conf_perfect_otp
#print axioms GameBasedSOTP.pedersen_extract
#print axioms GameBasedSOTP.bind_rel_gives_dlog
#print axioms GameBasedSOTP.win_bind_le_dlog
```

## A.10 Limitations et portée des réductions

*Objectif de cette section.* Énumérer les cinq limitations des réductions game-based, à savoir la conditionnalité, l'interprète honnête, la réduction one-way, le terme $1/q$ et la relation avec Lean4.

1. **Conditionnalité aux hypothèses calculatoires.** La sécurité de SOTP-Low est prouvée sous PRG et DLOG. SOTP-High via Groth16 repose sur la difficulté des couplages sur BN254, non post-quantique. Une extension aux primitives résistantes aux quantiques (STARKs, réseaux euclidiens) est une direction de recherche ouverte (section `sec:sotp_construction`).
2. **Modèle d'interprète honnête dans EXT-OPP.** Le jeu suppose que l'interprète tente sincèrement d'extraire le bon verdict. Un interprète *adversarial* (juge corrompu) n'est pas modélisé. Des extensions game-théoriques (régulateur vs entité auditée) sont identifiées comme direction future (section `sec:sotp_construction`).
3. **Réduction SOTP-Base one-way.** Le Théorème `thm:ann_sotp_base_opp` garantit seulement l'implication *dimension suffisante $\Rightarrow$ préservation JL*. Il ne garantit pas que la préservation des distances permette d'extraire le verdict, car cela dépend de la fonction $f_\Delta$ choisie par l'institution, dont ni l'existence ni la calculabilité efficace ne sont établies.
4. **Terme $1/q$ dans les bornes SOTP-Low.** Les équations (`eq:ann_sotp_low_conf`) et (`eq:ann_sotp_low_rel`) contiennent $1/q$. Il est négligeable en $\lambda$ au sens strict dès que l'ordre du groupe vérifie $\log_2 q \geq \lambda$, ce qui est le cas des paramètres utilisés ($q \approx 2^{252}$, soit $1/q \approx 10^{-76}$). Le terme est conservé pour que les bornes restent exactes à $\lambda$ fixé. Dans la borne de confidentialité, il correspond à l'événement $h = 1$, où l'engagement n'est plus masquant. Dans la borne de liaison, il n'est ajouté que par symétrie.
5. **Relation avec la formalisation Lean4 (Annexe `chap:annexe_lean4`).** Les deux annexes se complètent de la manière suivante.
   - **Lean4 (Annexe `chap:annexe_lean4`)** certifie mécaniquement la dérivation algébrique de la borne $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp} \leq \Delta/\lambda + K/\lambda^2 + \varepsilon(\lambda)$ (Théorème `thm:conditional_CRO_trilemma`), en posant Fano et Pinsker comme propriétés de chaque instance et l'extraction bornée comme hypothèse
   - **Annexe `chap:annexe_gamebased` (ici)** établit les propriétés cryptographiques de la famille SOTP (confidentialité calculatoire, fiabilité de vérification) sous PRG, DLOG et Groth16 ; elle n'instancie pas les hypothèses du Trilemme, qui portent sur $\mathsf{Conf}$ statistique et $\mathsf{Rel}_{\mathrm{rec}}$

   Les deux niveaux sont donc complémentaires sans se composer en une preuve unique, puisque le niveau *formel* certifie la logique de la dérivation du Trilemme tandis que le niveau *game-based* justifie les garanties cryptographiques des constructions. La section A.9 commence à mécaniser ce second niveau, en situation réduite.

## Notes de transcription

- Les notations de dimension sont désormais celles de l'Algorithme `alg:sotp_base`. La dimension de plongement est $d$ et la dimension d'arrivée de la projection est $k$, dans l'annexe comme dans le texte principal (note T4 de la spécification, résolue).
