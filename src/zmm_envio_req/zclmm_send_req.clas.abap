CLASS zclmm_send_req DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_req,
              banfn TYPE banfn,
              bnfpo TYPE bnfpo,
            END OF ty_req.

    TYPES: tt_header       TYPE REF TO if_purchase_requisition,
           tt_me_int       TYPE TABLE OF zsmm_int_me,
           tt_item         TYPE TABLE OF mereq_item,
           tt_req          TYPE TABLE OF ty_req,
           tt_ext          TYPE STANDARD TABLE OF mereq_item  WITH DEFAULT KEY,
           tt_extx         TYPE STANDARD TABLE OF mereq_itemx WITH DEFAULT KEY,
           tt_req_att      TYPE STANDARD TABLE OF ztmm_envio_req WITH EMPTY KEY,
           tt_extensionout TYPE TABLE OF bapiparex.

    METHODS: execute
      IMPORTING is_header TYPE tt_header
      RAISING   cx_ai_system_fault ,

      get_data
        IMPORTING is_header TYPE mereq_header OPTIONAL
                  it_itens  TYPE tt_item      OPTIONAL
                  it_req    TYPE tt_req       OPTIONAL
        EXPORTING et_msg    TYPE bapiret2_tab
        RAISING
                  cx_ai_system_fault .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_s TYPE c VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_n TYPE c VALUE 'N' ##NO_TEXT.
    CONSTANTS gc_k TYPE c VALUE 'K' ##NO_TEXT.
    CONSTANTS gc_a TYPE c VALUE 'A' ##NO_TEXT.
    CONSTANTS gc_e TYPE c VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_v TYPE c VALUE 'V' ##NO_TEXT.
    CONSTANTS gc_p TYPE c VALUE 'P' ##NO_TEXT.
    CONSTANTS gc_f TYPE c VALUE 'F' ##NO_TEXT.
    CONSTANTS gc_m TYPE c VALUE 'M' ##NO_TEXT.
    CONSTANTS gc_w TYPE c VALUE 'W' ##NO_TEXT.
    CONSTANTS gc_zrtp TYPE bsart VALUE 'ZRTP' ##NO_TEXT.
    CONSTANTS gc_zreg TYPE bsart VALUE 'ZREG' ##NO_TEXT.
    CONSTANTS gc_zrem TYPE bsart VALUE 'ZREM' ##NO_TEXT.
    CONSTANTS gc_nb TYPE bsart VALUE 'NB' ##NO_TEXT.
    CONSTANTS:gc_emp(7) TYPE c VALUE 'EMPRESA' ##NO_TEXT.
    CONSTANTS:gc_cen(6) TYPE c VALUE 'CENTRO' ##NO_TEXT.
    CONSTANTS gc_org TYPE string VALUE 'ORGANIZACAO_COMPRAS' ##NO_TEXT.
    CONSTANTS gc_eban TYPE thead-tdobject VALUE 'EBAN' ##NO_TEXT.
    CONSTANTS gc_ebanh TYPE thead-tdobject VALUE 'EBANH' ##NO_TEXT.
    CONSTANTS gc_b01 TYPE thead-tdid VALUE 'B01' ##NO_TEXT.
    CONSTANTS gc_b04 TYPE thead-tdid VALUE 'B04' ##NO_TEXT.
    CONSTANTS gc_lang TYPE thead-tdspras VALUE 'P' ##NO_TEXT.
    CONSTANTS gc_tp_proc TYPE c VALUE '2' ##NO_TEXT.
    CONSTANTS gc_modulo TYPE ze_param_modulo VALUE 'MM' ##NO_TEXT.
    CONSTANTS gc_chave1 TYPE ze_param_chave VALUE 'ME' ##NO_TEXT.
    CONSTANTS gc_chave2 TYPE ze_param_chave VALUE 'PREQ' ##NO_TEXT.
    CONSTANTS gc_chave3 TYPE ze_param_chave_3 VALUE 'BSART' ##NO_TEXT.
    CONSTANTS gc_1bmatext TYPE te_struc VALUE 'J_1BMATEXT' ##NO_TEXT.
    CONSTANTS gc_num TYPE string VALUE '0123456789' ##NO_TEXT.
    CONSTANTS gc_zmm TYPE char3 VALUE 'ZMM' ##NO_TEXT.
    CONSTANTS gc_erro TYPE bapi_mtype VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_dien TYPE mtart VALUE 'DIEN'.
    CONSTANTS gc_serv TYPE mtart VALUE 'SERV'.

    DATA: gt_int_save  TYPE TABLE OF ztmm_envio_req,
          gt_req       TYPE tt_req_att,
          gt_param     TYPE TABLE OF ztca_param_val,
          gt_header    TYPE zdt_requisicao_compra,
          gt_item      TYPE TABLE OF zitem_requisicao,
          gt_atributo  TYPE TABLE OF zatributo,
          gt_obj_custo TYPE TABLE OF zitem_requisicao_objeto_custo,
          gt_borg      TYPE TABLE OF zborg,
          gt_req_envio TYPE tt_req_att,
          gt_msg       TYPE bapiret2_tab.

    DATA go_num_item TYPE REF TO zclmm_me_conv_num_item .

    "! Fill the table to save
    METHODS save_table
      IMPORTING
        !is_header TYPE mereq_header
        !is_items  TYPE mereq_item .

    "! Commit Work
    METHODS commit_table .

    "! Trigger the interfaces of requisition
    METHODS trigger_int
      IMPORTING
        !it_req TYPE tt_req
      EXPORTING
        !et_msg TYPE bapiret2_tab
      RAISING
        cx_ai_system_fault .

    "! Get text
    METHODS read_text
      IMPORTING
                !iv_pr         TYPE thead-tdname
                !iv_id         TYPE tdid
                !iv_object     TYPE tdobject
      RETURNING VALUE(rv_text) TYPE string.

    "! BAPI to change requisition
    METHODS change_requisicao
      IMPORTING
        !it_req TYPE tt_req
      EXPORTING
        !et_ret TYPE bapiret2_tab.

    "! Send requisition
    METHODS enviar_requisicao
      IMPORTING
        !it_req    TYPE tt_req
      EXPORTING
        !es_return TYPE zmt_requisicao_compra_resp
        !et_msg    TYPE bapiret2_tab .

    "! Send attachment
    METHODS send_attachment
      IMPORTING
        !it_req    TYPE tt_req
        !is_return TYPE zmt_requisicao_compra_resp
      EXPORTING
        !et_msg    TYPE bapiret2_tab .

    "! Fill the data extension
    METHODS fill_extension
      IMPORTING
        !it_req  TYPE tt_req
      EXPORTING
        !et_ext  TYPE tt_ext
        !et_extx TYPE tt_extx .

    "! Converter unit of measure
    METHODS conv_me
      IMPORTING
        !iv_me       TYPE char3
      RETURNING
        VALUE(rv_me) TYPE char3 .

    "! Identify the type service
    METHODS servico
      IMPORTING
                iv_banfn       TYPE banfn
                iv_bnfpo       TYPE bnfpo
      RETURNING VALUE(rv_type) TYPE char1.

    "! Get nbm
    METHODS item_nbm
      IMPORTING
                iv_matnr      TYPE matnr
      CHANGING
                ct_ext        TYPE tt_extensionout
      RETURNING VALUE(rv_nbm) TYPE string.
    METHODS get_prodtype
      IMPORTING
                iv_matnr       TYPE matnr
                iv_producttype TYPE product_type
      RETURNING VALUE(rv_type) TYPE product_type.

