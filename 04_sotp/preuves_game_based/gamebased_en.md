> **Status: PROPOSAL. construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Annex A (`chap:annexe_gamebased`), file [gamebased_source_fr.tex](gamebased_source_fr.tex) (French)

# Game-based security and formal reductions for the SOTP family

*Version française : [gamebased_fr.md](gamebased_fr.md)*

English Markdown rendering of Annex A of the thesis, in its final version. Statements, games, reductions and proofs are translated without any change of substance. The pedagogical margin comments of the source (macros `\cmt` and `\cmtFormule`) are omitted; they appear in [gamebased_source_fr.tex](gamebased_source_fr.tex). No English `.tex` version is provided: this Markdown file is the English reference. Internal cross-references are given by their LaTeX label and references by their key. The algorithms are specified in [../specification/sotp_specification_en.md](../specification/sotp_specification_en.md).

## Introduction

The CLO framework defines $\mathsf{Conf}$, $\mathsf{Rel}$ and $\mathsf{Opp}$ in information-theoretic terms, namely conditional entropies, mutual information and total variation distance [MINKA2026CLO]. This approach yields general results (Contextual Bottleneck Theorem, Conditional CRO Trilemma), but does not directly state *what a computationally bounded adversary can or cannot do*. In computational cryptography, security is classically expressed through *games* between a challenger and a probabilistic polynomial-time (PPT) adversary.

*Why this annex.* The CLO framework reasons in bits and entropies, whereas classical cryptography reasons in games and adversarial advantages. This annex builds the bridge between the two by capturing each CLO metric with a cryptographic game, then relating each game to a standard hardness assumption (PRG, DLOG, JL, Groth16).

This annex establishes the **formal bridge** between the two worlds in three steps.

1. Define cryptographic games (*IND-CONF*, *BIND-REL*, *EXT-OPP*) that operationally capture $\mathsf{Conf}$ (in its computational version), $\mathsf{Rel}_{\mathrm{ver}}$ and $\mathsf{Opp}$
2. Prove formal *reductions* establishing that, if a PPT adversary wins one of these games, it solves a problem assumed to be hard (PRG, discrete logarithm, JL, Groth16)
3. Derive a **game-based lower bound on the CLO product** (Corollary `cor:ann_cro_from_games`), on the operational scale (computational confidentiality, verification reliability), which is not directly comparable with the Trilemma (Remark `rem:ann_pas_de_contradiction`)

*Three games, three metrics.* **IND-CONF** captures confidentiality by requiring that the adversary cannot distinguish the proofs of two messages. **BIND-REL** captures reliability, since the adversary must not be able to open a proof to two distinct messages. Finally, **EXT-OPP** captures opposability, the institutional interpreter having to extract the right verdict from the proof.

**Convention.** Every adversary $\mathcal{A}$ is probabilistic polynomial-time (PPT) in $\lambda$ unless stated otherwise. The challenger is denoted $\mathcal{C}$. A reduction builds an algorithm $\mathcal{B}$ (reducer) that uses $\mathcal{A}$ to solve a hard problem.

**Table `tab:ann_g_structure` — Structure of the annex**

