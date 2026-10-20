> **Status: PROPOSAL. reference implementation** · Source: thesis, Chapter 3, Algorithms `alg:sotp_low` and `alg:sotp_base`; Appendix A, §A.5 and §A.6

# Reference implementation of SOTP-Low and SOTP-Base

*Version française : [README_fr.md](README_fr.md)*

> **Warning.** **Educational**, **unaudited** implementation. **Do not use in production.** Pure Python arithmetic is not constant time, there is no protection against side channels, serialisation is not specified and parameter choices favour readability. This code illustrates Algorithms 1 and 2 of the thesis; it validates neither the construction nor any lower bound on opposability.

## Contents

| File | Role |
|---|---|
| [group.py](group.py) | Prime-order group $q$ (subgroup of quadratic residues of $\mathbb{Z}_p^*$, $p = 2q+1$ a 2048-bit safe prime, RFC 3526 group 14); generators $g, h$ obtained by hashing to the group, so that $\log_g h$ is unknown; small toy group ($p = 2039$, $q = 1019$) reserved for tests |
| [sotp_low.py](sotp_low.py) | SOTP-Low, Algorithm 1 (`alg:sotp_low`); `extract_dlog` function of the binding reduction |
| [sotp_base.py](sotp_base.py) | SOTP-Base, Algorithm 2 (`alg:sotp_base`); sizing rules and the JL sizing lemma of Appendix A |
| [tests/](tests/) | pytest tests |
| [requirements.txt](requirements.txt) | Dependencies (numpy, pytest) |

The code exists in a single copy, with English identifiers and comments (MIT licence).

## Mapping between the code and the thesis algorithms

### SOTP-Low (Algorithm 1)

| Algorithm line(s) | Statement | Code |
|---|---|---|
| 3 | group $(\mathbb{G}, q)$ with hard DLog | `group.rfc3526_group14()` |
| 4 | $g, h \xleftarrow{\$} \mathbb{G}$, $\log_g h$ unknown | `group.generators()` (hash to group, public labels) |
| 5 | $\mathsf{PRG} : \mathbb{Z}_q \to \lbrace 0,1\rbrace^\lambda$ | `sotp_low.prg()` (SHAKE-256) |
| 6 | $\mathsf{Hash} : \mathcal{C} \to \lbrace 0,1\rbrace^\lambda$ | `sotp_low.context_hash()` (SHA-256 truncated to $\lambda$ bits) |
| 7 | $\phi : \mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$ | `PublicKeyLow.phi()` (index of the context in the public context space) |
| 2–8 | $\mathsf{Setup}$ | `sotp_low.setup()` |
| 11 | $s \xleftarrow{\$} \mathbb{Z}_q$, $\sigma_1 \leftarrow m \oplus \mathsf{PRG}(s)$ | `sotp_low.prove()`, Gold layer |
| 13 | $\rho \xleftarrow{\$} \mathbb{Z}_q$, $\sigma_2 \leftarrow g^s h^\rho$ | `sotp_low.prove()`, Iron layer |
| 15 | $\sigma_3 \leftarrow (\phi(c), \mathsf{Hash}(c), V(c))$ | `sotp_low.prove()`, Clay layer (`Clay(phi_c, hash_c, verdict)`) |
| 17–18 | $\mathsf{Verify}$ | `sotp_low.verify()` |
| 19–20 | $\mathsf{Open}$ | `sotp_low.open_proof()` |
| proof of `thm:saturation_sotp_low`, part II | $\log_g h = (s_0 - s_1)/(\rho_1 - \rho_0) \bmod q$ | `sotp_low.extract_dlog()` |

### SOTP-Base (Algorithm 2)

