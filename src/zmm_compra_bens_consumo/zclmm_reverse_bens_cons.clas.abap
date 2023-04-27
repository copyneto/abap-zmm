class ZCLMM_REVERSE_BENS_CONS definition
  public
  final
  create public .

public section.

  "! Processamento principal
  "! @parameter et_return | Retorno
  "! @parameter cs_document | Dados de processamento
  methods REVERSE_PROCESS
    exporting
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
  "! Estorno do mov. material
  "! @parameter et_return | Retorno
  "! @parameter es_goodsmvt_est | Estorno do mov. material
  "! @parameter cs_document | Dados de processamento
  methods REVERSAL_GOODSMVT
    exporting
      !ES_GOODSMVT_EST type BAPI2017_GM_HEAD_RET
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
  "! Estorno NF
  "! @parameter et_return | Retorno
  "! @parameter ev_docnum_est | Estorno NF
  "! @parameter cs_document | Dados de processamento
  methods REVERSAL_NF
    exporting
      !EV_DOCNUM_EST type J_1BNFDOC-DOCNUM
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
  "! Estorno doc. contábil
  "! @parameter et_return | Retorno
  "! @parameter ev_belnr_est | Doc. estorno
  "! @parameter ev_gjahr_est | Ano Doc. estorno
  "! @parameter cs_document | Dados de processamento
  methods REVERSAL_DOC_POSTING
    exporting
      !EV_BELNR_EST type BELNR_D
      !EV_GJAHR_EST type GJAHR
      !ET_RETURN type BAPIRET2_TAB
    changing
      !CS_DOCUMENT type ZTMM_MOV_CNTRL .
PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ty_etapas,
      etapa_criar    TYPE ze_etapa,
      etapa_estornar TYPE ze_etapa,
    END OF ty_etapas .
  TYPES:
    ty_etapas_t TYPE STANDARD TABLE OF ty_etapas .

  CONSTANTS:
    "! Constantes de processamento
    BEGIN OF gc_data,
      fixo_03               TYPE char2      VALUE '03',
      fixo_221              TYPE char3      VALUE '221',
      ok                    TYPE char1      VALUE 'S',
      erro                  TYPE char1      VALUE 'E',
      fixo_01               TYPE char2      VALUE '01',
      etapa_1_goods_saida   TYPE ze_etapa   VALUE 1,
      etapa_2_tax_simulate  TYPE ze_etapa   VALUE 2,
      etapa_3_nf_saida      TYPE ze_etapa   VALUE 3,
      etapa_4_posting       TYPE ze_etapa   VALUE 4,
      etapa_5_nf_entrada    TYPE ze_etapa   VALUE 5,
      etapa_6_goods_entrada TYPE ze_etapa   VALUE 6,

    END OF gc_data .
  DATA gt_return TYPE bapiret2_tab .

  "! Atribuir mensagem
  "! @parameter is_msg | Mensagem
  METHODS set_message
    IMPORTING
      !is_msg TYPE bapiret2 .
  "! Commit
  METHODS commit_work .
  "! Rollback
  METHODS rollback .
  "! Verificar dados
  "! @parameter iv_etapa | Etapa
  "! @parameter iv_doc | Documento
  "! @parameter iv_ano | Ano
  "! @parameter iv_nf | NF
  "! @parameter iv_belnr | Doc. contábil
  METHODS check_dados
    IMPORTING
      !iv_etapa    TYPE ztmm_mov_cntrl-etapa
      !iv_doc      TYPE mblnr OPTIONAL
      !iv_ano      TYPE mjahr OPTIONAL
      !iv_nf       TYPE j_1bnfdoc-docnum OPTIONAL
      !iv_belnr    TYPE belnr_d OPTIONAL
    RETURNING
      VALUE(rv_ok) TYPE abap_bool .
  "! Atribuir data
  "! @parameter iv_doc | Documento
  "! @parameter iv_ano | Ano
  "! @parameter rv_post_date | Data
  METHODS set_post_date
    IMPORTING
      !iv_doc             TYPE mblnr
      !iv_ano             TYPE mjahr
    RETURNING
      VALUE(rv_post_date) TYPE sy-datum .
  "! Executar BAPI estorno doc. mat.
  "! @parameter iv_material | Material
  "! @parameter iv_ano | Tabela de retorno
  "! @parameter  iv_post_date     | Data
  "! @parameter  iv_user | Usuário
  "! @parameter  es_obj_key    | Doc. gerado
  "! @parameter  cs_document    | Dados do processamento
  METHODS call_bapi_est_goods
    IMPORTING
      !iv_material  TYPE ztmm_mov_cntrl-mblnr_sai
      !iv_ano       TYPE ztmm_mov_cntrl-mjahr
      !iv_post_date TYPE sy-datum
      !iv_user      TYPE syst-uname
    EXPORTING
      !es_obj_key   TYPE bapi2017_gm_head_ret
    CHANGING
      !cs_document  TYPE ztmm_mov_cntrl .
  "! Executar BAPI estorno nf entrada
  "! @parameter iv_nf_ent | Docnum
  "! @parameter ev_docnum | Doc. gerado
  "! @parameter  cs_document    | Dados do processamento
  METHODS call_bapi_est_nf_ent
    IMPORTING
      !iv_nf_ent   TYPE ztmm_mov_cntrl-docnum_ent
    EXPORTING
      !ev_docnum   TYPE j_1bnfdoc-docnum
    CHANGING
      !cs_document TYPE ztmm_mov_cntrl .
  "! Executar BAPI estorno doc. cont.
  "! @parameter iv_belnr | Doc. cont.
  "! @parameter iv_gjahr | Ano Doc. cont.
  "! @parameter iv_bukrs| Empresa
  "! @parameter ev_belnr_est | Doc. cont. estorno
  "! @parameter ev_gjahr_est | Ano Doc. cont. estorno
  "! @parameter  cs_document | Dados do processamento
  METHODS call_bapi_est_posting
    IMPORTING
      !iv_belnr     TYPE ztmm_mov_cntrl-belnr
      !iv_gjahr     TYPE ztmm_mov_cntrl-gjahr_dc
      !iv_bukrs     TYPE ztmm_mov_cntrl-bukrs
    EXPORTING
      !ev_belnr_est TYPE belnr_d
      !ev_gjahr_est TYPE gjahr
    CHANGING
      !cs_document  TYPE ztmm_mov_cntrl .
  "! Atualizar dados
  "! @parameter is_doc | Dados de processamento
  METHODS update_table
    IMPORTING
      !is_doc TYPE ztmm_mov_cntrl .
  "! Atribuir etapa reversão
  "! @parameter ct_etapas | Etapas
  METHODS set_etapa_reverse
    CHANGING
      !ct_etapas TYPE ty_etapas_t .
  "! Atribuir etapa reversão
  "! @parameter iv_etapa | Etapa
  "! @parameter rv_etapa_nova | Nova Etapa
  METHODS set_etapa
    IMPORTING
      !iv_etapa            TYPE ztmm_mov_cntrl-etapa
    RETURNING
      VALUE(rv_etapa_nova) TYPE ztmm_mov_cntrl-etapa .
  "! Executar estorno
  "! @parameter iv_estorno | Estorno
  "! @parameter cs_doc | Dados de processamento
  METHODS exec_estorno
    IMPORTING
      !iv_estorno TYPE ze_etapa
    CHANGING
      !cs_doc     TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Executar estorno mov. mat.
  "! @parameter cs_doc | Dados de processamento
  METHODS process_estorno_goodsmvt
    CHANGING
      !cs_doc TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Verificar retorno
  "! @parameter rv_ok | Ok/Nok
  METHODS check_return
    RETURNING
      VALUE(rv_ok) TYPE abap_bool .
  "! Executar estorno simulate
  "! @parameter cs_doc | Dados de processamento
  METHODS process_estorno_simulate
    CHANGING
      !cs_doc TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Executar estorno nf saida
  "! @parameter cs_doc | Dados de processamento
  METHODS process_estorno_nf_saida_app
    CHANGING
      !cs_doc TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Executar estorno doc. contab.
  "! @parameter cs_doc | Dados de processamento
  METHODS process_estorno_posting
    CHANGING
      !cs_doc TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Executar estorno doc. contab.
  "! @parameter cs_doc | Dados de processamento
  METHODS process_estorno_nf_entrada
    CHANGING
      cs_doc TYPE ztmm_mov_cntrl
    EXCEPTIONS
      error .
  "! Verificar etapa 3 - nf saída
  "! @parameter cs_doc | Dados de processamento
  "! @parameter rv_ok | Ok/Nok
  METHODS check_etapa_3
    CHANGING
      cs_doc       TYPE ztmm_mov_cntrl
    RETURNING
      VALUE(rv_ok) TYPE abap_bool.