| Section | Content | Property | Assumption |
|---|---|---|---|
| [A.1](#a1-cryptographic-primitives-and-preliminary-definitions) | Primitives and preliminary definitions | – | – |
| [A.2](#a2-ind-conf-game-game-based-confidentiality) | IND-CONF game + link to $\mathsf{Conf}$ | $\mathsf{Conf}$ | PRG |
| [A.3](#a3-bind-rel-game-game-based-reliability) | BIND-REL game + link to $\mathsf{Rel}_{\mathrm{ver}}$ | $\mathsf{Rel}_{\mathrm{ver}}$ | DLOG |
| [A.4](#a4-ext-opp-game-game-based-opposability) | EXT-OPP game + link to $\mathsf{Opp}$ | $\mathsf{Opp}$ | Fano |
| [A.5](#a5-formal-reductions-for-sotp-low) | SOTP-Low reductions | $\mathsf{Conf}_{\mathrm{calc}}$, $\mathsf{Rel}_{\mathrm{ver}}$ | PRG, DLOG |
| [A.6](#a6-jl-reduction-for-sotp-base) | SOTP-Base sizing | – | JL |
| [A.7](#a7-reductions-for-sotp-high) | SOTP-High reductions | $\mathsf{Conf}$, $\mathsf{Rel}_{\mathrm{ver}}$ | Groth16 |
| [A.8](#a8-complete-statements-and-game-based-cro-product) | Complete statements + CLO product | $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ | All |
| [A.9](#a9-limitations-and-scope-of-the-reductions) | Limitations and scope | – | – |

---

## A.1 Cryptographic primitives and preliminary definitions

*Purpose of this section.* Recall the four cryptographic primitives used in the SOTP family, namely the PRG (Gold layer), the Pedersen commitment (Iron layer), the Groth16 zk-SNARK (SOTP-High) and the Johnson-Lindenstrauss transform (SOTP-Base), together with two theoretical tools, Fano's inequality and the DPI.

### Pseudo-random generator (PRG)

**Intuition.** A PRG takes a short seed $s \in \lbrace 0,1\rbrace^\lambda$ and produces a long sequence $G(s) \in \lbrace 0,1\rbrace^{L(\lambda)}$, $L > \lambda$, indistinguishable from a truly random sequence. It underlies the Gold layer of SOTP-Low, in which the pad $G(s)$ masks the message so that, without $s$, no PPT adversary can recover $m$ from $m \oplus G(s)$.

**Definition `def:ann_prg` (PRG security [GoldreichKrawczyk99]).** A polynomial-time computable function $G : \lbrace 0,1\rbrace^\lambda \to \lbrace 0,1\rbrace^{L(\lambda)}$ with $L(\lambda) > \lambda$ is a secure PRG if, for every PPT adversary $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{A}}(\lambda) = \left| \Pr_{s \leftarrow \lbrace 0,1\rbrace^\lambda}\big[\mathcal{A}(G(s)) = 1\big] - \Pr_{y \leftarrow \lbrace 0,1\rbrace^{L(\lambda)}}\big[\mathcal{A}(y) = 1\big] \right| \leq \mathrm{negl}(\lambda)$$

**Practical implementations.** SOTP-Low uses ChaCha20/AES-CTR, two standardised PRGs meeting this definition.

### Pedersen commitment

**Intuition.** The Pedersen commitment lets a prover "commit" to $m$ without revealing it (*perfect hiding*), while being unable to change its mind (*computational binding*). The construction $\mathsf{Com}(m, r) = g^m h^r$ uses the algebra of cyclic groups, so that any commitment collision would allow computing $\log_g h$, solving the discrete logarithm.

**Definition `def:ann_pedersen` (Pedersen commitment [Pedersen91]).** Let $\mathbb{G}$ be a cyclic group of prime order $q$, $g, h \in \mathbb{G}$ two generators such that $\log_g h$ is unknown.

- $\mathsf{Com}(m, r) = g^m h^r \in \mathbb{G}$, $m,r \in \mathbb{Z}_q$ (group operation)
- $\mathsf{Open}(\sigma_2, m, r)$ accepts if $\sigma_2 = g^m h^r$

**Perfect Hiding.** For all $m_0, m_1$, the commitments $\mathsf{Com}(m_0, r_0)$ and $\mathsf{Com}(m_1, r_1)$ are identically distributed for $r_0, r_1 \xleftarrow{\$} \mathbb{Z}_q$.

**Computational Binding.** No PPT adversary can find $(m_0, r_0, m_1, r_1)$ with $m_0 \neq m_1$ such that $g^{m_0} h^{r_0} = g^{m_1} h^{r_1}$ in $\mathbb{G}$.

**Role in SOTP.** The Iron layer of every SOTP variant is a Pedersen commitment (to the seed $s \in \mathbb{Z}_q$ for SOTP-Low and SOTP-Base, to $m$ for SOTP-High). It guarantees verification reliability $\mathsf{Rel}_{\mathrm{ver}}$, since a proof cannot be "opened" to two distinct messages.

### Groth16 zk-SNARK

**Intuition.** A zk-SNARK for a relation $\mathcal{R}$ allows proving knowledge of a witness $w$ such that $(x,w) \in \mathcal{R}$, without revealing $w$, in a constant-size proof. A Groth16 proof consists of three group elements, that is 128 bytes (compressed points) on BN254 or 192 bytes on BLS12-381; it is verified with $O(1)$ pairings.

**Definition `def:ann_groth16` (Groth16 zk-SNARK [Groth16]).** $(\mathsf{Setup}, \mathsf{Prove}, \mathsf{Verify})$ satisfies the following properties.

**Perfect completeness.** $\Pr[\mathsf{Verify}(\sigma_v,x,\pi)=1 \mid (x,w)\in\mathcal{R}] = 1$

**Knowledge soundness.** For every PPT $\mathcal{A}$, there exists an extractor $\mathcal{E}$ such that

$$\Pr\left[ \mathsf{Verify}(\sigma_v,x,\pi)=1 \land (x,w)\notin\mathcal{R} \;:\; (x,\pi)\leftarrow\mathcal{A}(\sigma_p),\ w\leftarrow\mathcal{E}(\sigma_p) \right] \leq \mathrm{negl}(\lambda)$$

**Perfect zero-knowledge.** There exists a simulator $\mathcal{S}$ such that for every $(x,w)\in\mathcal{R}$,

$$\lbrace\pi :  \pi \leftarrow \mathsf{Prove}(\sigma_p,x,w)\rbrace \equiv \lbrace\pi :  \pi \leftarrow \mathcal{S}(\sigma_p,x)\rbrace \quad\text{(identical distributions)}$$

**Reading for SOTP-High.** *Perfect* zero-knowledge, together with the perfect hiding of the commitment $c_m$, implies that $(\pi, c_m)$ is independent of $m$ given $c$, hence $\mathsf{Conf} = 1$ in the statistical sense. Knowledge soundness implies verification reliability $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$; it says nothing about reconstruction reliability, which equals $2^{-\lambda}$ when $\mathsf{Conf} = 1$ (Remark `rem:rel_ver`).

### Johnson-Lindenstrauss (JL) transform

**Intuition.** The JL transform projects $N$ points of $\mathbb{R}^n$ into $\mathbb{R}^d$ ($d \ll n$) while approximately preserving all pairwise distances. In SOTP-Base, contexts $c \in \mathbb{R}^n$ are compressed into $\Phi c \in \mathbb{R}^d$, keeping the structure that enables institutional extraction.

**Definition `def:ann_jl` (JL transform [JohnsonLindenstrauss84, DasguptaGupta03]).** For $0 < \varepsilon < 1$, $N > 0$, $S \subset \mathbb{R}^n$ with $|S| = N$, there exists $\Phi : \mathbb{R}^n \to \mathbb{R}^d$ with $d = O(\varepsilon^{-2} \log N)$ such that, for all $x,y \in S$,

$$(1-\varepsilon)\|x-y\|^2 \leq \|\Phi x-\Phi y\|^2 \leq (1+\varepsilon)\|x-y\|^2$$

**Dimension lemma for SOTP-Base.** The minimal dimension $d$ preserving $\Delta$ bits of extraction with tolerance $\varepsilon^2$ is given by the condition

$$d \geq \frac{4\Delta H(\mathcal{C})}{\varepsilon^2} \qquad \text{(eq:ann\_jl\_dim)}$$

### Fundamental theoretical tools

**Lemma `lem:ann_g_fano` (Fano's inequality [CoverThomas06]).** Let $X$ be a variable with $k$ values, $\hat{X}$ an estimator, $p_e = \Pr[X \neq \hat{X}]$. Then

$$H(X|\hat{X}) \leq h(p_e) + p_e \log_2(k-1)$$

**Reading.** Low extraction error $p_e$ $\Rightarrow$ low residual uncertainty $H(X|\hat{X})$ $\Rightarrow$ large extracted mutual information. This lemma is the direct bridge between the EXT-OPP game and the $\mathsf{Opp}$ metric.

**Lemma `lem:ann_dpi` (Data-processing inequality, DPI [CoverThomas06]).** If $X \to Y \to Z$ forms a Markov chain, then $I(X;Z) \leq I(X;Y)$.

**Reading.** Any transformation of $Y$ can only increase uncertainty about $X$. An adversary observing $\sigma$ can extract at most $I(M;\Sigma|C)$ bits about $m$, which grounds the link between $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}$ and $I(M;\Sigma|C)$.

## A.2 IND-CONF game: game-based confidentiality

*Purpose of this section.* Define the IND-CONF game capturing confidentiality, then establish its link with the CLO metric $\mathsf{Conf}$.

### Definition of the game

**Intuition.** The adversary chooses two messages $m_0, m_1$, receives the proof of one of them (secretly chosen by the challenger), then must guess which. If the protocol is confidential, the adversary does no better than a random guess (advantage $\approx 0$).

**Definition `def:ann_ind_conf` (IND-CONF game).** For a protocol $\mathcal{P} = (\mathsf{Setup},\mathsf{Prove}, \mathsf{Verify})$ and an adversary $\mathcal{A}$, the game runs as follows.

1. $\mathcal{A}$ receives $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ chooses $m_0,m_1 \in \mathcal{M}_\lambda$ ($|m_0|=|m_1|$) and $c \in \mathcal{C}_\lambda$ *(challenge phase)*
3. The challenger samples $b \xleftarrow{\$} \lbrace 0,1\rbrace$ and computes $\sigma \leftarrow \mathsf{Prove}(pp, m_b, c)$
4. $\mathcal{A}$ receives $\sigma$ and outputs $b' \in \lbrace 0,1\rbrace$ *(response phase)*
5. The experiment outputs 1 if $b' = b$, and 0 otherwise

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) = \left|\Pr\left[ \mathsf{Exp}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) = 1\right] - \frac{1}{2}\right|$$

### Link with information-theoretic $\mathsf{Conf}$

**Remark `rem:ann_ind_conf_link` (IND-CONF $\leftrightarrow$ $\mathsf{Conf}$ bridge).** For every distinguisher $\mathcal{A}$, even computationally unbounded,

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathcal{P}}(\lambda) \;\leq\; \frac{1 - \mathsf{Conf}(\mathcal{P})}{2},$$

with equality for the Neyman–Pearson test on the most distinguishable pair (Remark `rem:jeu_ind_conf_link`). A protocol with $\mathsf{Conf} \geq 1 - \mathrm{negl}(\lambda)$ therefore resists the IND-CONF game. The converse is false, because resistance to IND-CONF against PPT adversaries is a computational property, compatible with weak statistical confidentiality. The reductions of this annex establish computational guarantees, which we denote $\mathsf{Conf}_{\mathrm{calc}}$ when they must be distinguished from $\mathsf{Conf}$.

## A.3 BIND-REL game: game-based reliability

*Purpose of this section.* Define the BIND-REL game capturing reliability (non-equivocation), then establish its link with the metric $\mathsf{Rel}_{\mathrm{ver}}$.

### Definition of the game

**Intuition.** The game captures *non-equivocation*: an adversary must not be able to produce a proof $\sigma$ that can be opened to two distinct messages $m_0 \neq m_1$. Unlike IND-CONF, the adversary freely chooses $(c, \sigma, s_0, s_1)$, modelling an agent who deliberately forges an ambiguous proof.

**Definition `def:ann_bind_rel` (BIND-REL game).** For a protocol $\mathcal{P}$ with $\mathsf{Open}$ and an adversary $\mathcal{A}$, the game runs as follows.

1. $\mathcal{A}$ receives $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ outputs $(c, \sigma, s_0, s_1)$
3. Compute $m_i = \mathsf{Open}(pp, \sigma, s_i)$ for $i \in \lbrace 0,1\rbrace$
4. $\mathcal{A}$ *wins* if and only if $\mathsf{Verify}(pp,\sigma,c)=1$, $m_0 \neq m_1$, $m_0 \neq \bot$ and $m_1 \neq \bot$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) = \Pr\left[\mathcal{A} \text{ wins in } \mathsf{Exp}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathcal{P}}(\lambda) \right]$$

### Link with $\mathsf{Rel}_{\mathrm{ver}}$ (verification reliability)

**Remark `rem:ann_bind_rel_link` (BIND-REL $\leftrightarrow$ $\mathsf{Rel}_{\mathrm{ver}}$ bridge).** For a complete protocol whose BIND-REL winning probability is at most $\varepsilon_{\mathsf{bind}}$,

$$\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$$

(Remark `rem:jeu_bind_rel_link`). BIND-REL says nothing about reconstruction reliability $\mathsf{Rel}_{\mathrm{rec}}$, since a perfectly hiding and binding commitment has $\mathsf{Rel}_{\mathrm{rec}} = 2^{-\lambda}$.

## A.4 EXT-OPP game: game-based opposability

*Purpose of this section.* Define the EXT-OPP game capturing institutional opposability, then establish its link with the metric $\mathsf{Opp}$ through Fano's inequality.

### Definition of the game

**Intuition.** The game models the ability of an institutional interpreter to extract the right verdict from a proof. The "adversary" here is the interpreter itself (judge, regulator), whose *error* probability is measured. The reference verdict $v^*$ is the one the institution would reach with full knowledge of the facts (Definition `def:interp_admissible`); the institution must reach a decision aligned with the legal context, beyond the mere verification of the proof.

**Definition `def:ann_ext_opp` (EXT-OPP game).** For a protocol $\mathcal{P}$, an interpreter $\mathsf{Interpret}$ of capacity $\Delta$ and a distribution $\mathcal{D}_C$ fixed in advance, the game runs as follows.

1. The challenger samples $c \leftarrow \mathcal{D}_C$, $m \leftarrow \mathcal{M}_\lambda$
2. The challenger computes $\sigma \leftarrow \mathsf{Prove}(pp,m,c)$
3. The interpreter receives $(\sigma,c)$ and outputs $v \leftarrow \mathsf{Interpret}(pp,\sigma,c,\Delta)$
4. Let $v^*$ be the reference verdict, a realisation of the variable $V$ (which may depend on the message, the context and institutional resources, Definition `def:interp_admissible`)
5. The interpreter *wins* if $v = v^*$

$$\mathsf{Err}^{\mathsf{EXT\text{-}OPP}}_{\mathsf{Interpret},\mathcal{P},\mathcal{D}_C}(\lambda) = \Pr\left[ \mathsf{Interpret} \text{ loses in } \mathsf{Exp}^{\mathsf{EXT\text{-}OPP}}\right]$$

**Why is $\mathcal{D}_C$ fixed in advance?** Opposability depends on the institutional domain. A protocol highly opposable in a simple contractual context may be poorly opposable in a complex regulatory context. Fixing $\mathcal{D}_C$ parameterises the game by the domain.

### Link with $\mathsf{Opp}$ through Fano

**Remark `rem:ann_ext_opp_link` (EXT-OPP $\leftrightarrow$ $\mathsf{Opp}$ bridge).** By Fano (Lemma `lem:ann_g_fano`) applied to the estimation of $V$ from $(\Sigma,C)$,

$$\mathsf{Opp} = 1 - \frac{H(V|\Sigma,C)}{H(V|C)} \geq 1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1)}{H(V|C)} \qquad \text{(eq:ann\_fano\_opp)}$$

where $\varepsilon_{\mathsf{ext}} = \mathsf{Err}^{\mathsf{EXT\text{-}OPP}}$ and $h(\cdot)$ is the binary entropy. An interpreter with low extraction error implies high opposability.

## A.5 Formal reductions for SOTP-Low

SOTP-Low operates in the context-scarce regime ($H(\mathcal{C}) < H^*(\lambda)$). Its two main reductions target PRG (confidentiality) and discrete logarithm (reliability).

*Purpose of this section.* Establish the two formal reductions relating SOTP-Low to the standard PRG (Gold layer) and DLOG (Iron layer) assumptions.

### PRG reduction for confidentiality

**Intuition.** The Gold layer encrypts $m$ with the pad $G(s)$. If $\mathcal{A}$ distinguishes the proofs of $m_0$ vs $m_1$, it necessarily distinguishes $G(s)$ from a random string, contradicting PRG security.

**Theorem `thm:ann_sotp_low_conf` (SOTP-Low, PRG reduction).** Let $\mathcal{A}$ be a PPT adversary against IND-CONF of SOTP-Low with advantage $\varepsilon$. Then there exists a PPT adversary $\mathcal{B}$ against the PRG $G$ with advantage $\geq \varepsilon/2 - \mathrm{negl}(\lambda)$.

**Proof.**

*Construction of the reducer $\mathcal{B}$.* $\mathcal{B}$ receives a PRG challenge (either $G(s)$ or uniform) and simulates the IND-CONF environment for $\mathcal{A}$. It uses its challenge as masking pad, then observes whether $\mathcal{A}$ guesses $b$ correctly.

**Construction of $\mathcal{B}$.** $\mathcal{B}$ receives a PRG challenge $y \in \lbrace 0,1\rbrace^L$ (either $G(s)$ or uniform) and simulates the IND-CONF game for $\mathcal{A}$ as follows.

1. Generate $(\mathbb{G},q,g,h)$ as in the SOTP-Low Setup
2. When $\mathcal{A}$ submits $(m_0,m_1,c)$, choose $b \xleftarrow{\$} \lbrace 0,1\rbrace$
3. Set $\sigma_1 = m_b \oplus y$ (PRG challenge as pad)
4. Set $\sigma_2 = g^{s'}h^\rho$ for $s',\rho \xleftarrow{\$} \mathbb{Z}_q$ (simulated Iron)
5. Set $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ (deterministic Clay)
6. Return $\sigma = (\sigma_1,\sigma_2,\sigma_3)$ to $\mathcal{A}$

If $\mathcal{A}$ outputs $b'=b$, $\mathcal{B}$ returns 1; otherwise 0.

**Analysis.**

- *Case $y = G(s)$.* $\mathcal{A}$ sees a genuine SOTP-Low proof and wins with probability $1/2 + \varepsilon$. $\mathcal{B}$ returns 1 with probability $1/2+\varepsilon$.
- *Case $y$ uniform.* $\sigma_1 = m_b \oplus U_{|m|}$ is a perfect one-time pad, $\mathcal{A}$ has no information about $b$. $\mathcal{B}$ returns 1 with probability $1/2$.

Hence $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon/2 - \mathrm{negl}(\lambda)$. $\square$

### Discrete-logarithm reduction for reliability

**Intuition.** The Iron layer is $\sigma_2 = g^s h^\rho$. To win BIND-REL, the adversary must find two openings $s_0 \neq s_1$ of the same $\sigma_2$, which implies $g^{s_0}h^{\rho_0} = g^{s_1}h^{\rho_1}$, allowing $\log_g h$ to be computed and solving DLOG.

**Theorem `thm:ann_sotp_low_rel` (SOTP-Low, DLOG reduction).** Assume the seed is sampled in $\mathbb{Z}_q$ and the commitment has the form $\sigma_2 = g^{s}h^{\rho}$ (Algorithm `alg:sotp_low`). Let $\mathcal{A}$ be a PPT adversary winning BIND-REL for SOTP-Low (opening procedure $\mathsf{Open}$) with probability $\varepsilon$. Then there exists a PPT adversary $\mathcal{B}$ solving DLOG in $\mathbb{G}$ with probability $\geq \varepsilon$.

**Proof.**

*Construction of the DLOG reducer.* $\mathcal{B}$ receives a DLOG instance $(g, h)$ and uses the attack of $\mathcal{A}$ against BIND-REL to extract $\log_g h$. The key is that two valid openings of the same proof yield a solvable algebraic equation.

Let a DLOG instance $(g,h)$ be given, with $x = \log_g h$ unknown.

1. $\mathcal{B}$ sets up SOTP-Low with the given $(g,h)$
2. $\mathcal{A}$ outputs $(c,\,\sigma=(\sigma_1,\sigma_2,\sigma_3))$ and two accepted openings $(m_0, s_0, \rho_0)$, $(m_1, s_1, \rho_1)$ with $m_0 \neq m_1$
3. Since $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ and $m_0 \neq m_1$, we have $\mathsf{PRG}(s_0) \neq \mathsf{PRG}(s_1)$, hence $s_0 \neq s_1$ in $\mathbb{Z}_q$
4. The two openings give $g^{s_0}h^{\rho_0} = g^{s_1}h^{\rho_1}$, hence $g^{s_0-s_1} = h^{\rho_1-\rho_0}$; since $s_0 \neq s_1$ and $g$ generates $\mathbb{G}$, we have $\rho_1 \neq \rho_0$
5. Compute
$$x = \bigl(s_0-s_1\bigr)\cdot\bigl(\rho_1-\rho_0\bigr)^{-1} \bmod q$$

$\mathcal{B}$ succeeds whenever $\mathcal{A}$ produces a valid attack, with probability $\varepsilon$. $\square$

Sampling the seed in $\mathbb{Z}_q$ is indispensable at step 3, because with a seed in $\lbrace 0,1\rbrace^\lambda$ committed as $\mathsf{int}(s) \bmod q$, $s$ and $s+q$ would yield the same commitment (comment from the source).

**Practical meaning.** With Curve25519 ($q \approx 2^{252}$, 128-bit security), breaking the reliability of SOTP-Low is as hard as solving the elliptic-curve DLP.

## A.6 JL reduction for SOTP-Base

SOTP-Base operates in the transition regime ($H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log_2\lambda$). Its Clay layer applies a JL projection $\Phi : \mathbb{R}^n \to \mathbb{R}^d$ with $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$.

*Purpose of this section.* Show that the extraction error of the interpreter is directly related to the quality of JL preservation. If the projection distorts distances too much, extraction becomes erroneous.

**Intuition.** If $\Phi$ distorts some distances too much, neighbouring contexts become indistinguishable in the compressed space, causing extraction errors. The reduction below quantifies this relation precisely.

**Theorem `thm:ann_sotp_base_opp` (SOTP-Base, JL sizing).** Let $\mathcal{C} = \lbrace c_1,\ldots,c_N\rbrace$ be the set of embedded contexts, $N = 2^{H(\mathcal{C})}$, and $\delta, \varepsilon' \in (0,1)$. If the projection dimension satisfies

$$d \;\geq\; \frac{8}{\delta^2}\,\ln\left(\frac{N^2}{\varepsilon'}\right) = O\left(\delta^{-2}\bigl(H(\mathcal{C}) + \log(1/\varepsilon')\bigr)\right),$$

then, with probability at least $1 - \varepsilon'$ over the choice of $\Phi$, $\Phi$ preserves all pairwise distances of $\mathcal{C}$ up to a factor $(1 \pm \delta)$.

**Proof.** By the JL lemma, for each pair $(i,j)$,

$$\Pr\left[\,\left|\frac{\|\Phi c_i-\Phi c_j\|^2}{\|c_i-c_j\|^2} - 1\right| > \delta\,\right] \leq 2e^{-d\delta^2/8};$$

a union bound over the $N^2/2$ pairs gives a failure probability at most $N^2 e^{-d\delta^2/8}$, below $\varepsilon'$ as soon as $d \geq (8/\delta^2)\ln(N^2/\varepsilon')$. Distance preservation is a *necessary* condition for a distance-based extraction function to distinguish contexts; it is not sufficient to guarantee extractable information about the verdict. It therefore provides no lower bound on $\mathsf{Opp}$. This dimension, of order $O(H(\mathcal{C}))$, is distinct from the sizing rule $\lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ of the main text, which is a design choice. $\square$

