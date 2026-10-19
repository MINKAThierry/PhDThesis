#!/usr/bin/env bash
# Verify a SOTP-High proof directory (proof.json, public.json).
# Runs the standard snarkjs CLI verifier (b1), then scripts/verify.js (b1 and b2).
# Usage: scripts/verify.sh <dir> [verification_key.json]
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="${1:-$ROOT/build/out/conforme}"
VK="${2:-$ROOT/build/verification_key.json}"
[ -f "$VK" ] || VK="$ROOT/examples/verification_key.json"
echo "== snarkjs groth16 verify ($DIR)"
(cd "$ROOT" && npx --no-install snarkjs groth16 verify "$VK" "$DIR/public.json" "$DIR/proof.json")
echo "== SOTP-High Verify: b1 and b2"
node "$ROOT/scripts/verify.js" "$DIR" --vk "$VK"
