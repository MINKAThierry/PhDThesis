# Corpus des 100 contextes (P2, approche MDS)

> **Statut : PROPOSITION. protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.3 (« un ensemble de $n_{\text{ctx}} = 100$ contextes variés »)

[English version](corpus_contextes_en.md) · [Protocole de dissimilarité](protocole_dissimilarite_mds_fr.md)

Fichier produit par [generer_corpus.py](generer_corpus.py), ne pas modifier à la main. Chaque contexte combine un niveau de six éléments de la [grille de décomposition](grille_decomposition_structurelle_fr.md), deux par composante L, T et R. Les combinaisons sont tirées sans répétition avec une graine fixe. Les niveaux de chaque contexte figurent dans [corpus_contextes.csv](corpus_contextes.csv). Ils servent à comparer après coup les dimensions de la MDS aux éléments de la grille. Les experts ne les voient pas.

La rédaction est volontairement uniforme, afin que la dissimilarité jugée porte sur le contenu et non sur le style. Elle peut être reprise par l'équipe à condition de garder une forme commune **[à arrêter par l'équipe]**. Tous les contextes sont fictifs.

## Contentieux électoral (`ELEC`), 34 contextes

| Code | Contexte |
|---|---|
| CTX-001 | Contestation portant sur l'éligibilité d'un candidat lors de l'élection d'un ordre professionnel, soulevée pendant la campagne et dans les délais, devant la commission électorale. Le scrutin se déroule par voie électronique à distance. |
| CTX-002 | Contestation portant sur l'éligibilité d'un candidat lors de l'élection d'une association, soulevée le jour du vote et hors délai, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-003 | Contestation portant sur la régularité d'un vote lors d'une élection législative, soulevée pendant la campagne et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule par voie électronique à distance. |
| CTX-004 | Contestation portant sur la proclamation des résultats lors d'une élection municipale, soulevée pendant la campagne et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-005 | Contestation portant sur le dépouillement lors d'une élection présidentielle, soulevée pendant le dépouillement et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule par voie électronique à distance. |
| CTX-006 | Contestation portant sur l'éligibilité d'un candidat lors de l'élection d'un ordre professionnel, soulevée pendant le dépouillement et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-007 | Contestation portant sur la proclamation des résultats lors d'une élection présidentielle, soulevée après la proclamation et à une date contestée, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-008 | Contestation portant sur l'éligibilité d'un candidat lors d'une élection municipale, soulevée pendant la campagne et hors délai, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-009 | Contestation portant sur le dépouillement lors de l'élection d'un ordre professionnel, soulevée le jour du vote et hors délai, devant le juge administratif. Le scrutin se déroule par voie électronique à distance. |
| CTX-010 | Contestation portant sur le dépouillement lors d'une élection présidentielle, soulevée pendant la campagne et hors délai, devant le juge constitutionnel. Le scrutin se déroule par voie électronique sur place. |
| CTX-011 | Contestation portant sur la régularité d'un vote lors d'une élection présidentielle, soulevée pendant le dépouillement et dans les délais, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-012 | Contestation portant sur la proclamation des résultats lors d'une élection municipale, soulevée pendant la campagne et à une date contestée, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-013 | Contestation portant sur la proclamation des résultats lors d'une élection municipale, soulevée le jour du vote et à une date contestée, devant le juge administratif. Le scrutin se déroule par voie électronique sur place. |
| CTX-014 | Contestation portant sur l'éligibilité d'un candidat lors d'une élection législative, soulevée après la proclamation et dans les délais, devant le juge constitutionnel. Le scrutin se déroule par voie électronique à distance. |
| CTX-015 | Contestation portant sur l'éligibilité d'un candidat lors d'une élection présidentielle, soulevée pendant le dépouillement et dans les délais, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-016 | Contestation portant sur la proclamation des résultats lors d'une élection municipale, soulevée après la proclamation et hors délai, devant la commission électorale. Le scrutin se déroule par voie électronique à distance. |
| CTX-017 | Contestation portant sur la régularité d'un vote lors d'une élection législative, soulevée après la proclamation et dans les délais, devant le juge administratif. Le scrutin se déroule par voie électronique à distance. |
| CTX-018 | Contestation portant sur la régularité d'un vote lors d'une élection présidentielle, soulevée pendant la campagne et dans les délais, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-019 | Contestation portant sur la régularité d'un vote lors d'une élection législative, soulevée après la proclamation et dans les délais, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-020 | Contestation portant sur le dépouillement lors d'une élection législative, soulevée le jour du vote et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-021 | Contestation portant sur la proclamation des résultats lors de l'élection d'une association, soulevée pendant le dépouillement et hors délai, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-022 | Contestation portant sur le dépouillement lors de l'élection d'une association, soulevée pendant la campagne et dans les délais, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-023 | Contestation portant sur la régularité d'un vote lors de l'élection d'une association, soulevée après la proclamation et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule par voie électronique sur place. |
| CTX-024 | Contestation portant sur le dépouillement lors d'une élection législative, soulevée après la proclamation et hors délai, devant le juge administratif. Le scrutin se déroule par voie électronique à distance. |
| CTX-025 | Contestation portant sur le dépouillement lors de l'élection d'une association, soulevée après la proclamation et dans les délais, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-026 | Contestation portant sur la proclamation des résultats lors d'une élection présidentielle, soulevée le jour du vote et dans les délais, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-027 | Contestation portant sur la proclamation des résultats lors d'une élection présidentielle, soulevée pendant la campagne et hors délai, devant la commission électorale. Le scrutin se déroule à l'urne. |
| CTX-028 | Contestation portant sur la régularité d'un vote lors d'une élection présidentielle, soulevée pendant la campagne et dans les délais, devant la commission électorale. Le scrutin se déroule par voie électronique à distance. |
| CTX-029 | Contestation portant sur la proclamation des résultats lors d'une élection législative, soulevée pendant le dépouillement et à une date contestée, devant le juge administratif. Le scrutin se déroule à l'urne. |
| CTX-030 | Contestation portant sur le dépouillement lors de l'élection d'une association, soulevée le jour du vote et à une date contestée, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-031 | Contestation portant sur la proclamation des résultats lors d'une élection municipale, soulevée pendant la campagne et hors délai, devant le juge constitutionnel. Le scrutin se déroule par voie électronique à distance. |
| CTX-032 | Contestation portant sur l'éligibilité d'un candidat lors de l'élection d'un ordre professionnel, soulevée pendant le dépouillement et à une date contestée, devant la commission électorale. Le scrutin se déroule par voie électronique sur place. |
| CTX-033 | Contestation portant sur la régularité d'un vote lors de l'élection d'une association, soulevée pendant la campagne et dans les délais, devant le juge constitutionnel. Le scrutin se déroule à l'urne. |
| CTX-034 | Contestation portant sur la régularité d'un vote lors d'une élection municipale, soulevée pendant le dépouillement et hors délai, devant la commission électorale. Le scrutin se déroule à l'urne. |

