> **Statut : PROPOSITION. implémentation de référence** · Source : thèse, chapitre 3, Algorithmes `alg:sotp_low` et `alg:sotp_base` ; annexe A, §A.5 et §A.6

# Implémentation de référence de SOTP-Low et SOTP-Base

*English version: [README_en.md](README_en.md)*

> **Avertissement.** Implémentation **pédagogique**, **non auditée**. **Ne pas utiliser en production.** L'arithmétique en Python pur n'est pas à temps constant, aucune protection contre les canaux auxiliaires n'est prévue, la sérialisation n'est pas spécifiée et les choix de paramètres servent la lisibilité. Ce code illustre les Algorithmes 1 et 2 de la thèse ; il ne valide ni la construction ni une quelconque minoration d'opposabilité.

## Contenu

| Fichier | Rôle |
|---|---|
| [group.py](group.py) | Groupe d'ordre premier $q$ (sous-groupe des résidus quadratiques de $\mathbb{Z}_p^*$, $p = 2q+1$ premier sûr de 2048 bits, groupe 14 de la RFC 3526) ; générateurs $g, h$ obtenus par hachage vers le groupe, de sorte que $\log_g h$ est inconnu ; petit groupe jouet ($p = 2039$, $q = 1019$) réservé aux tests |
| [sotp_low.py](sotp_low.py) | SOTP-Low, Algorithme 1 (`alg:sotp_low`) ; fonction `extract_dlog` de la réduction de liaison |
| [sotp_base.py](sotp_base.py) | SOTP-Base, Algorithme 2 (`alg:sotp_base`) ; règles de dimensionnement et lemme de dimensionnement JL de l'annexe A |
| [tests/](tests/) | Tests pytest |
| [requirements.txt](requirements.txt) | Dépendances (numpy, pytest) |

Le code est en un seul exemplaire, avec identifiants et commentaires en anglais (licence MIT).

## Correspondance entre le code et les algorithmes de la thèse

### SOTP-Low (Algorithme 1)

