*&---------------------------------------------------------------------*
*& Include zmmi_integracao_me
*&---------------------------------------------------------------------*

TRY .
    NEW zclmm_send_req( )->execute( is_header = im_header ).
  CATCH cx_ai_system_fault.
ENDTRY.
