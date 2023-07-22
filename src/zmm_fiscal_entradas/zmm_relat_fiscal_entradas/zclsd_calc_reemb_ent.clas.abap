CLASS zclsd_calc_reemb_ent DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_calc_reemb_ent IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    CONSTANTS: lc_sd         TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1     TYPE ztca_param_par-chave1 VALUE 'REEMBOLSO NFE',
               lc_regra1     TYPE ztca_param_par-chave2 VALUE 'REGRA 1',
               lc_regra2     TYPE ztca_param_par-chave2 VALUE 'REGRA 2',
               lc_regra3     TYPE ztca_param_par-chave2 VALUE 'REGRA 3',
               lc_cont_icms  TYPE ztca_param_par-chave2 VALUE 'CONTRIBUINTE DE ICMS',
               lc_infadfisco TYPE ztca_param_par-chave2 VALUE 'INFADFISCO'.

    DATA: lr_regra1       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_regra2       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_regra3       TYPE RANGE OF j_1bnfdoc-vstel,
          lr_sp           TYPE RANGE OF j_1bnfdoc-vstel,
          lv_porcentagem1 TYPE j_1bnfe_pfcpstret,
          lv_porcentagem2 TYPE j_1bnfe_pfcpstret,
          lr_cont_icms    TYPE RANGE OF kna1-icmstaxpay,
          lv_stfcp        TYPE j_1bnflin-vfcpstret.


    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_fiscal_entradas WITH DEFAULT KEY.
*          lv_unit_in       TYPE t006-msehi.

    lt_original_data = CORRESPONDING #( it_original_data ).
    CHECK lt_original_data IS NOT INITIAL.

    DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra1
          IMPORTING
            et_range  = lr_regra1 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra2
          IMPORTING
            et_range  = lr_regra2 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_regra3
          IMPORTING
            et_range  = lr_regra3 ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_cont_icms
          IMPORTING
            et_range  = lr_cont_icms ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_sd
            iv_chave1 = lc_chave1
            iv_chave2 = lc_infadfisco
          IMPORTING
            et_range  = lr_sp ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    SELECT lin~docnum,
           lin~itmnum,
           lin~pst,
           lin~pfcpstret,
           lin~picmsefet,
           lin~vbcstret,
           lin~vbcefet,
           lin~vicmsstret,
           lin~vbcfcpstret,
           lin~vfcpstret,
           doc~regio
        INTO TABLE @DATA(lt_lin)
        FROM j_1bnflin AS lin
        INNER JOIN j_1bnfdoc AS doc ON doc~docnum = lin~docnum
        FOR ALL ENTRIES IN @lt_original_data
        WHERE lin~docnum = @lt_original_data-br_notafiscal
          AND lin~itmnum = @lt_original_data-BR_NotaFiscalItem.

    SORT lt_lin BY docnum itmnum.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-TaxIncentiveCode IS NOT INITIAL.
        <fs_data>-ICMSSemBenef = <fs_data>-BR_NFTotalAmount * ( <fs_data>-BR_NFItemTaxRate / 100 ).
      ENDIF.

      READ TABLE lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>) WITH KEY docnum = <fs_data>-br_notafiscal
                                                                  itmnum = <fs_data>-BR_NotaFiscalItem BINARY SEARCH.

      IF <fs_lin>-regio IN lr_regra1.

        lv_porcentagem1 = ( <fs_lin>-pst - <fs_lin>-pfcpstret ) / 100.
        lv_porcentagem2 = ( <fs_lin>-picmsefet - <fs_lin>-pfcpstret  ) / 100.
        <fs_data>-MontanteST = ( <fs_lin>-vbcstret * lv_porcentagem1 ) - ( <fs_lin>-vbcefet * lv_porcentagem2 ).
        <fs_data>-BaseST = <fs_lin>-vbcstret.

        IF <fs_data>-MontanteST < 0.
          <fs_data>-MontanteST = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-BaseSTFCP = <fs_lin>-vbcfcpstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp  = ( <fs_lin>-vbcstret * <fs_lin>-pfcpstret ) - ( <fs_lin>-vbcefet * <fs_lin>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          <fs_data>-ValorSTFCP = lv_stfcp.
        ENDIF.

      ELSEIF <fs_lin>-regio IN lr_regra2.

        <fs_data>-MontanteST  = <fs_lin>-vicmsstret.
        <fs_data>-BaseST = <fs_lin>-vbcstret.

        IF <fs_data>-MontanteST < 0.
          <fs_data>-MontanteST = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-BaseSTFCP = <fs_lin>-vbcfcpstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp = <fs_lin>-vfcpstret.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
          ENDIF.
          <fs_data>-ValorSTFCP = lv_stfcp.
        ENDIF.

      ELSEIF <fs_lin>-regio IN lr_regra3.

        lv_porcentagem1            = ( <fs_lin>-pst - <fs_lin>-pfcpstret ) / 100.
        lv_porcentagem2            = ( <fs_lin>-picmsefet - <fs_lin>-pfcpstret  ) / 100.
        <fs_data>-MontanteST  = ( <fs_lin>-vbcstret * lv_porcentagem1 ) - ( <fs_lin>-vbcefet * lv_porcentagem2 ).
        <fs_data>-BaseST = <fs_lin>-vbcstret.

        IF <fs_data>-MontanteST < 0.
          <fs_data>-MontanteST = 0.
        ENDIF.

        " Base ICMS ST FCP Reembolso
        <fs_data>-BaseSTFCP = <fs_lin>-vbcstret.

        " Valor ICMS ST FCP Reembolso
        lv_stfcp  = ( <fs_lin>-vbcstret * <fs_lin>-pfcpstret ) - ( <fs_lin>-vbcefet * <fs_lin>-pfcpstret ).
        lv_stfcp  = lv_stfcp / 100.

        IF lv_stfcp IS NOT INITIAL.
          IF lv_stfcp LT 0.
            lv_stfcp = 0.
            <fs_data>-BaseSTFCP = 0.
          ENDIF.
          <fs_data>-ValorSTFCP = lv_stfcp.
        ELSE.
          <fs_data>-BaseSTFCP = 0.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
     INSERT CONV string( 'TAXINCENTIVECODE' ) INTO TABLE et_requested_orig_elements.
     INSERT CONV string( 'BR_NFTOTALAMOUNT' ) INTO TABLE et_requested_orig_elements.
     INSERT CONV string( 'BR_NFITEMTAXRATE' ) INTO TABLE et_requested_orig_elements.
  ENDMETHOD.
ENDCLASS.
