> **Status: PROPOSAL. construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Annex A (`chap:annexe_gamebased`), file [gamebased_source_fr.tex](gamebased_source_fr.tex) (French)

# Game-based security and formal reductions for the SOTP family

*Version française : [gamebased_fr.md](gamebased_fr.md)*

English Markdown rendering of Annex A of the thesis, in its final version. Statements, games, reductions and proofs are translated without any change of substance. The pedagogical margin comments of the source (macros `\cmt` and `\cmtFormule`) are omitted; they appear in [gamebased_source_fr.tex](gamebased_source_fr.tex). No English `.tex` version is provided: this Markdown file is the English reference. Internal cross-references are given by their LaTeX label and references by their key. The algorithms are specified in [../specification/sotp_specification_en.md](../specification/sotp_specification_en.md).

## Introduction

The CLO framework defines $\mathsf{Conf}$, $\mathsf{Rel}$ and $\mathsf{Opp}$ in information-theoretic terms, namely conditional entropies, mutual information and total variation distance [MINKA2026CLO]. This approach yields general results (Contextual Bottleneck Theorem, Conditional CRO Trilemma), but does not directly state *what a computationally bounded adversary can or cannot do*. In computational cryptography, security is classically expressed by *games* between a challenger and a probabilistic polynomial-time (PPT) adversary.

*Why this annex.* The CLO framework reasons in bits and entropies, whereas classical cryptography reasons in games and adversarial advantages. This annex builds the bridge between the two. It translates each CLO metric into a cryptographic game, then relates each game to a standard hardness assumption (PRG, DLOG, JL, Groth16).

This annex establishes the **formal bridge** between the two worlds in three steps.

