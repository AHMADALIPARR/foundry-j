<!--
  Copyright (C) 2026 Foundry J contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# foundry-j

**A pure-J recreation of the mathematical cores of Foundry F1: the Goldilocks prime field, prime monomial matrices, the spectral contraction governor, and the additive Banach recurrence — each property traced to a source line and checked by a J harness.**

---

## Abstract

Foundry F1 is a C++/C99 system whose lowest layer is a small, self-contained body of mathematics: arithmetic in the 64-bit Goldilocks prime field, a sparse signed-matrix type graded by prime monomials, a Gershgorin and power-iteration spectral test, and a contraction recurrence

$$
x_{t+1} = \Xi_t \cdot x_t + \Lambda_t \cdot T(x_t) + g_t
$$

whose step is kept contractive by a soft projection of its weight schedules. Around that core the upstream project builds orchestration: audit chains, seals, gates, certificates, and hardware.

This repository recreates **only the mathematics**, in J, with no other runtime. The work proceeds from an inventory of fifty-six numbered properties extracted from the upstream sources, each with a `file:line` citation, through a frozen J API, to a verification harness that tests every property and prints one verdict line per check. The latest run on disk reports **61 PASS, 0 FAIL, 4 SKIP**; the four skips are properties that are narrative or system-level rather than mathematical.

