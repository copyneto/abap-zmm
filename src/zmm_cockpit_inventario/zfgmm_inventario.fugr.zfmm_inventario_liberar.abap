FUNCTION zfmm_inventario_liberar.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCUMENTID) TYPE  ZTMM_INVENTORY_H-DOCUMENTID
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE et_return.

  DATA(lo_inventario) = NEW zclmm_inventario( ).

* ---------------------------------------------------------------------------
* Cria documento de inventário e contagem
* ---------------------------------------------------------------------------
  lo_inventario->release_start( EXPORTING iv_documentid = iv_documentid
                                IMPORTING et_return     = et_return ).

* ---------------------------------------------------------------------------
* Salva mensagens de retorno
* ---------------------------------------------------------------------------
  lo_inventario->save_log( EXPORTING iv_documentid = iv_documentid
                           CHANGING  ct_return     = et_return ).

ENDFUNCTION.
