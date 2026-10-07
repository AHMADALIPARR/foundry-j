NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Named constants props 19–25.

run_constants =: 3 : 0
  if. -. CORE_OK do.
    ('missing ' , FOUNDRY_IJS) blocked 'prop_19'
    '' return.
  end.

  NB. prop_19 K_MAX
  try.
    if. K_MAX = 133144 do. pass 'prop_19' else. (('got ' , ": K_MAX)) fail 'prop_19' end.
  catch. (13!:12 '') fail 'prop_19' end.

  NB. prop_20 MAX_DRIFT
  try.
    if. MAX_DRIFT = 300000000000000000x do. pass 'prop_20'
    else. (('got ' , ": MAX_DRIFT)) fail 'prop_20' end.
  catch. (13!:12 '') fail 'prop_20' end.

  NB. prop_21 PIRTM_MAGIC = 0x7F504952
  try.
    if. PIRTM_MAGIC = 2135945554x do. pass 'prop_21'
    else. (('got ' , ": PIRTM_MAGIC)) fail 'prop_21' end.
  catch. (13!:12 '') fail 'prop_21' end.

  NB. prop_22 PHI
  try.
    if. 1e_12 > | PHI - 1.618033988749895 do. pass 'prop_22'
    else. (('got ' , ": PHI)) fail 'prop_22' end.
  catch. (13!:12 '') fail 'prop_22' end.

  NB. prop_23 P_64 first 64 primes
  try.
    expect =. 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311
    if. (64 = # P64) *. (P64 -: expect) *. (P_64 -: P64) do. pass 'prop_23'
    else. 'P64 mismatch' fail 'prop_23' end.
  catch. (13!:12 '') fail 'prop_23' end.

  NB. prop_24 GENESIS_HASH_SIZE (in foundry locale; not always exported)
  try.
    ghs =. GENESIS_HASH_SIZE_foundry_
    if. ghs = 32 do. pass 'prop_24' else. (('got ' , ": ghs)) fail 'prop_24' end.
  catch. (13!:12 '') fail 'prop_24' end.

  NB. prop_25 tier epsilons
  try.
    ok =. ((tier_eps 1) = 0.10) *. ((tier_eps 2) = 0.05) *. ((tier_eps 3) = 0.02) *. ((tier_eps 4) = 0.01) *. ((tier_eps 99) = 0.10)
    if. ok do. pass 'prop_25' else. 'tier_eps mismatch' fail 'prop_25' end.
  catch. (13!:12 '') fail 'prop_25' end.
  ''
)

run_constants ''
