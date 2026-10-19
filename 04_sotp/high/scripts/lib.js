// Shared helpers for the SOTP-High reference implementation (demonstration).
"use strict";

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const { buildPoseidon, buildBabyjub, buildPedersenHash } = require("circomlibjs");

const ROOT = path.resolve(__dirname, "..");
const BUILD = path.join(ROOT, "build");
const WASM = path.join(BUILD, "sotp_high_js", "sotp_high.wasm");
const ZKEY = path.join(BUILD, "sotp_high_final.zkey");
const VKEY = path.join(BUILD, "verification_key.json");

// Pedersen generators used in the circuit (circomlib pedersen.circom BASE[0], BASE[1]).
const G = [
  "10457101036533406547632367118273992217979173478358440826365724437999023779287",
  "19824078218392094440610104313265183977899662750282163392862422243483260492317",
];
const H = [
  "2671756056509184035029146175565761955751135805354291559563293617232983272177",
  "2663205510731142763556352975002641716101654201788071096152948830924149045094",
];

let _crypto = null;
async function primitives() {
  if (!_crypto) {
    const [poseidon, babyjub, pedersen] = await Promise.all([
      buildPoseidon(),
      buildBabyjub(),
      buildPedersenHash(),
    ]);
    _crypto = { poseidon, babyjub, pedersen };
  }
  return _crypto;
}

// Uniform rho in [0, l), l = order of the Baby Jubjub prime-order subgroup.
async function sampleRho() {
  const { babyjub } = await primitives();
  const l = BigInt(babyjub.subOrder.toString());
  // Rejection sampling over 256-bit strings reduced to the bit length of l.
  const bits = l.toString(2).length;
  const mask = (1n << BigInt(bits)) - 1n;
  for (;;) {
    const r = BigInt("0x" + crypto.randomBytes(32).toString("hex")) & mask;
    if (r < l) return r;
  }
}

// Off-circuit reference computation of the public statement (h_c, c_m).
async function expectedPublic(m, c, rho) {
  const { poseidon, babyjub } = await primitives();
  const F = babyjub.F;
  const hc = poseidon.F.toObject(poseidon(c.map((x) => BigInt(x))));
  const g = [F.e(G[0]), F.e(G[1])];
  const h = [F.e(H[0]), F.e(H[1])];
  const cm = babyjub.addPoint(
    babyjub.mulPointEscalar(g, BigInt(m)),
    babyjub.mulPointEscalar(h, BigInt(rho))
  );
  return {
    h_c: hc.toString(),
    cm_x: F.toObject(cm[0]).toString(),
    cm_y: F.toObject(cm[1]).toString(),
  };
}

// b2 of Algorithm SOTP-High: c_m is a point of the prime-order subgroup.
async function commitmentInGroup(cmx, cmy) {
  const { babyjub } = await primitives();
  const F = babyjub.F;
  const p = [F.e(BigInt(cmx)), F.e(BigInt(cmy))];
  return babyjub.inCurve(p) && babyjub.inSubgroup(p);
}

// Re-derive the generators from their nothing-up-my-sleeve seeds.
async function rederiveGenerators() {
  const { babyjub, pedersen } = await primitives();
  const F = babyjub.F;
  const pt = (i) => {
    const p = pedersen.getBasePoint("blake", i);
    return [F.toObject(p[0]).toString(), F.toObject(p[1]).toString()];
  };
  return { G: pt(0), H: pt(1) };
}

// Informative size of a Groth16 proof on BN254 in compressed form:
// A, C in G1 (32 bytes each), B in G2 (64 bytes) = 128 bytes.
const GROTH16_BN254_COMPRESSED_BYTES = 32 + 64 + 32;

function readJson(p) {
  return JSON.parse(fs.readFileSync(p, "utf8"));
}

function circuitInput(spec) {
  return {
    m: String(spec.m),
    c: spec.c.map(String),
    rho: String(spec.rho),
  };
}

module.exports = {
  ROOT,
  BUILD,
  WASM,
  ZKEY,
  VKEY,
  G,
  H,
  primitives,
  sampleRho,
  expectedPublic,
  commitmentInGroup,
  rederiveGenerators,
  GROTH16_BN254_COMPRESSED_BYTES,
  readJson,
  circuitInput,
};
