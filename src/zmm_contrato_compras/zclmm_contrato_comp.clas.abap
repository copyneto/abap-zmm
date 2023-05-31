CLASS zclmm_contrato_comp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:

      "! Start the process
      execute
        IMPORTING
          is_contrato TYPE zclmm_mt_contrato_compra
        RAISING
          zcxmm_erro_interface_mes.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: tt_item         TYPE STANDARD TABLE OF bapimeoutitem  WITH DEFAULT KEY,
           tt_itemx        TYPE STANDARD TABLE OF bapimeoutitemx WITH DEFAULT KEY,
           tt_header_t     TYPE STANDARD TABLE OF bapimeouttext  WITH DEFAULT KEY,
           tt_return       TYPE STANDARD TABLE OF bapiret2       WITH DEFAULT KEY,
           tt_controle_int TYPE STANDARD TABLE OF ztmm_control_int WITH DEFAULT KEY,
           tt_contrato     TYPE STANDARD TABLE OF ztmm_me_contrato WITH DEFAULT KEY.


    CONSTANTS: BEGIN OF gc_values,
                 s      TYPE c        VALUE 'S',
                 n      TYPE c        VALUE 'N',
                 l      TYPE c        VALUE 'L',
                 erro   TYPE c        VALUE 'E',
                 u      TYPE knttp    VALUE 'U',
                 tp     TYPE char2    VALUE '10',
                 cd     TYPE c        VALUE 'K',
                 s104   TYPE string   VALUE '104',
                 s3     TYPE string   VALUE '3',
                 s109   TYPE string   VALUE '109',
                 classe TYPE string   VALUE 'ZMM_PRE_PEDIDO',
                 msgno7 TYPE symsgno  VALUE '007',
                 msgno8 TYPE symsgno  VALUE '008',
                 msgno9 TYPE symsgno  VALUE '009',
                 v001   TYPE symsgno  VALUE '001',
               END OF gc_values.

    DATA: gs_contrato TYPE zclmm_dt_contrato_compra.

    METHODS:

      "! Build the structure to do the BAPI's
      build_structure
        RAISING
          zcxmm_erro_interface_mes,

      "! Fill the header structure
      fill_header
        EXPORTING
          es_header  TYPE bapimeoutheader
          es_headerx TYPE bapimeoutheaderx ,

      "! Fill the item structure
      fill_item
        EXPORTING
          et_item  TYPE tt_item
          et_itemx TYPE tt_itemx,

      "! Fill the header text structure
      header_text
        EXPORTING
          et_headet_t TYPE tt_header_t,

      "! Fill the item structure - delete
      fill_item_del
        EXPORTING
          et_item  TYPE tt_item
          et_itemx TYPE tt_itemx,

      "! Execute the BAPI's
      execute_bapi
        IMPORTING
          is_header  TYPE bapimeoutheader
          is_headerx TYPE bapimeoutheaderx
          it_item    TYPE tt_item
          it_itemx   TYPE tt_itemx
          it_htext   TYPE tt_header_t
        RAISING
          zcxmm_erro_interface_mes,

      "! Fill the item structure - change
      fill_item_change
        EXPORTING
          et_item  TYPE tt_item
          et_itemx TYPE tt_itemx,

      "! Call interface 09 - status return
      interface09
        IMPORTING
          it_return TYPE tt_return
        RAISING
          zcxmm_erro_interface_mes,

      "! Save log table
      interface04
        IMPORTING
          it_return TYPE tt_return,

      "! Catch error table
      error_ret
        IMPORTING
          it_return       TYPE tt_return
        EXPORTING
          et_controle_int TYPE tt_controle_int,

      "! Return error raising
      error_raise
        IMPORTING
          is_ret TYPE scx_t100key
        RAISING
          zcxmm_erro_interface_mes,
      conv_mat
        IMPORTING
          is_material      TYPE string
        RETURNING
          VALUE(rv_result) TYPE matnr18 ,
      conv_date
        IMPORTING
          iv_date          TYPE string
        RETURNING
          VALUE(rv_result) TYPE kdatb,
      save_contract,
      conv_price
            IMPORTING
              iv_price_unit    TYPE any
            RETURNING
              value(rv_result) TYPE epein.

ENDCLASS.



