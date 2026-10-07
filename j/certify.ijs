NB. =============================================================================
NB. Foundry F1 — AceCertificate math (PURE J)
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
NB. Contract: spec/J_API.md § ace_*; PROPERTIES §H (53–54); j/BOXING.md.
NB. AceCert open fields: lipschitz_upper ; safety_margin ; tail_bound ; certified
NB. ace_certify returns <AceCert>.
NB. Verbs: ace_safety_margin ace_tail_bound ace_certify

cocurrent 'foundry'

NB. max_q ace_safety_margin epsilon → (1-ε) - max_q  (PROPERTIES 53)
ace_safety_margin =: 4 : '(1 - y) - x'

NB. tail_norm ace_tail_bound max_q → tail/(1-max_q) or _ if max_q>=1 (PROPERTIES 54)
ace_tail_bound =: 4 : 0
  if. y >: 1 do. _ else. x % 1 - y end.
)

NB. steps ace_certify delta
NB. steps = list of <StepInfo> (same packing as rec_run history)
NB. Returns <AceCert>
ace_certify =: 4 : 0
  steps =. boxxopen x
  delta =. y
  if. 0 = # steps do. < 0 ; 0 ; 0 ; 0 return. end.
  qs =. 0 $ 0.
  rs =. 0 $ 0.
  for_s. steps do.
    info =. > s
    qs =. qs , 1 {:: info
    rs =. rs , 6 {:: info
  end.
  max_q =. >./ qs
  max_resid =. >./ rs
  eps =. 2 {:: > 0 { steps
  margin =. max_q ace_safety_margin eps
  tail =. max_resid ace_tail_bound max_q
  certified =. margin >: delta
  < max_q ; margin ; tail ; certified
)

cocurrent 'base'
