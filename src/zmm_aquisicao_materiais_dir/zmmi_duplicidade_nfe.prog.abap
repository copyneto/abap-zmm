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
*& ZMMI_DUPLICIDADE_NFE
*&--------------------------------------------------------------------*
CONSTANTS: lc_nftype TYPE j_1bnfdoc-nftype VALUE 'YH',
           lc_ref    TYPE j_1bnflin-reftyp VALUE 'BI',
           lc_tcode  TYPE sy-tcode VALUE 'J1B2N',
           lc_modulo TYPE ztca_param_mod-modulo VALUE 'MM',
           lc_chave1 TYPE ztca_param_par-chave1 VALUE 'NFTYPE',
           lc_chave2 TYPE ztca_param_par-chave2 VALUE 'VALOR'.


DATA: lr_docnum     TYPE RANGE OF j_1bdocnum,
      lv_nfenum_in  TYPE j_1bnfdoc-nfenum,
      lv_nfenum_out TYPE char12,
      lv_series     TYPE j_1bnfdoc-series,
      lr_nftype     TYPE RANGE OF j_1bnfdoc-nftype.

FIELD-SYMBOLS: <fs_storno> TYPE xfeld,
               <fs_okcode> TYPE any.



IF  sy-tcode         NE lc_tcode
AND is_header-direct EQ 1.

  DATA(lt_nflin) = it_nflin.
  SORT lt_nflin BY reftyp.
  READ TABLE lt_nflin TRANSPORTING NO FIELDS WITH KEY reftyp = lc_ref BINARY SEARCH.
  IF sy-subrc NE 0.

    IF is_header-nftype NE lc_nftype.

      ASSIGN ('(SAPLJ1BI)STORNO_FLAG') TO <fs_storno>.
      IF <fs_storno> IS ASSIGNED.
        DATA(lv_storno) = <fs_storno>.
      ENDIF.

      IF lv_storno IS INITIAL.

        TRY.
            zclca_tabela_parametros=>get_instance( )->m_get_range( " CHANGE - LSCHEPP - 20.07.2023
               EXPORTING
                 iv_modulo = lc_modulo
                 iv_chave1 = lc_chave1
                 iv_chave2 = lc_chave2
               IMPORTING
                 et_range  = lr_nftype ).
          CATCH zcxca_tabela_parametros.
        ENDTRY.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = is_header-nfenum
          IMPORTING
            output = lv_nfenum_in.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = is_header-nfenum
          IMPORTING
            output = lv_nfenum_out.

        CONCATENATE '%' lv_nfenum_out INTO lv_nfenum_out.
        CONDENSE lv_nfenum_out NO-GAPS.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = is_header-series
          IMPORTING
            output = lv_series.

        IF  lv_nfenum_out    IS NOT INITIAL
        AND is_header-parid  IS NOT INITIAL
        AND is_header-nftype IN lr_nftype.
*        AND ( sy-tcode       EQ lc_miro
*         OR   sy-tcode       EQ lc_mir4 ).

          SELECT docnum,
                 nfenum,
                 series,
                 parid,
                 direct
             FROM j_1bnfdoc
             INTO TABLE @DATA(lt_nfe)
             WHERE docnum IN @lr_docnum
               AND doctyp EQ '1'
               AND direct EQ '1'
*             AND nfenum EQ @lv_nfenum
               AND nfenum LIKE @lv_nfenum_out
               AND parid  EQ @is_header-parid
               AND cancel EQ @space.

          LOOP AT lt_nfe ASSIGNING FIELD-SYMBOL(<fs_nfe>).
            DATA(lv_tabix) = sy-tabix.

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

          READ TABLE lt_nfe INTO DATA(ls_nfe)
            WITH KEY nfenum = lv_nfenum_in
                     series = lv_series BINARY SEARCH.
          IF sy-subrc EQ 0.

            ASSIGN ('(SAPLJ1BB2)OK_CODE') TO <fs_okcode>.
            IF <fs_okcode> IS ASSIGNED.
              CLEAR <fs_okcode>.
            ENDIF.

            DATA(lv_nota) = COND string( WHEN is_header-series IS NOT INITIAL THEN |{ is_header-nfenum }-{ is_header-series }|
                                         ELSE is_header-nfenum ).

            DATA(lv_nota_replicacao) = abap_false.
            DATA(lt_stack) = cl_abap_get_call_stack=>get_call_stack( ).
            LOOP AT lt_stack INTO DATA(ls_stack_entry).
              IF ls_stack_entry-program_info CS 'ZCLMM_CRIAR_REPLIC_NF_WRITER'.
                lv_nota_replicacao = abap_true.
                EXIT.
              ENDIF.
            ENDLOOP.
            IF lv_nota_replicacao = abap_false.
              MESSAGE ID 'ZMM_DUPLICIDADE_NFE' TYPE 'E' NUMBER '001' WITH |{ ls_nfe-docnum ALPHA = OUT }|.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.
  ENDIF.

ENDIF.
