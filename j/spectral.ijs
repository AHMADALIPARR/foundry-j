NB. =============================================================================
NB. Foundry F1 — Spectral Governor (PURE J)
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
NB. Contract: spec/J_API.md § Spectral; PROPERTIES §F (33–38); j/BOXING.md.
NB. Jacobian = n×n real matrix.
NB. SpectralResult open fields:
NB.   spectral_radius ; contractive ; gershgorin_bound ;
NB.   power_iter_bound ; used_power_iteration
NB. Producers return <SpectralResult> (one outer box) — see BOXING.md.
NB.
NB. Verbs: gershgorin_bound gershgorin_check power_iteration
NB.        power_iteration_check spectral_analyze

cocurrent 'foundry'

NB. gershgorin_bound J (PROPERTIES 33)
gershgorin_bound =: 3 : 0
  J =. y
  n =. # J
  if. 0 = n do. 0 return. end.
  bounds =. 0 $ 0.
  for_i. i. n do.
    row =. i { J
    diag =. | i { row
    off  =. +/ | (i ~: i. n) # row
    bounds =. bounds , diag + off
  end.
  >./ bounds
)

NB. J gershgorin_check epsilon — contractive iff bound < 1-ε (PROPERTIES 34)
NB. Returns <SpectralResult>
gershgorin_check =: 4 : 0
  bound =. gershgorin_bound x
  contractive =. bound < (1 - y)
  < bound ; contractive ; bound ; bound ; 0
)

NB. J power_iteration (max_iters , tol)
NB. Defaults: max_iters=100, tol=1e_12 (PROPERTIES 35)
power_iteration =: 4 : 0
  J =. x
  'max_iters tol' =. 2 {. (,y) , 100 1e_12
  n =. # J
  if. 0 = n do. 0 return. end.
  v =. n $ %: % n
  eigenvalue =. 0.
  for_iter. i. max_iters do.
    Jv =. J +/ . * v
    new_ev =. v +/ . * Jv
    if. tol > | new_ev - eigenvalue do. | new_ev return. end.
    eigenvalue =. new_ev
    norm =. %: Jv +/ . * Jv
    if. norm < 1e_15 do. break. end.
    v =. Jv % norm
  end.
  | eigenvalue
)

NB. J power_iteration_check (epsilon , max_iters) (PROPERTIES 36)
NB. Returns <SpectralResult>
power_iteration_check =: 4 : 0
  'eps max_iters' =. 2 {. (,y) , 0.1 100
  bound =. x power_iteration max_iters , 1e_12
  gersho =. gershgorin_bound x
  contractive =. bound < (1 - eps)
  < bound ; contractive ; gersho ; bound ; 1
)

NB. J spectral_analyze epsilon (PROPERTIES 37)
NB. Gershgorin first; if contractive but bound > 0.95*(1-ε), power-iterate
NB. Returns <SpectralResult>
spectral_analyze =: 4 : 0
  result =. > x gershgorin_check y
  'sr c gersh pi used' =. result
  if. c *. (gersh > 0.95 * 1 - y) do.
    result =. > x power_iteration_check y , 100
  end.
  < result
)

NB. SpectralResult accessors — accept <SpectralResult> (L.>1) or open fields
sr_open        =: >
sr_fields      =: 3 : 'if. 1 < L. y do. > y else. y end.'
sr_radius      =: 0 {:: sr_fields
sr_contractive =: 1 {:: sr_fields
sr_gersh       =: 2 {:: sr_fields
sr_power       =: 3 {:: sr_fields
sr_used_pi     =: 4 {:: sr_fields

cocurrent 'base'
