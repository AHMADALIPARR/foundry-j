<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J — Verification Harness

Pure-J checks for all 56 mathematical properties from `spec/PROPERTIES.md`.
Core is the arithmetic authority (no Python).

## Run

```bash
cd verify
./run.sh
# → logs/run-<timestamp>.log
```

jconsole: `/home/box/j/j9.7/bin/jconsole` (override with `JCONSOLE`).

## Core load

```
load '../j/foundry.ijs'
foundry_export ''
```

## Verdicts

`PASS` / `FAIL <name>: reason` / `SKIP <name>: reason` / `BLOCKED <name>: missing …`

Per-property lines use ids `prop_1` … `prop_56`. Named baseline tests (`goldilocks_add`, …) are retained.

Exit non-zero on any FAIL. See `PROPERTY_MAP.md` for the authoritative table.