| Ligne(s) de l'algorithme | Énoncé | Code |
|---|---|---|
| 3 | groupe $(\mathbb{G}, q)$ à DLog difficile | `group.rfc3526_group14()` |
| 4 | $g, h \xleftarrow{\$} \mathbb{G}$, $\log_g h$ inconnu | `group.generators()` (hachage vers le groupe, étiquettes publiques) |
| 5 | $\mathsf{PRG} : \mathbb{Z}_q \to \lbrace 0,1\rbrace^\lambda$ | `sotp_low.prg()` (SHAKE-256) |
| 6 | $\mathsf{Hash} : \mathcal{C} \to \lbrace 0,1\rbrace^\lambda$ | `sotp_low.context_hash()` (SHA-256 tronqué à $\lambda$ bits) |
| 7 | $\phi : \mathcal{C} \to \lbrace 0,1\rbrace^{H(\mathcal{C})}$ | `PublicKeyLow.phi()` (indice du contexte dans l'espace public des contextes) |
| 2–8 | $\mathsf{Setup}$ | `sotp_low.setup()` |
| 11 | $s \xleftarrow{\$} \mathbb{Z}_q$, $\sigma_1 \leftarrow m \oplus \mathsf{PRG}(s)$ | `sotp_low.prove()`, couche Gold |
| 13 | $\rho \xleftarrow{\$} \mathbb{Z}_q$, $\sigma_2 \leftarrow g^s h^\rho$ | `sotp_low.prove()`, couche Iron |
| 15 | $\sigma_3 \leftarrow (\phi(c), \mathsf{Hash}(c), V(c))$ | `sotp_low.prove()`, couche Clay (`Clay(phi_c, hash_c, verdict)`) |
| 17–18 | $\mathsf{Verify}$ | `sotp_low.verify()` |
| 19–20 | $\mathsf{Open}$ | `sotp_low.open_proof()` |
| preuve de `thm:saturation_sotp_low`, partie II | $\log_g h = (s_0 - s_1)/(\rho_1 - \rho_0) \bmod q$ | `sotp_low.extract_dlog()` |

### SOTP-Base (Algorithme 2)

| Ligne(s) de l'algorithme | Énoncé | Code |
|---|---|---|
| 3 | groupe, PRG, Hash comme SOTP-Low | `sotp_base.setup()` réutilise `group` et `sotp_low.prg` |
| 4 | $d \leftarrow \lceil 4\Delta H(\mathcal{C})/\varepsilon^2 \rceil$ | `sotp_base.embed_dimension()` |
| 5 | $k \leftarrow \lceil 8\log(2^{H(\mathcal{C})})/\varepsilon^2 \rceil$ | `sotp_base.output_dimension()` (logarithme népérien) |
| 6 | $\Phi \xleftarrow{\$} \mathcal{N}(0, 1/k)^{k \times d}$ | `sotp_base.jl_matrix()` (numpy, graine publique) |
| 9 | couches Gold et Iron identiques à SOTP-Low | `sotp_base.prove()` |
| 11–12 | $\vec{c} \leftarrow \mathsf{embed}(c)$, $\sigma_3 \leftarrow \Phi\vec{c}$ | `sotp_base.embed()`, `sotp_base.prove()` |
| 15 | $\|\Phi\,\mathsf{embed}(c) - \sigma_3\| \leq \varepsilon$ | `sotp_base.verify()` (vérification par recalcul) |
| 16 | $\sigma_2 \in \mathbb{G}$ et cohérence Gold | `sotp_base.verify()` |
| $\mathsf{Open}$ (identique à SOTP-Low) | $\sigma_2 = g^s h^\rho$ et $\sigma_1 = m \oplus \mathsf{PRG}(s)$ | `sotp_base.open_proof()` |
| annexe A, Th. `thm:ann_sotp_base_opp` | $\dim \geq (c/\delta^2)\ln(N^2/\varepsilon')$ | `sotp_base.jl_dimension_lemma()` (constante 8 de la preuve) |

## Choix d'implémentation laissés ouverts par la thèse

- **Groupe.** Le groupe 14 de la RFC 3526 a été retenu parce qu'il se réalise en quelques lignes de Python pur avec une arithmétique entière exacte. Son ordre vérifie $|q| = 2047$ bits, ce qui satisfait la condition $|q| \geq 2\lambda$ de la ligne 3 de l'Algorithme 1 ; le paramètre $\lambda$ fixe aussi la longueur des messages et les seuils de régime. La sécurité DLog de ce groupe est estimée à environ 110 bits.
- **Messages.** Les messages sont des chaînes de exactement $\lambda$ bits, comme l'impose $\mathsf{PRG} : \mathbb{Z}_q \to \lbrace 0,1\rbrace^\lambda$.
- **Encodage $\phi$.** L'espace des contextes est une liste publique finie. $\phi(c)$ est l'indice de $c$ écrit sur $\lceil\log_2|\mathcal{C}|\rceil$ bits, ce qui est un encodage sans perte sur $H(\mathcal{C})$ bits pour un contexte uniforme. `setup` refuse un espace de contextes hors du régime $H(\mathcal{C}) < \sqrt{\lambda}$.
- **Verdict $V(c)$.** La fonction de verdict institutionnel est un paramètre public de `setup` ; la valeur par défaut est une fonction illustrative du contexte. Conformément à l'Algorithme 1, `verify` ne contrôle pas $V(c)$.
- **Ordre de $\sigma_3$.** Le code suit l'Algorithme 1 et l'annexe A, $(\phi(c), \mathsf{Hash}(c), V(c))$.
- **Plongement $\mathsf{embed}$.** Hachage signé des mots du contexte dans $\mathbb{R}^d$ puis normalisation euclidienne. Deux contextes qui partagent des mots ont des plongements proches.
- **Cohérence Gold (ligne 16 de l'Algorithme 2).** Sans témoin, le seul contrôle possible porte sur la forme de $\sigma_1$, une chaîne de $\lambda$ bits. Le lien entre $\sigma_1$ et $\sigma_2$ n'est vérifié que par $\mathsf{Open}$, comme dans SOTP-Low.
- **Taille de $\Phi$.** Avec $\varepsilon = 0{,}1$ et les paramètres de Helios ($\Delta = 56$, $H(\mathcal{C}) = 40$), la règle de la ligne 4 donne $d = 896\,000$ et la matrice $\Phi$ dépasserait la mémoire disponible. `setup` lève `MemoryError` au-delà de $5\cdot 10^7$ coefficients. Les tests utilisent $\lambda = 128$, $H(\mathcal{C}) = 12$ bits, $\Delta = 2$ et $\varepsilon = 0{,}3$, d'où $d = 1067$ et $k = 740$.

## Exécution

Depuis ce dossier :

```sh
pip install --break-system-packages -r requirements.txt   # si numpy ou pytest manquent
python3 -m pytest -q tests
```

## Résultats des tests

Exécution du 12 octobre 2026 (Python 3.11.15, numpy 2.4.4, pytest 9.1.1), trois exécutions successives sans échec.

```text
tests/test_binding.py ......                                             [ 12%]
tests/test_group.py .......                                              [ 26%]
tests/test_sotp_base.py ..................                               [ 62%]
tests/test_sotp_low.py ...................                               [100%]
50 passed in 7.76s
```

| Fichier de test | Propriété vérifiée |
|---|---|
| `test_group.py` | $p$ et $q$ premiers, $p = 2q+1$, $g$ et $h$ d'ordre $q$, rejet des éléments hors du sous-groupe |
| `test_sotp_low.py` | correction (Verify et Open acceptent les preuves honnêtes, pour chaque contexte) ; rejet des ouvertures falsifiées (message, graine, aléa, $\sigma_1$ ou $\sigma_2$ altérés, graine $s+q$) ; rejet par Verify d'un autre contexte, d'un condensé ou d'un encodage falsifiés, de $\sigma_2 \notin \mathbb{G}$ ; Verify seul n'établit pas le lien entre $\sigma_1$ et $\sigma_2$ (propriété documentée de l'algorithme) ; contrôle du régime |
| `test_binding.py` | sur le groupe jouet où $\log_g h$ est calculable par recherche exhaustive, le détenteur de $\log_g h$ produit deux ouvertures acceptées d'une même preuve sur deux messages distincts ; à partir de ces deux ouvertures, `extract_dlog` retrouve exactement $\log_g h$ ; pour $\sigma_2$ fixé, chaque graine admet exactement une ouverture (masquage parfait, liaison calculatoire) |
| `test_sotp_base.py` | dimensions conformes aux lignes 4 et 5 ; exemple $d = 896\,000$ de la thèse ; variance de $\Phi$ ; correction ; tolérance $\varepsilon$ ; rejet d'un autre contexte, d'une couche Clay hors tolérance ou mal formée, de $\sigma_2 \notin \mathbb{G}$, d'une couche Gold mal formée, des ouvertures falsifiées ; préservation empirique des distances à $(1 \pm \varepsilon)$ près sur 780 paires de contextes et sur 1770 paires de points aléatoires avec la dimension du lemme de l'annexe A |

Ces tests vérifient la cohérence du code avec les algorithmes. Ils ne mesurent ni la confidentialité ni l'opposabilité.
