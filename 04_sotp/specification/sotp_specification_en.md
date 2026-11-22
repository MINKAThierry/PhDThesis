> **Status: PROPOSAL — construction (submitted to IEEE Transactions on Information Theory)** · Source: thesis, Chapter 3, §3.1 (introduction), §3.2 (`sec:sotp_base`) and §3.3 (`sec:sotp_construction`)

# Specification of the SOTP family

*Version française : [sotp_specification_fr.md](sotp_specification_fr.md)*

This document is a faithful rendering of the S-OTP and SOTP constructions of the thesis (written in French). Statements (theorem, propositions, remarks, conjecture) and algorithms are translated without any change of substance. Internal cross-references to the thesis are given by their LaTeX label (for example `rem:rel_ver`) and bibliographic references by their key (for example [Pedersen91]). Transcription notes flag the places where the source text is inconsistent or ambiguous; they do not modify any statement.

## Contents

1. [Status of the results](#1-status-of-the-results)
2. [The Gold-Iron-Clay paradigm](#2-the-gold-iron-clay-paradigm)
3. [S-OTP, prototype](#3-s-otp-prototype)
4. [Common architecture of the SOTP family](#4-common-architecture-of-the-sotp-family)
5. [SOTP-Low when the exact context is required](#5-sotp-low-when-the-exact-context-is-required)
6. [SOTP-Base when proximity between contexts matters](#6-sotp-base-when-proximity-between-contexts-matters)
7. [SOTP-High beyond the capacity threshold](#7-sotp-high-beyond-the-capacity-threshold)
8. [Synthesis and variant selection](#8-synthesis-and-variant-selection)
9. [Universal optimality conjecture and sensitivity analysis](#9-universal-optimality-conjecture-and-sensitivity-analysis)
10. [Quantum extension](#10-quantum-extension)
11. [Transcription notes](#11-transcription-notes)

---

## 1. Status of the results

The threshold $H^\sharp$ of the theorem separates two regimes. SOTP-Low and SOTP-Base serve as references in the context-scarce regime ($H(\mathcal{C}) \leq H^\sharp$), depending on whether the institution needs the exact context or a representation that preserves proximity between contexts. SOTP-High serves as the reference in the context-rich regime. Their cryptographic properties are proven; their optimality, which concerns the opposability of protocols with negligible leakage, remains a conjecture.

**Remark `rem:statut_sotp` (Status of the results of this chapter).** The S-OTP and SOTP constructions are evaluated on the operational CLO scale, which combines statistical confidentiality, verification reliability $\mathsf{Rel}_{\mathrm{ver}}$ (Remark `rem:rel_ver`) and opposability under explicit interpretation conventions. These metrics are not compared with the bound of Theorem `thm:trilemme_cro_conditionnel`, which concerns $\mathsf{Rel}_{\mathrm{rec}}$ and states that, for every protocol with statistical confidentiality $1-\mathrm{negl}(\lambda)$, $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$. That the SOTP variants achieve, up to a constant, the best opposability allowed to protocols with negligible leakage is formulated as a conjecture (Conjecture `conj:optimalite_universelle`). Proof components that depend only on the public context $C$ carry no conditional information, since $I(V; g(C) \mid C) = 0$ for every function $g$. The Clay layer is therefore analysed as a *presentation format* that eases interpretation (lower cognitive cost) without adding information in the sense of $\mathsf{Opp}$. The factors $0.75$, $0.5$ and $0.45$ of the initial formulations are design heuristics, without the status of proven lower bounds. They do not appear in the statement of the conjecture.

| Statement | Status |
|---|---|
| Confidentiality (SOTP-Low, SOTP-Base) | statistical with a truncated mask (Remark `rem:masque_troncature`), computational under PRG otherwise (Propositions `thm:saturation_sotp_low`, `thm:saturation_sotp_base`) |
| $\mathsf{Rel}_{\mathrm{ver}} = 1-\mathrm{negl}(\lambda)$ (SOTP-Low, SOTP-Base) | proven under DLog |
| Confidentiality and $\mathsf{Rel}_{\mathrm{ver}}$ (SOTP-High) | proven under the knowledge soundness of Groth16 (generic or algebraic group model), DLog, collision resistance of Poseidon and an honest ceremony (Proposition `thm:saturation_sotp_high`) |
| JL distance preservation (SOTP-Base) | Johnson-Lindenstrauss lemma, probability $\geq 1-\delta$ |
| Lower bounds $0.75\,\Delta/\lambda$, $0.5\min\{\cdot\}$, $0.45\,\beta\log_2\lambda/\lambda$ | unproven design heuristics |
| Universal optimality of SOTP, in the opposability of protocols with negligible leakage | conjecture |
| Numerical values (ECDSA, Helios, zk-SNARKs, 296-bit budget) | analytical illustrations, not comparable with CLO products |

## 2. The Gold-Iron-Clay paradigm

Source: §`subsec:gold_iron_clay` and §`subsec:principes_conception`.

With the three metrics defined, a methodology is needed to design protocols that balance them [Shoup01, Damgard87]. The **Gold-Iron-Clay** paradigm structures this design into three functional layers. Its name, inspired by medieval metallurgy, reflects the relation between malleability and strength.

| Layer | Property | Means | Question it answers |
|---|---|---|---|
| **Gold** | confidentiality, $\mathsf{Conf} \to 1$ | cryptographic masking of the message through PRG-based one-time pads, semantically secure encryption [GoldwasserMicali84, Bellare97], zero-knowledge proofs [GMR85, BenOr88] | "How can $\sigma$ be made indistinguishable between two messages?" |
| **Iron** | reliability, $\mathsf{Rel}_{\mathrm{ver}} \to 1$ | binding commitments allowing verifiable recovery, Pedersen commitments [Pedersen91, ChaumPedersen92], accumulators [CamenischLysyanskaya02], signatures | "How can we guarantee that $\sigma$ allows $m$ to be recovered with probability $1 - \mathrm{negl}(\lambda)$?" |
| **Clay** | opposability, $\mathsf{Opp} \to \max$ | encoding that preserves the institutional context for information extraction by resource-bounded interpreters [Miller56, Simon82], through deterministic encoding, Johnson-Lindenstrauss projection [JohnsonLindenstrauss84, DasguptaGupta03] or deterministic hashing | "How can $\mathsf{Interpret}$ extract as much information as possible about $V$ from $(c, \sigma)$?" |

Note to figure `fig:gold_iron_clay`. The **Gold** layer ($\mathsf{Conf}$) performs cryptographic masking, the **Iron** layer ($\mathsf{Rel}_{\mathrm{ver}}$) guarantees binding and reliable verification, while the **Clay** layer ($\mathsf{Opp}$) presents the context in an interpretable form; it increases $\mathsf{Opp}$ only if it conveys information that the institution does not already hold (Remark `rem:statut_sotp`).

### Entropy budget

An optimal CLO protocol allocates its entropy budget according to application requirements. The total budget defined by

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget\_clo)}$$

equals for instance $296$ bits for $\lambda = 128$ and a Helios voting context with $H(\mathcal{C}) = 40$ bits.

When the application prioritises confidentiality ($\mathsf{Conf}_{\min} = 0.9$), the recommended allocation assigns $60\%$ of the budget to the Gold layer ($\approx 180$ bits), $30\%$ to Iron ($\approx 90$ bits) and the remaining $10\%$ to Clay (aggressive compression of the context). When opposability comes first ($\mathsf{Opp}_{\min} = 0.8$), the proportions are reversed, with $20\%$ for Gold (minimal masking), $30\%$ for Iron (standard binding) and $50\%$ for Clay (rich preservation of the context).

Modular independence of the layers is necessary, because Gold, Iron and Clay must be replaceable without a complete redesign [canetti2001, Goldreich02]. Replacing the PRG by AES-GCM affects neither Iron nor Clay; replacing Pedersen by an RSA accumulator leaves Gold and Clay intact; replacing contextual hashing by a JL representation does not change the first two layers. This modularity eases adaptation to cryptographic (post-quantum, homomorphic) and regulatory developments [NISTPQC, Kyber2022, Dilithium2022].

## 3. S-OTP, prototype

Source: §`subsec:construction_sotp` and §`subsec:metriques_sotp`.

The Gold-Iron-Clay paradigm can be instantiated within the class of XOR-based protocols. The **Semantic One-Time Pad (S-OTP)** construction provides the instance. It serves as the prototype of the SOTP family.

**Theorem `thm:proprietes_sotp` (Security properties of S-OTP).** Under hardness of the discrete logarithm (DLog) in $\mathbb{G}$ and, when the mask is pseudorandom, under the PRG assumption [BlumMicali84, Yao82],

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda), \qquad \mathsf{Opp}(\text{S-OTP}) \leq \frac{H(h \mid C)}{H(V\mid C)}$$

where $h$ is the auxiliary component of the proof that carries the contextual information. With a uniform mask, as in the proof below, $\mathsf{Conf}(\text{S-OTP}) = 1$ with no computational assumption.

**Remark `rem:portee_sotp` (Scope of Theorem `thm:proprietes_sotp`).** The reliability established is verification reliability $\mathsf{Rel}_{\mathrm{ver}}$; reconstruction reliability satisfies $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ as soon as $I(M;\Sigma|C) \leq \kappa/\lambda$ (Remark `rem:rel_ver`). If $h$ is a function of the public context $C$, then $H(h|C) = 0$ and $\mathsf{Opp}(\text{S-OTP}) = 0$. The opposability of S-OTP therefore assumes that $h$ conveys contextual information that the institution does not already hold (private case-specific context). The expression $H(\mathcal{C})/\lambda$ of [MINKA2026CLO] corresponds to the convention $H(h|C) = H(\mathcal{C})$ and $H(V|C) \approx \lambda$.

### Proof (confidentiality)

By the one-time-pad masking construction, $M^* = m \oplus \mathsf{mask}_m$ where $\mathsf{mask}_m \xleftarrow{\$} \lbrace 0,1\rbrace^{|m|}$. For every pair $(m_0, m_1) \in \mathcal{M}$,

$$\mathrm{TV}(P_{M^*|M=m_0}, P_{M^*|M=m_1}) = 0$$

because both distributions are uniform on $\lbrace 0,1\rbrace^{|m|}$. The commitment $c_\Sigma = \mathsf{Com}(M^*)$ inherits this indistinguishability, because the Pedersen commitment is *perfectly* hiding with no computational assumption [Pedersen91]. Hence

$$\mathsf{Conf}(\text{S-OTP}) = 1 - \max_{m_0,m_1} \mathrm{TV}(P_{\Sigma|M=m_0}, P_{\Sigma|M=m_1}) = 1 - \mathrm{negl}(\lambda).$$

### Proof (reliability)

Completeness follows directly from the completeness of the commitment scheme. For every $(m, c)$,

$$\Pr[\mathsf{Verify}(pk, \mathsf{Prove}(sk,m,c), c) = 1] = 1 - \delta_{\mathsf{Com}}$$

where $\delta_{\mathsf{Com}} = \mathrm{negl}(\lambda)$ is the commitment error. To establish *soundness*, suppose that an adversary $\mathcal{A}$ produces $\sigma^* = (c_\Sigma^*, h^*, \ldots)$ with $\mathsf{Verify}(\sigma^*, c) = 1$ without going through $\mathsf{Prove}$. Then $\mathcal{A}$ would have opened the commitment $c_\Sigma^*$ to a valid content; this contradicts the computational *binding* property of the Pedersen scheme under the DLog assumption (probability $\leq \mathrm{negl}(\lambda)$) [Pedersen91]. Hence $\mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) = 1 - \mathrm{negl}(\lambda)$.

### Proof (opposability)

The auxiliary information $h$ encodes $\ell_{\text{aux}} = H(\mathcal{C})$ bits of context. If the interpreter reads the proof only through $(h, C)$, that is, under the chain $V - (h, C) - \Sigma$,

$$I(V;\Sigma|C) \leq I(V;h|C) = H(h|C) - H(h|V,C) \leq H(h|C).$$

Dividing by $H(V|C)$ gives

$$\mathsf{Opp}(\text{S-OTP}) = \frac{I(V;\Sigma|C)}{H(V|C)} \leq \frac{H(h|C)}{H(V|C)}.$$

**Remark `thm:optimalite_sotp` (Heuristic argument for the optimality of S-OTP within the OTP class).** Among protocols that mask the message with a one-time pad and encode the context only in an auxiliary component $h$, S-OTP appears to achieve the best trade-off. Every such protocol indeed devotes $|m| = \lambda$ random bits to masking for perfect security. Its opposability remains bounded by $H(h|C)/H(V|C)$, by the same argument as above. A proof of optimality would require a formal definition of the OTP class and a uniform upper bound within it; we leave it open. According to this heuristic argument, a construction achieving higher opposability would have to either (i) give up information-theoretic confidentiality in favour of computational assumptions, or (ii) use interactive multi-round protocols, or (iii) employ different primitives, beyond the OTP paradigm.

### CLO metrics achieved (illustration)

For the typical parameters $\lambda = 128$, $\Delta = 50$ bits, $H(\mathcal{C}) = 30$ bits, below the threshold $H^\sharp \approx 51$ bits for $\alpha = 1$,

$$\mathsf{Conf}(\text{S-OTP}) \approx 0.999, \qquad \mathsf{Rel}_{\mathrm{ver}}(\text{S-OTP}) \approx 0.999, \qquad \mathsf{Opp}(\text{S-OTP}) \approx \min\left\lbrace 1,\ \frac{50}{30}\right\rbrace = 1.$$

These values are theoretical estimates computed under the PRG and DLog assumptions [Goldreich01, KatzLindell14], without controlled empirical measurement. The product then equals

$$\mathsf{Conf} \cdot \mathsf{Rel}_{\mathrm{ver}} \cdot \mathsf{Opp} \approx 0.998.$$

This value concerns verification reliability and an opposability computed under the convention $\mathsf{Opp} = \min\lbrace 1,\Delta/H(\mathcal{C})\rbrace$ of [MINKA2026CLO]. This convention does not follow from the theorem and assumes that $h$ conveys a case-specific context unknown to the institution. The value obtained is not comparable with the bound of Theorem `thm:trilemme_cro_conditionnel`. In reconstruction reliability, the statistical confidentiality of S-OTP imposes $\mathsf{Rel}_{\mathrm{rec}} \leq (1+\kappa/\lambda)/\lambda$ (Remark `rem:rel_ver`), whereas [MINKA2026CLO] gives a product of order $H(\mathcal{C})/\lambda$. This high product is achievable only below the threshold, that is, for $H(\mathcal{C}) \leq H^\sharp$. Beyond it, opposability is bounded above by $(\kappa/\lambda + \Delta)/\gamma \approx \Delta/(\alpha H(\mathcal{C})) < 1$, a quantity that decreases as $1/H(\mathcal{C})$ (proof of Proposition `prop:borne_aigue`, step 6). This motivates the SOTP-High variant, while SOTP-Base answers the need for proximity between contexts below the threshold.

Remark `thm:optimalite_sotp` indicates that S-OTP would be optimal within its class, without proving it. Even if established, this optimality would remain restricted, because the SOTP-Base and SOTP-High variants use techniques beyond XOR protocols (JL projection, zk-SNARKs) and answer other needs.

## 4. Common architecture of the SOTP family

Source: §`sec:sotp_construction` (introduction) and §`subsec:philosophie_sotp`.

The SOTP family proposes three reference constructions for the two regimes of contextual richness. Below the threshold $H^\sharp$ of the theorem, SOTP-Low and SOTP-Base answer two needs, the exact context or proximity between contexts. Beyond it, SOTP-High takes over.

Three functional layers structure each protocol. The **Gold** layer performs cryptographic masking with a one-time mask, truncated or pseudorandom, for SOTP-Low and SOTP-Base [Shannon49, BlumMicali84]. It relies on zero-knowledge proofs for SOTP-High [GMR85, BenOr88]. The **Iron** layer ensures binding through binding commitments, Pedersen [Pedersen91, ChaumPedersen92] for SOTP-Low/Base and Groth16 [Groth16, BCTV14] for SOTP-High, allowing verifiable opening of the message. Finally, the **Clay** layer presents the institutional context in a form that interpreters with bounded capacity $\Delta$ can exploit to reach their verdicts [Simon82, Miller56]; it increases $\mathsf{Opp}$ only if it conveys information that the institution does not already hold (Remark `rem:statut_sotp`).

The specific contribution of the family lies in its **adaptation to the regime and to the institution's need**. Each SOTP variant specialises the Clay layer with a deterministic encoding, a Johnson-Lindenstrauss representation [JohnsonLindenstrauss84, DasguptaGupta03, Vempala05] or a SNARK-friendly Poseidon hash [Groth16, Poseidon2019].

### Correspondence between CLO metrics and cryptographic properties

| CLO metric | Cryptographic property | Assumptions |
|---|---|---|
| $\mathsf{Conf}$ (statistical notion) | computational counterpart, semantic indistinguishability [GoldwasserMicali84, MicaliRackoff91]: for every pair $(m_0, m_1)$ in the same context $c$, no polynomial adversary distinguishes the proof of $m_0$ from that of $m_1$ with non-negligible advantage | PRG [BlumMicali84, Yao82] when the mask is pseudorandom |
| $\mathsf{Rel}_{\mathrm{ver}}$ (Remark `rem:rel_ver`) | binding [Pedersen91, Damgard87]: no polynomial adversary produces two distinct openings of the same commitment to different messages with non-negligible probability | DLog [DiffieHellman76]; knowledge soundness of Groth16 in the generic or algebraic group model [Groth16, FKL18] |
| $\mathsf{Opp}$ | fraction of extractable information about the verdict, $I(V;\Sigma\mid C)/H(V\mid C)$, quantified through the institutional extraction capacity $\Delta$ (Definition `def:delta_extraction`) | no reduction; depends on institutional interpretation |

The guarantees of confidentiality and verification reliability result from formal reductions to standard cryptographic assumptions. Opposability, by contrast, depends on institutional interpretation and these reductions do not bound it from below.

### Clay layer per regime

| Regime and need | Condition | Clay technique |
|---|---|---|
| scarce, exact context required (SOTP-Low) | $H(\mathcal{C}) \leq H^\sharp$ | deterministic encoding $\phi:\mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$, which conveys the context losslessly [Shannon48] |
| scarce, proximity between contexts required (SOTP-Base) | $H(\mathcal{C}) \leq H^\sharp$ | JL representation [JohnsonLindenstrauss84, Achlioptas2003], which embeds the context in $\mathbb{R}^d$ and then projects it to $\mathbb{R}^k$; for $N$ contexts, $k = O(\log N/\varepsilon^2)$ suffices to preserve distances up to $\varepsilon$ |
| rich (SOTP-High) | $H(\mathcal{C}) > H^\sharp$ | Poseidon hashing [Poseidon2019, Grassi2021] of an arbitrarily complex context into a fixed-size digest ($256$ bits), with structured metadata |

The threshold separating the regimes is that of the theorem (Remark `rem:activite_delta`),

$$H^\sharp = \frac{\Delta + 1 + \kappa/\lambda}{\alpha}.$$

Below this threshold, the institution's capacity covers the context. A functional criterion then decides between SOTP-Low and SOTP-Base. The Lean formalisation certifies the threshold in both directions.

The total entropy budget of each SOTP proof reads

$$H_{\text{total}} = H_{\text{Gold}} + H_{\text{Iron}} + H_{\text{Clay}} \approx 2\lambda + H(\mathcal{C}) \qquad \text{(eq:entropy\_budget)}$$

For $\lambda = 128$ and $H(\mathcal{C}) = 40$ bits (Helios-type voting [Adida08]), this gives $\approx 296$ bits. This budget counts the entropy of the proof, not its length; the JL representation of SOTP-Base thus occupies $k$ real coordinates. It constrains the Clay layer, because preserving too much context may correlate $\Sigma$ with $m$, reducing $\mathsf{Conf}$; compressing too aggressively reduces $\mathsf{Opp}$ because the interpreter can no longer extract the verdicts [Smith09, Alvim12].

## 5. SOTP-Low when the exact context is required

Source: §`subsec:sotp_low`.

For the case where the institution needs the exact context, the thesis proposes a simple deterministic construction and establishes its cryptographic properties (Remark `rem:statut_sotp`).

The target regime is the one where the institution's capacity covers the context, $H(\mathcal{C}) \leq H^\sharp$ (Remark `rem:activite_delta`). The institution needs the exact context there. Below this threshold, the refined bound reduces to the Fano bound, which the Lean formalisation certifies in both directions. Contractual ECDSA signatures [Johnson01, NIST.FIPS.186-5] are the textbook case. A standardised contract and its parties are often parameterised by a context of entropy $H(\mathcal{C}) \approx 20$ bits [Mason07, Kerr04], below the threshold $H^\sharp \approx 36$ bits obtained with $\Delta \approx 35$ bits and $\alpha = 1$.

The idea is to encode the context *deterministically* in the Clay layer, which entails neither compression loss nor a costly circuit. The proof consists of a PRG mask (Gold), a Pedersen commitment (Iron) and a triple $(\phi(c), \mathsf{Hash}(c), V(c))$ (Clay). This last component reveals the context without revealing the message, since $M \perp C$ by construction.

### Algorithm 1 — SOTP-Low (`alg:sotp_low`)

```text
 1  Parameters: λ, (Δ, α, β), H(C) ≤ H♯, exact context required
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

- The deterministic encoding $\phi$ serialises the institutional context $c$ on exactly $H(\mathcal{C})$ bits. This point is specific to SOTP-Low, which conveys the exact context.
- Sampling the seed in $\mathbb{Z}_q$ is necessary. With $s \in \lbrace 0,1\rbrace^\lambda$ and a commitment to $\mathsf{int}(s) \bmod q$, two seeds $s$ and $s+q$ would yield the same commitment, which would destroy binding.
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

**Part I. Computational confidentiality.** The distribution of $\sigma$ given $M = m_i$ depends on $m_i$ only through $\sigma_1$. Indeed, $\sigma_2$ is perfectly hiding (for every $s$, $g^s h^\rho$ is uniform in $\mathbb{G}$ when $\rho$ is uniform), while $\sigma_3$ depends only on $c$, which is independent of $m$ ($M \perp C$). Suppose that a PPT distinguisher $\mathcal{D}$ distinguishes $m_0 \oplus \mathsf{PRG}(s)$ from $m_1 \oplus \mathsf{PRG}(s)$ with non-negligible advantage $\mu(\lambda)$. The adversary $\mathcal{B}$ receives $y$ (PRG output or uniform string), samples $b$, submits $m_b \oplus y$ to $\mathcal{D}$ and answers "PRG" if $\mathcal{D}$ recovers $b$. It distinguishes the PRG with advantage at least $\mu(\lambda) - 1/q$ (Theorem `thm:ann_sotp_low_conf`), since when $y$ is uniform, $m_b \oplus y$ carries no information about $b$. This contradicts PRG security [BlumMicali84]. The IND-CONF advantage of every PPT adversary is therefore negligible. Confidentiality is computational. In the statistical sense of Definition `def:confidentialite_clo`, it is guaranteed as soon as the mask is uniform or statistically close to uniform (Remark `rem:masque_troncature`).

**Part II. Verification reliability.** *Completeness.* For every honest proof, $\mathsf{Hash}(c) = \sigma_3.\mathsf{hc}$ and $\phi(c) = \sigma_3.h_c$ by construction, $\sigma_2 \in \mathbb{G}$ by closure of the group; finally $\mathsf{Open}$ accepts the honest witness $(m, s, \rho)$. Completeness is perfect.

*Binding (reduction to DLog).* Suppose that a PPT adversary produces a proof $\sigma$ and two accepted openings $(m_0, s_0, \rho_0)$ and $(m_1, s_1, \rho_1)$ with $m_0 \neq m_1$. Since $\sigma_1 = m_0 \oplus \mathsf{PRG}(s_0) = m_1 \oplus \mathsf{PRG}(s_1)$ and $m_0 \neq m_1$, we have $s_0 \neq s_1$ in $\mathbb{Z}_q$. The equality $g^{s_0} h^{\rho_0} = g^{s_1} h^{\rho_1}$ then forces $\rho_0 \neq \rho_1$ and

$$\log_g h = \frac{s_0 - s_1}{\rho_1 - \rho_0} \bmod q,$$

which contradicts the hardness of the discrete logarithm [DiffieHellman76]. The BIND-REL winning probability is therefore negligible, hence $\mathsf{Rel}_{\mathrm{ver}}(\mathrm{SOTP\text{-}Low}) = 1 - \mathrm{negl}(\lambda)$. $\square$

**Remark `rem:masque_troncature` (Mask by truncation).** The seed $s$ is uniform in $\mathbb{Z}_q$ with $|q| \geq 2\lambda$, hence longer than the $\lambda$-bit mask. The function $G(s) = s \bmod 2^\lambda$ is then suitable as a mask-derivation function. With $r = q \bmod 2^\lambda$, the statistical distance between $G(s)$ and a uniform string equals $r(2^\lambda - r)/(q\,2^\lambda) \leq 2^\lambda/(4q) \leq 2^{-\lambda-1}$. For $h \neq 1$, the commitment $\sigma_2$ is uniform and independent of $s$. It follows that $\mathrm{TV}(P_{\sigma|m_0,c}, P_{\sigma|m_1,c}) \leq 2^{-\lambda}$, hence $\mathsf{Conf}(\mathrm{SOTP\text{-}Low}) \geq 1 - 2^{-\lambda}$ in the statistical sense and a negligible leakage $I(M;\Sigma|C)$. For a group of order $q \approx 2^{252}$ and $\lambda = 128$, the bound $2^\lambda/(4q)$ gives $2^{-126}$, which is still negligible. Confidentiality becomes statistical, which strengthens part 1 of Proposition `thm:saturation_sotp_low` without changing it. Binding uses no property of $G$ and is unchanged. The reduction of part 1 is mechanised in Lean, in a reduced setting, for every function $G$ (Annex `chap:annexe_gamebased`).

### Illustration: ECDSA signatures

As an illustration, with no validation value (the CLO metrics of ECDSA are analytical parametric estimates derived from the published specifications [Johnson01, NIST.FIPS.186-5] and ECDSA is not an instance of the theorem, Remark `rem:portee_cas_etude`), the parameters $\Delta = 35$ bits, $\lambda = 128$ give for the SOTP-Low heuristic the value $0.75 \times 35/128 \approx 0.205$. This value is not comparable with the CLO product of ECDSA ($0.273$).

## 6. SOTP-Base when proximity between contexts matters

Source: §`subsec:sotp_base`.

When the institution compares contexts, the thesis proposes a construction based on the Johnson-Lindenstrauss representation [JohnsonLindenstrauss84], which preserves distances between contexts up to $\varepsilon$.

Helios [Adida08, Adida09UCL] is the archetype. The electoral context (voter register, election rules, official report) represents $H(\mathcal{C}) \approx 40$ bits for a medium-size election (table `tab:parametres_reference`). The capacity of a committee of specialised guarantors is estimated at $\Delta \approx 56$ bits, that is, $H^\sharp \approx 48$ bits for $\alpha = 1.2$. Usage decides the variant. Size plays no role, since the exact encoding would fit in a few tens of bits. The guarantors compare elections and spot discrepancies, which requires a representation in which two close contexts remain close. An election whose context exceeded $H^\sharp$ would fall under SOTP-High.

The Johnson-Lindenstrauss representation [JohnsonLindenstrauss84, DasguptaGupta03, Achlioptas2003] embeds the context in a space of dimension $d = \Theta(\Delta \cdot H(\mathcal{C}))$ and then projects it to $k = O(\log N/\varepsilon^2)$ dimensions through a random matrix $\Phi$, for $N$ contexts, preserving distances up to a factor $1 \pm \varepsilon$. That extractable information is preserved in the same proportion is a design assumption that the lemma does not guarantee.

### Algorithm 2 — Construction of SOTP-Base with JL representation (`alg:sotp_base`)

```text
 1  Parameters: λ, (Δ, α), H(C) ≤ H♯, proximity between contexts required, ε = 0.1
 2  Setup(1^λ):
 3      Generate (G, q, g, h), PRG, Hash as in SOTP-Low
 4      Receive d = ⌈4 Δ H(C) / ε²⌉ from Algorithm 4 (alg:selection_variante_sotp)
 5      Set k ← ⌈4 ln N / (ε²/2 − ε³/3)⌉,  N = 2^{H(C)}
 6      Generate JL matrix Φ ←$ N(0, 1/k)^{k×d}      [DasguptaGupta03, Vempala05]
 7      Return pk = (G, q, g, h, PRG, Hash, Φ, k, d)
 8  Prove(pk, m, c):
 9      Gold and Iron layers identical to SOTP-Low
10      // JL Clay
11      c⃗ ← embed(c) ∈ R^d
12      σ3 ← Φ c⃗ ∈ R^k
13      Return σ = (σ1, σ2, σ3)
14  Verify(pk, σ, c):
15      Check σ3 = Φ · embed(c)  (up to representation rounding)
16      Check σ2 ∈ G
```

Construction points stated in the thesis text.

- SOTP-Base shares the Gold and Iron layers of SOTP-Low unchanged. The Clay layer replaces the bijective deterministic encoding by a Johnson-Lindenstrauss representation. This substitution answers a functional need. The institution compares contexts and must find their proximity in the proof, which the exact encoding does not make apparent.
- The embedding dimension $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ (line 4) calibrates the intermediate representation space on the product of the institutional extraction capacity $\Delta$ and the contextual entropy. The richer the context and the more the institution can extract from it, the wider the representation must be to preserve the relevant semantic distances.
- The target dimension (line 5) is $k = \lceil 4\ln N/(\varepsilon^2/2 - \varepsilon^3/3) \rceil$, with $N = 2^{H(\mathcal{C})}$ contexts assumed equiprobable. It determines the size of the Clay layer transmitted in the proof. It is calibrated on the Dasgupta-Gupta bound [DasguptaGupta03] (Lemma `lem:johnson_lindenstrauss`), which guarantees that a projection preserving distances up to $\varepsilon = 0.1$ exists. A margin on $k$ makes this preservation very likely for all pairs (Theorem `thm:ann_sotp_base_opp`).
- The matrix $\Phi$ (line 6) is drawn at random from a centred Gaussian of variance $1/k$. This normalisation ensures that Euclidean norms are preserved in expectation, a property on which the JL guarantee rests.
- The function $\mathsf{embed}$ (line 11) translates the semantic structure of the context into a real vector, so that two semantically close contexts produce close vectors in Euclidean distance. Line 12 projects this $d$-dimensional vector to a space of $k \ll d$ dimensions. The transmitted proof $\sigma_3$ is therefore the projection of the context, distinct from the context itself and from its exact encoding.
- The $\mathsf{Verify}$ phase (lines 14 to 16) recomputes $\Phi \cdot \mathsf{embed}(c)$ and compares it with $\sigma_3$. The matrix $\Phi$ is public and fixed at $\mathsf{Setup}$, so the equality is exact; the tolerance only covers the rounding of the representation of reals. The parameter $\varepsilon$ governs the distortion of distances between contexts and plays no role in verification. It sets the trade-off between the fidelity of the representation and the dimension $k$ of the transmitted proof.
- With $\varepsilon = 0.1$, $\Delta = 56$ and $H(\mathcal{C}) = 40$, the embedding dimension is $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil = 896{,}000$ and the target dimension $k = 23{,}766$. Preserving all pairs with probability $1 - 10^{-6}$ requires $k \approx 83{,}100$ (Theorem `thm:ann_sotp_base_opp`).

### Proposition `thm:saturation_sotp_base` (Cryptographic properties of SOTP-Base)

Under PRG security [BlumMicali84] and DLog hardness [DiffieHellman76], since the Gold and Iron layers of SOTP-Base are identical to those of SOTP-Low, SOTP-Base satisfies the two properties of Proposition `thm:saturation_sotp_low`, namely computational confidentiality and $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$ for the opening procedure. Moreover, for all contexts $c, c'$, with probability at least $1 - \delta$ over the draw of $\Phi$, where $\delta \leq 2/N^2$ for the $k$ of line 5,

$$\|\Phi\,\mathsf{embed}(c) - \Phi\,\mathsf{embed}(c')\|^2 \in (1 \pm \varepsilon)\|\mathsf{embed}(c) - \mathsf{embed}(c')\|^2$$

(Lemma `lem:johnson_lindenstrauss`).

*Proof.* The arguments of Proposition `thm:saturation_sotp_low` apply unchanged to the Gold and Iron layers; the Clay layer plays no role in confidentiality (it depends only on $c$, which is independent of $m$) nor in binding. The last property is the Johnson–Lindenstrauss lemma applied to the finite set of context embeddings. $\square$

**Remark `rem:heuristique_sotp_base` (Design heuristic of SOTP-Base, unproven).** The initial formulation of this result stated $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0.5 \cdot \min\lbrace\Delta/d,\ \beta\log_2 d/d\rbrace$. The formalisation led to replacing it for the reasons given in Remark `rem:facteur_limitant_low`. Indeed, $\sigma_3 = \Phi\,\mathsf{embed}(c)$ is a function of the public context, hence $I(V;\sigma_3|C) = 0$; distance preservation does not imply preservation of extractable information; finally, a lower bound cannot be deduced from an upper bound. The expression $0.5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$, a sizing form distinct from the initial formulation, is kept as a sizing heuristic for the Clay layer. As soon as $d > \beta\log_2 d$, it reduces to $0.5\,\Delta/d$.

### Illustration: Helios electronic voting

As an illustration, the SOTP-Base heuristic for the analytical parameters of Helios [Adida08, MINKA2026CRO] ($\Delta = 56$ bits, $\beta = 1.4$, $d = 560$) gives $0.5 \times \min\lbrace 56/560,\ 56/(1.4 \log_2 560)\rbrace \approx 0.050$. This value is not comparable with the CLO product of Helios ($0.437$), which concerns $\mathsf{Rel}_{\mathrm{ver}}$ and is not an instance of the theorem (Remark `rem:portee_cas_etude`). The dimension $d = 560$ used here is a sizing choice, distinct from the rule $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2\rceil$.

## 7. SOTP-High beyond the capacity threshold

Source: §`subsec:sotp_high`.

For rich contexts, the thesis proposes a construction based on succinct Groth16 zk-SNARKs, which protects the witness (zero knowledge) at the price of reduced opposability.

Financial compliance through zk-SNARKs [Groth16, Garratt15, BaselIII] illustrates this regime, where complex transactions, multi-jurisdictional regulations and long histories produce $H(\mathcal{C}) \approx 70$–$90$ bits, beyond the threshold $H^\sharp \approx 49$ bits obtained with $\Delta \approx 73$ bits and $\alpha = 1.5$. The institution's capacity no longer covers the entropy of the verdicts, $\gamma = \alpha H(\mathcal{C}) - 1 = 104$ bits for $H(\mathcal{C}) = 70$ [Simon82, Miller56]. Conveying the context or its representation to it would no longer serve the verdict; a statement about this context must be certified without revealing the message.

Succinct zk-SNARKs (Groth16 [Groth16, BCTV14, Gennaro13]) remove this obstacle by producing a constant-size proof ($128$ bytes on BN254 [BarretoNaehrig2006], in compressed points) independent of the complexity of the verified circuit. Succinctness breaks the linear coupling between $H(\mathcal{C})$ and proof size. This solution has a twofold cost. A trusted setup step is required [Bowe2017]. Opposability is also reduced, capped by the entropy loss of the hash that compresses the context into 256 bits.

*Footnote of the manuscript.* BN254 is chosen for the size of its proofs. Since the extended tower number field sieves [KimBarbulescu2016], it offers about $100$ bits of security; the value $\lambda = 128$ is therefore nominal on this curve. Likewise, the order $q \approx 2^{252}$ of the groups used meets the condition $|q| \geq 2\lambda$ only to within a few bits.

### Algorithm 3 — Construction of SOTP-High with Groth16 zk-SNARKs (`alg:sotp_high`)

```text
 1  Parameters: λ, (Δ, α), H(C) > H♯, circuit C_circuit
 2  Setup(1^λ, C_circuit):
 3      sample τ, α_s, β_s, γ_s, δ_s ←$ F_p^*  (toxic)
 4      Build pk_prove and vk_verify (Groth16 CRS)      [Groth16, BCTV14]
 5      // Destroy toxic waste: τ, α_s, β_s, γ_s, δ_s
 6      (g, h) ←$ G² for the Iron layer
 7      Return pk = (pk_prove, vk_verify, g, h)
 8  Prove(pk, m, c):
 9      // Gold + Iron (Groth16 + Pedersen)
10      ρ ←$ Z_q ;  c_m ← g^m · h^ρ                         [Pedersen91]
11      h_c ← Poseidon(c) [Poseidon2019, Grassi2021] ;  π ← Groth16.Prove(pk_prove, (h_c, c_m), (m, c, ρ))
12      relation: h_c = Poseidon(c) ∧ c_m = g^m h^ρ ∧ Conforme(m, c) = 1
13      // Clay: hash digest + metadata
14      Return σ = (h_c, π, c_m, metadata)
15  Verify(σ, c):
16      b0 ← [h_c = Poseidon(c)] ;  b1 ← Groth16.Verify(vk_verify, (h_c, c_m), π)
17      b2 ← [c_m ∈ G]
18      Return b0 ∧ b1 ∧ b2
```

Construction points stated in the thesis text.

- In the regime $H(\mathcal{C}) > H^\sharp$, the institution's capacity no longer covers the context and a faithful representation of the context in the proof would no longer serve the verdict. The threshold is that of the theorem, certified in Lean in both directions. Instead of conveying the context or its representation, one conveys a *proof of knowledge* of a message compliant with the context through a Groth16 zk-SNARK.
- Line 5 is a security imperative. If any of the five toxic scalars $\tau, \alpha_s, \beta_s, \gamma_s, \delta_s$ survived the $\mathsf{Setup}$, its holder could forge valid proofs for any statement. In practice, this destruction is carried out through a multi-party step in which the simultaneous compromise of all participants would be needed to reconstruct the toxic values. The pair $(g, h)$ of the Iron layer is independent of the Groth16 CRS.
- The proof $\pi$ attests that the prover knows $(m, c, \rho)$ such that $h_c = \mathsf{Poseidon}(c)$, $c_m = g^m h^\rho$ and the compliance predicate $\mathsf{Conforme}(m, c)$ holds; this relation binds the commitment to the context and to the proven statement.
- The $\mathsf{Verify}$ phase receives the public context $c$, as in the CLO model. It first checks that $h_c = \mathsf{Poseidon}(c)$ ($b_0$), then the validity of the Groth16 proof ($b_1$) and the membership of $c_m$ in the group ($b_2$). The conjunction $b_0 \wedge b_1 \wedge b_2$ suffices to establish that the prover knew a message $m$ compliant with a context of digest $h_c$. This context is $c$, barring a collision of $\mathsf{Poseidon}$.
- The contextual information the arbiter can extract from $h_c$ is bounded by the size of the digest ($256$ bits). It is even zero if $c$ is already known to the institution. What the proof contributes to the verdict lies in the certified statement ($\mathsf{Conforme}(m,c) = 1$), not in the digest.

An executable implementation of this algorithm (Circom/Groth16) is provided separately in [`../high/`](../high/).

### Proposition `thm:saturation_sotp_high` (Cryptographic properties of SOTP-High)

Under the *knowledge soundness* of Groth16, established in the generic group model [Groth16] and in the algebraic group model under q-DLog [FKL18], DLog hardness, the collision resistance of $\mathsf{Poseidon}$ [Poseidon2019] and an honest trusted setup ceremony [Bowe2017]:

1. the proof $\pi$ is perfectly zero-knowledge and $c_m$ is perfectly hiding, so that $(\pi, c_m)$ reveals nothing about $m$ beyond the public inputs;
2. completeness is perfect and, by *knowledge soundness*, for every PPT prover that makes $\sigma$ accepted, there exists an *extractor* (which exploits the algebraic representation of the elements produced by the prover, unlike the verifier) producing a witness $(m, c, \rho)$ satisfying the relation; hence $\mathsf{Rel}_{\mathrm{ver}} = 1 - \mathrm{negl}(\lambda)$.

Confidentiality is understood between messages compliant with the same context, the only messages for which $\mathsf{Prove}$ is defined. The assumption $M \perp C$ then requires the distribution of $M$ to charge only messages compliant with every possible context.

*Proof (summary of the manuscript).* (1) With an honest CRS, Groth16 is perfectly zero-knowledge and the Pedersen commitment $c_m$ is uniform on $\mathbb{G}$ whatever $m$. The pair $(\pi, c_m)$ therefore has the same distribution as a uniform commitment together with a proof simulated from the public inputs alone. (2) Knowledge soundness provides an extractor. The collision resistance of $\mathsf{Poseidon}$ guarantees that the context of the extracted witness is the public context $c$ checked by $b_0$. The binding of $c_m$, under DLog, prevents two extracted witnesses from concerning distinct messages. $\square$

**Remark `rem:heuristique_sotp_high` (Design heuristic of SOTP-High, unproven).** The initial formulation of this result stated $\mathsf{Conf} \cdot \mathsf{Rel} \cdot \mathsf{Opp} \geq 0.45 \cdot \beta\log_2\lambda/\lambda$, with a constant $0.45$ "calibrated" on deployed systems. The formalisation led to replacing it, for four reasons. The digest $h_c = \mathsf{Poseidon}(c)$ and the metadata are functions of the public context ($I(V;h_c|C) = 0$). Three group elements represent $\Theta(\lambda)$ bits, not $O(\log\lambda)$. The verifier cannot extract the witness, otherwise the proof would not be zero-knowledge. Finally, a constant fitted on data has no place in a theorem statement. The expression $0.45\,\beta\log_2\lambda/\lambda$ is kept as a design heuristic; $\beta$ denotes the regularity constant of the protocol (Definition `def:beta_regularite`).

### Illustration: zk-SNARK compliance

For the analytical parameters $\Delta = 73$ bits, $\alpha = 1.5$, $\beta = 1.5$, $\lambda = 128$ (parametric estimates without controlled empirical measurement), the SOTP-High heuristic gives $0.45 \times 1.5 \times 7/128 \approx 0.037$. This value is not comparable with the CLO product of compliance zk-SNARKs ($\approx 0.572$), which concerns $\mathsf{Rel}_{\mathrm{ver}}$ and is not an instance of the theorem (Remark `rem:portee_cas_etude`).

## 8. Synthesis and variant selection

Source: §`subsec:synthese_selection`.

### Table `tab:comparaison_sotp_construction` — Comparison of SOTP variants

| Criterion | SOTP-Low | SOTP-Base | SOTP-High |
|---|---|---|---|
| ***Operating regime*** | | | |
| Entropy $H(\mathcal{C})$ | $\leq H^\sharp$, exact context required | $\leq H^\sharp$, proximity required | $> H^\sharp$ |
| Calibration ($\lambda = 128$) | $20 \leq 36$ bits | $40 \leq 48$ bits | $70 > 49$ bits |
| ***Cryptographic techniques*** | | | |
| Gold layer | truncated mask or PRG [BlumMicali84] | same | perfect ZK (Groth16) [Groth16] |
| Iron layer | Pedersen [Pedersen91] | Pedersen [Pedersen91] | knowledge soundness (GGM or AGM) [Groth16, FKL18] |
| Clay layer | $\phi:\mathcal{C}\to\lbrace 0,1\rbrace^{H(\mathcal{C})}$ | JL $\Phi:\mathbb{R}^d\to\mathbb{R}^k$ [JohnsonLindenstrauss84] | Poseidon + SNARK [Poseidon2019] |
| Primitives | SHA-256, Pedersen | Gaussian, Pedersen | Groth16, Poseidon, BN254 [BarretoNaehrig2006] |
| ***CLO metrics achieved*** | | | |
| Confidentiality | statistical (truncation) or computational (PRG) | same | perfect ZK |
| $\mathsf{Rel}_{\mathrm{ver}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{DLog}}$ | $1 - \epsilon_{\text{KS}} - \epsilon_{\text{DLog}}$ |
| $\mathsf{Opp}$ | depends on the case-specific context conveyed | same | same |
| ***Design heuristic (unproven)*** | | | |
| Expression | $0.75 \cdot \Delta/\lambda$ | $0.5 \cdot \min\lbrace\Delta/d,\ \Delta/(\beta\log_2 d)\rbrace$ | $0.45 \cdot \beta\log_2\lambda/\lambda$ |
| Trusted setup | No | No | Yes [Bowe2017] |
| ***Illustration (not comparable with CLO products)*** | | | |
| Reference system | ECDSA [Johnson01] | Helios [Adida08] | compliance zk-SNARKs [Groth16] |
| Value of the heuristic | $\approx 0.205$ | $\approx 0.050$ | $\approx 0.037$ |
| CLO product ($\mathsf{Rel}_{\mathrm{ver}}$ scale) | $\approx 0.273$ | $\approx 0.437$ | $\approx 0.572$ |

In the table, $\epsilon_{\text{KS}}$ denotes the advantage of a prover against the knowledge soundness of Groth16 and $\epsilon_{\text{DLog}}$ that of an adversary against the discrete logarithm. The association of each reference system with a variant is illustrative. It follows the threshold $H^\sharp$ and the functional criterion of Algorithm `alg:selection_variante_sotp`, with the calibration parameters (table `tab:parametres_reference`).

The three variants cover the whole spectrum of contextual entropy. SOTP-Low favours readability of the exact context below the threshold $H^\sharp$. It suits legal or contractual applications [Mason07, Kerr04]. SOTP-Base preserves proximity between contexts, which makes it suitable for governmental and electoral applications [Adida08, Goodman15]. SOTP-High sacrifices opposability for perfect confidentiality and scalability. It serves financial or medical applications with very rich contexts [Garratt15, BaselIII].

### Algorithm 4 — Automatic SOTP variant selection (`alg:selection_variante_sotp`)

```text
 1  Inputs: H(C), Δ, α, κ, λ, Need ∈ {exact, proximity}, TrustedSetup_OK
 2  H♯ ← (Δ + 1 + κ/λ) / α
 3  if TrustedSetup_OK = False and H(C) > H♯ then
 4      ALERT: SOTP-High required but trusted setup unavailable   [Bowe2017]
 5      Recommend: variant matching the need, with loss of opposability, or deploy MPC
 6      Return SOTP-Low if Need = exact, otherwise SOTP-Base
 7  end if
 8  if H(C) > H♯ then
 9      Return SOTP-High ;  compile circuit C_circuit
10  else if Need = exact then
11      Return SOTP-Low
12  else
13      Return SOTP-Base ;  d ← ⌈4 Δ H(C) / ε²⌉
14  end if
```

This algorithm is a deployment meta-algorithm, distinct from the cryptographic constructions. It takes as input the parameters of the institutional context and returns the suitable SOTP variant, taking into account the mathematical properties of the context and the operational constraints of the deployment environment.

Line 2 computes the threshold $H^\sharp$ of the theorem (Remark `rem:activite_delta`). It separates the regime in which the institution's capacity covers the context from the one in which it becomes the binding constraint. The Lean formalisation certifies it in both directions. It increases with $\Delta$ and decreases with $\alpha$. Below this threshold, the choice between SOTP-Low and SOTP-Base is functional. It depends on what the institution needs, the exact context or proximity between contexts. The quantities $\sqrt{\lambda}$ and $\lambda/\log_2\lambda$ of the initial formulations do not define the regimes; they remain indications of encoding size.

Lines 3 to 7 form the operational safety guard, which is the most important part of the algorithm from the deployment point of view. SOTP-High requires a trusted setup step to generate the Groth16 CRS. This step may not have been carried out, for lack of resources to organise a multi-party protocol or because the regulatory context does not allow it. If the context nevertheless exceeds $H^\sharp$, the algorithm raises an explicit alert and does not silently degrade security. It then recommends either accepting the variant that answers the institution's need, SOTP-Low or SOTP-Base, with the loss of opposability associated with a context beyond the threshold, or deploying an MPC protocol to perform the trusted setup in a distributed way.

Lines 8 to 14 perform the selection itself. If $H(\mathcal{C})$ exceeds $H^\sharp$ and the trusted setup is available, SOTP-High is selected. Below the threshold, SOTP-Low is chosen when the institution needs the exact context, with no additional parameter. Otherwise SOTP-Base is selected and the embedding dimension $d = \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ is computed immediately. This computation is done at selection time rather than in $\mathsf{Setup}$, so that $d$ can be adapted to the actual value of $H(\mathcal{C})$ observed at deployment. For SOTP-High, the arithmetic circuit $\mathcal{C}_{\text{circuit}}$ is compiled. Since this compilation is the most expensive operation of the process, it is triggered only if the context exceeds the threshold.

The selection logic thus follows two criteria. Below the threshold, the institution's need decides. SOTP-Low serves the exact context (minimal cost, no external dependency) and SOTP-Base proximity between contexts (no trusted setup). SOTP-High is deployed only when contextual richness makes it unavoidable and operational conditions allow it.

### Five-phase design methodology

1. **Application analysis.** Estimate $H(\mathcal{C})$ and identify the minimal requirements $\mathsf{Conf}_{\min}$, $\mathsf{Rel}_{\min}$, $\mathsf{Opp}_{\min}$.
2. **Institutional assessment.** Estimate $\Delta$ (deliberation capacity, expertise, institutional memory) and $\alpha$ (verdict granularity). These estimates are analytical, since direct measurement through controlled cognitive protocols remains future work.
3. **Feasibility test.** Check the inequality
   $$\mathsf{Conf}_{\min} \cdot \mathsf{Rel}_{\mathrm{rec},\min} \cdot \mathsf{Opp}_{\min} \stackrel{?}{\leq} \frac{1+\kappa/\lambda}{\lambda}\,\min\left\lbrace 1, \frac{\kappa/\lambda + \Delta}{\gamma}\right\rbrace \qquad \text{(eq:test\_faisabilite\_sotp)}$$
   for requirements expressed in reconstruction reliability (equation `eq:trilemme_cro_raffine`). If the inequality is violated, one may relax a requirement, increase $\Delta$ through investment in institutional training (effective only if $\Delta < \gamma$) or revise verdict granularity. Requirements expressed in verification reliability $\mathsf{Rel}_{\mathrm{ver}}$ are not constrained by this test.
4. **Selection and parameterisation.** Apply Algorithm `alg:selection_variante_sotp` and optimise the Gold/Iron/Clay primitives in the identified regime.
5. **Proofs and validation.** Establish the formal reductions to standard assumptions, then measure $\Delta$ and the opposability obtained according to the protocols of Chapter `chap:experimentation`.

## 9. Universal optimality conjecture and sensitivity analysis

Source: §`subsec:optimalite_sensibilite`.

**Conjecture `conj:optimalite_universelle` (Universal optimality of SOTP).** Consider a model in which the Clay layer conveys a case-specific context that the institution does not hold. Under Assumptions `ass:extraction_bornee`–`ass:regime`, for each regime of contextual richness, there exist an SOTP variant and a constant $C_R \geq 1$ independent of $\lambda$, $\Delta$ and $\gamma$ such that, for every CLO protocol $\mathcal{P}'$ of the same regime whose leakage $I(M;\Sigma|C)$ is negligible (in particular $\kappa = 0$),

$$\mathsf{Opp}(\mathcal{P}') \ \leq\ C_R \cdot \mathsf{Opp}(\text{SOTP}). \qquad \text{(eq:optimalite\_universelle)}$$

For these protocols, reconstruction reliability is negligible (Proposition `prop:borne_aigue`) and opposability is bounded above by $\min\lbrace 1, (\kappa/\lambda + \Delta)/\gamma\rbrace$. The SOTP-Low and SOTP-Base variants belong to this class as soon as the mask is truncated (Remark `rem:masque_troncature`). SOTP-High belongs to it by perfect zero knowledge.

**Remark `rem:statut_optimalite` (Status and heuristic argument).** The initial formulation of this statement was presented as a theorem in the form $\text{product}(\mathcal{P}') \leq c \cdot \text{product}(\text{SOTP}) + o(1)$ with $c \in [0.45;\,0.75]$. It was replaced by a more precise formulation, for four reasons. (i) With $c < 1$ and $\mathcal{P}' = \text{SOTP}$, it would give $\text{product} \leq 0.75 \times \text{product}$, which forces $C_R \geq 1$; (ii) the additive term $o(1)$ dominates products that are all $O(1/\lambda)$; (iii) its argument invoked the trilemma without Assumption `ass:regime`; (iv) it relied on the lower bounds of Remarks `rem:facteur_limitant_low`, `rem:heuristique_sotp_base` and `rem:heuristique_sotp_high`, which are design heuristics. The retained statement compares opposabilities under negligible leakage. For these protocols, opposability is bounded above by $\min\lbrace 1, (\kappa/\lambda + \Delta)/\gamma\rbrace$ and the explicit distribution of Remark `rem:temoin_realisable`, taken with $\min\lbrace \Delta, \gamma\rbrace$ bits, achieves $\min\lbrace 1, \Delta/\gamma\rbrace$. The argument therefore aims at bounding the opposability of the SOTP variant of the regime from below by a constant fraction of this value. The constant $C_R$ depends neither on $\lambda$, nor on $\Delta$, nor on $\gamma$. Without this requirement, the statement would hold as soon as $\mathsf{Opp}(\text{SOTP})$ is positive and independent of $\lambda$, with $C_R = 1/\mathsf{Opp}(\text{SOTP})$. This step remains open. In the current model, the Clay layer is a function of the public context and the opposability of SOTP is zero (Remark `rem:facteur_limitant_low`). The statement would be false there against the explicit distribution. The conjecture is therefore posed in a model in which the Clay layer conveys a case-specific context that the institution does not hold (perspective developed in Chapter `chap:resultats_discussions`).

*Justification of reasons (i) and (ii), after the manuscript.* (i) With $\mathcal{P}' = \text{SOTP}$, the multiplicative form gives $p \leq C_R\,p$ for the opposability $p > 0$ of the variant, which forces $C_R \geq 1$. With a factor $c < 1$ and no additive term, it would give $p \leq c\,p < p$, which is impossible. (ii) The products are bounded above by $(1+\kappa/\lambda)/\lambda = O(1/\lambda)$ (Remark `rem:activite_delta`). An additive term $o(1)$ such as $\lambda^{-1/2}$ exceeds this quantity for large $\lambda$ and makes the inequality vacuous.

### Sensitivity analysis

The analysis concerns the refined bound (`eq:trilemme_cro_raffine`), which is the only proven statement, as well as the design heuristics.

- **Sensitivity to $\Delta$.** In the context-rich regime ($\Delta < \gamma$), the bound is proportional to $\kappa/\lambda + \Delta$. Raising $\Delta$ from $50$ to $65$ bits (intensive training of guarantors [Ericsson95]) raises the bound by about $30\%$. In the context-scarce regime ($\Delta \geq \gamma$), the bound is the Fano bound and does not depend on $\Delta$.
- **Sensitivity to $\alpha$.** In the context-rich regime, the bound varies as $1/\gamma = 1/(\alpha H(\mathcal{C}) - 1)$, so that coarser verdicts (going from 12 levels to 6) raise the bound and may move the institution into the context-scarce regime. Institutions with highly nuanced verdicts (fine risk scales, graduated fine amounts) thus pay a real penalty. The optimum between decision precision and the CRO trade-off depends on application priorities.
- **Sensitivity to $\beta$.** The constant $\beta$ does not appear in the bound; it enters the confidentiality guarantee of Lemma `lem:confidentiality_guarantee`, where a more regular protocol (smaller $\beta$) tightens that guarantee. In the SOTP-High heuristic, which is proportional to $\beta$, going from $\beta = 1.5$ to $\beta = 1.2$ *decreases* the value by $20\%$. $\beta$ is a property of the proof distributions (KL divergence) and does not depend on the hash function used in the circuit.

## 10. Quantum extension

Source: §`subsec:extension_postquantique_sotp`.

- **Post-quantum SOTP-Low.** The Gold layer can use hash-based PRGs (whose security Grover's algorithm [Grover96] reduces from $\lambda$ to $\lambda/2$ bits). The Pedersen commitment remains perfectly hiding, but its binding rests on DLog, which Shor's algorithm solves. It must therefore be replaced by a post-quantum commitment, for example a lattice-based one under SIS/LWE [Peikert2016].
- **Post-quantum SOTP-Base.** The JL projection is independent of the adversary model [JohnsonLindenstrauss84, DasguptaGupta03]. The adaptations concern the Gold and Iron layers with post-quantum primitives (lattice-based commitment [Peikert2016], ML-DSA signatures [Dilithium2022]).
- **Post-quantum SOTP-High.** Groth16 zk-SNARKs require particular attention [Unruh2016, Chatterjee2021]. Their knowledge soundness is established in the generic and algebraic group models (under q-DLog). It rests on pairing groups whose discrete logarithm Shor's algorithm solves. STARKs [BenSasson2019], which rely only on hash functions, are the post-quantum alternative; Bulletproofs [Bulletproofs2018] rely on DLog and are not post-quantum.

The interpretability-loss coefficient $\eta_q$ (Definition `def:perte_interp_quantique`) applies to all variants when the proof travels over a quantum medium

$$\mathsf{Opp}^q \geq \mathsf{Opp} - \eta_q\,\frac{H(C)}{H(V|C)},$$

and $\eta_q = 0$ when the proof remains a classical bit string.

## 11. Transcription notes

These notes flag points of the source text without modifying the statements.

<a id="t4"></a>**T4 (resolved).** In the earlier version, Annex A wrote the projection $\Phi : \mathbb{R}^n \to \mathbb{R}^d$, with $d$ as output dimension, and line 5 of Algorithm 2 did not specify the base of the logarithm. The revised manuscript unifies the notation. Throughout, $d$ is the embedding dimension and $k$ the target dimension ($\Phi : \mathbb{R}^d \to \mathbb{R}^k$). Line 5 now gives $k$ explicitly through the Dasgupta-Gupta bound, with the natural logarithm. The sizing theorem of Annex A concerns $k$, with the constant $12$.
