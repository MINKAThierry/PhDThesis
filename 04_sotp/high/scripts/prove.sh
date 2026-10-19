#!/usr/bin/env bash
# Wrapper: generate a witness and a Groth16 proof from an input JSON file.
# Usage: scripts/prove.sh <input.json> [out_dir]   (default out_dir: build/out/<basename>)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN="$1"
OUT="${2:-$ROOT/build/out/$(basename "$IN" .json)}"
exec node "$ROOT/scripts/prove.js" "$IN" "$OUT"
