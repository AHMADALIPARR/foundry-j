NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Emission / CSL / Ace props 48–54; SKIP 47,55,56.

run_emit_csl_ace =: 3 : 0
  if. -. CORE_OK do.
    ('missing ' , FOUNDRY_IJS) blocked 'prop_48'
    '' return.
  end.

  NB. ── prop_47 WORM / seal chain (system-level theater) ─────────────────────
  'WORM/seal chain / triple-lock theater out of harness scope' skip 'prop_47'

  NB. ── prop_48 Emission Suppress ───────────────────────────────────────────
  try.
    z =. (1 2 3) emit_apply (0 0 0) ; 0.95 ; GP_SUPPRESS ; 0.1
    p =. (1 2 3) emit_apply (0 0 0) ; 0.5 ; GP_SUPPRESS ; 0.1
    if. (z -: 0 0 0) *. (p -: 1 2 3) do. pass 'prop_48'
    else. (('suppress z=' , (": z) , ' p=' , ": p)) fail 'prop_48' end.
  catch. (13!:12 '') fail 'prop_48' end.

  NB. ── prop_49 Emission Attenuate scale max(0,1-ε-q) ────────────────────────
  try.
    NB. Spec: scale = max(0, (1-ε)-q); q=0.5 eps=0.1 → 0.4
    NB. Core emit_apply uses J RTL `1 - eps - q` (=1.4 here) — mismatch → FAIL if so
    out =. (1 2 3) emit_apply (0 0 0) ; 0.5 ; GP_ATTENUATE ; 0.1
    expect =. 0.4 * 1 2 3
    if. 1e_9 > >./ | out - expect do. pass 'prop_49'
    else. (('Spec expect 0.4*out; Core got ' , ": out)) fail 'prop_49' end.
  catch. (13!:12 '') fail 'prop_49' end.

  NB. ── prop_50 CSL neutrality ──────────────────────────────────────────────
  try.
    NB. identity-ish: Tx = 0.5 * x → Lip 0.5 < 1+ε
    v =. (1 2 3) csl_neutrality ((0.5 1 1.5) ; 0.1)
    if. v = CSL_PASS do. pass 'prop_50'
    else. (('neutrality=' , ": v)) fail 'prop_50' end.
  catch. (13!:12 '') fail 'prop_50' end.

  NB. ── prop_51 CSL beneficence ─────────────────────────────────────────────
  try.
    v =. (1 0) csl_beneficence ((0.5 0) ; 0.1 ; 0.1)
    if. v = CSL_PASS do. pass 'prop_51'
    else. (('beneficence=' , ": v)) fail 'prop_51' end.
  catch. (13!:12 '') fail 'prop_51' end.

  NB. ── prop_52 CSL commutation ─────────────────────────────────────────────
  try.
    cocurrent 'foundry'
    idT =: ]
    idF =: ]
    cocurrent 'base'
    v =. (1 2) csl_commutation ((<'idT') ; (<'idF') ; 0.1)
    if. v = CSL_PASS do. pass 'prop_52'
    else. (('commutation=' , ": v)) fail 'prop_52' end.
  catch. (13!:12 '') fail 'prop_52' end.

  NB. ── prop_53 AceCertificate safety margin ────────────────────────────────
  try.
    m =. 0.5 ace_safety_margin 0.1
    NB. (1-0.1)-0.5 = 0.4
    if. 1e_9 > | m - 0.4 do. pass 'prop_53'
    else. (('margin=' , ": m)) fail 'prop_53' end.
  catch. (13!:12 '') fail 'prop_53' end.

  NB. ── prop_54 AceCertificate tail bound ───────────────────────────────────
  try.
    t =. 1 ace_tail_bound 0.5
    inf =. 1 ace_tail_bound 1
    if. (1e_9 > | t - 2) *. (inf = _) do. pass 'prop_54'
    else. (('tail=' , (": t) , ' inf=' , ": inf)) fail 'prop_54' end.
  catch. (13!:12 '') fail 'prop_54' end.

  NB. ── prop_55 Guardian spectral legality ──────────────────────────────────
  'no Core guardian verb (gate theater out of harness scope)' skip 'prop_55'

  NB. ── prop_56 Consensus / false-positive bound (narrative) ────────────────
  'narrative-only consensus / 2^-256 bound' skip 'prop_56'
  ''
)

run_emit_csl_ace ''
