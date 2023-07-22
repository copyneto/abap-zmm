CLASS zclmm_determina_lote DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_le_shp_delivery_proc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_determina_lote IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_field_attributes.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~check_item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~initialize_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.

    CONSTANTS: lc_modulo  TYPE ztca_param_mod-modulo VALUE 'MM',
               lc_chave1  TYPE ztca_param_par-chave1 VALUE 'DETERMINACAO_LOTE',
               lc_chave2a TYPE ztca_param_par-chave1 VALUE 'CATEGORIA DE ITEM',
               lc_chave2b TYPE ztca_param_par-chave1 VALUE 'TIPO DE MOVIMENTO',
               lc_chave3a TYPE ztca_param_par-chave3 VALUE 'PSTYP',
               lc_chave3b TYPE ztca_param_par-chave3 VALUE 'BWART',
               lc_pstyv   TYPE lips-pstyv VALUE 'ELN',
               lc_pstyp   TYPE ekpo-pstyp VALUE '7'.
    "TM integração
    CONSTANTS: lc_modtm    TYPE ztca_param_mod-modulo VALUE 'TM',
               lc_chavetm1 TYPE ztca_param_par-chave1 VALUE 'FLUIG',
               lc_chavetm2 TYPE ztca_param_par-chave1 VALUE 'TIPO_REMESSA'.

    DATA: lv_bwart_p TYPE lips-bwart,
          lv_pstyp_p TYPE ekpo-pstyp.
*          lv_lfart   TYPE likp-lfart.

    " Ranges
    DATA: lr_lfart TYPE RANGE OF likp-lfart.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " INSERT - JWSILVA - 21.07.2023

    " Obter os dados cadastrados na Tabela de Parámetros
    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo  = lc_modulo    " CHANGE - JWSILVA - 21.07.2023
                                          iv_chave1 = lc_chave1
                                          iv_chave2 = lc_chave2a
                                          iv_chave3 = lc_chave3a
                                IMPORTING ev_param  = lv_pstyp_p ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo  = lc_modulo    " CHANGE - JWSILVA - 21.07.2023
                                          iv_chave1 = lc_chave1
                                          iv_chave2 = lc_chave2b
                                          iv_chave3 = lc_chave3b
                                IMPORTING ev_param  = lv_bwart_p ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = lc_modtm       " CHANGE - JWSILVA - 21.07.2023
                                         iv_chave1 = lc_chavetm1
                                         iv_chave2 = lc_chavetm2
                               IMPORTING et_range  = lr_lfart ).

      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    IF ct_xlips IS NOT INITIAL.

      SELECT ebeln, ebelp, pstyp
        FROM ekpo
        INTO TABLE @DATA(lt_ekpo)
        FOR ALL ENTRIES IN @ct_xlips
        WHERE ebeln = @ct_xlips-vgbel AND
              ebelp = @ct_xlips-vgpos+1(5) AND
              pstyp = @lc_pstyp.

      IF lt_ekpo IS NOT INITIAL.
        SORT lt_ekpo BY ebeln ASCENDING
                        ebelp ASCENDING.

        LOOP AT ct_xlips ASSIGNING FIELD-SYMBOL(<fs_xlips>).
          READ TABLE lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>) WITH  KEY ebeln = <fs_xlips>-vgbel
                                                                         ebelp = <fs_xlips>-vgpos+1(5) BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            IF <fs_ekpo>-pstyp = lv_pstyp_p AND <fs_xlips>-pstyv = lc_pstyv.
              <fs_xlips>-bwart = lv_bwart_p.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

    IF ct_xlikp IS NOT INITIAL.
      READ TABLE ct_xlikp ASSIGNING FIELD-SYMBOL(<fs_xlikp>) INDEX 1.

*      IF <fs_xlikp>-lfart EQ lv_lfart.
      IF <fs_xlikp>-lfart IN lr_lfart.

        SELECT SINGLE tm_ctrl_key
          FROM tms_c_shp
          INTO <fs_xlikp>-tm_ctrl_key
        WHERE vstel = <fs_xlikp>-vstel
          AND lfart = <fs_xlikp>-lfart.
      ENDIF.
    ENDIF.

    IF ct_xlips IS NOT INITIAL.
      TYPES: ty_xlips TYPE SORTED TABLE OF lipsvb WITH NON-UNIQUE KEY mandt vbeln posnr.
      DATA: lt_xlips TYPE ty_xlips.
      lt_xlips = ct_xlips.

      SELECT xlips~vbeln, xlips~posnr, _ekpo~lgort
        FROM @lt_xlips AS xlips
        INNER JOIN ekpo AS _ekpo
        ON  vgbel                    = _ekpo~ebeln
        AND substring( vgpos, 2, 5 ) = _ekpo~ebelp
        INNER JOIN ekko AS _ekko
        ON  _ekko~ebeln = _ekpo~ebeln
        AND _ekko~bsart = 'ZDF'
        INTO TABLE @DATA(lt_deposito_pedido).
      IF sy-subrc = 0.
        SELECT xlips~vbeln, xlips~posnr, _his_dep_fec~storage_location
          FROM @lt_xlips AS xlips
          INNER JOIN ztmm_his_dep_fec AS _his_dep_fec
          ON  vgbel                    = _his_dep_fec~purchase_order
          AND substring( vgpos, 2, 5 ) = _his_dep_fec~purchase_order_item
          INTO TABLE @DATA(lt_deposito_fechado).

        LOOP AT ct_xlips ASSIGNING <fs_xlips>.
          READ TABLE lt_deposito_pedido ASSIGNING FIELD-SYMBOL(<fs_deposito_pedido>)
          WITH KEY vbeln = <fs_xlips>-vbeln
                   posnr = <fs_xlips>-posnr BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_xlips>-lgort = <fs_deposito_pedido>-lgort.
          ENDIF.
          READ TABLE lt_deposito_fechado ASSIGNING FIELD-SYMBOL(<fs_deposito_fechado>)
          WITH KEY vbeln = <fs_xlips>-vbeln
                   posnr = <fs_xlips>-posnr BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_xlips>-lgort = <fs_deposito_fechado>-storage_location.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

* BEGIN OF INSERT - JWSILVA - 26.04.2023
    IF <fs_xlikp>-tm_ctrl_key IS NOT INITIAL.
      cf_force_status_update   = abap_true.
    ENDIF.
* END OF INSERT - JWSILVA - 26.04.2023

  ENDMETHOD.
ENDCLASS.
