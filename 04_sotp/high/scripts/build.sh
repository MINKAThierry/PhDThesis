#!/usr/bin/env bash
# Compile the SOTP-High circuit and run a LOCAL Groth16 setup on BN254 (bn128).
#
# WARNING: DEMONSTRATION ONLY. The Powers of Tau and the circuit-specific
# phase 2 below are produced on this machine by a single party with entropy
# drawn from /dev/urandom. Whoever runs this script could keep the toxic
# waste and forge proofs. A real deployment requires a multi-party ceremony
# (the thesis lists the trusted setup as a limitation of SOTP-High).
#
# Outputs (in build/): sotp_high.r1cs, sotp_high_js/sotp_high.wasm,
# pot_final.ptau, sotp_high_final.zkey, verification_key.json.
# The .ptau and .zkey files are large and git-ignored; rerun this script to
# regenerate them. examples/verification_key.json is refreshed at the end.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

POWER="${POWER:-13}"          # 2^13 = 8192 >= number of constraints (~6.1k)
BUILD="build"
CIRCUIT="circuits/sotp_high.circom"
NAME="sotp_high"
SNARKJS="npx --no-install snarkjs"
CIRCOM="npx --no-install circom2"

rand() { head -c 32 /dev/urandom | od -An -tx1 | tr -d ' \n'; }

mkdir -p "$BUILD"

echo "== [1/6] Compiling circuit (circom2 / circom 2.x WebAssembly)"
$CIRCOM "$CIRCUIT" --r1cs --wasm --sym -o "$BUILD"
$SNARKJS r1cs info "$BUILD/$NAME.r1cs"

echo "== [2/6] Powers of Tau (phase 1, local, 2^$POWER) -- DEMONSTRATION ONLY"
if [ ! -f "$BUILD/pot_final.ptau" ]; then
  $SNARKJS powersoftau new bn128 "$POWER" "$BUILD/pot_0000.ptau"
  $SNARKJS powersoftau contribute "$BUILD/pot_0000.ptau" "$BUILD/pot_0001.ptau" \
    --name="local demo contribution" -e="$(rand)"
  $SNARKJS powersoftau prepare phase2 "$BUILD/pot_0001.ptau" "$BUILD/pot_final.ptau"
  rm -f "$BUILD/pot_0000.ptau" "$BUILD/pot_0001.ptau"
else
  echo "   reusing existing $BUILD/pot_final.ptau"
fi

echo "== [3/6] Groth16 circuit-specific setup (phase 2)"
$SNARKJS groth16 setup "$BUILD/$NAME.r1cs" "$BUILD/pot_final.ptau" "$BUILD/${NAME}_0000.zkey"

echo "== [4/6] Phase 2 contribution (local, DEMONSTRATION ONLY)"
$SNARKJS zkey contribute "$BUILD/${NAME}_0000.zkey" "$BUILD/${NAME}_final.zkey" \
  --name="local demo phase2 contribution" -e="$(rand)"
rm -f "$BUILD/${NAME}_0000.zkey"
$SNARKJS zkey verify "$BUILD/$NAME.r1cs" "$BUILD/pot_final.ptau" "$BUILD/${NAME}_final.zkey"

echo "== [5/6] Exporting verification key"
$SNARKJS zkey export verificationkey "$BUILD/${NAME}_final.zkey" "$BUILD/verification_key.json"

echo "== [6/6] Copying verification key to examples/"
mkdir -p examples
cp "$BUILD/verification_key.json" examples/verification_key.json

echo "Build done."
