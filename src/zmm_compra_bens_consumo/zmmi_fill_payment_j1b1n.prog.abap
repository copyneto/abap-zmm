*&---------------------------------------------------------------------*
*& Include ZMMI_FILL_PAYMENT_J1B1N
*&---------------------------------------------------------------------*

  CONSTANTS: BEGIN OF lc_param,
               modulo TYPE ztca_param_par-modulo VALUE 'MM',
               chave1 TYPE ztca_param_par-chave1 VALUE 'MONITOR_IMOBILIZACAO',
               ctg_nf TYPE ztca_param_par-chave2 VALUE 'CTG_NF',
               chav3  TYPE ztca_param_par-chave3 VALUE 'ENTRADA',
             END OF lc_param.

  DATA: lt_nftyp TYPE RANGE OF j_1bnftype.

  DATA(lo_param) = NEW zclca_tabela_parametros( ).

  TRY.
      lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                       iv_chave1 = lc_param-chave1
                                       iv_chave2 = lc_param-ctg_nf
                                       iv_chave3 = lc_param-chav3
                             IMPORTING et_range  = lt_nftyp ).
    CATCH cx_root.
  ENDTRY.

  IF is_header-nftype IN lt_nftyp.
    APPEND INITIAL LINE TO ct_payment ASSIGNING FIELD-SYMBOL(<fs_payment>).
    <fs_payment>-mandt   = sy-mandt.
    <fs_payment>-docnum  = is_header-docnum.
    <fs_payment>-ind_pag = '1'.
    <fs_payment>-counter = 1.
    <fs_payment>-t_pag   = '90'.
    CLEAR <fs_payment>-v_pag.
  ENDIF.
