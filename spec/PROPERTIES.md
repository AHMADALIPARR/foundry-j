# Foundry F1 — Pure-J Recreation Property Inventory

Extracted from cpp-foundry sources under `/workspace/foundry-j/`.
Every claim below is required to hold in a pure-J recreation of the mathematical surface.
Citations are `file:line` or README section. **No invented numeric constants.**

Preferred license for derivative pure-J work: **AGPL-3.0** (sources do not ship a LICENSE file; this preference is inventory policy only).

---

## A. Goldilocks prime and field carrier

1. **Goldilocks prime (decimal).**  
   \( p = 2^{64} - 2^{32} + 1 = 18446744069414584321 \).  
   Cite: README.md § "Goldilocks Field F_p" (lines 209–210).

2. **Goldilocks prime (hex / named constant).**  
   `GOLDILOCKS_PRIME = 0xFFFFFFFF00000001ULL`, meaning \( 2^{64} - 2^{32} + 1 \).  
   Cite: `include/types.h:17`; README.md § "Key Constants" (line 315); `include/goldilocks.h:2,12`.

3. **Field elements are u64 reduced mod p.**  
   Carrier is unsigned 64-bit values always reduced modulo \( p \).  
   Cite: README.md § "Goldilocks Field F_p" (line 212); `include/goldilocks.h:14–18`.

4. **Elem construction reduces.**  
   `Elem(x)` stores `reduce(x)`.  
   Cite: `include/goldilocks.h:18`.

---

## B. Reduction identity and mulmod

5. **Congruence \( 2^{64} \equiv 2^{32} - 1 \pmod{p} \).**  
   Cite: README.md § "Goldilocks Field F_p" (line 214); `src/goldilocks.cpp:23`.

6. **Fold constant EPSILON.**  
   README names `EPSILON = 0xFFFFFFFF` as \( 2^{32} - 1 \) (Goldilocks fold constant). Implementation uses the same literal as `eps` / `hi_lo` mask.  
   Cite: README.md § "Key Constants" (line 320); `src/goldilocks.cpp:27,31`.

7. **128-bit product split.**  
   For \( a \cdot b \), form `__uint128_t product`, then `lo = product`, `hi = product >> 64`.  
   Cite: README.md (line 213); `src/goldilocks.cpp:20–25`.

8. **hi split into 32-bit halves.**  
   `hi_lo = hi & 0xFFFFFFFF`, `hi_hi = hi >> 32`.  
   Cite: `src/goldilocks.cpp:27–28`.

9. **Reduction identity (fold).**  
   \( x \equiv \mathrm{lo} + \mathrm{hi\_lo}\cdot(2^{32}-1) - \mathrm{hi\_hi} \pmod{p} \).  
   Cite: README.md § "Goldilocks Field F_p" (line 216); implemented as `folded = lo + hi_lo * eps` then subtract `hi_hi` with underflow handling (`src/goldilocks.cpp:30–41`).

10. **Underflow handling on fold.**  
    If `folded >= hi_hi` then `reduced = folded - hi_hi`, else `reduced = folded + P - hi_hi`.  
    Cite: `src/goldilocks.cpp:36–41`.

11. **Final conditional reduction after fold.**  
    If `reduced >= P` then `reduced -= P`; result is `uint64_t`.  
    Cite: `src/goldilocks.cpp:43–48`.

12. **Single-limb reduce.**  
    For \( x < 2^{64} \): `reduce(x) = (x >= P) ? x - P : x`.  
    Cite: `src/goldilocks.cpp:12–16`; `include/goldilocks.h:35`.

---

## C. Field operations

13. **Addition mod p.**  
    \( r = a.v + b.v \); if \( r \ge P \) then \( r -= P \). Result is in \( \mathbb{F}_p \).  
    Cite: `src/goldilocks.cpp:51–55`; asserted `100+200=300` in `src/test.cpp:33–39`.

14. **Subtraction mod p.**  
    Unsigned difference with conditional add of \( P \) on underflow (mask from high bit).  
    Cite: `src/goldilocks.cpp:57–62`; asserted `100-50=50` in `src/test.cpp:60–66`.

