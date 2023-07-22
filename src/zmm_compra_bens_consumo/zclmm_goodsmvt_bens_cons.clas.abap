class ZCLMM_GOODSMVT_BENS_CONS definition
  public
  final
  create public .

public section.

    "! Processamento principal
    "! @parameter es_goodsmvt | Documento
    "! @parameter et_return | Retorno
    "! @parameter cs_document | Dados de processamento
  methods PROCESS
    exporting
      !ES_GOODSMVT type BAPI2017_GM_HEAD_RET
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL . " ztmm_mov_cntrl .
PROTECTED SECTION.
private section.

  constants:
    "! Constantes do processamento
    BEGIN OF gc_data,
      fixo_03         TYPE gm_code  VALUE '03',
      fixo_05         TYPE gm_code  VALUE '05',
      move_type_221   TYPE bwart    VALUE '221',
      move_type_561   TYPE bwart    VALUE '561',
      ok              TYPE char1    VALUE 'S',
      erro            TYPE char1    VALUE 'E',
      etapa_1_baixa   TYPE ze_etapa VALUE '1',
      etapa_6_entrada TYPE ze_etapa VALUE '6',
    END OF gc_data .
  "! Tabela de retorno
  data GT_RETURN type BAPIRET2_TAB .
  constants GC_MSGID type SYST_MSGID value 'ZMM_BENS_CONSUMO' ##NO_TEXT.
  constants GC_MSGNO_1 type SYST_MSGNO value '001' ##NO_TEXT.
  constants GC_MSGNO_2 type SYST_MSGNO value '002' ##NO_TEXT.

  "! Atribuir cabeçalho
  "! @parameter rs_header | Cabeçalho
  methods SET_HEADER
    returning
      value(RS_HEADER) type BAPI2017_GM_HEAD_01 .
  "! Atribuir item
  "! @parameter is_document | Dados de processamento
  "! @parameter rt_item | Item
  methods SET_ITEM
    importing
      !IS_DOCUMENT type ZTMM_MOV_CNTRL   " ztmm_mov_cntrl .
    returning
      value(RT_ITEM) type BAPI2017_GM_ITEM_CREATE_T .
  "! Atribuir código
  "! @parameter iv_etapa | Etapa
  "! @parameter rs_code | Item
  methods SET_CODE
    importing
      !IV_ETAPA type ZTMM_MOV_CNTRL-ETAPA
    returning
      value(RS_CODE) type BAPI2017_GM_CODE .
  "! Atribuir lote
  "! @parameter is_document | Dados de processamento
  "! @parameter rv_batch | Lote
  methods SET_BATCH
    importing
      !IS_DOCUMENT type ZTMM_MOV_CNTRL    " ztmm_mov_cntrl .
    returning
      value(RV_BATCH) type CHARG_D .
  "! Executar BAPI
  "! @parameter es_goodsmvt | Doc. gerado
  "! @parameter  is_header | Header
  "! @parameter  is_code | Código
  "! @parameter  it_item       | Item
  "! @parameter  cs_document       | Dados de process.
  methods CALL_BAPI
    importing
      !IS_HEADER type BAPI2017_GM_HEAD_01
      !IS_CODE type BAPI2017_GM_CODE
      !IT_ITEM type BAPI2017_GM_ITEM_CREATE_T
      !IT_SERIAL type GM_ITEM_SERIAL_NO_T optional
    exporting
      !ES_GOODSMVT type BAPI2017_GM_HEAD_RET
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL . " ztmm_mov_cntrl .
  "! Atribuir item
  "! @parameter is_doc | Dados de processamento
  "! @parameter is_msg | Mensagem
  methods SET_MESSAGE
    importing
      !IS_DOC type ZTMM_MOV_CNTRL " ztmm_mov_cntrl
      !IS_MSG type BAPIRET2 .
  "! Commit
  methods COMMIT_WORK .
  "! Rollback
  methods ROLLBACK .
  "! Atualizar dados
  "! @parameter is_doc | Dados de processamento
  methods UPDATE_TABLE
    importing
      !IS_DOC type ZTMM_MOV_CNTRL . " ztmm_mov_cntrl.
  methods SET_SERIAL
    importing
      !IS_DOCUMENT type ZTMM_MOV_CNTRL
    returning
      value(RT_SERIAL) type GM_ITEM_SERIAL_NO_T .
ENDCLASS.



CLASS ZCLMM_GOODSMVT_BENS_CONS IMPLEMENTATION.


  METHOD process.

    DATA(ls_header) = set_header( ).

    DATA(ls_code)   = set_code( cs_document-etapa ).

    DATA(lt_item)   = set_item( is_document = cs_document ).

    DATA(lt_serial) = set_serial( is_document = cs_document ).

    call_bapi( EXPORTING is_header   = ls_header
                         is_code     = ls_code
                         it_item     = lt_item
                         it_serial   = lt_serial
               IMPORTING es_goodsmvt = es_goodsmvt
                CHANGING cs_document = cs_document ).

    et_return = gt_return.

  ENDMETHOD.


  METHOD set_header.

    rs_header = VALUE #( pstng_date = sy-datum
                         doc_date   = sy-datum ).

  ENDMETHOD.


  METHOD set_item.

    DATA: lv_lgort TYPE lgort_d.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = 'MM'
                                          iv_chave1 = 'MONITOR_IMOBILIZACAO'
                                          iv_chave2 = 'DEPOSITO'
                                IMPORTING ev_param  = lv_lgort ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    APPEND VALUE #(
        material = COND #( WHEN is_document-etapa = gc_data-etapa_6_entrada THEN is_document-matnr ELSE is_document-matnr1 )  " |{ is_document-matnr1 ALPHA = IN }|
        plant = |{ is_document-werks ALPHA = IN }|

