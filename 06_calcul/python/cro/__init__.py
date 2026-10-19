"""Outils de calcul accompagnant la thèse « Aux fondements de la cryptographie
institutionnelle » (T. E. Minka Mi Nguidjoï, LIMSI/ENSP, Université de Yaoundé I).

Modules
-------
information   entropies et informations mutuelles conditionnelles (lois finies)
bornes        bornes du Trilemme CRO (formes publiée, explicite, raffinée), Fano, seuil H♯
sotp          expressions heuristiques de conception des variantes SOTP (chapitre 3)
donnees       lecture des fichiers de data/

Statut des résultats : les métriques CLO des systèmes déployés sont une
calibration illustrative sur l'échelle opérationnelle CLO (fiabilité de
vérification Rel_ver). Ces systèmes ne sont pas des instances du Théorème
du trilemme, qui porte sur la fiabilité de reconstruction Rel_rec
(voir 03_resultats_these/resultats_these_fr.md du dépôt PhDThesis).
"""

__version__ = "1.0.0"
