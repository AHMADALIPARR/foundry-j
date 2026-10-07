<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Harness ↔ PROPERTIES.md mapping + measured results

Properties: `spec/PROPERTIES.md` (56).
Core entry: `j/foundry.ijs` + `foundry_export''`.
Log: `logs/run-20261007-075943.log` (PT).

Statuses below match that log exactly. Named baseline tests are listed after the property table.

| # | Title | Status | Harness id | Log citation |
|---|-------|--------|------------|--------------|
| 1 | Goldilocks prime (decimal) | **PASS** | `prop_1` | `PASS prop_1` |
| 2 | Goldilocks prime (hex / named) | **PASS** | `prop_2` | `PASS prop_2` |
| 3 | Field elements u64 reduced mod p | **PASS** | `prop_3` | `PASS prop_3` |
| 4 | Elem construction reduces | **PASS** | `prop_4` | `PASS prop_4` |
| 5 | Congruence 2^64 ≡ 2^32−1 (mod p) | **PASS** | `prop_5` | `PASS prop_5` |
| 6 | Fold constant EPSILON | **PASS** | `prop_6` | `PASS prop_6` |
| 7 | 128-bit product split (via fp_mulmod) | **PASS** | `prop_7` | `PASS prop_7` |
| 8 | hi split into 32-bit halves | **PASS** | `prop_8` | `PASS prop_8` |
| 9 | Reduction identity (fold) | **PASS** | `prop_9` | `PASS prop_9` |
| 10 | Underflow handling on fold | **PASS** | `prop_10` | `PASS prop_10` |
| 11 | Final conditional reduction | **PASS** | `prop_11` | `PASS prop_11` |
| 12 | Single-limb reduce | **PASS** | `prop_12` | `PASS prop_12` |
| 13 | Addition mod p | **PASS** | `prop_13` | `PASS prop_13` |
| 14 | Subtraction mod p | **PASS** | `prop_14` | `PASS prop_14` |
| 15 | Multiplication via mulmod | **PASS** | `prop_15` | `PASS prop_15` |
| 16 | Fermat inverse | **PASS** | `prop_16` | `PASS prop_16` |
| 17 | Binary exponentiation | **PASS** | `prop_17` | `PASS prop_17` |
| 18 | Batch add/mul | **PASS** | `prop_18` | `PASS prop_18` |
| 19 | K_MAX | **PASS** | `prop_19` | `PASS prop_19` |
| 20 | MAX_DRIFT | **PASS** | `prop_20` | `PASS prop_20` |
| 21 | PIRTM_MAGIC | **PASS** | `prop_21` | `PASS prop_21` |
| 22 | PHI | **PASS** | `prop_22` | `PASS prop_22` |
| 23 | P_64 first 64 primes | **PASS** | `prop_23` | `PASS prop_23` |
| 24 | GENESIS_HASH_SIZE | **PASS** | `prop_24` | `PASS prop_24` |
| 25 | Tier epsilons | **PASS** | `prop_25` | `PASS prop_25` |
| 26 | PMat entry shape | **PASS** | `prop_26` | `PASS prop_26` |
| 27 | Insert domain checks | **PASS** | `prop_27` | `PASS prop_27` |
| 28 | Grading condition (C++ stub mirror) | **PASS** | `prop_28` | `PASS prop_28` |
| 29 | Conservation theorem | **PASS** | `prop_29` | `PASS prop_29` |
| 30 | Composition preserves grading/shape | **PASS** | `prop_30` | `PASS prop_30` |
| 31 | Compose monomial accumulation rule | **PASS** | `prop_31` | `PASS prop_31` |
| 32 | Frobenius norm of PMat | **PASS** | `prop_32` | `PASS prop_32` |
| 33 | Gershgorin disk bound | **PASS** | `prop_33` | `PASS prop_33` |
| 34 | Contractive test (Gershgorin) | **PASS** | `prop_34` | `PASS prop_34` |
| 35 | Power iteration (Rayleigh) | **PASS** | `prop_35` | `PASS prop_35` |
| 36 | Contractive test (power iteration) | **PASS** | `prop_36` | `PASS prop_36` |
| 37 | Analyze fallback policy | **PASS** | `prop_37` | `PASS prop_37` |
| 38 | Tested contractive / expansive examples | **PASS** | `prop_38` | `PASS prop_38` |
| 39 | Recurrence equation | **PASS** | `prop_39` | `PASS prop_39` |
| 40 | Contraction condition | **PASS** | `prop_40` | `PASS prop_40` |
| 41 | Unique fixed-point guarantee (narrative) | **SKIP** | `prop_41` | `SKIP prop_41: narrative-only Banach guarantee` |
| 42 | q estimate in step | **PASS** | `prop_42` | `PASS prop_42` |
| 43 | Soft projection | **PASS** | `prop_43` | `PASS prop_43` |
| 44 | Weight budget split | **PASS** | `prop_44` | `PASS prop_44` |
| 45 | Projector | **PASS** | `prop_45` | `PASS prop_45` |
| 46 | Residual / convergence | **PASS** | `prop_46` | `PASS prop_46` |
| 47 | WORM / seal chain invariant | **SKIP** | `prop_47` | `SKIP prop_47: WORM/seal chain / triple-lock theater out of harness scope` |
| 48 | Emission Suppress | **PASS** | `prop_48` | `PASS prop_48` |
| 49 | Emission Attenuate scale | **FAIL** | `prop_49` | `FAIL prop_49: Spec expect 0.4*out; Core got 1.4 2.8 4.2` |
| 50 | CSL neutrality | **FAIL** | `prop_50` | `FAIL prop_50: index error in csl_neutrality` |
| 51 | CSL beneficence | **PASS** | `prop_51` | `PASS prop_51` |
| 52 | CSL commutation | **PASS** | `prop_52` | `PASS prop_52` |
| 53 | AceCertificate safety margin | **PASS** | `prop_53` | `PASS prop_53` |
| 54 | AceCertificate tail bound | **PASS** | `prop_54` | `PASS prop_54` |
| 55 | Guardian spectral legality | **SKIP** | `prop_55` | `SKIP prop_55: no Core guardian verb (gate theater out of harness scope)` |
| 56 | Consensus / false-positive bound | **SKIP** | `prop_56` | `SKIP prop_56: narrative-only consensus / 2^-256 bound` |