1. Define cryptographic games (*IND-CONF*, *BIND-REL*, *EXT-OPP*) that operationally capture $\mathsf{Conf}$ (in its computational version), $\mathsf{Rel}_{\mathrm{ver}}$ and $\mathsf{Opp}$
2. Prove formal *reductions* establishing that, if a PPT adversary wins one of these games, it solves a problem assumed to be hard (PRG, discrete logarithm, JL, Groth16)
3. Establish a **game-based lower bound on the CLO product** (Corollary `cor:ann_cro_from_games`), on the operational scale (computational confidentiality, verification reliability), which is not directly comparable with the Trilemma (Remark `rem:ann_pas_de_contradiction`)

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
| [A.9](#a9-mechanisation-in-a-reduced-setting) | Mechanisation in a reduced setting | $\mathsf{Conf}_{\mathrm{calc}}$, $\mathsf{Rel}_{\mathrm{ver}}$ | PRG, DLOG |
| [A.10](#a10-limitations-and-scope-of-the-reductions) | Limitations and scope | – | – |

---

## A.1 Cryptographic primitives and preliminary definitions

*Purpose of this section.* Recall the four cryptographic primitives used in the SOTP family, namely the PRG (Gold layer), the Pedersen commitment (Iron layer), the Groth16 zk-SNARK (SOTP-High) and the Johnson-Lindenstrauss transform (SOTP-Base), together with two theoretical tools, Fano's inequality and the DPI.

### Pseudo-random generator (PRG)

**Intuition.** A PRG takes a short seed $s \in \lbrace 0,1\rbrace^\lambda$ and produces a long sequence $G(s) \in \lbrace 0,1\rbrace^{L(\lambda)}$, $L > \lambda$, indistinguishable from a truly random sequence. It underlies the Gold layer of SOTP-Low, in which the pad $G(s)$ masks the message so that, without $s$, no PPT adversary can recover $m$ from $m \oplus G(s)$.

**Definition `def:ann_prg` (PRG security [GoldreichKrawczyk99]).** Let $\mathcal{S}_\lambda$ be a finite seed set, for instance $\lbrace 0,1\rbrace^\lambda$ or $\mathbb{Z}_q$. A polynomial-time computable function $G : \mathcal{S}_\lambda \to \lbrace 0,1\rbrace^{L(\lambda)}$ is secure if, for every PPT adversary $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{A}}(\lambda) = \left| \Pr_{s \leftarrow \mathcal{S}_\lambda}\big[\mathcal{A}(G(s)) = 1\big] - \Pr_{y \leftarrow \lbrace 0,1\rbrace^{L(\lambda)}}\big[\mathcal{A}(y) = 1\big] \right| \leq \mathrm{negl}(\lambda)$$

**Seed distribution.** SOTP-Low draws its seed uniformly in $\mathbb{Z}_q$ (Algorithm `alg:sotp_low`), a condition required by the discrete-logarithm reduction. The reductions of this annex therefore use $\mathcal{S}_\lambda = \mathbb{Z}_q$. For IND-CONF, the advantage is $|\Pr[b' = b] - 1/2|$; for the PRG, it is the difference of the two probabilities above.

**Seed longer than the output.** The definition does not require $G$ to stretch the seed. When $L(\lambda) > \log_2|\mathcal{S}_\lambda|$, $G$ is a pseudorandom generator in the usual sense and its security is a computational assumption. When the seed is longer than the output, $G$ is a mask-derivation function and the condition can be met in the statistical sense. This is the case of SOTP-Low, where $s \in \mathbb{Z}_q$ with $|q| \geq 2\lambda$ and $L(\lambda) = \lambda$. The truncation $s \bmod 2^\lambda$ is then at statistical distance at most $2^{-\lambda-1}$ from uniform (Remark `rem:masque_troncature`).

**Practical implementations.** For a longer message, SOTP-Low derives a key from the seed and then uses ChaCha20 or AES-CTR, two standardised PRGs meeting this definition.

### Pedersen commitment

**Intuition.** The Pedersen commitment lets a prover "commit" to $m$ without revealing it (*perfect hiding*), while being unable to change its mind (*computational binding*). The construction $\mathsf{Com}(m, r) = g^m h^r$ uses the algebra of cyclic groups, so that any commitment collision would allow computing $\log_g h$, solving the discrete logarithm.

**Definition `def:ann_pedersen` (Pedersen commitment [Pedersen91]).** Let $\mathbb{G}$ be a cyclic group of prime order $q$, $g, h \in \mathbb{G}$ two generators such that $\log_g h$ is unknown.

- $\mathsf{Com}(m, r) = g^m h^r \in \mathbb{G}$, $m,r \in \mathbb{Z}_q$ (group operation)
- $\mathsf{Open}(\sigma_2, m, r)$ accepts if $\sigma_2 = g^m h^r$

**Perfect Hiding.** For all $m_0, m_1$, the commitments $\mathsf{Com}(m_0, r_0)$ and $\mathsf{Com}(m_1, r_1)$ are identically distributed for $r_0, r_1 \xleftarrow{\$} \mathbb{Z}_q$.

**Computational Binding.** No PPT adversary can find $(m_0, r_0, m_1, r_1)$ with $m_0 \neq m_1$ such that $g^{m_0} h^{r_0} = g^{m_1} h^{r_1}$ in $\mathbb{G}$.

**Role in SOTP.** The Iron layer of every SOTP variant is a Pedersen commitment (to the seed $s \in \mathbb{Z}_q$ for SOTP-Low and SOTP-Base, to $m$ for SOTP-High). It guarantees verification reliability $\mathsf{Rel}_{\mathrm{ver}}$, since a proof cannot be "opened" to two distinct messages.

### Groth16 zk-SNARK

**Intuition.** A zk-SNARK for a relation $\mathcal{R}$ allows proving knowledge of a witness $w$ such that $(x,w) \in \mathcal{R}$, without revealing $w$, in a constant-size proof. A Groth16 proof consists of three group elements, that is 128 bytes (compressed points) on BN254 [BarretoNaehrig2006]; it is verified with $O(1)$ pairings.

**Definition `def:ann_groth16` (Groth16 zk-SNARK [Groth16]).** $(\mathsf{Setup}, \mathsf{Prove}, \mathsf{Verify})$ satisfies the following properties.

**Perfect completeness.** $\Pr[\mathsf{Verify}(\sigma_v,x,\pi)=1 \mid (x,w)\in\mathcal{R}] = 1$

**Knowledge soundness.** For every PPT $\mathcal{A}$, there exists an extractor $\mathcal{E}$ such that

$$\Pr\left[ \mathsf{Verify}(\sigma_v,x,\pi)=1 \land (x,w)\notin\mathcal{R} \;:\; (x,\pi)\leftarrow\mathcal{A}(\sigma_p),\ w\leftarrow\mathcal{E}(\sigma_p) \right] \leq \mathrm{negl}(\lambda)$$

**Perfect zero-knowledge.** There exists a simulator $\mathcal{S}$ such that for every $(x,w)\in\mathcal{R}$,

$$\lbrace\pi :  \pi \leftarrow \mathsf{Prove}(\sigma_p,x,w)\rbrace \equiv \lbrace\pi :  \pi \leftarrow \mathcal{S}(\sigma_p,x)\rbrace \quad\text{(identical distributions)}$$

**Reading for SOTP-High.** *Perfect* zero-knowledge, together with the perfect hiding of the commitment $c_m$, implies that $(\pi, c_m)$ is independent of $m$ given $c$, hence $\mathsf{Conf} = 1$ in the statistical sense. Knowledge soundness implies verification reliability $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$; it says nothing about reconstruction reliability, which equals $2^{-\lambda}$ when $\mathsf{Conf} = 1$ (Remark `rem:rel_ver`).

### Johnson-Lindenstrauss (JL) transform

**Intuition.** The JL transform projects $N$ points of $\mathbb{R}^d$ into $\mathbb{R}^k$ ($k \ll d$) while approximately preserving all pairwise distances. In SOTP-Base, the context embeddings $\mathsf{embed}(c) \in \mathbb{R}^d$ are projected to $\Phi\,\mathsf{embed}(c) \in \mathbb{R}^k$, which preserves their proximity.

**Definition `def:ann_jl` (JL transform [JohnsonLindenstrauss84, DasguptaGupta03]).** For $0 < \varepsilon < 1$, $N > 0$, $S \subset \mathbb{R}^d$ with $|S| = N$, there exists $\Phi : \mathbb{R}^d \to \mathbb{R}^k$ with $k = O(\varepsilon^{-2} \log N)$ such that, for all $x,y \in S$,

$$(1-\varepsilon)\|x-y\|^2 \leq \|\Phi x-\Phi y\|^2 \leq (1+\varepsilon)\|x-y\|^2$$

**Design rule for SOTP-Base.** The embedding dimension chosen by design is

$$d = \left\lceil \frac{4\Delta H(\mathcal{C})}{\varepsilon^2} \right\rceil \qquad \text{(eq:ann\_jl\_dim)}$$

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

**Intuition.** The game captures *non-equivocation*: an adversary must not be able to produce a proof $\sigma$ that can be opened to two distinct messages $m_0 \neq m_1$. Unlike IND-CONF, the adversary freely chooses $(c, \sigma, o_0, o_1)$, modelling an agent who deliberately forges an ambiguous proof.

**Definition `def:ann_bind_rel` (BIND-REL game).** For a protocol $\mathcal{P}$ with $\mathsf{Open}$ and an adversary $\mathcal{A}$, the game runs as follows.

1. $\mathcal{A}$ receives $pp \leftarrow \mathsf{Setup}(1^\lambda)$
2. $\mathcal{A}$ outputs $(c, \sigma, o_0, o_1)$, where each opening $o_i = (m_i, s_i, \rho_i)$
3. Compute $m_i = \mathsf{Open}(pp, \sigma, o_i)$ for $i \in \lbrace 0,1\rbrace$
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
3. The interpreter receives $(\sigma,c)$, may consult its institutional resources $K$ (Definition `def:interp_admissible`) and outputs $v \leftarrow \mathsf{Interpret}(pp,\sigma,c,\Delta)$
4. Let $v^*$ be the reference verdict, a realisation of the variable $V$ (which may depend on the message, the context and institutional resources, Definition `def:interp_admissible`)
5. The interpreter *wins* if $v = v^*$

$$\mathsf{Err}^{\mathsf{EXT\text{-}OPP}}_{\mathsf{Interpret},\mathcal{P},\mathcal{D}_C}(\lambda) = \Pr\left[ \mathsf{Interpret} \text{ loses in } \mathsf{Exp}^{\mathsf{EXT\text{-}OPP}}\right]$$

**Why is $\mathcal{D}_C$ fixed in advance?** Opposability depends on the institutional domain. A protocol highly opposable in a simple contractual context may be poorly opposable in a complex regulatory context. Fixing $\mathcal{D}_C$ parameterises the game by the domain.

### Link with $\mathsf{Opp}$ through Fano

**Remark `rem:ann_ext_opp_link` (EXT-OPP $\leftrightarrow$ $\mathsf{Opp}$ bridge).** By Fano (Lemma `lem:ann_g_fano`) applied to the estimation of $V$ from $(\Sigma,C,K)$, then by the chain rule $H(V|\Sigma,C) = H(V|\Sigma,C,K) + I(V;K|\Sigma,C)$ (Remark `rem:jeu_ext_opp_link`),

$$\mathsf{Opp} = 1 - \frac{H(V|\Sigma,C)}{H(V|C)} \geq 1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1) + I(V;K|\Sigma,C)}{H(V|C)} \qquad \text{(eq:ann\_fano\_opp)}$$

