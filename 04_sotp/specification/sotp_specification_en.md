> **Status: PROPOSAL — construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Chapter 3, §3.1 (introduction), §3.2 (`sec:sotp_base`) and §3.3 (`sec:sotp_construction`)

# Specification of the SOTP family

*Version française : [sotp_specification_fr.md](sotp_specification_fr.md)*

This document is a faithful rendering of the S-OTP and SOTP constructions of the thesis (written in French). Statements (theorem, propositions, remarks, conjecture) and algorithms are translated without any change of substance. Internal cross-references to the thesis are given by their LaTeX label (for example `rem:rel_ver`) and bibliographic references by their key (for example [Pedersen91]). Transcription notes flag the places where the source text is inconsistent or ambiguous; they do not modify any statement.

## Contents

1. [Status of the results](#1-status-of-the-results)
2. [The Gold-Iron-Clay paradigm](#2-the-gold-iron-clay-paradigm)
3. [S-OTP, prototype](#3-s-otp-prototype)
4. [Common architecture of the SOTP family](#4-common-architecture-of-the-sotp-family)
5. [SOTP-Low (scarce-context regime)](#5-sotp-low-scarce-context-regime)
6. [SOTP-Base (transition regime)](#6-sotp-base-transition-regime)
7. [SOTP-High (rich-context regime)](#7-sotp-high-rich-context-regime)
8. [Synthesis and variant selection](#8-synthesis-and-variant-selection)
9. [Universal optimality conjecture and sensitivity analysis](#9-universal-optimality-conjecture-and-sensitivity-analysis)
10. [Quantum extension](#10-quantum-extension)
11. [Transcription notes](#11-transcription-notes)

---

## 1. Status of the results

**Remark `rem:statut_sotp` (Status of the results of this chapter).** The S-OTP and SOTP constructions are evaluated on the operational CLO scale, which combines statistical confidentiality, verification reliability $\mathsf{Rel}_{\mathrm{ver}}$ (Remark `rem:rel_ver`) and opposability under explicit interpretation conventions. These metrics are not compared with the bound of Theorem `thm:trilemme_cro_conditionnel`, which concerns $\mathsf{Rel}_{\mathrm{rec}}$ and states that, for every protocol with statistical confidentiality $1-\mathrm{negl}(\lambda)$, $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$. The existence of protocols approaching the refined bound (`eq:trilemme_cro_raffine`) is formulated as a conjecture (Conjecture `conj:optimalite_universelle`). Proof components that depend only on the public context $C$ carry no conditional information, since $I(V; g(C) \mid C) = 0$ for every function $g$. The Clay layer is therefore analysed as a *presentation format* that eases interpretation (lower cognitive cost); it is not a source of information in the sense of $\mathsf{Opp}$. The numerical saturation expressions (factors $0.75$, $0.5$, $0.45$) are design heuristics, not proven lower bounds.

| Statement | Status |
|---|---|
| Computational confidentiality (SOTP-Low, SOTP-Base) | proven under PRG (Propositions `thm:saturation_sotp_low`, `thm:saturation_sotp_base`) |
| $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ (SOTP-Low, SOTP-Base) | proven under DLog |
| Confidentiality and $\mathsf{Rel}_{\mathrm{ver}}$ (SOTP-High) | proven under q-SDH, q-PKE, DLog and an honest ceremony (Proposition `thm:saturation_sotp_high`) |
| JL distance preservation (SOTP-Base) | Johnson-Lindenstrauss lemma, probability $\geq 1-\delta$ |
| Lower bounds $0.75\,\Delta/\lambda$, $0.5\min\{\cdot\}$, $0.45\,\beta\log_2\lambda/\lambda$ | unproven design heuristics |
| Universal optimality of SOTP | conjecture |
| Numerical values (ECDSA, Helios, zk-SNARKs, 296-bit budget) | analytical illustrations, not comparable with CLO products |

## 2. The Gold-Iron-Clay paradigm

Source: §`subsec:gold_iron_clay` and §`subsec:principes_conception`.

With the three metrics defined, a methodology is needed to design protocols that balance them [Shoup01, Damgard87]. The **Gold-Iron-Clay** paradigm structures this design into three functional layers; the name, inspired by medieval metallurgy, reflects the relation between malleability and strength.

| Layer | Property | Means | Question it answers |
|---|---|---|---|
| **Gold** | confidentiality, $\mathsf{Conf} \to 1$ | cryptographic masking of the message through PRG-based one-time pads, semantically secure encryption [GoldwasserMicali84, Bellare97], zero-knowledge proofs [GMR85, BenOr88] | "How can $\sigma$ be made indistinguishable between two messages?" |
| **Iron** | reliability, $\mathsf{Rel}_{\mathrm{ver}} \to 1$ | binding commitments allowing verifiable recovery, Pedersen commitments [Pedersen91, ChaumPedersen92], accumulators [CamenischLysyanskaya02], signatures | "How can we guarantee that $\sigma$ allows $m$ to be recovered with probability $1 - \mathrm{negl}(\lambda)$?" |
| **Clay** | opposability, $\mathsf{Opp} \to \max$ | encoding that preserves the institutional context for information extraction by resource-bounded interpreters [Miller56, Simon82], through deterministic encoding, Johnson-Lindenstrauss compression [JohnsonLindenstrauss84, DasguptaGupta03] or deterministic hashing | "How can $\mathsf{Interpret}$ extract as much information as possible about $V$ from $(c, \sigma)$?" |

Note to figure `fig:gold_iron_clay`. The **Gold** layer ($\mathsf{Conf}$) performs cryptographic masking, the **Iron** layer ($\mathsf{Rel}_{\mathrm{ver}}$) guarantees binding and reliable verification, while the **Clay** layer ($\mathsf{Opp}$) presents the context in an interpretable form; it increases $\mathsf{Opp}$ only if it conveys information that the institution does not already hold (Remark `rem:statut_sotp`).

### Entropy budget

An optimal CLO protocol allocates its entropy budget according to application requirements. The total budget defined by

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget\_clo)}$$

equals, for example, $296$ bits for $\lambda = 128$ and a Helios voting context with $H(\mathcal{C}) = 40$ bits.

When the application gives priority to confidentiality ($\mathsf{Conf}_{\min} = 0.9$), the recommended allocation assigns $60\%$ of the budget to the Gold layer ($\approx 180$ bits), $30\%$ to Iron ($\approx 90$ bits) and the remaining $10\%$ to Clay (aggressive context compression). When opposability comes first ($\mathsf{Opp}_{\min} = 0.8$), the proportions are reversed, with $20\%$ for Gold (minimal masking), $30\%$ for Iron (standard binding) and $50\%$ for Clay (rich context preservation).

Modular independence of the layers is essential, because Gold, Iron and Clay must be replaceable without a complete redesign [canetti2001, Goldreich02]. Replacing the PRG with AES-GCM affects neither Iron nor Clay; replacing Pedersen with an RSA accumulator leaves Gold and Clay intact; replacing contextual hashing with JL compression does not affect the first two layers.

## 3. S-OTP, prototype

Source: §`subsec:construction_sotp` and §`subsec:metriques_sotp`.

The Gold-Iron-Clay paradigm is achievable within the class of XOR-based protocols, through the **Semantic One-Time Pad (S-OTP)** construction, prototype of the SOTP family.

**Theorem `thm:proprietes_sotp` (Security properties of S-OTP).** Under the PRG (pseudo-random generator) and discrete-logarithm hardness (DLog) assumptions in $\mathbb{G}$ [BlumMicali84, Yao82],

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Opp}(\text{S-OTP}) \leq \frac{H(h \mid C)}{H(V\mid C)}$$

where $h$ is the auxiliary proof component that carries the contextual information.

**Remark `rem:portee_sotp` (Scope of Theorem `thm:proprietes_sotp`).** The reliability established is verification reliability $\mathsf{Rel}_{\mathrm{ver}}$; reconstruction reliability satisfies $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ as soon as $I(M;\Sigma|C) \leq \kappa/\lambda$ (Remark `rem:rel_ver`). If $h$ is a function of the public context $C$, then $H(h|C) = 0$ and $\mathsf{Opp}(\text{S-OTP}) = 0$. The opposability of S-OTP therefore assumes that $h$ conveys contextual information that the institution does not already hold (private case-specific context). The expression $H(\mathcal{C})/\lambda$ of [MINKA2026CLO] corresponds to the convention $H(h|C) = H(\mathcal{C})$ and $H(V|C) \approx \lambda$.

### Proof (confidentiality)

By the one-time-pad masking construction, $M^* = m \oplus \mathsf{mask}_m$ where $\mathsf{mask}_m \xleftarrow{\$} \lbrace 0,1\rbrace^{|m|}$. For every pair $(m_0, m_1) \in \mathcal{M}$,

$$\mathrm{TV}(P_{M^*|M=m_0}, P_{M^*|M=m_1}) = 0$$

because both distributions are uniform over $\lbrace 0,1\rbrace^{|m|}$. The commitment $c_\Sigma = \mathsf{Com}(M^*)$ inherits this indistinguishability, because the Pedersen commitment is *perfectly* hiding without any computational assumption [Pedersen91]. Hence

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \max_{m_0,m_1} \mathrm{TV}(P_{\Sigma|M=m_0}, P_{\Sigma|M=m_1}) = 1 - \mathrm{negl}(\lambda).$$

### Proof (reliability)

Completeness follows directly from the completeness of the commitment scheme. For every $(m, c)$,

$$\Pr[\mathsf{Verify}(pk, \mathsf{Prove}(sk,m,c), c) = 1] = 1 - \delta_{\mathsf{Com}}$$

where $\delta_{\mathsf{Com}} = \mathrm{negl}(\lambda)$ is the commitment error. To establish *soundness*, suppose an adversary $\mathcal{A}$ produces $\sigma^* = (c_\Sigma^*, h^*, \ldots)$ with $\mathsf{Verify}(\sigma^*, c) = 1$ without going through $\mathsf{Prove}$. Then $\mathcal{A}$ would have opened the commitment $c_\Sigma^*$ to a valid content; this contradicts the computational *binding* property of the Pedersen scheme under the DLog assumption (probability $\leq \mathrm{negl}(\lambda)$) [Pedersen91]. Hence $\mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda)$.

### Proof (opposability)

The auxiliary information $h$ encodes $\ell_{\text{aux}} = H(\mathcal{C})$ bits of context. By construction,

$$I(V;\Sigma|C) \leq I(V;h|C) = H(h|C) - H(h|V,C) \leq H(h|C).$$

Dividing by $H(V|C)$ gives

$$\mathsf{Opp}(\text{S-OTP}) = \frac{I(V;\Sigma|C)}{H(V|C)} \leq \frac{H(h|C)}{H(V|C)}.$$

**Remark `thm:optimalite_sotp` (Optimality of S-OTP within the OTP class: heuristic argument).** Among protocols that mask the message with a one-time pad and encode the context only in an auxiliary component $h$, S-OTP appears to achieve the best trade-off, since every such protocol devotes $|m| = \lambda$ random bits to masking for perfect security and has its opposability bounded by $H(h|C)/H(V|C)$ (same argument as above). A proof of optimality would require a formal definition of the OTP class and a uniform upper bound within it; we leave it open. Any construction achieving higher opposability must either (i) give up information-theoretic confidentiality in favour of computational assumptions, or (ii) use interactive multi-round protocols, or (iii) employ different primitives, beyond the OTP paradigm.

### CLO metrics achieved (illustration)

For the typical parameters $\lambda = 128$, $\Delta = 50$ bits, $H(\mathcal{C}) = 30$ bits (scarce-context regime),

$$\mathsf{Conf}(\text{S-OTP}) \approx 0.999, \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) \approx 0.999, \qquad \mathsf{Opp}(\text{S-OTP}) \approx \min\left\lbrace 1,\ \frac{50}{30}\right\rbrace = 1.$$

These values are theoretical estimates computed under the PRG and DLog assumptions [Goldreich01, KatzLindell14]; they are not controlled empirical measurements. The product is then

$$\mathsf{Conf} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \approx 0.998.$$

This value concerns verification reliability and an opposability computed under the convention $\mathsf{Opp} = \min\lbrace 1,\Delta/H(\mathcal{C})\rbrace$, which assumes that $h$ conveys a case-specific context unknown to the institution; it is not comparable with the bound of Theorem `thm:trilemme_cro_conditionnel`. In terms of reconstruction reliability, the statistical confidentiality of S-OTP imposes $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ (Remark `rem:rel_ver`), while [MINKA2026CLO] gives a product of order $H(\mathcal{C})/\lambda$. This high product is only achievable in the scarce-context regime ($H(\mathcal{C}) \leq \Delta$). As soon as the context becomes richer ($H(\mathcal{C}) \gg \Delta$), opposability collapses to $\mathsf{Opp} \approx \Delta / H(\mathcal{C}) \ll 1$, which motivates the SOTP-Base and SOTP-High variants.

Remark `thm:optimalite_sotp` indicates that S-OTP would be optimal within its class, without proving it. Even if established, this optimality would remain restricted, because the SOTP-Base and SOTP-High variants use techniques beyond XOR protocols (JL compression, zk-SNARKs) and outperform S-OTP in the appropriate regimes.

## 4. Common architecture of the SOTP family

Source: §`subsec:philosophie_sotp`.

Three functional layers structure every protocol. The **Gold** layer performs cryptographic masking using pseudo-random one-time pads in the low and intermediate regimes [Shannon49, BlumMicali84], and zero-knowledge proofs in the rich regime [GMR85, BenOr88]. The **Iron** layer provides binding through binding commitments, Pedersen [Pedersen91, ChaumPedersen92] for SOTP-Low/Base, Groth16 [Groth16, BCTV14] for SOTP-High, allowing verifiable opening of the message. Finally, the **Clay** layer presents the institutional context in a form that interpreters with bounded capacity $\Delta$ can use to reach their verdicts [Simon82, Miller56]; it increases $\mathsf{Opp}$ only if it conveys information that the institution does not already hold (Remark `rem:statut_sotp`).

The specific contribution of the family lies in its **per-regime adaptation**: each SOTP variant specialises the Clay layer according to the contextual entropy $H(\mathcal{C})$, substituting deterministic encoding, Johnson-Lindenstrauss compression [JohnsonLindenstrauss84, DasguptaGupta03, Vempala05] or Poseidon SNARK hashing [Groth16, Poseidon2019] depending on the richness of the context.

### Correspondence between CLO metrics and cryptographic properties

| CLO metric | Cryptographic property | Assumptions |
|---|---|---|
| $\mathsf{Conf}$ (statistical notion) | semantic indistinguishability [GoldwasserMicali84, MicaliRackoff91]: for every pair $(m_0, m_1)$ in the same context $c$, no polynomial adversary distinguishes the proof of $m_0$ from that of $m_1$ with non-negligible advantage | PRG [BlumMicali84, Yao82] |
| $\mathsf{Rel}_{\mathrm{ver}}$ (Remark `rem:rel_ver`) | binding [Pedersen91, Damgard87]: no polynomial adversary produces two distinct openings of the same commitment to different messages with non-negligible probability | DLog [DiffieHellman76], q-SDH/q-PKE [BonehBoyen08] |
| $\mathsf{Opp}$ | fraction of extractable information about the verdict, $I(V;\Sigma\mid C)/H(V\mid C)$, quantified through the institutional extraction capacity $\Delta$ (Definition `def:delta_extraction`) | no reduction; depends on institutional interpretation |

The confidentiality and verification-reliability guarantees result from formal reductions to standard cryptographic assumptions; opposability, by contrast, depends on institutional interpretation and is not lower-bounded by these reductions.

### Clay layer per regime

| Regime | Condition | Clay technique |
|---|---|---|
| scarce | $H(\mathcal{C}) < H^*(\lambda)$ | deterministic encoding $\phi:\mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$, lossless [Shannon48] |
| transition | $H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log\lambda$ | JL compression [JohnsonLindenstrauss84, Achlioptas2003] from $d = \Theta(\Delta \cdot H(\mathcal{C}))$ to $k = O(\log n/\epsilon^2)$ dimensions, distances preserved up to $\epsilon$ |
| rich | $H(\mathcal{C}) > \lambda/\log\lambda$ | Poseidon hashing [Poseidon2019, Grassi2021] into a $256$-bit digest, with structured metadata |

The two construction thresholds are

$$H^*(\lambda) = \sqrt{\lambda} \qquad\text{and}\qquad H^{**}(\lambda) = \frac{\lambda}{\log_2 \lambda},$$

that is about $11$ bits and $18$ bits for $\lambda = 128$. The threshold $H^*(\lambda)$ is a construction criterion, distinct from the threshold $H^\sharp$ of the theorem (Remark `rem:activite_delta`).

The total entropy budget of each SOTP proof is

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget)}$$

For $\lambda = 128$ and $H(\mathcal{C}) = 40$ bits (Helios-type voting [Adida08]), this gives $\approx 296$ bits. This budget constrains the Clay layer, because preserving too much context may correlate $\Sigma$ with $m$, reducing $\mathsf{Conf}$; compressing too aggressively reduces $\mathsf{Opp}$ because the interpreter can no longer extract verdicts [Smith09, Alvim12].

## 5. SOTP-Low (scarce-context regime)

Source: §`subsec:sotp_low`.

The target regime is that of contexts that can be encoded in full inside the proof, $H(\mathcal{C}) < H^*(\lambda)$, with $H^*(\lambda) = \sqrt{\lambda}$ as construction criterion (about $11$ bits at $\lambda = 128$). Contractual ECDSA signatures [Johnson01, NIST.FIPS.186-5] are the textbook case, since a standardised contract and its parties are often parameterised by a context of entropy $H(\mathcal{C}) \approx 20$ bits [Mason07, Kerr04]. Whenever $\Delta \gtrsim H(\mathcal{C})$, the institutional capacity absorbs the whole context, so that opposability may approach 1.

### Algorithm 1 — SOTP-Low (`alg:sotp_low`)

```text
 1  Parameters: λ, H(C) < H*(λ), (Δ, α, β)
 2  Setup(1^λ):
 3      Generate cyclic group (G, q) with |q| ≥ 2λ and hard DLog
 4      sample g, h ←$ G such that log_g h is unknown
 5      Choose PRG  PRG : Z_q → {0,1}^λ
 6      Choose collision-resistant Hash : C → {0,1}^λ
 7      Define deterministic encoding φ : C → {0,1}^{H(C)}
 8      Return pk = (G, q, g, h, PRG, Hash, φ)
 9  Prove(pk, m, c):
10      // Gold
11      s ←$ Z_q ;  σ1 ← m ⊕ PRG(s)
12      // Iron
13      ρ ←$ Z_q ;  σ2 ← g^s · h^ρ                      [Pedersen91]
14      // Clay
15      σ3 ← (φ(c), Hash(c), V(c))
16      Return σ = (σ1, σ2, σ3) ; secret witness (s, ρ)
17  Verify(pk, σ, c):
18      Check Hash(c) =? σ3.hc  and  φ(c) =? σ3.h_c  and  σ2 ∈ G
19  Open(pk, σ, c, (m, s, ρ)):
20      Accept iff σ2 = g^s h^ρ  and  σ1 = m ⊕ PRG(s)
```

Construction points stated in the thesis text.

- Sampling the seed in $\mathbb{Z}_q$ is essential. With $s \in \lbrace 0,1\rbrace^\lambda$ and a commitment to $\mathsf{int}(s) \bmod q$, two seeds $s$ and $s+q$ would yield the same commitment, which would destroy binding.
- The $\mathsf{Verify}$ phase does not check consistency between $\sigma_1$ and $\sigma_2$, because this link is only checked at opening ($\mathsf{Open}$), which requires the witness $(m, s, \rho)$; without opening, $\sigma_1$ and $\sigma_2$ are not linked, so that $\mathsf{Verify}$ alone accepts any well-formed pair. The arbiter can thus check the form of the proof without access to the message $m$; the binding guarantee concerns the opening.
- The Clay layer presents the context in a readable form but, being a function of the public context $c$, it carries no conditional information in the sense of $\mathsf{Opp}$ (Remark `rem:statut_sotp`).

### Proposition `thm:saturation_sotp_low` (Cryptographic properties of SOTP-Low)

Under PRG security [BlumMicali84, Yao82] and DLog hardness [DiffieHellman76]:

1. every PPT adversary has negligible IND-CONF advantage against SOTP-Low (computational confidentiality);
2. completeness is perfect and, for the opening procedure, the BIND-REL winning probability is negligible, hence $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$ in the sense of Remark `rem:jeu_bind_rel_link`.

**Remark `rem:facteur_limitant_low` (Design heuristic of SOTP-Low, unproven).** The initial formulation of this result stated the lower bound $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0.75 \cdot \min\lbrace\Delta, H(\mathcal{C})\rbrace/\lambda$. The formalisation led to replacing it, for three reasons. (i) The component $\sigma_3 = (\phi(c), \mathsf{Hash}(c), V(c))$ is a function of the public context, hence $I(V;\sigma_3|C) = 0$; (ii) going through $H(V|C) \approx \lambda$ contradicts Assumption `ass:verdicts_efficace` ($\log_2|\mathcal{V}_\lambda| \leq \alpha H(\mathcal{C})$); (iii) such a lower bound would exceed the upper bound of Theorem `thm:trilemme_cro_conditionnel` as soon as $\gamma > 4/3$, while concerning $\mathsf{Rel}_{\mathrm{ver}}$ instead of $\mathsf{Rel}_{\mathrm{rec}}$. The expression $0.75\,\Delta/\lambda$ is kept as a *design heuristic*, because it describes the fraction of extraction capacity that a full encoding of $\lfloor H(\mathcal{C}) \rfloor$ bits would allow to exploit if this context were a case-specific context unknown to the institution ($1 - 1/\Delta \geq 0.75$ for $\Delta \geq 4$). Its rigorous justification, in a private-context model, is a perspective (Chapter `chap:resultats_discussions`).

### Proof of Proposition `thm:saturation_sotp_low`

Recall of the construction.

$$\sigma_1 = m \oplus \mathsf{PRG}(s),\ s \xleftarrow{\$} \mathbb{Z}_q \ \text{(Gold)}, \qquad \sigma_2 = g^{s} \cdot h^\rho,\ \rho \xleftarrow{\$} \mathbb{Z}_q \ \text{(Iron)}, \qquad \sigma_3 = \bigl(\phi(c),\ \mathsf{Hash}(c),\ V(c)\bigr) \ \text{(Clay)}$$

where $(g, h)$ are generators of the group $(\mathbb{G}, q)$ with $\log_g h$ unknown. The secret witness is $(s, \rho)$.

**Part I. Computational confidentiality.** The distribution of $\sigma$ given $M = m_i$ depends on $m_i$ only through $\sigma_1$. Indeed, $\sigma_2$ is perfectly hiding (for every $s$, $g^s h^\rho$ is uniform in $\mathbb{G}$ when $\rho$ is uniform) while $\sigma_3$ depends only on $c$, independent of $m$ ($M \perp C$). Suppose a PPT distinguisher $\mathcal{D}$ distinguishes $m_0 \oplus \mathsf{PRG}(s)$ from $m_1 \oplus \mathsf{PRG}(s)$ with non-negligible advantage $\mu(\lambda)$. The adversary $\mathcal{B}$ that receives $y$ (PRG output or uniform string), samples $b$, submits $m_b \oplus y$ to $\mathcal{D}$ and answers "PRG" if $\mathcal{D}$ recovers $b$, distinguishes the PRG with advantage $\mu(\lambda)/2$, since if $y$ is uniform, $m_b \oplus y$ contains no information about $b$. This contradicts PRG security [BlumMicali84]. The IND-CONF advantage of every PPT adversary is therefore negligible. Confidentiality is computational. In the statistical sense of Definition `def:confidentialite_clo`, it is guaranteed only if the PRG is replaced by a uniform mask.

**Part II. Verification reliability.** *Completeness.* For every honest proof, $\mathsf{Hash}(c) = \sigma_3.\mathsf{hc}$ and $\phi(c) = \sigma_3.h_c$ by construction, $\sigma_2 \in \mathbb{G}$ by closure of the group; finally $\mathsf{Open}$ accepts the honest witness $(m, s, \rho)$. Completeness is perfect.

*Binding (reduction to DLog).* Suppose a PPT adversary produces a proof $\sigma$ and two accepted openings $(m_0, s_0, \rho_0)$ and $(m_1, s_1, \rho_1)$ with $m_0 \neq m_1$. Since $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ and $m_0 \neq m_1$, we have $s_0 \neq s_1$ in $\mathbb{Z}_q$. The equality $g^{s_0} h^{\rho_0} = g^{s_1} h^{\rho_1}$ then forces $\rho_0 \neq \rho_1$ and

$$\log_g h = \frac{s_0 - s_1}{\rho_1 - \rho_0} \bmod q,$$

which contradicts the hardness of the discrete logarithm [DiffieHellman76]. The BIND-REL winning probability is therefore negligible, whence $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$. $\square$

### Illustration: ECDSA signatures

As an illustration (and not a validation, because the CLO metrics of ECDSA are analytical parametric estimates derived from published specifications [Johnson01, NIST.FIPS.186-5] and ECDSA is not an instance of the theorem, Remark `rem:portee_cas_etude`), the parameters $\Delta = 35$ bits, $\lambda = 128$ give the SOTP-Low heuristic the value $0.75 \times 35/128 \approx 0.205$. This value is not comparable with the CLO product of ECDSA ($0.273$).

## 6. SOTP-Base (transition regime)

Source: §`subsec:sotp_base`.

Helios [Adida08, Adida09UCL] is the archetype of this regime, since the electoral context (voter roll, voting rules, official record) represents $H(\mathcal{C}) \approx 40$–$50$ bits for a medium-sized election, the capacity of a committee of specialised trustees being estimated at $\Delta \approx 56$ bits. Johnson-Lindenstrauss compression [JohnsonLindenstrauss84, DasguptaGupta03, Achlioptas2003] projects the context from dimension $d = \Theta(\Delta \cdot H(\mathcal{C}))$ to $k = O(\log n/\epsilon^2)$ dimensions through a random matrix $\Phi$, preserving distances up to a factor $1 \pm \epsilon$. That extractable information is preserved in the same proportion is a design assumption, not a consequence of the lemma.

### Algorithm 2 — SOTP-Base, construction with JL compression (`alg:sotp_base`)

```text
 1  Parameters: λ, H*(λ) ≤ H(C) ≤ λ/log λ, ε = 0.1
 2  Setup(1^λ):
 3      Generate (G, q, g, h), PRG, Hash as in SOTP-Low
 4      Set d ← ⌈4 Δ H(C) / ε²⌉
 5      Set k ← ⌈8 log(2^{H(C)}) / ε²⌉
 6      Generate JL matrix Φ ←$ N(0, 1/k)^{k×d}       [DasguptaGupta03, Vempala05]
 7      Return pk = (G, q, g, h, PRG, Hash, Φ, k, d)
 8  Prove(pk, m, c):
 9      Gold and Iron layers identical to SOTP-Low
10      // Clay JL
11      c⃗ ← embed(c) ∈ R^d
12      σ3 ← Φ c⃗ ∈ R^k
13      Return σ = (σ1, σ2, σ3)
14  Verify(pk, σ, c):
15      Check ‖Φ · embed(c) − σ3‖ ≤ ε
16      Check σ2 ∈ G and Gold consistency
```

Construction points stated in the thesis text.

- The dimension $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ (line 4) calibrates the intermediate representation space on the product of the institutional extraction capacity $\Delta$ and the contextual entropy. The output dimension $k$ (line 5) sets the size of the transmitted Clay layer; it is calibrated so that the JL lemma guarantees distance preservation up to $\varepsilon = 0.1$ with high probability. The matrix $\Phi$ (line 6) is drawn from a centred Gaussian with variance $1/k$, a normalisation that preserves Euclidean norms in expectation.
- The function $\mathsf{embed}$ (line 11) translates the semantic structure of the context into a real vector, so that two semantically close contexts yield vectors that are close in Euclidean distance.
- Verification (line 15) checks closeness $\|\Phi \cdot \mathsf{embed}(c) - \sigma_3\| \leq \varepsilon$ rather than exact equality. With $\varepsilon = 0.1$, $\Delta = 56$ and $H(\mathcal{C}) = 40$, the intermediate dimension is $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil = 896{,}000$.

### Proposition `thm:saturation_sotp_base` (Cryptographic properties of SOTP-Base)

Under PRG security [BlumMicali84] and DLog hardness [DiffieHellman76], since the Gold and Iron layers of SOTP-Base are identical to those of SOTP-Low, SOTP-Base satisfies the two properties of Proposition `thm:saturation_sotp_low`, namely computational confidentiality and $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$ for the opening procedure. Moreover, for all contexts $c, c'$, with probability at least $1 - \delta$ over the choice of $\Phi$,

$$\|\Phi\,\mathsf{embed}(c) - \Phi\,\mathsf{embed}(c')\|^2 \in (1 \pm \varepsilon)\|\mathsf{embed}(c) - \mathsf{embed}(c')\|^2$$

(Lemma `lem:johnson_lindenstrauss`).

*Proof.* The arguments of Proposition `thm:saturation_sotp_low` apply unchanged to the Gold and Iron layers; the Clay layer plays no role in confidentiality (it depends only on $c$, independent of $m$) nor in binding. The last property is the Johnson–Lindenstrauss lemma applied to the finite set of context embeddings. $\square$

**Remark `rem:heuristique_sotp_base` (Design heuristic of SOTP-Base, unproven).** The initial formulation of this result stated $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0.5 \cdot \min\lbrace\Delta/d,\ \beta\log_2 d/d\rbrace$. The formalisation led to replacing it for the reasons given in Remark `rem:facteur_limitant_low`. Indeed, $\sigma_3 = \Phi\,\mathsf{embed}(c)$ is a function of the public context, hence $I(V;\sigma_3|C) = 0$; distance preservation does not imply preservation of extractable information; finally the derivation inferred a lower bound from an upper bound. The expression $0.5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ is kept as a sizing heuristic for the Clay layer.

### Illustration: Helios electronic voting

As an illustration, the SOTP-Base heuristic for the analytical Helios parameters [Adida08, MINKA2026CRO] ($\Delta = 56$ bits, $\beta = 1.4$, $d = 560$) gives $0.5 \times \min\lbrace 56/560,\ 56/(1.4 \log_2 560)\rbrace \approx 0.050$. This value is not comparable with the CLO product of Helios ($0.437$), which concerns $\mathsf{Rel}_{\mathrm{ver}}$ and is not an instance of the theorem (Remark `rem:portee_cas_etude`). The dimension $d = 560$ used here is a sizing choice, distinct from the rule $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$.

## 7. SOTP-High (rich-context regime)

Source: §`subsec:sotp_high`.

Financial compliance through zk-SNARKs [Groth16, Garratt15, BaselIII] illustrates this regime, where complex transactions, multi-jurisdictional regulations and long histories produce $H(\mathcal{C}) \approx 70$–$90$ bits. Succinct zk-SNARKs (Groth16 [Groth16, BCTV14, Gennaro13]) produce a constant-size proof ($\approx 128$–$200$ bytes) independent of the complexity of the verified circuit. This solution has a twofold cost. A trusted setup step is required [Bowe2017]; moreover opposability, capped by the entropy loss of the hash compressing the context into 256 bits, is reduced.

### Algorithm 3 — SOTP-High, construction with Groth16 zk-SNARKs (`alg:sotp_high`)

```text
 1  Parameters: λ, H(C) > λ/log λ, circuit C_circuit
 2  Setup(1^λ, C_circuit):
 3      sample τ, α_s, β_s, γ, δ ←$ F_p^*  (toxic)
 4      Build pk_prove and vk_verify (Groth16 CRS)          [Groth16, BCTV14]
 5      // Destroy toxic waste: τ, α_s, β_s, γ, δ
 6      (g, h) ←$ G² for the Iron layer
 7      Return pk = (pk_prove, vk_verify, g, h)
 8  Prove(pk, m, c):
 9      // Gold + Iron (Groth16 + Pedersen)
10      ρ ←$ Z_q ;  c_m ← g^m · h^ρ                         [Pedersen91]
11      h_c ← Poseidon(c) ;  π ← Groth16.Prove(pk_prove, (h_c, c_m), (m, c, ρ))
12      relation: h_c = Poseidon(c) ∧ c_m = g^m h^ρ ∧ Conforme(m, c) = 1
13      // Clay: hash digest + metadata
14      Return σ = (h_c, π, c_m, metadata)
15  Verify(σ):
16      b1 ← Groth16.Verify(vk_verify, (h_c, c_m), π)
17      b2 ← [c_m ∈ G]
18      Return b1 ∧ b2
```

Construction points stated in the thesis text.

- Line 5 is a security imperative. If any of the five toxic scalars survived the $\mathsf{Setup}$, its holder could forge valid proofs for any statement. In practice, destruction is achieved through a multi-party step in which the simultaneous compromise of all participants would be needed to rebuild the toxic values.
- The proof $\pi$ attests that the prover knows $(m, c, \rho)$ such that $h_c = \mathsf{Poseidon}(c)$, $c_m = g^m h^\rho$ and the compliance predicate $\mathsf{Conforme}(m, c)$ holds.
- The contextual information the arbiter can extract from $h_c$ is bounded by the digest size ($256$ bits). It is even zero if $c$ is already known to the institution. What the proof contributes to the verdict lies in the certified statement ($\mathsf{Conforme}(m,c) = 1$), not in the digest.

An executable implementation of this algorithm (Circom/Groth16) is provided separately in [`../high/`](../high/).

### Proposition `thm:saturation_sotp_high` (Cryptographic properties of SOTP-High)

Under the q-SDH and q-PKE assumptions (*knowledge soundness* of Groth16 [BonehBoyen08, BCTV14]), DLog hardness and an honest trusted-setup ceremony [Bowe2017]:

1. the proof $\pi$ is perfect zero-knowledge and $c_m$ is perfectly hiding, so that $(\pi, c_m)$ reveals nothing about $m$ beyond the public inputs;
2. completeness is perfect and, by *knowledge soundness*, for every PPT prover that gets $\sigma$ accepted there exists an *extractor* (which rewinds the prover or uses the trapdoor of the q-PKE assumption, unlike the verifier) producing a witness $(m, c, \rho)$ satisfying the relation; hence $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$.

**Remark `rem:heuristique_sotp_high` (Design heuristic of SOTP-High, unproven).** The initial formulation of this result stated $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0.45 \cdot \beta\log_2\lambda/\lambda$, with a constant $0.45$ "calibrated" on deployed systems. The formalisation led to replacing it. The digest $h_c = \mathsf{Poseidon}(c)$ and the metadata are functions of the public context ($I(V;h_c|C) = 0$); three group elements represent $\Theta(\lambda)$ bits and not $O(\log\lambda)$; the verifier cannot extract the witness, otherwise the proof would not be zero-knowledge; finally a constant fitted on data has no place in a theorem statement. The expression $0.45\,\beta\log_2\lambda/\lambda$ is kept as a design heuristic; $\beta$ denotes the regularity constant of the protocol (Definition `def:beta_regularite`).

### Illustration: zk-SNARK compliance

For the analytical parameters $\Delta = 73$ bits, $\alpha = 1.5$, $\beta = 1.5$, $\lambda = 128$ (parametric estimates, not controlled empirical measurement), the SOTP-High heuristic gives $0.45 \times 1.5 \times 7/128 \approx 0.037$. This value is not comparable with the CLO product of compliance zk-SNARKs ($\approx 0.572$), which concerns $\mathsf{Rel}_{\mathrm{ver}}$ and is not an instance of the theorem (Remark `rem:portee_cas_etude`).

## 8. Synthesis and variant selection

Source: §`subsec:synthese_selection`.

### Table `tab:comparaison_sotp_construction` — Comparison of SOTP variants

| Criterion | SOTP-Low | SOTP-Base | SOTP-High |
|---|---|---|---|
| ***Operating regime*** | | | |
| Entropy $H(\mathcal{C})$ | $< H^*(\lambda) \approx O(\sqrt{\lambda})$ | $H^*(\lambda) \leq H(\mathcal{C}) \leq \lambda/\log\lambda$ | $> \lambda/\log\lambda$ |
| Values ($\lambda = 128$) | $< 11$ bits | $11$–$18$ bits | $> 18$ bits |
| ***Cryptographic techniques*** | | | |
| Gold layer | PRG [BlumMicali84] | PRG [BlumMicali84] | Perfect ZK Groth16 [Groth16] |
| Iron layer | Pedersen [Pedersen91] | Pedersen [Pedersen91] | q-SDH Soundness [BonehBoyen08] |
| Clay layer | $\phi:\mathcal{C}\to\lbrace 0,1\rbrace^{H(\mathcal{C})}$ | JL $\Phi:\mathbb{R}^d\to\mathbb{R}^k$ [JohnsonLindenstrauss84] | Poseidon + SNARK [Poseidon2019] |
| Primitives | SHA-256, Pedersen | Gaussian, Pedersen | Groth16, Poseidon, BLS12-381 [BLS12-381] |
| ***CLO metrics achieved*** | | | |
| Confidentiality | computational (PRG) | computational (PRG) | perfect ZK |
| $\mathsf{Rel}_{\mathrm{ver}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{q-SDH}}$ |
| $\mathsf{Opp}$ | depends on the case-specific context conveyed | same | same |
| ***Design heuristic (unproven)*** | | | |
| Expression | $0.75 \cdot \Delta/\lambda$ | $0.5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ | $0.45 \cdot \beta\log_2\lambda/\lambda$ |
| Trusted setup | No | No | Yes [Bowe2017] |
| ***Illustration (not comparable with CLO products)*** | | | |
| Reference system | ECDSA [Johnson01] | Helios [Adida08] | compliance zk-SNARKs [Groth16] |
| Heuristic value | $\approx 0.205$ | $\approx 0.050$ | $\approx 0.037$ |
| CLO product ($\mathsf{Rel}_{\mathrm{ver}}$ scale) | $\approx 0.273$ | $\approx 0.437$ | $\approx 0.572$ |

The three variants form an adaptive continuum covering the whole spectrum of contextual entropy. SOTP-Low favours readability of the context at the price of a restriction on $H(\mathcal{C})$, ideal for legal or contractual applications [Mason07, Kerr04]. SOTP-Base balances the three metrics through adaptive compression, versatile for governmental and electoral applications [Adida08, Goodman15]. SOTP-High sacrifices opposability for perfect confidentiality and scalability, necessary for financial or medical applications with very rich context [Garratt15, BaselIII].

### Algorithm 4 — Automatic SOTP variant selection (`alg:selection_variante_sotp`)

```text
 1  Inputs: H(C), Δ, λ, Priority, TrustedSetup_OK
 2  H*(λ) ← √λ ;  H**(λ) ← λ / log2 λ
 3  if TrustedSetup_OK = False and H(C) > H**(λ) then
 4      ALERT: SOTP-High required but trusted setup unavailable   [Bowe2017]
 5      Recommend: SOTP-Base with loss of opposability, or deploy MPC
 6      Return SOTP-Base
 7  end if
 8  if H(C) < H*(λ) then
 9      Return SOTP-Low
10  else if H(C) ≤ H**(λ) then
11      Return SOTP-Base ;  d ← ⌈4 Δ H(C) / ε²⌉
12  else
13      Return SOTP-High ;  compile circuit C_circuit
14  end if
```

This algorithm is not a cryptographic construction but a deployment meta-algorithm. Lines 3 to 7 form the operational safety guard. If the trusted setup has not been carried out and the context is nevertheless rich, the algorithm raises an explicit alert rather than silently degrading security. It then recommends either accepting SOTP-Base with the associated loss of opposability, or deploying an MPC protocol to perform the trusted setup in a distributed way. The value $d$ is computed at selection time rather than in $\mathsf{Setup}$, so that $d$ can be adapted to the actual value of $H(\mathcal{C})$ observed at deployment. The selection logic reflects an implicit preference order. SOTP-Low is preferred when applicable (minimal cost, no external dependency), SOTP-Base is the default choice in the intermediate regime (robust, no trusted setup), while SOTP-High is deployed only when contextual richness makes it unavoidable and operational conditions allow it.

### Five-phase design methodology

1. **Application analysis.** Estimate $H(\mathcal{C})$ and identify the minimal requirements $\mathsf{Conf}_{\min}$, $\mathsf{Rel}_{\min}$, $\mathsf{Opp}_{\min}$.
2. **Institutional assessment.** Estimate $\Delta$ (deliberation capacity, expertise, institutional memory) and $\alpha$ (verdict granularity). These estimates are analytical, since direct measurement through controlled cognitive protocols remains future work.
3. **Feasibility test.** Check the inequality
   $$\mathsf{Conf}_{\min} \cdot \mathsf{Rel}_{\mathrm{rec},\min} \cdot \mathsf{Opp}_{\min} \stackrel{?}{\leq} \frac{1+\kappa/\lambda}{\lambda}\,\min\left\lbrace 1, \frac{\kappa/\lambda + \Delta}{\gamma}\right\rbrace \qquad \text{(eq:test\_faisabilite\_sotp)}$$
   for requirements expressed in reconstruction reliability (equation `eq:trilemme_cro_raffine`). If the inequality is violated, one may relax a requirement; increase $\Delta$ through investment in institutional training (effective only if $\Delta < \gamma$); or revise verdict granularity. Requirements expressed in verification reliability $\mathsf{Rel}_{\mathrm{ver}}$ are not constrained by this test.
4. **Selection and parameterisation.** Apply Algorithm `alg:selection_variante_sotp` and optimise the Gold/Iron/Clay primitives in the identified regime.
5. **Proofs and validation.** Establish the formal reductions to standard assumptions, then measure $\Delta$ and the opposability obtained according to the protocols of Chapter `chap:experimentation`.

## 9. Universal optimality conjecture and sensitivity analysis

Source: §`subsec:optimalite_sensibilite`.

**Conjecture `conj:optimalite_universelle` (Universal optimality of SOTP).** Under Assumptions `ass:extraction_bornee`–`ass:regime`, for each regime of contextual richness, there exist an SOTP variant and a constant $C_R \geq 1$ independent of $\lambda$ such that, for every CLO protocol $\mathcal{P}'$ of the same regime,

$$\mathsf{Conf}(\mathcal{P}')\,\mathsf{Rel}_{\mathrm{rec}}(\mathcal{P}')\,\mathsf{Opp}(\mathcal{P}') \ \leq\ C_R \cdot \mathsf{Conf}(\text{SOTP})\,\mathsf{Rel}_{\mathrm{rec}}(\text{SOTP})\,\mathsf{Opp}(\text{SOTP}). \qquad \text{(eq:optimalite\_universelle)}$$

**Remark `rem:statut_optimalite` (Status and heuristic argument).** The initial formulation of this statement, presented as a theorem in the form $\text{product}(\mathcal{P}') \leq c \cdot \text{product}(\text{SOTP}) + o(1)$ with $c \in [0.45;\,0.75]$, was replaced by a more precise formulation, for four reasons. (i) With $c < 1$ and $\mathcal{P}' = \text{SOTP}$, it would give $\text{product} \leq 0.75 \times \text{product}$, which forces $C_R \geq 1$; (ii) the additive term $o(1)$ dominates products that are all $O(1/\lambda)$; (iii) its argument invoked the trilemma without Assumption `ass:regime`; (iv) it relied on the lower bounds of Remarks `rem:facteur_limitant_low`, `rem:heuristique_sotp_base` and `rem:heuristique_sotp_high`, which are design heuristics. The multiplicative form above, with $C_R \geq 1$, is the statement the argument aims at. The argument proceeds in three steps, which consist in upper-bounding the product of any $\mathcal{P}'$ by the refined form (`eq:trilemme_cro_raffine`); lower-bounding that of the SOTP variant of the regime; forming the ratio. The second step remains open, because it requires a model in which the Clay layer conveys a case-specific context that the institution does not hold (perspective developed in Chapter `chap:resultats_discussions`). The indicative ratios that the design heuristics would give, $1/0.75 \approx 1.33$ (SOTP-Low), $1/0.5 = 2$ (SOTP-Base) and $1/0.45 \approx 2.2$ (SOTP-High), set the order of magnitude of the targeted $C_R$.

### Sensitivity analysis

The analysis concerns the refined bound (`eq:trilemme_cro_raffine`), which is the only proven statement, as well as the design heuristics.

- **Sensitivity to $\Delta$.** In the rich-context regime ($\Delta < \gamma$), the bound is proportional to $\kappa/\lambda + \Delta$. Increasing $\Delta$ from $50$ to $65$ bits (intensive training of trustees [Ericsson95]) raises the bound by about $30\%$. In the scarce-context regime ($\Delta \geq \gamma$), the bound is Fano's and does not depend on $\Delta$.
- **Sensitivity to $\alpha$.** In the rich-context regime, the bound varies as $1/\gamma = 1/(\alpha H(\mathcal{C}) - 1)$, so that coarser verdicts (going from 12 levels to 6) raise the bound and may move the institution into the scarce-context regime. Institutions with highly nuanced verdicts (fine risk scales, graduated fine amounts) thus pay a real penalty. The optimum between decision precision and CRO trade-off depends on application priorities.
- **Sensitivity to $\beta$.** The constant $\beta$ does not appear in the bound; it enters the confidentiality guarantee of Lemma `lem:confidentiality_guarantee`, where a more regular protocol (smaller $\beta$) tightens this guarantee. In the SOTP-High heuristic, which is proportional to $\beta$, going from $\beta = 1.5$ to $\beta = 1.2$ *decreases* the value by $20\%$. $\beta$ is a property of the proof distributions (KL divergence) rather than of the hash function used in the circuit.

## 10. Quantum extension

Source: §`subsec:extension_postquantique_sotp`.

- **Post-quantum SOTP-Low.** The Gold layer can use hash-based PRGs (resistant to quantum attacks through Grover's algorithm [Grover96], which reduces security from $\lambda$ to $\lambda/2$ bits). The Pedersen commitment remains perfectly hiding, but its binding relies on DLog, which Shor's algorithm solves. It must therefore be replaced by a post-quantum commitment, for example a lattice-based one under SIS/LWE [Peikert2016].
- **Post-quantum SOTP-Base.** JL compression is independent of the adversary model [JohnsonLindenstrauss84, DasguptaGupta03]. The adaptations concern the Gold and Iron layers, with post-quantum primitives (lattice-based commitment [Peikert2016], ML-DSA signatures [Dilithium2022]).
- **Post-quantum SOTP-High.** Groth16 zk-SNARKs require particular care [Unruh2016, Chatterjee2021]. The q-SDH and q-PKE assumptions may be weakened against quantum adversaries (they rely on pairings, which Shor's algorithm compromises). STARKs [BenSasson2019], which rely only on hash functions, are the post-quantum alternative; Bulletproofs [Bulletproofs2018] rely on DLog and are not post-quantum.

The interpretability-loss coefficient $\eta_q$ (Definition `def:perte_interp_quantique`) applies to all variants when the proof travels over a quantum medium:

$$\mathsf{Opp}^q \geq \mathsf{Opp} - \eta_q\,\frac{H(C)}{H(V|C)},$$

and $\eta_q = 0$ when the proof remains a classical bit string.

## 11. Transcription notes

These notes flag points of the source text without modifying the statements.

<a id="t4"></a>**T4.** In Algorithm 2, $d$ is the embedding dimension and $k$ the output dimension ($\Phi : \mathbb{R}^d \to \mathbb{R}^k$). Annex A writes the projection as $\Phi : \mathbb{R}^n \to \mathbb{R}^d$, where $d$ is the output dimension. Line 5 does not specify the base of the logarithm; with $N = 2^{H(\mathcal{C})}$ and the natural logarithm, it coincides with $(4/\varepsilon^2)\ln(N^2)$, the dimension of the Annex A sizing lemma without its failure-probability term.
