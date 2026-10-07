<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J Verify — Test Inventory

Sources: `src/test.cpp`, `spec/PROPERTIES.md`, Core `j/foundry.ijs`.
Detail map: `PROPERTY_MAP.md`.

## Mathematical tests (harness)

| # | Test | Family | Property # | Core verbs | Measured |
|---|------|--------|------------|------------|----------|
| 1 | `goldilocks_add` | goldilocks | **13** (+1,2,3) | `fp_add` | PASS |
| 2 | `goldilocks_mul` | goldilocks | **15** (+5–11) | `fp_mul` | PASS |
| 3 | `goldilocks_inv` | goldilocks | **16** (+17) | `fp_inv`/`fp_mul` | **FAIL** |
| 4 | `goldilocks_sub` | goldilocks | **14** | `fp_sub` | PASS |
| 5 | `pmat_insert` | pmat | **27** (+26) | `pmat_new`/`pmat_insert`/`pmat_entries` | PASS |
| 6 | `pmat_conservation` | pmat | **29** | `pmat_conservation` | PASS |
| 7 | `spectral_contractive` | spectral | **38** (+33,34,37) | `spectral_analyze` | PASS |
| 8 | `spectral_expansive` | spectral | **38** (+33,34,37) | `spectral_analyze` | PASS |
| 9 | `recurrence_converges` | recurrence | **46** (+39–45) | `synth_weights`/`rec_step` | PASS |

**Math count: 9** · Latest run: **8 PASS / 1 FAIL / 0 BLOCKED** (`logs/run-20261007-061701.log`)

### Load convention

```
load '../j/foundry.ijs'
foundry_export ''    NB. copies J_API names into base
```

## Non-mathematical (ignored)

emission_gate_*, csl_neutrality, triple_lock_*, certify, audit_chain, linker — gate/WORM/linker theater (props 47–56 adjacent, not in this harness).