CLASS ZCLMM_CONTRATO_COMP IMPLEMENTATION.


  METHOD execute.

    gs_contrato = is_contrato-mt_contrato_compra.

    me->build_structure( ).

  ENDMETHOD.


  METHOD build_structure.

    IF gs_contrato-purchasingdocument IS NOT INITIAL.

      IF gs_contrato-delete_ind = gc_values-s.
        me->fill_item_del( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).
      ELSE.
        me->fill_item_change( IMPORTING et_item = lt_item et_itemx = lt_itemx ).
      ENDIF.

    ELSE.
      me->fill_item( IMPORTING et_item = lt_item et_itemx = lt_itemx ).
    ENDIF.

    me->fill_header( IMPORTING es_header   = DATA(ls_header) es_headerx = DATA(ls_headerx) ).

    me->header_text( IMPORTING et_headet_t = DATA(lt_headet_t) ).

    me->execute_bapi(
    EXPORTING
        is_header   = ls_header
        is_headerx  = ls_headerx
        it_htext    = lt_headet_t
        it_item     = lt_item
        it_itemx    = lt_itemx
      ).


  ENDMETHOD.


  METHOD fill_header.

    es_header = VALUE bapimeoutheader(
        comp_code  = gs_contrato-comp_code
        doc_type   = gs_contrato-doc_type
        creat_date = sy-datum
        created_by = gs_contrato-created_by
        vendor     = gs_contrato-vendor
        langu      = sy-langu
        langu_iso  = sy-langu
        pmnttrms   = gs_contrato-pmnttrms
        purch_org  = gs_contrato-purch_org
        pur_group  = gs_contrato-pur_group
        currency   = gs_contrato-currency
        doc_date   = sy-datum
        vper_start = conv_date( gs_contrato-vper_start )
        vper_end   = conv_date( gs_contrato-vper_end )
        ref_1      = gs_contrato-ref_1
        our_ref    = gs_contrato-our_ref
        incoterms1 = gs_contrato-incoterms1
        incoterms2 = gs_contrato-incoterms1
* BEGIN OF CHANGE - JWSILVA - 26.05.2023
        acum_value = COND #( WHEN gs_contrato-valorfixo is not initial
                             THEN gs_contrato-valorfixo
                             ELSE gs_contrato-acum_value )
