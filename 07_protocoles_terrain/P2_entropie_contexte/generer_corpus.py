# SPDX-License-Identifier: MIT
"""Generate the 100-context corpus of P2 (MDS approach) in French and English.

PROPOSAL - field protocol not deployed.

Each context is a combination of levels of six elements of the structural
decomposition grid (two per component L, T, R), drawn without repetition
with a fixed seed. Building the corpus from the grid has two advantages:
the corpus covers the variability the experts are asked about in
approach 1, and the factor levels of every context are known, so the MDS
dimensions can later be compared with the grid elements.

Corpus: CTX-001..CTX-034 ELEC, CTX-035..CTX-067 FIN, CTX-068..CTX-100 CONT.

Usage::

    python3 generer_corpus.py           # writes corpus_contextes_{fr,en}.md and corpus_contextes.csv
    python3 generer_corpus.py --check   # regenerates and compares with the committed files
"""
from __future__ import annotations

import argparse
import csv
import io
import random
from pathlib import Path

HERE = Path(__file__).parent
SEED = 20261012
COUNTS = {"ELEC": 34, "FIN": 33, "CONT": 33}

# element code, component, French levels, English levels
ELEMENTS = {
    "ELEC": [
        ("E1", "L", ["d'une élection présidentielle", "d'une élection législative", "d'une élection municipale",
                     "de l'élection d'un ordre professionnel", "de l'élection d'une association"],
                    ["a presidential election", "a parliamentary election", "a municipal election",
                     "the election of a professional order", "the election of an association"]),
        ("E4", "L", ["l'éligibilité d'un candidat", "la régularité d'un vote", "le dépouillement",
                     "la proclamation des résultats"],
                    ["a candidate's eligibility", "the regularity of a vote", "the count",
                     "the announcement of the results"]),
        ("E5", "T", ["pendant la campagne", "le jour du vote", "pendant le dépouillement", "après la proclamation"],
                    ["during the campaign", "on polling day", "during the count", "after the announcement"]),
        ("E7", "T", ["dans les délais", "hors délai", "à une date contestée"],
                    ["within the time limit", "after the time limit", "on a disputed date"]),
        ("E8", "R", ["la commission électorale", "le juge administratif", "le juge constitutionnel"],
                    ["the electoral commission", "the administrative court", "the constitutional court"]),
        ("E9", "R", ["à l'urne", "par voie électronique sur place", "par voie électronique à distance"],
                    ["with paper ballots", "electronically at the polling station", "electronically and remotely"]),
    ],
    "FIN": [
        ("F1", "L", ["prudentielle", "de lutte contre le blanchiment", "fiscale", "comptable"],
                    ["prudential", "anti-money-laundering", "tax", "accounting"]),
        ("F2", "L", ["une banque", "un établissement de microfinance", "une compagnie d'assurance",
                     "une entreprise publique", "une plateforme de cryptoactifs"],
                    ["a bank", "a microfinance institution", "an insurance company",
                     "a state-owned company", "a crypto-asset platform"]),
        ("F5", "T", ["l'exercice en cours", "le dernier exercice clos", "les trois derniers exercices"],
                    ["the current financial year", "the last closed financial year", "the last three financial years"]),
        ("F6", "T", ["sans antécédent", "ayant déjà reçu des observations", "déjà sanctionnée"],
                    ["with no prior record", "that has already received observations", "already sanctioned"]),
        ("F8", "R", ["sur pièces", "sur place", "par un auditeur externe", "dans le cadre d'une enquête"],
                    ["on documents", "on site", "by an external auditor", "as part of an investigation"]),
        ("F10", "R", ["un classement", "une injonction", "une sanction", "une transmission au parquet"],
                     ["closure", "an injunction", "a sanction", "referral to the prosecutor"]),
    ],
    "CONT": [
        ("C1", "L", ["deux particuliers", "un particulier et une société", "deux sociétés",
                     "une personne publique et une société"],
                    ["two individuals", "an individual and a company", "two companies",
                     "a public body and a company"]),
        ("C2", "L", ["d'un bail", "d'une vente", "d'un contrat de prestation", "d'un prêt", "d'un contrat de travail"],
                    ["a lease", "a sale", "a service contract", "a loan", "an employment contract"]),
        ("C3", "L", ["le prix", "la durée", "la résiliation", "une clause d'exclusivité"],
                    ["the price", "the duration", "termination", "an exclusivity clause"]),
        ("C6", "T", ["avant tout commencement d'exécution", "en cours d'exécution", "après exécution complète",
                     "après résiliation"],
                    ["before any performance", "during performance", "after full performance",
                     "after termination"]),
        ("C8", "R", ["sur papier", "par signature électronique simple", "par signature électronique qualifiée"],
                    ["on paper", "with a simple electronic signature", "with a qualified electronic signature"]),
        ("C10", "R", ["portée en référé", "jugée au fond", "soumise à un arbitre"],
                     ["brought in summary proceedings", "heard on the merits", "submitted to an arbitrator"]),
    ],
}

