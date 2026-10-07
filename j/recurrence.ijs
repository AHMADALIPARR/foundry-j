NB. =============================================================================
NB. Foundry F1 — Banach Contraction Recurrence (PURE J)
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
NB. Contract: spec/J_API.md § Banach recurrence; PROPERTIES §G (39–46); j/BOXING.md.
NB. Equation: x_{t+1} = Ξ_t · x_t + Λ_t · T(x_t) + g_t
NB. Constraint: q_t = ‖Ξ‖ + ‖Λ‖·‖T‖ < 1 - ε
NB.
NB. Verbs: synth_weights soft_project q_estimate residual_l2 rec_step rec_run
NB.        (tier_eps lives in types.ijs)
NB.
NB. StepInfo open fields (length 7):
NB.   step ; q ; epsilon ; n_xi ; n_lam ; projected ; residual
NB. rec_step → x_next ; <StepInfo>
NB. rec_run  → list of <StepInfo>
NB. REC_STATE → x_current ; converged ; <history>
NB. T / p_op hooks: boxed verb-name strings (or gerunds) resolved by apply_hook.

cocurrent 'foundry'

NB. x apply_hook boxed_fn — invoke rank-1→1 transform
apply_hook =: 4 : 0
  f =. > y
  if. 2 = 3!:0 f do. (f)~ x else. f `: 6 x end.
)

NB. ── synth_weights ───────────────────────────────────────────────────────────
NB. synth_weights max_steps;tier;profile;[primes]
NB. Returns xi_schedule ; lambda_schedule (length 2; numeric tables) — BOXING.md
NB. q_star=1-tier_eps; xi=q_star*factor*0.7; lam=q_star*factor*0.3 (PROPERTIES 44)
synth_weights =: 3 : 0
  y =. boxxopen y
  max_steps =. 0 ". ": > 0 { y , <200
  tier      =. 0 ". ": > 1 { y , <T1
  profile   =. 0 ". ": > 2 { y , <WP_UNIFORM
  q_star =. 1 - tier_eps tier
  xi_s =. 0 2 $ 0.
  lam_s =. 0 2 $ 0.
  for_t. i. max_steps do.
    select. profile
    case. WP_HARMONIC do. factor =. % t + 1.
    case. WP_LOGDECAY do. factor =. % ^. t + 2.
    case. do.             factor =. 1.
    end.
    xi_s  =. xi_s  , (q_star * factor * 0.7) , 0.
    lam_s =. lam_s , 0. , (q_star * factor * 0.3)
  end.
  xi_s ; lam_s
:
  synth_weights x
)

NB. ── soft_project ────────────────────────────────────────────────────────────
NB. (xi ; lam) soft_project (q ; eps)  — scale by (1-eps)/q if q>1-eps
NB. Returns xi ; lam (length 2; numeric lists) — BOXING.md
soft_project =: 4 : 0
  'xi lam' =. x
  xi =. , > xi
  lam =. , > lam
  'q eps' =. 2 {. (,y) , 0 0.1
  target =. 1 - eps
  if. q <: target do. xi ; lam
  else. scale =. target % q
        (xi * scale) ; (lam * scale)
  end.
)

NB. ── q_estimate ──────────────────────────────────────────────────────────────
NB. q_estimate xi;lam;x;Tx  (PROPERTIES 42)
q_estimate =: 3 : 0
  'xi lam xv Tx' =. y
  xi =. , > xi
  lam =. , > lam
  xv =. , > xv
  Tx =. , > Tx
  n_xi =. >./ | xi
  n_lam =. >./ | lam
  n_T =. >./ | Tx
  n_x =. >./ | xv
  if. n_x > 1e_15 do. n_T =. n_T % n_x end.
  n_xi + n_lam * n_T
)

NB. ── residual_l2 ─────────────────────────────────────────────────────────────
NB. x_next residual_l2 x_t → ‖x'-x‖_2
residual_l2 =: 4 : 0
  d =. (,x) - ,y
  %: d +/ . * d
)

NB. weight at component i (C++: xi[min(i,1)])
wt_at =: 4 : '((y <. 1) { , x)'

NB. ── rec_step ────────────────────────────────────────────────────────────────
NB. x_t rec_step xi;lam;g;T_hook;p_hook;[step_idx];[tier]
NB. Returns x_next ; <StepInfo>  (length 2 — BOXING.md)
rec_step =: 4 : 0
  xv =. , x
  y =. boxxopen y
  xi  =. , > 0 { y
  lam =. , > 1 { y
  g   =. , > 2 { y
  Th  =. 3 { y
  Ph  =. 4 { y
  if. 0 = # g do. g =. (# xv) $ 0. end.
  if. 5 < # y do. step_idx =. 0 ". ": > 5 { y else. step_idx =. 0 end.
  if. 6 < # y do. tier =. 0 ". ": > 6 { y else. tier =. T1 end.
  eps =. tier_eps tier
  dim =. # xv

  Tx =. xv apply_hook Th
  q =. q_estimate xi ; lam ; xv ; Tx
  projected =. 0
  xi_use =. xi
  lam_use =. lam
  if. q > 1 - eps do.
    sp =. (xi ; lam) soft_project q , eps
    xi_use =. , > 0 { sp
    lam_use =. , > 1 { sp
    q =. q_estimate xi_use ; lam_use ; xv ; Tx
    projected =. 1
  end.
  n_xi =. >./ | xi_use
  n_lam =. >./ | lam_use

  x_next =. dim $ 0.
  for_i. i. dim do.
    val =. ((xi_use wt_at i) * i { xv) + ((lam_use wt_at i) * i { Tx) + i { g
    x_next =. val i} x_next
  end.
  x_next =. x_next apply_hook Ph
  resid =. x_next residual_l2 xv
  info =. step_idx ; q ; eps ; n_xi ; n_lam ; projected ; resid
  x_next ; <info
)

NB. ── rec_run ─────────────────────────────────────────────────────────────────
NB. x0 rec_run max_steps;tier;profile;tol;T_hook;p_hook
NB. Returns list of <StepInfo> (Verify prop 46 via this history).
NB. Sets REC_STATE =: x_current ; converged ; <history>  (length 3)
rec_run =: 4 : 0
  x0 =. , x
  y =. boxxopen y
  max_steps =. 0 ". ": > 0 { y , <200
  tier      =. 0 ". ": > 1 { y , <T1
  profile   =. 0 ". ": > 2 { y , <WP_UNIFORM
  tol       =. 0 ". ": > 3 { y , <1e_6
  Th =. 4 { y , <'['
  Ph =. 5 { y , <'['
  if. 0 = max_steps do. max_steps =. 200 end.
  if. 0 = tol do. tol =. 1e_6 end.

  sched =. synth_weights max_steps ; tier ; profile
  xi_s =. > 0 { sched
  lam_s =. > 1 { sched
  g =. (# x0) $ 0.
  xc =. x0
  history =. 0 $ a:
  converged =. 0

  for_t. i. max_steps do.
    xi =. t { xi_s
    lam =. t { lam_s
    pair =. xc rec_step xi ; lam ; g ; Th ; Ph ; t ; tier
    xc =. , > 0 { pair
    info =. > 1 { pair
    history =. history , <info
    resid =. 6 {:: info
    if. resid < tol do. converged =. 1 break. end.
  end.

  REC_STATE =: xc ; converged ; <history
  history
)

rec_state_x         =: 0 {:: ]
rec_state_converged =: 1 {:: ]
rec_state_history   =: 2 {:: ]

cocurrent 'base'
