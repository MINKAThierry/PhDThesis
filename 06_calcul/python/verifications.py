"""Quatorze contrôles numériques reproductibles (rapport d'analyse du manuscrit, septembre 2026).

Usage : python verifications.py > ../results/verifications_output.txt
Graine fixée (2026) : la sortie est déterministe.
"""
import itertools, math, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent))
import numpy as np
from mpmath import mp, mpf, log as mlog
rng = np.random.default_rng(2026)
lg = lambda x: math.log2(x)

def H(p):
    p = np.asarray(p, float).ravel(); p = p[p > 0]
    return float(-(p * np.log2(p)).sum())

def cond_MI(P, a, b, c):
    """I(A;B|C) pour une loi jointe P (ndarray) et listes d'axes a,b,c."""
    ax = list(range(P.ndim))
    def marg(keep):
        drop = tuple(i for i in ax if i not in keep)
        return P.sum(axis=drop) if drop else P
    return H(marg(a + c)) + H(marg(b + c)) - H(marg(a + b + c)) - H(marg(c))

print("== V1. Opp ≡ 1 quand V est fonction déterministe de (Σ,C)")
worst = 0
for _ in range(2000):
    nM, nS, nC, nV = 4, 6, 3, 3
    PC = rng.dirichlet(np.ones(nC)); PM = rng.dirichlet(np.ones(nM))
    PS = rng.dirichlet(np.ones(nS), size=(nM, nC))           # P(σ|m,c)
    f = rng.integers(0, nV, size=(nS, nC))                     # V = f(σ,c)
    P = np.zeros((nM, nS, nC, nV))
    for m, s, c in itertools.product(range(nM), range(nS), range(nC)):
        P[m, s, c, f[s, c]] += PM[m] * PC[c] * PS[m, c, s]
    I = cond_MI(P, [3], [1], [2]); HVC = H(P.sum(axis=(0, 1))) - H(P.sum(axis=(0, 1, 3)))
    if HVC > 1e-9: worst = max(worst, abs(I / HVC - 1))
print(f"  2000 protocoles aléatoires : max |Opp − 1| = {worst:.2e}")

print("== V2. Composante fonction de C seul : I(V;g(C)|C) = 0")
worst = 0
for _ in range(1000):
    nC, nV = 5, 4
    PCV = rng.dirichlet(np.ones(nC * nV)).reshape(nC, nV)
    g = rng.integers(0, 3, size=nC)
    P = np.zeros((nC, 3, nV))
    for c in range(nC):
        P[c, g[c], :] = PCV[c]
    worst = max(worst, abs(cond_MI(P, [2], [1], [0])))
print(f"  1000 essais : max I(V;σ3|C) = {worst:.2e}")

print("== V3. Borne explicite vs Fano seul (Δ ≥ γ ⇒ borne ≥ (x+1)/λ)")
for name, D, a, Hc in [("Helios", 56, 1.2, 8), ("zk", 73, 1.5, 11), ("ECDSA", 35, 1.0, 20),
                       ("Helios(ch.2)", 56, 1.2, 40), ("zk(ch.2)", 73, 1.5, 70)]:
    g = a * Hc - 1; lam = 128; k = 1.0
    fano = (1 + k / lam) / lam
    thm = (1 / g) * (D / lam + k * (D + 1) / lam**2 + k**2 / lam**3)
    print(f"  {name:13s} γ={g:6.1f}  Δ/γ={D/g:5.2f}  borne thm={thm:.4f}  Fano seul={fano:.4f}  -> {'Δ inactif' if thm >= fano else 'Δ actif'}")

print("== V4. Produits CLO vs borne Δ/(γλ) (valeurs de la thèse)")
for name, prod, D, a, Hc in [("Helios", .437, 56, 1.2, 8), ("zk", .572, 73, 1.5, 11), ("ECDSA", .273, 35, 1.0, 20)]:
    g = a * Hc - 1
    print(f"  {name:7s} Δ/λ={D/128:.3f}  Δ/(γλ)={D/(g*128):.4f}  produit={prod}  facteur={prod/(D/(g*128)):.1f}  Hyp2 (H(V|C)≥γ)?")
print("  H(V|C) dérivés : Helios 2 bits (γ=8,6) ; zk 3 bits (γ=15,5) ; ECDSA 20 bits (γ=19)")

print("== V5. Triplets de clo.tex (exemples d'instanciation) vs produits annoncés")
for n, t, ann in [("Helios", (.95, .90, .45), .437), ("zk", (.98, .40, .85), .572), ("ECDSA", (.05, .95, .95), .273),
                  ("Helios P1", (.92, .95, .50), .437), ("zk P1", (.89, .96, .67), .572), ("ECDSA P1", (.31, .98, .90), .273)]:
    print(f"  {n:10s} produit réel={np.prod(t):.4f}  annoncé={ann}")

print("== V6. Cas limite du régime (Remark scope), version conforme à l'Hyp.2' (H(C)=2, V = 1er bit)")
mp.dps = 50
for lam in [64, 128, 256]:
    N = mpf(2)**lam; a = mpf(1)/2 + 1/(2*N); b = 1/(2*N)
    conf = 1 - (a - b); rel = a
    HSgM = -a*mlog(a, 2) - (N-1)*b*mlog(b, 2); I = lam - HSgM
    KL = (a - b) * mlog(a / b, 2); beta = KL / I
    # C = 2 bits uniformes indépendants ; α = 1 ⇒ γ = 1 ; V = 1er bit de Σ ⇒ H(V|C)=1 ≥ γ ; I(V;Σ|C)=1 ≤ I + Δ (Δ=0)
    print(f"  λ={lam}: Conf={float(conf):.3f} Rel={float(rel):.5f} Opp=1 I={float(I):.2f} β={float(beta):.4f} produit={float(conf*rel):.4f}  (γ=1, H(V|C)=1)")