ENDCLASS.



CLASS ZCLMM_REVERSE_BENS_CONS IMPLEMENTATION.


  METHOD update_table.

    DATA ls_update TYPE ztmm_mov_cntrl.

    ls_update = CORRESPONDING #( is_doc ).

    MODIFY ztmm_mov_cntrl FROM ls_update. "#EC CI_IMUD_NESTED

  ENDMETHOD.


  METHOD set_post_date.

    SELECT SINGLE PostingDate "#EC CI_SEL_NESTED
      FROM I_MaterialDocumentHeader
      INTO @rv_post_date
     WHERE MaterialDocument = @iv_doc
       AND MaterialDocumentYear = @iv_ano.

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


  METHOD set_etapa_reverse.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_1_goods_saida
*            etapa_estornar = gc_data-etapa_7_estorno_goods_saida
        ) TO ct_etapas.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_2_tax_simulate
*            etapa_estornar = gc_data-etapa_7_estorno_goods_saida
        ) TO ct_etapas.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_3_nf_saida
*            etapa_estornar = gc_data-etapa_11_estorno_app_nf_saida
        ) TO ct_etapas.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_4_posting
*            etapa_estornar = gc_data-etapa_9_estorno_posting
        ) TO ct_etapas.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_5_nf_entrada
*            etapa_estornar = gc_data-etapa_8_estorno_nf_entrada
        ) TO ct_etapas.

    APPEND VALUE #(
            etapa_criar    = gc_data-etapa_6_goods_entrada
*            etapa_estornar = gc_data-etapa_10_estorno_goods_entrada
        ) TO ct_etapas.






  ENDMETHOD.


  METHOD set_etapa.

    rv_etapa_nova = iv_etapa + 1.

  ENDMETHOD.


  METHOD rollback.

    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

  ENDMETHOD.


  METHOD reverse_process.

    DATA lt_etapas TYPE ty_etapas_t.


    set_etapa_reverse( CHANGING ct_etapas = lt_etapas ).

*    DATA(lv_etapa) = set_etapa( cs_document-etapa ).

    DATA(lv_etapa) = cs_document-etapa.

    IF lv_etapa IS INITIAL.

*        msg erro
      RETURN.
    ENDIF.

    IF check_etapa_3( CHANGING cs_doc = cs_document ) = abap_true.


      WHILE lv_etapa <> 0.

        IF check_etapa_3( CHANGING cs_doc = cs_document ) = abap_false.

          EXIT.

        ENDIF.
        READ TABLE lt_etapas ASSIGNING FIELD-SYMBOL(<fs_line>)
                             WITH KEY etapa_criar = lv_etapa BINARY SEARCH.

        IF sy-subrc = 0.

          exec_estorno(
            EXPORTING
              iv_estorno = <fs_line>-etapa_criar
            CHANGING
               cs_doc     = cs_document
            EXCEPTIONS
              error      = 1
              OTHERS     = 2
          ).

          IF sy-subrc <> 0 OR lv_etapa = 0.

            EXIT.

          ELSE.

            SUBTRACT 1 FROM lv_etapa.


          ENDIF.

        ENDIF.


      ENDWHILE.

    ENDIF.

    et_return = gt_return.


  ENDMETHOD.


  METHOD reversal_nf.

    DATA(lv_check) = check_dados( iv_etapa = cs_document-etapa iv_nf = cs_document-docnum_ent ).
