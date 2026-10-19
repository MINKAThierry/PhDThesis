// Tests for the SOTP-High reference implementation (node:test, Node >= 18).
// Requires a prior `bash scripts/build.sh`.
"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const fs = require("fs");
const path = require("path");
const snarkjs = require("snarkjs");
const lib = require("../scripts/lib");

const INPUTS = path.join(lib.ROOT, "inputs");
const load = (f) => lib.readJson(path.join(INPUTS, f));

let vk;
let honest; // { proof, publicSignals, input }

async function prove(spec) {
  const s = { ...spec };
  if (s.rho === undefined) s.rho = (await lib.sampleRho()).toString();
  const input = lib.circuitInput(s);
  const { proof, publicSignals } = await snarkjs.groth16.fullProve(input, lib.WASM, lib.ZKEY);
  return { proof, publicSignals, input };
}

// Witness generation alone (no proof): rejects iff the constraints have no solution.
async function witnessFails(spec) {
  const input = lib.circuitInput({ ...spec, rho: "1" });
  const wtns = { type: "mem" };
  try {
    await snarkjs.wtns.calculate(input, lib.WASM, wtns);
    return false;
  } catch (_e) {
    return true;
  }
}

test.before(async () => {
  assert.ok(fs.existsSync(lib.ZKEY), "run `bash scripts/build.sh` first");
  vk = lib.readJson(lib.VKEY);
  honest = await prove(load("conforme.json"));
});

test.after(async () => {
  // Release the ffjavascript worker threads so the process can exit.
  if (globalThis.curve_bn128) await globalThis.curve_bn128.terminate();
});

test("generators G, H are the nothing-up-my-sleeve circomlib Pedersen bases", async () => {
  const { G, H } = await lib.rederiveGenerators();
  assert.deepEqual(G, lib.G);
  assert.deepEqual(H, lib.H);
  assert.notDeepEqual(G, H);
});

test("completeness: honest proof is accepted (b1 and b2)", async () => {
  const b1 = await snarkjs.groth16.verify(vk, honest.publicSignals, honest.proof);
  const b2 = await lib.commitmentInGroup(honest.publicSignals[1], honest.publicSignals[2]);
  assert.equal(b1, true);
  assert.equal(b2, true);
});

test("public statement equals off-circuit (Poseidon(c), m*G + rho*H)", async () => {
  const { m, c, rho } = honest.input;
  const exp = await lib.expectedPublic(m, c, rho);
  assert.deepEqual(honest.publicSignals, [exp.h_c, exp.cm_x, exp.cm_y]);
});

test("boundary case m = threshold - 1 is provable and accepted", async () => {
  const p = await prove(load("conforme_limite.json"));
  assert.equal(await snarkjs.groth16.verify(vk, p.publicSignals, p.proof), true);
});

for (const [idx, name] of [[0, "h_c"], [1, "cm_x"], [2, "cm_y"]]) {
  test(`soundness check: proof with modified public signal ${name} is rejected`, async () => {
    const pub = [...honest.publicSignals];
    pub[idx] = (BigInt(pub[idx]) + 1n).toString();
    assert.equal(await snarkjs.groth16.verify(vk, pub, honest.proof), false);
  });
}

test("soundness check: honest proof replayed with another context digest is rejected", async () => {
  const other = load("conforme.json");
  other.c = [...other.c];
  other.c[2] = 999; // different jurisdiction code => different h_c
  const exp = await lib.expectedPublic(honest.input.m, other.c.map(String), honest.input.rho);
  const pub = [exp.h_c, honest.publicSignals[1], honest.publicSignals[2]];
  assert.notEqual(exp.h_c, honest.publicSignals[0]);
  assert.equal(await snarkjs.groth16.verify(vk, pub, honest.proof), false);
});

test("soundness check: modified proof element is rejected", async () => {
  const p = JSON.parse(JSON.stringify(honest.proof));
  p.pi_a = honest.proof.pi_c; // swap a valid G1 point in
  assert.equal(await snarkjs.groth16.verify(vk, honest.publicSignals, p), false);
});

for (const f of ["non_conforme.json", "seuil_atteint.json", "type_non_autorise.json", "hors_plage.json"]) {
  test(`no witness: ${f} cannot produce a witness`, async () => {
    assert.equal(await witnessFails(load(f)), true);
  });
}

test("hiding sanity: same (m, c) with fresh rho gives a different c_m, same h_c", async () => {
  const p2 = await prove(load("conforme.json"));
  assert.equal(p2.publicSignals[0], honest.publicSignals[0]);
  assert.notEqual(p2.publicSignals[1], honest.publicSignals[1]);
});

test("metrics: proof size and verification time", async () => {
  const jsonBytes = Buffer.byteLength(JSON.stringify(honest.proof));
  const pubBytes = Buffer.byteLength(JSON.stringify(honest.publicSignals));
  // Warm-up, then timed runs.
  await snarkjs.groth16.verify(vk, honest.publicSignals, honest.proof);
  const N = 10;
  const times = [];
  for (let i = 0; i < N; i++) {
    const t0 = process.hrtime.bigint();
    const ok = await snarkjs.groth16.verify(vk, honest.publicSignals, honest.proof);
    times.push(Number(process.hrtime.bigint() - t0) / 1e6);
    assert.equal(ok, true);
  }
  times.sort((a, b) => a - b);
  const median = times[Math.floor(N / 2)];
  const t0 = process.hrtime.bigint();
  await prove(load("conforme.json"));
  const proveMs = Number(process.hrtime.bigint() - t0) / 1e6;
  console.log(`# proof.json (snarkjs JSON, compact): ${jsonBytes} bytes`);
  console.log(`# public.json (3 signals): ${pubBytes} bytes`);
  console.log(
    `# Groth16 proof = 3 group elements (A, C in G1, B in G2): ` +
      `~${lib.GROTH16_BN254_COMPRESSED_BYTES} bytes compressed on BN254 (informative)`
  );
  console.log(`# verification time (snarkjs, warm, median of ${N}): ${median.toFixed(1)} ms`);
  console.log(`# proving time (witness + Groth16, snarkjs): ${proveMs.toFixed(0)} ms`);
  assert.ok(jsonBytes > 0);
});