print("== V7. Composition : Fréchet et composition parallèle")
a, b = 0.9, 0.8
print(f"  a+b−1 = {a+b-1:.2f} < ab = {a*b:.2f}  ⇒ la borne additive NE donne PAS le produit")
# parallèle : Σ=(Σ1,Σ2) ; TV conjointe ≥ max TV marginales ⇒ Conf(P1||P2) ≤ min
p0 = np.array([.7, .3]); p1 = np.array([.3, .7]); q0 = np.array([.6, .4]); q1 = np.array([.4, .6])
tv = lambda x, y: .5 * np.abs(x - y).sum()
tv_joint = tv(np.outer(p0, q0).ravel(), np.outer(p1, q1).ravel())
print(f"  Conf1={1-tv(p0,p1):.2f} Conf2={1-tv(q0,q1):.2f} Conf(P1||P2)={1-tv_joint:.3f} (< min ; thèse : ≥ max)")

print("== V8. Bootstrap : CV 20 % sur Δ ⇒ IC95 de Δ/λ")
for n, D in [("ECDSA", 35), ("Helios", 56), ("zk", 73)]:
    d = rng.normal(D, .2 * D, 200000) / 128
    lo, hi = np.percentile(d, [2.5, 97.5])
    print(f"  {n:6s} IC95=[{lo:.3f}; {hi:.3f}]  (thèse : ±1,8 %)")

print("== V9. Stabilité en λ si produit prédit = Δ/λ")
for n, D in [("ECDSA", 35), ("Helios", 56), ("zk", 73)]:
    print("  " + n + " " + "  ".join(f"λ={l}: {D/l:.3f}" for l in (112, 128, 192, 256)))

print("== V10. p-valeur de permutation minimale pour n = 3 points")
print(f"  3! = {math.factorial(3)} permutations ⇒ p_min = {1/math.factorial(3):.3f} (thèse : p < 1e-6)")

print("== V11. SOTP : prédictions calculées dans le texte vs valeurs CLO")
print(f"  SOTP-Low ECDSA 0,75·35/128 = {0.75*35/128:.3f} (CLO 0,273)")
d = 560; print(f"  SOTP-Base Helios 0,5·min(56/560, 56/(1,4·log2 560)) = {0.5*min(56/d, 56/(1.4*lg(d))):.3f} (CLO 0,437)")
print(f"  SOTP-High zk 0,45·1,5·log2(128)/128 = {0.45*1.5*7/128:.4f} (CLO 0,572)")
print(f"  d = ⌈4ΔH(C)/ε²⌉ (Δ=56, H=40, ε=0,1) = {math.ceil(4*56*40/0.01)} ; ε=0,2 : {math.ceil(4*56*40/0.04)}")

print("== V12. Pedersen sur int(s) mod q : collision triviale (λ = 8, q = 251)")
q, lam = 251, 8
s0 = 3; s1 = s0 + q
print(f"  s0={s0:08b}, s1={s1:08b} (< 2^{lam}={2**lam}), int(s) mod q : {s0 % q} = {s1 % q} ⇒ même σ2 avec ρ0=ρ1, graines distinctes")

print("== V13. Proposition (option A) : interprétation admissible (V ⊥ M | Σ,C) + I(V;Σ|M,C) ≤ Δ ⇒ Hyp.1 ; Opp < 1 possible")
worst = -1e9; opps = []
for _ in range(3000):
    nM, nS, nC, nV = 3, 5, 2, 3
    PM = rng.dirichlet(np.ones(nM)); PC = rng.dirichlet(np.ones(nC))
    PS = rng.dirichlet(np.ones(nS), size=(nM, nC)); PV = rng.dirichlet(np.ones(nV), size=(nS, nC))
    P = np.einsum('m,c,mcs,scv->mscv', PM, PC, PS, PV)
    lhs = cond_MI(P, [3], [1], [2])                   # I(V;Σ|C)
    D1 = cond_MI(P, [3], [1], [0, 2])                 # I(V;Σ|M,C)
    rhs = cond_MI(P, [0], [1], [2]) + D1              # I(M;Σ|C) + Δ
    worst = max(worst, lhs - rhs)
    HVC = H(P.sum(axis=(0, 1))) - H(P.sum(axis=(0, 1, 3)))
    opps.append(lhs / HVC)
print(f"  3000 lois aléatoires : max[I(V;Σ|C) − (I(M;Σ|C)+Δ)] avec Δ = I(V;Σ|M,C) = {worst:.2e} (≤ 0 attendu) ; Opp ∈ [{min(opps):.3f}; {max(opps):.3f}]")

print("== V14. Borne raffinée proposée : produit ≤ (1+κ/λ)/λ · min{1,(κ/λ+Δ)/γ}")
for n, D, g in [("Δ=35,γ=19", 35, 19), ("Δ=10,γ=19", 10, 19), ("Δ=5,γ=19", 5, 19)]:
    lam, k = 128, 1
    print(f"  {n}: {(1+k/lam)/lam*min(1,(k/lam+D)/g):.5f}  (forme publiée Δ/λ = {D/lam:.3f})")
