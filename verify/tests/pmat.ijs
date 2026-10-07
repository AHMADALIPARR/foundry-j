NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Named tests + PMAT props 26–32.

run_pmat =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'pmat_insert'
    r blocked 'pmat_conservation'
    '' return.
  end.

  NB. ── named tests ─────────────────────────────────────────────────────────
  try.
    m =. 3 pmat_new 3
    'm ok1' =. m pmat_insert 0 0 1 1 1
    'm ok2' =. m pmat_insert 0 1 _1 0 1
    c =. # pmat_entries m
    if. ok1 *. ok2 *. c = 2 do. pass 'pmat_insert'
    else. (('ok1=' , (": ok1) , ' ok2=' , (": ok2) , ' count=' , ": c)) fail 'pmat_insert' end.
  catch. (13!:12 '') fail 'pmat_insert' end.

  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 0 1 3 5
    'm ok' =. m pmat_insert 0 1 _1 1 2
    'm ok' =. m pmat_insert 1 0 1 2 1
    cons =. pmat_conservation m
    if. cons -: 6 8 do. pass 'pmat_conservation'
    else. (('expected 6 8 got ' , ": cons)) fail 'pmat_conservation' end.
  catch. (13!:12 '') fail 'pmat_conservation' end.

  NB. ── prop_26 PMat entry shape (sign, monomial ds/dt, row, col) ────────────
  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 1 _1 3 4
    e =. {. pmat_entries m
    NB. entry row: sign, ds, dt, row, col
    if. ok *. (e -: _1 3 4 0 1) do. pass 'prop_26'
    else. (('entry=' , ": e)) fail 'prop_26' end.
  catch. (13!:12 '') fail 'prop_26' end.

  NB. ── prop_27 insert domain checks ────────────────────────────────────────
  try.
    m =. 2 pmat_new 2
    'm1 ok_bad_row' =. m pmat_insert 5 0 1 0 0
    'm2 ok_bad_sign' =. m pmat_insert 0 0 2 0 0
    'm3 ok_good' =. m pmat_insert 0 0 1 1 1
    if. (-. ok_bad_row) *. (-. ok_bad_sign) *. ok_good do. pass 'prop_27'
    else. 'domain checks wrong' fail 'prop_27' end.
  catch. (13!:12 '') fail 'prop_27' end.

  NB. ── prop_28 grading stub (mirrors C++ always-true) ───────────────────────
  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 0 1 1 1
    if. 1 = pmat_validate_grading m do. pass 'prop_28'
    else. 'validate_grading not 1' fail 'prop_28' end.
  catch. (13!:12 '') fail 'prop_28' end.

  NB. ── prop_29 conservation ────────────────────────────────────────────────
  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 0 1 3 5
    'm ok' =. m pmat_insert 0 1 _1 1 2
    'm ok' =. m pmat_insert 1 0 1 2 1
    if. (pmat_conservation m) -: 6 8 do. pass 'prop_29'
    else. 'conservation != 6 8' fail 'prop_29' end.
  catch. (13!:12 '') fail 'prop_29' end.

  NB. ── prop_30 compose preserves shape (rows_A × cols_B) ───────────────────
  try.
    a =. 2 pmat_new 3
    'a ok' =. a pmat_insert 0 1 1 1 0
    b =. 3 pmat_new 2
    'b ok' =. b pmat_insert 1 0 1 0 2
    c =. a pmat_compose b
    if. (pmat_shape c) -: 2 2 do. pass 'prop_30'
    else. (('shape=' , ": pmat_shape c)) fail 'prop_30' end.
  catch. (13!:12 '') fail 'prop_30' end.

  NB. ── prop_31 compose monomial rule (ds+=a.ds, dt+=b.dt; sign*=) ──────────
  try.
    a =. 1 pmat_new 1
    'a ok' =. a pmat_insert 0 0 1 5 0
    b =. 1 pmat_new 1
    'b ok' =. b pmat_insert 0 0 _1 0 7
    c =. a pmat_compose b
    e =. {. pmat_entries c
    NB. sign = 1*_1 = -1; ds=5; dt=7; row=0; col=0
    if. e -: _1 5 7 0 0 do. pass 'prop_31'
    else. (('compose entry=' , ": e)) fail 'prop_31' end.
  catch. (13!:12 '') fail 'prop_31' end.

  NB. ── prop_32 Frobenius = sqrt(#entries) ──────────────────────────────────
  try.
    m =. 2 pmat_new 2
    'm ok' =. m pmat_insert 0 0 1 1 1
    'm ok' =. m pmat_insert 0 1 1 2 3
    f =. pmat_frobenius m
    if. 1e_9 > | f - %: 2 do. pass 'prop_32'
    else. (('frobenius=' , ": f)) fail 'prop_32' end.
  catch. (13!:12 '') fail 'prop_32' end.
  ''
)

run_pmat ''
