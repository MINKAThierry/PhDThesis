#!/usr/bin/env bash
# Audit du dossier de vérification Lean (04_sotp/preuves_game_based/lean).
#
# Usage, depuis n'importe quel dossier :
#   bash 04_sotp/preuves_game_based/lean/verifier.sh            # Mathlib déjà téléchargée
#   bash 04_sotp/preuves_game_based/lean/verifier.sh --cache    # lance d'abord lake exe cache get
#
# Le script échoue (code de sortie 1) si
#   1. Verification/Enonces.lean contient une preuve ou autre chose que des
#      définitions `def Nom : Prop := ...` ;
#   2. sorry, admit, native_decide ou une déclaration `axiom` apparaît dans les
#      sources (GameBasedSOTP.lean et Verification/*.lean, commentaires exclus) ;
#   3. Principal.lean ne relie pas chaque énoncé à un théorème existant, une
#      ligne par énoncé ;
#   4. la compilation échoue ou signale un `sorry` ;
#   5. un `#print axioms` sur un théorème de Principal.lean affiche autre chose
#      que [propext, Classical.choice, Quot.sound], ou un lemme de Coherence.lean
#      dépend d'un axiome hors de cette liste ;
#   6. un vérificateur indépendant du noyau fourni avec la chaîne Lean
#      (leanchecker, puis leanexport et nanoda_bin) rejette les déclarations.
#      Un outil absent est signalé comme non testé, sans échec.
#   Option --sans-noyau : saute l'étape 6.
# Sorties : results/verification.log et results/axiomes.txt.
# Le script ne modifie jamais GameBasedSOTP.lean ni les fichiers de Verification.

set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

LOG=results/verification.log
AX=results/axiomes.txt
mkdir -p results
: > "$LOG"
echec=0
note()  { echo "$*" | tee -a "$LOG"; }
ok()    { note "OK     $*"; }
fail()  { note "ECHEC  $*"; echec=1; }

PY=python3
command -v "$PY" >/dev/null 2>&1 || PY=python

# Retire les commentaires Lean (/- ... -/ imbriqués, docstrings et --).
sans_commentaires() {
  "$PY" - "$1" <<'EOF'
import sys
s = open(sys.argv[1], encoding="utf-8").read()
out, i, depth, n = [], 0, 0, len(s)
while i < n:
    if s.startswith("/-", i):
        depth += 1; i += 2; continue
    if depth and s.startswith("-/", i):
        depth -= 1; i += 2; continue
    if depth:
        if s[i] == "\n": out.append("\n")
        i += 1; continue
    if s.startswith("--", i):
        j = s.find("\n", i); i = n if j < 0 else j; continue
    out.append(s[i]); i += 1
sys.stdout.write("".join(out))
EOF
}

note "Dossier de vérification Lean, $(date -u '+%Y-%m-%d %H:%M UTC')"
note "Lean : $(lean --version 2>/dev/null || echo 'introuvable')"
note "Commit du dépôt : $(git rev-parse --short HEAD 2>/dev/null || echo 'inconnu')"
note "SHA-256 GameBasedSOTP.lean : $(sha256sum GameBasedSOTP.lean | cut -d' ' -f1)"
note ""

SOURCES="GameBasedSOTP.lean Verification/Enonces.lean Verification/Principal.lean Verification/Coherence.lean"
for f in $SOURCES; do
  [ -f "$f" ] || { fail "fichier absent : $f"; }
done
[ "$echec" -eq 0 ] || { note "Arrêt : fichiers manquants."; exit 1; }

# 1. Enonces.lean ne contient aucune preuve
note "1. Énoncés seuls (Verification/Enonces.lean)"
E_SANS=$(sans_commentaires Verification/Enonces.lean)
if echo "$E_SANS" | grep -nE '(^|[^A-Za-z_.])by([^A-Za-z_]|$)' >> "$LOG"; then
  fail "Enonces.lean contient le mot-clé by (preuve par tactique)"
else ok "aucune tactique by"; fi
if echo "$E_SANS" | grep -nE '^\s*(@\[[^]]*\]\s*)?(private |protected |noncomputable )*(theorem|lemma|example|instance|abbrev|opaque|axiom|structure|inductive|class|macro|elab|syntax|notation)\b' >> "$LOG"; then
  fail "Enonces.lean contient une déclaration autre que def"
