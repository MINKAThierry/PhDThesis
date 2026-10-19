# Cas limite du Théorème 1 de P2 dans sa formulation initiale

> **Statut : PROPOSITION — formulations précisées soumises** · Source : formulations précisées soumises pour P2 ([`../../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/`](../../01_publie/P2_CRO_IEEEAccess2026/formulations_precisees/)) ; thèse, `rem:scope_trilemme_classique` (Remarque 2.17, §2.3.2) et §3.4.9

[English version](README_en.md)

Le script [`cas_limite.py`](cas_limite.py) calcule en haute précision (bibliothèque `mpmath`, 60 chiffres) les quantités d'un protocole qui constitue un cas limite pour deux énoncés de l'article P2 dans leur formulation initiale. Il a servi à établir les formulations précisées soumises. Les énoncés de la thèse couvrent ce protocole, qui s'écarte du régime de l'Hypothèse 4.

## Protocole étudié

- La preuve $\Sigma$ vaut $M$ avec probabilité $1/2$ et est sinon tirée uniformément dans $\mathcal M_\lambda$, avec $\lvert\mathcal M_\lambda\rvert=2^\lambda$ et $M$ uniforme.
- Le contexte $C$ est un bit uniforme indépendant de tout le reste ($H(C)=1$, $\alpha=1$).
- Le verdict $V$ est le premier bit de $\Sigma$, donc $\mathrm{Opp}=1$.

Ce protocole vérifie les hypothèses publiées 1 à 3 avec $\Delta=0$, puisque $I(V;\Sigma\mid C)=1\le I(M;\Sigma\mid C)$. Sa constante de régularité $\beta$ est proche de 1. Son information mutuelle $I(M;\Sigma\mid C)=\lambda/2-1+O(\lambda 2^{-\lambda})$ croît avec $\lambda$.

## Ce que montre la sortie

```
    λ   Conf      Rel  Opp   I(M;Σ|C)    KL max   β=KL/I  Lemme4 borne    C·R·O  Th1 (Δ=0)  Th1 (Δ=56)
   64  0.500  0.50000    1     31.000    32.000   1.0323        0.4182   0.2500   2.87e-04      0.8753
  128  0.500  0.50000    1     63.000    64.000   1.0159        0.4088   0.2500   7.46e-05      0.4376
  256  0.500  0.50000    1    127.000   128.000   1.0079        0.4041   0.2500   1.90e-05      0.2188
  512  0.500  0.50000    1    255.000   256.000   1.0039        0.4018   0.2500   4.80e-06      0.1094
 1024  0.500  0.50000    1    511.000   512.000   1.0020        0.4006   0.2500   1.21e-06      0.0547
```

| Colonne | Signification |
|---|---|
| `Conf`, `Rel`, `Opp` | Valeurs exactes du protocole, $1/2$, $1/2+2^{-\lambda-1}$ et $1$ |
| `I(M;Σ\|C)`, `KL max`, `β=KL/I` | Information mutuelle, divergence KL maximale entre deux messages, constante de régularité réalisée |
| `Lemme4 borne` | Majorant de $\mathrm{Conf}$ annoncé par le Lemme 4 dans sa formulation initiale, $1-\sqrt{c_0 I/(\beta\lambda)}$ |
| `C·R·O` | Produit $\mathrm{Conf}\cdot\mathrm{Rel}\cdot\mathrm{Opp}$ |
| `Th1 (Δ=0)`, `Th1 (Δ=56)` | Borne du Théorème 1 dans sa formulation initiale, avec les constantes explicites de sa preuve (équations 36 à 38), pour $\Delta=0$ et $\Delta=56$ bits |

Le protocole constitue un cas limite pour deux énoncés dans leur formulation initiale.

1. **Lemme 4, formulation initiale.** $\mathrm{Conf}=0{,}5$ dépasse le majorant annoncé, compris entre 0,40 et 0,42. La preuve du lemme établit une minoration, $\mathrm{Conf}\ge 1-\sqrt{c_0\beta I}$, qui est la forme retenue dans les formulations précisées et dans la thèse.
2. **Théorème 1, formulation initiale.** Le produit reste égal à $0{,}25$ pour tout $\lambda$, alors que la borne initiale tend vers 0. Le produit la dépasse pour $\Delta=0$ dès $\lambda=64$ et même pour $\Delta=56$ bits dès $\lambda=256$.

Ce cas limite tient à l'absence de restriction sur la fuite dans la formulation initiale. La thèse et les formulations précisées posent explicitement l'Hypothèse 4, $I(M;\Sigma\mid C)\le\kappa/\lambda$, sous laquelle le théorème est démontré et certifié en Lean. Le cas limite montre que cette hypothèse est nécessaire. Dans la thèse, la même construction est présentée avec un contexte de deux bits ($H(C)=2$, $\gamma=1$) afin de satisfaire aussi l'Hypothèse 2′. Cette variante est vérifiée par le contrôle V6 de [`../../06_calcul/python/verifications.py`](../../06_calcul/python/verifications.py). En Lean, le théorème `regime_assumption_necessary` en donne la contrepartie dans le modèle abstrait.

## Exécuter

```bash
python3 -m pip install mpmath
python3 cas_limite.py
```

Le script est repris tel quel ; ses commentaires sont en français.