15. **Multiplication via mulmod.**  
    `mul(a,b) = Elem(mulmod(a.v, b.v))`.  
    Cite: `src/goldilocks.cpp:64–66`; asserted `7*6=42` in `src/test.cpp:42–48`.

16. **Fermat inverse.**  
    \( a^{-1} = a^{p-2} \pmod{p} \) via `inv(a) = pow(a, P-2)`.  
    Cite: `include/goldilocks.h:27`; `src/goldilocks.cpp:68–70`; README test legend (line 403); asserted `a * inv(a) = 1` for `a=42` in `src/test.cpp:51–57`.

17. **Binary exponentiation.**  
    `pow(a,e)`: square-and-multiply from `result=1`, `base=a`.  
    Cite: `src/goldilocks.cpp:73–81`; `include/goldilocks.h:28`.

18. **Batch add/mul.**  
    Elementwise `add` / `mul` over length-`n` arrays.  
    Cite: `include/goldilocks.h:31–32`; `src/goldilocks.cpp:84–96`.

---

## D. Named constants (non-field)

19. **K_MAX.**  
    `K_MAX = 133144` (README: max W8A8 accumulation).  
    Cite: `include/types.h:18`; README.md § "Key Constants" (line 316).

20. **MAX_DRIFT.**  
    `MAX_DRIFT = 300000000000000000ULL` (README: \( 3\times 10^{17} \), “0.3Ξ drift bound” / “0.3Ξ in wei”).  
    Cite: `include/types.h:19`; README.md § "Key Constants" (line 317).

21. **PIRTM_MAGIC.**  
    `PIRTM_MAGIC = 0x7F504952` (README: `\x7FPIR` bytecode magic).  
    Cite: `include/types.h:20`; README.md § "Key Constants" (line 318); linker test bytes `src/test.cpp:371–372`.

22. **PHI.**  
    `PHI = 1.618033988749895`.  
    Cite: `include/types.h:21`. (Sources do not state further mathematical use in the UAC/recurrence core.)

23. **P_64 — first 64 primes.**  
    Array of length 64:  
    `2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311`.  
    Cite: `include/types.h:24–30`; README.md § "Key Constants" (line 319).

24. **GENESIS_HASH_SIZE.**  
    `GENESIS_HASH_SIZE = 32`.  
    Cite: `include/types.h:22`.

25. **Tier epsilons (contraction margins).**  
    T1→0.10, T2→0.05, T3→0.02, T4→0.01; default fallback 0.10.  
    Cite: `include/types.h:34–48`.

---

## E. PMAT / prime monomial facts

26. **PMat entry shape.**  
    Sparse entry is `(sign, monomial, row, col)` with `sign ∈ {±1}` and `Signature = (delta_source, delta_target)`.  
    Cite: `include/pmat.h:10–15`; `include/types.h:103–112`.

27. **Insert domain checks.**  
    Insert fails if `row ≥ rows` or `col ≥ cols`, or if `sign ∉ {1,-1}`; else appends entry.  
    Cite: `src/pmat.cpp:11–16`; asserted in `src/test.cpp:71–77`.

28. **Grading condition (stated).**  
    Header/README narrative: grading condition `tgt_sig - src_sig = monomial` is enforced on insertion / validated globally.  
    Cite: `include/pmat.h:3,21–25`.  
    **Gap note:** `insert` does not compare signatures to row/col grades; `validate_grading` always returns `true` (`src/pmat.cpp:19–22`). J must decide whether to enforce the stated condition or mirror the current C++ stub.

29. **Conservation theorem.**  
    Product (componentwise sum) of all entry monomials equals accumulated `(Σ delta_source, Σ delta_target)`.  
    Cite: `include/pmat.h:27–28`; `src/pmat.cpp:25–33`; asserted sums `(6,8)` for monomials `{3,5}+{1,2}+{2,1}` in `src/test.cpp:80–89`.

30. **Composition preserves grading (stated).**  
    Compose multiplies signs and accumulates monomials along matching mid-indices; result size `(rows_, other.cols_)`.  
    Cite: `include/pmat.h:30–31`; `src/pmat.cpp:36–66`.