else ok "aucune déclaration theorem, lemma, example, instance, abbrev ou axiom"; fi
NDEF=$(echo "$E_SANS" | grep -cE '^\s*def ')
NPROP=$(echo "$E_SANS" | grep -cE '^\s*def [A-Za-z0-9_]+ : Prop :=')
if [ "$NDEF" -gt 0 ] && [ "$NDEF" -eq "$NPROP" ]; then
  ok "$NDEF définitions, toutes de la forme def Nom : Prop :="
else
  fail "$NDEF définitions dont seulement $NPROP de la forme def Nom : Prop :="
fi

# 2. Mots interdits dans les sources
note ""
note "2. Mots interdits dans les sources (commentaires exclus)"
for f in $SOURCES; do
  if sans_commentaires "$f" | grep -nE '(^|[^A-Za-z_.])(sorry|admit|native_decide)([^A-Za-z_]|$)|^\s*(@\[[^]]*\]\s*)?(private |protected )?axiom\s|implemented_by|@\[extern' > /tmp/verif_interdits.txt; then
    sed "s|^|  $f:|" /tmp/verif_interdits.txt >> "$LOG"
    fail "$f contient sorry, admit, native_decide, axiom ou implemented_by"
  else ok "$f"; fi
done

# 3. Principal.lean : une ligne par énoncé, vers un théorème existant
note ""
note "3. Point d'entrée (Verification/Principal.lean)"
P_SANS=$(sans_commentaires Verification/Principal.lean)
NTHM=$(echo "$P_SANS" | grep -cE '^\s*theorem ')
NBON=$(echo "$P_SANS" | grep -cE '^theorem principal_[A-Za-z0-9_]+ : Enonces\.[A-Za-z0-9_]+ := [A-Za-z0-9_.]+\s*$')
if [ "$NTHM" -eq "$NBON" ] && [ "$NTHM" -gt 0 ]; then
  ok "$NTHM théorèmes de la forme theorem principal_x : Enonces.X := nomExistant"
else
  fail "$NTHM théorèmes dont $NBON seulement de la forme attendue"
fi
DEFS=$(echo "$E_SANS" | grep -oE '^\s*def [A-Za-z0-9_]+' | awk '{print $2}' | sort)
USES=$(echo "$P_SANS" | grep -oE 'Enonces\.[A-Za-z0-9_]+' | sed 's/Enonces\.//' | sort)
if [ "$DEFS" = "$USES" ]; then
  ok "chaque énoncé est utilisé exactement une fois"
else
  fail "énoncés et lignes de Principal.lean ne correspondent pas"
  diff <(echo "$DEFS") <(echo "$USES") >> "$LOG"
fi

# 4. Compilation
note ""
note "4. Compilation"
if [[ " $* " == *" --cache "* ]]; then
  lake exe cache get >> "$LOG" 2>&1 || fail "lake exe cache get"
fi
BUILD=$(mktemp)
if lake build GameBasedSOTP Verification > "$BUILD" 2>&1; then
  ok "lake build GameBasedSOTP Verification"
else
  fail "lake build GameBasedSOTP Verification"
fi
grep -E '^(error|warning)' "$BUILD" | grep -v 'module system' >> "$LOG"
if grep -q "declaration uses 'sorry'" "$BUILD"; then fail "la compilation signale un sorry"; fi
NWARN=$(grep -E '^warning' "$BUILD" | grep -vc 'module system')
note "       avertissements (hors module system) : $NWARN"
tail -1 "$BUILD" | tee -a "$LOG"
rm -f "$BUILD"

# 5. Axiomes
note ""
note "5. Axiomes (#print axioms)"
ATTENDU="[propext, Classical.choice, Quot.sound]"
TMPD=$(mktemp -d)
AUDIT="$TMPD/AuditAxiomes.lean"
{
  echo "import Verification.Principal"
  echo "import Verification.Coherence"
  echo "$P_SANS" | grep -oE '^theorem principal_[A-Za-z0-9_]+' | awk '{print "#print axioms Principal." $2}'
  sans_commentaires Verification/Coherence.lean | grep -oE '^\s*lemma [A-Za-z0-9_]+' | awk '{print "#print axioms Coherence." $2}'
} > "$AUDIT"
lake env lean "$AUDIT" > "$AX" 2>&1 || fail "exécution de #print axioms"
rm -rf "$TMPD"
NP=$(grep -c "^'Principal\." "$AX")
NPOK=$(grep -cF "depends on axioms: $ATTENDU" <(grep "^'Principal\." "$AX"))
if [ "$NP" -eq "$NTHM" ] && [ "$NP" -eq "$NPOK" ]; then
  ok "$NP théorèmes de Principal.lean, tous $ATTENDU"
