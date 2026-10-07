NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Named tests + recurrence props 39–46 (41 narrative SKIP).

run_recurrence =: 3 : 0
  if. -. CORE_OK do.
    ('missing ' , FOUNDRY_IJS) blocked 'recurrence_converges'
    '' return.
  end.

  try.
    cocurrent 'foundry'
    verify_T =: 3 : ', (0.5 * {. y) + 0.3'
    verify_proj =: 3 : '_1 >. 1 <. , y'
    cocurrent 'base'

    if. 0 = 4!:0 <'rec_run' do.
      'rec_run not exported' fail 'recurrence_converges'
      '' return.
    end.

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

  NB. ── prop_39 recurrence equation via rec_step ────────────────────────────
  try.
    cocurrent 'foundry'
    verify_T =: 3 : ', 0.5 * , y'
    verify_proj =: ]
    cocurrent 'base'
    xi =. 0.5 0
    lam =. 0 0.3
    g =. 0.1 0
    x0 =. 1 1
    pair =. x0 rec_step xi ; lam ; g ; (<'verify_T') ; (<'verify_proj') ; 0 ; T1
    xn =. , > 0 { pair
    NB. x'[i] = xi[i]*x[i] + lam[i]*T(x)[i] + g[i]; T=0.5*x
    NB. i0: 0.5*1 + 0*0.5 + 0.1 = 0.6
    NB. i1: 0*1 + 0.3*0.5 + 0 = 0.15
    expect =. 0.6 0.15
    if. 1e_9 > >./ | xn - expect do. pass 'prop_39'
    else. (('x_next=' , ": xn)) fail 'prop_39' end.
  catch. (13!:12 '') fail 'prop_39' end.

  NB. ── prop_40 contraction condition q < 1-ε after soft project ────────────
  try.
    cocurrent 'foundry'
    verify_T =: 3 : ', 0.5 * , y'
    verify_proj =: ]
    cocurrent 'base'
    pair =. (, 1.) rec_step (0.5 0) ; (0 0.2) ; (0) ; (<'verify_T') ; (<'verify_proj') ; 0 ; T1
    info =. > 1 { pair
    q =. > 1 { info
    eps =. > 2 { info
    if. q < 1 - eps do. pass 'prop_40'
    else. (('q=' , (": q) , ' eps=' , ": eps)) fail 'prop_40' end.
  catch. (13!:12 '') fail 'prop_40' end.

  NB. ── prop_41 unique fixed-point guarantee (narrative) ────────────────────
  'narrative-only Banach guarantee' skip 'prop_41'

  NB. ── prop_42 q_estimate coded form ───────────────────────────────────────
  try.
    q =. q_estimate (0.5 0) ; (0 0.2) ; (1 1) ; (0.5 0.5)
    NB. n_xi=0.5, n_lam=0.2, n_T=0.5/1=0.5 → q=0.5+0.2*0.5=0.6
    if. 1e_9 > | q - 0.6 do. pass 'prop_42'
    else. (('q=' , ": q)) fail 'prop_42' end.
  catch. (13!:12 '') fail 'prop_42' end.

  NB. ── prop_43 soft projection ─────────────────────────────────────────────
  try.
    sp =. ((0.9 0) ; (0 0.9)) soft_project 1.2 0.1
    xi =. , > 0 { sp
    lam =. , > 1 { sp
    NB. target=0.9; scale=0.9/1.2=0.75 → 0.675
    if. (1e_9 > | (0 { xi) - 0.675) *. (1e_9 > | (1 { lam) - 0.675) do. pass 'prop_43'
    else. (('xi=' , (": xi) , ' lam=' , ": lam)) fail 'prop_43' end.
  catch. (13!:12 '') fail 'prop_43' end.

  NB. ── prop_44 weight budget split 0.7/0.3 of q_star ───────────────────────
  try.
    sched =. synth_weights 1 ; T1 ; WP_UNIFORM
    xi =. {. > 0 { sched
    lam =. {. > 1 { sched
    q_star =. 1 - 0.10
    expect_xi =. q_star * 0.7
    expect_lam =. q_star * 0.3
    if. (1e_9 > | (0 { xi) - expect_xi) *. (1e_9 > | (1 { lam) - expect_lam) do. pass 'prop_44'
    else. (('xi=' , (": xi) , ' lam=' , ": lam)) fail 'prop_44' end.
  catch. (13!:12 '') fail 'prop_44' end.

  NB. ── prop_45 projector clip [-1,1] ───────────────────────────────────────
  try.
    cocurrent 'foundry'
    verify_T =: ]
    verify_proj =: 3 : '_1 >. 1 <. , y'
    cocurrent 'base'
    NB. xi=1 carries x=5 through affine update; projector clips to 1
    pair =. (, 5.) rec_step (1 0) ; (0 0) ; (0) ; (<'verify_T') ; (<'verify_proj') ; 0 ; T1
    xn =. , > 0 { pair
    if. xn = 1 do. pass 'prop_45'
    else. (('projected=' , ": xn)) fail 'prop_45' end.
  catch. (13!:12 '') fail 'prop_45' end.

  NB. ── prop_46 residual / convergence ──────────────────────────────────────
  try.
    hist =. (, 1.) rec_run 200 ; T1 ; WP_UNIFORM ; 1e_6 ; (<'verify_T') ; (<'verify_proj')
    st =. REC_STATE_foundry_
    conv =. > 1 { st
    resid =. 99.
    if. 0 < # hist do. resid =. > 6 { > {: hist end.
    if. conv *. resid < 1e_6 do. pass 'prop_46'
    else. (('conv=' , (": conv) , ' resid=' , ": resid)) fail 'prop_46' end.
  catch. (13!:12 '') fail 'prop_46' end.
  ''
)

run_recurrence ''
