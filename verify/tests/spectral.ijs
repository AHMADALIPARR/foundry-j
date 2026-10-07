NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Prop primary: 38 (+33,34,37).

run_spectral =: 3 : 0
  if. -. CORE_OK do.
    r =. 'missing ' , FOUNDRY_IJS
    r blocked 'spectral_contractive'
    r blocked 'spectral_expansive'
    '' return.
  end.

  NB. prop 38 contractive
  try.
    J =. 2 2 $ 0.2 0.1 0.05 0.15
    res =. J spectral_analyze 0.1
    c =. 1 {:: res
    if. c do. pass 'spectral_contractive' else. 'should be contractive' fail 'spectral_contractive' end.
  catch. (13!:12 '') fail 'spectral_contractive' end.

  NB. prop 38 expansive
  try.
    J =. 2 2 $ 0.9 0.3 0.3 0.95
    res =. J spectral_analyze 0.1
    c =. 1 {:: res
    if. -. c do. pass 'spectral_expansive' else. 'should not be contractive' fail 'spectral_expansive' end.
  catch. (13!:12 '') fail 'spectral_expansive' end.
  ''
)

run_spectral ''