where $\varepsilon_{\mathsf{ext}} = \mathsf{Err}^{\mathsf{EXT\text{-}OPP}}$ and $h(\cdot)$ is the binary entropy. The term $I(V;K|\Sigma,C)$ measures what the interpreter draws from its own resources $K$ rather than from the proof; it vanishes when the interpreter reads only $(\Sigma,C)$. An interpreter with low extraction error, which owes little to its own resources, implies high opposability.

## A.5 Formal reductions for SOTP-Low

SOTP-Low serves below the threshold $H^\sharp$ when the institution needs the exact context. Its two main reductions target PRG (confidentiality) and discrete logarithm (reliability).

*Purpose of this section.* Establish the two formal reductions relating SOTP-Low to the standard PRG (Gold layer) and DLOG (Iron layer) assumptions.

### PRG reduction for confidentiality

**Intuition.** The Gold layer encrypts $m$ with the pad $G(s)$. If $\mathcal{A}$ distinguishes the proofs of $m_0$ vs $m_1$, it necessarily distinguishes $G(s)$ from a random string, contradicting PRG security.

**Theorem `thm:ann_sotp_low_conf` (SOTP-Low, PRG reduction).** Let $\mathcal{A}$ be a PPT adversary against IND-CONF of SOTP-Low with advantage $\varepsilon$. Then there exists a PPT adversary $\mathcal{B}$ against the PRG $G$ with the same running time as $\mathcal{A}$ up to a polynomial term, such that $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon - 1/q$.

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

