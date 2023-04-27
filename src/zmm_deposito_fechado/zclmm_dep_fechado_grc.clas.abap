class ZCLMM_DEP_FECHADO_GRC definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_BADI_GET_PROCESS .
  interfaces /XNFE/IF_BADI_INVOICE_ENHANCE .
  interfaces IF_BADI_INTERFACE .

  methods MB_CREATE_GOODS_MOVEMENT_ENHA
    importing
      !IT_MSEG type TY_T_MSEG .
  methods MB_CREATE_GOODS_MOVEMENT_TRANS
    importing
      !IT_MSEG type TY_T_MSEG .
  methods MB_CREATE_GOODS_MOVEMENT_VENDA
    importing
      !IT_IMSEG type TY_T_IMSEG .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_DEP_FECHADO_GRC IMPLEMENTATION.


  method /XNFE/IF_BADI_GET_PROCESS~GET_BUSINESS_PROCESS.

EV_PROCTYP = IV_PROCTYP.

* debug( ).

  endmethod.


  METHOD /xnfe/if_badi_invoice_enhance~invoice_enhance.

    CHECK 1 = 2.
    TYPES:
      BEGIN OF ty_ekpo_key,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_ekpo_key,
      BEGIN OF ty_ekko_key,
        ebeln TYPE ebeln,
      END OF ty_ekko_key,
      BEGIN OF ty_prm_dep_fec,
        origin_plant            TYPE werks_d,
        origin_storage_location TYPE lgort_d,
        destiny_plant           TYPE werks_d,
      END OF ty_prm_dep_fec.

    DATA: lt_ekko_key        TYPE TABLE OF ty_ekko_key,
          lt_ekpo_key        TYPE TABLE OF ty_ekpo_key,
          lt_prm_dep_fec_key TYPE TABLE OF ty_prm_dep_fec.

    lt_ekko_key = VALUE #( FOR ls_nfe_in_item IN it_nfe_in_item WHERE ( ponumber IS NOT INITIAL ) ( ebeln = ls_nfe_in_item-ponumber ) ).

    lt_ekpo_key = VALUE #( FOR ls_nfe_in_item IN it_nfe_in_item WHERE ( ponumber IS NOT INITIAL ) ( ebeln = ls_nfe_in_item-ponumber ebelp = ls_nfe_in_item-poitem ) ).

    SORT lt_ekko_key. DELETE ADJACENT DUPLICATES FROM lt_ekko_key.
    SORT lt_ekpo_key. DELETE ADJACENT DUPLICATES FROM lt_ekpo_key.

    CHECK lt_ekko_key IS NOT INITIAL.

    SELECT ebeln, bsart
      FROM ekko
      FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
      INTO TABLE @DATA(lt_ekko_data).

    SELECT ebeln, ebelp, werks, lgort, emlif, matnr, menge, meins
      FROM ekpo
      FOR ALL ENTRIES IN @lt_ekpo_key
      WHERE ebeln = @lt_ekpo_key-ebeln
        AND ebelp = @lt_ekpo_key-ebelp
        INTO TABLE @DATA(lt_ekpo_data).


    SELECT ebeln, lifn2
     FROM ekpa
     FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
        AND parvw = 'UD'
      INTO TABLE @DATA(lt_ekpa_data).

    SORT lt_ekpa_data BY ebeln.

    lt_prm_dep_fec_key = VALUE #( FOR ls_ekpo_data IN lt_ekpo_data ( origin_plant = ls_ekpo_data-werks
                                                                     origin_storage_location = ls_ekpo_data-lgort
                                                                     destiny_plant  = |{ ls_ekpo_data-emlif ALPHA = OUT }|  ) ).

    LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_dat).
      IF line_exists( lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ] ).
        APPEND VALUE #( origin_plant = ls_ekpo_dat->werks
                        origin_storage_location = ls_ekpo_dat->lgort
                        destiny_plant  = |{ lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ]-lifn2  ALPHA = OUT }| ) TO lt_prm_dep_fec_key.
      ENDIF.
    ENDLOOP.

    SORT lt_prm_dep_fec_key. DELETE ADJACENT DUPLICATES FROM lt_prm_dep_fec_key.

    SELECT origin_plant, origin_storage_location, destiny_plant, destiny_storage_location, origin_plant_type, destiny_plant_type
      FROM ztmm_prm_dep_fec
      FOR ALL ENTRIES IN @lt_prm_dep_fec_key
      WHERE origin_plant            = @lt_prm_dep_fec_key-origin_plant
        AND origin_storage_location = @lt_prm_dep_fec_key-origin_storage_location
        AND destiny_plant           = @lt_prm_dep_fec_key-destiny_plant
        INTO TABLE @DATA(lt_prm_dep_fec).


    SORT lt_prm_dep_fec BY origin_plant origin_storage_location destiny_plant destiny_storage_location origin_plant_type destiny_plant_type.


    CHECK lt_prm_dep_fec IS NOT INITIAL.

    DATA: lt_his_dep_fec   TYPE STANDARD TABLE OF ztmm_his_dep_fec,
          lv_destiny_plant TYPE werks_d,
          lv_tabix         TYPE sy-tabix.

    SORT lt_ekpo_data BY ebeln ebelp.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT lt_ekko_data REFERENCE INTO DATA(ls_ekko_dat).
      CLEAR lv_destiny_plant.

      READ TABLE lt_ekpa_data ASSIGNING FIELD-SYMBOL(<fs_ekpa_data>) WITH KEY ebeln = ls_ekko_dat->ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        lv_destiny_plant = |{ <fs_ekpa_data>-lifn2 ALPHA = OUT }|.
      ENDIF.

      READ TABLE lt_ekpo_data TRANSPORTING NO FIELDS WITH KEY ebeln = ls_ekko_dat->ebeln BINARY SEARCH.
      lv_tabix = sy-tabix.

      LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_ref) FROM lv_tabix.

        IF ls_ekpo_ref->ebeln <> ls_ekko_dat->ebeln.
          EXIT.
        ENDIF.

        IF lv_destiny_plant IS INITIAL.
          lv_destiny_plant = |{ ls_ekpo_ref->emlif ALPHA = OUT }|.
        ENDIF.

        READ TABLE lt_prm_dep_fec ASSIGNING FIELD-SYMBOL(<fs_prm_dep_fec>) WITH KEY origin_plant = ls_ekpo_ref->werks
                                                                                      origin_storage_location = ls_ekpo_ref->lgort
                                                                                      destiny_plant = lv_destiny_plant BINARY SEARCH.

        CHECK sy-subrc = 0.

        IF ls_ekpo_ref->ebeln IS NOT INITIAL.
          SELECT COUNT(*) FROM ztmm_his_dep_fec "#EC CI_SEL_NESTED
            WHERE main_purchase_order      = @ls_ekpo_ref->ebeln
              AND main_purchase_order_item = @ls_ekpo_ref->ebelp.
          IF sy-subrc = 0.
            CONTINUE.
          ENDIF.
        ENDIF.

        APPEND VALUE #(
          material              = ls_ekpo_ref->matnr
          plant                 = ls_ekpo_ref->werks
          storage_location      = ls_ekpo_ref->lgort
          plant_dest            = <fs_prm_dep_fec>-destiny_plant
          storage_location_dest = <fs_prm_dep_fec>-destiny_storage_location
          process_step          = 'F06'
          status                = '10'
          origin_plant          = <fs_prm_dep_fec>-origin_plant
          origin_plant_type     = <fs_prm_dep_fec>-origin_plant_type
          origin_storage_location = <fs_prm_dep_fec>-origin_storage_location
          destiny_plant         = <fs_prm_dep_fec>-destiny_plant
          destiny_plant_type    = <fs_prm_dep_fec>-destiny_plant_type
          destiny_storage_location = <fs_prm_dep_fec>-destiny_storage_location
          origin_unit           = ls_ekpo_ref->meins
          unit                  = ls_ekpo_ref->meins
