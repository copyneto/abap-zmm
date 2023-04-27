FUNCTION zfmmm_lancam_compensacao.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADER) TYPE  ZSMM_LANCAM_COMP_HEADER_DATA
*"  EXPORTING
*"     VALUE(EV_BELNR) TYPE  BELNR_D
*"     VALUE(EV_GJAHR) TYPE  GJAHR
*"     VALUE(EV_BUKRS) TYPE  BUKRS
*"  TABLES
*"      IT_ITEM TYPE  ZCTGMM_LANCAM_COMP_ITEM_DATA
*"      IT_DOCUMENTS TYPE  ZCTGMM_LANCAM_COMP_DOCUMENTS
*"      ET_RETURN TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA: lt_return    TYPE bapiret2_t,
        lt_item      TYPE zctgmm_lancam_comp_item_data,
        lt_documents TYPE zctgmm_lancam_comp_documents.


  APPEND LINES OF it_item TO lt_item.
  APPEND LINES OF it_documents TO lt_documents.

  " Transferência c/compensação
  DATA(lo_lancam_compensacao) = NEW zclmm_lancam_compensacao( 'UMBUCHNG' ).

  " Passando as informações para processamento
  lo_lancam_compensacao->set_header_data( is_header ).
  lo_lancam_compensacao->set_item_data( lt_item ).
  lo_lancam_compensacao->set_documents( lt_documents ).
  lt_return = lo_lancam_compensacao->clear_documents(
                                          IMPORTING
                                            ev_belnr = ev_belnr
                                            ev_gjahr = ev_gjahr
                                            ev_bukrs = ev_bukrs ).

  APPEND LINES OF lt_return TO et_return.

ENDFUNCTION.
