NB. Copyright (C) 2026 Foundry J contributors
NB. SPDX-License-Identifier: AGPL-3.0-or-later
NB. Foundry J verification suite — load Core via foundry.ijs + foundry_export.

echo 'Foundry J — Verification Harness'
echo '═══════════════════════════════════════'
echo 'jconsole: ' , 9!:14 ''
echo 'core: ../j/foundry.ijs + foundry_export'
echo ''

load 'harness.ijs'

ok =. load_foundry ''
echo 'core_loaded=' , ": ok
echo ''

echo '── goldilocks ──'
load 'tests/goldilocks.ijs'
echo '── pmat ──'
load 'tests/pmat.ijs'
echo '── spectral ──'
load 'tests/spectral.ijs'
echo '── recurrence ──'
load 'tests/recurrence.ijs'

harness_finish ''