*

    IF lv_check = abap_true.

      call_bapi_est_nf_ent( EXPORTING
                            iv_nf_ent = cs_document-docnum_ent
                           IMPORTING
                            ev_docnum  = ev_docnum_est
                           CHANGING
                            cs_document = cs_document
                          ).

    ENDIF.

    et_return = gt_return.


  ENDMETHOD.


  METHOD reversal_goodsmvt.



    DATA(lv_material) = COND #( WHEN cs_document-etapa = gc_data-etapa_6_goods_entrada      THEN cs_document-mblnr_ent
                                WHEN cs_document-etapa = gc_data-etapa_1_goods_saida        THEN cs_document-mblnr_sai ).

    DATA(lv_ano) = COND #( WHEN cs_document-etapa = gc_data-etapa_6_goods_entrada     THEN cs_document-mjahr_ent
                           WHEN cs_document-etapa = gc_data-etapa_1_goods_saida    THEN cs_document-mjahr ).

    DATA(lv_check) = check_dados( iv_etapa = cs_document-etapa iv_doc = lv_material iv_ano = lv_ano ).

    IF lv_check = abap_true.

      DATA(lv_post_date) = set_post_date( iv_doc = lv_material
                                          iv_ano = lv_ano ).

      call_bapi_est_goods( EXPORTING
                            iv_material  = lv_material
                            iv_ano       = lv_ano
                            iv_post_date = lv_post_date
                            iv_user      = sy-uname

                           IMPORTING
                            es_obj_key  = es_goodsmvt_est
                           CHANGING
                            cs_document = cs_document
                          ).

    ENDIF.

    et_return = gt_return.


  ENDMETHOD.


  METHOD reversal_doc_posting.


    DATA(lv_check) = check_dados( iv_etapa = cs_document-etapa iv_belnr = cs_document-belnr ).
