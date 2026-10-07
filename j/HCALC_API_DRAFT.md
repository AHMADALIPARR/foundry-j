<!--
  Copyright (C) 2026 Foundry J / HCALC contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# HCALC production API draft (Core) — WAITING ON Spec `PRODUCTION.md`

**Status:** DRAFT ONLY. Not implemented. Do not treat as Spec.  
**Branch:** `draft/hcalc-production-api`  
**Owner lane:** Foundry J Core  
**Rule:** No formulas invented here. Verb names + wiring only. All math bodies land **after** Spec publishes `PRODUCTION.md` (path Spec chooses under `foundry-j` or `hcalc`).  
**Existing cite hooks:** `P64`, `spectral_analyze`, `soft_project`, `q_estimate`, `synth_weights`, `rec_step` (see `spec/J_API.md`, `j/BOXING.md`, `spec/HCALC_CROSSLINKS.md`).

Hilbert production ask (paraphrase): witness  
`Tp` from `P64`, `C` = soft_project-or-id in-step, `Λm` scalar from op-norm bound,  
step `X' = Ξ(t, Λm·C(Tp(X)))`.

---

## Proposed verb surface (names tentative until PRODUCTION.md)

| Verb (draft) | Intent | Must reuse / call | Formula source |
|--------------|--------|-------------------|----------------|
| `tp_from_p64` | Build prime-indexed transform `Tp` from `P64` (+ optional mask) | `P64` / `P_64`; maybe `apply_hook` | **Gap-Tp-from-P64** — Spec PRODUCTION.md only |
| `lam_m_from_bound` | Scalar `Λm` from an operator-norm / spectral bound | `spectral_analyze` (or gershgorin/power bounds inside it); `tier_eps` | **Gap-Λm-scalar** — Spec only |
| `c_wrap` | In-step `C[·]`: identity, or soft-project path when budget exceeded | `q_estimate`, `soft_project` | **Gap-C-wrapper** — Spec only |
| `hcalc_xi_apply` | Apply `Ξ(t, ·)` to a prepared vector | may use `synth_weights` row for time index `t` **only if Spec says so** | **Gap-Ξ** — Spec only |
| `hcalc_step` | One nested step: `X' = Ξ(t, Λm · C(Tp(X)))` | compose the above; **do not** silently call additive `rec_step` as equal | **Gap-ShapeMap** — Spec only |
| `hcalc_run` | Iterate `hcalc_step` with history boxing | follow `j/BOXING.md` nesting (`value ; <record>`) | Spec + BOXING |

Optional accessors (if Spec wants parity with SpectralResult / StepInfo):

| Draft noun/verb | Notes |
|-----------------|-------|
| `HcalcStepInfo` | Field order **owned by Spec**; Core freezes boxing in BOXING.md after Spec lists fields |
| `lam_m`, `tp`, `c_mode` | Carriers; no default numeric constants beyond those Spec cites |

---

## Explicit non-goals until PRODUCTION.md

- Do **not** equate `hcalc_step` with Foundry `rec_step` (`x' = Ξx + ΛT(x) + g`) without a Spec-named ShapeMap.
- Do **not** invent `Λm = (1-ε)/ρ` or any other closed form — even if “obvious.”
- Do **not** invent `Tp` as “diagonal of P64” or PMAT compose unless Spec writes that law.
- Do **not** implement Barrett / PHI / PMAT grading beyond `GAP_DECISIONS.md`.
- Do **not** claim Sedona / PIRTM / Triple-Lock as math for `Tp`.

---

## Implementation checklist (after PRODUCTION.md lands)

1. Spec states path: `foundry-j/j/` vs `hcalc/...` and final verb names.  
2. Core implements **only** formulas cited in PRODUCTION.md.  
3. Extend `foundry.ijs` export list / loader.  
4. Update `j/BOXING.md` for any new records.  
5. Verify (or HCALC verify) adds measured tests — Core does not invent pass counts.  
6. Push SHA; notify Hilbert.

---

## Current tree readiness

| Hook | Ready today |
|------|-------------|
| `P64` | yes (`types.ijs`) |
| `spectral_analyze` | yes (`spectral.ijs`) |
| `soft_project` / `q_estimate` | yes (`recurrence.ijs`) |
| `synth_weights` / `rec_step` | yes — Foundry additive form |
| Nested `hcalc_step` | **blocked** on PRODUCTION.md + Gap-ShapeMap |

**Idle policy:** leave this draft; implement when PRODUCTION.md exists and names the map.