## Property summary (56)

| Status | Count |
|--------|------:|
| PASS | **50** |
| FAIL | **2** (`prop_49`, `prop_50`) |
| SKIP | **4** (`prop_41`, `prop_47`, `prop_55`, `prop_56`) |
| BLOCKED | **0** |

## Named baseline tests (same log)

| Harness test | Primary # | Measured |
|--------------|-----------|----------|
| `goldilocks_add` | 13 | **PASS** |
| `goldilocks_mul` | 15 | **PASS** |
| `goldilocks_inv` | 16 | **PASS** |
| `goldilocks_sub` | 14 | **PASS** |
| `pmat_insert` | 27 | **PASS** |
| `pmat_conservation` | 29 | **PASS** |
| `spectral_contractive` | 38 | **PASS** |
| `spectral_expansive` | 38 | **PASS** |
| `recurrence_converges` | 46 | **PASS** |

Named: **PASS=9 FAIL=0 BLOCKED=0** (no regression vs `logs/run-20261007-061853.log`).

## Full harness counters (named + prop_*)

`PASS=59 FAIL=2 SKIP=4 BLOCKED=0` · `exit_code=1`

## Notes for Hilbert / Core

1. **Measured against Core** `7cc1ba6` (BOXING.md freeze). Prop 16 / `goldilocks_inv` **PASS**. Prop 46 driven via `rec_run` (list of `<StepInfo>`).
2. **prop_49 FAIL** — Spec `max(0,(1−ε)−q)`; Core `emit_apply` Attenuate uses J RTL `1 - eps - q` → `1-(eps-q)`, so q=0.5 ε=0.1 yields scale 1.4 not 0.4.
3. **prop_50 FAIL** — Core `csl_neutrality` loop bound `n - i - 1` is J RTL (`n-(i-1)`), causing index error for normal vector lengths. Measured FAIL (verb exists; not SKIP).
4. Props 7–11 exercise mulmod via `fp_mulmod` identities (128-bit split internals are not separately exported).
5. Prop 28 mirrors C++ stub (`pmat_validate_grading` always 1); Spec gap noted in PROPERTIES.md / GAP_DECISIONS.