ENDCLASS.



CLASS ZCLMM_SEND_REQ IMPLEMENTATION.


  METHOD execute.

    DATA: lt_itens TYPE tt_item.

    TRY.

        DATA(ls_header) = is_header->get_data(  ).
        DATA(lt_item)   = is_header->get_items(  ).

        SELECT item~ekgrp,
               item~bsart
          FROM zi_mm_header_intme \_item[ bsart = @ls_header-bsart ] AS item
         INNER JOIN ztmm_me_header AS header ON header~bsart   = item~bsart
                                            AND header~zz1_int = @abap_true
          INTO TABLE @DATA(lt_header_intme).

        IF sy-subrc EQ 0.
          SORT lt_header_intme BY ekgrp.
        ENDIF.

        DATA(lt_items) = is_header->get_items(  ).

        LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<fs_items>).

          DATA(ls_item) = <fs_items>-item->get_data(  ).

          IF NOT line_exists( lt_header_intme[ ekgrp = ls_item-ekgrp ] ).

            me->save_table( EXPORTING is_header = ls_header is_items = ls_item ).

          ENDIF.

        ENDLOOP.

        IF gt_int_save IS NOT INITIAL.

          me->commit_table( ).

        ENDIF.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD save_table.

    SELECT COUNT(*) FROM ztmm_envio_req
    WHERE tp_proc  EQ gc_tp_proc
      AND doc_sap  EQ is_header-banfn
      AND doc_item EQ is_items-bnfpo.

    IF sy-subrc NE 0.

      gt_int_save =  VALUE #( BASE  gt_int_save (
          tp_proc   = gc_tp_proc
          doc_sap   = is_header-banfn
          doc_item  = is_items-bnfpo
          cod_elmnc = COND #( WHEN is_items-loekz EQ abap_false THEN gc_n ELSE gc_s )
          data_c    = sy-datum
          lib_int   = gc_s

       ) ).

    ENDIF.

  ENDMETHOD.


  METHOD trigger_int.

    me->enviar_requisicao(
    EXPORTING
      it_req = it_req
    IMPORTING
      es_return    = DATA(ls_return)
      et_msg       = et_msg ).

    IF NOT line_exists( et_msg[ type = gc_e ] )
    AND  ls_return-mt_requisicao_compra_resp-result CO gc_num.

      me->change_requisicao( EXPORTING it_req = it_req IMPORTING et_ret = DATA(lt_msg1) ).

      me->send_attachment(
      EXPORTING
          it_req       = it_req
          is_return    = ls_return
      IMPORTING
          et_msg = DATA(lt_msg2)
      ).

      APPEND LINES OF lt_msg1 TO et_msg.
      APPEND LINES OF lt_msg2 TO et_msg.

    ENDIF.

    IF gt_req IS NOT INITIAL.

      UPDATE ztmm_envio_req FROM TABLE gt_req.
      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD commit_table.

    MODIFY ztmm_envio_req FROM TABLE gt_int_save.

    REFRESH: gt_int_save.

  ENDMETHOD.


  METHOD get_data.

    DATA: lt_t001k        TYPE TABLE OF v_t001k_assign,
          lt_acct_assgmt  TYPE TABLE OF zdt_requisicao_compra_c_purch1,
          lt_requisicao   TYPE TABLE OF zdt_requisicao_compra_c_purcha,
          lt_borgs        TYPE zdt_requisicao_compra_borg_tab,
          lt_borg_cen     TYPE zdt_requisicao_compra_bor_tab1,
          lt_borg_emp     TYPE zdt_requisicao_compra_bor_tab2,
          lt_borg_org     TYPE zdt_requisicao_compra_bor_tab3,
          lt_extensionout TYPE TABLE OF bapiparex,
          lt_pritem       TYPE TABLE OF bapimereqitem.

    DATA: lv_banfn TYPE banfn,
          lv_cont  TYPE i.

    CLEAR: gt_msg.

    me->go_num_item = NEW zclmm_me_conv_num_item( ).

    IF it_req IS NOT INITIAL.

      SELECT * FROM zi_mm_cop_purchasereqnitem  AS z
          LEFT JOIN  c_purchasereqnacctassgmt AS c
          ON z~purchaserequisition     = c~purchaserequisition
         AND z~purchaserequisitionitem = c~purchaserequisitionitem
          LEFT JOIN eban AS d
          ON d~banfn = z~purchaserequisition
         AND d~bnfpo = z~purchaserequisitionitem
      FOR ALL ENTRIES IN @it_req
      WHERE z~purchaserequisition     EQ @it_req-banfn
       AND  z~purchaserequisitionitem EQ @it_req-bnfpo
          INTO TABLE @DATA(lt_me_cds).

      IF sy-subrc EQ 0.

        SORT lt_me_cds BY z-purchaserequisition
                          z-purchaserequisitionitem ASCENDING.

        SELECT matkl, wgbez60 FROM t023t
          FOR ALL ENTRIES IN @lt_me_cds
          WHERE matkl = @lt_me_cds-z-materialgroup
          INTO TABLE @DATA(lt_desc_group).


        SELECT matnr, mtuse FROM mbew
            FOR ALL ENTRIES IN @lt_me_cds
            WHERE matnr = @lt_me_cds-z-material
            INTO TABLE @DATA(lt_mat).


        CALL FUNCTION 'VIEW_GET_DATA'
          EXPORTING
            view_name = 'V_T001K_ASSIGN'
          TABLES
            data      = lt_t001k.

        CALL FUNCTION 'BAPI_PR_GETDETAIL'
          EXPORTING
            number       = it_req[ 1 ]-banfn
          TABLES
            pritem       = lt_pritem
            extensionout = lt_extensionout.

        LOOP AT lt_me_cds ASSIGNING FIELD-SYMBOL(<fs_cds>) GROUP BY (
             purchaserequisition     = <fs_cds>-z-purchaserequisition
             purchaserequisitionitem = <fs_cds>-z-purchaserequisitionitem
             size = GROUP SIZE
             index = GROUP INDEX )
             ASSIGNING FIELD-SYMBOL(<gfs_group>) .

          LOOP AT GROUP <gfs_group> ASSIGNING FIELD-SYMBOL(<gfs_grup>) .

            IF  lv_banfn NE <gfs_grup>-z-purchaserequisition AND
                lv_banfn NE space.

              gt_header-purchase_requisition = lv_banfn.

              me->trigger_int(
                EXPORTING
                  it_req = it_req
                IMPORTING
                  et_msg = DATA(lt_return)              ).

              APPEND LINES OF lt_return TO gt_msg.

              CLEAR: gt_header.

            ENDIF.

            lv_banfn = <gfs_grup>-z-purchaserequisition.

            lv_cont = lv_cont + 1.

            IF lv_cont EQ 1.

              IF gt_header IS INITIAL.

                gt_header = VALUE #(