- *Case $y = G(s)$.* When $h \neq 1$, $h$ generates $\mathbb{G}$ and $\sigma_2 = g^{s'}h^\rho$ is uniform and independent of $s$, like $g^{s}h^\rho$ in the real game. $\mathcal{A}$ then sees exactly a genuine SOTP-Low proof. The event $h = 1$ has probability $1/q$. $\mathcal{B}$ therefore returns 1 with a probability that differs from $\Pr[b' = b] = 1/2 \pm \varepsilon$ by at most $1/q$.
- *Case $y$ uniform.* $\sigma_1 = m_b \oplus U_{|m|}$ is a perfect one-time pad, $\mathcal{A}$ has no information about $b$. $\mathcal{B}$ returns 1 with probability $1/2$.

Hence $\mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) \geq \varepsilon - 1/q$. $\square$

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

SOTP-Base serves below the threshold $H^\sharp$ when the institution needs proximity between contexts. Its Clay layer applies a JL projection $\Phi : \mathbb{R}^d \to \mathbb{R}^k$, where $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ is the embedding dimension chosen by design and $k$ the target dimension (Algorithm `alg:sotp_base`).

*Purpose of this section.* Show that the extraction error of the interpreter is directly related to the quality of JL preservation. If the projection distorts distances too much, extraction becomes erroneous.

**Intuition.** If $\Phi$ distorts some distances too much, neighbouring contexts become indistinguishable in the target space, causing extraction errors. The reduction below quantifies this relation precisely.

**Theorem `thm:ann_sotp_base_opp` (SOTP-Base, JL sizing).** Let $\mathcal{C} = \lbrace c_1,\ldots,c_N\rbrace$ be the set of embedded contexts, $N = 2^{H(\mathcal{C})}$, and $\delta, \varepsilon' \in (0,1)$. If the target dimension $k$ satisfies

$$k \;\geq\; \frac{12}{\delta^2}\,\ln\left(\frac{N^2}{\varepsilon'}\right) = O\left(\delta^{-2}\bigl(H(\mathcal{C}) + \log(1/\varepsilon')\bigr)\right),$$

then, with probability at least $1 - \varepsilon'$ over the choice of $\Phi$, $\Phi$ preserves all pairwise distances of $\mathcal{C}$ up to a factor $(1 \pm \delta)$.

**Proof.** By the JL lemma, for each pair $(i,j)$,

$$\Pr\left[\,\left|\frac{\|\Phi c_i-\Phi c_j\|^2}{\|c_i-c_j\|^2} - 1\right| > \delta\,\right] \leq 2e^{-k\delta^2/12} \quad \text{for } 0 < \delta < 1$$

