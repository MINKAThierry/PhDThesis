pragma circom 2.1.0;

// SOTP-High reference circuit (demonstration, NOT audited).
//
// Proves knowledge of a witness (m, c, rho) for the public statement (h_c, c_m)
// in the relation of the thesis (Chapter 3, Algorithm "SOTP-High"; Appendix A,
// theorem thm:ann_sotp_high):
//
//   R = { ((h_c, c_m), (m, c, rho)) :
//           h_c = Poseidon(c)                 -- Clay layer (context digest)
//         ∧ c_m = m*G + rho*H                 -- Iron layer (Pedersen, Baby Jubjub)
//         ∧ Conforme(m, c) = 1 }              -- certified institutional assertion
//
// The Gold layer (zero-knowledge masking of the witness) is provided by the
// Groth16 proof system itself, not by this circuit.
//
// Conforme(m, c) below is an EXAMPLE predicate (a toy AML rule). Another
// institutional context would require another predicate, hence another circuit
// and another circuit-specific Groth16 setup.

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/escalarmulfix.circom";
include "../node_modules/circomlib/circuits/babyjub.circom";

// ---------------------------------------------------------------------------
// Example compliance predicate (toy AML rule).
//
// Encoded institutional context c[0..3]:
//   c[0] : reporting threshold T (amount units, < 2^nBits)
//   c[1] : operation type code
//   c[2] : jurisdiction code      (only bound through h_c in this example)
//   c[3] : rule-set version       (only bound through h_c in this example)
//
// Conforme(m, c) = 1  iff  m < c[0]  and  c[1] ∈ ALLOWED_TYPES.
// ALLOWED_TYPES = {1, 2, 3} is fixed in the circuit (part of the public rule).
// ---------------------------------------------------------------------------
template ConformeAML(nBits) {
    signal input m;
    signal input c[4];

    // Range checks: both the amount and the threshold must fit in nBits,
    // otherwise LessThan(nBits) would be unsound (field wrap-around).
    component rm = Num2Bits(nBits);
    rm.in <== m;
    component rt = Num2Bits(nBits);
    rt.in <== c[0];

    // m < threshold
    component lt = LessThan(nBits);
    lt.in[0] <== m;
    lt.in[1] <== c[0];
    lt.out === 1;

    // Operation type in the allowed list {1, 2, 3}:
    // (t - 1)(t - 2)(t - 3) = 0
    signal p1;
    signal p2;
    p1 <== (c[1] - 1) * (c[1] - 2);
    p2 <== p1 * (c[1] - 3);
    p2 === 0;
}

// ---------------------------------------------------------------------------
// Pedersen commitment on Baby Jubjub: c_m = m*G + rho*H.
//
// G and H are the first two generators of circomlib's Pedersen hash
// (circomlib/circuits/pedersen.circom, BASE[0] and BASE[1]). They are derived
// by try-and-increment from blake256("PedersenGenerator_<i>_<try>") and then
// multiplied by the cofactor 8, so both lie in the prime-order subgroup and
// nobody knows log_G(H) (nothing-up-my-sleeve derivation). test/ re-derives
// them with circomlibjs and checks they match the constants below.
// ---------------------------------------------------------------------------
template PedersenCommitBJJ(mBits, rBits) {
    signal input m;
    signal input rho;
    signal output out[2];

    var G[2] = [
        10457101036533406547632367118273992217979173478358440826365724437999023779287,
        19824078218392094440610104313265183977899662750282163392862422243483260492317
    ];
    var H[2] = [
        2671756056509184035029146175565761955751135805354291559563293617232983272177,
        2663205510731142763556352975002641716101654201788071096152948830924149045094
    ];

    component mb = Num2Bits(mBits);
    mb.in <== m;
    component rb = Num2Bits(rBits);
    rb.in <== rho;

    component mG = EscalarMulFix(mBits, G);
    for (var i = 0; i < mBits; i++) { mG.e[i] <== mb.out[i]; }

    component rH = EscalarMulFix(rBits, H);
    for (var i = 0; i < rBits; i++) { rH.e[i] <== rb.out[i]; }

    component add = BabyAdd();
    add.x1 <== mG.out[0];
    add.y1 <== mG.out[1];
    add.x2 <== rH.out[0];
    add.y2 <== rH.out[1];

    out[0] <== add.xout;
    out[1] <== add.yout;
}

// ---------------------------------------------------------------------------
// Top-level SOTP-High statement.
// Private inputs : m, c[4], rho
// Public outputs : h_c, cm_x, cm_y   (snarkjs public.json order)
// ---------------------------------------------------------------------------
template SotpHigh(nBits, rBits) {
    signal input m;
    signal input c[4];
    signal input rho;

    signal output h_c;
    signal output cm_x;
    signal output cm_y;

    // Clay: context digest
    component pos = Poseidon(4);
    for (var i = 0; i < 4; i++) { pos.inputs[i] <== c[i]; }
    h_c <== pos.out;

    // Iron: Pedersen commitment to the message
    component com = PedersenCommitBJJ(nBits, rBits);
    com.m <== m;
    com.rho <== rho;
    cm_x <== com.out[0];
    cm_y <== com.out[1];

    // Certified assertion: Conforme(m, c) = 1
    component conf = ConformeAML(nBits);
    conf.m <== m;
    for (var i = 0; i < 4; i++) { conf.c[i] <== c[i]; }
}

// 64-bit amounts; rho < 2^253 (the prover samples rho uniformly in [0, l),
// l the order of the Baby Jubjub prime-order subgroup, l < 2^251).
component main = SotpHigh(64, 253);