*                status                     = COND #( WHEN <gfs_grup>-c-isdeleted IS INITIAL THEN 0 ELSE 3 )
                status                     = COND #( WHEN <gfs_grup>-c-isdeleted IS INITIAL THEN 0 ELSE 133 )
                purchase_requisition       = <gfs_grup>-z-purchaserequisition
                obs_cli                    = read_text( EXPORTING iv_pr = CONV #( <gfs_grup>-z-PurchaseRequisition ) iv_id = gc_b01 iv_object = gc_ebanh )
                purchase_requisition_type  = <gfs_grup>-z-purchaserequisitiontype
                is_deleted                 = COND #( WHEN NOT line_exists( lt_me_cds[ c-isdeleted = space ] ) THEN gc_s ELSE gc_n ) ).

              ENDIF.

              APPEND VALUE #(
                        codigo_borg = COND #( WHEN <gfs_grup>-z-accountassignmentcategory NE space
                                               AND <gfs_grup>-c-companycode IS INITIAL             THEN VALUE #( lt_t001k[ werks = <gfs_grup>-z-plant ]-bukrs OPTIONAL )
                                              WHEN <gfs_grup>-z-accountassignmentcategory NE space THEN <gfs_grup>-c-companycode
                                              WHEN lt_t001k IS NOT INITIAL                         THEN  VALUE #( lt_t001k[ werks = <gfs_grup>-z-plant ]-bukrs OPTIONAL ) )
                        campo_vent = gc_emp
                 ) TO lt_borg_emp.

              APPEND VALUE #(
                      codigo_borg = <gfs_grup>-z-plant
                      campo_vent  = gc_cen
               ) TO lt_borg_cen.

              APPEND VALUE #(
                      codigo_borg = <gfs_grup>-z-PurchasingOrganization
                      campo_vent  = gc_org
               ) TO lt_borg_org.

              APPEND VALUE #(
                    borg_empresa             = lt_borg_emp[]
                    borg_centro              = lt_borg_cen[]
                    borg_organizacao_compras = lt_borg_org[]
              ) TO lt_borgs.


              DATA(lv_prodtype) =  get_prodtype( iv_matnr       = <gfs_grup>-z-material
                                                 iv_producttype = <gfs_grup>-z-producttype ) .

              APPEND  VALUE #(
                 is_deleted                     = COND #( WHEN <gfs_grup>-c-isdeleted EQ space THEN gc_n ELSE gc_s )
                 requested_quantity             = <gfs_grup>-z-requestedquantity
                 purchase_requisition_item_text = <gfs_grup>-z-purchaserequisitionitemtext
                 base_unit                      = conv_me( <gfs_grup>-z-baseunit )
                 material_group                 = <gfs_grup>-z-materialgroup
                 grupo_produto                  = VALUE #( lt_desc_group[ matkl = <gfs_grup>-z-materialgroup ]-wgbez60 OPTIONAL )
                 purchase_requisition_price     = <gfs_grup>-z-purchaserequisitionprice
                 alteracao                      = gc_n
                 purchase_requisition_item      = <gfs_grup>-z-purchaserequisitionitem
                 requisitioner_name             = <gfs_grup>-z-requisitionername
                 pur_reqn_item_currency         = <gfs_grup>-z-purreqnitemcurrency
                 aplicacao_material             = VALUE #( lt_mat[ matnr = <gfs_grup>-z-material ]-mtuse OPTIONAL )
                 material                       = <gfs_grup>-z-material
                 nbm                            = item_nbm( EXPORTING iv_matnr = <gfs_grup>-z-material CHANGING ct_ext = lt_extensionout )