TEMPLATES = {
    "ELEC": ("Contestation portant sur {E4} lors {E1}, soulevée {E5} et {E7}, devant {E8}. "
             "Le scrutin se déroule {E9}.",
             "Challenge concerning {E4} in {E1}, raised {E5} and {E7}, before {E8}. "
             "Voting takes place {E9}."),
    "FIN": ("Contrôle de conformité {F1} visant {F2} {F6}, portant sur {F5}, mené {F8}. "
            "La suite envisagée est {F10}.",
            "{F1_cap} compliance control of {F2} {F6}, covering {F5}, carried out {F8}. "
            "The contemplated outcome is {F10}."),
    "CONT": ("Litige entre {C1} au sujet {C2}, portant sur {C3}, survenu {C6}. "
             "Le contrat a été conclu {C8} et l'affaire est {C10}.",
             "Dispute between {C1} about {C2}, concerning {C3}, arising {C6}. "
             "The contract was concluded {C8} and the case is {C10}."),
}


def build() -> list[dict]:
    rng = random.Random(SEED)
    rows, n = [], 0
    for domain in ("ELEC", "FIN", "CONT"):
        elems = ELEMENTS[domain]
        seen = set()
        while len(seen) < COUNTS[domain]:
            combo = tuple(rng.randrange(len(fr)) for _, _, fr, _ in elems)
            if combo in seen:
                continue
            seen.add(combo)
            n += 1
            fr_vals = {code: fr[i] for (code, _, fr, _), i in zip(elems, combo)}
            en_vals = {code: en[i] for (code, _, _, en), i in zip(elems, combo)}
            en_vals.update({k + "_cap": v[:1].upper() + v[1:] for k, v in en_vals.items()})
            rows.append({
                "id_ctx": f"CTX-{n:03d}", "domaine": domain,
                "niveaux": ";".join(f"{code}={i + 1}" for (code, *_), i in zip(elems, combo)),
                "texte_fr": TEMPLATES[domain][0].format(**fr_vals),
                "texte_en": TEMPLATES[domain][1].format(**en_vals),
            })
    return rows