**Interpretation.** SOTP-Base chooses the dimension $d$ guaranteeing distance preservation with the desired probability; the link with verdict extraction remains a design assumption.

## A.7 Reductions for SOTP-High

SOTP-High operates in the context-rich regime ($H(\mathcal{C}) > \lambda/\log_2\lambda$) and relies on Groth16 for its Gold layer. Its Clay layer encodes $h_c = \mathsf{Poseidon}(c)$.

*Purpose of this section.* Show that $\mathsf{Conf}$ and $\mathsf{Rel}_{\mathrm{ver}}$ of SOTP-High inherit the properties of Groth16 (perfect zero-knowledge, knowledge soundness); opposability is not covered by a reduction.

**Theorem `thm:ann_sotp_high` (SOTP-High, security inherited from Groth16).** For the relation $\mathcal{R} = \lbrace((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = g^m h^\rho \wedge \mathsf{Conforme}(m,c) = 1\rbrace$, the following two properties hold.

1. **Confidentiality.** The perfect zero-knowledge of Groth16 and the perfect hiding of $c_m$ give $\mathsf{Conf} = 1$.
2. **Verification reliability.** The knowledge soundness of Groth16 gives $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$.

**Proof.**

**Confidentiality.** By perfect ZK, honest proofs and simulated proofs $\mathcal{S}(\sigma_p, (h_c, c_m))$ have the same distribution. The simulator uses only the public inputs; $h_c$ depends only on $c$ while $c_m$ is uniform in $\mathbb{G}$ whatever $m$. The distribution of $\Sigma = (h_c, \pi, c_m, \mathsf{metadata})$ given $(M = m, C = c)$ therefore does not depend on $m$, hence $\mathsf{Conf} = 1$.

**Verification reliability.** For every PPT $\mathcal{A}$ producing an accepting proof $\pi$, the Groth16 extractor $\mathcal{E}$ (which has the code of $\mathcal{A}$ and uses the q-PKE assumption; it is not the verifier) outputs a witness $(m,c,\rho)$ with $((h_c,c_m),(m,c,\rho)) \in \mathcal{R}$, except with negligible probability. Thus

$$\Pr\left[\mathsf{Verify}=1 \land (m,c,\rho)\notin\mathcal{R}\right] \leq \mathsf{Adv}^{\mathsf{sound}}(\lambda) \leq \mathrm{negl}(\lambda) \;\Rightarrow\; \mathsf{Rel}_{\mathrm{ver}} \geq 1-\mathrm{negl}(\lambda).$$

**Opposability.** No bound is derived here, because $h_c$ and the metadata are functions of the public context, hence $I(V;h_c|C) = 0$; what the proof contributes to the verdict lies in the certified statement $\mathsf{Conforme}(m,c) = 1$ (Remark `rem:heuristique_sotp_high`). $\square$

**Remark (Perfect ZK).** The *perfect* ZK of Groth16 means that even a computationally unbounded adversary cannot distinguish real proofs from simulated ones. It is an unconditional guarantee once the CRS is fixed, a remarkably strong property that makes SOTP-High the most protective variant for high-entropy contexts.

## A.8 Complete statements and game-based CRO product

*Purpose of this section.* Gather the game-based bounds of the three games and derive a lower bound on the CRO product. This bound complements the CRO Trilemma (upper bound) to bracket the achievable product.

### Complete security of SOTP-Low

**Theorem `thm:ann_sotp_low_games` (SOTP-Low, complete game-based bounds).** Under PRG and DLOG in $\mathbb{G}$ of order $q$, for every PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq 2\cdot\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_conf)}$$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_rel)}$$

