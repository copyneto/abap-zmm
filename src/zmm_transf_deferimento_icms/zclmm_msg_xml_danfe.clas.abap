class ZCLMM_MSG_XML_DANFE definition
  public
  final
  create public .

public section.

  class-data GT_TLINE type TLINE .

  class-methods VALIDAR_ICMSDIF
    importing
      !IV_BRANCH type J_1BBRANC_
      !IV_BUKRS type BUKRS
      !IV_REGIO type REGIO
      !IV_DATE type J_1BTXDATF
    exporting
      !ES_SADR type SADR
      !ES_ZREGIO_DIFERI type ZTMM_REGIO_DIFER
      !EV_RATE type J_1BTXIC1-RATE
    returning
      value(RV_RETURN) type BOOLEAN_FLG .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_MSG_XML_DANFE IMPLEMENTATION.


  METHOD validar_icmsdif.

    SELECT SINGLE * FROM ztmm_regio_difer
     INTO es_zregio_diferi
       WHERE regio EQ iv_regio.

    CHECK sy-subrc EQ 0.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = iv_branch
        bukrs             = iv_bukrs
      IMPORTING
        address           = es_sadr
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.

    IF sy-subrc = 0.
      CALL FUNCTION 'J_1B_READ_TXIC1'
        EXPORTING
          country    = es_sadr-land1
          state_from = es_sadr-regio
          state_to   = iv_regio
          date       = iv_date
        IMPORTING
          rate       = ev_rate.
    ENDIF.

    IF es_sadr-regio EQ iv_regio.
      rv_return = 'X'. "Variável booleana (X=verdadeiro, espaço=falso)
    ENDIF.

  ENDMETHOD.
ENDCLASS.