*        serialno_auto_numberassignment = COND #( WHEN is_document-etapa = gc_data-etapa_6_entrada THEN abap_true )

*        stge_loc = is_document-lgort
        stge_loc = COND #( WHEN is_document-etapa = gc_data-etapa_1_baixa   THEN lv_lgort
                           WHEN is_document-etapa = gc_data-etapa_6_entrada THEN is_document-lgort )

        batch = set_batch( is_document )

        move_type = COND #( WHEN is_document-etapa = gc_data-etapa_1_baixa   THEN gc_data-move_type_221
                            WHEN is_document-etapa = gc_data-etapa_6_entrada THEN gc_data-move_type_561 )

        entry_qnt = is_document-menge

*        wbs_elem  = |{ is_document-posid ALPHA = in }|
        wbs_elem = COND #( WHEN is_document-etapa = gc_data-etapa_1_baixa THEN is_document-posid )

    ) TO rt_item.


  ENDMETHOD.


  METHOD set_code.

    rs_code-gm_code = COND #( WHEN iv_etapa = gc_data-etapa_1_baixa THEN gc_data-fixo_03
                              WHEN iv_etapa = gc_data-etapa_6_entrada THEN gc_data-fixo_05 ).

  ENDMETHOD.


  METHOD set_batch.

    CASE is_document-etapa.

      WHEN gc_data-etapa_1_baixa.
*
        DATA(lv_mat) = |{ is_document-matnr1 ALPHA = IN }|.
        DATA(lv_wer) = |{ is_document-werks ALPHA = IN }|.

        SELECT SINGLE charg_sid
         FROM P_StockBatchInfo
         INTO @rv_batch
        WHERE matnr = @is_document-matnr1 "lv_mat
          AND werks = @lv_wer
          AND mng01 > 0.

      WHEN gc_data-etapa_6_entrada.

        CLEAR rv_batch.

    ENDCASE.


  ENDMETHOD.


  METHOD call_bapi.

    DATA(lt_item)   = it_item[].
    DATA(lt_serial) = it_serial[].

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header       = is_header
        goodsmvt_code         = is_code
      IMPORTING
        goodsmvt_headret      = es_goodsmvt
      TABLES
        goodsmvt_item         = lt_item
        goodsmvt_serialnumber = lt_serial
        return                = gt_return.

    IF es_goodsmvt IS NOT INITIAL.

      CASE cs_document-etapa.
        WHEN gc_data-etapa_1_baixa.

          cs_document-mblnr_sai = es_goodsmvt-mat_doc.
          cs_document-mjahr     = es_goodsmvt-doc_year.
          ADD 1 TO cs_document-mblpo.

        WHEN gc_data-etapa_6_entrada.

          cs_document-mblnr_ent = es_goodsmvt-mat_doc.
          cs_document-mjahr_ent = es_goodsmvt-doc_year.
          ADD 1 TO cs_document-mblpo_ent.

      ENDCASE.

      set_message( is_doc = cs_document
                   is_msg = VALUE #( type       = gc_data-ok
                                     id         = gc_msgid
                                     number     = gc_msgno_1
                                     message_v1 = es_goodsmvt-mat_doc
                                     message_v2 = es_goodsmvt-doc_year ) ).

      update_table( cs_document ).

      commit_work( ).

    ELSE.

      set_message( is_doc = cs_document
                   is_msg = VALUE #( type   = gc_data-erro
                                     id     = gc_msgid
                                     number = gc_msgno_2 ) ).
      rollback( ).

    ENDIF.

  ENDMETHOD.


  METHOD set_message.

    DATA ls_message TYPE bapiret2.

    ls_message-type        = is_msg-type.
    ls_message-id          = is_msg-id.
    ls_message-number      = is_msg-number.
    ls_message-message_v1  = is_msg-message_v1.
    ls_message-message_v2  = is_msg-message_v2.
    ls_message-message_v3  = is_msg-message_v3.
    ls_message-message_v4  = is_msg-message_v4.

    MESSAGE   ID        ls_message-id
              TYPE      ls_message-type
              NUMBER    ls_message-number
              WITH      ls_message-message_v1
                        ls_message-message_v2
                        ls_message-message_v3
                        ls_message-message_v4
              INTO      ls_message-message.

    APPEND ls_message TO gt_return.

  ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


  ENDMETHOD.


  METHOD rollback.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDMETHOD.


  METHOD update_table.

    DATA ls_update TYPE ztmm_mov_cntrl.

    ls_update = CORRESPONDING #( is_doc ).

    CASE is_doc-etapa.
      WHEN gc_data-etapa_1_baixa.
        CLEAR: ls_update-mblnr_est,
               ls_update-mjahr_est.

      WHEN gc_data-etapa_6_entrada.
        CLEAR: ls_update-mblnr_est_ent,
               ls_update-mjahr_est_ent,
               ls_update-bldat_est_ent.

    ENDCASE.

    MODIFY ztmm_mov_cntrl FROM ls_update.

  ENDMETHOD.


  METHOD set_serial.

    DATA: lv_mblpo TYPE mblpo.

    CHECK is_document-etapa = gc_data-etapa_6_entrada.

    SELECT id,
           id_mov,
           invnr
      FROM ztmm_mat_cntrl
     WHERE id_mov = @is_document-id
      INTO TABLE @DATA(lt_inv).

    IF sy-subrc IS INITIAL.
      LOOP AT lt_inv ASSIGNING FIELD-SYMBOL(<fs_inv>).

        rt_serial = VALUE #( BASE rt_serial ( matdoc_itm = 1
                                              serialno   = <fs_inv>-invnr ) ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