The repository is also the reference against which the sibling project [HCALC](https://github.com/AHMADALIPARR/hcalc) states what it borrows and what it does not.

---

## 1. Purpose and method

There are two reasons to recreate a numerical core in a second language. The first is to understand it: an array language forces every reduction, every boundary case, and every implicit cast in the original to be made explicit. The second is to have an independent oracle: when two implementations of the same property agree on the same inputs, and the property is pinned to a line of the original, disagreement anywhere downstream becomes a precise question rather than a vague suspicion.

foundry-j follows a fixed method:

1. **Inventory.** [`spec/PROPERTIES.md`](spec/PROPERTIES.md) lists 56 properties of the upstream mathematics. Each one cites a header, a source file, a test, or a README section. Numeric constants are copied, never invented.
2. **Gap rulings.** Where upstream prose and upstream code disagree, [`spec/GAP_DECISIONS.md`](spec/GAP_DECISIONS.md) records a ruling. The default policy is *match the C++ as coded*, unless the prose is the only statement of an identity.
3. **API.** [`spec/J_API.md`](spec/J_API.md) fixes nouns, verbs, ranks, and record field orders. [`j/BOXING.md`](j/BOXING.md) freezes how multi-field records are boxed so that J's link operator never flattens them.
4. **Core.** The J sources under `j/` implement the API in a single locale, `foundry`.
5. **Verify.** The harness under `verify/` loads the core, runs one check per property plus nine named baseline tests, and writes a timestamped log.

---

## 2. The Goldilocks prime field

### 2.1 The prime

$$
p = 2^{64} - 2^{32} + 1 = 18446744069414584321 = \mathtt{0xFFFFFFFF00000001}.
$$

Field elements are integers $0 \le v < p$. In J the modulus is the extended-precision noun `GOLDILOCKS_PRIME` (alias `p`), and all field verbs promote their arguments to extended integers with `x:`, so intermediate sums and products never wrap.

### 2.2 Why this prime reduces cheaply

The prime is chosen so that powers of two fold back into small expressions. From $p = 2^{64} - 2^{32} + 1$,

$$
2^{64} \equiv 2^{32} - 1 \pmod{p}, \qquad 2^{96} = 2^{32} \cdot 2^{64} \equiv 2^{64} - 2^{32} \equiv -1 \pmod{p}.
$$

Write a 128-bit product as $a \cdot b = \mathrm{lo} + 2^{64}\,\mathrm{hi}$ and split the high word as $\mathrm{hi} = \mathrm{hi_{lo}} + 2^{32}\,\mathrm{hi_{hi}}$, with $\mathrm{lo} < 2^{64}$ and $\mathrm{hi_{lo}}, \mathrm{hi_{hi}} < 2^{32}$. Then

$$
a \cdot b \equiv \mathrm{lo} + (2^{32} - 1)\,\mathrm{hi_{lo}} - \mathrm{hi_{hi}} \pmod{p}.
$$

This is the reduction identity of properties 5–9. The constant $2^{32} - 1 = 4294967295$ is the fold constant, named `EPSILON` in the upstream README and `EPSILON_FOLD` here.

### 2.3 The fold as coded

`fp_mulmod` follows the upstream algorithm step by step (properties 7–11):

1. Form the product and split it: `lo = product mod 2^64`, `hi = floor(product / 2^64)`.
2. Split the high word: `hi_lo = hi mod 2^32`, `hi_hi = floor(hi / 2^32)`.
3. Fold: `folded = lo + hi_lo * EPSILON_FOLD`.
4. Subtract with underflow handling: if `folded >= hi_hi` then `reduced = folded - hi_hi`, else `reduced = folded + p - hi_hi`.
5. Final conditional reduction: if `reduced >= p` then subtract $p$ once.

One subtraction suffices in the last step. The largest possible fold is $(2^{64} - 1) + (2^{32} - 1)^2 = 2^{65} - 2^{33}$, which is below $2p = 2^{65} - 2^{33} + 2$; hence after removing $\mathrm{hi_{hi}}$ the value is below $2p$ and one conditional subtraction lands it in $[0, p)$.

A source comment in `fp_mulmod` records the one subtle point: upstream extracts `hi_lo` with the bit mask `hi & 0xFFFFFFFF`, which is reduction modulo $2^{32}$, not modulo the fold constant $2^{32} - 1$. Getting that wrong produces a multiplication that looks plausible on small inputs and breaks on products whose high word is large — which is exactly where exponentiation, and hence inversion, spends its time.

### 2.4 Field operations

| Verb | Definition | Property |
|---|---|---|
| `fp_reduce` | $x - p$ if $x \ge p$, else $x$ (single limb) | 12 |
| `fp_add` | $a + b$, minus $p$ if the sum reaches $p$ | 13 |
| `fp_sub` | $a - b$, plus $p$ on underflow | 14 |
| `fp_mul` | `fp_mulmod` | 15 |
| `fp_pow` | square-and-multiply from `result = 1`, `base = a` | 17 |
| `fp_inv` | Fermat: $a^{-1} = a^{p-2} \bmod p$ | 16 |
| `fp_add_batch`, `fp_mul_batch` | element-wise over lists | 18 |

Fermat inversion is correct because $p$ is prime: for $a \not\equiv 0$, $a^{p-1} \equiv 1$, so $a \cdot a^{p-2} \equiv 1$. The harness checks it on the upstream test value $a = 42$.

---

## 3. Named constants

The upstream header `include/types.h` defines constants beyond the field. foundry-j reproduces them exactly, because other layers and other repositories cite them:

| Noun | Value | Property | Note |
|---|---|---|---|
| `K_MAX` | 133144 | 19 | upstream: maximum W8A8 accumulation |
| `MAX_DRIFT` | 300000000000000000 | 20 | upstream: drift bound, $3 \times 10^{17}$ |
| `PIRTM_MAGIC` | `0x7F504952` | 21 | bytecode magic `\x7FPIR` |
| `PHI` | 1.618033988749895 | 22 | present upstream; no consuming identity in the math sources |
| `P64` (alias `P_64`) | 2, 3, 5, …, 311 | 23 | the first 64 primes |
| `GENESIS_HASH_SIZE` | 32 | 24 | recorded, not used by the math cores |
| `tier_eps` | T1: 0.10, T2: 0.05, T3: 0.02, T4: 0.01; default 0.10 | 25 | contraction margins $\varepsilon$ |

$P_{64}$ and the tier margins are the two constants that matter most outside this repository: HCALC builds its prime-weighted transform from $P_{64}$ and takes its default margin from tier T2, and sedona-k uses $P_{64}$ as the mode set of its Riemann gas.

---

## 4. Prime monomial matrices (PMAT)

A PMAT is a sparse matrix whose non-zero entries are signs, each tagged with a *signature* — a pair of integer grades $(\delta_{\mathrm{src}}, \delta_{\mathrm{tgt}})$ called the entry's monomial. In J a PMAT is the triple `rows ; cols ; entries`, where each entry row is `sign, ds, dt, row, col`.

### 4.1 Insertion (properties 26–28)

`pmat_insert` rejects an entry if `row >= rows`, `col >= cols`, or the sign is not $\pm 1$, and otherwise appends it. Upstream documentation states a grading condition — target signature minus source signature equals the monomial — but the upstream code never checks it, and `validate_grading` always returns true. Gap ruling 3 is to mirror the code: `pmat_validate_grading` returns `1`, and insertion performs domain checks only. The stated condition is recorded as a possible future upgrade, not as a property of this core.

### 4.2 Conservation (property 29)

The conservation law says that the component-wise sum of all entry monomials equals the accumulated signature:

$$
\sum_{e \in M} \left(\delta_{\mathrm{src}}(e),\ \delta_{\mathrm{tgt}}(e)\right) = \left(\Sigma_{\mathrm{src}},\ \Sigma_{\mathrm{tgt}}\right).
$$

The upstream test inserts monomials $(3,5)$, $(1,2)$, $(2,1)$ and expects $(6,8)$; the harness reproduces that case.

### 4.3 Composition (properties 30–31)

For $A$ of shape $r_A \times c_A$ and $B$ of shape $r_B \times c_B$, the composite has shape $r_A \times c_B$. For each output cell $(i,j)$ and each pair of entries $a$ in row $i$ of $A$ and $b$ in column $j$ of $B$ with matching inner index ($a.\mathrm{col} = b.\mathrm{row}$), the code accumulates

$$
\sigma \leftarrow \sigma \cdot \mathrm{sign}(a) \cdot \mathrm{sign}(b), \qquad
\delta_{\mathrm{src}} \leftarrow \delta_{\mathrm{src}} + \delta_{\mathrm{src}}(a), \qquad
\delta_{\mathrm{tgt}} \leftarrow \delta_{\mathrm{tgt}} + \delta_{\mathrm{tgt}}(b).
$$

Only the *source* grade of the left factor and the *target* grade of the right factor are accumulated. A fuller reading of the upstream prose ("sum of both signatures") would add all four; gap ruling 4 keeps the coded rule.

### 4.4 Norm (property 32)

Every entry has magnitude one, so the Frobenius norm is the square root of the entry count:

$$
\lVert M \rVert_F = \sqrt{\#\mathrm{entries}(M)} .
$$

---

## 5. The spectral governor

The governor answers one question: is a Jacobian $J \in \mathbb{R}^{n \times n}$ safely contractive with margin $\varepsilon$?

### 5.1 Gershgorin bound (properties 33–34)

For each row $i$, the Gershgorin disc has centre $J_{ii}$ and radius $R_i = \sum_{j \ne i} \lvert J_{ij} \rvert$. The bound is the farthest reach of any disc from the origin:

$$
G(J) = \max_i \left( \lvert J_{ii} \rvert + \sum_{j \ne i} \lvert J_{ij} \rvert \right).
$$

$J$ is declared contractive when $G(J) < 1 - \varepsilon$. Note that $G(J)$ is exactly the maximum absolute row sum, i.e. the operator norm of $J$ induced by $\ell_\infty$. It therefore bounds the spectral radius from above, and it is a Lipschitz constant of the linear map $x \mapsto Jx$ in the sup norm — which is why HCALC, whose metric is $\ell_\infty$, can use it directly.

### 5.2 Power iteration (properties 35–36)

Starting from the uniform unit vector, iterate $v \leftarrow Jv / \lVert Jv \rVert_2$ and track the Rayleigh quotient $\lambda \approx v^{\top} J v$. Stop when successive estimates differ by less than $10^{-12}$ or after 100 iterations, and return $\lvert \lambda \rvert$. The same predicate, $\lvert \lambda \rvert < 1 - \varepsilon$, defines contractivity.

### 5.3 Fallback policy (property 37)

`spectral_analyze` tries Gershgorin first. If Gershgorin reports contractive *and* the bound lies within five percent of the margin, $G(J) > 0.95\,(1 - \varepsilon)$, the result is recomputed by power iteration. The returned record (`SpectralResult`) carries the spectral-radius estimate, the verdict, both bounds, and a flag saying whether power iteration was used.

### 5.4 Reference cases (property 38)

The upstream tests use $\varepsilon = 0.1$, so the margin is $0.9$:

```math
J_1 = \begin{bmatrix} 0.2 & 0.1 \\ 0.05 & 0.15 \end{bmatrix}, \qquad
J_2 = \begin{bmatrix} 0.9 & 0.3 \\ 0.3 & 0.95 \end{bmatrix}.
```

For $J_1$ the row sums are $0.3$ and $0.2$, so $G(J_1) = 0.3 < 0.9$: contractive. For $J_2$ they are $1.2$ and $1.25$, so $G(J_2) = 1.25$: not contractive. The harness reproduces both verdicts as the named tests `spectral_contractive` and `spectral_expansive`.

---

## 6. The Banach recurrence

### 6.1 The step (properties 39–40)

$$
x_{t+1} = \Xi_t \cdot x_t + \Lambda_t \cdot T(x_t) + g_t .
$$

The contraction condition is

$$
q_t = \lVert \Xi_t \rVert + \lVert \Lambda_t \rVert \cdot \lVert T \rVert < 1 - \varepsilon ,
$$

and when it holds uniformly the map is a strict contraction, so Banach's theorem gives a unique fixed point (property 41). That last statement is upstream narrative — the code checks $q_t$ at each step but does not prove the theorem — so the harness records property 41 as SKIP rather than claiming it.

### 6.2 How $q$ is estimated in the step (property 42)

As coded, $q$ is an inexpensive, state-dependent estimate:

$$
q = n_{\Xi} + n_{\Lambda} \cdot n_T, \qquad
n_{\Xi} = \max_i \lvert \Xi_i \rvert, \quad
n_{\Lambda} = \max_i \lvert \Lambda_i \rvert, \quad
n_T = \frac{\lVert T(x) \rVert_\infty}{\lVert x \rVert_\infty},
$$

where the division in $n_T$ is skipped when $\lVert x \rVert_\infty \le 10^{-15}$.

### 6.3 Soft projection (property 43)

If $q > 1 - \varepsilon$, both weight vectors are rescaled before the update:

$$
(\Xi, \Lambda) \leftarrow \frac{1 - \varepsilon}{q} \cdot (\Xi, \Lambda),
$$

and $q$ is re-estimated. The `StepInfo` record notes that a projection occurred. This is the operation HCALC's in-step governor is a cousin of; the difference is that `soft_project` scales the *schedules*, not the state.

### 6.4 Weight synthesis (property 44)

`synth_weights` builds per-step schedules from a tier and a profile. With $q^{\star} = 1 - \varepsilon_{\mathrm{tier}}$ and a profile factor $f_t$,

$$
\xi_t = 0.7\, q^{\star} f_t, \qquad \lambda_t = 0.3\, q^{\star} f_t,
$$

where $f_t = 1$ (Uniform), $f_t = 1/(t+1)$ (Harmonic), or $f_t = 1/\ln(t+2)$ (LogDecay). As coded, each schedule row has length two and component $i$ reads entry $\min(i, 1)$; the $\Xi$ row is $(\xi_t, 0)$ and the $\Lambda$ row is $(0, \lambda_t)$. The 70/30 split makes $\xi_t + \lambda_t = q^{\star} f_t$, so with $n_T \le 1$ the step estimate of §6.2 satisfies $q \le q^{\star} f_t$. For the Uniform and Harmonic profiles $f_t \le 1$ and the schedule starts inside the margin; LogDecay begins at $f_0 = 1/\ln 2 \approx 1.44$, and its early steps rely on the soft projection of §6.3.

### 6.5 Projector and residual (properties 45–46)

After the affine update, an optional projector hook is applied (the upstream test clips to $[-1, 1]$; the default in `rec_run` is the identity verb). The residual is the Euclidean step length,

$$
r_t = \lVert x_{t+1} - x_t \rVert_2 ,
$$

and `rec_run` stops when $r_t$ falls below the tolerance (default $10^{-6}$) or the step cap (default 200) is reached. It returns the list of per-step `StepInfo` records and sets `REC_STATE` to the final state, the convergence flag, and the history.

---

## 7. Emission, CSL, and certificate arithmetic

The upstream gate and certification layers contain a few scalar formulas that consume the recurrence's outputs. They are mathematics, not orchestration, so they are recreated and tested (properties 48–54):

- **Emission policies** (`emit_apply`): pass-through; *suppress* (emit zeros if $q \ge 1 - \varepsilon$); *hold* (emit the previous output under the same condition); and *attenuate*, which multiplies the output by $\max(0, 1 - \varepsilon - q)$.
- **CSL neutrality**: fail if some pair with $\lvert x_i - x_j \rvert > 10^{-15}$ has $\lvert T_i - T_j \rvert / \lvert x_i - x_j \rvert > 1 + \varepsilon$.
- **CSL beneficence**: require $\lVert T(x) \rVert_2 \le (1 + \varepsilon) \lVert x \rVert_2$ and residual at most $(1 + \varepsilon) \lVert x \rVert_2$.
- **CSL commutation**: require $\lVert \mathrm{filter}(T(x)) - T(\mathrm{filter}(x)) \rVert_\infty \le \varepsilon$.
- **Certificate arithmetic** (`ace_certify` over a `StepInfo` history): with $q_{\max}$ the largest step estimate,

$$
\mathrm{margin} = (1 - \varepsilon) - q_{\max}, \qquad
\mathrm{tail} = \frac{r_{\max}}{1 - q_{\max}} \ \ (q_{\max} < 1), \qquad
\mathrm{certified} \iff \mathrm{margin} \ge \delta ,
$$

and the tail bound is $+\infty$ when $q_{\max} \ge 1$.

The tail bound is the standard a-posteriori Banach estimate: if each step contracts by at most $q_{\max}$, the remaining distance to the fixed point is bounded by the last step length divided by $1 - q_{\max}$.

What is *not* recreated is the machinery those formulas sit inside: seal chains, multi-party locks, guardians, and consensus. Their properties (47, 55, 56) are recorded in the inventory and skipped by the harness.

---

## 8. Repository layout, API, and verification

### 8.1 Layout

```
foundry-j/
  LICENSE                GNU AGPL v3
  README.md              this document
  spec/
    PROPERTIES.md        56 numbered properties with source citations
    J_API.md             nouns, verbs, ranks, record field orders
    GAP_DECISIONS.md     rulings where upstream prose and code disagree
    COVERAGE_MATRIX.md   property-to-harness coverage at an earlier commit
    HCALC_CROSSLINKS.md  Foundry properties relevant to HCALC
    HCALC_PRODUCTION_REVIEW.md   review of HCALC PRODUCTION.md
    LICENSE_NOTE.txt
  j/
    foundry.ijs          loader: types, goldilocks, pmat, spectral,
                         recurrence, gate, certify; foundry_export
    types.ijs            constants, tiers, enums
    goldilocks.ijs       field arithmetic
    pmat.ijs             prime monomial matrices
    spectral.ijs         Gershgorin, power iteration, analyze
    recurrence.ijs       synth_weights, soft_project, q_estimate,
                         rec_step, rec_run
    gate.ijs             emission and CSL checks
    certify.ijs          certificate arithmetic
    BOXING.md            record boxing contracts
  verify/
    run.sh, run.ijs, harness.ijs
    tests/               goldilocks, constants, pmat, spectral,
                         recurrence, emit_csl_ace
    PROPERTY_MAP.md      property-to-harness map
    INVENTORY.md         named tests and coverage files
    logs/                timestamped runs
  docs/images/           harness screenshot
```

### 8.2 Using the core

```j
load 'j/foundry.ijs'      NB. verbs live in locale foundry
foundry_export ''         NB. optional: copy the public names into base

42 fp_mul fp_inv 42       NB. 1
P64                       NB. 2 3 5 ... 311
tier_eps T2               NB. 0.05
```

Records follow `j/BOXING.md`. The three that matter most:

| Record | Fields, in order |
|---|---|
| `StepInfo` | step, q, epsilon, n_xi, n_lam, projected, residual |
| `SpectralResult` | spectral_radius, contractive, gershgorin_bound, power_iter_bound, used_power_iteration |
| `AceCert` | lipschitz_upper, safety_margin, tail_bound, certified |

`rec_step` returns `x_next ; <StepInfo>`, always of length two, so a caller can unpack it without worrying about J's link operator splicing record fields into the outer list.

### 8.3 Running the harness

Requires J with `jconsole`. The wrapper defaults to `/home/box/j/j9.7/bin/jconsole`; set `JCONSOLE` to override.

```bash
cd verify
./run.sh                  # writes logs/run-YYYYMMDD-HHMMSS.log
# or directly:
jconsole verify/run.ijs
```

Each line is `PASS name`, `FAIL name: reason`, `SKIP name: reason`, or `BLOCKED name: missing …`. The harness exits non-zero on any failure.

---

## 9. Measured results

Source: [`verify/logs/run-20261007-080122.log`](verify/logs/run-20261007-080122.log), J 9.7.1, stamped 2026-10-07 08:01:22 PDT.

```
PASS=61 FAIL=0 SKIP=4 BLOCKED=0
exit_code=0
```

| Section | Checks in log | PASS | SKIP |
|---|---|---|---|
| goldilocks | 4 named tests + properties 1–18 | 22 | 0 |
| constants | properties 19–25 | 7 | 0 |
| pmat | 2 named tests + properties 26–32 | 9 | 0 |
| spectral | 2 named tests + properties 33–38 | 8 | 0 |
| recurrence | 1 named test + properties 39–46 | 8 | 1 (property 41) |
| emit / CSL / ACE | properties 47–56 | 7 | 3 (properties 47, 55, 56) |
| **total** | 9 named tests + 56 properties | **61** | **4** |

The skips and their logged reasons:

| Property | Reason in log |
|---|---|
| 41 | narrative-only Banach guarantee |
| 47 | WORM/seal chain / triple-lock theater out of harness scope |
| 55 | no Core guardian verb (gate theater out of harness scope) |
| 56 | narrative-only consensus / $2^{-256}$ bound |

### How the count got here

The logs directory keeps the earlier runs, and the history is informative:

- The first runs (06:12–06:18 PT) exercised only the nine named tests. After initial load and wiring errors were cleared, Fermat inversion failed in three consecutive runs, with `42 * fp_inv 42` returning `11152786313141180820` instead of 1. Once the field core was corrected, the named tests reached 9/9 (`run-20261007-061853.log`).
- The run at 07:59 PT (`run-20261007-075943.log`) was the first to cover all 56 properties and reported `PASS=59 FAIL=2 SKIP=4`. The failures were property 49 (attenuation scale) and property 50 (CSL neutrality), both caused by J's right-to-left evaluation order in expressions transcribed from C++.
- Those two were fixed (commit `f8ab694`), and the run at 08:01 PT is the current result.

`verify/PROPERTY_MAP.md` and `spec/COVERAGE_MATRIX.md` cite earlier logs in places; the log above is the authoritative current measurement.

---

## 10. Relationship to sibling repositories

### HCALC

[HCALC](https://github.com/AHMADALIPARR/hcalc) defines a *nested* recurrence,

$$
X_{t+1} = \Xi\left(t,\ \Lambda_m \cdot C\left(T_p(X_t)\right)\right),
$$

on $\mathbb{R}^n$ with a prime-weighted diagonal transform built from $P_{64}$. Its core loads this repository and cites exactly two things: the list `P64` and the estimator `spectral_analyze`. It does not call `soft_project` or `rec_step`.

The two recurrences are related by an explicit parameter table that HCALC calls `InstanceBridge` ($T := C \circ T_p$, $\Lambda := \Lambda_m \cdot \mathbf{1}$, $\Xi := \xi_t$). Under that table, the additive step of §6.1 evaluated on HCALC inputs differs from HCALC's nested step by the drift term $\xi_t \cdot x$, so the two are distinct maps. The Foundry J review of HCALC's production specification, kept in [`spec/HCALC_PRODUCTION_REVIEW.md`](spec/HCALC_PRODUCTION_REVIEW.md), accepts the bridge as a non-identity morphism and rejects any reading of HCALC's step as property 39. In particular:

- HCALC's state-level governor reuses the scale factor $(1 - \varepsilon)/q$ of property 43 but is not property 43;
- HCALC's weight law $\alpha_j = 1/(1 + \ln p_{j \bmod 64})$ is HCALC's own definition, not a Foundry property;
- HCALC's residual uses $\ell_\infty$, whereas property 46 uses $\ell_2$.

A passing foundry-j harness therefore says nothing about HCALC beyond the correctness of the two cited hooks.

### sedona-k

[sedona-k](https://github.com/AHMADALIPARR/sedona-k) takes the Goldilocks prime, the fold constant, and $P_{64}$ from `j/types.ijs` and computes Riemann-gas thermodynamics over $P_{64}$ in ngn/k. It uses no field arithmetic, PMAT, governor, or recurrence.

### david

[david](https://github.com/AHMADALIPARR/david) is an unrelated product (sparse agent routing in J, PostgreSQL/pgvector, and Prolog). It shares the J toolchain and nothing else.

---

## 11. Out of scope

- The upstream orchestration layers: SHA-256 audit and seal chains, multi-party locks, guardians, publishers, consensus, and their certificates as system objects.
- The bytecode linker associated with `PIRTM_MAGIC` (the constant is recorded; the linker is not recreated).
- Hardware and hardware-verification trees in the upstream project.
- Barrett reduction (upstream defines a constant for it and never uses it; gap ruling 2).
- Enforcement of the stated PMAT grading condition (gap ruling 3).
- A Lean or Alloy formalization of these cores. foundry-j is executable and tested, not proved.
- Continuous-integration workflows. The harness is run locally and its logs are committed.

Upstream reference (not shipped here): <https://github.com/SNAPKITTYWEST/SNAPKITTYWEST/tree/main/cpp-foundry>.

---

## 12. Demo

![Foundry J verify harness](docs/images/foundry-j-verify.png)

---

## 13. License

Copyright © 2026 Foundry J contributors.

This repository is distributed under the GNU Affero General Public License, **version 3 only** — see [`LICENSE`](LICENSE). SPDX identifier: `AGPL-3.0-only`.

Some file headers inherited from earlier drafts (for example under `verify/` and parts of `spec/` and `j/`) still carry `AGPL-3.0-or-later` tags or "version 3 or later" wording; they have not yet been aligned with the repository-level choice stated here.