*

    IF lv_check = abap_true.

      call_bapi_est_posting( EXPORTING
                            iv_belnr = cs_document-belnr
                            iv_gjahr = cs_document-gjahr_dc
                            iv_bukrs = cs_document-bukrs
                           IMPORTING
                            ev_belnr_est = ev_belnr_est
                            ev_gjahr_est = ev_gjahr_est
                           CHANGING
                            cs_document = cs_document
                          ).

    ENDIF.

    et_return = gt_return.


  ENDMETHOD.


  METHOD process_estorno_simulate.

    "nao tem estorno

    FREE gt_return.

  ENDMETHOD.


  METHOD process_estorno_posting.

    DATA(lo_bapi) = NEW zclmm_reverse_bens_cons( ).
    FREE gt_return.
    lo_bapi->reversal_doc_posting(
      IMPORTING
*          ev_belnr_est =
*          ev_gjahr_est =
        et_return    = gt_return
      CHANGING
        cs_document  = cs_doc
    ).

  ENDMETHOD.


  METHOD process_estorno_nf_saida_app.

    "esta etapa sera pelo app..

    FREE gt_return.

    set_message( is_msg   = VALUE #( type   = gc_data-ok
                                 id         = 'ZMM_BENS_CONSUMO'
                                 number     = '022' ) ).

    RAISE error.

  ENDMETHOD.


  METHOD process_estorno_nf_entrada.

    DATA(lo_bapi) = NEW zclmm_reverse_bens_cons( ).
    FREE gt_return.
    lo_bapi->reversal_nf(
      IMPORTING
*          ev_docnum_est =
        et_return     = gt_return
      CHANGING
        cs_document   = cs_doc
    ).

  ENDMETHOD.


  METHOD process_estorno_goodsmvt.

    DATA(lo_bapi) = NEW zclmm_reverse_bens_cons( ).
    FREE gt_return.
    lo_bapi->reversal_goodsmvt(
      IMPORTING
        es_goodsmvt_est = DATA(ls_goods)
        et_return       = gt_return
      CHANGING
        cs_document     = cs_doc
    ).

  ENDMETHOD.


  METHOD exec_estorno.


    CASE iv_estorno.

      WHEN gc_data-etapa_1_goods_saida.

        process_estorno_goodsmvt(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.

      WHEN gc_data-etapa_2_tax_simulate.

        process_estorno_simulate(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.

      WHEN gc_data-etapa_3_nf_saida.

        process_estorno_nf_saida_app(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.


      WHEN gc_data-etapa_4_posting.

        process_estorno_posting(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.

      WHEN gc_data-etapa_5_nf_entrada.

        process_estorno_nf_entrada(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.

      WHEN gc_data-etapa_6_goods_entrada.

        process_estorno_goodsmvt(
          CHANGING
            cs_doc = cs_doc
          EXCEPTIONS
            error  = 1
            OTHERS = 2
            ).

        IF sy-subrc <> 0 OR check_return( ) = abap_false.

          RAISE error.

        ENDIF.

    ENDCASE.

    SUBTRACT 1 FROM cs_doc-etapa.

    update_table( is_doc = cs_doc ).

    commit_work( ).



  ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


  ENDMETHOD.


  METHOD check_return.

    READ TABLE gt_return ASSIGNING FIELD-SYMBOL(<fs_line>) WITH KEY type = gc_data-erro. "#EC CI_STDSEQ

    IF sy-subrc = 0.

      rv_ok = abap_false.

    ELSE.

      rv_ok = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD check_dados.

    rv_ok = abap_true.


    CASE iv_etapa.

*      WHEN gc_data-etapa_7_estorno_goods_saida OR gc_data-etapa_10_estorno_goods_entrada.
      WHEN gc_data-etapa_1_goods_saida OR gc_data-etapa_6_goods_entrada.

        IF iv_ano IS INITIAL OR
           iv_doc IS INITIAL.

          rv_ok = abap_false.

        ENDIF.



      WHEN gc_data-etapa_5_nf_entrada.

        IF iv_nf IS INITIAL.

          rv_ok = abap_false.

        ENDIF.

*      WHEN gc_data-etapa_9_estorno_posting.
      WHEN gc_data-etapa_4_posting.

        IF iv_belnr IS INITIAL.

          rv_ok = abap_false.

        ENDIF.


    ENDCASE.

    IF rv_ok = abap_false.

      set_message(
           is_msg   = VALUE #( type       = gc_data-erro
                               id         = 'ZMM_BENS_CONSUMO'
                               number     = '012'
                                ) ).

    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_est_posting.

    CALL FUNCTION 'TR_SE_FI_DOCUMENT_REVERSAL'
      EXPORTING
        i_bukrs              = iv_bukrs
        i_docnrfi            = iv_belnr
        i_gjahr              = iv_gjahr
       i_budat              = sy-datum
       i_period             = sy-datum+4(2)
        i_fi_reversal_reason = gc_data-fixo_01
      IMPORTING
        e_reversal_docnrfi   = ev_belnr_est
        e_reversal_gjahr     = ev_gjahr_est
      EXCEPTIONS
        error_occured        = 1
        OTHERS               = 2.

    IF sy-subrc = 0 AND ev_belnr_est IS NOT INITIAL.

      cs_document-belnr_est = ev_belnr_est.
      cs_document-gjahr_est = ev_gjahr_est.
      cs_document-bldat_est = sy-datum.

      set_message( is_msg   = VALUE #( type       = gc_data-ok
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '015'
                                       message_v1 = ev_belnr_est
                                       message_v2 = ev_gjahr_est ) ).

      commit_work( ).

    ELSE.

      set_message( is_msg   = VALUE #( type       = gc_data-erro
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '016'
                                    ) ).
      rollback( ).

    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_est_nf_ent.

    CALL FUNCTION 'J_1B_NF_DOCUMENT_CANCEL'
      EXPORTING
        doc_number               = iv_nf_ent
        ref_type                 = ''
        ref_key                  = ''
*       can_dat                  =
*       cre_nam                  =
*       doc_dat                  =
*       pst_dat                  =
*       bel_nr                   =
*       g_jahr                   =
      IMPORTING
        doc_number               = ev_docnum
      EXCEPTIONS
        document_not_found       = 1
        cancel_not_possible      = 2
        nf_cancel_type_not_found = 3
        database_problem         = 4
        docum_lock               = 5
        nfe_cancel_simulation    = 6
        partner_blocked          = 7
        OTHERS                   = 8.

    IF sy-subrc = 0 AND ev_docnum IS NOT INITIAL.

      cs_document-docnum_est_ent = ev_docnum.

      set_message( is_msg   = VALUE #( type       = gc_data-ok
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '013'
                                       message_v1 = ev_docnum ) ).

      commit_work( ).

    ELSE.

      set_message( is_msg   = VALUE #( type       = gc_data-erro
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '014'
                                    ) ).
      rollback( ).

    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_est_goods.

    CALL FUNCTION 'BAPI_GOODSMVT_CANCEL'
      EXPORTING
        materialdocument    = iv_material
        matdocumentyear     = iv_ano
        goodsmvt_pstng_date = iv_post_date
        goodsmvt_pr_uname   = iv_user
