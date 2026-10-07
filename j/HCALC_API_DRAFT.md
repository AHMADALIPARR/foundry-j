<!--
  Copyright (C) 2026 Foundry J / HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# HCALC production API draft (Core) — WAITING ON Spec `PRODUCTION.md`

**Status:** DRAFT ONLY. Not implemented. Do not treat as Spec.  
**Branch:** `draft/hcalc-production-api`  
**Owner lane:** Foundry J Core  
**Rule:** No formulas invented here. Verb names + wiring only. Math bodies land **after** Spec publishes `/workspace/hcalc/spec/PRODUCTION.md` (exact formulas).  
**Existing cite hooks:** `P64`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step` (`spec/J_API.md`, `j/BOXING.md`, `spec/HCALC_CROSSLINKS.md`).  
**Aligned to:** HCALC Spec PRODUCTION close (via Hilbert) — intents below; Foundry J Spec `FOUNDRY_J_PRODUCTION_REVIEW.md` (bridge non-identity until ShapeMap named).

---

## Spec-stated intents (cite; formulas TBD in PRODUCTION.md)

| Piece | Spec intent (as given) | Gap until PRODUCTION.md |
|-------|------------------------|-------------------------|
| \(T_p\) | From `P64` / PrimeMask **diagonal** \(\alpha_j\) | Gap-Tp-from-P64 — exact \(\alpha_j\) law TBD |
| \(C\) | In-step soft_project governor on \(\|D(T_p)\|\) vs \(1-\varepsilon\) | Gap-C-wrapper — exact \(D(\cdot)\) TBD |
| \(\Lambda_m\) | **Scalar** (not `lambda_schedule` vector) with \(\|\Lambda_m\cdot(C\circ T_p)\|_{\mathrm{op}}\le 1-\varepsilon\) | Gap-Λm-scalar — how bound is measured TBD |
| \(\Xi(t,y)\) | \(\xi_t\cdot y+g_t\) from `xi_schedule` (Uniform default) | Gap-Ξ — schedule/g_t details TBD |
| ShapeMap | Additive FoundryStep with \(T:=C\circ T_p\), \(\Lambda:=\Lambda_m\cdot\mathbf{1}\), \(\Xi:=\xi_t\) | Gap-ShapeMap — PRODUCTION.md must name this bridge |
| Nested step | \(X'=\Xi(t,\Lambda_m\cdot C(T_p(X)))\) | Compose only after formulas land |

---

## Proposed verb surface (names tentative)

| Verb (draft) | Intent | Must reuse / call |
|--------------|--------|-------------------|
| `tp_from_p64` | \(T_p\) from `P64` / optional PrimeMask; diagonal \(\alpha_j\) when Spec defines \(\alpha\) | `P64` / `P_64` |
| `lam_m_from_bound` | Scalar \(\Lambda_m\) from op-norm / spectral bound of \(C\circ T_p\) (or Spec-named Jacobian) | `spectral_analyze`, `tier_eps` |
| `c_wrap` | In-step \(C[\cdot]\): id or soft_project governor vs \(1-\varepsilon\) | `q_estimate`, `soft_project` |
| `hcalc_xi_apply` | \(\Xi(t,y)=\xi_t\cdot y+g_t\) using `xi_schedule` (Uniform default via `synth_weights`) | `synth_weights` |
| `hcalc_step` | Nested one-step \(X'=\Xi(t,\Lambda_m\cdot C(T_p(X)))\) | compose above |
| `hcalc_shapemap_step` | Optional: run additive `rec_step` under ShapeMap \(T:=C\circ T_p\), \(\Lambda:=\Lambda_m\cdot 1\), \(\Xi:=\xi_t\) **only if** PRODUCTION.md so directs | `rec_step` |
| `hcalc_run` | Iterate with BOXING.md nesting | — |

---

## Explicit non-goals until PRODUCTION.md

- No invented \(\alpha_j\), \(\Lambda_m=(1-\varepsilon)/\rho\), or \(D(T_p)\) definitions.
- Do not silently equate nested `hcalc_step` with Foundry `rec_step` without Spec-named ShapeMap.
- Do not treat `lambda_schedule` as \(\Lambda_m\).
- Honor `GAP_DECISIONS.md` (grading stub, compose deltas, no Barrett/PHI consumers).

---

## Checklist after PRODUCTION.md lands

1. Read exact formulas + path (`foundry-j/j/` vs `hcalc/...`).  
2. Implement **only** those formulas; rename verbs to Spec’s names if different.  
3. Update `foundry.ijs` exports + `BOXING.md`.  
4. Verify / report SHA to Hilbert + HCALC Spec.

**Idle now:** PRODUCTION.md still missing at review time.
