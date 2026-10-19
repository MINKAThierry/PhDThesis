# Limiting case of Theorem 1 of P2 in its initial formulation

> **Status: PROPOSAL — submitted refined statements** · Source: refined statements submitted for P2 ([`../../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/)); thesis, `rem:scope_trilemme_classique` (Remark 2.17, §2.3.2) and §3.4.9

[Version française](README_fr.md)

The script [`cas_limite.py`](cas_limite.py) computes in high precision (`mpmath` library, 60 digits) the quantities of a protocol that is a limiting case for two statements of article P2 in their initial formulation. It was used to establish the submitted refined statements. The statements of the thesis cover this protocol, which departs from the regime of Assumption 4.

## Protocol studied

- The proof $\Sigma$ equals $M$ with probability $1/2$ and is otherwise drawn uniformly from $\mathcal M_\lambda$, with $\lvert\mathcal M_\lambda\rvert=2^\lambda$ and $M$ uniform.
- The context $C$ is a uniform bit independent of everything else ($H(C)=1$, $\alpha=1$).
- The verdict $V$ is the first bit of $\Sigma$, hence $\mathrm{Opp}=1$.

This protocol satisfies the published Assumptions 1 to 3 with $\Delta=0$, since $I(V;\Sigma\mid C)=1\le I(M;\Sigma\mid C)$, and with a regularity constant $\beta$ close to 1. Its mutual information $I(M;\Sigma\mid C)=\lambda/2-1+O(\lambda 2^{-\lambda})$ grows with $\lambda$.

## What the output shows

```
    λ   Conf      Rel  Opp   I(M;Σ|C)    KL max   β=KL/I  Lemme4 borne    C·R·O  Th1 (Δ=0)  Th1 (Δ=56)
   64  0.500  0.50000    1     31.000    32.000   1.0323        0.4182   0.2500   2.87e-04      0.8753
  128  0.500  0.50000    1     63.000    64.000   1.0159        0.4088   0.2500   7.46e-05      0.4376
  256  0.500  0.50000    1    127.000   128.000   1.0079        0.4041   0.2500   1.90e-05      0.2188
  512  0.500  0.50000    1    255.000   256.000   1.0039        0.4018   0.2500   4.80e-06      0.1094
 1024  0.500  0.50000    1    511.000   512.000   1.0020        0.4006   0.2500   1.21e-06      0.0547
```

| Column | Meaning |
|---|---|
| `Conf`, `Rel`, `Opp` | Exact values of the protocol, $1/2$, $1/2+2^{-\lambda-1}$ and $1$ |
| `I(M;Σ\|C)`, `KL max`, `β=KL/I` | Mutual information, maximal KL divergence between two messages, realised regularity constant |
| `Lemme4 borne` (Lemma 4 bound) | Upper bound on $\mathrm{Conf}$ stated by Lemma 4 in its initial formulation, $1-\sqrt{c_0 I/(\beta\lambda)}$ |
| `C·R·O` | Product $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ |
| `Th1 (Δ=0)`, `Th1 (Δ=56)` | Bound of Theorem 1 in its initial formulation, with the explicit constants of its proof (equations 36 to 38), for $\Delta=0$ and $\Delta=56$ bits |

The protocol is a limiting case for two statements in their initial formulation.

1. **Lemma 4, initial formulation.** $\mathrm{Conf}=0.5$ exceeds the stated upper bound, which lies between 0.40 and 0.42. The proof of the lemma establishes a lower bound, $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$, which is the form adopted in the refined statements and in the thesis.
2. **Theorem 1, initial formulation.** The product stays equal to $0.25$ for every $\lambda$, whereas the initial bound tends to 0. The product exceeds it for $\Delta=0$ from $\lambda=64$ on and even for $\Delta=56$ bits from $\lambda=256$ on.

This limiting case stems from the absence of any restriction on leakage in the initial formulation. The thesis and the refined statements state Assumption 4 explicitly, $I(M;\Sigma\mid C)\le\kappa/\lambda$, under which the theorem is proved and certified in Lean. The limiting case shows that this assumption is necessary. In the thesis, the same construction is presented with a two-bit context ($H(C)=2$, $\gamma=1$) so as to satisfy Assumption 2′ as well. This variant is checked by check V6 of [`../../06_calcul/python/verifications.py`](../../06_calcul/python/verifications.py). In Lean, the theorem `regime_assumption_necessary` gives its counterpart in the abstract model.

## Running

```bash
python3 -m pip install mpmath
python3 cas_limite.py
```

The script is kept as is; its comments are in French.
