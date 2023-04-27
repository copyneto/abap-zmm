class ZCLMM_ARGO_PEDIDO_COMPRA definition
  public
  final
  create public .

public section.

    "! Método consulta fatura
    "! @parameter IS_INPUT | parâmetros de entreda
    "! @parameter RV_RETURN   | Mensagem de retorno
  methods BUSCA_FATURA
    importing
      !IS_INPUT type ZCLMM_DT_FATURA
    exporting
      !ES_OUTPUT type ZCLMM_MT_PEDIDO_COMPRA
    returning
      value(RV_RETURN) type STRING .
    "! Método para Criar pedido
    "! @parameter IS_INPUT | parâmetros de entreda
  methods GERA_PEDIDO
    importing
      !IS_INPUT type ZCLMM_MT_PEDIDO_COMPRA
    exporting
      !ET_RETURN type BAPIRET2_T .
protected section.
PRIVATE SECTION.

  DATA gt_faturas TYPE zclmm_dt_pedido_compra_fat_tab .
  DATA gs_header TYPE bapimepoheader .
  DATA gs_headerx TYPE bapimepoheaderx .
  DATA:
    gt_item TYPE TABLE OF bapimepoitem .
  DATA:
    gt_itemx TYPE TABLE OF bapimepoitemx .
  DATA:
    gt_text TYPE TABLE OF bapimepotextheader .
  DATA: gt_text_item TYPE STANDARD TABLE OF bapimepotext.
  DATA gt_return TYPE bapiret2_t .

  "! Chama proxy consulta fatura
  "! @parameter IS_INPUT | parâmetros de entreda
  "! @parameter RV_RETURN   | Mensagem de retorno
  METHODS call_proxy_consulta
    IMPORTING
      !is_input        TYPE zclmm_dt_fatura
    EXPORTING
      !es_output       TYPE zclmm_mt_pedido_compra
    RETURNING
      VALUE(rv_return) TYPE string .
  "! Preenche campos da BAPI
  METHODS mapping_bapi .
  "! Calcula valor total da fatura
  "! @parameter IT_REVERSA | Itens da reversa
  "! @parameter RV_TOTAL   | Valor total
  METHODS calcula_valor_total
    IMPORTING
      !it_reversa     TYPE zclmm_dt_pedido_compra_ite_tab
    RETURNING
      VALUE(rv_total) TYPE string .
  "! Busca tabela de parâmetros
  "! @parameter RT_RETURN | retorno dos parâmetros
  METHODS get_parametros
    RETURNING
      VALUE(rt_return) TYPE zctgmm_param_val .
  "! Busca dados da requisição
  "! @parameter IT_REVERSA | Itens da reversa
  "! @parameter RT_REQUISITION   | Dados da requisição
  METHODS get_requisition
    IMPORTING
      !it_reversa           TYPE zclmm_dt_pedido_compra_ite_tab
    RETURNING
      VALUE(rt_requisition) TYPE zctgmm_requisition .
  "! Chama Bapi de criação de pedido
  METHODS call_bapi .
  "! Busca dados ARGO
  "! @parameter IV_CENTRO | Centro
  "! @parameter IV_CATEGORIA   | Categoria
  "! @parameter RS_ARGO   | Dados ARGO
  METHODS get_argo_parametros
    IMPORTING
      !iv_centro     TYPE werks_r
      !iv_categoria  TYPE knttp
    RETURNING
      VALUE(rs_argo) TYPE ztmm_argo_param .
ENDCLASS.



CLASS ZCLMM_ARGO_PEDIDO_COMPRA IMPLEMENTATION.


  METHOD busca_fatura.

    rv_return = call_proxy_consulta(
                  EXPORTING
                    is_input  = is_input
                  IMPORTING
                    es_output =  es_output ).

  ENDMETHOD.


  METHOD calcula_valor_total.

    DATA: lv_valor_total TYPE p LENGTH 16 DECIMALS 2.

    LOOP AT it_reversa ASSIGNING FIELD-SYMBOL(<fs_reserva>).

      lv_valor_total = lv_valor_total + ( <fs_reserva>-tarifa + <fs_reserva>-outras_taxas ).

    ENDLOOP.

    rv_total = lv_valor_total.

  ENDMETHOD.


  METHOD call_bapi.

    DATA lt_return TYPE TABLE OF bapiret2.

    DATA: lv_btext TYPE char1,
          lv_id    TYPE char7.

    lv_id    = 'ZBENNER'.
    lv_btext = abap_true.

    " Export para classe ZCLMM_PO_BENNER~TEXT_OUTPUT
    EXPORT lv_btext FROM lv_btext TO MEMORY ID lv_id.

    CALL FUNCTION 'BAPI_PO_CREATE1'
      EXPORTING
        poheader     = gs_header
        poheaderx    = gs_headerx
      TABLES
        return       = lt_return
        poitem       = gt_item
        poitemx      = gt_itemx
        potextheader = gt_text
        potextitem   = gt_text_item.

    DELETE FROM MEMORY ID lv_id.

    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WITH KEY type = 'E'.
    IF sy-subrc IS NOT INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.

    APPEND LINES OF lt_return TO gt_return.

    FREE lt_return.

  ENDMETHOD.


  METHOD call_proxy_consulta.

    TRY.

        NEW zclmm_co_si_buscar_fatura_out( )->si_buscar_fatura_out(
            EXPORTING
              output = VALUE #( mt_fatura = VALUE #(  tipo_data     = is_input-tipo_data
                                                      data_inicial  = is_input-data_inicial
                                                      data_final    = is_input-data_final
                                                      status        = is_input-status ) )
            IMPORTING
              input  = es_output ).
