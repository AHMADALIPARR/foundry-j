NB. =============================================================================
NB. Foundry F1 — Emission Gate + CSL checks (PURE J)
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
NB. Contract: spec/J_API.md § Emission/CSL; PROPERTIES §H (48–52).
NB. Verbs: emit_apply csl_neutrality csl_beneficence csl_commutation
NB. Verdicts: CSL_PASS CSL_FAIL_NEUTRALITY CSL_FAIL_BENEFICENCE CSL_FAIL_COMMUTATION
NB. Policies: GP_PASSTHROUGH GP_SUPPRESS GP_HOLD GP_ATTENUATE  (types.ijs)

cocurrent 'foundry'

NB. ── emit_apply ──────────────────────────────────────────────────────────────
NB. out emit_apply (prev ; q ; policy ; epsilon)
NB. PassThrough: out
NB. Suppress: zeros if q >= 1-ε else out          (PROPERTIES 48)
NB. Hold: prev if q >= 1-ε else out
NB. Attenuate: out * max(0, 1-ε-q)                (PROPERTIES 49)
emit_apply =: 4 : 0
  out =. , x
  y =. boxxopen y
  prev =. , > 0 { y
  q    =. 0 ". ": > 1 { y
  pol  =. 0 ". ": > 2 { y
  eps  =. 0 ". ": > 3 { y , <0.1
  select. pol
  case. GP_PASSTHROUGH do. out
  case. GP_SUPPRESS do.
    if. q >: 1 - eps do. (# out) $ 0. else. out end.
  case. GP_HOLD do.
    if. q >: 1 - eps do. prev else. out end.
  case. GP_ATTENUATE do.
    scale =. 0 >. 1 - eps - q
    out * scale
  case. do. out
  end.
)

NB. ── csl_neutrality ──────────────────────────────────────────────────────────
NB. x csl_neutrality (Tx ; epsilon)
NB. Fail if |xi-xj|>1e_15 and |Ti-Tj|/|xi-xj| > 1+ε  (PROPERTIES 50)
csl_neutrality =: 4 : 0
  xv =. , x
  y =. boxxopen y
  Tx =. , > 0 { y
  eps =. 0 ". ": > 1 { y , <0.1
  n =. # xv
  verdict =. CSL_PASS
  for_i. i. n do.
    for_j. (i + 1) + i. 0 >. n - i - 1 do.
      dx =. | (i { xv) - j { xv
      dT =. | (i { Tx) - j { Tx
      if. (dx > 1e_15) *. ((dT % dx) > 1 + eps) do.
        verdict =. CSL_FAIL_NEUTRALITY
      end.
    end.
  end.
  verdict
)

NB. ── csl_beneficence ─────────────────────────────────────────────────────────
NB. x csl_beneficence (Tx ; residual ; epsilon)
NB. ‖T(x)‖_2 ≤ (1+ε)‖x‖_2 and residual ≤ (1+ε)‖x‖_2  (PROPERTIES 51)
csl_beneficence =: 4 : 0
  xv =. , x
  y =. boxxopen y
  Tx =. , > 0 { y
  resid =. 0 ". ": > 1 { y
  eps =. 0 ". ": > 2 { y , <0.1
  norm_x =. %: xv +/ . * xv
  norm_Tx =. %: Tx +/ . * Tx
  if. (norm_x > 1e_15) *. (norm_Tx > (1 + eps) * norm_x) do.
    CSL_FAIL_BENEFICENCE return.
  end.
  if. resid > (1 + eps) * norm_x do.
    CSL_FAIL_BENEFICENCE return.
  end.
  CSL_PASS
)

NB. ── csl_commutation ─────────────────────────────────────────────────────────
NB. x csl_commutation (T_hook ; filter_hook ; epsilon)
NB. ‖filter(T(x)) - T(filter(x))‖_∞ ≤ ε  (PROPERTIES 52)
csl_commutation =: 4 : 0
  xv =. , x
  y =. boxxopen y
  Th =. 0 { y
  Fh =. 1 { y
  eps =. 0 ". ": > 2 { y , <0.1
  Tx  =. xv apply_hook Th
  fTx =. Tx apply_hook Fh
  fx  =. xv apply_hook Fh
  Tfx =. fx apply_hook Th
  if. +./ eps < | fTx - Tfx do. CSL_FAIL_COMMUTATION else. CSL_PASS end.
)

cocurrent 'base'
