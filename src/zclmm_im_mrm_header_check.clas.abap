CLASS zclmm_im_mrm_header_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_mrm_header_check .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_komv
      IMPORTING
        !iv_knumv        TYPE knumv
      RETURNING
        VALUE(rt_return) TYPE ty_komv .
ENDCLASS.



CLASS zclmm_im_mrm_header_check IMPLEMENTATION.


  METHOD if_ex_mrm_header_check~headerdata_check.

    INCLUDE zmmi_duplicidade_nfe_miro IF FOUND.

    INCLUDE zmmi_troca_tx_cambio IF FOUND.

  ENDMETHOD.


  METHOD get_komv.
    CONSTANTS:
      lc_modulo_tx      TYPE ztca_param_mod-modulo VALUE 'MM',
      lc_chave1_tx      TYPE ztca_param_par-chave1 VALUE 'MRM_HEADER_CHECK',
      lc_chave2_tx      TYPE ztca_param_par-chave2 VALUE 'MIRO',
      lc_kschl          TYPE ztca_param_par-chave3 VALUE 'KSCHL',
      lc_rv_konv_select TYPE rs38l_fnam            VALUE 'RV_KONV_SELECT',
      lc_get_range      TYPE seocpdname            VALUE 'M_GET_RANGE'.

    DATA:
      lr_kschl TYPE RANGE OF konv-kschl.

    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.
        CALL METHOD lo_parametros->(lc_get_range)
          EXPORTING
            iv_modulo = lc_modulo_tx
            iv_chave1 = lc_chave1_tx
            iv_chave2 = lc_chave2_tx
            iv_chave3 = lc_kschl
          IMPORTING
            et_range  = lr_kschl.
      CATCH zcxca_tabela_parametros.
        RETURN.
    ENDTRY.

    CALL FUNCTION lc_rv_konv_select
      EXPORTING
        comm_head_i  = VALUE komk( knumv = iv_knumv )
        general_read = abap_true
      TABLES
        tkomv        = rt_return.

    LOOP AT rt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      IF <fs_return>-kschl NOT IN lr_kschl.
        DELETE rt_return INDEX sy-tabix.
      ENDIF.
    ENDLOOP.

    SORT rt_return BY knumv kposn.

  ENDMETHOD.
ENDCLASS.
