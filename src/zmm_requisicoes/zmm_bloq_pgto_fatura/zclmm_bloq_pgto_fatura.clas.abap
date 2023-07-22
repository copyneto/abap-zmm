CLASS zclmm_bloq_pgto_fatura DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_invoice_update .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_BLOQ_PGTO_FATURA IMPLEMENTATION.


  METHOD if_ex_invoice_update~change_at_save.

    CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'MM',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'GKO',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'FATURA',
               lc_nftype TYPE ztca_param_par-chave3 VALUE 'NFTYPE',
               lc_zlspr  TYPE ztca_param_par-chave3 VALUE 'ZLSPR',
               lc_sgtxt  TYPE ztca_param_par-chave3 VALUE 'SGTXT'.

    DATA: lv_struc(30) TYPE c VALUE '(SAPLMRMP)RBKPV',
          lr_nftype    TYPE RANGE OF j_1bnftype,
          lr_zlspr     TYPE RANGE OF dzlspr,
          lr_sgtxt     TYPE RANGE OF sgtxt.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    FIELD-SYMBOLS <fs_rbkpv> TYPE mrm_rbkpv.
    ASSIGN (lv_struc) TO <fs_rbkpv>.

    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
            iv_chave3 = lc_nftype
          IMPORTING
            et_range  = lr_nftype
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.

        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
            iv_chave3 = lc_zlspr
          IMPORTING
            et_range  = lr_zlspr
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    TRY.

        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
            iv_chave3 = lc_sgtxt
          IMPORTING
            et_range  = lr_sgtxt
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    IF <fs_rbkpv> IS ASSIGNED AND
        lr_nftype IS NOT INITIAL.

      IF <fs_rbkpv>-j_1bnftype IN lr_nftype.

        READ TABLE lr_sgtxt ASSIGNING FIELD-SYMBOL(<fs_sgtxt>) INDEX 1.
        IF sy-subrc IS INITIAL.

          <fs_rbkpv>-sgtxt = <fs_sgtxt>-low.

        ENDIF.

        READ TABLE lr_zlspr ASSIGNING FIELD-SYMBOL(<fs_zlspr>) INDEX 1.
        IF sy-subrc IS INITIAL.

          <fs_rbkpv>-zlspr = <fs_zlspr>-low.

        ENDIF.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD if_ex_invoice_update~change_before_update.

    INCLUDE zmmi_send_reversal IF FOUND.

  ENDMETHOD.


  METHOD if_ex_invoice_update~change_in_update.
  ENDMETHOD.
ENDCLASS.
