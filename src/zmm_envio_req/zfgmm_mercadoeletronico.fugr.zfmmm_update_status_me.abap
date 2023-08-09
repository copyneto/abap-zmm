FUNCTION zfmmm_update_status_me.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_REQ) TYPE  ZCTGMM_ENVIO_REQ
*"----------------------------------------------------------------------
  CONSTANTS gc_m TYPE c VALUE 'M' ##NO_TEXT.

  DATA: lt_xeban TYPE STANDARD TABLE OF ueban,
        lt_yeban TYPE STANDARD TABLE OF ueban,
        lt_xebkn TYPE STANDARD TABLE OF uebkn,
        lt_yebkn TYPE STANDARD TABLE OF uebkn.


  CHECK it_req IS NOT INITIAL.

  DATA(lt_req) = it_req.
*VALUE zclmm_send_req=>tt_req_att( FOR ls_req IN it_req
*                                 let ls_base = VALUE ztmm_envio_req( status = gc_m )
*                                 IN ( CORRESPONDING #( BASE ( ls_req )  ls_base ) ) ).

  LOOP AT lt_req ASSIGNING FIELD-SYMBOL(<fs_req>).
    <fs_req>-status = gc_m .
  ENDLOOP.

  " Atualizar tabela controle requisições ME - Integrados
  SORT lt_req BY doc_item ASCENDING.
  UPDATE ztmm_envio_req FROM TABLE lt_req.

  IF sy-subrc EQ 0.
    COMMIT WORK.
  ENDIF.

  " Atualizar campo status - Integrado
  IF lt_req IS NOT INITIAL.
    SELECT * FROM eban
    FOR ALL ENTRIES IN @lt_req
    WHERE banfn  = @lt_req-doc_sap
      AND bnfpo = @lt_req-doc_item
      AND zz1_statu <> 'C'
      AND loekz      = ''
      APPENDING  TABLE @lt_xeban.
  ENDIF.

  CHECK lt_xeban IS NOT INITIAL.

  lt_yeban = lt_xeban.

  LOOP AT lt_xeban ASSIGNING FIELD-SYMBOL(<fs_eban>).
    <fs_eban>-zz1_statu = gc_m .
    <fs_eban>-kz        = 'U'.
  ENDLOOP.

  CALL FUNCTION 'ME_UPDATE_REQUISITION'
    TABLES
      xeban = lt_xeban
      xebkn = lt_xebkn
      yeban = lt_yeban
      yebkn = lt_yebkn.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDFUNCTION.
