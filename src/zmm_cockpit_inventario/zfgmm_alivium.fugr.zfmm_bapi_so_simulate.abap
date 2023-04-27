FUNCTION zfmm_bapi_so_simulate.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IT_MKPF) TYPE  TY_T_MKPF
*"     REFERENCE(IT_MSEG) TYPE  TY_T_MSEG
*"     REFERENCE(IT_COND) TYPE  CRMT_BAPICOND_T
*"     REFERENCE(IT_DIRF) TYPE  ZCTGMM_ALIVIUM_DIRFISCAIS
*"  EXPORTING
*"     REFERENCE(EV_BAPIRETURN) TYPE  BAPIRETURN
*"     REFERENCE(ET_DIRF) TYPE  ZCTGMM_ALIVIUM_DIRFISCAIS
*"  EXCEPTIONS
*"      EX_MKPF_NOT_FILLED
*"      EX_MSEG_NOT_FILLED
*"      EX_FILLING_INCOMPLETE
*"      EX_ZCGC_COLIGADA_NOT_FOUND
*"      EX_DIR_FISCAIS_ERROR
*"----------------------------------------------------------------------
  DATA: ls_header        TYPE bapisdhead,
        lt_item          TYPE TABLE OF bapiitemin,
        lt_items_out     TYPE TABLE OF bapiitemex,
        lt_partner       TYPE TABLE OF bapipartnr,
        lt_schedline     TYPE TABLE OF bapischdl,
        ls_bapireturn    TYPE bapireturn,
        ls_zcgc_coligada TYPE ztmm_cgccoligada,
        ls_t001w         TYPE t001w,
        lt_cond          TYPE TABLE OF bapicond.

  DATA: lt_dir_fiscais  TYPE zctgmm_alivium_dirfiscais,
        lt_dir_fiscais2 TYPE zctgmm_alivium_dirfiscais,
        ls_dir_fiscais  TYPE zsmm_alivium_dirfiscais.

  CLEAR: lt_items_out.

  SELECT *
    FROM ztmm_alivium_par
    INTO CORRESPONDING FIELDS OF TABLE gt_zalivium_params
   WHERE function = sy-repid.

  READ TABLE it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) INDEX 1.
  IF <fs_mseg> IS ASSIGNED.

    SELECT SINGLE * FROM t001w
      INTO ls_t001w
     WHERE werks = <fs_mseg>-werks.

    SELECT SINGLE *                                     "#EC CI_ALL_FIELDS_NEEDED
      FROM ztmm_cgccoligada
      INTO ls_zcgc_coligada
     WHERE bukrs = <fs_mseg>-bukrs
       AND bupla = ls_t001w-j_1bbranch.

    IF sy-subrc NE 0.
      RAISE ex_zcgc_coligada_not_found.
    ENDIF.
  ENDIF.
  PERFORM f_bapiso_header_partner TABLES lt_partner
                                       it_mkpf
                                       it_mseg
                                 USING ls_zcgc_coligada
                                       ls_t001w
                              CHANGING ls_header.

  PERFORM f_bapiso_item_sched TABLES lt_item
                                lt_schedline
                                it_mseg.

  PERFORM f_check_filling TABLES lt_item
                               lt_partner
                               lt_schedline
                         USING ls_header.

  PERFORM f_get_tax_law TABLES  lt_item
                                  lt_partner
                                  lt_schedline
                                  lt_dir_fiscais
                                  it_cond
                            USING ls_header.

  IF lt_dir_fiscais[] IS NOT INITIAL.
    et_dirf = lt_dir_fiscais.
  ELSE.
    RAISE ex_dir_fiscais_error.
  ENDIF.

ENDFUNCTION.
