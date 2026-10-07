NB. =============================================================================
NB. Foundry F1 — Goldilocks F_p arithmetic (PURE J)
NB. Copyright (C) 2026 Foundry / Prime Materia Commons
NB.
NB. This program is free software: you can redistribute it and/or modify
NB. it under the terms of the GNU Affero General Public License as published
NB. by the Free Software Foundation, either version 3 of the License, or
NB. (at your option) any later version.
NB.
NB. This program is distributed in the hope that it will be useful,
NB. but WITHOUT ANY WARRANTY; without even the implied warranty of
NB. MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
NB. GNU Affero General Public License for more details.
NB.
NB. You should have received a copy of the GNU Affero General Public License
NB. along with this program.  If not, see <https://www.gnu.org/licenses/>.
NB. =============================================================================
NB.
NB. Contract: spec/J_API.md § Goldilocks; PROPERTIES §A–C (1–18).
NB. Carrier Fp: extended int with 0 ≤ v < p.
NB.
NB. Verbs: fp_reduce fp_add fp_sub fp_mul fp_mulmod fp_pow fp_inv
NB.        fp_add_batch fp_mul_batch

cocurrent 'foundry'

NB. fp_reduce y — single-limb: (y >= p) ? y-p : y   (PROPERTIES 12)
fp_reduce =: 3 : 0"0
  y =. x: y
  if. y >: p do. y - p else. y end.
)

NB. fp_mulmod x y — Goldilocks fold (PROPERTIES 5–11)
NB. 2^64 ≡ 2^32-1 (mod p); x ≡ lo + hi_lo*EPSILON_FOLD - hi_hi (mod p)
fp_mulmod =: 4 : 0"0
  a =. x: x
  b =. x: y
  product =. a * b
  lo    =. TWO64 | product
  hi    =. product <.@% TWO64
  hi_lo =. TWO32 | hi  NB. C++: hi & 0xFFFFFFFFull (= mod 2^32), not mod EPSILON_FOLD
  hi_hi =. hi <.@% TWO32
  folded =. lo + hi_lo * EPSILON_FOLD
  if. folded >: hi_hi do.
    reduced =. folded - hi_hi
  else.
    reduced =. folded + p - hi_hi
  end.
  if. reduced >: p do. reduced =. reduced - p end.
  reduced
)

NB. fp_add x y — (a+b) mod p (PROPERTIES 13)
fp_add =: 4 : 0"0
  r =. (x: x) + (x: y)
  if. r >: p do. r =. r - p end.
  r
)

NB. fp_sub x y — (a-b) mod p with underflow +p (PROPERTIES 14)
fp_sub =: 4 : 0"0
  r =. (x: x) - (x: y)
  if. r < 0x do. r =. r + p end.
  r
)

NB. fp_mul x y — mulmod (PROPERTIES 15)
fp_mul =: 4 : 0"0
  x fp_mulmod y
)

NB. fp_pow x y — square-and-multiply x^y mod p (PROPERTIES 17)
fp_pow =: 4 : 0
  a =. x: x
  e =. x: y
  result =. 1x
  base =. a
  while. e > 0x do.
    if. 1x = 2x | e do. result =. result fp_mul base end.
    base =. base fp_mul base
    e =. e <.@% 2x
  end.
  result
)

NB. fp_inv y — Fermat a^(p-2) (PROPERTIES 16)
fp_inv =: 3 : 0
  y fp_pow (p - 2x)
)

NB. Batch elementwise (PROPERTIES 18) — same verbs, list rank
fp_add_batch =: fp_add"0
fp_mul_batch =: fp_mul"0

cocurrent 'base'
