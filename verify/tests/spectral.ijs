NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Named tests + spectral props 33–38.
NB. Core BOXING.md: SpectralResult producers return <fields>; open before indexing.

run_spectral =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'spectral_contractive'
    r blocked 'spectral_expansive'
    '' return.
  end.

  NB. Open <SpectralResult> — Core sr_open is > after foundry_export
  open =. ]
  if. 3 = 4!:0 <'sr_open' do. open =. sr_open else. open =. > end.

  Jc =. 2 2 $ 0.2 0.1 0.05 0.15
  Je =. 2 2 $ 0.9 0.3 0.3 0.95

  NB. ── named tests ─────────────────────────────────────────────────────────
  try.
    res =. open Jc spectral_analyze 0.1
    if. > 1 { res do. pass 'spectral_contractive' else. 'should be contractive' fail 'spectral_contractive' end.
  catch. (13!:12 '') fail 'spectral_contractive' end.

  try.
    res =. open Je spectral_analyze 0.1
    if. -. > 1 { res do. pass 'spectral_expansive' else. 'should not be contractive' fail 'spectral_expansive' end.
  catch. (13!:12 '') fail 'spectral_expansive' end.

  NB. ── prop_33 Gershgorin disk bound ───────────────────────────────────────
  try.
    b =. gershgorin_bound Jc
    if. 1e_9 > | b - 0.3 do. pass 'prop_33'
    else. (('bound=' , ": b)) fail 'prop_33' end.
  catch. (13!:12 '') fail 'prop_33' end.

  NB. ── prop_34 contractive via Gershgorin ──────────────────────────────────
  try.
    res =. open Jc gershgorin_check 0.1
    if. > 1 { res do. pass 'prop_34' else. 'gershgorin_check not contractive' fail 'prop_34' end.
  catch. (13!:12 '') fail 'prop_34' end.

  NB. ── prop_35 power iteration (Rayleigh) ──────────────────────────────────
  try.
    ev =. Jc power_iteration 100 1e_12
    if. (ev > 0) *. (ev < 0.9) do. pass 'prop_35'
    else. (('power_iteration=' , ": ev)) fail 'prop_35' end.
  catch. (13!:12 '') fail 'prop_35' end.

  NB. ── prop_36 power_iteration_check contractive predicate ─────────────────
  try.
    res =. open Jc power_iteration_check 0.1 100
    if. > 1 { res do. pass 'prop_36' else. 'PI check not contractive' fail 'prop_36' end.
  catch. (13!:12 '') fail 'prop_36' end.

  NB. ── prop_37 analyze fallback policy (Gershgorin then optional PI) ───────
  try.
    res =. open Jc spectral_analyze 0.1
    c =. > 1 { res
    used =. > 4 { res
    if. c *. (-. used) do. pass 'prop_37'
    else. (('c=' , (": c) , ' used_pi=' , ": used)) fail 'prop_37' end.
  catch. (13!:12 '') fail 'prop_37' end.

  NB. ── prop_38 tested contractive / expansive examples ─────────────────────
  try.
    okc =. > 1 { open Jc spectral_analyze 0.1
    oke =. -. > 1 { open Je spectral_analyze 0.1
    if. okc *. oke do. pass 'prop_38'
    else. 'prop_38 example matrices failed' fail 'prop_38' end.
  catch. (13!:12 '') fail 'prop_38' end.
  ''
)

run_spectral ''
