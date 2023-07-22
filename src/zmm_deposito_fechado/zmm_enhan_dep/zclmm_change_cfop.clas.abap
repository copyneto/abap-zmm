CLASS zclmm_change_cfop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS: change_cfop
      CHANGING
        !cv_cfop TYPE j_1bag-cfop,

      change_cfop_4
        IMPORTING
          !is_parameters TYPE    j_1bao
          !iv_land1      TYPE    land1
          !iv_region     TYPE    regio
          !iv_date       TYPE    j_1bdocdat
        CHANGING
          !cv_cfop       TYPE j_1bag-cfop.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_change_cfop IMPLEMENTATION.


  METHOD change_cfop.

    CONSTANTS: lc_mod               TYPE ztca_param_par-modulo VALUE 'MM',
               lc_entrada_fisica    TYPE ztca_param_par-chave1 VALUE 'ENTRADA_FISICA',
               lc_retorno_simbolico TYPE ztca_param_par-chave1 VALUE 'RETORNO_SIMBOLICO',
               lc_retorno_fisico    TYPE ztca_param_par-chave1 VALUE 'RETORNO_FISICO',
               lc_rem_simba_dupl    TYPE ztca_param_par-chave1 VALUE 'REM_SIMBA_DUPL',
               lc_cfop              TYPE ztca_param_par-chave2 VALUE 'CFOP',
               lc_estadual          TYPE ztca_param_par-chave3 VALUE 'ESTADUAL',
               lc_interestadual     TYPE ztca_param_par-chave3 VALUE 'INTEREST',
               lc_cfop5906aa        TYPE j_1bag-cfop VALUE '5906AA',
               lc_cfop6906aa        TYPE j_1bag-cfop VALUE '6906AA',
               lc_cfop5907aa        TYPE j_1bag-cfop VALUE '5907AA',
               lc_cfop6907aa        TYPE j_1bag-cfop VALUE '6907AA',
               lc_cfop5905aa        TYPE j_1bag-cfop VALUE '5905AA',
               lc_cfop6905aa        TYPE j_1bag-cfop VALUE '6905AA',
               lc_cfop5934aa        TYPE j_1bag-cfop VALUE '5934AA',
               lc_cfop1934aa        TYPE j_1bag-cfop VALUE '1934AA',
               lc_cfop6934aa        TYPE j_1bag-cfop VALUE '6934AA',
               lc_cfop2934aa        TYPE j_1bag-cfop VALUE '2934AA',
               lc_zdf               TYPE bsart VALUE 'ZDF'.

    DATA: lv_vgbel TYPE vgbel,
          lv_cfop  TYPE j_1bag-cfop,
          lv_param TYPE j_1bag-cfop.

    FIELD-SYMBOLS <fs_mseg> TYPE mseg.

    ASSIGN ('(SAPLJ1BF)WA_XMSEG') TO <fs_mseg>.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " INSERT - JWSILVA - 21.07.2023

    IF <fs_mseg> IS ASSIGNED.

      SELECT SINGLE vgbel, j_1bcfop
      INTO ( @lv_vgbel, @lv_cfop )
      FROM lips
      WHERE vbeln = @<fs_mseg>-vbeln_im
      AND posnr = @<fs_mseg>-vbelp_im.

      CHECK sy-subrc IS INITIAL.

      SELECT SINGLE bsart
      INTO @DATA(lv_bsart)
      FROM ekko
      WHERE ebeln = @lv_vgbel.

      CHECK lv_bsart = lc_zdf.

      IF lv_cfop = lc_cfop5905aa.

        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_entrada_fisica
                iv_chave2 = lc_cfop
                iv_chave3 = lc_estadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.

      ELSEIF lv_cfop = lc_cfop6905aa.

        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_entrada_fisica
                iv_chave2 = lc_cfop
                iv_chave3 = lc_interestadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.

      ELSEIF lv_cfop = lc_cfop5907aa.

        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_retorno_simbolico
                iv_chave2 = lc_cfop
                iv_chave3 = lc_estadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.
      ELSEIF lv_cfop = lc_cfop6907aa.

        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_retorno_simbolico
                iv_chave2 = lc_cfop
                iv_chave3 = lc_interestadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.
      ELSEIF lv_cfop = lc_cfop5906aa.
        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_retorno_fisico
                iv_chave2 = lc_cfop
                iv_chave3 = lc_estadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.

      ELSEIF lv_cfop = lc_cfop6906aa.

        TRY.
            lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
              EXPORTING
                iv_modulo = lc_mod
                iv_chave1 = lc_retorno_fisico
                iv_chave2 = lc_cfop
                iv_chave3 = lc_interestadual
              IMPORTING
                ev_param  = lv_param
            ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.
      ENDIF.

      IF lv_param IS NOT INITIAL AND
        lv_bsart = lc_zdf AND
        lv_param <> cv_cfop.

        cv_cfop = lv_param.
      ENDIF.

      IF lv_vgbel IS NOT INITIAL.
        SELECT plant, plant_dest, process_step, main_purchase_order UP TO 1 ROWS
          FROM ztmm_his_dep_fec
          INTO @DATA(ls_historico)
          WHERE purchase_order EQ @lv_vgbel.
        ENDSELECT.
        IF sy-subrc = 0 AND
           ls_historico-process_step = 'F06' AND
           ls_historico-main_purchase_order IS NOT INITIAL.

          SELECT SINGLE regio FROM t001w
            INTO @DATA(lv_regio_orig)
            WHERE werks = @ls_historico-plant.
          IF sy-subrc = 0.
            SELECT SINGLE regio FROM t001w
             INTO @DATA(lv_regio_dest)
             WHERE werks = @ls_historico-plant_dest.
            IF sy-subrc = 0 AND lv_regio_dest = 'MG'.
              IF lv_regio_orig = lv_regio_dest.
                TRY.
                    lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
                      EXPORTING
                        iv_modulo = lc_mod
                        iv_chave1 = lc_rem_simba_dupl
                        iv_chave2 = lc_cfop
                        iv_chave3 = lc_estadual
                      IMPORTING
                        ev_param  = lv_param
                    ).
                    lv_param = COND #( WHEN lv_param = lc_cfop5934aa THEN lc_cfop1934aa ELSE lv_param ).
                  CATCH zcxca_tabela_parametros.
                ENDTRY.
              ELSE.
                TRY.
                    lo_param->m_get_single(                                 " CHANGE - JWSILVA - 21.07.2023
                      EXPORTING
                        iv_modulo = lc_mod
                        iv_chave1 = lc_rem_simba_dupl
                        iv_chave2 = lc_cfop
                        iv_chave3 = lc_interestadual
                      IMPORTING
                        ev_param  = lv_param
                    ).
                    lv_param = COND #( WHEN lv_param = lc_cfop6934aa THEN lc_cfop2934aa ELSE lv_param ).
                  CATCH zcxca_tabela_parametros.
                ENDTRY.
              ENDIF.
              IF lv_param IS NOT INITIAL AND
                lv_bsart = lc_zdf AND
                lv_param <> cv_cfop.

                cv_cfop = lv_param.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD change_cfop_4.

    DATA: lv_version        TYPE j_1bcfop_ver,
          ls_branch_record  TYPE j_1bbranch,
          ls_branch_address TYPE sadr,
          ls_partner_record TYPE j_1binnad,
          ls_tregx          TYPE j_1btregx,
          ls_wtregx         TYPE j_1btregx,
          lv_suframa        TYPE j_1bnfe_icms_exemption_reason.

    FIELD-SYMBOLS <fs_doc>  TYPE j_1bnfdoc.
    FIELD-SYMBOLS <fs_miro> TYPE invfo.

    "//Estrutura processo transferência entre centros
    ASSIGN ('(SAPLJ1BF)WA_NF_DOC') TO <fs_doc>.

    "//Estrutura processo entrada de compras
    IF <fs_doc> IS NOT ASSIGNED.
      ASSIGN ('(SAPLJ1BI)NFHEADER') TO <fs_doc>.
      ASSIGN ('(SAPLFDCB)INVFO')    TO <fs_miro>.
    ENDIF.

    IF ( <fs_doc> IS ASSIGNED ).

      IF <fs_doc>-partyp = 'V'.
        IF <fs_miro>-lifnr IS ASSIGNED.
          CALL FUNCTION 'J_1B_NF_PARTNER_READ'
            EXPORTING
              partner_type = <fs_doc>-partyp
              partner_id   = <fs_miro>-lifnr
            IMPORTING
              parnad       = ls_partner_record
            EXCEPTIONS
              OTHERS       = 8.

          IF sy-subrc NE 0.
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        CALL FUNCTION 'J_1B_NF_PARTNER_READ'
          EXPORTING
            partner_type = <fs_doc>-partyp
            partner_id   = <fs_doc>-parid
          IMPORTING
            parnad       = ls_partner_record
          EXCEPTIONS
            OTHERS       = 8.

        IF sy-subrc NE 0.
          RETURN.
        ENDIF.
      ENDIF.

      CALL FUNCTION 'J_1B_BRANCH_READ'
        EXPORTING
          company       = <fs_doc>-bukrs
          branch        = <fs_doc>-branch
        IMPORTING
          branch_record = ls_branch_record
          address       = ls_branch_address
        EXCEPTIONS
          OTHERS        = 8.
      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      CALL FUNCTION 'J_1B_CFOP_GET_VERSION'
        EXPORTING
          land1        = iv_land1
          region       = iv_region
          date         = iv_date
        IMPORTING
          version      = lv_version
        EXCEPTIONS
          date_missing = 1
          OTHERS       = 2.
      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      IF iv_land1 NE iv_land1.
        DATA(lv_dstcat) = 2.
      ELSE.

        CALL FUNCTION 'J_1BTREGX_READ'
          EXPORTING
            country              = iv_land1
            taxregion            = ls_branch_address-regio
          IMPORTING
            tregx                = ls_wtregx
          EXCEPTIONS
            parameters_incorrect = 1
            not_found            = 2
            OTHERS               = 3.
        IF sy-subrc NE 0.
          CLEAR ls_wtregx.
        ENDIF.

        IF ls_branch_address-regio NE ls_partner_record-regio.
          IF ls_wtregx-taxfree = abap_true.
            lv_dstcat = 4.
          ELSE.
            lv_dstcat = 1.
          ENDIF.
        ELSE.
          IF ls_wtregx-taxfree = abap_true.
            lv_dstcat = 3.
          ELSE.
            lv_dstcat = 0.
          ENDIF.
        ENDIF.
      ENDIF.

      SELECT SINGLE cfop FROM j_1baon
      INTO @cv_cfop
      WHERE direct  = @is_parameters-direct
        AND dstcat  = @lv_dstcat
        AND indus3  = @is_parameters-indus3
        AND itmtyp  = @is_parameters-itmtyp
        AND spcsto  = @is_parameters-spcsto
        AND matuse  = @is_parameters-matuse
        AND indus2  = @is_parameters-indus2
        AND version = @lv_version.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