**Remark `rem:ann_sotp_low_opp_statut` (Opposability of SOTP-Low: no game-based bound).** The initial formulation of this theorem contained a third inequality, $\mathsf{Err}^{\mathsf{EXT\text{-}OPP}} \leq 1 - \Delta/(\alpha H(\mathcal{C}))$, drawn from the fact that the Clay layer $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ determines the verdict. The present formulation does not keep it, since $\sigma_3$ is a function of the public context $C$, hence $I(V;\sigma_3|C) = 0$; it thus contributes nothing to opposability in the sense of Definition `def:interp_admissible`. What SOTP-Low contributes to the verdict goes through the opening $(m,s,\rho)$ supplied to the institution, which falls under the design heuristic (Remark `rem:facteur_limitant_low`), with no associated reduction.

### Summary table of reductions

**Table `tab:ann_g_reductions` — Summary of game-based reductions for the SOTP family**

| Variant | Property | Game | Assumption | Bound |
|---|---|---|---|---|
| SOTP-Low | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq 2\varepsilon_{\mathsf{PRG}} + 1/q$ |
| SOTP-Low | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + 1/q$ |
| SOTP-Low | $\mathsf{Opp}$ | – | – | none (Rem. `rem:ann_sotp_low_opp_statut`) |
| SOTP-Base | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq 2\varepsilon_{\mathsf{PRG}} + \mathrm{negl}$ |
| SOTP-Base | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + \mathrm{negl}$ |
| SOTP-Base | – | – | JL lemma | sizing of $d$ (Th. `thm:ann_sotp_base_opp`) |
| SOTP-High | $\mathsf{Conf}$ | IND-CONF | Groth16 perfect ZK | $\mathsf{Conf} = 1$ |
| SOTP-High | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | Groth16 (q-PKE) | $\geq 1-\mathrm{negl}(\lambda)$ |
| SOTP-High | $\mathsf{Opp}$ | – | – | none (Rem. `rem:heuristique_sotp_high`) |

