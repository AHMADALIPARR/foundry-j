<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# foundry-j

Pure J recreation of Foundry F1 **math cores only**: Goldilocks field,
PMAT, spectral governor, and Banach contraction recurrence.

This is **not** the upstream C++/C99 Foundry orchestration stack. SHA-256
WORM audit chains, Triple-Lock seals, gate/certify theater, Alapeno
hardware, and the full Sedona spine are out of scope.

Upstream reference (not shipped here):
https://github.com/SNAPKITTYWEST/SNAPKITTYWEST/tree/main/cpp-foundry

Goldilocks modulus:

```
p = 18446744069414584321 = 2^64 − 2^32 + 1
```

## Quick start

Requires [J](https://www.jsoftware.com/) with `jconsole` on `PATH`.

```bash
cd verify
./run.sh

# or:
jconsole verify/run.ijs
```

## Measured verify

Source: [`verify/logs/run-20261007-080122.log`](verify/logs/run-20261007-080122.log)
(2026-10-07 PT):

```
PASS=61 FAIL=0 SKIP=4 BLOCKED=0
```

SKIP are narrative/theater props only: Banach narrative (41), WORM/seal
theater (47), guardian theater (55), consensus narrative (56). Property
inventory: `spec/PROPERTIES.md`. J API: `spec/J_API.md`.

## Layout

```
foundry-j/
  LICENSE
  README.md
  spec/           PROPERTIES.md, J_API.md
  j/              goldilocks, pmat, spectral, recurrence, types
  verify/         harness, PROPERTY_MAP, run.sh, logs/
  docs/images/    demo screenshots
```

## Demo

![Foundry J verify harness](docs/images/foundry-j-verify.png)

## Out of scope

- SHA-256 WORM audit chain / PIRTM linker / Triple-Lock seals
- Full gate/certify / CSL / AceCertificate theater
- Alapeno hardware (`rtl/`, `spice/`, Why3)
- Live orchestration beyond the math cores

## License

Copyright © 2026 Foundry J contributors. **AGPL-3.0-only** — see
[`LICENSE`](LICENSE).