*    use_available         = ls_dep_fec-
          available_stock       = ls_ekpo_ref->menge
          used_stock            = ls_ekpo_ref->menge
          used_stock_conv       = ls_ekpo_ref->menge
        main_purchase_order   = ls_ekpo_ref->ebeln
        main_purchase_order_item = ls_ekpo_ref->ebelp
        created_by             = sy-uname
        created_at             = lv_timestamp
      ) TO lt_his_dep_fec.

      ENDLOOP.
    ENDLOOP.

    CHECK lt_his_dep_fec IS NOT INITIAL.

    MODIFY ztmm_his_dep_fec FROM  TABLE lt_his_dep_fec.
    WAIT UP TO 5 SECONDS.

    DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
    lr_adm_emissao_nf_events->bapi_create_documents(
      EXPORTING
        it_historico_key = lt_his_dep_fec
*       iv_update_history = abap_true
      IMPORTING
        et_return        = DATA(lt_return_po)
    ).

    lr_adm_emissao_nf_events->job_delivery(
      EXPORTING
        iv_status = '10'
      IMPORTING
        et_return = DATA(lt_return_delivery)
    ).

    APPEND LINES OF lt_return_po TO lt_return_delivery.

  ENDMETHOD.


  method /XNFE/IF_BADI_INVOICE_ENHANCE~INVOICE_ENHANCE_SC.
  RETURN.
  endmethod.


  METHOD mb_create_goods_movement_enha.

    TYPES:
      BEGIN OF ty_ekpo_key,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_ekpo_key,
      BEGIN OF ty_ekko_key,
        ebeln TYPE ebeln,
      END OF ty_ekko_key,
      BEGIN OF ty_prm_dep_fec,
        origin_plant            TYPE werks_d,
        origin_storage_location TYPE lgort_d,
        destiny_plant           TYPE werks_d,
      END OF ty_prm_dep_fec.

    DATA: lt_ekko_key        TYPE TABLE OF ty_ekko_key,
          lt_ekpo_key        TYPE TABLE OF ty_ekpo_key,
          lt_prm_dep_fec_key TYPE TABLE OF ty_prm_dep_fec,
          lv_guid	           TYPE sysuuid_x16.

    lt_ekko_key = VALUE #( FOR ls_mseg IN it_mseg WHERE ( ebeln IS NOT INITIAL AND bwart = '861' ) ( ebeln = ls_mseg-ebeln ) ). "#EC CI_STDSEQ

    SORT lt_ekko_key. DELETE ADJACENT DUPLICATES FROM lt_ekko_key.

    CHECK lt_ekko_key IS NOT INITIAL.

    SELECT ebeln, bsart
      FROM ekko
      FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
        AND bsart = 'UB'
      INTO TABLE @DATA(lt_ekko_data).

    CHECK lt_ekko_data IS NOT INITIAL.

