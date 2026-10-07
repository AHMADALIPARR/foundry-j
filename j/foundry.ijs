NB. =============================================================================
NB. Foundry F1 — Pure-J Core package loader
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
NB. Load order matches dependency: types → goldilocks → pmat → spectral →
NB. recurrence → gate → certify.
NB. Record boxing contracts: j/BOXING.md (StepInfo, SpectralResult, AceCert, PMat).
NB.
NB. Usage (from any cwd):
NB.   load '/workspace/foundry-j/j/foundry.ijs'
NB. Then verbs live in locale 'foundry'; bring into base with:
NB.   cocurrent 'foundry'   NB. or call as foundry_fp_add_ etc.

(3 : 0) ''
here =. ({.~ i:&'/') > {: 4!:3 ''
if. 0 = # here do. here =. 1!:43 '' end.
sep =. '/'
mods =. 'types';'goldilocks';'pmat';'spectral';'recurrence';'gate';'certify'
for_m. mods do.
  load here , sep , (> m) , '.ijs'
end.
i. 0 0
)

NB. Optional: export key verbs into base for Verify convenience
NB. Uncomment if desired:
NB. (3 : 0) ''
NB. names =. ;: 'fp_add fp_sub fp_mul fp_inv fp_mulmod fp_pow fp_reduce fp_add_batch fp_mul_batch pmat_new pmat_insert pmat_conservation pmat_compose pmat_frobenius pmat_validate_grading gershgorin_bound gershgorin_check power_iteration power_iteration_check spectral_analyze synth_weights soft_project q_estimate residual_l2 rec_step rec_run tier_eps emit_apply csl_neutrality csl_beneficence csl_commutation ace_safety_margin ace_tail_bound ace_certify GOLDILOCKS_PRIME p EPSILON_FOLD P64'
NB. for_n. names do.
NB.   (n) =: (n) f.   NB. not valid across locales this way
NB. end.
NB. i.0 0
NB. )

NB. Instead expose a verb that copies selected names into base:
foundry_export =: 3 : 0
  ns =. ;: 'fp_reduce fp_add fp_sub fp_mul fp_mulmod fp_pow fp_inv fp_add_batch fp_mul_batch pmat_new pmat_insert pmat_validate_grading pmat_conservation pmat_compose pmat_frobenius pmat_entries pmat_shape gershgorin_bound gershgorin_check power_iteration power_iteration_check spectral_analyze sr_open sr_fields sr_radius sr_contractive synth_weights soft_project q_estimate residual_l2 rec_step rec_run tier_eps tier_epsilon emit_apply csl_neutrality csl_beneficence csl_commutation ace_safety_margin ace_tail_bound ace_certify GOLDILOCKS_PRIME p EPSILON_FOLD P64 P_64 K_MAX MAX_DRIFT PHI PIRTM_MAGIC T1 T2 T3 T4 WP_UNIFORM WP_HARMONIC WP_LOGDECAY GP_PASSTHROUGH GP_SUPPRESS GP_HOLD GP_ATTENUATE CSL_PASS CSL_FAIL_NEUTRALITY CSL_FAIL_BENEFICENCE CSL_FAIL_COMMUTATION'
  cocurrent 'base'
  for_n. ns do.
    ". (>n) , ' =: ' , (>n) , '_foundry_'
  end.
  i. 0 0
)
