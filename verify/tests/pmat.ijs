NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Props primary: 27, 29.

run_pmat =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'pmat_insert'
    r blocked 'pmat_conservation'
    '' return.
  end.

  NB. prop 27 — insert two entries, count == 2
  try.
    m =. 3 pmat_new 3
    'm ok1' =. m pmat_insert 0 0 1 1 1
    'm ok2' =. m pmat_insert 0 1 _1 0 1
    c =. # pmat_entries m
    if. ok1 *. ok2 *. c = 2 do. pass 'pmat_insert'
    else. (('ok1=' , (": ok1) , ' ok2=' , (": ok2) , ' count=' , ": c)) fail 'pmat_insert' end.
  catch. (13!:12 '') fail 'pmat_insert' end.

  NB. prop 29 — conservation 6 8
  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 0 1 3 5
    'm ok' =. m pmat_insert 0 1 _1 1 2
    'm ok' =. m pmat_insert 1 0 1 2 1
    cons =. pmat_conservation m
    if. cons -: 6 8 do. pass 'pmat_conservation'
    else. (('expected 6 8 got ' , ": cons)) fail 'pmat_conservation' end.
  catch. (13!:12 '') fail 'pmat_conservation' end.
  ''
)

run_pmat ''
