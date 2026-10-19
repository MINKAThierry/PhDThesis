#!/usr/bin/env bash
# End-to-end run of the SOTP-High reference implementation:
# install -> build (compile + local demo setup) -> prove -> verify -> negative cases -> tests.
# Set REBUILD=1 to force a fresh compile and setup even if build/ already exists.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "### 1. npm dependencies"
if [ ! -d node_modules ]; then
  if [ -f package-lock.json ]; then npm ci; else npm install; fi
fi

echo "### 2. build (circuit + local Groth16 setup, DEMONSTRATION ONLY)"
if [ "${REBUILD:-0}" = "1" ] || [ ! -f build/sotp_high_final.zkey ]; then
  bash scripts/build.sh
else
  echo "   build/sotp_high_final.zkey present, skipping (REBUILD=1 to force)"
fi

echo "### 3. prove (compliant inputs)"
for f in conforme conforme_limite; do
  bash scripts/prove.sh "inputs/$f.json" "build/out/$f"
done

echo "### 4. verify"
bash scripts/verify.sh build/out/conforme
node scripts/verify.js build/out/conforme --open build/out/conforme/opening.json

echo "### 5. negative cases (witness generation must fail)"
for f in non_conforme seuil_atteint type_non_autorise hors_plage; do
  set +e
  node scripts/prove.js "inputs/$f.json" "build/out/$f" 2>/dev/null
  rc=$?
  set -e
  if [ "$rc" -eq 2 ]; then
    echo "   $f: no witness (expected)"
  else
    echo "   $f: UNEXPECTED exit code $rc"; exit 1
  fi
done

echo "### 6. refresh examples/ (verification key, one proof and its public signals)"
cp build/verification_key.json examples/verification_key.json
cp build/out/conforme/proof.json examples/proof.json
cp build/out/conforme/public.json examples/public.json
cp build/out/conforme/sigma.json examples/sigma.json
node scripts/verify.js examples --vk examples/verification_key.json

echo "### 7. tests"
node --test test/sotp_high.test.js

echo "### run_all: all steps passed"
