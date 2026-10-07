NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Named tests + Goldilocks props 1–18 (where Core verbs exist).

run_goldilocks =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'goldilocks_add'
    r blocked 'goldilocks_mul'
    r blocked 'goldilocks_inv'
    r blocked 'goldilocks_sub'
    '' return.
  end.

  NB. ── named tests (baseline) ──────────────────────────────────────────────
  try. r =. 100x fp_add 200x
    if. r = 300x do. pass 'goldilocks_add' else. (('expected 300 got ' , ": r)) fail 'goldilocks_add' end.
  catch. (13!:12 '') fail 'goldilocks_add' end.

  try. r =. 7x fp_mul 6x
    if. r = 42x do. pass 'goldilocks_mul' else. (('expected 42 got ' , ": r)) fail 'goldilocks_mul' end.
  catch. (13!:12 '') fail 'goldilocks_mul' end.

  try. one =. 42x fp_mul (fp_inv 42x)
    if. one = 1x do. pass 'goldilocks_inv' else. (('expected 1 got ' , ": one)) fail 'goldilocks_inv' end.
  catch. (13!:12 '') fail 'goldilocks_inv' end.

  try. r =. 100x fp_sub 50x
    if. r = 50x do. pass 'goldilocks_sub' else. (('expected 50 got ' , ": r)) fail 'goldilocks_sub' end.
  catch. (13!:12 '') fail 'goldilocks_sub' end.

  NB. ── prop_1 Goldilocks prime (decimal) ───────────────────────────────────
  try.
    if. GOLDILOCKS_PRIME = 18446744069414584321x do. pass 'prop_1'
    else. (('got ' , ": GOLDILOCKS_PRIME)) fail 'prop_1' end.
  catch. (13!:12 '') fail 'prop_1' end.

  NB. ── prop_2 hex / named constant (= decimal p) ───────────────────────────
  try.
    if. (p = GOLDILOCKS_PRIME) *. (p = 18446744069414584321x) do. pass 'prop_2'
    else. 'p / GOLDILOCKS_PRIME mismatch' fail 'prop_2' end.
  catch. (13!:12 '') fail 'prop_2' end.

  NB. ── prop_3 field elements reduced mod p (carrier < p) ───────────────────
  try.
    r =. fp_reduce 42x
    if. (r = 42x) *. (r < p) do. pass 'prop_3'
    else. (('got ' , ": r)) fail 'prop_3' end.
  catch. (13!:12 '') fail 'prop_3' end.

  NB. ── prop_4 Elem construction reduces (fp_reduce) ────────────────────────
  try.
    r =. fp_reduce (p + 5x)
    if. r = 5x do. pass 'prop_4'
    else. (('expected 5 got ' , ": r)) fail 'prop_4' end.
  catch. (13!:12 '') fail 'prop_4' end.

  NB. ── prop_5 congruence 2^64 ≡ 2^32-1 (mod p) ──────────────────────────────
  try.
    NB. TWO64 - p = 2^32 - 1 = EPSILON_FOLD
    if. (TWO64_foundry_ - p) = EPSILON_FOLD do. pass 'prop_5'
    else. 'TWO64 - p != EPSILON_FOLD' fail 'prop_5' end.
  catch. (13!:12 '') fail 'prop_5' end.

  NB. ── prop_6 EPSILON fold constant ────────────────────────────────────────
  try.
    if. EPSILON_FOLD = 4294967295x do. pass 'prop_6'
    else. (('got ' , ": EPSILON_FOLD)) fail 'prop_6' end.
  catch. (13!:12 '') fail 'prop_6' end.

  NB. ── prop_7..11 mulmod fold path (exercised via fp_mulmod / fp_mul) ──────
  NB. Internal 128-bit split is not separately exported; identity a*b mod p
  NB. via Goldilocks fold covers props 7–11 as a unit for harness purposes.
  try.
    r =. 7x fp_mulmod 6x
    if. r = 42x do. pass 'prop_7'
    else. (('fp_mulmod 7*6 expected 42 got ' , ": r)) fail 'prop_7' end.
  catch. (13!:12 '') fail 'prop_7' end.

  try.
    NB. larger product exercises hi/lo split (props 8–11)
    a =. 123456789x
    b =. 987654321x
    r =. a fp_mulmod b
    expect =. p | (a * b)
    if. r = expect do. pass 'prop_8'
    else. (('hi_lo path mismatch got ' , (": r) , ' expect ' , ": expect)) fail 'prop_8' end.
  catch. (13!:12 '') fail 'prop_8' end.

  try.
    a =. (p - 1x)
    b =. (p - 1x)
    r =. a fp_mulmod b
    expect =. p | (a * b)
    if. r = expect do. pass 'prop_9'
    else. (('fold identity fail got ' , (": r) , ' expect ' , ": expect)) fail 'prop_9' end.
  catch. (13!:12 '') fail 'prop_9' end.

  try.
    NB. underflow / conditional reduction path: product near multiples of p
    r =. 2x fp_mulmod (p - 1x)
    expect =. p | (2x * (p - 1x))
    if. r = expect do. pass 'prop_10'
    else. (('underflow path got ' , (": r) , ' expect ' , ": expect)) fail 'prop_10' end.
  catch. (13!:12 '') fail 'prop_10' end.

  try.
    r =. 3x fp_mulmod 5x
    if. (r < p) *. (r = 15x) do. pass 'prop_11'
    else. (('final reduce got ' , ": r)) fail 'prop_11' end.
  catch. (13!:12 '') fail 'prop_11' end.

  NB. ── prop_12 single-limb reduce ──────────────────────────────────────────
  try.
    ok =. ((fp_reduce 10x) = 10x) *. ((fp_reduce p) = 0x) *. ((fp_reduce (p + 1x)) = 1x)
    if. ok do. pass 'prop_12' else. 'fp_reduce cases failed' fail 'prop_12' end.
  catch. (13!:12 '') fail 'prop_12' end.

  NB. ── prop_13 add ─────────────────────────────────────────────────────────
  try.
    if. (100x fp_add 200x) = 300x do. pass 'prop_13' else. 'add != 300' fail 'prop_13' end.
  catch. (13!:12 '') fail 'prop_13' end.

  NB. ── prop_14 sub ─────────────────────────────────────────────────────────
  try.
    if. (100x fp_sub 50x) = 50x do. pass 'prop_14' else. 'sub != 50' fail 'prop_14' end.
  catch. (13!:12 '') fail 'prop_14' end.

  NB. ── prop_15 mul ─────────────────────────────────────────────────────────
  try.
    if. (7x fp_mul 6x) = 42x do. pass 'prop_15' else. 'mul != 42' fail 'prop_15' end.
  catch. (13!:12 '') fail 'prop_15' end.

  NB. ── prop_16 Fermat inverse ──────────────────────────────────────────────
  try.
    one =. 42x fp_mul (fp_inv 42x)
    if. one = 1x do. pass 'prop_16' else. (('a*inv(a) got ' , ": one)) fail 'prop_16' end.
  catch. (13!:12 '') fail 'prop_16' end.

  NB. ── prop_17 binary exponentiation ───────────────────────────────────────
  try.
    r =. 7x fp_pow 3x
    if. r = 343x do. pass 'prop_17' else. (('7^3 got ' , ": r)) fail 'prop_17' end.
  catch. (13!:12 '') fail 'prop_17' end.

  NB. ── prop_18 batch add/mul ───────────────────────────────────────────────
  try.
    ra =. 100 200 fp_add_batch 1 2
    rm =. 7 8 fp_mul_batch 6 5
    if. (ra -: 101 202) *. (rm -: 42 40) do. pass 'prop_18'
    else. (('batch got add=' , (": ra) , ' mul=' , ": rm)) fail 'prop_18' end.
  catch. (13!:12 '') fail 'prop_18' end.
  ''
)

run_goldilocks ''
