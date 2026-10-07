<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Harness ↔ PROPERTIES.md mapping + measured results

Properties: `/workspace/foundry-j/spec/PROPERTIES.md` (56).
Core entry: `/workspace/foundry-j/j/foundry.ijs` + `foundry_export''`.
Log: `logs/run-20261007-061701.log` (PT).

| Harness test | Primary # | Related # | Measured (2026-10-07 06:17:01 PDT) |
|--------------|-----------|-----------|-------------------------------------|
| `goldilocks_add` | **13** | 1,2,3 | **PASS** |
| `goldilocks_mul` | **15** | 5–11 | **PASS** |
| `goldilocks_inv` | **16** | 17 | **FAIL** — `42*fp_inv(42)` → `11152786313141180820` (not 1); Core `fp_mulmod`/`fp_pow` under Fermat |
| `goldilocks_sub` | **14** | — | **PASS** |
| `pmat_insert` | **27** | 26 | **PASS** |
| `pmat_conservation` | **29** | — | **PASS** |
| `spectral_contractive` | **38** | 33,34,37 | **PASS** |
| `spectral_expansive` | **38** | 33,34,37 | **PASS** |
| `recurrence_converges` | **46** | 39–45 | **PASS** (harness loop via `synth_weights`+`rec_step`; Core `rec_run` still flattens StepInfo via `;` link) |

## Summary counts

- PASS: **8**
- FAIL: **1** (`goldilocks_inv` / prop **16**)
- BLOCKED: **0**

## Notes for Hilbert / Core

1. **Prop 16 FAIL is real** — not a harness bug. Small `fp_mul` (7×6) passes; Fermat inverse path fails (incomplete reduction in `fp_mulmod` for large intermediates is the likely cause).
2. **`rec_run` packing** — `x_next ; info` flattens to 8 boxes; harness measures prop 46 via `rec_step` loop instead. Fix Core to `x_next ; <info` for J_API `rec_run`.
3. No C++ side-by-side run claimed; vectors mirror `src/test.cpp` only.
