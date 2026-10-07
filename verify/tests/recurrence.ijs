NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Props 39–46 (primary 46). Core returns (x_next ; <StepInfo>); REC_STATE in locale foundry.

run_recurrence =: 3 : 0
  if. -. CORE_OK do.
    ('missing ' , FOUNDRY_IJS) blocked 'recurrence_converges'
    '' return.
  end.

  try.
    NB. Hooks must live in foundry locale (apply_hook name lookup)
    cocurrent 'foundry'
    verify_T =: 3 : ', (0.5 * {. y) + 0.3'
    verify_proj =: 3 : '_1 >. 1 <. , y'
    cocurrent 'base'

    if. 0 = 4!:0 <'rec_run' do.
      'rec_run not exported' fail 'recurrence_converges'
      '' return.
    end.

    NB. Mirror test.cpp: T1 Uniform 200 steps tol 1e-6 x0=1
    hist =. (, 1.) rec_run 200 ; T1 ; WP_UNIFORM ; 1e_6 ; (<'verify_T') ; (<'verify_proj')
    st =. REC_STATE_foundry_
    conv =. > 1 { st
    resid =. 99.
    if. 0 < # hist do.
      last =. > {: hist
      resid =. > 6 { last
    end.

    if. conv *. resid < 1e_6 do. pass 'recurrence_converges'
    else. (('converged=' , (": conv) , ' residual=' , ": resid)) fail 'recurrence_converges' end.
  catch.
    (13!:12 '') fail 'recurrence_converges'
  end.
  ''
)

run_recurrence ''