## Conformité financière (`FIN`), 33 contextes

| Code | Contexte |
|---|---|
| CTX-035 | Contrôle de conformité prudentielle visant une plateforme de cryptoactifs déjà sanctionnée, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est une sanction. |
| CTX-036 | Contrôle de conformité fiscale visant une banque ayant déjà reçu des observations, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est un classement. |
| CTX-037 | Contrôle de conformité de lutte contre le blanchiment visant une banque sans antécédent, portant sur l'exercice en cours, mené dans le cadre d'une enquête. La suite envisagée est une injonction. |
| CTX-038 | Contrôle de conformité fiscale visant une plateforme de cryptoactifs ayant déjà reçu des observations, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est une sanction. |
| CTX-039 | Contrôle de conformité prudentielle visant une plateforme de cryptoactifs ayant déjà reçu des observations, portant sur le dernier exercice clos, mené dans le cadre d'une enquête. La suite envisagée est une transmission au parquet. |
| CTX-040 | Contrôle de conformité comptable visant une plateforme de cryptoactifs ayant déjà reçu des observations, portant sur l'exercice en cours, mené dans le cadre d'une enquête. La suite envisagée est une sanction. |
| CTX-041 | Contrôle de conformité comptable visant une entreprise publique sans antécédent, portant sur l'exercice en cours, mené dans le cadre d'une enquête. La suite envisagée est une transmission au parquet. |
| CTX-042 | Contrôle de conformité comptable visant une compagnie d'assurance ayant déjà reçu des observations, portant sur les trois derniers exercices, mené sur place. La suite envisagée est une injonction. |
| CTX-043 | Contrôle de conformité comptable visant un établissement de microfinance sans antécédent, portant sur l'exercice en cours, mené par un auditeur externe. La suite envisagée est une injonction. |
| CTX-044 | Contrôle de conformité comptable visant une banque sans antécédent, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est une sanction. |
| CTX-045 | Contrôle de conformité de lutte contre le blanchiment visant une compagnie d'assurance déjà sanctionnée, portant sur l'exercice en cours, mené sur place. La suite envisagée est un classement. |
| CTX-046 | Contrôle de conformité fiscale visant une plateforme de cryptoactifs déjà sanctionnée, portant sur le dernier exercice clos, mené sur place. La suite envisagée est un classement. |
| CTX-047 | Contrôle de conformité fiscale visant une plateforme de cryptoactifs déjà sanctionnée, portant sur les trois derniers exercices, mené dans le cadre d'une enquête. La suite envisagée est un classement. |
| CTX-048 | Contrôle de conformité de lutte contre le blanchiment visant une compagnie d'assurance sans antécédent, portant sur l'exercice en cours, mené dans le cadre d'une enquête. La suite envisagée est une transmission au parquet. |
| CTX-049 | Contrôle de conformité prudentielle visant une plateforme de cryptoactifs déjà sanctionnée, portant sur les trois derniers exercices, mené sur pièces. La suite envisagée est une injonction. |
| CTX-050 | Contrôle de conformité fiscale visant une plateforme de cryptoactifs sans antécédent, portant sur les trois derniers exercices, mené sur place. La suite envisagée est un classement. |
| CTX-051 | Contrôle de conformité prudentielle visant un établissement de microfinance déjà sanctionnée, portant sur le dernier exercice clos, mené sur place. La suite envisagée est une transmission au parquet. |
| CTX-052 | Contrôle de conformité prudentielle visant une compagnie d'assurance sans antécédent, portant sur l'exercice en cours, mené sur pièces. La suite envisagée est un classement. |
| CTX-053 | Contrôle de conformité de lutte contre le blanchiment visant une plateforme de cryptoactifs sans antécédent, portant sur l'exercice en cours, mené par un auditeur externe. La suite envisagée est une injonction. |
| CTX-054 | Contrôle de conformité prudentielle visant une banque déjà sanctionnée, portant sur les trois derniers exercices, mené sur place. La suite envisagée est une sanction. |
| CTX-055 | Contrôle de conformité de lutte contre le blanchiment visant une plateforme de cryptoactifs sans antécédent, portant sur l'exercice en cours, mené sur pièces. La suite envisagée est une injonction. |
| CTX-056 | Contrôle de conformité comptable visant une compagnie d'assurance sans antécédent, portant sur les trois derniers exercices, mené sur pièces. La suite envisagée est un classement. |
| CTX-057 | Contrôle de conformité de lutte contre le blanchiment visant une entreprise publique ayant déjà reçu des observations, portant sur les trois derniers exercices, mené sur pièces. La suite envisagée est une transmission au parquet. |
| CTX-058 | Contrôle de conformité prudentielle visant une plateforme de cryptoactifs déjà sanctionnée, portant sur le dernier exercice clos, mené sur pièces. La suite envisagée est une sanction. |
| CTX-059 | Contrôle de conformité fiscale visant une banque déjà sanctionnée, portant sur l'exercice en cours, mené sur pièces. La suite envisagée est une sanction. |
| CTX-060 | Contrôle de conformité prudentielle visant une banque déjà sanctionnée, portant sur le dernier exercice clos, mené sur pièces. La suite envisagée est une sanction. |
| CTX-061 | Contrôle de conformité prudentielle visant une entreprise publique ayant déjà reçu des observations, portant sur l'exercice en cours, mené sur pièces. La suite envisagée est un classement. |
| CTX-062 | Contrôle de conformité comptable visant une banque sans antécédent, portant sur les trois derniers exercices, mené sur place. La suite envisagée est une injonction. |
| CTX-063 | Contrôle de conformité de lutte contre le blanchiment visant une entreprise publique ayant déjà reçu des observations, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est une sanction. |
| CTX-064 | Contrôle de conformité fiscale visant une plateforme de cryptoactifs sans antécédent, portant sur l'exercice en cours, mené dans le cadre d'une enquête. La suite envisagée est une injonction. |
| CTX-065 | Contrôle de conformité de lutte contre le blanchiment visant une plateforme de cryptoactifs sans antécédent, portant sur le dernier exercice clos, mené sur pièces. La suite envisagée est une injonction. |
| CTX-066 | Contrôle de conformité comptable visant une compagnie d'assurance déjà sanctionnée, portant sur l'exercice en cours, mené sur place. La suite envisagée est un classement. |
| CTX-067 | Contrôle de conformité fiscale visant une compagnie d'assurance ayant déjà reçu des observations, portant sur les trois derniers exercices, mené par un auditeur externe. La suite envisagée est une injonction. |

