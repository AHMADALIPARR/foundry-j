# foundry-j

Pure J array recreation of the mathematical cores of Foundry F1 (Goldilocks field, PMAT, spectral governor, Banach contraction recurrence).

## What the original Foundry (cpp-foundry / Foundry F1) did

Upstream C++/C99 Foundry F1 is described as an orchestration substrate around:

- **Goldilocks field** \(\mathbb{F}_p\) with \(p = 2^{64} - 2^{32} + 1\)
- **Banach contraction recurrence** for iterative weight updates
- **Spectral governor** (contractive / expansive analysis)
- **PMAT** (prime monomial / graded algebraic structure)
- **SHA-256 WORM audit chain**, gates, and certification
- A claimed **10-layer Sedona spine** and **17/17 C++ tests**

Upstream report (reference only, not shipped here):  
https://github.com/SNAPKITTYWEST/SNAPKITTYWEST/tree/main/cpp-foundry

The audit chain, linker, seals, gates/certify theater, and hardware layers are **not** part of this J repository. foundry-j recreates **only** the math cores in pure J.

## What this J recreation does

- Pure array implementation of **Goldilocks**, **PMAT**, **spectral**, and **recurrence** under `j/`
- **56 numbered properties** inventoried in `spec/PROPERTIES.md` (with J API contract in `spec/J_API.md`)
- Verification harness under `verify/` driven by **jconsole**
- Measured harness result (2026-10-07 PT): **PASS=9 FAIL=0 BLOCKED=0** for  
  `goldilocks_add` / `goldilocks_mul` / `goldilocks_inv` / `goldilocks_sub`,  
  `pmat_insert` / `pmat_conservation`,  
  `spectral_contractive` / `spectral_expansive`,  
  `recurrence_converges`  
  Log: `verify/logs/run-20261007-061853.log`

## Layout

| Path | Role |
|------|------|
| `spec/` | Property inventory (`PROPERTIES.md`) and J API contract (`J_API.md`) |
| `j/` | Pure J implementation (Goldilocks, PMAT, spectral, recurrence, types, gate/certify stubs) |
| `verify/` | jconsole harness, property map, measured logs |
| `docs/images/` | Demo screenshots (PNG drops land here) |
| `LICENSE` | GNU Affero General Public License v3 only |

## How to run

Requires [J](https://www.jsoftware.com/) with `jconsole` on `PATH`, or the path used below.

```bash
# from a clone of this repo:
cd verify
./run.sh

# or directly:
/home/box/j/j9.7/bin/jconsole verify/run.ijs
```

Expected terminal summary ends with:

```text
PASS=9 FAIL=0 BLOCKED=0
```

## Demo screenshots

Screenshots of the verification run land under `docs/images/`.

![Foundry J verify harness](docs/images/foundry-j-verify.png)

*(If the PNG is not yet present, drop `foundry-j-verify.png` into `docs/images/` — Hilbert will place photos there.)*

## License

**AGPL-3.0-only** — see [`LICENSE`](LICENSE).

## Out of scope

Not recreated here (present in or claimed by upstream cpp-foundry / Foundry F1, not this pure-J math surface):

- SHA-256 WORM audit chain
- PIRTM linker / Triple-Lock seals
- Full gate/certify / emission / CSL / AceCertificate system theater
- Alapeno hardware (`rtl/`, `spice/`, Why3, compiler)
- Live orchestration substrate beyond the math cores
