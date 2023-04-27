CLASS zclmm_df_create_out_delivery DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      ty_tt_his_dep_fec TYPE SORTED TABLE OF ztmm_his_dep_fec WITH
      NON-UNIQUE KEY client material plant storage_location batch plant_dest storage_location_dest guid.

    METHODS:
      executar
        IMPORTING
          it_his_dep_fec    TYPE ty_tt_his_dep_fec
        RETURNING
          VALUE(rt_retorno) TYPE ty_tt_his_dep_fec.
  PRIVATE SECTION.
    METHODS:
      criar_out_delivery
        IMPORTING
          it_criar_out_delivery TYPE ty_tt_criar_out_delivery
        RETURNING
          VALUE(rt_retorno)     TYPE ty_tt_retorno_out_delivery,

      determina_due_date
        IMPORTING
          is_criar_out_delivery TYPE ty_criar_out_delivery
        RETURNING
          VALUE(rv_retorno)     TYPE ledat,

      determina_stock_trans_items
        IMPORTING
          is_criar_out_delivery TYPE ty_criar_out_delivery
        RETURNING
          VALUE(rt_retorno)     TYPE /syclo/sd_dlvreftosto_tab,

      determina_serial_number
        IMPORTING
          is_criar_out_delivery TYPE ty_criar_out_delivery
        RETURNING
          VALUE(rt_retorno)     TYPE /syclo/sd_dlvserialnumber_tab,

      bapi_outb_delivery_create_sto
        IMPORTING
          iv_due_date          TYPE ledat
          it_stock_trans_items TYPE /syclo/sd_dlvreftosto_tab
          it_serial_number     TYPE /syclo/sd_dlvserialnumber_tab
        RETURNING
          VALUE(rs_retorno)    TYPE ty_retorno_bapi,

      atualizar_his_dep_fec
        IMPORTING
          it_delivery_dados TYPE ty_tt_retorno_out_delivery
          it_his_dep_fec    TYPE ty_tt_his_dep_fec
        RETURNING
          VALUE(rt_retorno) TYPE ty_tt_his_dep_fec,

      busca_dados_criar_out_delivery
        IMPORTING
          it_tt_his_dep_fec TYPE ty_tt_his_dep_fec
        RETURNING
          VALUE(rt_retorno) TYPE ty_tt_criar_out_delivery.
ENDCLASS.



CLASS zclmm_df_create_out_delivery IMPLEMENTATION.
  METHOD executar.
    DATA(lt_dados_criar_out_delivery) = busca_dados_criar_out_delivery( it_his_dep_fec ). "#EC CI_CONV_OK
    atualizar_his_dep_fec(
      it_delivery_dados = criar_out_delivery( lt_dados_criar_out_delivery ) "#EC CI_CONV_OK
      it_his_dep_fec = it_his_dep_fec
    ).
  ENDMETHOD.

  METHOD atualizar_his_dep_fec.
