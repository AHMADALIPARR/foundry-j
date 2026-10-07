<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J Spec — HCALC PRODUCTION.md review (pass 3 / InstanceBridge)

**Reviewer:** Foundry J Spec  
**Date:** 2026-10-07 (PT)  
**Target:** `/workspace/hcalc/spec/PRODUCTION.md` @ `f5a08da`  
**Focus:** §6 ShapeMap `InstanceBridge` vs REJECT identity; Core path `/workspace/hcalc/j/`

---

## Verdict (short)

| Item | Verdict |
|------|---------|
| §6 `InstanceBridge` (NOT rfl / NOT Foundry39≡nested) | **ACCEPT** |
| Explicit param table \(T:=C\circ T_p\), \(\Lambda:=\Lambda_m\mathbf{1}\), \(\Xi:=\xi_t\) without symbol identity | **ACCEPT** |
| Option B: implement `hcalc_step` only; `toFoundryStep` diagnostic cite-only | **ACCEPT** |
| soft_project remains Foundry-coded **42–43**; `C` is Spec wiring that *uses* the scale idea | **ACCEPT** (wording in §6) |
| Core path `/workspace/hcalc/j/` + verb list matching `HCALC_API_DRAFT.md` | **ACCEPT** |
| GAP_DECISIONS | **No conflict** |
| Silent identity Foundry39 ≡ nested | Still **REJECT** — PRODUCTION agrees |

**Overall:** **ACCEPT** PRODUCTION @ `f5a08da` for ShapeMap / implement path. Non-blocking nits below.

---

## §6 ShapeMap detail

PRODUCTION now states clearly:

- `toFoundryStep` = \(\xi_t\cdot x + \Lambda_m(C\circ T_p)(x)+g_t\) under InstanceBridge params.  
- `hcalcStep` = \(\xi_t\cdot(\Lambda_m\cdot C(T_p(x)))+g_t\).  
- These differ (\(\xi_t\cdot x\) only on Foundry side).  
- L7 = structure + theorems about the table, **not** `FoundryStep = hcalcStep`.

This matches Foundry J Spec’s prior REJECT of identity and Hilbert’s explicit morphism (not rfl). **ACCEPT.**

---

## `/workspace/hcalc/j/` implement path

| Check | Result |
|-------|--------|
| Path authoritative under hcalc | **ACCEPT** |
| Verbs: `tp_from_p64`, `c_wrap`, `lam_m_from_bound`, `hcalc_xi_apply`, `hcalc_step`, `hcalc_run` | **ACCEPT** (names match draft) |
| Do not equate `hcalc_step` / `rec_step` | **ACCEPT** |
| Implementation status | **Scaffold only** (`j/README.md`); bodies still Core’s job — not a Spec reject |

---

## Non-blocking nits (optional Spec polish)

1. **§3 vs §6 soft_project wording:** §3 formula still scales **state** \(x\); Foundry **43** scales **schedules** \(\Xi,\Lambda\). §6 correctly calls that Spec wiring. One footnote in §3: “`softProjectScale` factor shared; Foundry `soft_project` API remains schedule-scaling when called as Foundry.”  
2. **Alloy checklist line** still says “FoundryAdditive” — align naming to `InstanceBridge` / `toFoundryStep` vs `hcalcStep`.  
3. **§8 Hyp under Uniform:** phrase “when using InstanceBridge” for nested Lip — prefer “when iterating `hcalcStep` (Option B)”; `toFoundryStep` has an extra \(\xi_t\cdot x\) term.  
4. **α law / ℓ∞ residual:** still Spec-def (not Foundry source-claim) — OK if provenance stays Spec-owned.

---

## Summary for Hilbert / HCALC Spec

**ACCEPT** InstanceBridge ShapeMap and `/workspace/hcalc/j/` Core path. Identity REJECT stands and is honored. Ready for Alloy/Lean/Core to implement Option B without further Foundry J Spec gate — unless they want the §3 soft_project footnote.
