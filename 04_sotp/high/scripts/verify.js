#!/usr/bin/env node
// SOTP-High Verify(sigma): b1 = Groth16.Verify(vk, (h_c, c_m), pi),
// b2 = [c_m in G] (on Baby Jubjub and in the prime-order subgroup).
// Usage:
//   node scripts/verify.js <dir with proof.json and public.json> [--vk <vk.json>] [--open <opening.json>]
//
// --open additionally checks a revealed opening (m, c, rho) against (h_c, c_m),
// i.e. the verifiable opening allowed by the Iron layer.
// Exit code 0 iff accepted.
"use strict";

const fs = require("fs");
const path = require("path");
const snarkjs = require("snarkjs");
const lib = require("./lib");

async function main() {
  const args = process.argv.slice(2);
  const dir = args[0];
  if (!dir) {
    console.error("usage: node scripts/verify.js <dir> [--vk vk.json] [--open opening.json]");
    process.exit(64);
  }
  const opt = (name) => {
    const i = args.indexOf(name);
    return i >= 0 ? args[i + 1] : undefined;
  };
  const vkPath = opt("--vk") || (fs.existsSync(lib.VKEY) ? lib.VKEY : path.join(lib.ROOT, "examples", "verification_key.json"));
  const vk = lib.readJson(vkPath);
  const proof = lib.readJson(path.join(dir, "proof.json"));
  const pub = lib.readJson(path.join(dir, "public.json"));

  const t0 = process.hrtime.bigint();
  const b1 = await snarkjs.groth16.verify(vk, pub, proof);
  const verifyMs = Number(process.hrtime.bigint() - t0) / 1e6;
  const b2 = await lib.commitmentInGroup(pub[1], pub[2]);

  let ok = b1 && b2;
  console.log(`[verify] b1 Groth16.Verify = ${b1}  (${verifyMs.toFixed(1)} ms, cold: includes BN254 curve initialisation)`);
  console.log(`[verify] b2 c_m in subgroup = ${b2}`);

  const openPath = opt("--open");
  if (openPath) {
    const o = lib.readJson(openPath);
    const exp = await lib.expectedPublic(o.m, o.c, o.rho);
    const b3 = exp.h_c === pub[0] && exp.cm_x === pub[1] && exp.cm_y === pub[2];
    console.log(`[verify] opening (m, c, rho) matches (h_c, c_m) = ${b3}`);
    ok = ok && b3;
  }
  console.log(ok ? "[verify] ACCEPT" : "[verify] REJECT");
  return ok ? 0 : 1;
}

main()
  .then((code) => process.exit(code))
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
