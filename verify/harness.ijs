NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. PASS/FAIL/BLOCKED helpers + Foundry Core loader (foundry.ijs + foundry_export).

cocurrent 'z'

PASS_N  =: 0
FAIL_N  =: 0
BLOCK_N =: 0
CORE_OK =: 0

FOUNDRY_IJS =: '../j/foundry.ijs'

fexists =: 3 : '0 < # 1!:0 < y'

pass =: 3 : 0
  PASS_N =: PASS_N + 1
  echo 'PASS ' , y
)

fail =: 4 : 0
  FAIL_N =: FAIL_N + 1
  echo 'FAIL ' , y , ': ' , x
)

blocked =: 4 : 0
  BLOCK_N =: BLOCK_N + 1
  echo 'BLOCKED ' , y , ': ' , x
)

NB. Load package entrypoint and export J_API verbs into base.
NB. Returns 1 on success, 0 if foundry.ijs missing.
load_foundry =: 3 : 0
  if. -. fexists FOUNDRY_IJS do.
    CORE_OK =: 0
    0 return.
  end.
  load FOUNDRY_IJS
  foundry_export ''
  CORE_OK =: 1
  1
)

harness_finish =: 3 : 0
  echo ''
  echo '═══════════════════════════════════════'
  echo 'PASS=' , (": PASS_N) , ' FAIL=' , (": FAIL_N) , ' BLOCKED=' , (": BLOCK_N)
  if. FAIL_N > 0 do. 2!:55 ] 1 else. 2!:55 ] 0 end.
)