### Central corollary: game-based CRO product

**Corollary `cor:ann_cro_from_games` (CLO product from the games).** If IND-CONF, BIND-REL and EXT-OPP are won with respective advantages at most $\varepsilon_{\mathsf{ind}}$, $\varepsilon_{\mathsf{bind}}$, $\varepsilon_{\mathsf{ext}}$, then

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq \left(1-2\varepsilon_{\mathsf{ind}}\right) \left(1-\varepsilon_{\mathsf{bind}}\right) \left(1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_product\_games)}$$

where $\mathsf{Conf}_{\mathrm{calc}} = 1 - 2\varepsilon_{\mathsf{ind}}$ denotes computational confidentiality. For $\varepsilon_{\mathsf{ind}},\varepsilon_{\mathsf{bind}}, \varepsilon_{\mathsf{ext}} \ll 1$,

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq 1 - O\left(\varepsilon_{\mathsf{ind}} + \varepsilon_{\mathsf{bind}} + \varepsilon_{\mathsf{ext}}\log_2|\mathcal{V}_\lambda| + h(\varepsilon_{\mathsf{ext}})\right) \qquad \text{(eq:ann\_cro\_approx)}$$

**Proof.** **Term $\mathsf{Conf}_{\mathrm{calc}}$.** Definition, with the IND-CONF game (Remark `rem:ann_ind_conf_link`). **Term $\mathsf{Rel}_{\mathrm{ver}}$.** Remark `rem:ann_bind_rel_link` gives $\mathsf{Rel}_{\mathrm{ver}} \geq 1-\varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$. **Term $\mathsf{Opp}$.** Remark `rem:ann_ext_opp_link` (Fano's inequality, `eq:ann_fano_opp`). The product $(1-a)(1-b)(1-c) \geq 1-a-b-c$ for $a,b,c \in [0,1]$ gives (`eq:ann_cro_approx`). $\square$

**Remark `rem:ann_pas_de_contradiction` (Why this corollary does not contradict the Trilemma).** The CRO Trilemma (Theorem `thm:trilemme_cro_conditionnel`) upper-bounds the product $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp}$, where $\mathsf{Conf}$ is statistical and $\mathsf{Rel}_{\mathrm{rec}}$ measures message reconstruction. The corollary lower-bounds a product of a different nature, involving *computational* confidentiality and *verification* reliability. The two scales are not comparable. A protocol may have $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ close to 1 while obeying the Trilemma, because $\mathsf{Rel}_{\mathrm{rec}}$ then remains of order $2^{-\lambda}$ (Remark `rem:rel_ver`). The assumption that $\varepsilon_{\mathsf{ext}}$ is small is precisely what the Trilemma makes costly when statistical $\mathsf{Conf}$ is close to 1; Remark `rem:activite_delta` indicates which quantity ($\Delta$ or Fano) then limits $\mathsf{Opp}$. The initial formulation of this paragraph announced a "bracketing" of the product by $\Delta/(\alpha\lambda)$ and a constant $c \in [0.45;\,0.85]$; the present formulation distinguishes the two scales.