*        COMMIT WORK.

        rv_return = TEXT-001.

      CATCH cx_ai_system_fault INTO DATA(lo_message).
        rv_return = lo_message->if_message~get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD gera_pedido.

    gt_faturas[] = CORRESPONDING #( is_input-mt_pedido_compra-faturas-fatura[] ).

    mapping_bapi( ).

    et_return[] = gt_return[].

  ENDMETHOD.


  METHOD get_argo_parametros.

    SELECT bukrs
           werks
           knttp
           lifnr
           bkgrp
           begda
           zterm
           mwskz
        UP TO 1 ROWS
      INTO CORRESPONDING FIELDS OF rs_argo
      FROM ztmm_argo_param
     WHERE werks = iv_centro
       AND knttp = iv_categoria
       AND begda <= sy-datum
       AND active = abap_true.
    ENDSELECT.

  ENDMETHOD.


  METHOD get_parametros.

    SELECT chave3
           low
           high
      INTO CORRESPONDING FIELDS OF TABLE rt_return
      FROM ztca_param_val
     WHERE modulo = 'MM'
       AND chave1 = 'BENNER'
       AND chave2 = 'PEDIDO'.
    IF sy-subrc IS INITIAL.
      SORT rt_return BY chave3.
    ENDIF.

  ENDMETHOD.


  METHOD get_requisition.

    DATA: lr_inf_os TYPE RANGE OF bednr.

    LOOP AT it_reversa ASSIGNING FIELD-SYMBOL(<fs_reserva>).
      APPEND VALUE #( sign   = 'I'
                      option = 'EQ'
                      low    = <fs_reserva>-inf_os ) TO lr_inf_os.
    ENDLOOP.

    IF lr_inf_os[] IS NOT INITIAL.

      SELECT requirementtracking,
             purchaserequisition,
             purchaserequisitionitem,
             purchaserequisitionprice,
             accountassignmentcategory,
             plant
        INTO TABLE @rt_requisition
        FROM c_purchasereqnitem
       WHERE requirementtracking IN @lr_inf_os.

      IF sy-subrc IS INITIAL.
        SORT rt_requisition BY requirementtracking.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD mapping_bapi.

    DATA: lt_lines TYPE STANDARD TABLE OF tline.

    DATA: lv_item         TYPE ebelp,
          lv_datac        TYPE char10,
          lv_data_formart TYPE char10.

    CONSTANTS: lc_id        TYPE thead-tdid       VALUE 'B01',
               lc_langu     TYPE thead-tdspras    VALUE 'P',
               lc_object    TYPE thead-tdobject   VALUE 'EBANH',
               lc_text_id   TYPE tdid             VALUE 'F01',
               lc_text_form TYPE tdformat         VALUE '*',
               lc_traco     TYPE char1            VALUE '-',
               lc_chv3_tipo TYPE ze_param_chave_3 VALUE 'TIPO',
               lc_chv3_moed TYPE ze_param_chave_3 VALUE 'MOEDA',
               lc_chv3_prop TYPE ze_param_chave_3 VALUE 'POPRICE',
               lc_purch_ord TYPE ekorg            VALUE 'OC01'.

    DATA(lt_param) = get_parametros( ).

    LOOP AT gt_faturas ASSIGNING FIELD-SYMBOL(<fs_fatura>).

      DATA(lv_valor_total) = calcula_valor_total( <fs_fatura>-reservas-item_reserva ).

      DATA(lt_requisition) = get_requisition( <fs_fatura>-reservas-item_reserva ).

      DATA(ls_requisition) = VALUE #( lt_requisition[ 1 ] DEFAULT '' ).

      DATA(ls_argo_param) = get_argo_parametros( EXPORTING iv_centro    = ls_requisition-plant
                                                           iv_categoria = ls_requisition-accountassignmentcategory ).

      gs_header = VALUE #( comp_code = ls_argo_param-bukrs
                           doc_type  = VALUE #( lt_param[ chave3 = lc_chv3_tipo ]-low DEFAULT '' )
                           vendor    = ls_argo_param-lifnr
                           pmnttrms  = ls_argo_param-zterm
                           purch_org = lc_purch_ord
                           pur_group = ls_argo_param-bkgrp
                           ref_1     = <fs_fatura>-codigo_interno
                           currency  = VALUE #( lt_param[ chave3 = lc_chv3_moed ]-low DEFAULT '' ) ).

      gs_headerx   = VALUE #( comp_code = abap_true
                              doc_type  = abap_true
                              vendor    = abap_true
                              pmnttrms  = abap_true
                              purch_org = abap_true
                              pur_group = abap_true
                              ref_1     = abap_true
                              currency  = abap_true ).

      CLEAR: lv_item.

      LOOP AT <fs_fatura>-reservas-item_reserva ASSIGNING FIELD-SYMBOL(<fs_reserva>).

        ADD 10 TO lv_item.

        APPEND VALUE bapimepoitem( po_item   = lv_item
                                   net_price = VALUE #( lt_requisition[ requirementtracking = <fs_reserva>-inf_os ]-purchaserequisitionprice DEFAULT '' )
                                   tax_code  = ls_argo_param-mwskz
                                   preq_no   = VALUE #( lt_requisition[ requirementtracking = <fs_reserva>-inf_os ]-purchaserequisition DEFAULT '' )
                                   preq_item = VALUE #( lt_requisition[ requirementtracking = <fs_reserva>-inf_os ]-purchaserequisitionitem DEFAULT '' )
                                   po_price  = VALUE #( lt_param[ chave3 = lc_chv3_prop ]-low DEFAULT '' )
                                   ir_ind    = abap_true
                                   ) TO gt_item.

        APPEND VALUE bapimepoitemx( po_item   = lv_item
                                    net_price = abap_true
                                    tax_code  = abap_true
                                    preq_no   = abap_true
                                    preq_item = abap_true
                                    po_price  = abap_true
                                    ir_ind    = abap_true
                                    ) TO gt_itemx.

        lv_data_formart = <fs_fatura>-data_confirmacao+8(2) && lc_traco && <fs_fatura>-data_confirmacao+5(2) && lc_traco && <fs_fatura>-data_confirmacao(4).

        DATA(lv_number) = VALUE #( lt_requisition[ requirementtracking = <fs_reserva>-inf_os ]-purchaserequisition DEFAULT '' ).

        FREE: lt_lines[].
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = sy-mandt
            id                      = lc_id
            language                = lc_langu
            name                    = CONV tdobname( lv_number )
            object                  = lc_object
          TABLES
            lines                   = lt_lines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc IS INITIAL.
          LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).

            gt_text_item = VALUE #( BASE gt_text_item ( po_item   = lv_item
                                                        text_id   = lc_text_id
                                                        text_form = <fs_lines>-tdformat
                                                        text_line = <fs_lines>-tdline   ) ).

          ENDLOOP.
        ENDIF.

      ENDLOOP.

      APPEND VALUE bapimepotextheader( text_id   = lc_text_id
                                       text_form = lc_text_form
                                       text_line = |{ TEXT-002 } { <fs_fatura>-codigo_interno }| ) TO gt_text.

      APPEND VALUE bapimepotextheader( text_id   = lc_text_id
                                       text_form = lc_text_form
                                       text_line = |{ TEXT-003 } { lv_data_formart }| ) TO gt_text.

      APPEND VALUE bapimepotextheader( text_id   = lc_text_id
                                       text_form = lc_text_form
                                       text_line = |{ TEXT-004 } { lv_valor_total }| ) TO gt_text.

      APPEND VALUE bapimepotextheader( text_id   = lc_text_id
                                       text_form = lc_text_form
                                       text_line = |{ TEXT-005 } { <fs_fatura>-link_pdffatura }| ) TO gt_text.

      call_bapi(  ).

      CLEAR: lv_item,
             lv_valor_total,
             lv_data_formart,
             gs_header,
             gs_headerx.

      FREE: gt_item[],
            gt_itemx[],
            gt_text[],
            lt_requisition[].

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
