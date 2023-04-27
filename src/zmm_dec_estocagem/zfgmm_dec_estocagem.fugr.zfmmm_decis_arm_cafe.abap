FUNCTION zfmmm_decis_arm_cafe.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ROMANEIO) TYPE  ZE_ROMANEIO
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA(lo_cafe) = NEW zclmm_arm_cafe( ).

  et_return = lo_cafe->proc_armaz( iv_romaneio = iv_romaneio ).

ENDFUNCTION.
