NB. =============================================================================
NB. Foundry F1 — Prime Monomial Matrix / PMAT (PURE J)
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
NB. Contract: spec/J_API.md § PMAT; PROPERTIES §E (26–32).
NB. PMat = rows ; cols ; entries
NB. entries = n×5 table: sign, delta_source, delta_target, row, col
NB. Signature = length-2 list (delta_source, delta_target)
NB.
NB. Verbs: pmat_new pmat_insert pmat_validate_grading pmat_conservation
NB.        pmat_compose pmat_frobenius
NB. Accessors: pmat_rows pmat_cols pmat_entries pmat_shape

cocurrent 'foundry'

NB. rows pmat_new cols  → empty PMat
pmat_new =: 4 : 0
  (x ; y ; (0 5 $ 0))
)

pmat_rows    =: 0 {:: ]
pmat_cols    =: 1 {:: ]
pmat_entries =: 2 {:: ]
pmat_shape   =: 3 : '(pmat_rows y) , (pmat_cols y)'

NB. m pmat_insert (row ; col ; sign ; Signature)
NB. Signature may be length-2 list or two trailing atoms ds,dt
NB. Returns (new_PMat ; ok)  ok=0 on bounds/sign failure (PROPERTIES 27)
pmat_insert =: 4 : 0
  args =. y
  if. 1 = L. args do.
    'r c s sig' =. 4 {. args , 4 $ a:
    if. 1 = L. sig do. sig =. > sig end.
    'ds dt' =. 2 {. sig , 0 0
  else.
    'r c s ds dt' =. 5 {. args , 5 $ 0
  end.
  rows =. pmat_rows x
  cols =. pmat_cols x
  ents =. pmat_entries x
  ok =. 1
  if. (r >: rows) +. (r < 0) do. ok =. 0 end.
  if. (c >: cols) +. (c < 0) do. ok =. 0 end.
  if. -. s e. _1 1 do. ok =. 0 end.
  if. ok do.
    ents =. ents , s , ds , dt , r , c
    ((rows ; cols ; ents) ; 1)
  else.
    (x ; 0)
  end.
)

NB. Mirror C++ stub: always true (PROPERTIES 28 gap — do not invent checks)
pmat_validate_grading =: 3 : '1'

NB. Σ monomials → Signature (PROPERTIES 29)
pmat_conservation =: 3 : 0
  ents =. pmat_entries y
  if. 0 = # ents do. 0 0 else. +/ 1 2 {"1 ents end.
)

NB. a pmat_compose b — sign *= ; ds += a.ds ; dt += b.dt (PROPERTIES 30–31)
pmat_compose =: 4 : 0
  a =. x
  b =. y
  rA =. pmat_rows a
  cB =. pmat_cols b
  eA =. pmat_entries a
  eB =. pmat_entries b
  if. (0 = # eA) +. (0 = # eB) do. rA pmat_new cB return. end.
  acc =. 0 5 $ 0
  for_i. i. rA do.
    for_j. i. cB do.
      sign_acc =. 1
      mon_ds =. 0
      mon_dt =. 0
      any =. 0
      arows =. eA #~ i = 3 {"1 eA
      brows =. eB #~ j = 4 {"1 eB
      for_ai. i. # arows do.
        ea =. ai { arows
        acol =. 4 { ea
        for_bi. i. # brows do.
          eb =. bi { brows
          if. acol = 3 { eb do.
            sign_acc =. sign_acc * (0 { ea) * (0 { eb)
            mon_ds =. mon_ds + 1 { ea
            mon_dt =. mon_dt + 2 { eb
            any =. 1
          end.
        end.
      end.
      if. any do.
        if. sign_acc >: 0 do. sign_acc =. 1 else. sign_acc =. _1 end.
        acc =. acc , sign_acc , mon_ds , mon_dt , i , j
      end.
    end.
  end.
  rA ; cB ; acc
)

NB. Frobenius = sqrt(#entries) (PROPERTIES 32)
pmat_frobenius =: 3 : '%: # pmat_entries y'

cocurrent 'base'