(proof of Lemma `lem:johnson_lindenstrauss`). A union bound over the $N^2/2$ pairs gives a failure probability of at most $N^2 e^{-k\delta^2/12}$. This probability is below $\varepsilon'$ as soon as $k \geq (12/\delta^2)\ln(N^2/\varepsilon')$. Distance preservation is a *necessary* condition for a distance-based extraction function to distinguish contexts; it is not sufficient to guarantee extractable information about the verdict. It therefore provides no lower bound on $\mathsf{Opp}$. This dimension, of order $O(H(\mathcal{C}))$, is distinct from the sizing rule $\lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ of the main text, which is a design choice. $\square$

**Interpretation.** SOTP-Base chooses the target dimension $k$ guaranteeing distance preservation with the desired probability; the link with verdict extraction remains a design assumption.

**Corollary `cor:ann_sotp_base_reductions` (Reductions for SOTP-Base).** Under PRG and DLOG in $\mathbb{G}$ of order $q$, for every PPT $\mathcal{A}$, $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Base}}(\lambda) \leq \mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + 1/q$ and $\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Base}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda)$.

**Proof.** SOTP-Base shares the Gold and Iron layers with SOTP-Low (Algorithm `alg:sotp_base`), and its Clay layer, the JL projection of the context, is a public function of $c$ and of the public draw of $\Phi$. The reductions of Theorems `thm:ann_sotp_low_conf` and `thm:ann_sotp_low_rel` compute this layer from $c$. Their simulations and analyses are unchanged. $\square$

## A.7 Reductions for SOTP-High

SOTP-High serves beyond the threshold $H^\sharp$ and relies on Groth16 for its Gold layer. Its Clay layer encodes $h_c = \mathsf{Poseidon}(c)$.

*Purpose of this section.* Show that $\mathsf{Conf}$ and $\mathsf{Rel}_{\mathrm{ver}}$ of SOTP-High inherit the properties of Groth16 (perfect zero-knowledge, knowledge soundness); opposability is not covered by a reduction.

**Theorem `thm:ann_sotp_high` (SOTP-High, security inherited from Groth16).** For the relation $\mathcal{R} = \lbrace((h_c, c_m), (m, c, \rho)) : h_c = \mathsf{Poseidon}(c) \wedge c_m = g^m h^\rho \wedge \mathsf{Conforme}(m,c) = 1\rbrace$, the following two properties hold.

1. **Confidentiality.** The perfect zero-knowledge of Groth16 and the perfect hiding of $c_m$ give $\mathsf{Conf} = 1$.
2. **Verification reliability.** The knowledge soundness of Groth16, the collision resistance of $\mathsf{Poseidon}$ and the binding property of the Pedersen commitment under DLOG give $\mathsf{Rel}_{\mathrm{ver}} \geq 1 - \mathrm{negl}(\lambda)$.

**Proof.**

**Confidentiality.** By perfect ZK, honest proofs and simulated proofs $\mathcal{S}(\sigma_p, (h_c, c_m))$ have the same distribution. The simulator uses only the public inputs; $h_c$ depends only on $c$ while $c_m$ is uniform in $\mathbb{G}$ whatever $m$. The distribution of $\Sigma = (h_c, \pi, c_m, \mathsf{metadata})$ given $(M = m, C = c)$ therefore does not depend on $m$, hence $\mathsf{Conf} = 1$.

**Verification reliability.** For every PPT $\mathcal{A}$ producing an accepting proof $\pi$, the Groth16 extractor $\mathcal{E}$ whose existence is proved in the generic group model [Groth16] and in the algebraic group model under the q-DLog assumption [FKL18] (it is not the verifier) outputs a witness $(m,c,\rho)$ with $((h_c,c_m),(m,c,\rho)) \in \mathcal{R}$, except with negligible probability. Thus

$$\Pr\left[\mathsf{Verify}=1 \land (m,c,\rho)\notin\mathcal{R}\right] \leq \mathsf{Adv}^{\mathsf{sound}}(\lambda) \leq \mathrm{negl}(\lambda) \;\Rightarrow\; \mathsf{Rel}_{\mathrm{ver}} \geq 1-\mathrm{negl}(\lambda).$$

**Opposability.** No bound is established here, because $h_c$ and the metadata are functions of the public context, hence $I(V;h_c|C) = 0$; what the proof contributes to the verdict lies in the certified statement $\mathsf{Conforme}(m,c) = 1$ (Remark `rem:heuristique_sotp_high`). $\square$

