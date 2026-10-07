<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Coverage Matrix — PROPERTIES.md ↔ harness

**Target commit:** `194e588` (pure-J Foundry F1).  
**Sources:** `spec/PROPERTIES.md` (56 numbered properties); `verify/PROPERTY_MAP.md` (harness Primary/Related + measured results); `verify/INVENTORY.md` (non-mathematical / ignored note).  
**Measured log:** `logs/run-20261007-061701.log` — PROPERTY_MAP reports **8 PASS / 1 FAIL / 0 BLOCKED** (not 9/9).  
**No invented numbers.** Status definitions exactly as Spec brief.

| Status | Definition |
|--------|------------|
| **covered** | Listed in PROPERTY_MAP as Primary # or Related # **and** measured **PASS** |
| **partial** | Listed as Primary/Related but measured **FAIL**; **or** harness works around Core (e.g. recurrence via `rec_step` not `rec_run`); **or** emission / CSL / AceCert / WORM props called out as non-mathematical / ignored by harness |
| **untested** | Not mentioned in PROPERTY_MAP Primary or Related columns (and not in the ignored 47–56 band) |

---

| Prop | Short name | Status | Evidence | Notes |
|------|------------|--------|----------|-------|
| 1 | Goldilocks prime (decimal) | covered | `goldilocks_add` (Related) | PASS in PROPERTY_MAP |
| 2 | Goldilocks prime (hex / named constant) | covered | `goldilocks_add` (Related) | PASS in PROPERTY_MAP |
| 3 | Field elements are u64 reduced mod p | covered | `goldilocks_add` (Related) | PASS in PROPERTY_MAP |
| 4 | Elem construction reduces | untested | none | Not in PROPERTY_MAP Primary/Related |
| 5 | Congruence \(2^{64} \equiv 2^{32}-1 \pmod{p}\) | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 6 | Fold constant EPSILON | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 7 | 128-bit product split | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 8 | hi split into 32-bit halves | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 9 | Reduction identity (fold) | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 10 | Underflow handling on fold | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 11 | Final conditional reduction after fold | covered | `goldilocks_mul` (Related 5–11) | PASS in PROPERTY_MAP |
| 12 | Single-limb reduce | untested | none | Not in PROPERTY_MAP Primary/Related |
| 13 | Addition mod p | covered | `goldilocks_add` (Primary) | PASS in PROPERTY_MAP; `verify/tests/goldilocks.ijs` |
| 14 | Subtraction mod p | covered | `goldilocks_sub` (Primary) | PASS in PROPERTY_MAP; `verify/tests/goldilocks.ijs` |
| 15 | Multiplication via mulmod | covered | `goldilocks_mul` (Primary) | PASS in PROPERTY_MAP; `verify/tests/goldilocks.ijs` |
| 16 | Fermat inverse | partial | `goldilocks_inv` (Primary) | **covered-but-FAIL** — PROPERTY_MAP: `42*fp_inv(42)` → `11152786313141180820` (not 1); log `run-20261007-061701` |
| 17 | Binary exponentiation | partial | `goldilocks_inv` (Related) | Listed with prop 16; same measured **FAIL** |
| 18 | Batch add/mul | untested | none | Not in PROPERTY_MAP Primary/Related |
| 19 | K_MAX | untested | none | Not in PROPERTY_MAP Primary/Related |
| 20 | MAX_DRIFT | untested | none | Not in PROPERTY_MAP Primary/Related |
| 21 | PIRTM_MAGIC | untested | none | Not in PROPERTY_MAP Primary/Related |
| 22 | PHI | untested | none | Not in PROPERTY_MAP Primary/Related; see Gaps |
| 23 | P_64 — first 64 primes | untested | none | Not in PROPERTY_MAP Primary/Related |
| 24 | GENESIS_HASH_SIZE | untested | none | Not in PROPERTY_MAP Primary/Related |
| 25 | Tier epsilons (contraction margins) | untested | none | Not in PROPERTY_MAP Primary/Related |
| 26 | PMat entry shape | covered | `pmat_insert` (Related) | PASS in PROPERTY_MAP |
| 27 | Insert domain checks | covered | `pmat_insert` (Primary) | PASS in PROPERTY_MAP; `verify/tests/pmat.ijs` |
| 28 | Grading condition (stated) | untested | none | Gap: `validate_grading` stub; not in harness map |
| 29 | Conservation theorem | covered | `pmat_conservation` (Primary) | PASS in PROPERTY_MAP; `verify/tests/pmat.ijs` |
| 30 | Composition preserves grading (stated) | untested | none | Not in PROPERTY_MAP Primary/Related |
| 31 | Compose monomial accumulation rule (as coded) | untested | none | Not in PROPERTY_MAP Primary/Related; see Gaps |
| 32 | Frobenius norm of PMat | untested | none | Not in PROPERTY_MAP Primary/Related |
| 33 | Gershgorin disk bound | covered | `spectral_contractive`, `spectral_expansive` (Related) | PASS in PROPERTY_MAP |
| 34 | Contractive test (Gershgorin) | covered | `spectral_contractive`, `spectral_expansive` (Related) | PASS in PROPERTY_MAP |
| 35 | Power iteration (Rayleigh) | untested | none | Not in PROPERTY_MAP Primary/Related |
| 36 | Contractive test (power iteration) | untested | none | Not in PROPERTY_MAP Primary/Related |
| 37 | Analyze fallback policy | covered | `spectral_contractive`, `spectral_expansive` (Related) | PASS in PROPERTY_MAP |
| 38 | Tested contractive / expansive examples | covered | `spectral_contractive`, `spectral_expansive` (Primary) | PASS in PROPERTY_MAP; `verify/tests/spectral.ijs` |
| 39 | Recurrence equation | partial | `recurrence_converges` (Related 39–45) | PASS measured, but PROPERTY_MAP notes harness loop via `synth_weights`+`rec_step`; Core `rec_run` still flattens StepInfo |
| 40 | Contraction condition | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 41 | Unique fixed-point guarantee (narrative) | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 42 | q estimate in step (as coded) | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 43 | Soft projection | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 44 | Weight budget split | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 45 | Projector | partial | `recurrence_converges` (Related 39–45) | Same workaround note as prop 39 |
| 46 | Residual | partial | `recurrence_converges` (Primary) | PASS measured via `rec_step` loop; PROPERTY_MAP: Core `rec_run` packing still broken (`x_next ; info` flattens) |
| 47 | WORM / seal chain invariant (system-level) | partial | none (ignored) | INVENTORY: props 47–56 adjacent / gate-WORM theater, not in harness |
| 48 | Emission Suppress | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 49 | Emission Attenuate scale | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 50 | CSL neutrality | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 51 | CSL beneficence | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 52 | CSL commutation | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 53 | AceCertificate safety margin | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 54 | AceCertificate tail bound | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 55 | Guardian spectral legality | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |
| 56 | Consensus / false-positive bound (narrative) | partial | none (ignored) | INVENTORY non-mathematical / ignored by harness |

---

## Summary counts

| Status | Count |
|--------|------:|
| covered | **20** |
| partial | **20** |
| untested | **16** |
| **Total** | **56** |

### Partial breakdown (for handoff)

| Reason | Props | Count |
|--------|-------|------:|
| Measured FAIL (`goldilocks_inv`) | 16, 17 | 2 |
| Harness workaround (`rec_step` / `rec_run` packing) | 39–46 | 8 |
| Ignored / non-mathematical (INVENTORY 47–56) | 47–56 | 10 |

### Harness measured (PROPERTY_MAP / log `run-20261007-061701`)

| Result | Count | Detail |
|--------|------:|--------|
| PASS | 8 | `goldilocks_add`, `goldilocks_mul`, `goldilocks_sub`, `pmat_insert`, `pmat_conservation`, `spectral_contractive`, `spectral_expansive`, `recurrence_converges` |
| FAIL | 1 | `goldilocks_inv` / prop **16** |
| BLOCKED | 0 | — |

Cite: `verify/PROPERTY_MAP.md` Summary counts; `verify/INVENTORY.md` Math count line.
