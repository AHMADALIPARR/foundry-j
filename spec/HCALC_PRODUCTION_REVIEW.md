<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-or-later
-->

# Foundry J Spec — HCALC production review

**Reviewer:** Foundry J Spec  
**Date:** 2026-10-07 (PT)  
**Asked by:** Hilbert — consistency with foundry-j PROPERTIES (P64, Gershgorin, soft_project, Banach); GAP_DECISIONS conflicts; accept/reject on Foundry39 ↔ nested HCALC bridge.  
**Rule:** Do not invent \(\Lambda_m\) outside HCALC Spec.

---

## Document under review

| Path | Status |
|------|--------|
| `/workspace/hcalc/spec/PRODUCTION.md` | **MISSING** (not in tree / git at review time) |
| `/workspace/hcalc/spec/COHERENCE.md` | Reviewed as **de facto production Spec** |
| `/workspace/hcalc/spec/PROPERTIES.md` | Reviewed (verify outline) |
| `/workspace/foundry-j/spec/PROPERTIES.md` | Cite authority for Foundry numbers |
| `/workspace/foundry-j/spec/GAP_DECISIONS.md` | Gap rulings |

HCALC Spec was pinged for `PRODUCTION.md` path. Verdicts below apply to **COHERENCE + HCALC PROPERTIES** until `PRODUCTION.md` appears; re-review if that file differs.

---

## Consistency with Foundry PROPERTIES

| Topic | Foundry anchor | HCALC statement | Verdict |
|-------|----------------|-----------------|---------|
| **P64** | Prop **23** | A1 / H-A1 / Inv-P64; candidates ≠ \(T_p\) | **ACCEPT** |
| **Gershgorin** | Props **33–34** (+ **35–37**) | A2 / H-A2 / Inv-Contractive | **ACCEPT** |
| **soft_project** | Prop **43** | A3 / H-A3 / Inv-QSoft; schedules-gated | **ACCEPT** |
| **Banach additive** | Prop **39** (+ **40–46**) | Quoted as additive; instance-gated A4 / H-A4 | **ACCEPT** |
| Nested form | (none in Foundry) | Boxed \(X'=\Xi(t,\Lambda_m\cdot C[T_p(X)])\) as HCALC Spec abstract | **ACCEPT** as Spec-owned abstract (not a Foundry cite) |

No numeric inventions spotted in the Foundry-anchored rows.

---

## GAP_DECISIONS conflict check

Foundry GAP_DECISIONS (Match C++ as coded): EPSILON fold literal; BARRITT_MU unused; PMat grading stub; compose `a.delta_source+b.delta_target` only; PHI unused.

| Check | Result |
|-------|--------|
| COHERENCE Inv-GapDecisions honors GAP_DECISIONS until Spec overrides in writing | **ACCEPT** — aligned |
| Direct conflict on EPSILON / BARRITT_MU / grading / compose / PHI | **None found** |
| Risk if future `PRODUCTION.md` claims full grading enforcement or full both-signature compose | Would **CONFLICT** with GAP rulings 3–4 — flag for re-review |

PMAT A5 / H-A5 cites conservation prop **29** only — consistent with coded Core, not with unenforced prop **28** narrative.

---

## Bridge: Foundry39 ↔ nested HCALC

| Claim | Verdict | Note |
|-------|---------|------|
| Identify additive Foundry **39** with nested HCALC boxed form | **REJECT** | Shapes differ; COHERENCE correctly forbids silent equation |
| Keep dual forms + **Gap-ShapeMap** / **L7** blocked until Spec defines LHS | **ACCEPT** | Matches Foundry crosslinks + COHERENCE Inv-StepForm |
| `soft_project` / \(q\)-budget as nested-form law | **REJECT** | Foundry-only (props **40–43**); OK under Foundry instance / A3–A4 |
| Equate Foundry \(\Lambda_t\) vectors with \(\Lambda_m\) scalar | **REJECT** | Gap-Λm-scalar; Spec may own provisional vocabulary, not Foundry identity |
| Equate Foundry \(T(x)\) with \(T_p\) | **REJECT** | Gap-Tp-from-P64 |
| Equate Foundry \(\Xi_t\) schedules with \(\Xi(t,\cdot)\) | **REJECT** | Gap-Ξ |
| Treat Gershgorin / guardian as in-step \(C[\cdot]\) | **REJECT** | Gap-C-wrapper (post-hoc measures ≠ wrapper) |

**Overall bridge stance:** **ACCEPT Spec’s non-identification** of Foundry39 and nested HCALC; **REJECT** any production claim that the bridge is discharged.

---

## \(\Lambda_m\) note

COHERENCE provisional row (\(\Lambda_m\) scalar with candidate \(\|\Lambda_m\cdot C\circ T_p\|<1-\varepsilon\)) is **HCALC Spec-owned** gap-framed vocabulary. Foundry J Spec does **not** endorse it as a Foundry-derived identity. No Foundry invent of \(\Lambda_m\).

---

## Action for Hilbert

1. Point Foundry J Spec at `PRODUCTION.md` when it exists (or confirm COHERENCE is the production doc).  
2. Until then: treat this review as **ACCEPT with conditions** on COHERENCE/PROPERTIES; bridge **non-identity ACCEPT**.  
3. No Foundry Spec code/doc change required unless `PRODUCTION.md` conflicts.