**Remark (Perfect ZK).** The *perfect* ZK of Groth16 means that even a computationally unbounded adversary cannot distinguish real proofs from simulated ones. It is an unconditional guarantee once the CRS is fixed, a remarkably strong property that makes SOTP-High the most protective variant for high-entropy contexts.

## A.8 Complete statements and game-based CRO product

*Purpose of this section.* Gather the game-based bounds of the three games and derive a lower bound on the CRO product. This bound complements the CRO Trilemma (upper bound) to bracket the achievable product.

### Complete security of SOTP-Low

**Theorem `thm:ann_sotp_low_games` (SOTP-Low, complete game-based bounds).** Under PRG and DLOG in $\mathbb{G}$ of order $q$, for every PPT $\mathcal{A}$,

$$\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{PRG}}_{\mathcal{B}}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_conf)}$$

$$\mathsf{Win}^{\mathsf{BIND\text{-}REL}}_{\mathcal{A},\mathsf{SOTP\text{-}Low}}(\lambda) \leq \mathsf{Adv}^{\mathsf{DLOG}}_{\mathcal{B}'}(\lambda) + \frac{1}{q} \qquad \text{(eq:ann\_sotp\_low\_rel)}$$

**Remark `rem:ann_sotp_low_opp_statut` (Opposability of SOTP-Low: no game-based bound).** The initial formulation of this theorem contained a third inequality, $\mathsf{Err}^{\mathsf{EXT\text{-}OPP}} \leq 1 - \Delta/(\alpha H(\mathcal{C}))$, drawn from the fact that the Clay layer $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ determines the verdict. The present formulation does not keep it, since $\sigma_3$ is a function of the public context $C$, hence $I(V;\sigma_3|C) = 0$; it thus contributes nothing to opposability in the sense of Definition `def:interp_admissible`. What SOTP-Low contributes to the verdict goes through the opening $(m,s,\rho)$ supplied to the institution, which falls under the design heuristic (Remark `rem:facteur_limitant_low`), with no associated reduction.

### Summary table of reductions

**Table `tab:ann_g_reductions` — Summary of game-based reductions for the SOTP family**

| Variant | Property | Game | Assumption | Bound |
|---|---|---|---|---|
| SOTP-Low | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq \varepsilon_{\mathsf{PRG}} + 1/q$ |
| SOTP-Low | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}} + 1/q$ |
| SOTP-Low | $\mathsf{Opp}$ | – | – | none (Rem. `rem:ann_sotp_low_opp_statut`) |
| SOTP-Base | $\mathsf{Conf}_{\mathrm{calc}}$ | IND-CONF | PRG | $\mathsf{Adv} \leq \varepsilon_{\mathsf{PRG}} + 1/q$ (Cor. `cor:ann_sotp_base_reductions`) |
| SOTP-Base | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | DLOG | $\mathsf{Win} \leq \varepsilon_{\mathsf{DLOG}}$ (Cor. `cor:ann_sotp_base_reductions`) |
| SOTP-Base | – | – | JL lemma | sizing of $k$ (Th. `thm:ann_sotp_base_opp`) |
| SOTP-High | $\mathsf{Conf}$ | IND-CONF | Groth16 perfect ZK | $\mathsf{Conf} = 1$ |
| SOTP-High | $\mathsf{Rel}_{\mathrm{ver}}$ | BIND-REL | Groth16 (GGM or AGM), DLOG | $\geq 1-\mathrm{negl}(\lambda)$ |
| SOTP-High | $\mathsf{Opp}$ | – | – | none (Rem. `rem:heuristique_sotp_high`) |

### Central corollary: game-based CRO product

**Corollary `cor:ann_cro_from_games` (CLO product from the games).** If IND-CONF, BIND-REL and EXT-OPP are won with respective advantages at most $\varepsilon_{\mathsf{ind}}$, $\varepsilon_{\mathsf{bind}}$, $\varepsilon_{\mathsf{ext}}$, then

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq \left(1-2\varepsilon_{\mathsf{ind}}\right) \left(1-\varepsilon_{\mathsf{bind}}\right) \left(1 - \frac{h(\varepsilon_{\mathsf{ext}}) + \varepsilon_{\mathsf{ext}}\log_2(|\mathcal{V}_\lambda|-1) + I(V;K|\Sigma,C)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_product\_games)}$$