*       documentheader_text =
      IMPORTING
        goodsmvt_headret    = es_obj_key
      TABLES
        return              = gt_return
*       goodsmvt_matdocitem =
      .


    IF es_obj_key IS NOT INITIAL.

      CASE cs_document-etapa.

        WHEN gc_data-etapa_6_goods_entrada.
*        WHEN gc_data-etapa_7_estorno_goods_saida.

          cs_document-mblnr_est_ent = es_obj_key-mat_doc.
          cs_document-mjahr_est_ent = es_obj_key-doc_year.
          cs_document-bldat_est_ent = iv_post_date.

*        WHEN gc_data-etapa_10_estorno_goods_entrada.
        WHEN gc_data-etapa_1_goods_saida.

          cs_document-mblnr_est = es_obj_key-mat_doc.
          cs_document-mjahr_est = es_obj_key-doc_year.
          cs_document-bldat_est = iv_post_date.

      ENDCASE.

      set_message( is_msg   = VALUE #( type       = gc_data-ok
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '010'
                                       message_v1 = es_obj_key-mat_doc
                                       message_v2 = es_obj_key-doc_year ) ).

      commit_work( ).

    ELSE.

      set_message( is_msg   = VALUE #( type       = gc_data-erro
                                       id         = 'ZMM_BENS_CONSUMO'
                                       number     = '011'
                                    ) ).
      rollback( ).

    ENDIF.


  ENDMETHOD.


  METHOD check_etapa_3.

    CONSTANTS lc_100 TYPE j_1bnfe_active-code VALUE '101'.

    rv_ok = abap_true.

    CHECK cs_doc-etapa = 3.

    SELECT SINGLE code "#EC CI_SEL_NESTED
    FROM j_1bnfe_active
    INTO @DATA(lv_code)
    WHERE docnum = @cs_doc-docnum_s.

    IF lv_code = lc_100.
      rv_ok = abap_true.

      cs_doc-etapa = 2.

      update_table( cs_doc ).

    ELSE.

      rv_ok = abap_false.

      set_message( is_msg   = VALUE #( type       = gc_data-erro
                                     id         = 'ZMM_BENS_CONSUMO'
                                     number     = '022'
                                  ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
