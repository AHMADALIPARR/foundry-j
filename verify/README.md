<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J — Verification Harness

Pure-J checks for mathematical properties from `src/test.cpp`, mapped to
`spec/PROPERTIES.md`. Core is the arithmetic authority (no Python).

## Run

```bash
cd /workspace/foundry-j/verify
./run.sh
# → logs/run-<timestamp>.log
```

jconsole: `/home/box/j/j9.7/bin/jconsole`

## Core load

```
load '../j/foundry.ijs'
foundry_export ''
```

J_API verbs used: `fp_add` `fp_mul` `fp_sub` `fp_inv` `pmat_new` `pmat_insert`
`pmat_conservation` `spectral_analyze` `synth_weights` `rec_step` (+ constants).

## Verdicts

`PASS` / `FAIL <name>: reason` / `BLOCKED <name>: missing …`  
Exit non-zero only on FAIL. See `PROPERTY_MAP.md` for property numbers.