where $\mathsf{Conf}_{\mathrm{calc}} = 1 - 2\varepsilon_{\mathsf{ind}}$ denotes computational confidentiality. For $\varepsilon_{\mathsf{ind}},\varepsilon_{\mathsf{bind}}, \varepsilon_{\mathsf{ext}} \ll 1$,

$$\mathsf{Conf}_{\mathrm{calc}} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \geq 1 - O\left(\varepsilon_{\mathsf{ind}} + \varepsilon_{\mathsf{bind}} + \varepsilon_{\mathsf{ext}}\log_2|\mathcal{V}_\lambda| + h(\varepsilon_{\mathsf{ext}}) + \frac{I(V;K|\Sigma,C)}{H(V|C)}\right) \qquad \text{(eq:ann\_cro\_approx)}$$

**Proof.** **Term $\mathsf{Conf}_{\mathrm{calc}}$.** Definition, with the IND-CONF game (Remark `rem:ann_ind_conf_link`). **Term $\mathsf{Rel}_{\mathrm{ver}}$.** Remark `rem:ann_bind_rel_link` gives $\mathsf{Rel}_{\mathrm{ver}} \geq 1-\varepsilon_{\mathsf{bind}} - \mathrm{negl}(\lambda)$. **Term $\mathsf{Opp}$.** Remark `rem:ann_ext_opp_link` (Fano's inequality, `eq:ann_fano_opp`). The product $(1-a)(1-b)(1-c) \geq 1-a-b-c$ for $a,b,c \in [0,1]$ gives (`eq:ann_cro_approx`). $\square$

**Remark `rem:ann_pas_de_contradiction` (Why this corollary does not contradict the Trilemma).** The CRO Trilemma (Theorem `thm:trilemme_cro_conditionnel`) upper-bounds the product $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp}$, where $\mathsf{Conf}$ is statistical and $\mathsf{Rel}_{\mathrm{rec}}$ measures message reconstruction. The corollary lower-bounds a product of a different nature, involving *computational* confidentiality and *verification* reliability. The two scales are not comparable. A protocol may have $\mathsf{Conf}_{\mathrm{calc}}\cdot\mathsf{Rel}_{\mathrm{ver}}\cdot\mathsf{Opp}$ close to 1 while obeying the Trilemma, because $\mathsf{Rel}_{\mathrm{rec}}$ then remains of order $2^{-\lambda}$ (Remark `rem:rel_ver`). The assumption that $\varepsilon_{\mathsf{ext}}$ is small is precisely what the Trilemma makes costly when statistical $\mathsf{Conf}$ is close to 1; Remark `rem:activite_delta` indicates which quantity ($\Delta$ or Fano) then limits $\mathsf{Opp}$. The initial formulation of this paragraph announced a "bracketing" of the product by $\Delta/(\alpha\lambda)$ and a constant $c \in [0.45;\,0.85]$; the present formulation distinguishes the two scales.

## A.9 Mechanisation in a reduced setting

This section tests the mechanisation of the game-based proofs of this annex on a reduced version of SOTP-Low. It aims to show that the approach is feasible; the full mechanisation of the three variants will follow. The file [lean/GameBasedSOTP.lean](lean/GameBasedSOTP.lean) uses Mathlib only. It was checked on 22 November 2026 on <https://live.lean-lang.org> and locally with Lean v4.35.0 and Mathlib v4.35.0, with no error and no warning. Its six `#print axioms` show only `propext`, `Classical.choice` and `Quot.sound`.

**Table `tab:ann_g_mecanisation` — Game-based theorems mechanised in a reduced setting**

| Lean theorem | Statement | Annex statement |
|---|---|---|
| `otp_uniform` | the law of $m + y$, $y$ uniform, does not depend on $m$ | one-time pad in the proof of Theorem `thm:ann_sotp_low_conf` |
| `ind_conf_eq_prg` | $\mathsf{Adv}^{\mathsf{IND\text{-}CONF}}(\mathcal{A}) = \mathsf{Adv}^{\mathsf{PRG}}(\mathcal{B})$ | Theorem `thm:ann_sotp_low_conf` (Gold layer) |
| `ind_conf_perfect_otp` | zero advantage with a uniform pad | uniform case of the same proof |
| `pedersen_extract` | $x = (s_0 - s_1)/(\rho_1 - \rho_0)$ | steps 3 to 5 of the proof of Theorem `thm:ann_sotp_low_rel` |
| `bind_rel_gives_dlog` | a BIND-REL win yields the discrete logarithm | Theorem `thm:ann_sotp_low_rel` |
| `win_bind_le_dlog` | $\mathsf{Win}^{\mathsf{BIND\text{-}REL}}(\mathcal{A}) \leq \mathsf{Adv}^{\mathsf{DLOG}}(\mathcal{B})$ | bound (`eq:ann_sotp_low_rel`) |