*    LOOP AT it_delivery_dados ASSIGNING FIELD-SYMBOL(<fs_delivery_dados>).
*      LOOP AT <fs_delivery_dados>-retorno_bapi-created_items ASSIGNING FIELD-SYMBOL(<fs_created_items>).
*        DATA(ls_his_dep_fec) = it_his_dep_fec[
*          purchase_order      = <fs_created_items>-ref_doc
*          purchase_order_item = <fs_created_items>-ref_item
*        ].
**        fazer loop it_his_dep_fec
*      ENDLOOP.
*   ENDLOOP.
*        ls_his_dep_fec-out_delivery_document = .
*        APPEND VALUE #(
*          out_delivery_document         = ls_created_items->deliv_numb
*          out_delivery_document_item    = ls_created_items->deliv_item
*        ) TO rt_retorno.
*      ENDLOOP.
RETURN.
    ENDMETHOD.

    METHOD busca_dados_criar_out_delivery.
      RETURN.
    ENDMETHOD.

    METHOD criar_out_delivery.
      LOOP AT it_criar_out_delivery ASSIGNING FIELD-SYMBOL(<fs_criar_out_delivery>).
        DATA(ls_delivery) = bapi_outb_delivery_create_sto(
          iv_due_date          = determina_due_date( <fs_criar_out_delivery> )
          it_stock_trans_items = determina_stock_trans_items( <fs_criar_out_delivery> )
          it_serial_number     = determina_serial_number( <fs_criar_out_delivery> )
        ).
        APPEND VALUE #(
          purchase_order      = <fs_criar_out_delivery>-purchase_order
          retorno_bapi        = ls_delivery
        ) TO rt_retorno.
      ENDLOOP.
    ENDMETHOD.

    METHOD determina_due_date.
      SELECT SINGLE eindt
      FROM @is_criar_out_delivery-eket AS _eket
      WHERE eindt IS NOT INITIAL
      INTO @rv_retorno.
        rv_retorno = COND #(
          WHEN sy-subrc = 0
          THEN rv_retorno
          ELSE sy-datum
        ).
      ENDMETHOD.

      METHOD determina_stock_trans_items.
        rt_retorno = CORRESPONDING #( is_criar_out_delivery-his_dep_fec MAPPING
          ref_doc    = purchase_order
          ref_item   = purchase_order_item
          deliv_numb = delivery_document
          dlv_qty    = used_stock_conv
          sales_unit = unit
        ).
      ENDMETHOD.

      METHOD determina_serial_number.
        LOOP AT is_criar_out_delivery-his_dep_fec ASSIGNING FIELD-SYMBOL(<fs_his_dep_fec>).
          IF line_exists( is_criar_out_delivery-mara[ matnr = <fs_his_dep_fec>-material mtart = 'ZCOM' ] ).
            SELECT _serie~serialno
            FROM @is_criar_out_delivery-serie AS _serie
            WHERE material         = @<fs_his_dep_fec>-material AND
                  plant            = @<fs_his_dep_fec>-plant AND
                  storage_location = @<fs_his_dep_fec>-storage_location AND
                  guid             = @<fs_his_dep_fec>-guid AND
                  process_step     = @<fs_his_dep_fec>-process_step
            INTO TABLE @DATA(lt_serie).

              rt_retorno = VALUE #( FOR <fs_serie> IN lt_serie (
                ref_doc  = <fs_his_dep_fec>-purchase_order
                ref_item = <fs_his_dep_fec>-purchase_order_item
                serialno = <fs_serie>-serialno
              ) ).
            ELSE.
              APPEND VALUE #(
                ref_doc  = <fs_his_dep_fec>-purchase_order
                ref_item = <fs_his_dep_fec>-purchase_order_item
                serialno = VALUE #( is_criar_out_delivery-equi[ KEY sec_key
                  matnr = <fs_his_dep_fec>-material
                  werk  = <fs_his_dep_fec>-destiny_plant
                  lager = <fs_his_dep_fec>-destiny_storage_location ]-sernr OPTIONAL )
              ) TO rt_retorno.
            ENDIF.
          ENDLOOP.
        ENDMETHOD.

        METHOD bapi_outb_delivery_create_sto.
          DATA:
            lt_created_items  TYPE STANDARD TABLE OF bapidlvitemcreated,
            lt_mensagens      TYPE STANDARD TABLE OF bapiret2,
            lv_num_deliveries TYPE vbnum.

          DATA(lt_stock_trans_items) = it_stock_trans_items.
          DATA(lt_serial_number) = it_serial_number.
          CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_STO'  "#EC CI_SEL_NESTED or "#EC CI_SROFC_NESTED
            EXPORTING
              due_date          = iv_due_date
            IMPORTING
              delivery          = rs_retorno-delivery
              num_deliveries    = lv_num_deliveries
            TABLES
              stock_trans_items = lt_stock_trans_items
              serial_numbers    = lt_serial_number
              created_items     = rs_retorno-created_items
              return            = lt_mensagens.

          rs_retorno-mensagens = lt_mensagens.
          IF line_exists( rs_retorno-mensagens[ type = 'E' ] ).
            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
          ELSE.
            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
              EXPORTING
                wait = abap_true.
          ENDIF.
        ENDMETHOD.
ENDCLASS.