## Signature contractuelle (`CONT`), 33 contextes

| Code | Contexte |
|---|---|
| CTX-068 | Litige entre un particulier et une société au sujet d'un prêt, portant sur la résiliation, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-069 | Litige entre un particulier et une société au sujet d'un prêt, portant sur la durée, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique qualifiée et l'affaire est soumise à un arbitre. |
| CTX-070 | Litige entre un particulier et une société au sujet d'un bail, portant sur une clause d'exclusivité, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-071 | Litige entre deux particuliers au sujet d'un bail, portant sur la résiliation, survenu après exécution complète. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |
| CTX-072 | Litige entre une personne publique et une société au sujet d'un bail, portant sur la durée, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique simple et l'affaire est soumise à un arbitre. |
| CTX-073 | Litige entre deux sociétés au sujet d'un prêt, portant sur une clause d'exclusivité, survenu après résiliation. Le contrat a été conclu par signature électronique simple et l'affaire est soumise à un arbitre. |
| CTX-074 | Litige entre deux sociétés au sujet d'un contrat de travail, portant sur la durée, survenu après résiliation. Le contrat a été conclu par signature électronique qualifiée et l'affaire est jugée au fond. |
| CTX-075 | Litige entre deux particuliers au sujet d'un contrat de travail, portant sur la durée, survenu en cours d'exécution. Le contrat a été conclu sur papier et l'affaire est portée en référé. |
| CTX-076 | Litige entre deux particuliers au sujet d'une vente, portant sur la résiliation, survenu en cours d'exécution. Le contrat a été conclu par signature électronique qualifiée et l'affaire est jugée au fond. |
| CTX-077 | Litige entre un particulier et une société au sujet d'un prêt, portant sur le prix, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique simple et l'affaire est soumise à un arbitre. |
| CTX-078 | Litige entre deux sociétés au sujet d'un contrat de travail, portant sur le prix, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est soumise à un arbitre. |
| CTX-079 | Litige entre deux particuliers au sujet d'un prêt, portant sur la résiliation, survenu après résiliation. Le contrat a été conclu par signature électronique simple et l'affaire est soumise à un arbitre. |
| CTX-080 | Litige entre deux particuliers au sujet d'une vente, portant sur une clause d'exclusivité, survenu après résiliation. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-081 | Litige entre deux particuliers au sujet d'un prêt, portant sur une clause d'exclusivité, survenu après exécution complète. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |
| CTX-082 | Litige entre une personne publique et une société au sujet d'un bail, portant sur la durée, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-083 | Litige entre un particulier et une société au sujet d'un prêt, portant sur une clause d'exclusivité, survenu après résiliation. Le contrat a été conclu par signature électronique qualifiée et l'affaire est portée en référé. |
| CTX-084 | Litige entre un particulier et une société au sujet d'un bail, portant sur la résiliation, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est portée en référé. |
| CTX-085 | Litige entre un particulier et une société au sujet d'un contrat de prestation, portant sur une clause d'exclusivité, survenu après résiliation. Le contrat a été conclu par signature électronique qualifiée et l'affaire est portée en référé. |
| CTX-086 | Litige entre deux sociétés au sujet d'un contrat de prestation, portant sur le prix, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |
| CTX-087 | Litige entre deux particuliers au sujet d'un contrat de travail, portant sur le prix, survenu après résiliation. Le contrat a été conclu par signature électronique qualifiée et l'affaire est soumise à un arbitre. |
| CTX-088 | Litige entre deux sociétés au sujet d'un bail, portant sur la durée, survenu après résiliation. Le contrat a été conclu par signature électronique qualifiée et l'affaire est portée en référé. |
| CTX-089 | Litige entre deux particuliers au sujet d'un prêt, portant sur la durée, survenu après exécution complète. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |
| CTX-090 | Litige entre un particulier et une société au sujet d'un bail, portant sur une clause d'exclusivité, survenu en cours d'exécution. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |
| CTX-091 | Litige entre deux particuliers au sujet d'un contrat de travail, portant sur la résiliation, survenu après résiliation. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-092 | Litige entre deux particuliers au sujet d'un contrat de prestation, portant sur une clause d'exclusivité, survenu après exécution complète. Le contrat a été conclu par signature électronique qualifiée et l'affaire est portée en référé. |
| CTX-093 | Litige entre un particulier et une société au sujet d'une vente, portant sur la durée, survenu après résiliation. Le contrat a été conclu sur papier et l'affaire est soumise à un arbitre. |
| CTX-094 | Litige entre un particulier et une société au sujet d'une vente, portant sur une clause d'exclusivité, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique qualifiée et l'affaire est portée en référé. |
| CTX-095 | Litige entre deux particuliers au sujet d'une vente, portant sur la résiliation, survenu en cours d'exécution. Le contrat a été conclu sur papier et l'affaire est soumise à un arbitre. |
| CTX-096 | Litige entre un particulier et une société au sujet d'un bail, portant sur la durée, survenu après exécution complète. Le contrat a été conclu par signature électronique qualifiée et l'affaire est jugée au fond. |
| CTX-097 | Litige entre une personne publique et une société au sujet d'une vente, portant sur la durée, survenu avant tout commencement d'exécution. Le contrat a été conclu sur papier et l'affaire est jugée au fond. |
| CTX-098 | Litige entre un particulier et une société au sujet d'un bail, portant sur une clause d'exclusivité, survenu avant tout commencement d'exécution. Le contrat a été conclu par signature électronique simple et l'affaire est soumise à un arbitre. |
| CTX-099 | Litige entre deux sociétés au sujet d'un prêt, portant sur la résiliation, survenu après exécution complète. Le contrat a été conclu sur papier et l'affaire est portée en référé. |
| CTX-100 | Litige entre un particulier et une société au sujet d'un prêt, portant sur la résiliation, survenu après exécution complète. Le contrat a été conclu par signature électronique simple et l'affaire est jugée au fond. |

Licence CC BY 4.0.
