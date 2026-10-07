# Foundry F1 — Pure-J Core API Surface

Mapping of the C++ mathematical surface to J Core verbs/nouns.
**No implementation.** Names, ranks, and domains only.
Preferred license for derivative pure-J work: **AGPL-3.0**.

Convention: J ranks — `0` atom, `1` list/vector, `2` table/matrix, `3` rank-3. Domains name the mathematical carrier.

---

## Nouns (data carriers)

| Noun | Rank | Domain | Maps from |
|------|------|--------|-----------|
| `Fp` | 0 | atom `u64` with \(0 \le v < p\) | `Goldilocks::Elem` |
| `FpVec` | 1 | list of `Fp` | batch Elem arrays |
| `Signature` | 1 | length-2 integer list `(delta_source; delta_target)` | `pmc::Signature` |
| `PMatEntry` | 1 | boxed/record: `sign (±1)`, `Signature`, `row`, `col` | `pmc::PMatEntry` |
| `PMat` | 1–2 | sparse list of `PMatEntry` plus shape `(rows; cols)` | `pmc::PMat` |
| `Jacobian` | 2 | real matrix \( n\times n \) | `vector<vector<double>>` spectral input |
| `State` | 1 | real vector \( x_t \) | recurrence state |
| `Weights` | 1 | length-2 (or dim) real list for Ξ / Λ schedule row | `xi_schedule_[t]`, `lambda_schedule_[t]` |
| `StepInfo` | 0–1 | record: `step`, `q`, `epsilon`, `n_xi`, `n_lam`, `projected`, `residual` | `pmc::StepInfo` |
| `SpectralResult` | 0–1 | record: `spectral_radius`, `contractive`, `gershgorin_bound`, `power_iter_bound`, `used_power_iteration` | `SpectralGovernor::Result` |
| `AceCert` | 0–1 | record: `lipschitz_upper`, `safety_margin`, `tail_bound`, `certified` | `pmc::AceCertificate` |
| `Tier` | 0 | enum atom T1..T4 | `pmc::Tier` |
| `GatePolicy` | 0 | enum: PassThrough / Suppress / Hold / Attenuate | `pmc::GatePolicy` |
| `P64` | 1 | length-64 list of first primes | `pmc::P_64` |
| `PrimeMask` | 0 | `u64` bitmask over `P64` indices | `pmc::PrimeMask` |
| `ResonanceWord` | 0 | `u64` packed class∥payload | `pmc::ResonanceWord` |

### Named constant nouns (must match PROPERTIES.md)

| Noun | Rank | Value source |
|------|------|--------------|
| `GOLDILOCKS_PRIME` / `p` | 0 | `0xFFFFFFFF00000001` = 18446744069414584321 |
| `EPSILON_FOLD` | 0 | `0xFFFFFFFF` = \(2^{32}-1\) (fold; README name `EPSILON`) |
| `K_MAX` | 0 | 133144 |
| `MAX_DRIFT` | 0 | 300000000000000000 |
| `PIRTM_MAGIC` | 0 | `0x7F504952` |
| `PHI` | 0 | 1.618033988749895 |
| `tier_epsilon` | 0←0 | T1:0.10 T2:0.05 T3:0.02 T4:0.01 |

---

## Verbs — Goldilocks field

| Verb | Rank | Domain → range | Meaning |
|------|------|----------------|---------|
| `fp_reduce` | 0→0 | `u64` → `Fp` | conditional \( x-p \) if \( x\ge p \) |
| `fp_add` | 0 0→0 | `Fp×Fp` → `Fp` | \( (a+b)\bmod p \) |
| `fp_sub` | 0 0→0 | `Fp×Fp` → `Fp` | \( (a-b)\bmod p \) |
| `fp_mul` | 0 0→0 | `Fp×Fp` → `Fp` | mulmod via reduction identity |
| `fp_mulmod` | 0 0→0 | `u64×u64` → `u64` | 128-bit product + fold \( \mathrm{lo}+\mathrm{hi\_lo}\cdot\varepsilon-\mathrm{hi\_hi} \) |
| `fp_pow` | 0 0→0 | `Fp×u64` → `Fp` | square-and-multiply |
| `fp_inv` | 0→0 | `Fp` → `Fp` | \( a^{p-2} \) (Fermat) |
| `fp_add_batch` | 1 1→1 | `FpVec×FpVec` → `FpVec` | elementwise add |
| `fp_mul_batch` | 1 1→1 | `FpVec×FpVec` → `FpVec` | elementwise mul |

---

## Verbs — PMAT