*                 status                         = COND #( WHEN <gfs_grup>-c-isdeleted IS INITIAL THEN 0 ELSE 3 )
                 status                         = COND #( WHEN <gfs_grup>-c-isdeleted IS INITIAL THEN 0 ELSE 113 )
                 obs_cli                        = read_text( EXPORTING iv_pr = CONV #( <gfs_grup>-z-purchasereqnitemuniqueid ) iv_id = gc_b01 iv_object = gc_eban )
                 obs_item                       = read_text( EXPORTING iv_pr = CONV #( <gfs_grup>-z-purchasereqnitemuniqueid ) iv_id = gc_b04 iv_object = gc_eban )
                 account_assignment_category    = COND #( WHEN <gfs_grup>-z-accountassignmentcategory IS INITIAL THEN gc_v ELSE <gfs_grup>-z-accountassignmentcategory )
                 purchasing_group               = <gfs_grup>-z-purchasinggroup
                 origem_material                 = VALUE #( lt_pritem[ preq_item = <gfs_grup>-c-purchaserequisitionitem ]-preq_price OPTIONAL )
                 purchase_contract               = <gfs_grup>-z-purchasecontract
                 purchase_contract_item          = <gfs_grup>-z-purchasecontractitem
                 plant                           = <gfs_grup>-z-plant
                 product_type                    = COND #( WHEN lv_prodtype EQ 1 THEN gc_n
                                                           WHEN lv_prodtype EQ 2 THEN gc_s )
                 delivery_date                   = COND #( WHEN lv_prodtype EQ 1 THEN <gfs_grup>-z-deliverydate )
                 performance_period_start_date   = COND #( WHEN lv_prodtype EQ 2 THEN <gfs_grup>-z-performanceperiodstartdate )
                 performance_period_end_date     = COND #( WHEN lv_prodtype EQ 2 THEN <gfs_grup>-z-PerformancePeriodEndDate )
                 servico                         = servico( EXPORTING iv_banfn = <gfs_grup>-z-purchaserequisition iv_bnfpo = <gfs_grup>-z-PurchaseRequisitionItem )
                 entrada_mercadoria              = <gfs_grup>-z-GoodsReceiptIsExpected
                 borgs                           = lt_borgs[]
                 ernam                           = <gfs_grup>-z-createdbyuser
                 emlif                           = <gfs_grup>-d-emlif
              ) TO lt_requisicao.

            ENDIF.

            APPEND VALUE #(
               quantity            = <gfs_grup>-c-quantity
               glaccount           = <gfs_grup>-c-glaccount
               cost_center         = COND #( WHEN <gfs_grup>-z-accountassignmentcategory = gc_k THEN <gfs_grup>-c-costcenter )
               master_fixed_asset  = COND #( WHEN <gfs_grup>-z-accountassignmentcategory = gc_a THEN <gfs_grup>-c-masterfixedasset )
               fixed_asset         = COND #( WHEN <gfs_grup>-z-accountassignmentcategory = gc_a THEN <gfs_grup>-c-fixedasset )
               order_id            = COND #( WHEN <gfs_grup>-z-accountassignmentcategory = gc_f THEN <gfs_grup>-c-orderid )
               wbselement          = COND #( WHEN <gfs_grup>-z-accountassignmentcategory = gc_p THEN <gfs_grup>-c-wbselement )
               company_code        = <gfs_grup>-z-multipleacctassgmtdistribution
               multiple_acct_assgmt_distr_per = <gfs_grup>-c-multipleacctassgmtdistrpercent
            ) TO lt_acct_assgmt .

            IF lv_cont EQ <gfs_group>-size.

              APPEND INITIAL LINE TO gt_header-c_purchase_reqn_item ASSIGNING FIELD-SYMBOL(<fs_item>).
              <fs_item> = CORRESPONDING #( lt_requisicao[ 1 ] ).

              IF lt_acct_assgmt IS NOT INITIAL.
                gt_header-c_purchase_reqn_item[ purchase_requisition_item = <gfs_grup>-z-purchaserequisitionitem ]-c_purchase_reqn_acct_assgmt = lt_acct_assgmt. "#EC CI_STDSEQ
              ENDIF.

            ENDIF.

          ENDLOOP.

          CLEAR: lv_cont, lt_acct_assgmt[], lt_requisicao[], lt_borg_emp[], lt_borg_cen[], lt_borgs[], lt_borg_org[].

        ENDLOOP.

        IF gt_header IS NOT INITIAL AND
        gt_header-c_purchase_reqn_item IS NOT INITIAL.

          me->trigger_int(
            EXPORTING
              it_req = it_req
            IMPORTING
              et_msg = DATA(lt_return2)
          ).

          APPEND LINES OF lt_return2 TO gt_msg.

        ENDIF.


      ELSE.
        "Dados não localizados para processamento
        gt_msg = VALUE #( (   id = gc_zmm
                            type = gc_w
                          number = 000
                      message_v1 = TEXT-e01 ) ).
      ENDIF.


    ENDIF.

    et_msg = gt_msg.

  ENDMETHOD.


  METHOD read_text.

    DATA: lt_text TYPE TABLE OF tline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = iv_id
        language                = gc_lang
        name                    = iv_pr
        object                  = iv_object
      TABLES
        lines                   = lt_text
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc NE 0.
      EXIT.
    ELSE.

      LOOP AT lt_text ASSIGNING FIELD-SYMBOL(<fs_text>).

        CONCATENATE rv_text <fs_text>-tdline INTO rv_text SEPARATED BY space.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD enviar_requisicao.

    DATA: lt_req_envio TYPE tt_req_att.

    CLEAR: gt_req[].

    TRY.

        NEW zco_si_enviar_requisicao_compr( )->si_enviar_requisicao_compra_ou(
          EXPORTING
            output = VALUE zmt_requisicao_compra( mt_requisicao_compra = gt_header )
            IMPORTING
              input = es_return
            ).                          " Enviar requisição

        IF es_return-mt_requisicao_compra_resp-result CO gc_num
       AND it_req IS NOT INITIAL.

          SELECT tp_proc, doc_sap, doc_item, cod_elmnc, id_me, data_c, data_i, lib_int  FROM ztmm_envio_req
            FOR ALL ENTRIES IN @it_req
            WHERE doc_sap  = @it_req-banfn
              AND doc_item = @it_req-bnfpo
            INTO TABLE @DATA(lt_envio_req).

          IF sy-subrc EQ 0.

            lt_req_envio  = CORRESPONDING #( lt_envio_req ).

            gt_req = VALUE tt_req_att(
                   FOR <fs_init> IN lt_req_envio
                   WHERE ( doc_sap = gt_header-purchase_requisition )
                 ( VALUE #(
                 BASE  <fs_init>
                    doc_sap = <fs_init>-doc_sap
                    data_i  = sy-datum
                    id_me   = es_return-mt_requisicao_compra_resp-result
                    ) ) ) .

          ENDIF.

        ENDIF.

        "Sucesso ao integrar requisição:
        et_msg = VALUE #( ( id = gc_zmm type = gc_s number = 000
                            message_v1 = TEXT-s01
                            message_v2 = gt_header-purchase_requisition ) ).

        CLEAR: gt_header.

      CATCH cx_ai_system_fault INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zsmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).
        "Error ao tentar enviar requisição
        et_msg = VALUE #( (    id = gc_zmm type = gc_e
                           number = 000
                       message_v1 = TEXT-e02 )
                          ( id    = gc_zmm type = gc_e
                           number = 000
                       message_v1 = ls_erro-fault_text(50)
                       message_v2 = ls_erro-fault_text+50(50)
                       message_v3 = ls_erro-fault_text+100(50)
                       message_v4 = ls_erro-fault_text+150(50) ) ).

    ENDTRY.
  ENDMETHOD.


  METHOD send_attachment.

    TRY.

        " Enviar anexo

        NEW zclmm_get_attachment(  )->get_attach(
        EXPORTING
          iv_classname = TEXT-005
          it_req       = gt_req "gt_req_envio
          is_ret       = is_return
        IMPORTING
          et_msg = et_msg
          ).

      CATCH cx_ai_system_fault INTO DATA(lo_erro).         "Error enviar requisição

        DATA(ls_erro) = VALUE zsmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        et_msg = VALUE #( (   id          = gc_zmm type =
                              gc_e number = 000
                              message_v1  = TEXT-e03 )
                            ( id          = gc_zmm
                              type        = gc_e
                              number      = 000
                              message_v1  = ls_erro-fault_text ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD change_requisicao.

    IF it_req IS NOT INITIAL.

      SELECT a~*, b~mtart FROM eban AS a
      INNER JOIN mara AS b
      ON a~matnr = b~matnr
      FOR ALL ENTRIES IN @it_req
      WHERE banfn = @it_req-banfn
        AND bnfpo = @it_req-bnfpo
        AND zz1_statu <> 'C'
        AND loekz = ''
        INTO TABLE @DATA(lt_eban).
      IF sy-subrc EQ 0.

        UPDATE eban FROM TABLE @( VALUE #(
           FOR ls_eban IN lt_eban
             ( VALUE #(
                 BASE ls_eban-a
                 zz1_statu   = gc_m
*                 producttype = COND #( WHEN ls_eban-a-producttype IS INITIAL THEN COND #( WHEN  ls_eban-mtart EQ 'DIEN'
*                                                                                            OR  ls_eban-mtart EQ 'SERV'  THEN '02'
*                                                                                                                         ELSE '01' )
*                                                                             ELSE ls_eban-a-producttype )
                                                                             ) ) ) ).

        IF sy-subrc EQ 0.
          COMMIT WORK.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_extension.

    et_ext = VALUE tt_ext( FOR ls_item IN it_req (
                        bnfpo     = ls_item-bnfpo
                        zz1_statu = gc_m
                     ) ).

    et_extx = VALUE tt_extx( FOR ls_ext IN et_ext (
                        bnfpo     = abap_true
                        zz1_statu = abap_true
                     ) ).



  ENDMETHOD.


  METHOD conv_me.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = iv_me
        language       = sy-langu
      IMPORTING
        output         = rv_me
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc NE 0.
      rv_me = iv_me.
    ENDIF.

  ENDMETHOD.


  METHOD servico.

    SELECT SINGLE mtart FROM eban AS a
    INNER JOIN mara AS b
    ON a~matnr = b~matnr
    WHERE a~banfn  EQ @iv_banfn
      AND a~bnfpo  EQ @iv_bnfpo
    INTO @DATA(lv_mtart).

    IF lv_mtart IS NOT INITIAL.

      IF "lv_mtart EQ gc_dien OR
         lv_mtart EQ gc_serv.

        rv_type = gc_s.

      ELSE.
        rv_type = gc_n.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD item_nbm.

    rv_nbm =  VALUE #( ct_ext[ structure = gc_1bmatext ]-valuepart1+5(13) OPTIONAL ) .

    IF rv_nbm IS NOT INITIAL.

      DELETE ct_ext WHERE structure  EQ gc_1bmatext
                      AND valuepart1 CS rv_nbm.

    ELSE.

      SELECT SINGLE steuc FROM marc
      WHERE matnr = @iv_matnr
      INTO @rv_nbm.

    ENDIF.

  ENDMETHOD.


  METHOD get_prodtype.

    IF iv_producttype IS INITIAL.

      SELECT SINGLE mtart FROM mara
           WHERE matnr = @iv_matnr
             INTO @DATA(lv_mtart).

      IF sy-subrc EQ 0.

        rv_type = COND #( WHEN lv_mtart EQ 'SERV' THEN 2 ELSE 1 ) .

      ENDIF.

    ELSE.
      rv_type = iv_producttype.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
