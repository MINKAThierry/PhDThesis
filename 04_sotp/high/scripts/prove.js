#!/usr/bin/env node
// SOTP-High Prove(pk, m, c): generate a witness from an input JSON file and a
// Groth16 proof. Usage:
//   node scripts/prove.js <input.json> <out_dir>
//
// Input JSON: { "m": <amount>, "c": [c0, c1, c2, c3], "rho": <optional> }
// If "rho" is absent, it is sampled uniformly in [0, l) (Baby Jubjub subgroup).
//
// Outputs in <out_dir>:
//   proof.json   Groth16 proof pi (snarkjs format)
//   public.json  public signals [h_c, cm_x, cm_y]
//   sigma.json   sigma = (h_c, pi, c_m, metadata), Algorithm SOTP-High line 13
//   opening.json SECRET opening (m, c, rho) kept by the prover (git-ignored)
//
// Exit code 2 if no witness exists (e.g. Conforme(m, c) = 0).
"use strict";

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const snarkjs = require("snarkjs");
const lib = require("./lib");

async function main() {
  const [inputPath, outDir] = process.argv.slice(2);
  if (!inputPath || !outDir) {
    console.error("usage: node scripts/prove.js <input.json> <out_dir>");
    process.exit(64);
  }
  const spec = lib.readJson(inputPath);
  if (spec.rho === undefined) spec.rho = (await lib.sampleRho()).toString();
  const input = lib.circuitInput(spec);

  // 1) Witness generation. Fails if the relation R has no witness for (m, c).
  const t0 = process.hrtime.bigint();
  let proof, publicSignals;
  try {
    ({ proof, publicSignals } = await snarkjs.groth16.fullProve(input, lib.WASM, lib.ZKEY));
  } catch (e) {
    const msg = String(e && e.message ? e.message : e).split("\n")[0];
    console.error(`[prove] NO WITNESS for ${inputPath}: ${msg}`);
    console.error("[prove] the circuit constraints (Conforme(m, c) = 1 or range checks) are not satisfied");
    return 2;
  }
  const proveMs = Number(process.hrtime.bigint() - t0) / 1e6;

  // 2) Cross-check the public statement against an off-circuit computation.
  const exp = await lib.expectedPublic(input.m, input.c, input.rho);
  const got = { h_c: publicSignals[0], cm_x: publicSignals[1], cm_y: publicSignals[2] };
  for (const k of Object.keys(exp)) {
    if (exp[k] !== got[k]) throw new Error(`public signal ${k} mismatch: ${got[k]} != ${exp[k]}`);
  }

  const vk = fs.readFileSync(lib.VKEY);
  const sigma = {
    h_c: got.h_c,
    c_m: { x: got.cm_x, y: got.cm_y },
    pi: proof,
    metadata: {
      scheme: "SOTP-High (reference implementation, demonstration)",
      proof_system: "Groth16 / BN254 (snarkjs bn128)",
      circuit: "circuits/sotp_high.circom",
      predicate: "ConformeAML example: m < c[0] and c[1] in {1,2,3}",
      context_hash: "Poseidon(c[0..3]) over the BN254 scalar field",
      commitment: "Pedersen on Baby Jubjub, c_m = m*G + rho*H (circomlib Pedersen BASE[0], BASE[1])",
      verification_key_sha256: crypto.createHash("sha256").update(vk).digest("hex"),
      trusted_setup: "LOCAL single-party demonstration ceremony, NOT secure",
    },
  };

  fs.mkdirSync(outDir, { recursive: true });
  const w = (f, o) => fs.writeFileSync(path.join(outDir, f), JSON.stringify(o, null, 2) + "\n");
  w("proof.json", proof);
  w("public.json", publicSignals);
  w("sigma.json", sigma);
  w("opening.json", { _warning: "SECRET opening of c_m, do not publish", m: input.m, c: input.c, rho: input.rho });

  console.log(`[prove] witness + Groth16 proof OK for ${inputPath} in ${proveMs.toFixed(0)} ms`);
  console.log(`[prove] h_c  = ${got.h_c}`);
  console.log(`[prove] c_m  = (${got.cm_x}, ${got.cm_y})`);
  console.log(`[prove] wrote ${outDir}/{proof,public,sigma,opening}.json`);
  return 0;
}

main()
  .then((code) => process.exit(code))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
