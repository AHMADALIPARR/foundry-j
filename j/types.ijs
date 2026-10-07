NB. =============================================================================
NB. Foundry F1 — Shared types and constants (PURE J)
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
NB. Contract: spec/J_API.md nouns + PROPERTIES.md §A,D (constants).
NB. GAP_DECISIONS: EPSILON_FOLD fold noun; BARRITT_MU omitted (no Barrett path);
NB. PHI exposed, no math consumer. Boxing: see j/BOXING.md.
NB. Locale: foundry

cocurrent 'foundry'

NB. ── Field / system constants (PROPERTIES 1–2, 6, 19–24) ─────────────────────
NB. GOLDILOCKS_PRIME = 2^64 - 2^32 + 1 = 0xFFFFFFFF00000001
GOLDILOCKS_PRIME =: 18446744069414584321x
p                =: GOLDILOCKS_PRIME
NB. Fold constant EPSILON (README) / EPSILON_FOLD (J_API): 2^32 - 1
EPSILON_FOLD     =: 4294967295x
TWO64            =: 18446744073709551616x
TWO32            =: 4294967296x

K_MAX            =: 133144
MAX_DRIFT        =: 300000000000000000x
PIRTM_MAGIC      =: 2135945554x          NB. 0x7F504952
PHI              =: 1.618033988749895
GENESIS_HASH_SIZE=: 32

NB. First 64 primes — types.h P_64 / J_API noun P64
P64 =: 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311
P_64 =: P64                              NB. C++ name alias

NB. ── Tier (PROPERTIES 25) ────────────────────────────────────────────────────
NB. Tier atoms: 1=T1 2=T2 3=T3 4=T4
T1 =: 1
T2 =: 2
T3 =: 3
T4 =: 4

NB. tier_eps / tier_epsilon — T1:0.10 T2:0.05 T3:0.02 T4:0.01; default 0.10
tier_eps =: 3 : 0
  select. y
  case. 1 do. 0.10
  case. 2 do. 0.05
  case. 3 do. 0.02
  case. 4 do. 0.01
  case. do. 0.10
  end.
)
tier_epsilon =: tier_eps

NB. Weight profile codes (WeightProfile)
WP_UNIFORM  =: 0
WP_HARMONIC =: 1
WP_LOGDECAY =: 2

NB. GatePolicy (J_API)
GP_PASSTHROUGH =: 0
GP_SUPPRESS    =: 1
GP_HOLD        =: 2
GP_ATTENUATE   =: 3

NB. CSLVerdict
CSL_PASS              =: 0
CSL_FAIL_NEUTRALITY   =: 1
CSL_FAIL_BENEFICENCE  =: 2
CSL_FAIL_COMMUTATION  =: 3

NB. Signature helpers: length-2 integer list (delta_source, delta_target)
sig_sub =: -
sig_eq  =: -:

cocurrent 'base'
