# foundry-j

Pure J array recreation of the mathematical cores described by Foundry F1 / cpp-foundry (Goldilocks field, PMAT, spectral governor, Banach recurrence).

License: GNU Affero General Public License v3 only (`LICENSE`).

Upstream report (reference only, not shipped here): https://github.com/SNAPKITTYWEST/SNAPKITTYWEST/tree/main/cpp-foundry

## Layout

| Path | Role |
|------|------|
| `spec/` | Property inventory and J API contract |
| `j/` | Pure J implementation |
| `verify/` | jconsole harness and measured logs |

## Run

```bash
/home/box/j/j9.7/bin/jconsole /path/to/foundry-j/verify/run.ijs
# or:
cd verify && ./run.sh
```

Measured suite (2026-10-07): 9/9 PASS — Goldilocks add/mul/inv/sub, PMAT insert/conservation, spectral contractive/expansive, recurrence converges. See `verify/logs/run-20261007-061853.log`.

Out of scope here: SHA-256 WORM audit, PIRTM linker, Triple-Lock seals, Alapeno hardware.