HEAD = {
    "fr": ("# Corpus des 100 contextes (P2, approche MDS)\n\n"
           "> **Statut : PROPOSITION — protocole non déployé** · Source : thèse, chapitre 4, §4.2.2.3 "
           "(« un ensemble de $n_{\\text{ctx}} = 100$ contextes variés »)\n\n"
           "[English version](corpus_contextes_en.md) · [Protocole de dissimilarité](protocole_dissimilarite_mds_fr.md)\n\n"
           "Fichier produit par [generer_corpus.py](generer_corpus.py), ne pas modifier à la main. "
           "Chaque contexte combine un niveau de six éléments de la "
           "[grille de décomposition](grille_decomposition_structurelle_fr.md), deux par composante L, T et R. "
           "Les combinaisons sont tirées sans répétition avec une graine fixe. Les niveaux de chaque contexte "
           "figurent dans [corpus_contextes.csv](corpus_contextes.csv). Ils servent à comparer après coup "
           "les dimensions de la MDS aux éléments de la grille. Les experts ne les voient pas.\n\n"
           "La rédaction est volontairement uniforme, afin que la dissimilarité jugée porte sur le contenu "
           "et non sur le style. Elle peut être reprise par l'équipe à condition de garder une forme commune "
           "**[à arrêter par l'équipe]**. Tous les contextes sont fictifs.\n\n"),
    "en": ("# Corpus of the 100 contexts (P2, MDS approach)\n\n"
           "> **Status: PROPOSAL — protocol not deployed** · Source: thesis, Chapter 4, §4.2.2.3 "
           "(“a set of $n_{\\text{ctx}} = 100$ varied contexts”)\n\n"
           "[Version française](corpus_contextes_fr.md) · [Dissimilarity protocol](protocole_dissimilarite_mds_en.md)\n\n"
           "File produced by [generer_corpus.py](generer_corpus.py), do not edit by hand. "
           "Each context combines one level of six elements of the "
           "[decomposition grid](grille_decomposition_structurelle_en.md), two per component L, T and R. "
           "The combinations are drawn without repetition with a fixed seed. The levels of each context are "
           "in [corpus_contextes.csv](corpus_contextes.csv). They are used afterwards to compare the MDS "
           "dimensions with the grid elements. The experts do not see them.\n\n"
           "The wording is deliberately uniform, so that the judged dissimilarity bears on content and not "
           "on style. The team may rewrite it provided a common form is kept **[to be decided by the team]**. "
           "The experts work on the French version. All contexts are fictitious.\n\n"),
}
SECTION = {"fr": {"ELEC": "Contentieux électoral (`ELEC`)", "FIN": "Conformité financière (`FIN`)",
                  "CONT": "Signature contractuelle (`CONT`)"},
           "en": {"ELEC": "Electoral disputes (`ELEC`)", "FIN": "Financial compliance (`FIN`)",
                  "CONT": "Contract signature (`CONT`)"}}


def render(rows: list[dict]) -> dict[str, str]:
    out = {}
    for lang in ("fr", "en"):
        parts = [HEAD[lang]]
        for domain in ("ELEC", "FIN", "CONT"):
            sub = [r for r in rows if r["domaine"] == domain]
            parts.append(f"## {SECTION[lang][domain]}, {len(sub)} contextes\n\n" if lang == "fr"
                         else f"## {SECTION[lang][domain]}, {len(sub)} contexts\n\n")
            parts.append("| Code | Contexte |\n|---|---|\n" if lang == "fr" else "| Code | Context |\n|---|---|\n")
            parts += [f"| {r['id_ctx']} | {r['texte_' + lang]} |\n" for r in sub]
            parts.append("\n")
        parts.append("Licence CC BY 4.0.\n")
        out[f"corpus_contextes_{lang}.md"] = "".join(parts)
    buf = io.StringIO()
    w = csv.writer(buf, lineterminator="\r\n")
    w.writerow(["id_ctx", "domaine", "niveaux", "texte_fr", "texte_en"])
    for r in rows:
        w.writerow([r["id_ctx"], r["domaine"], r["niveaux"], r["texte_fr"], r["texte_en"]])
    out["corpus_contextes.csv"] = buf.getvalue()
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    files = render(build())
    if args.check:
        bad = [n for n, t in files.items()
               if not (HERE / n).exists() or (HERE / n).read_bytes() != t.encode("utf-8")]
        print("identique aux fichiers versionnés" if not bad else f"DIFFÉRENT : {bad}")
        raise SystemExit(1 if bad else 0)
    for n, t in files.items():
        (HERE / n).write_bytes(t.encode("utf-8"))
        print(f"écrit : {n}")


if __name__ == "__main__":
    main()
