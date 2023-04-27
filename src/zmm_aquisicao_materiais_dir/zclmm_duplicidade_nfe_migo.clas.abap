CLASS zclmm_duplicidade_nfe_migo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_ex_mb_check_line_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zclmm_duplicidade_nfe_migo IMPLEMENTATION.


  METHOD if_ex_mb_check_line_badi~check_line.

    DATA: lv_nfenum_in  TYPE j_1bnfdoc-nfenum,
          lv_nfenumc    TYPE j_1bnfdoc-nfenum,
          lv_nfenum_out TYPE char12,
          lv_series     TYPE j_1bnfdoc-series,
          lv_seriesc    TYPE numc3,
          lt_error      TYPE STANDARD TABLE OF mrm_errprot,
          lr_bwart      TYPE RANGE OF bwart,
          lr_nftype     TYPE RANGE OF j_1bnfdoc-nftype.

    IF is_mseg-smbln IS INITIAL. " Documento não estornado

      SPLIT is_mkpf-xblnr AT '-' INTO lv_nfenumc lv_seriesc.

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

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_seriesc
        IMPORTING
          output = lv_series.

      IF lv_nfenum_in  IS NOT INITIAL
     AND lv_series     IS NOT INITIAL
     AND is_mseg-lifnr IS NOT INITIAL.

        SELECT docnum,
               nfenum,
               series,
               parid
          FROM j_1bnfdoc
          INTO TABLE @DATA(lt_nfe)
         WHERE nfenum LIKE @lv_nfenum_out
           AND series EQ   @lv_series
           AND direct EQ   '1'
           AND parid  EQ   @is_mseg-lifnr
           AND cancel EQ   @space.

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

          MESSAGE ID 'ZMM_DUPLICIDADE_NFE' TYPE 'E' NUMBER '001' WITH |{ <fs_nfe>-docnum ALPHA = OUT }|.

        ENDLOOP.

*        IF sy-subrc IS INITIAL.
*
*          MESSAGE ID 'ZMM_DUPLICIDADE_NFE' TYPE 'E' NUMBER '001' WITH is_mkpf-xblnr.
*
*        ENDIF.

      ENDIF.

    ENDIF.

*==============

    " Validação Entrada de Mercadoria - SAGA
    INCLUDE zmmi_saga_entrada_merc IF FOUND.

  ENDMETHOD.
ENDCLASS.
