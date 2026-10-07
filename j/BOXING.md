<!--
  Copyright (C) 2026 Foundry / Prime Materia Commons
  SPDX-License-Identifier: AGPL-3.0-or-later

  This file is part of Foundry F1 Pure-J Core.
  License: GNU Affero General Public License v3.0 or later.
  See <https://www.gnu.org/licenses/>.
-->

# Foundry J Core — Record boxing contracts

Field **order** is owned by `spec/J_API.md`. This file freezes the **boxing / nesting** used by Pure-J Core under `j/` so `;` (link) never flattens multi-field records into sibling boxes when paired with another value.

## J link hazard (why wrap)

In J9, `x ; y` with **unboxed** `x` and **list-of-boxes** `y` yields `(<x) , y` — the fields of `y` become siblings of `x`. Multi-field records must therefore be wrapped in **one outer box** whenever they are:

- returned alone as a record value, or
- linked with another value (`value ; <record>`).

Atoms and plain numeric arrays are not list-of-boxes; `xi ; lam` with two numeric arrays is already length-stable.

## StepInfo (length 7)

Open field list (J_API order):

```text
step ; q ; epsilon ; n_xi ; n_lam ; projected ; residual
```

| Producer | Return shape |
|----------|----------------|
| `rec_step` | `x_next ; <StepInfo>` — always length 2 |
| `rec_run` | list of `<StepInfo>` (one box per step) |
| `REC_STATE` | `x_current ; converged ; <history>` — length 3; `history` is the same list `rec_run` returns |

Unpack:

```j
'x info' =. x rec_step ...          NB. info is still boxed
info =. > info                      NB. open length-7 StepInfo
NB. or: info =. 1 {:: pair

hist =. x0 rec_run ...
step =. > k { hist                  NB. open StepInfo
resid =. 6 {:: step                 NB. or > 6 { step
```

## SpectralResult (length 5)

Open field list (J_API order):

```text
spectral_radius ; contractive ; gershgorin_bound ; power_iter_bound ; used_power_iteration
```

| Producer | Return shape |
|----------|----------------|
| `gershgorin_check` | `<SpectralResult>` |
| `power_iteration_check` | `<SpectralResult>` |
| `spectral_analyze` | `<SpectralResult>` |

Unpack: `sr_open res` then index, or `1 {:: > res`, or `sr_contractive res`.
`sr_open` is `>` (Core). Parenthesize: `sr_open (J spectral_analyze eps)`.

Accessors `sr_radius` … `sr_used_pi` accept wrapped or open form.

## AceCert (length 4)

Open field list (J_API order):

```text
lipschitz_upper ; safety_margin ; tail_bound ; certified
```

| Producer | Return shape |
|----------|----------------|
| `ace_certify` | `<AceCert>` |

`ace_certify` consumes a list of `<StepInfo>` (same packing as `rec_run` history).

Unpack: `> ace` then field index, e.g. `3 {:: > ace` for `certified`.

## PMat

Open field list (shape used by Core today):

```text
rows ; cols ; entries
```

- `rows`, `cols` — integer atoms  
- `entries` — numeric table `n×5`: `sign , delta_source , delta_target , row , col` (empty: `0 5 $ 0`)

| Producer | Return shape |
|----------|----------------|
| `pmat_new` | open `rows ; cols ; entries` |
| `pmat_compose` | open `rows ; cols ; entries` |
| `pmat_insert` | **`new_PMat ; <ok>`** — length 2; `new_PMat` is the open 3-field PMat; `ok` is boolean 0/1 wrapped so the pair stays length-2 under link |

Unpack insert:

```j
pair =. m pmat_insert row ; col ; sign ; sig
m  =. 0 {:: pair          NB. open PMat
ok =. 1 {:: pair          NB. boolean (opens <ok>)
NB. 'm ok' =. pair  then  ok =. > ok
```

Accessors `pmat_rows` / `pmat_cols` / `pmat_entries` take the **open** PMat.

`pmat_validate_grading` remains the C++ stub: always `1` (no invented checks).

## Other multi-part returns

| Producer | Return shape |
|----------|----------------|
| `synth_weights` | `xi_schedule ; lambda_schedule` — length 2; each a numeric table |
| `soft_project` | `xi ; lam` — length 2; each a numeric list |

Both sides are unboxed numerics, so bare `;` is length-stable. Do not link an unboxed value onto these pairs without wrapping the pair: `value ; <(xi;lam)>`.

## Summary preference

| Situation | Shape |
|-----------|--------|
| Record alone | `<record>` (StepInfo items in history; SpectralResult; AceCert) |
| Value + record | `value ; <record>` (`rec_step`; conceptually same nesting for insert) |
| PMat alone | open `rows ; cols ; entries` |
| PMat + ok | `PMat ; <ok>` |
| Numeric pair | `a ; b` (schedules / soft_project) |