**What "reduced setting" means.** Probabilities are averages over finite sets with the uniform law. Adversaries are functions whose own randomness is absorbed into their description, which suffices for both reductions. The seed is drawn in an arbitrary finite set (Definition `def:ann_prg`), $\mathbb{Z}_q$ included. The group is any group generated by an element of prime order $q$. The Iron layer is not part of the confidentiality game, its perfect hiding corresponding to the term $1/q$, and the Clay layer is not modelled. The PRG and DLOG assumptions are not stated as axioms: the theorems relate the adversary's advantage to that of the reduction built from it.

**What remains to be mechanised.** Probabilistic adversaries with oracles, the term $1/q$, SOTP-Base, SOTP-High, the EXT-OPP game and Corollary `cor:ann_cro_from_games`. These steps require a framework of games with oracles, such as VCVio in Lean 4 [VCVio2026], and belong to the article in preparation.

The source code is reproduced below (listing `lst:gamebased_lean`).

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

## A.10 Limitations and scope of the reductions

*Purpose of this section.* List the five limitations of the game-based reductions, namely conditionality, the honest interpreter, the one-way reduction, the $1/q$ term and the relation with Lean4.

1. **Conditionality on computational assumptions.** The security of SOTP-Low is proven under PRG and DLOG. SOTP-High via Groth16 relies on the hardness of pairings on BN254, which is not post-quantum. An extension to quantum-resistant primitives (STARKs, Euclidean lattices) is an open research direction (section `sec:sotp_construction`).
2. **Honest-interpreter model in EXT-OPP.** The game assumes that the interpreter sincerely tries to extract the right verdict. An *adversarial* interpreter (corrupt judge) is not modelled. Game-theoretic extensions (regulator vs audited entity) are identified as a future direction (section `sec:sotp_construction`).
3. **One-way SOTP-Base reduction.** Theorem `thm:ann_sotp_base_opp` only guarantees the implication *sufficient dimension $\Rightarrow$ JL preservation*. It does not guarantee that distance preservation allows the verdict to be extracted, because that depends on the function $f_\Delta$ chosen by the institution, whose existence and efficient computability are not established.
4. **$1/q$ term in the SOTP-Low bounds.** Equations (`eq:ann_sotp_low_conf`) and (`eq:ann_sotp_low_rel`) contain $1/q$. It is negligible in $\lambda$ in the strict sense as soon as the group order satisfies $\log_2 q \geq \lambda$, which holds for the parameters used ($q \approx 2^{252}$, i.e. $1/q \approx 10^{-76}$). The term is kept so that the bounds remain exact for fixed $\lambda$. In the confidentiality bound, it corresponds to the event $h = 1$, where the commitment is no longer hiding. In the binding bound, it is added only for symmetry.
5. **Relation with the Lean4 formalisation (Annex `chap:annexe_lean4`).** The two annexes complement each other as follows.
   - **Lean4 (Annex `chap:annexe_lean4`)** mechanically certifies the algebraic derivation of the bound $\mathsf{Conf}\cdot\mathsf{Rel}_{\mathrm{rec}}\cdot\mathsf{Opp} \leq \Delta/\lambda + K/\lambda^2 + \varepsilon(\lambda)$ (Theorem `thm:conditional_CRO_trilemma`), taking Fano and Pinsker as properties of each instance and bounded extraction as an assumption
   - **Annex `chap:annexe_gamebased` (here)** establishes the cryptographic properties of the SOTP family (computational confidentiality, verification reliability) under PRG, DLOG and Groth16; it does not instantiate the assumptions of the Trilemma, which concern statistical $\mathsf{Conf}$ and $\mathsf{Rel}_{\mathrm{rec}}$

   The two levels are thus complementary without composing into a single proof: the *formal* level certifies the logic of the derivation of the Trilemma, while the *game-based* level justifies the cryptographic guarantees of the constructions. Section A.9 starts mechanising this second level, in a reduced setting.

## Transcription notes

- The dimension notation is now that of Algorithm `alg:sotp_base`. The embedding dimension is $d$ and the target dimension of the projection is $k$, in the annex as in the main text (note T4 of the specification, resolved).
