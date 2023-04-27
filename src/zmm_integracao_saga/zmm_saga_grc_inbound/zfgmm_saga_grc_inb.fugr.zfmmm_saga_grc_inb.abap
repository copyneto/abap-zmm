FUNCTION zfmmm_saga_grc_inb.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IS_HEADER) TYPE  /XNFE/INNFEHD OPTIONAL
*"     VALUE(IT_ASSIGN) TYPE  /XNFE/NFEASSIGN_T OPTIONAL
*"     VALUE(IV_ACTION) TYPE  CHAR1
*"----------------------------------------------------------------------

  IF iv_action EQ abap_true.

*    NEW zclmm_saga_grc_inbound( )->dados_pross( is_header   = is_header
*                                                it_assign   = it_assign  ).

  ELSE.

*    NEW zclmm_saga_grc_inbound( )->dados_trans( is_header  = is_header ).

  ENDIF.



ENDFUNCTION.