31. **Compose monomial accumulation rule (as coded).**  
    On matching `a.col == b.row`: `sign_acc *= a.sign * b.sign`; `monom_acc.delta_source += a.monomial.delta_source`; `monom_acc.delta_target += b.monomial.delta_target`.  
    Cite: `src/pmat.cpp:51–55`.

32. **Frobenius norm of PMat.**  
    Each entry has magnitude 1; \( \|M\|_F = \sqrt{\#\mathrm{entries}} \).  
    Cite: `include/pmat.h:33–34`; `src/pmat.cpp:69–74`.

---

## F. Spectral governor (Gershgorin / contractive)

33. **Gershgorin disk bound.**  
    For each row \( i \): radius \( = \sum_{j\neq i}|J_{ij}| \); disk max \( = |J_{ii}| + \mathrm{radius} \); bound = max over rows.  
    Cite: `src/spectral.cpp:10–24`; `include/spectral.h:36–37`.

34. **Contractive test (Gershgorin).**  
    `contractive ⟺ bound < (1.0 - epsilon)`.  
    Cite: `src/spectral.cpp:27–36`; `include/spectral.h:17–18`.

35. **Power iteration (Rayleigh).**  
    Iterate \( v \leftarrow Jv/\|Jv\| \); eigenvalue ≈ \( v^\top Jv \); return absolute value; default tolerance `1e-12`, default `max_iters=100`.  
    Cite: `include/spectral.h:29–30,40–41`; `src/spectral.cpp:39–86`.

36. **Contractive test (power iteration).**  
    Same predicate: dominant eigenvalue modulus \( < 1 - \epsilon \).  
    Cite: `src/spectral.cpp:88–98`.

37. **Analyze fallback policy.**  
    Try Gershgorin first; if contractive but `gershgorin_bound > (1-epsilon)*0.95`, recheck with power iteration.  
    Cite: `src/spectral.cpp:101–111`; `include/spectral.h:32–34`.

38. **Tested contractive / expansive examples.**  
    \( J=\begin{bmatrix}0.2&0.1\\0.05&0.15\end{bmatrix} \) with \( \epsilon=0.1 \) is contractive;  
    \( J=\begin{bmatrix}0.9&0.3\\0.3&0.95\end{bmatrix} \) with \( \epsilon=0.1 \) is not.  
    Cite: `src/test.cpp:94–113`.

---

## G. Banach recurrence

39. **Recurrence equation.**  
    \( x_{t+1} = \Xi_t \cdot x_t + \Lambda_t \cdot T(x_t) + g_t \).  
    Cite: README.md § "Banach Contraction Mapping" (lines 226–232); `include/recurrence.h:3`; `src/recurrence.cpp:105–110`.

40. **Contraction condition.**  
    \( q_t = \|\Xi_t\| + \|\Lambda_t\| \cdot \|T\| < 1 - \varepsilon \).  
    Cite: README.md (lines 234–235, 280); `include/recurrence.h:4`; `include/types.h:119`.

41. **Unique fixed-point guarantee (narrative).**  
    Strict Banach contraction ⇒ convergence to unique fixed point; spectral governor verifies a priori.  
    Cite: README.md § "The Core Guarantee" (lines 282–284).

42. **q estimate in step (as coded).**  
    \( n_\Xi, n_\Lambda \) = max-abs of schedule vectors (length 2); \( n_T \) = max-abs of \( T(x) \) scaled by max-abs of \( x \) when \( \|x\|_\infty > 10^{-15} \); \( q = n_\Xi + n_\Lambda \cdot n_T \).  
    Cite: `src/recurrence.cpp:66–87`.

43. **Soft projection.**  
    If \( q > 1 - \mathrm{tier\_epsilon} \), scale Ξ and Λ by \( (1-\varepsilon)/q \).  
    Cite: `include/recurrence.h:60–63`; `src/recurrence.cpp:46–55,89–102`.

44. **Weight budget split.**  
    `q_star = 1 - tier_epsilon(tier)`; `xi_val = q_star * factor * 0.7`; `lam_val = q_star * factor * 0.3`; Uniform/Harmonic/LogDecay factors as coded.  
    Cite: `src/recurrence.cpp:21–42`.

45. **Projector.**  
    After affine update, apply `p_op` (example: clip to \([-1,1]\)).  
    Cite: `include/recurrence.h:15–16`; `src/recurrence.cpp:113–114`; test projector `src/test.cpp:133–135`.

46. **Residual.**  
    \( \mathrm{residual} = \|x_{next} - x_t\|_2 \). Convergence when residual \( < \) `convergence_tol`.  
    Cite: `src/recurrence.cpp:116–122,159–161`; test tol `1e-6` in `src/test.cpp:125,139`.

47. **WORM / seal chain invariant (system-level).**  
    \( \forall k>0:\ \mathrm{hash}(\mathrm{seal}_{k-1}) = \mathrm{seal}_k.\mathrm{prev\_hash} \) (README); Triple-Lock seals chain Guardian→Examiner→Publisher.  
    Cite: README.md Layer 8 (line 130), Quick Reference (line 525); `src/test.cpp:300–324`.

---

## H. Emission / CSL / certification math (adjacent to contraction)

48. **Emission Suppress.**  
    If \( q \ge 1-\varepsilon \), emit zeros; else pass output.  
    Cite: `include/types.h:63`; `src/gate.cpp:21–25`; `src/test.cpp:145–150`.

49. **Emission Attenuate scale.**  
    Scale by \( \max(0,\ 1-\varepsilon-q) \).  
    Cite: `include/types.h:65`; `src/gate.cpp:34–40`.

50. **CSL neutrality.**  
    Pairwise: if \( |x_i-x_j|>10^{-15} \) and \( |T_i-T_j|/|x_i-x_j| > 1+\varepsilon \), fail neutrality.  
    Cite: `src/gate.cpp:50–62`; `include/gate.h:34–37`.

51. **CSL beneficence.**  
    \( \|T(x)\|_2 \le (1+\varepsilon)\|x\|_2 \) and residual \( \le (1+\varepsilon)\|x\|_2 \).  
    Cite: `src/gate.cpp:65–86`; `include/gate.h:39–42`.

52. **CSL commutation.**  
    \( \|\mathrm{filter}(T(x)) - T(\mathrm{filter}(x))\|_\infty \le \varepsilon \) (componentwise abs ≤ ε).  
    Cite: `src/gate.cpp:89–104`; `include/gate.h:44–48`.

53. **AceCertificate safety margin.**  
    `safety_margin = (1 - epsilon) - max_q`; certified iff `margin >= delta`.  
    Cite: `include/types.h:133–136`; `src/certify.cpp:44–45,35`.

54. **AceCertificate tail bound.**  
    If `max_q >= 1` then \( +\infty \); else `tail_norm / (1 - max_q)`.  
    Cite: `include/types.h:135`; `src/certify.cpp:48–50`.

55. **Guardian spectral legality.**  
    Reject if `spectral_radius >= 1.0` or non-finite next state; reject status `"PROVISIONAL"`.  
    Cite: `src/gate.cpp:159–177`; `src/test.cpp:193–201,276–284`.

56. **Consensus / false-positive bound (narrative).**  
    Every claim requires all Triple-Lock parties; \( P(\mathrm{false\ positive}) \le 2^{-256} \).  
    Cite: README.md Triple-Lock (lines 272–273), Implications (line 451).

---

## Gaps (sources silent — do not invent)

- **Named C++ identifier `EPSILON`:** named only in README Key Constants; code uses literal `0xFFFFFFFFULL` in mulmod, not a `types.h` symbol.
- **`BARRITT_MU`:** defined equal to `P` and unused (`src/goldilocks.cpp:9–10`); no Barrett algorithm steps beyond the comment.
- **PMat per-entry grading vs indices:** stated in `pmat.h:3` but not checked in `insert` / `validate_grading`.
- **Compose monomial rule vs “sum of both signatures”:** coded as `a.delta_source` + `b.delta_target` only (`src/pmat.cpp:54–55`), not full addition of both signatures from both factors.
- **PHI usage** in UAC/recurrence math: constant present; no consuming identity in the cited math cpp files.
- **Alapeno:** out of scope; left untouched (`/workspace/alapeno`).

---

## Count

**Numbered properties: 56**