| Algorithm line(s) | Statement | Code |
|---|---|---|
| 3 | group, PRG, Hash as in SOTP-Low | `sotp_base.setup()` reuses `group` and `sotp_low.prg` |
| 4 | $d \leftarrow \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ | `sotp_base.embed_dimension()` |
| 5 | $k \leftarrow \lceil 8\log(2^{H(\mathcal{C})})/\varepsilon^2 \rceil$ | `sotp_base.output_dimension()` (natural logarithm) |
| 6 | $\Phi \xleftarrow{\$} \mathcal{N}(0, 1/k)^{k \times d}$ | `sotp_base.jl_matrix()` (numpy, public seed) |
| 9 | Gold and Iron layers identical to SOTP-Low | `sotp_base.prove()` |
| 11–12 | $\vec{c} \leftarrow \mathsf{embed}(c)$, $\sigma_3 \leftarrow \Phi\vec{c}$ | `sotp_base.embed()`, `sotp_base.prove()` |
| 15 | $\|\Phi\,\mathsf{embed}(c) - \sigma_3\| \leq \varepsilon$ | `sotp_base.verify()` (recomputation check) |
| 16 | $\sigma_2 \in \mathbb{G}$ and Gold consistency | `sotp_base.verify()` |
| $\mathsf{Open}$ (as in SOTP-Low) | $\sigma_2 = g^s h^\rho$ and $\sigma_1 = m \oplus \mathsf{PRG}(s)$ | `sotp_base.open_proof()` |
| Appendix A, Th. `thm:ann_sotp_base_opp` | $\dim \geq (c/\delta^2)\ln(N^2/\varepsilon')$ | `sotp_base.jl_dimension_lemma()` (constant 8 from the proof) |

## Implementation choices left open by the thesis

- **Group.** RFC 3526 group 14 was chosen because it fits in a few lines of pure Python with exact integer arithmetic. Its order satisfies $|q| = 2047$ bits, which meets the condition $|q| \geq 2\lambda$ of line 3 of Algorithm 1; the parameter $\lambda$ also sets the message length and the regime thresholds. The DLog security of this group is estimated at about 110 bits.
- **Messages.** Messages are strings of exactly $\lambda$ bits, as required by $\mathsf{PRG} : \mathbb{Z}_q \to \lbrace 0,1\rbrace^\lambda$.
- **Encoding $\phi$.** The context space is a finite public list. $\phi(c)$ is the index of $c$ written on $\lceil\log_2|\mathcal{C}|\rceil$ bits, a lossless encoding on $H(\mathcal{C})$ bits for a uniform context. `setup` refuses a context space outside the regime $H(\mathcal{C}) < \sqrt{\lambda}$.
- **Verdict $V(c)$.** The institutional verdict function is a public parameter of `setup`; the default is an illustrative function of the context. As in Algorithm 1, `verify` does not check $V(c)$.
- **Order of $\sigma_3$.** The code follows Algorithm 1 and Appendix A, $(\phi(c), \mathsf{Hash}(c), V(c))$.
- **Embedding $\mathsf{embed}$.** Signed hashing of the context words into $\mathbb{R}^d$ followed by Euclidean normalisation. Two contexts sharing words have close embeddings.
- **Gold consistency (line 16 of Algorithm 2).** Without a witness, the only possible check concerns the shape of $\sigma_1$, a string of $\lambda$ bits. The link between $\sigma_1$ and $\sigma_2$ is checked only by $\mathsf{Open}$, as in SOTP-Low.
- **Size of $\Phi$.** With $\varepsilon = 0.1$ and the Helios parameters ($\Delta = 56$, $H(\mathcal{C}) = 40$), the rule of line 4 gives $d = 896\,000$ and the matrix $\Phi$ would exceed available memory. `setup` raises `MemoryError` beyond $5\cdot 10^7$ coefficients. The tests use $\lambda = 128$, $H(\mathcal{C}) = 12$ bits, $\Delta = 2$ and $\varepsilon = 0.3$, hence $d = 1067$ and $k = 740$.

## Running

From this folder:

```sh
pip install --break-system-packages -r requirements.txt   # if numpy or pytest are missing
python3 -m pytest -q tests
```

## Test results

Run of 12 October 2026 (Python 3.11.15, numpy 2.4.4, pytest 9.1.1), three successive runs without failure.

```text
tests/test_binding.py ......                                             [ 12%]
tests/test_group.py .......                                              [ 26%]
tests/test_sotp_base.py ..................                               [ 62%]
tests/test_sotp_low.py ...................                               [100%]
50 passed in 7.76s
```

| Test file | Property checked |
|---|---|
| `test_group.py` | $p$ and $q$ prime, $p = 2q+1$, $g$ and $h$ of order $q$, rejection of elements outside the subgroup |
| `test_sotp_low.py` | correctness (Verify and Open accept honest proofs, for every context); rejection of forged openings (altered message, seed, randomness, $\sigma_1$ or $\sigma_2$, seed $s+q$); Verify rejects another context, a forged digest or encoding, $\sigma_2 \notin \mathbb{G}$; Verify alone does not establish the link between $\sigma_1$ and $\sigma_2$ (documented property of the algorithm); regime check |
| `test_binding.py` | on the toy group where $\log_g h$ can be found by exhaustive search, the holder of $\log_g h$ produces two accepted openings of the same proof on two distinct messages; from these two openings, `extract_dlog` recovers $\log_g h$ exactly; for a fixed $\sigma_2$, each seed admits exactly one opening (perfect hiding, computational binding) |
| `test_sotp_base.py` | dimensions consistent with lines 4 and 5; example $d = 896\,000$ from the thesis; variance of $\Phi$; correctness; tolerance $\varepsilon$; rejection of another context, of an out-of-tolerance or malformed Clay layer, of $\sigma_2 \notin \mathbb{G}$, of a malformed Gold layer, of forged openings; empirical distance preservation within $(1 \pm \varepsilon)$ over 780 context pairs and 1770 pairs of random points with the dimension of the Appendix A lemma |

These tests check that the code is consistent with the algorithms. They measure neither confidentiality nor opposability.
