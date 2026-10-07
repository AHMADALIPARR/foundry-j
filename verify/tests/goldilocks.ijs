NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Props primary: 13,15,16,14. Requires foundry_export (fp_*).

run_goldilocks =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'goldilocks_add'
    r blocked 'goldilocks_mul'
    r blocked 'goldilocks_inv'
    r blocked 'goldilocks_sub'
    '' return.
  end.

  NB. prop 13
  try. r =. 100x fp_add 200x
    if. r = 300x do. pass 'goldilocks_add' else. (('expected 300 got ' , ": r)) fail 'goldilocks_add' end.
  catch. (13!:12 '') fail 'goldilocks_add' end.

  NB. prop 15
  try. r =. 7x fp_mul 6x
    if. r = 42x do. pass 'goldilocks_mul' else. (('expected 42 got ' , ": r)) fail 'goldilocks_mul' end.
  catch. (13!:12 '') fail 'goldilocks_mul' end.

  NB. prop 16
  try. one =. 42x fp_mul (fp_inv 42x)
    if. one = 1x do. pass 'goldilocks_inv' else. (('expected 1 got ' , ": one)) fail 'goldilocks_inv' end.
  catch. (13!:12 '') fail 'goldilocks_inv' end.

  NB. prop 14
  try. r =. 100x fp_sub 50x
    if. r = 50x do. pass 'goldilocks_sub' else. (('expected 50 got ' , ": r)) fail 'goldilocks_sub' end.
  catch. (13!:12 '') fail 'goldilocks_sub' end.
  ''
)

run_goldilocks ''