*   DO.
*     data(lv_dbg) = abap_true.
*   ENDDO.

    LOOP AT it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).
      READ TABLE lt_ekko_data TRANSPORTING NO FIELDS WITH KEY ebeln = <fs_mseg>-ebeln BINARY SEARCH.
      CHECK sy-subrc = 0.
      APPEND VALUE #( ebeln = <fs_mseg>-ebeln ebelp = <fs_mseg>-ebelp ) TO lt_ekpo_key.
    ENDLOOP.

    SORT lt_ekpo_key. DELETE ADJACENT DUPLICATES FROM lt_ekpo_key.

    CHECK lt_ekpo_key IS NOT INITIAL.

    SELECT ebeln, ebelp, werks, lgort, emlif, matnr, menge, meins
      FROM ekpo
      FOR ALL ENTRIES IN @lt_ekpo_key
      WHERE ebeln = @lt_ekpo_key-ebeln
        AND ebelp = @lt_ekpo_key-ebelp
        INTO TABLE @DATA(lt_ekpo_data).


    SELECT ebeln, lifn2
     FROM ekpa
     FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
        AND parvw = 'ZU'
      INTO TABLE @DATA(lt_ekpa_data).

    SORT lt_ekpa_data BY ebeln.

      lt_prm_dep_fec_key = VALUE #( FOR ls_ekpo_data IN lt_ekpo_data ( origin_plant = ls_ekpo_data-werks
                                                                       origin_storage_location = ls_ekpo_data-lgort
                                                                       destiny_plant  = |{ ls_ekpo_data-emlif ALPHA = OUT }|  ) ).
      LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_dat).
        IF line_exists( lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ] ).
          APPEND VALUE #( origin_plant = ls_ekpo_dat->werks
                          origin_storage_location = ls_ekpo_dat->lgort
                          destiny_plant  = |{ lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ]-lifn2  ALPHA = OUT }| ) TO lt_prm_dep_fec_key.
        ENDIF.
      ENDLOOP.

    SORT lt_prm_dep_fec_key. DELETE ADJACENT DUPLICATES FROM lt_prm_dep_fec_key.

    SELECT origin_plant, origin_storage_location, destiny_plant, destiny_storage_location, origin_plant_type, destiny_plant_type, guid
      FROM ztmm_prm_dep_fec
      FOR ALL ENTRIES IN @lt_prm_dep_fec_key
      WHERE origin_plant            = @lt_prm_dep_fec_key-origin_plant
        AND origin_storage_location = @lt_prm_dep_fec_key-origin_storage_location
        AND destiny_plant           = @lt_prm_dep_fec_key-destiny_plant
        INTO TABLE @DATA(lt_prm_dep_fec).


    SORT lt_prm_dep_fec BY origin_plant origin_storage_location destiny_plant destiny_storage_location origin_plant_type destiny_plant_type.


    CHECK lt_prm_dep_fec IS NOT INITIAL.

    DATA: lt_his_dep_fec   TYPE STANDARD TABLE OF ztmm_his_dep_fec,
          lv_destiny_plant TYPE werks_d,
          lv_tabix         TYPE sy-tabix.

    SORT lt_ekpo_data BY ebeln ebelp.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT it_mseg ASSIGNING <fs_mseg>.

      READ TABLE lt_ekko_data REFERENCE INTO DATA(ls_ekko_dat) WITH KEY ebeln = <fs_mseg>-ebeln BINARY SEARCH.

      CHECK sy-subrc = 0.

      CLEAR lv_destiny_plant.

      READ TABLE lt_ekpa_data ASSIGNING FIELD-SYMBOL(<fs_ekpa_data>) WITH KEY ebeln = <fs_mseg>-ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        lv_destiny_plant = |{ <fs_ekpa_data>-lifn2 ALPHA = OUT }|.
      ENDIF.

      READ TABLE lt_ekpo_data TRANSPORTING NO FIELDS WITH KEY ebeln = <fs_mseg>-ebeln
                                                              ebelp = <fs_mseg>-ebelp BINARY SEARCH.
      lv_tabix = sy-tabix.

      LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_ref) FROM lv_tabix.

        IF ls_ekpo_ref->ebeln <> <fs_mseg>-ebeln OR ls_ekpo_ref->ebelp <> <fs_mseg>-ebelp.
          EXIT.
        ENDIF.

        IF lv_destiny_plant IS INITIAL.
          lv_destiny_plant = |{ ls_ekpo_ref->emlif ALPHA = OUT }|.
        ENDIF.

        READ TABLE lt_prm_dep_fec ASSIGNING FIELD-SYMBOL(<fs_prm_dep_fec>) WITH KEY origin_plant = ls_ekpo_ref->werks
                                                                                      origin_storage_location = ls_ekpo_ref->lgort
                                                                                      destiny_plant = lv_destiny_plant BINARY SEARCH.

        CHECK sy-subrc = 0.

        TRY.
            lv_guid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_root INTO DATA(lo_root).
            CONTINUE.
        ENDTRY.

        IF ls_ekpo_ref->ebeln IS NOT INITIAL.
          SELECT COUNT(*) FROM ztmm_his_dep_fec      "#EC CI_SEL_NESTED
            WHERE main_purchase_order         = @ls_ekpo_ref->ebeln
              AND main_purchase_order_item    = @ls_ekpo_ref->ebelp
              AND main_material_document      = @<fs_mseg>-mblnr
              AND main_material_document_year = @<fs_mseg>-mjahr
              AND main_material_document_item = @<fs_mseg>-zeile.
          IF sy-subrc = 0.
            CONTINUE.
          ENDIF.
        ENDIF.

        APPEND VALUE #(
          guid = lv_guid
          material              = ls_ekpo_ref->matnr
          plant                 = ls_ekpo_ref->werks
          storage_location      = ls_ekpo_ref->lgort
          plant_dest            = <fs_prm_dep_fec>-destiny_plant
          storage_location_dest = <fs_prm_dep_fec>-destiny_storage_location
          process_step          = 'F06'
          status                = '10'
          prm_dep_fec_id        = <fs_prm_dep_fec>-guid
          origin_plant          = <fs_prm_dep_fec>-origin_plant
          origin_plant_type     = <fs_prm_dep_fec>-origin_plant_type
          origin_storage_location = <fs_prm_dep_fec>-origin_storage_location
          batch                 = <fs_mseg>-charg
          destiny_plant         = <fs_prm_dep_fec>-destiny_plant
          destiny_plant_type    = <fs_prm_dep_fec>-destiny_plant_type
          destiny_storage_location = <fs_prm_dep_fec>-destiny_storage_location
          origin_unit           = ls_ekpo_ref->meins
          unit                  = ls_ekpo_ref->meins