* END OF CHANGE - JWSILVA - 26.05.2023
     ).

    es_headerx = VALUE bapimeoutheaderx(
            comp_code    = abap_true
            doc_type     = abap_true
            creat_date   = abap_true
            created_by   = abap_true
            vendor       = abap_true
            pmnttrms     = abap_true
            purch_org    = abap_true
            langu        = abap_true
            langu_iso    = abap_true
            pur_group    = abap_true
            currency     = abap_true
            doc_date     = abap_true
            vper_start   = abap_true
            vper_end     = abap_true
            ref_1        = abap_true
            our_ref      = abap_true
            incoterms1   = abap_true
            incoterms2   = abap_true
            acum_value   = COND #( WHEN es_header-acum_value IS NOT INITIAL THEN abap_true )
    ).

  ENDMETHOD.


  METHOD fill_item.

    et_item = VALUE tt_item(
                FOR ls_item IN gs_contrato-item INDEX INTO lv_index (
                item_no     = ( lv_index * 10 )
                material    = conv_mat( ls_item-material )
*                plant       = ls_item-plant
                target_qty  = ls_item-target_qty
                po_unit     = ls_item-price_unit
                net_price   = ls_item-net_price
                ir_ind      = abap_true
                gr_basediv  = abap_true
                tax_code    = ls_item-tax_code
                acctasscat  = gc_values-u
                 ) ).

    et_itemx = VALUE tt_itemx(
                FOR ls_item1 IN et_item INDEX INTO lv_index (
                item_no     = ls_item1-item_no
                material    = abap_true
*                plant       = abap_true
                target_qty  = abap_true
                po_unit     = abap_true
                net_price   = abap_true
                ir_ind      = abap_true
                gr_basediv  = abap_true
                tax_code    = abap_true
                acctasscat  =  abap_true
                 ) ).

  ENDMETHOD.


  METHOD header_text.

    et_headet_t = VALUE #( BASE et_headet_t (
                  text_id   = 'F01'
                  text_line = gs_contrato-obsheader
                  ) ).

  ENDMETHOD.


  METHOD fill_item_del.

    et_item = VALUE tt_item(
                FOR ls_item IN gs_contrato-item INDEX INTO lv_index (
                item_no     = ( 10 * ls_item-item_no )
                 delete_ind = abap_true
                 ) ).

    et_itemx = VALUE tt_itemx(
                FOR ls_item2 IN et_item INDEX INTO lv_index (
                item_no      = ls_item2-item_no
                item_nox     = abap_true
                delete_ind   = abap_true
                 ) ).

  ENDMETHOD.


  METHOD execute_bapi.

    DATA: lv_ebeln    TYPE ebeln,
          ls_header   TYPE bapimeoutheader,
          ls_headerx  TYPE bapimeoutheaderx,
          lt_item     TYPE STANDARD TABLE OF bapimeoutitem,
          lt_itemx    TYPE STANDARD TABLE OF bapimeoutitemx,
          lt_header_t TYPE STANDARD TABLE OF bapimeouttext,
          lt_return   TYPE STANDARD TABLE OF bapiret2.

    lv_ebeln = gs_contrato-purchasingdocument.

    lt_item     = it_item.
    lt_itemx    = it_itemx.
    lt_header_t = it_htext.

    IF lv_ebeln IS INITIAL.

      CALL FUNCTION 'BAPI_CONTRACT_CREATE'
        EXPORTING
          header             = is_header
          headerx            = is_headerx
        IMPORTING
          purchasingdocument = lv_ebeln
          exp_header         = ls_header
        TABLES
          return             = lt_return
          item               = lt_item
          itemx              = lt_itemx
          header_text        = lt_header_t.

    ELSE.

      CALL FUNCTION 'BAPI_CONTRACT_CHANGE'
        EXPORTING
          purchasingdocument = lv_ebeln
          header             = is_header
          headerx            = is_headerx
        IMPORTING
          exp_header         = ls_header
        TABLES
          return             = lt_return
          item               = lt_item
          itemx              = lt_itemx
          header_text        = lt_header_t.

    ENDIF.

    IF NOT line_exists( lt_return[ type = gc_values-erro ] ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      gs_contrato-purchasingdocument = lv_ebeln.

      me->save_contract(  ).

    ENDIF.

    me->interface09( lt_return ).

  ENDMETHOD.


  METHOD fill_item_change.

    SELECT PurchaseContractItem, Material, OrderQuantityUnit, PurchasingContractDeletionCode FROM I_PurchaseContractItem
    WHERE PurchaseContract EQ @gs_contrato-purchasingdocument
    INTO TABLE @DATA(lt_Purchase).

    et_item = VALUE tt_item(
                    FOR ls_itens IN gs_contrato-item (
                    item_no     = ( 10 * ls_itens-item_no )
                    material    = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN conv_mat( ls_itens-material ) )
                    ematerial   = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN conv_mat( ls_itens-material ) )
                    target_qty  = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN ls_itens-target_qty )
                    po_unit     = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN ls_itens-price_unit )
                    net_price   = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN ls_itens-net_price )
                    ir_ind      = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN abap_true )
                    gr_basediv  = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN abap_true )
                    tax_code    = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN ls_itens-tax_code )