| Verb | Rank | Domain → range | Meaning |
|------|------|----------------|---------|
| `pmat_new` | 0 0→1 | `(rows;cols)` → empty `PMat` | allocate shape |
| `pmat_insert` | 1 0 0 0 1→1 | PMat,row,col,sign,Signature → PMat\|fail | domain checks ±1 and bounds |
| `pmat_validate_grading` | 1→0 | `PMat` → boolean | global grading (stated identity) |
| `pmat_conservation` | 1→1 | `PMat` → `Signature` | Σ monomials |
| `pmat_compose` | 1 1→1 | `PMat×PMat` → `PMat` | sign multiply + monomial accumulate |
| `pmat_frobenius` | 1→0 | `PMat` → real | \( \sqrt{\#entries} \) |

---

## Verbs — Spectral governor

| Verb | Rank | Domain → range | Meaning |
|------|------|----------------|---------|
| `gershgorin_bound` | 2→0 | `Jacobian` → real | max disk \( |J_{ii}|+\sum_{j\neq i}|J_{ij}| \) |
| `gershgorin_check` | 2 0→1 | Jacobian,ε → `SpectralResult` | contractive iff bound \( <1-\varepsilon \) |
| `power_iteration` | 2 0 0→0 | Jacobian,max_iters,tol → real | dominant \|eigenvalue\| |
| `power_iteration_check` | 2 0 0→1 | Jacobian,ε,max_iters → `SpectralResult` | same contractive predicate |
| `spectral_analyze` | 2 0→1 | Jacobian,ε → `SpectralResult` | Gershgorin then optional power iter |

---

## Verbs — Banach recurrence

| Verb | Rank | Domain → range | Meaning |
|------|------|----------------|---------|
| `tier_eps` | 0→0 | `Tier` → real | margin ε |
| `synth_weights` | 0 0 1→2 | max_steps,Tier,profile,[primes] → (Ξ schedule; Λ schedule) | Uniform/Harmonic/LogDecay; 0.7/0.3 of \( q^\star \) |
| `soft_project` | 1 1 0 0→1 1 | Ξ,Λ,q,ε → scaled Ξ,Λ | scale by \( (1-\varepsilon)/q \) if \( q>1-\varepsilon \) |
| `rec_step` | 1 1 1 1→1 1 | x, Ξ, Λ, g ; T ; p_op → (x_next; StepInfo) | \( x'=\Xi x+\Lambda T(x)+g \) then project |
| `rec_run` | 1 0→2 | x0, config, T, p_op → StepInfo history | until residual < tol or max_steps |
| `residual_l2` | 1 1→0 | x_next, x_t → real | \( \|x'-x\|_2 \) |
| `q_estimate` | 1 1 1 1→0 | Ξ,Λ,x,Tx → real | \( \|\Xi\|_\infty+\|\Lambda\|_\infty\cdot\|T\| \) (coded max-abs form) |

Transform `T` and projector `p_op` are rank-1→1 function nouns (hooks), not fixed verbs.

---

## Verbs — Emission / CSL / certify (math-adjacent)

| Verb | Rank | Domain → range | Meaning |
|------|------|----------------|---------|
| `emit_apply` | 1 1 0 0→1 | out,prev,q,policy×ε → out' | PassThrough/Suppress/Hold/Attenuate |
| `csl_neutrality` | 1 1 0→0 | x,Tx,ε → verdict | pairwise Lip-style bound |
| `csl_beneficence` | 1 1 0 0→0 | x,Tx,residual,ε → verdict | norm & residual growth |
| `csl_commutation` | 1 0→0 | x; T; filter; ε → verdict | filter∘T ≈ T∘filter |
| `ace_safety_margin` | 0 0→0 | max_q,ε → real | \( (1-\varepsilon)-\max_q \) |
| `ace_tail_bound` | 0 0→0 | tail_norm,max_q → real | \( \mathrm{tail}/(1-\max_q) \) or ∞ |
| `ace_certify` | 1 0→1 | StepInfo list, delta → `AceCert` | margin ≥ delta |

---

## Coverage map (C++ → J)

| C++ module | J surface |
|------------|-----------|
| `goldilocks.h/cpp` | `fp_*` verbs + `Fp` / `FpVec` |
| `pmat.h/cpp` | `pmat_*` + `Signature` / `PMat` |
| `spectral.h/cpp` | `gershgorin_*` / `power_*` / `spectral_analyze` |
| `recurrence.h/cpp` | `rec_*` / `synth_weights` / `soft_project` / `q_estimate` |
| `types.h` constants | constant nouns + `tier_eps` |
| `gate.h/cpp` (math) | `emit_apply` / `csl_*` |
| `certify.h/cpp` | `ace_*` |

Non-math orchestration (SHA-256 WORM bytes, linker PIRTM, audit JSON) is out of this pure-J math Core inventory except where PROPERTIES.md cites seal-chain / consensus narrative for completeness.