*    use_available         = ls_dep_fec-
          available_stock       = ls_ekpo_ref->menge
          used_stock            = ls_ekpo_ref->menge
          used_stock_conv       = ls_ekpo_ref->menge
        main_purchase_order   = ls_ekpo_ref->ebeln
        main_purchase_order_item = ls_ekpo_ref->ebelp
        main_material_document   = <fs_mseg>-mblnr
        main_material_document_year = <fs_mseg>-mjahr
        main_material_document_item = <fs_mseg>-zeile
        created_by             = sy-uname
        created_at             = lv_timestamp
      ) TO lt_his_dep_fec.

      ENDLOOP.
    ENDLOOP.

    CHECK lt_his_dep_fec IS NOT INITIAL.

    CALL FUNCTION 'ZFMMM_CRIAR_DOCUMENTO' STARTING NEW TASK 'DEP_FECHADO'
      EXPORTING
        it_his_dep_fec = lt_his_dep_fec.

  ENDMETHOD.


  METHOD mb_create_goods_movement_trans.

    TYPES:
      BEGIN OF ty_ekpo_key,
        ebeln TYPE ebeln,
        ebelp TYPE ebelp,
      END OF ty_ekpo_key,
      BEGIN OF ty_ekko_key,
        ebeln TYPE ebeln,
      END OF ty_ekko_key,
      BEGIN OF ty_prm_dep_fec,
        origin_plant            TYPE werks_d,
        origin_storage_location TYPE lgort_d,
        destiny_plant           TYPE werks_d,
      END OF ty_prm_dep_fec.

    DATA: lt_ekko_key        TYPE TABLE OF ty_ekko_key,
          lt_ekpo_key        TYPE TABLE OF ty_ekpo_key,
          lt_prm_dep_fec_key TYPE TABLE OF ty_prm_dep_fec.

    lt_ekko_key = VALUE #( FOR ls_mseg IN it_mseg WHERE ( ebeln IS NOT INITIAL ) ( ebeln = ls_mseg-ebeln ) ).
    lt_ekpo_key = VALUE #( FOR ls_msegp IN it_mseg WHERE ( ebeln IS NOT INITIAL ) ( ebeln = ls_msegp-ebeln ebelp = ls_msegp-ebelp ) ).


    SORT lt_ekko_key. DELETE ADJACENT DUPLICATES FROM lt_ekko_key.
    SORT lt_ekpo_key. DELETE ADJACENT DUPLICATES FROM lt_ekpo_key.

    CHECK lt_ekko_key IS NOT INITIAL.

    SELECT ebeln, bsart
      FROM ekko
      FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
      INTO TABLE @DATA(lt_ekko_data).

    SELECT ebeln, ebelp, werks, lgort, emlif, matnr, menge, meins
      FROM ekpo
      FOR ALL ENTRIES IN @lt_ekpo_key
      WHERE ebeln = @lt_ekpo_key-ebeln
        AND ebelp = @lt_ekpo_key-ebelp
        INTO TABLE @DATA(lt_ekpo_data).


