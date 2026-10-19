#!/usr/bin/env bash
# Regenerates every computational output of 06_calcul/ into results/.
# The Lean formalisation lives in ../05_formalisation_lean; its build log is
# written to ../05_formalisation_lean/results/lean_build.log.
#
# Usage: ./reproduire.sh             (Python + Lean)
#        ./reproduire.sh --sans-lean (Python only)
set -euo pipefail
cd "$(dirname "$0")"
LEAN_DIR="../05_formalisation_lean"
mkdir -p results

echo "== Python: tests"
python3 -m pytest -q tests | tee results/pytest.log

echo "== Python: classical calibration (lambda = 128)"
python3 python/validate_sotp.py --system all --type classical --lambda 128 \
    --out results/calibration_classique_l128.csv | tee results/calibration_classique_l128.txt
echo "== Python: post-quantum calibration (lambda = 128)"
python3 python/validate_sotp.py --system all --type postquantum --lambda 128 \
    --out results/calibration_pq_l128.csv | tee results/calibration_pq_l128.txt
echo "== Python: sensitivity to eta_q"
python3 python/sensitivity_eta_q.py --range 0.01:0.20 --steps 20 \
    --out results/sensibilite_eta_q.csv | tee results/sensibilite_eta_q.txt
echo "== Python: 14 numerical checks"
python3 python/verifications.py | tee results/verifications_output.txt

if [[ "${1:-}" != "--sans-lean" ]]; then
  echo "== Lean: build (Lean 4.34.0, Mathlib v4.34.0) in ${LEAN_DIR}"
  mkdir -p "${LEAN_DIR}/results"
  ( cd "${LEAN_DIR}" && lake exe cache get && lake build && lake env lean ConditionalCRO.lean ) \
      2>&1 | tee "${LEAN_DIR}/results/lean_build.log"
  ( cd "${LEAN_DIR}/results" && sha256sum lean_build.log > SHA256SUMS )
fi

echo "== Checksums"
( cd results && sha256sum *.csv *.txt > SHA256SUMS )   # pytest.log excluded (variable timings)
echo "Done: see results/"
