# Cas limite du Théorème 1 dans sa formulation initiale (IEEE Access 2026, DOI 10.1109/ACCESS.2026.3669065)
# Protocole : Σ = M avec proba 1/2, sinon Σ uniforme sur M_λ (|M_λ| = N = 2^λ).
# Contexte C : un bit uniforme indépendant de tout. Verdict V = premier bit de Σ.
from mpmath import mp, mpf, log, sqrt
mp.dps = 60
c0 = 1/(2*log(2))
def lg(x): return log(x)/log(2)
print(f"{'λ':>5} {'Conf':>6} {'Rel':>8} {'Opp':>4} {'I(M;Σ|C)':>10} {'KL max':>9} {'β=KL/I':>8} "
      f"{'Lemme4 borne':>13} {'C·R·O':>8} {'Th1 (Δ=0)':>10} {'Th1 (Δ=56)':>11}")
for lam in [64,128,256,512,1024]:
    N = mpf(2)**lam
    a = mpf(1)/2 + 1/(2*N)      # P(Σ=m | M=m)
    b = 1/(2*N)                  # P(Σ=s | M=m), s≠m
    conf = 1 - (a-b)             # TV(P_m0,P_m1) = a-b = 1/2 exactement
    rel  = a                     # décodeur optimal : v̂ = Σ
    HSgM = -a*lg(a) - (N-1)*b*lg(b)
    I    = lam - HSgM            # H(Σ)=λ (Σ uniforme), C indépendant
    KL   = (a-b)*lg(a/b)         # D(P_m0 || P_m1), identique pour toute paire
    beta = KL/I
    opp  = 1                     # V=g(Σ) : I(V;Σ|C)=H(V|C)=1
    # Hypothèses : H1 : I(V;Σ|C)=1 ≤ I + Δ ; H2 : k=2 ≤ 2^{αH(C)} avec α=1,H(C)=1 ;
    # H3 : D ≤ β I pour toutes paires/contextes (β calculé ci-dessus, O(1)) ; (28) H(V|C)=1 ≥ αH(C)-1=0
    assert 1 <= I and 2 <= 2**(1*1) and 1 >= 1*1-1 and rel >= mpf(1)/2
    lem4 = 1 - sqrt(c0*I/(beta*lam))
    prod = conf*rel*opp
    # Théorème 1 avec les constantes explicites de la preuve (éq. 36-38), α=1, H(C)=1
    crypto = (625*c0**2/(256*(beta*lam)**2))*(1-5*c0/(4*beta*lam))/(1*1)
    negl = mpf(2)**(-lam)
    th0  = 0/lam + crypto + negl
    th56 = 56/mpf(lam) + crypto + negl
    print(f"{lam:>5} {float(conf):>6.3f} {float(rel):>8.5f} {opp:>4} {float(I):>10.3f} {float(KL):>9.3f} {float(beta):>8.4f} "
          f"{float(lem4):>13.4f} {float(prod):>8.4f} {float(th0):>10.2e} {float(th56):>11.4f}")
