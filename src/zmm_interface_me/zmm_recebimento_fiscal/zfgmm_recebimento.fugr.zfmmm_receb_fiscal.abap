FUNCTION zfmmm_receb_fiscal.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_MRMRSEG) TYPE  ZCTGMM_MRMRSEG OPTIONAL
*"     VALUE(IV_TCODE) TYPE  SYST_TCODE
*"----------------------------------------------------------------------
  WAIT UP TO 5 SECONDS.

  DATA(lo_object) = NEW zclmm_recebimento_fiscal( iv_tcode = iv_tcode it_mrmrseg = it_mrmrseg ).

  lo_object->execute(  ).

ENDFUNCTION.
