# Support de formation des trustees (P3, phase 1)

> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.3.3, phase 1 (« formation structurée sur Helios et les preuves zéro-connaissance », 4 h) ; dérivation Helios, §4.3

[English version](support_formation_trustees_en.md) · [Protocole P3](protocole_fr.md) · [Bulletins d'exercice](formation/bulletins_exercice.json)

Canevas de la formation et trame des diapositives. Contrairement à la formation de P1, celle-ci entre dans les mécanismes internes. Les trustees sont des doctorants et des enseignants-chercheurs. Ils doivent savoir vérifier eux-mêmes une preuve.

## 1. Règles de neutralité

1. La formation enseigne **comment vérifier**. Elle ne dit jamais **quel verdict rendre** à partir d'un résultat de vérification.
2. Elle ne mentionne ni la valeur prédite $\mathsf{Opp} = 0{,}50$, ni le critère de validation, ni la proportion ou les types de preuves témoins.
3. Elle annonce que la série d'audit « peut contenir des bulletins modifiés par l'équipe », comme la notice d'information.
4. Les exercices utilisent un format pédagogique distinct du format Helios. Aucun bulletin du scrutin réel n'est montré pendant la formation.

## 2. Déroulement (4 h)

| Durée | Module | Contenu |
|---|---|---|
| 15 min | Ouverture | objectifs, rôle du trustee dans l'audit de recherche, séparation avec le scrutin réel |
| 35 min | M1. Architecture de Helios | inscription, dépôt, tableau d'affichage public, empreinte de bulletin, vérification de dépôt, défi de l'électeur (« cast or audit »), dépouillement homomorphe, déchiffrement partagé entre détenteurs de clé |
| 35 min | M2. Chiffrement ElGamal exponentiel | groupe d'ordre premier, clé publique du scrutin, chiffré $(g^r, g^v y^r)$, homomorphie additive, pourquoi deux chiffrés d'un même choix diffèrent |
| 15 min | Pause | |
| 45 min | M3. Preuves à divulgation nulle | preuve de Chaum-Pedersen, preuve disjonctive « 0 ou 1 », preuve « la somme vaut 1 », transformation de Fiat-Shamir, ce que la vérification établit et ce qu'elle n'établit pas |
| 20 min | M4. Incidents documentés | cas où des trustees experts ont rencontré des difficultés opérationnelles (incidents IACR 2025 et UCL 2009 cités au §4.3 de la thèse), gestion des parts de clé |
| 50 min | M5. Exercices | vérification des six bulletins d'exercice EX-1 à EX-6, remplissage de la fiche d'audit à blanc |
| 25 min | M6. Déroulement de l'audit | fiche d'audit, consignes, confidentialité, calendrier, questions |

## 3. Points clés par module

**M1.** Le tableau d'affichage publie tous les bulletins chiffrés et leurs preuves. Chaque électeur peut retrouver l'empreinte de son bulletin. Le résultat n'est obtenu qu'après combinaison homomorphe des chiffrés et déchiffrement partagé. Aucun bulletin individuel n'est déchiffré.

**M2.** Un chiffré ElGamal exponentiel d'un choix $v \in \{0,1\}$ est la paire $(\alpha, \beta) = (g^r, g^v y^r)$, avec un aléa $r$ frais. Le produit de deux chiffrés chiffre la somme des choix. Chiffrer deux fois le même choix donne deux chiffrés différents, d'où l'intérêt d'une preuve de validité.

**M3.** Pour un chiffré, la preuve disjonctive établit que $v = 0$ ou $v = 1$ sans dire lequel. La preuve globale établit que la somme des choix d'un bulletin vaut 1. Une vérification réussie établit que le bulletin est bien formé sous l'hypothèse de difficulté du logarithme discret et dans le modèle de l'oracle aléatoire. Elle n'établit ni l'identité du votant, ni l'unicité du dépôt, ni le respect des horaires.

**M4.** Les difficultés documentées tiennent à l'exploitation (perte ou mauvaise gestion de parts de clé, procédures) plus qu'aux mathématiques. Ce module situe le rôle du trustee sans donner de règle de décision.

## 4. Exercices (M5)

Les six bulletins sont produits par [generer_bulletins_exercice.py](formation/generer_bulletins_exercice.py), qui réutilise la construction de type Helios des [stimuli de P1](../P1_delta/stimuli/generer_exemples.py). Leurs valeurs complètes figurent dans [bulletins_exercice.json](formation/bulletins_exercice.json). Ce format pédagogique n'est **pas** le format Helios et ne doit pas être soumis à un vérificateur Helios.

```sh
cd formation
python3 generer_bulletins_exercice.py --check   # régénère et compare au fichier versionné
python3 generer_bulletins_exercice.py --verifier EX-3   # vérifie un bulletin d'exercice
```

Les participants reçoivent les six bulletins et la clé publique d'exercice. Ils vérifient chaque bulletin avec l'option `--verifier` du script, qui recalcule l'empreinte et contrôle chaque preuve. Ils remplissent ensuite une fiche d'audit à blanc pour chacun. La correction porte sur les résultats de vérification et non sur le verdict.

### Corrigé des vérifications (remis après l'exercice)

| Bulletin | Empreinte (16 premiers caractères) | Preuves « 0 ou 1 » | Preuve « somme égale à 1 » | Ce qui est en cause |
|---|---|---|---|---|
| EX-1 | `0ce4f30f9905fc19` | acceptées | acceptée | rien, bulletin bien formé (liste 1) |
| EX-2 | `2f75d017f2aaa88b` | acceptées | acceptée | rien, bulletin bien formé (liste 2) |
| EX-3 | `884666c85fff87e6` | 1re rejetée | acceptée | une preuve modifiée après sa création |
| EX-4 | `3ddb28c0964ffda8` | acceptées | rejetée | deux choix exprimés, chaque chiffré est bien 0 ou 1 |
| EX-5 | `346ae1ca7fde60be` | 1re rejetée | rejetée | valeur 2 chiffrée pour la liste 1 |
| EX-6 | `0ce4f30f9905fc19` | acceptées | acceptée | même empreinte que EX-1, bulletin rejoué |

Discussion après correction. EX-4 montre que chaque preuve locale peut réussir alors que le bulletin est mal formé. EX-6 montre qu'une vérification cryptographique réussie ne dit rien de l'unicité du dépôt. Le formateur ne dit pas quel verdict il aurait rendu.

## 5. Évaluation de la formation

À la fin du module M6, chaque trustee répond à trois questions, sans note ni restitution individuelle.

1. Je sais vérifier seul les preuves d'un bulletin Helios. ☐ pas du tout ☐ plutôt non ☐ plutôt oui ☐ tout à fait
2. Je sais ce qu'une vérification réussie n'établit pas. ☐ pas du tout ☐ plutôt non ☐ plutôt oui ☐ tout à fait
3. Le temps consacré aux exercices était ☐ insuffisant ☐ suffisant ☐ excessif

Les réponses sont saisies à part, sans lien avec les verdicts d'audit **[à arrêter par l'équipe]**.

## 6. Contrôle de fidélité

☐ Diapositives identiques pour tous les trustees (version ____)
☐ Aucune mention de la valeur prédite ni des types de témoins
☐ Exercices faits sur le format pédagogique seulement
☐ Durée effective notée dans le [journal de séance](../00_commun/journal_session_fr.md)

Licence CC BY 4.0 pour le support, MIT pour le script.