*    DATA(lo_param) = NEW zclca_tabela_parametros( ).
*    DATA:lt_parvw_range     TYPE RANGE OF parvw.
*    CLEAR lt_parvw_range.
*    TRY.
*        lo_param->m_get_range(
*          EXPORTING
*            iv_modulo = 'MM'
*            iv_chave1 = 'FUNCAO_PARCEIRO'
*            iv_chave2 = 'DEPOSITO_FECHADO'
*          IMPORTING
*            et_range  = lt_parvw_range ).
*      CATCH zcxca_tabela_parametros.
*        EXIT.
*    ENDTRY.

    SELECT ebeln, lifn2
     FROM ekpa
     FOR ALL ENTRIES IN @lt_ekko_key
      WHERE ebeln = @lt_ekko_key-ebeln
*        AND parvw IN @lt_parvw_range "= 'UD'
        AND parvw = 'UD'
      INTO TABLE @DATA(lt_ekpa_data).

    SORT lt_ekpa_data BY ebeln.

    lt_prm_dep_fec_key = VALUE #( FOR ls_ekpo_data IN lt_ekpo_data ( origin_plant = ls_ekpo_data-werks
                                                                     origin_storage_location = ls_ekpo_data-lgort
                                                                     destiny_plant  = |{ ls_ekpo_data-emlif ALPHA = OUT }|  ) ).

    LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_dat).
      IF line_exists( lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ] ).
        APPEND VALUE #( origin_plant = ls_ekpo_dat->werks
                        origin_storage_location = ls_ekpo_dat->lgort
                        destiny_plant  = |{ lt_ekpa_data[ ebeln = ls_ekpo_dat->ebeln ]-lifn2  ALPHA = OUT }| ) TO lt_prm_dep_fec_key.
      ENDIF.
    ENDLOOP.

    SORT lt_prm_dep_fec_key. DELETE ADJACENT DUPLICATES FROM lt_prm_dep_fec_key.

    SELECT origin_plant, origin_storage_location, destiny_plant, destiny_storage_location, origin_plant_type, destiny_plant_type, guid
      FROM ztmm_prm_dep_fec
      FOR ALL ENTRIES IN @lt_prm_dep_fec_key
      WHERE origin_plant            = @lt_prm_dep_fec_key-origin_plant
        AND origin_storage_location = @lt_prm_dep_fec_key-origin_storage_location
        AND destiny_plant           = @lt_prm_dep_fec_key-destiny_plant
        INTO TABLE @DATA(lt_prm_dep_fec).


    SORT lt_prm_dep_fec BY origin_plant origin_storage_location destiny_plant destiny_storage_location origin_plant_type destiny_plant_type.


    CHECK lt_prm_dep_fec IS NOT INITIAL.

    DATA: lt_his_dep_fec   TYPE STANDARD TABLE OF ztmm_his_dep_fec,
          lv_destiny_plant TYPE werks_d,
          lv_tabix         TYPE sy-tabix,
          lv_guid	         TYPE sysuuid_x16.

    SORT lt_ekpo_data BY ebeln ebelp.
    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).

      READ TABLE lt_ekko_data REFERENCE INTO DATA(ls_ekko_dat) WITH KEY ebeln = <fs_mseg>-ebeln BINARY SEARCH.

      CHECK sy-subrc = 0.

      CLEAR lv_destiny_plant.

      READ TABLE lt_ekpa_data ASSIGNING FIELD-SYMBOL(<fs_ekpa_data>) WITH KEY ebeln = ls_ekko_dat->ebeln BINARY SEARCH.
      IF sy-subrc = 0.
        lv_destiny_plant = |{ <fs_ekpa_data>-lifn2 ALPHA = OUT }|.
      ENDIF.

      READ TABLE lt_ekpo_data TRANSPORTING NO FIELDS WITH KEY ebeln = <fs_mseg>-ebeln ebelp = <fs_mseg>-ebelp BINARY SEARCH.
      lv_tabix = sy-tabix.

      LOOP AT lt_ekpo_data REFERENCE INTO DATA(ls_ekpo_ref) FROM lv_tabix.

        IF ls_ekpo_ref->ebeln <> <fs_mseg>-ebeln OR ls_ekpo_ref->ebelp <> <fs_mseg>-ebelp.

          EXIT.
        ENDIF.

        IF lv_destiny_plant IS INITIAL.
          lv_destiny_plant = |{ ls_ekpo_ref->emlif ALPHA = OUT }|.
        ENDIF.

        READ TABLE lt_prm_dep_fec ASSIGNING FIELD-SYMBOL(<fs_prm_dep_fec>) WITH KEY origin_plant = ls_ekpo_ref->werks
                                                                                      origin_storage_location = ls_ekpo_ref->lgort
                                                                                      destiny_plant = lv_destiny_plant BINARY SEARCH.

        CHECK sy-subrc = 0.


        TRY.
            lv_guid = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_root INTO DATA(lo_root).
            CONTINUE.
        ENDTRY.

        IF ls_ekpo_ref->ebeln IS NOT INITIAL.
          SELECT COUNT(*) FROM ztmm_his_dep_fec "#EC CI_SEL_NESTED
            WHERE main_purchase_order         = @ls_ekpo_ref->ebeln
              AND main_purchase_order_item    = @ls_ekpo_ref->ebelp
              AND main_material_document      = @<fs_mseg>-mblnr
              AND main_material_document_year = @<fs_mseg>-mjahr
              AND main_material_document_item = @<fs_mseg>-zeile.
          IF sy-subrc = 0.
            CONTINUE.
          ENDIF.
        ENDIF.

        APPEND VALUE #(
          guid = lv_guid
          material              = ls_ekpo_ref->matnr
          plant                 = ls_ekpo_ref->werks
          storage_location      = ls_ekpo_ref->lgort
          plant_dest            = <fs_prm_dep_fec>-destiny_plant
          storage_location_dest = <fs_prm_dep_fec>-destiny_storage_location
          process_step          = 'F06'
          status                = '10'
          prm_dep_fec_id        = <fs_prm_dep_fec>-guid
          origin_plant          = <fs_prm_dep_fec>-origin_plant
          origin_plant_type     = <fs_prm_dep_fec>-origin_plant_type
          origin_storage_location = <fs_prm_dep_fec>-origin_storage_location
          batch                 = <fs_mseg>-charg
          destiny_plant         = <fs_prm_dep_fec>-destiny_plant
          destiny_plant_type    = <fs_prm_dep_fec>-destiny_plant_type
          destiny_storage_location = <fs_prm_dep_fec>-destiny_storage_location
          origin_unit           = ls_ekpo_ref->meins
          unit                  = ls_ekpo_ref->meins
