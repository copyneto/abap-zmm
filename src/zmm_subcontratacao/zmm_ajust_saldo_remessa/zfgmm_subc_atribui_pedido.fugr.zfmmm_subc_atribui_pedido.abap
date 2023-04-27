FUNCTION zfmmm_subc_atribui_pedido.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_KEY) TYPE  ZSMM_SUBC_SAVEATRIB
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_proc) = NEW zclmm_ajst_sald_remessa( ).

  lo_proc->call_bapis( EXPORTING is_key    = is_key
                       IMPORTING et_return = et_return ).

ENDFUNCTION.
