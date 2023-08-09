***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Duplicidade Recebimento NFe                            *
*** AUTOR:     Caio Mossmann   - META                                 *
*** FUNCIONAL: Rodrigo Prestes - META                                 *
*** DATA :     06.10.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 06.10.2021 | Caio Mossmann      | Desenvolvimento inicial         *
***********************************************************************
*&--------------------------------------------------------------------*
*& ZMMI_DUPLICIDADE_NFE_MIRO
*&--------------------------------------------------------------------*
CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'MM',
           lc_chave1 TYPE ztca_param_par-chave1 VALUE 'NFTYPE',
           lc_chave2 TYPE ztca_param_par-chave2 VALUE 'VALOR'.

DATA: lv_nfenum_in  TYPE j_1bnfdoc-nfenum,
      lv_nfenumc    TYPE j_1bnfdoc-nfenum,
      lv_nfenum_out TYPE j_1bnfdoc-nfenum,
      lv_series     TYPE j_1bnfdoc-series,
      lv_seriesc    TYPE numc3,
      lv_fcode      TYPE sy-ucomm,
      lt_error      TYPE STANDARD TABLE OF mrm_errprot,
      lr_nftype     TYPE RANGE OF j_1bnfdoc-nftype.

FIELD-SYMBOLS <fs_fcode> TYPE any.

DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

TRY.
    lo_parametros->m_get_range(
      EXPORTING
        iv_modulo = lc_modulo
        iv_chave1 = lc_chave1
        iv_chave2 = lc_chave2
      IMPORTING
        et_range  = lr_nftype ).
  CATCH zcxca_tabela_parametros.
ENDTRY.

SPLIT i_rbkpv-xblnr AT '-' INTO lv_nfenumc lv_seriesc.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input  = lv_nfenumc
  IMPORTING
    output = lv_nfenum_in.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    input  = lv_nfenumc
  IMPORTING
    output = lv_nfenum_out.
CONCATENATE '%' lv_nfenum_out INTO lv_nfenum_out.
CONDENSE lv_nfenum_out NO-GAPS.

ASSIGN ('(SAPLMR1M)OK-CODE') TO <fs_fcode>.
IF <fs_fcode> IS ASSIGNED.

  IF  ( <fs_fcode> EQ 'PB' OR <fs_fcode> EQ 'BU') " Simular ou Salvar
 AND lv_nfenum_in       IS NOT INITIAL
 AND i_rbkpv-lifnr      IS NOT INITIAL
 AND i_rbkpv-j_1bnftype IN lr_nftype.

    SELECT docnum,
           nfenum,
           series,
           parid
       FROM j_1bnfdoc
       INTO TABLE @DATA(lt_nfe)
       WHERE doctyp EQ '1'
         AND direct EQ '1'
*         AND nfenum EQ @lv_nfenum
         AND nfenum LIKE @lv_nfenum_out
         AND parid  EQ   @i_rbkpv-lifnr
         AND cancel EQ   @space.

    IF sy-subrc IS INITIAL.

      LOOP AT lt_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>).
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_nfe>-nfenum
          IMPORTING
            output = <fs_nfe>-nfenum.

        IF lv_nfenum_in NE <fs_nfe>-nfenum.
          CONTINUE.
        ENDIF.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_nfe>-series
          IMPORTING
            output = <fs_nfe>-series.
      ENDLOOP.
      SORT lt_nfe BY nfenum series.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_seriesc
        IMPORTING
          output = lv_series.

      READ TABLE lt_nfe INTO DATA(ls_nfe)
        WITH KEY nfenum = lv_nfenum_in
                 series = lv_series BINARY SEARCH.
      IF sy-subrc IS INITIAL.

*        lt_error = VALUE #( ( msgid  = 'ZMM_DUPLICIDADE_NFE'
*                              msgno  = '001'
*                              msgty  = 'E'
*                              msgv1  = i_rbkpv-xblnr
*                              source = space ) ).
*
*        CALL FUNCTION 'MRM_PROT_FILL'
*          TABLES
*            t_errprot = lt_error.

        CLEAR <fs_fcode>.
*        MESSAGE e001(zmm_duplicidade_nfe) WITH i_rbkpv-xblnr RAISING error.
        MESSAGE e001(zmm_duplicidade_nfe) WITH |{ ls_nfe-docnum ALPHA = OUT }| RAISING error.
      ENDIF.
    ENDIF.
  ENDIF.

ENDIF.
