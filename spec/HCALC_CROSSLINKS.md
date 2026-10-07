<!--
  Copyright (C) 2026 Foundry J / HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J → HCALC cross-links (Spec input)

**From:** Foundry J Spec  
**For:** HCALC Spec / Alloy / Lean (via Hilbert)  
**Sources:** `/workspace/foundry-j/spec/PROPERTIES.md`, `J_API.md`, `GAP_DECISIONS.md`; Foundry README Sedona Spine / PIRTM.  
**HCALC abstract (as given):** \( X_{t+1}=\Xi(t,\Lambda_m\cdot C[T_p(X_t)]) \).  
**Rule:** No invented \(\Lambda_m\) or \(\Xi\) definitions. Gaps flagged below.  
**Note:** `/workspace/hcalc` had no prior tree when this note was written.

---

## 0. Shape gap (read first)

| | Foundry F1 (cited) | HCALC abstract (given) |
|--|--------------------|-------------------------|
| Step | \( x_{t+1}=\Xi_t x_t+\Lambda_t T(x_t)+g_t \) (PROPERTIES **39**) | \( X_{t+1}=\Xi(t,\Lambda_m\cdot C[T_p(X_t)]) \) |
| \(\Xi\) | Per-step **schedule weights** (length-2 vectors) | Operator/map \(\Xi(t,\cdot)\) — **undefined in Foundry** |
| \(\Lambda\) / \(\Lambda_m\) | \(\Lambda_t\) schedule weights (same carrier as \(\Xi_t\)) | \(\Lambda_m\) — **no definition in Foundry sources** |
| \(T\) / \(T_p\) | Nonlinear \(T(x)\) in recurrence; **no \(T_p\)** symbol | Prime-indexed \(T_p\) — **not named in Foundry math** |
| \(C\) | Not a Foundry recurrence symbol | **Undefined** in Foundry inventory |

**Spec stance:** Treat Foundry as a **candidate instantiation layer** for pieces of the HCALC pipeline (prime index set, contraction tests, Banach step), not as a definition of \(\Lambda_m\) or HCALC-\(\Xi\). Alloy/Lean must not silently equate the two step forms.

---

## 1. Map: what Foundry can instantiate

### \(T_p\) candidates (prime-indexed structure)

| Foundry prop / surface | Role vs \(T_p\) | Cite |
|------------------------|----------------|------|
| **23** `P_64` (first 64 primes, length-64 list) | Discrete **prime index set** for any prime-indexed tensor/mask; strongest Foundry hook for “prime-indexed” | `types.h:24–30`; PROPERTIES 23 |
| `PrimeMask` / `ResonanceWord` (J_API nouns) | Bitmask / packed class∥payload over `P_64` indices — **representation**, not a recursive tensor law | J_API.md nouns |
| **26–32** PMAT / prime monomials (`Signature`, conservation, compose-as-coded) | Sparse **prime-monomial** linear algebra; possible skeleton for layer ops, **not** a definition of recursive tensor reps | PROPERTIES E; GAP_DECISIONS: grading stub, compose = `a.delta_source+b.delta_target` only |
| **1–17** Goldilocks \(\mathbb{F}_p\) | Finite-field **carrier** for discrete/algebraic lifts; does **not** by itself give real contraction of \(X_t\) | PROPERTIES A–C |
| **21** `PIRTM_MAGIC` / linker PIRTM | Bytecode/linker theater (Sedona Spine tooling) — **not** a math definition of \(T_p\) | PROPERTIES 21; README linker |

**Sedona Spine:** README names a 10-layer architecture and Triple-Lock; it does **not** define HCALC \(T_p\), \(\Lambda_m\), or \(C\). Use as architectural context only.

### Contraction / spectral measures (layerwise contraction → converged \(X\))

| Foundry prop | Measure | Cite |
|--------------|---------|------|
| **33–34** Gershgorin bound; `contractive ⟺ bound < 1-ε` | A priori row-sum spectral bound | PROPERTIES 33–34 |
| **35–37** Power iteration + fallback policy | Dominant-modulus check; recheck when Gershgorin tight | PROPERTIES 35–37 |
| **38** Contractive / expansive test matrices | Concrete witnesses (quoted in PROPERTIES; do not alter) | PROPERTIES 38 |
| **25** Tier ε: T1→0.10, T2→0.05, T3→0.02, T4→0.01 | Contraction **margin** schedule | PROPERTIES 25 |
| **39–46** Banach recurrence, \(q_t\), soft project, residual | Foundry **evolution** + projection when \(q>1-\varepsilon\) | PROPERTIES G |
| **55** Guardian spectral legality | Reject if `spectral_radius >= 1` or non-finite next state | PROPERTIES 55 |

---

## 2. Invariants demanded before calling HCALC “coherent”

Demand these as **explicit** Spec/Alloy/Lean obligations (Foundry-backed where cited; HCALC-native where flagged):

