<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Gap Decisions — DRAFT for Core handoff

**Status:** DRAFT. Spec rulings for Core against gaps listed in `spec/PROPERTIES.md` § Gaps.  
**Target commit:** `194e588`.  
**Policy:** Prefer **Match C++ as coded** when README prose and implementation disagree, unless README is the only statement of a math identity (then say so). **No invented numeric constants.** Alapeno remains out of scope.

Sources for gap list: `spec/PROPERTIES.md` lines 269–276 (Gaps section).

---

## 1. EPSILON naming (README name vs `0xFFFFFFFFULL` literal)

**Sources**

- PROPERTIES Gaps: “Named C++ identifier `EPSILON`: named only in README Key Constants; code uses literal `0xFFFFFFFFULL` in mulmod, not a `types.h` symbol.”
- Prop 6 cites: README.md § “Key Constants” (line 320); `src/goldilocks.cpp:27,31`.
- `J_API.md` already exposes fold constant as noun `EPSILON_FOLD` (= `0xFFFFFFFF` = \(2^{32}-1\)), noting README name `EPSILON`.

**Ruling:** **Match C++ as coded** (literal fold mask in mulmod path).

**Rationale:** README supplies the name; the implementation never defines an `EPSILON` symbol in `types.h` — Core must implement the fold arithmetic with the same literal value, not invent a C++ identifier.

**Done for Core**

- Provide a named J noun for the fold constant (e.g. `EPSILON_FOLD` per `J_API.md`) equal to `0xFFFFFFFF` (= \(2^{32}-1\)).
- Use that value in `fp_mulmod` / fold exactly as `src/goldilocks.cpp` uses `eps` / `hi_lo` mask.
- Do not require a `types.h`-style C++ symbol named `EPSILON`; README naming is documentation alias only.

---

## 2. BARRITT_MU unused

**Sources**

- PROPERTIES Gaps: “`BARRITT_MU`: defined equal to `P` and unused (`src/goldilocks.cpp:9–10`); no Barrett algorithm steps beyond the comment.”
- No numbered property asserts Barrett reduction; Goldilocks reduction is props 5–12 (fold / mulmod as coded).

**Ruling:** **Match C++ as coded** (define-equal-to-`P`, unused; no Barrett path).

**Rationale:** Sources define the constant and leave it unused; there is no Barrett algorithm identity to implement beyond the comment. Inventing Barrett steps would invent math not present in the cited cpp.

**Done for Core**

- May omit `BARRITT_MU` entirely, or expose a synonym equal to `GOLDILOCKS_PRIME` / `P` with no call sites.
- Do **not** implement Barrett reduction; keep reduction as fold/mulmod per props 5–12 and `src/goldilocks.cpp`.

---

## 3. PMat grading unchecked in `insert` / `validate_grading`

**Sources**

- PROPERTIES Gaps: “PMat per-entry grading vs indices: stated in `pmat.h:3` but not checked in `insert` / `validate_grading`.”
- Prop 28: header/README narrative says grading `tgt_sig - src_sig = monomial` is enforced; **Gap note** — `insert` does not compare signatures to row/col grades; `validate_grading` always returns `true` (`src/pmat.cpp:19–22`). Cite: `include/pmat.h:3,21–25`.

**Ruling:** **Match C++ as coded** (stub / always-true validate; insert domain checks only).

**Rationale:** The stated grading condition is narrative in the header; the coded surface that tests and callers see is domain checks on `insert` (prop 27) plus a no-op `validate_grading`. Enforcing full grading now would change observable C++ behavior Core is recreating. README/header is not a separate coded math identity here — the stub is the behavior.

**Done for Core**

- `pmat_insert`: fail only on `row ≥ rows`, `col ≥ cols`, or `sign ∉ {1,-1}` (prop 27); do not compare signatures to row/col grades.
- `validate_grading` (or J equivalent): return success / true unconditionally, matching `src/pmat.cpp:19–22`.
- Document that prop 28 “stated” grading remains a future Spec upgrade, not Core F1 obligation.

---

## 4. Compose deltas (`a.delta_source + b.delta_target` only vs README/full both signatures)

**Sources**

- PROPERTIES Gaps: “Compose monomial rule vs ‘sum of both signatures’: coded as `a.delta_source` + `b.delta_target` only (`src/pmat.cpp:54–55`), not full addition of both signatures from both factors.”
- Prop 31 (as coded): on matching `a.col == b.row`: `sign_acc *= a.sign * b.sign`; `monom_acc.delta_source += a.monomial.delta_source`; `monom_acc.delta_target += b.monomial.delta_target`. Cite: `src/pmat.cpp:51–55`.
- Prop 30 states composition preserves grading (narrative); prop 29 conservation is separately tested on entry monomials.

**Ruling:** **Match C++ as coded** (accumulate `a.delta_source` into result source and `b.delta_target` into result target only).

**Rationale:** Prop 31 already records the coded rule with a precise cite. A “sum of both signatures from both factors” reading is the prose disagreement; Core must reproduce the cpp accumulation, not invent a fuller bilinear sum.

**Done for Core**

- On compose match `a.col == b.row`: multiply signs; add **only** `a.monomial.delta_source` to accumulated `delta_source`; add **only** `b.monomial.delta_target` to accumulated `delta_target`.
- Do not add `a.delta_target` or `b.delta_source` into the composed monomial unless/until Spec revises prop 31 against a code change.

---

## 5. PHI unused in math cpp

**Sources**

- PROPERTIES Gaps: “PHI usage in UAC/recurrence math: constant present; no consuming identity in the cited math cpp files.”
- Prop 22: `PHI = 1.618033988749895`. Cite: `include/types.h:21`. “(Sources do not state further mathematical use in the UAC/recurrence core.)”

**Ruling:** **Match C++ as coded** (constant present; unused in field / PMat / spectral / recurrence math paths).

**Rationale:** Value is sourced from `types.h`; no cited math cpp consumes it. README is not supplying a PHI identity to implement — absence of use is the coded fact.

**Done for Core**

- Expose noun `PHI` with the value from `include/types.h:21` / prop 22 (do not invent a different constant).
- Do not wire PHI into Goldilocks, PMat, spectral governor, or Banach recurrence steps unless a later Spec cites a consuming identity.

---

## Summary table

| # | Gap | Spec ruling | Done for Core (one line) |
|---|-----|-------------|---------------------------|
| 1 | EPSILON naming | Match C++ as coded | Named fold noun = `0xFFFFFFFF`; use in mulmod; no required C++ `EPSILON` symbol |
| 2 | BARRITT_MU unused | Match C++ as coded | Omit or synonym-of-P; no Barrett algorithm |
| 3 | PMat grading unchecked | Match C++ as coded | Insert domain checks only; validate always true |
| 4 | Compose deltas | Match C++ as coded | `a.delta_source` + `b.delta_target` only (prop 31) |
| 5 | PHI unused | Match C++ as coded | Expose constant; no math consumer in Core F1 |

---

## Handoff note

This document is **DRAFT for Core**. It does not modify `PROPERTIES.md`, `j/`, `verify/`, `include/`, `src/`, or Alapeno. Core should treat the five “Done for Core” bullets as the F1 obligation for these gaps; reopen Spec only if a later commit changes the cited cpp behavior.