## A.9 Limitations and scope of the reductions

*Purpose of this section.* List the five limitations of the game-based reductions, namely conditionality, the honest interpreter, the one-way reduction, the $1/q$ term and the relation with Lean4.

1. **Conditionality on computational assumptions.** The security of SOTP-Low is proven under PRG and DLOG. SOTP-High via Groth16 relies on the hardness of pairings on BN254, which is not post-quantum. An extension to quantum-resistant primitives (STARKs, Euclidean lattices) is an open research direction (section `sec:sotp_construction`).
2. **Honest-interpreter model in EXT-OPP.** The game assumes that the interpreter sincerely tries to extract the right verdict. An *adversarial* interpreter (corrupt judge) is not modelled. Game-theoretic extensions (regulator vs audited entity) are identified as a future direction (section `sec:sotp_construction`).
3. **One-way SOTP-Base reduction.** Theorem `thm:ann_sotp_base_opp` only guarantees the implication *sufficient dimension $\Rightarrow$ JL preservation*. It does not guarantee that distance preservation allows the verdict to be extracted, because that depends on the function $f_\Delta$ chosen by the institution, whose existence and efficient computability are not established.
4. **$1/q$ term in the SOTP-Low bounds.** Equations (`eq:ann_sotp_low_conf`) and (`eq:ann_sotp_low_rel`) contain $1/q$ (probability of guessing the exponent). It is negligible in $\lambda$ in the strict sense as soon as the group order satisfies $\log_2 q \geq \lambda$, which holds for the parameters used ($q \approx 2^{252}$, i.e. $1/q \approx 10^{-76}$). The term is kept so that the bounds remain exact for fixed $\lambda$.
5. **Relation with the Lean4 formalisation (Annex `chap:annexe_lean4`).** The two annexes complement each other as follows.
   - **Lean4 (Annex `chap:annexe_lean4`)** mechanically certifies the algebraic derivation of the bound $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp} \leq \Delta/\lambda + K/\lambda^2 + \varepsilon(\lambda)$ (Theorem `thm:conditional_CRO_trilemma`), taking Fano and Pinsker as properties of each instance and bounded extraction as an assumption
   - **Annex `chap:annexe_gamebased` (here)** establishes the cryptographic properties of the SOTP family (computational confidentiality, verification reliability) under PRG, DLOG and Groth16; it does not instantiate the assumptions of the Trilemma, which concern statistical $\mathsf{Conf}$ and $\mathsf{Rel}_{\mathrm{rec}}$

   The two levels are thus complementary without composing into a single proof: the *formal* level certifies the logic of the derivation of the Trilemma, while the *game-based* level justifies the cryptographic guarantees of the constructions.

## Transcription notes

- In this annex, $d$ denotes the output dimension of the projection; in Algorithm `alg:sotp_base`, the output dimension is written $k$ and $d$ is the embedding dimension (note T4 of the specification).