1. **Step-form declared** — Either adopt Foundry **39** as an instance, or define HCALC \(\Xi(t,\cdot)\) / \(\Lambda_m\) / \(C\) / \(T_p\) separately. **Do not mix symbols without a bridge lemma.** (Gap: HCALC defs missing.)
2. **Prime index honesty** — If “prime-indexed” means Foundry, \(T_p\) (or its mask) is valued on **`P_64` (prop 23)** or a stated extension; no silent infinite prime stream.
3. **Contraction predicate** — Layer/Jacobian (or stated linearization) satisfies Foundry-style **34/36**: modulus bound \(< 1-\varepsilon\) for a declared \(\varepsilon\) (tier **25** or other cited constant).
4. **q-budget / soft projection** — If Foundry schedules are used: **40/42/43** — \(q=\|\Xi\|+\|\Lambda\|\cdot\|T\|\); if \(q>1-\varepsilon\), scale as coded.
5. **Convergence witness** — Residual **46** (or Lean equivalent) below a declared tolerance; unique fixed-point only where Banach hypotheses **41** are discharged (not assumed from narrative alone).
6. **PMAT conservation (if PMAT used)** — **29** product/sum of entry monomials equals accumulated signature sums (test vector cited in PROPERTIES).
7. **Gap rulings respected** — Match C++ as coded per `GAP_DECISIONS.md` (compose deltas, grading stub, EPSILON literal, unused BARRITT_MU/PHI) until HCALC Spec overrides **in writing**.
8. **No invented \(\Lambda_m\)** — Alloy/Lean may leave \(\Lambda_m\), HCALC-\(\Xi\), \(C\), \(T_p\) as **opaque symbols** or axioms with `sorry`/uninterpreted ops until HCALC Spec defines them.

---

## 3. Shortlist for Alloy asserts + Lean axiom candidates

### Alloy-oriented asserts (finite, checkable)

| ID | Assert (informal) | Foundry anchor |
|----|-------------------|----------------|
| A1 | `#P_64 = 64` and elements are the listed first-64 primes | Prop **23** |
| A2 | `contractive(J,ε) iff gershgorin(J) < 1-ε` (and optional power-iter branch **37**) | **33–37** |
| A3 | Soft-project: if `q > 1-ε` then scaled weights used in the step | **43** |
| A4 | Recurrence carrier: next state is affine Foundry form **only if** instance = Foundry | **39** |
| A5 | PMAT conservation on insert-set | **29** |
| A6 | Guardian: reject when spectral radius ≥ 1 or non-finite | **55** |
| A7 | **Gap stub:** `Λm`, HCALC-`Ξ`, `C`, `T_p` are unconstrained until defined — assert **presence of a definition record**, not a formula | (no Foundry cite) |

### Lean axiom / definition candidates (prefer defs where Foundry is concrete)

| ID | Candidate | Kind | Note |
|----|-----------|------|------|
| L1 | `P64 : Fin 64 → ℕ` with the PROPERTIES **23** list | **definition** (data) | No axiom needed if listed |
| L2 | `gershgorinBound`, `contractiveG` | **definition** + theorem | From **33–34** |
| L3 | `FoundryStep Ξ Λ T g x` | **definition** | Exact **39**; ≠ HCALC abstract |
| L4 | `qEstimate` / `softProject` | **definition** | **42–43** as coded |
| L5 | Banach unique fixed point under `q < 1-ε` | **theorem** (or axiom until proof) | Narrative **41** — prove or mark unfinished |
| L6 | `Λm`, `HCALC.Ξ`, `C`, `Tp` | **axioms / uninterpreted** | **Gaps — do not invent** |
| L7 | Bridge `HCALCStep = FoundryStep` (or embedding) | **axiom or theorem** | Only after HCALC Spec defines left-hand side |

### Explicit gaps (do not invent)

- \(\Lambda_m\) — no Foundry definition (Foundry has \(\Lambda_t\) weights only).
- HCALC \(\Xi(t,\cdot)\) — not Foundry \(\Xi_t\) vectors.
- \(C[\cdot]\) — undefined in Foundry inventory.
- \(T_p\) — no Foundry symbol; closest are `P_64` + PMAT + \(T(x)\).
- Recursive tensor representation law — **absent** from Foundry PROPERTIES.
- `/workspace/hcalc` content beyond this note — none at write time.

---

## 4. Suggested handoff order

1. HCALC Spec: define or explicitly leave open \(\Lambda_m\), \(\Xi\), \(C\), \(T_p\).  
2. Alloy: A1–A6 on Foundry instance; A7 gate on open symbols.  
3. Lean: L1–L4 defs first; L6 axioms for gaps; L5/L7 only with proof or labeled unfinished.  
4. Foundry Core/Verify: keep prop **16** FAIL and coverage matrix in view when claiming Goldilocks lifts into HCALC.