*    use_available         = ls_dep_fec-
          available_stock       = ls_ekpo_ref->menge
          used_stock            = ls_ekpo_ref->menge
          used_stock_conv       = ls_ekpo_ref->menge
        main_purchase_order   = ls_ekpo_ref->ebeln
        main_purchase_order_item = ls_ekpo_ref->ebelp
        main_material_document   = <fs_mseg>-mblnr
        main_material_document_year = <fs_mseg>-mjahr
        main_material_document_item = <fs_mseg>-zeile
        created_by             = sy-uname
        created_at             = lv_timestamp
      ) TO lt_his_dep_fec.

      ENDLOOP.
    ENDLOOP.

    CHECK lt_his_dep_fec IS NOT INITIAL.

    CALL FUNCTION 'ZFMMM_CRIAR_DOCUMENTO' STARTING NEW TASK 'DEP_FECHADO'
      EXPORTING
        it_his_dep_fec = lt_his_dep_fec.

  ENDMETHOD.


  METHOD mb_create_goods_movement_venda.

*   CHECK 1 = 2.

*    if sy-uname = 'APONCIANO'.
*    DO.
*      DATA(lv_dbg) = abap_true.
*    ENDDO.
*    ENDIF.

    TYPES: BEGIN OF ty_ordem,
             kdauf_sd TYPE kdauf,
           END OF ty_ordem,
           ty_tab_ordem TYPE TABLE OF ty_ordem,
           BEGIN OF ty_prm_dep_fec_key,
             origin_plant            TYPE werks_d,
             origin_storage_location TYPE lgort_d,
             destiny_plant            TYPE werks_d,
           END OF ty_prm_dep_fec_key,
           ty_tab_prm_dep_fec_key TYPE TABLE OF ty_prm_dep_fec_key.


    DATA: lt_ordem           TYPE TABLE OF ty_ordem,
          lt_prm_dep_fec_key TYPE ty_tab_prm_dep_fec_key,
          lt_his_dep_fec     TYPE STANDARD TABLE OF ztmm_his_dep_fec,
          lv_parvw           TYPE parvw,
          lv_werks           TYPE werks_d,
          lt_PARVW_range     TYPE RANGE OF PARVW.

    lt_ordem = VALUE #( FOR ls_imseg IN it_imseg WHERE ( kdauf_sd IS NOT INITIAL ) ( kdauf_sd = ls_imseg-kdauf_sd ) ).

    SORT lt_ordem. DELETE ADJACENT DUPLICATES FROM lt_ordem.
    CHECK lt_ordem IS NOT INITIAL.

    SELECT matnr, matwa, charg, werks, lgort, meins, klmeng, vbeln
      FROM vbap
      FOR ALL ENTRIES IN @lt_ordem
      WHERE vbeln = @lt_ordem-kdauf_sd
      INTO TABLE @DATA(lt_vbap).

            DATA(lo_param) = NEW zclca_tabela_parametros( ).

            TRY.
                lo_param->m_get_range(
                  EXPORTING
                    iv_modulo = 'MM'
                    iv_chave1 = 'FUNCAO_PARCEIRO'
                    iv_chave2 = 'DEPOSITO_FECHADO'
                  IMPORTING
                    et_range  = lt_PARVW_range ).
              CATCH zcxca_tabela_parametros.
            ENDTRY.


    select VBELN, POSNR, PARVW, KUNNR, LIFNR
      FROM VBPA
      FOR ALL ENTRIES IN @lt_ordem
      WHERE vbeln = @lt_ordem-kdauf_sd
        AND parvw IN @lt_PARVW_range
      INTO TABLE @DATA(lt_vbpA).

    CHECK lt_vbpA IS NOT INITIAL.

    lt_prm_dep_fec_key = VALUE #( FOR ls_vba IN lt_vbap ( origin_plant = ls_vba-werks origin_storage_location = ls_vba-lgort ) ).

     LOOP AT lt_vbpA ASSIGNING FIELD-SYMBOL(<fs_vbpA>).
       read TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>) WITH key vbeln = <fs_vbpA>-vbeln BINARY SEARCH.
       check sy-subrc = 0.
       append VALUE #( origin_plant = <fs_vbap>-werks origin_storage_location = <fs_vbap>-lgort destiny_plant = |{ <fs_vbpA>-lifnr  ALPHA = OUT }| ) to lt_prm_dep_fec_key .
      ENDLOOP.

    SORT lt_prm_dep_fec_key. DELETE ADJACENT DUPLICATES FROM lt_prm_dep_fec_key.
    CHECK lt_prm_dep_fec_key IS NOT INITIAL.

    SELECT origin_plant, origin_storage_location, destiny_plant, destiny_storage_location, origin_plant_type, destiny_plant_type, guid
      FROM ztmm_prm_dep_fec
      FOR ALL ENTRIES IN @lt_prm_dep_fec_key
      WHERE origin_plant            = @lt_prm_dep_fec_key-origin_plant
        AND origin_storage_location = @lt_prm_dep_fec_key-origin_storage_location
        and destiny_plant           = @lt_prm_dep_fec_key-destiny_plant
        INTO TABLE @DATA(lt_prm_dep_fec).

    CHECK lt_prm_dep_fec IS NOT INITIAL.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    sort lt_vbpA by vbeln.

    LOOP AT lt_vbap REFERENCE INTO DATA(ls_vbap).

      READ TABLE lt_vbpA ASSIGNING <fs_vbpA> WITH KEY vbeln = ls_vbap->vbeln BINARY SEARCH.
      CHECK <fs_vbpA> is ASSIGNED.

      data(lv_destiny_plant) = |{ <fs_vbpA>-lifnr  ALPHA = OUT }|.
      READ TABLE lt_prm_dep_fec ASSIGNING FIELD-SYMBOL(<fs_prm_dep_fec>) WITH KEY origin_plant = ls_vbap->werks
                                                                                  origin_storage_location = ls_vbap->lgort
                                                                                  destiny_plant = lv_destiny_plant BINARY SEARCH.

      CHECK sy-subrc = 0.

      APPEND VALUE #(
        material              = ls_vbap->matnr
        plant                 = ls_vbap->werks
        storage_location      = ls_vbap->lgort
        plant_dest            = <fs_prm_dep_fec>-destiny_plant
        storage_location_dest = <fs_prm_dep_fec>-destiny_storage_location
        process_step          = 'F02'
        status                = '10'
        prm_dep_fec_id        = <fs_prm_dep_fec>-guid
        origin_plant          = <fs_prm_dep_fec>-origin_plant
        origin_plant_type     = <fs_prm_dep_fec>-origin_plant_type
        origin_storage_location = <fs_prm_dep_fec>-origin_storage_location
        batch                 = ls_vbap->charg
        destiny_plant         = <fs_prm_dep_fec>-destiny_plant
        destiny_plant_type    = <fs_prm_dep_fec>-destiny_plant_type
        destiny_storage_location = <fs_prm_dep_fec>-destiny_storage_location
        origin_unit           = ls_vbap->meins
        unit                  = ls_vbap->meins
*    use_available         = ls_dep_fec-
        available_stock       = ls_vbap->klmeng
        used_stock            = ls_vbap->klmeng
        used_stock_conv       = ls_vbap->klmeng
      created_by             = sy-uname
      created_at             = lv_timestamp
    ) TO lt_his_dep_fec.

    ENDLOOP.

  CHECK lt_his_dep_fec IS NOT INITIAL.

  CALL FUNCTION 'ZFMMM_CRIAR_DOCUMENTO_VENDA'
    STARTING NEW TASK 'DEP_FECHADO_V'
    EXPORTING
      it_imseg      = it_imseg
      it_his_dep_fec = lt_his_dep_fec.

ENDMETHOD.
ENDCLASS.
