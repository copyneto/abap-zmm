class ZCLMM_DETERMINACAO_CFOP definition
  public
  final
  create public .

public section.

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCLMM_DETERMINACAO_CFOP .
  methods EXECUTE
    changing
      !CV_SPCSTO type J_1BSPCSTO .
protected section.
private section.

  class-data GO_INSTANCE type ref to ZCLMM_DETERMINACAO_CFOP .
ENDCLASS.



CLASS ZCLMM_DETERMINACAO_CFOP IMPLEMENTATION.


  METHOD execute.

    CONSTANTS: lc_znlc   TYPE likp-lfart     VALUE 'ZNLC',
               lc_taxbra TYPE j_1bt007-kalsm VALUE 'TAXBRA',
               lc_tx     TYPE a003-kappl     VALUE 'TX',
               lc_icst   TYPE j_1baj-taxgrp  VALUE 'ICST'.

    FIELD-SYMBOLS <fs_likp_tra> TYPE likp.
    FIELD-SYMBOLS <fs_lips_tra> TYPE lips.

    ASSIGN ('(SAPLV50S)LIKP') TO <fs_likp_tra>.

    IF <fs_likp_tra> IS ASSIGNED.
      "Checar o tipo de remessa
      IF <fs_likp_tra>-lfart EQ lc_znlc.
        ASSIGN ('(SAPLV50S)LIPS') TO <fs_lips_tra>.
        "Checar o IVA determinado na remessa
        IF <fs_lips_tra> IS ASSIGNED.

          SELECT SINGLE out_mwskz
          FROM j_1bt007
           WHERE kalsm EQ @lc_taxbra
           AND sd_mwskz EQ @<fs_lips_tra>-j_1btxsdc
          INTO @DATA(lv_iva_imp).

          "Checar se o IVA de MM contém uma condição relacionada a ST:
          "Buscar o grupo de imposto dos tipos de condições encontradas
          IF sy-subrc IS INITIAL.

            SELECT COUNT(*)
            FROM a003
              JOIN j_1baj ON a003~kschl = j_1baj~taxtyp
             WHERE kappl EQ @lc_tx
              AND mwskz EQ @lv_iva_imp
              AND j_1baj~taxgrp = @lc_icst
            INTO @DATA(lv_kschl).

            IF sy-subrc IS INITIAL.
              cv_spcsto = '1'.
            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  method GET_INSTANCE.
    ro_instance = go_instance = COND #(
      WHEN go_instance IS BOUND
      THEN go_instance
      ELSE NEW zclmm_determinacao_cfop( )
    ).
  endmethod.
ENDCLASS.
