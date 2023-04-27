CLASS zclmm_deposito_fechado_miro DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS process_deposito_fechado
      IMPORTING Is_RBKPV  TYPE MRM_RBKPV
                It_DRSEG  TYPE MMCR_TDRSEG
                it_RBWS   TYPE MRM_TAB_RBWS
                it_RBVS   TYPE MRM_T_RBVS
                iv_QSSKZ  TYPE RBKP-QSSKZ.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_DEPOSITO_FECHADO_MIRO IMPLEMENTATION.


METHOD process_deposito_fechado.

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

  lt_ekko_key = VALUE #( FOR ls_drseg IN it_drseg WHERE ( ebeln IS NOT INITIAL ) ( ebeln = ls_drseg-ebeln ) ).

  lt_ekpo_key = VALUE #( FOR ls_drseg IN it_drseg WHERE ( ebeln IS NOT INITIAL ) ( ebeln = ls_drseg-ebeln ebelp = ls_drseg-ebelp ) ).


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


  SELECT DISTINCT main_purchase_order
    FROM ztmm_his_dep_fec
    FOR ALL ENTRIES IN @lt_ekko_key
    WHERE process_step = 'F06'
     AND main_purchase_order = @lt_ekko_key-ebeln
    INTO TABLE @DATA(lt_main_purchase_order).

  SORT lt_main_purchase_order BY main_purchase_order.

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

    READ TABLE lt_main_purchase_order TRANSPORTING NO FIELDS WITH KEY main_purchase_order = ls_ekko_dat->ebeln BINARY SEARCH.

    CHECK sy-subrc <> 0.

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
          WHERE main_purchase_order   = @ls_ekpo_ref->ebeln
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
        available_stock       = ls_ekpo_ref->menge
        used_stock            = ls_ekpo_ref->menge
        used_stock_conv       = ls_ekpo_ref->menge
        main_purchase_order   = ls_ekpo_ref->ebeln
        main_purchase_order_item = ls_ekpo_ref->ebelp
        created_by             = sy-uname
        created_at             = lv_timestamp ) TO lt_his_dep_fec.
    ENDLOOP.
  ENDLOOP.

  CHECK lt_his_dep_fec IS NOT INITIAL.

  MODIFY ztmm_his_dep_fec FROM  TABLE lt_his_dep_fec.
  WAIT UP TO 5 SECONDS.

  DATA(lr_adm_emissao_nf_events) = NEW zclmm_adm_emissao_nf_events( ).
  lr_adm_emissao_nf_events->bapi_create_documents(
    EXPORTING
      it_historico_key = lt_his_dep_fec
*     iv_update_history = abap_true
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
ENDCLASS.