*                    acctasscat  = COND #( WHEN ls_itens-delete_ind EQ gc_values-n  THEN gc_values-u )
                    acctasscat  = gc_values-u
                    delete_ind  = COND #( WHEN ls_itens-delete_ind EQ gc_values-s  THEN abap_true
                                          WHEN ls_itens-delete_ind EQ gc_values-n
                                           AND line_exists( lt_Purchase[ PurchaseContractItem           = ( 10 * ls_itens-item_no )
                                                                         PurchasingContractDeletionCode = gc_values-l ] )  THEN abap_false )
                     ) ).

    et_itemx = VALUE tt_itemx(
                FOR ls_item1 IN et_item (
                item_no     = ls_item1-item_no
                material    = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                ematerial   = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                target_qty  = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                po_unit     = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                net_price   = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                ir_ind      = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                gr_basediv  = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                tax_code    = COND #( WHEN ls_item1-delete_ind IS INITIAL THEN abap_true )
                acctasscat  = abap_true "COND #( WHEN ls_item1-delete_ind IS NOT INITIAL THEN abap_true )
                item_nox    = COND #( WHEN ls_item1-delete_ind IS NOT INITIAL THEN abap_true )
                delete_ind  = COND #( WHEN ls_item1-delete_ind IS NOT INITIAL THEN abap_true
                                      WHEN ls_item1-delete_ind IS INITIAL
                                       AND line_exists( lt_Purchase[ PurchaseContractItem           = ls_item1-item_no
                                                                     PurchasingContractDeletionCode = gc_values-l ] )  THEN abap_true  )
                 ) ).

  ENDMETHOD.


  METHOD interface09.

    TRY.

        NEW zclmm_co_si_processar_mensage1(  )->si_processar_mensagem_status_c(
           EXPORTING
           output = VALUE zclmm_mt_mensagem_status_contr( mt_mensagem_status_contrato =
                    VALUE zclmm_dt_mensagem_status_contr(
                            ebeln         = gs_contrato-purchasingdocument
                            ihrez         = gs_contrato-ref_1
                            lifnr         = gs_contrato-vendor
                            status        = COND #( WHEN NOT line_exists( it_return[ type = gc_values-erro ] ) AND gs_contrato-delete_ind EQ gc_values-s THEN gc_values-s3
                                                    WHEN NOT line_exists( it_return[ type = gc_values-erro ] ) AND gs_contrato-delete_ind IS INITIAL     THEN gc_values-s104
                                                                                              ELSE gc_values-s109 )
                            motivo_recusa = REDUCE string( INIT lv_desc TYPE string FOR ls_ret IN it_return WHERE ( type   = gc_values-erro
                                                                                                                AND number <> gc_values-v001 ) NEXT lv_desc = lv_desc && | | &&  ls_ret-message )

           ) )
         ).

      CATCH cx_ai_system_fault.
        me->error_raise( is_ret = VALUE scx_t100key( msgid = gc_values-classe msgno = gc_values-msgno9 ) ).
    ENDTRY.


    IF line_exists( it_return[ type = gc_values-erro ] ).
      me->interface04( it_return ).
    ENDIF.

  ENDMETHOD.


  METHOD interface04.

    me->error_ret( EXPORTING it_return = it_return IMPORTING et_controle_int = DATA(lt_controle_int) ).

    IF lt_controle_int IS NOT INITIAL.

      MODIFY ztmm_control_int FROM  TABLE lt_controle_int.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD error_ret.

    DATA: lv_text TYPE string,
          lv_item TYPE char5.

    LOOP AT it_return ASSIGNING FIELD-SYMBOL(<fs_return>) GROUP BY (
         row   = <fs_return>-row
         size  = GROUP SIZE
         index = GROUP INDEX
     )
     INTO DATA(lt_grp).

      LOOP AT GROUP lt_grp INTO DATA(ls_grp).

        lv_text = lv_text && | | && ls_grp-message.
        lv_item = ls_grp-message_v2.

      ENDLOOP.

      et_controle_int = VALUE #( BASE et_controle_int (
            tp_processo   = gc_values-tp
            categoria_doc = gc_values-cd
            doc_sap       = gs_contrato-purchasingdocument
            item_doc      = lv_item
            dt_integracao = sy-datum
            log           = lv_text
            ) ).

      CLEAR: lv_text, lv_item.

    ENDLOOP.

  ENDMETHOD.


  METHOD error_raise.

    RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
      EXPORTING
        textid = VALUE #( msgid = is_ret-msgid
                          msgno = is_ret-msgno
                          ).

  ENDMETHOD.


  METHOD conv_mat.

    UNPACK is_material TO rv_result.

  ENDMETHOD.


  METHOD conv_date.

    DATA(lv_dats) = iv_date(10).

    REPLACE ALL OCCURRENCES OF '-' IN lv_dats WITH ' '.
    CONDENSE lv_dats NO-GAPS.

    rv_result = lv_dats.

  ENDMETHOD.


  METHOD save_contract.

    DATA(lt_contrato) = VALUE tt_contrato( FOR ls_item IN gs_contrato-item (
                                              doc_sap       = gs_contrato-purchasingdocument
                                              item_doc      = ( 10 * ls_item-item_no )
                                              doc_me        = gs_contrato-ref_1
                                              lifnr         = gs_contrato-vendor
                                              dt_criacao    = sy-datum
                                              dt_integracao = sy-datum
                                          ) ).

    IF lt_contrato IS NOT INITIAL.

      MODIFY ztmm_me_contrato FROM TABLE lt_contrato.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD conv_price.
    RETURN.
  ENDMETHOD.
ENDCLASS.
