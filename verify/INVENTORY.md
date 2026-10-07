<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J Verify — Test Inventory

Sources: `src/test.cpp`, `spec/PROPERTIES.md`, Core `j/foundry.ijs`.
Detail map: `PROPERTY_MAP.md` (all 56 properties).

## Named mathematical tests (baseline)

| # | Test | Family | Property # | Core verbs | Measured |
|---|------|--------|------------|------------|----------|
| 1 | `goldilocks_add` | goldilocks | **13** | `fp_add` | PASS |
| 2 | `goldilocks_mul` | goldilocks | **15** | `fp_mul` | PASS |
| 3 | `goldilocks_inv` | goldilocks | **16** | `fp_inv`/`fp_mul` | PASS |
| 4 | `goldilocks_sub` | goldilocks | **14** | `fp_sub` | PASS |
| 5 | `pmat_insert` | pmat | **27** | `pmat_new`/`pmat_insert`/`pmat_entries` | PASS |
| 6 | `pmat_conservation` | pmat | **29** | `pmat_conservation` | PASS |
| 7 | `spectral_contractive` | spectral | **38** | `spectral_analyze` | PASS |
| 8 | `spectral_expansive` | spectral | **38** | `spectral_analyze` | PASS |
| 9 | `recurrence_converges` | recurrence | **46** | `rec_run`/`synth_weights` | PASS |

**Named count: 9** · Latest: **9 PASS / 0 FAIL** (`logs/run-20261007-075943.log`)

## Property coverage files

| File | Props |
|------|-------|
| `tests/goldilocks.ijs` | 1–18 (+ named) |
| `tests/constants.ijs` | 19–25 |
| `tests/pmat.ijs` | 26–32 (+ named) |
| `tests/spectral.ijs` | 33–38 (+ named) |
| `tests/recurrence.ijs` | 39–46 (+ named; 41 SKIP) |
| `tests/emit_csl_ace.ijs` | 47–56 (47/55/56 SKIP; 49–50 FAIL) |

### Load convention

```
load '../j/foundry.ijs'
foundry_export ''    NB. copies J_API names into base
```

## Out of scope / SKIP

- **41** narrative Banach unique fixed-point
- **47** WORM/seal / triple-lock theater
- **55** guardian (no Core verb)
- **56** consensus narrative

## Known Core FAILs (honest)

- **49** attenuate scale (J RTL vs Spec)
- **50** `csl_neutrality` index error (J RTL loop bound)
