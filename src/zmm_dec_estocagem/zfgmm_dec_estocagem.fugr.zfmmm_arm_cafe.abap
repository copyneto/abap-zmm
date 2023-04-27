FUNCTION zfmmm_arm_cafe.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_MM_01_CAFE) TYPE  ZI_MM_01_CAFE OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA(lo_cafe) = NEW zclmm_arm_cafe( is_mm_01_cafe ).

  et_return = lo_cafe->execute(  ).

ENDFUNCTION.