else
  fail "$NPOK théorèmes sur $NTHM affichent exactement $ATTENDU"
  grep "^'Principal\." "$AX" | grep -vF "$ATTENDU" >> "$LOG"
fi
# Coherence : seuls des sous-ensembles des trois axiomes standard sont admis.
NC=$(grep -c "^'Coherence\." "$AX")
NCMAL=$("$PY" - "$AX" <<'EOF'
import re, sys
ok = {"propext", "Classical.choice", "Quot.sound"}
bad = 0
for line in open(sys.argv[1], encoding="utf-8"):
    if not line.startswith("'Coherence."):
        continue
    m = re.search(r"depends on axioms: \[(.*)\]", line)
    if m and not set(a.strip() for a in m.group(1).split(",")) <= ok:
        bad += 1
    elif not m and "does not depend on any axioms" not in line:
        bad += 1
print(bad)
EOF
)
if [ "$NCMAL" -eq 0 ] && [ "$NC" -gt 0 ]; then
  ok "$NC lemmes de Coherence.lean, axiomes standard seulement"
else
  fail "$NCMAL lemmes de Coherence.lean sur $NC avec un axiome non standard"
fi
if grep -q "sorryAx" "$AX"; then fail "sorryAx apparaît dans $AX"; fi

# 6. Vérification indépendante du noyau
note ""
note "6. Vérification indépendante du noyau"
if [[ " $* " == *" --sans-noyau "* ]]; then
  note "NON TESTÉ  étape sautée (--sans-noyau)"
else
  if lake env which leanchecker > /dev/null 2>&1; then
    for m in GameBasedSOTP Verification.Enonces Verification.Principal Verification.Coherence; do
      if lake env leanchecker "$m" >> "$LOG" 2>&1; then ok "leanchecker $m (rejeu par le noyau de Lean)"
      else fail "leanchecker $m"; fi
    done
  else
    note "NON TESTÉ  leanchecker absent de la chaîne Lean"
  fi
  if lake env which leanexport > /dev/null 2>&1 && lake env which nanoda_bin > /dev/null 2>&1; then
    TMPN=$(mktemp -d)
    DECLS=$(echo "$P_SANS" | grep -oE '^theorem principal_[A-Za-z0-9_]+' | awk '{print "Principal." $2}')
    # shellcheck disable=SC2086
    if lake env leanexport Verification.Principal -- $DECLS > "$TMPN/principal.export" 2>> "$LOG"; then
      printf '%s\n' "{" \
        "  \"export_file_path\": \"$TMPN/principal.export\"," \
        "  \"use_stdin\": false," \
        "  \"permitted_axioms\": [\"propext\", \"Classical.choice\", \"Quot.sound\"]," \
        "  \"unpermitted_axiom_hard_error\": false," \
        "  \"nat_extension\": true," \
        "  \"string_extension\": true," \
        "  \"pp_declars\": []," \
        "  \"pp_to_stdout\": false," \
        "  \"print_success_message\": true" \
        "}" > "$TMPN/nanoda.json"
      if lake env nanoda_bin "$TMPN/nanoda.json" >> "$LOG" 2>&1; then
        ok "nanoda_bin, second vérificateur écrit en Rust, sur Principal.lean et ses dépendances"
      else
        fail "nanoda_bin rejette l'export de Principal.lean"
      fi
    else
      fail "leanexport Verification.Principal"
    fi
    rm -rf "$TMPN"
  else
    note "NON TESTÉ  leanexport ou nanoda_bin absent de la chaîne Lean"
  fi
fi

note ""
if [ "$echec" -eq 0 ]; then
  note "RÉSULTAT : vérification réussie."
  exit 0
else
  note "RÉSULTAT : vérification en échec (voir les lignes ECHEC)."
  exit 1
fi
