CLASS zclmm_lpp_calc_ipi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.



    METHODS constructor
      IMPORTING
        !is_delivery_values    TYPE zsmm_delivery_data
        !is_condition_settings TYPE ztmm_map_cond OPTIONAL
        !io_pricing            TYPE REF TO zclmm_lpp_calc.

    METHODS calcula_condicao_IPI0
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
      RAISING
        zcxmm_lpp_calc.

    METHODS calcula_condicao_IPI1
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
      RAISING
        zcxmm_lpp_calc.

    METHODS calcula_condicao_IPI2
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
      RAISING
        zcxmm_lpp_calc.

    METHODS get_values
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
        !ev_base  TYPE j_1btxic3-base
        !ev_rate  TYPE j_1btxic3-rate.

  PROTECTED SECTION.

  PRIVATE SECTION.
    "Variáveis
    DATA:gv_kbetr TYPE kbetr,
         gv_kwert TYPE j_1bnfpri, "kwert,
         gv_base  TYPE j_1btxic3-base,
         gv_rate  TYPE j_1btxic3-rate.

    "Estruturas
    DATA: gs_delivery_values TYPE zsmm_delivery_data.

    "Objeto
    DATA go_pricing TYPE REF TO zclmm_lpp_calc.

    METHODS calcula_base_rate_ipi.
ENDCLASS.

CLASS zclmm_lpp_calc_ipi IMPLEMENTATION.

  METHOD calcula_base_rate_ipi.

    "Variáveis
    DATA: lv_ncm           TYPE marc-steuc,
          lv_matnr         TYPE mara-matnr,
          lv_kunnr         TYPE kna1-kunnr,
          lv_date_form(10),
          lv_date          TYPE j_1btxdatf,
          lv_bukrs         TYPE bukrs,
          lv_werks         TYPE werks_d,
          lv_mwskz         TYPE mwskz,
          lv_mtuse         TYPE j_1bmatuse,
          lv_mtorg         TYPE j_1bmatorg,
          lv_matkl         TYPE matkl,
          lv_taxlaw        TYPE j_1btxic3-taxlaw,
          lv_tax_group     TYPE j_1btxgruop-gruop.

    lv_ncm    = gs_delivery_values-steuc.
    lv_matnr  = gs_delivery_values-matnr.
    lv_kunnr  = gs_delivery_values-kunnr.
    lv_bukrs  = gs_delivery_values-bukrs.
    lv_werks  = gs_delivery_values-werks.
    lv_mwskz  = gs_delivery_values-mwskz.
    lv_mtuse  = gs_delivery_values-mtuse.
    lv_mtorg  = gs_delivery_values-mtorg.
    lv_matkl  = gs_delivery_values-matkl.

    WRITE sy-datum TO lv_date_form DD/MM/YYYY.

    "Convertendo data
    CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
      EXPORTING
        input  = lv_date_form
      IMPORTING
        output = lv_date.

    CALL FUNCTION 'J_1B_READ_TXIP2'
      EXPORTING
        material = lv_matnr
        date     = lv_date
      IMPORTING
        rate     = gv_rate
        base     = gv_base
        taxlaw   = lv_taxlaw.

    IF gv_rate IS INITIAL AND lv_taxlaw IS INITIAL.

      CALL FUNCTION 'J_1B_READ_DYNAMIC_TABLE'
        EXPORTING
          caller         = 'MM'
          country        = 'BR'
          material       = lv_matnr
          material_group = lv_matkl
          customer       = lv_kunnr
          material_usage = lv_mtuse
          material_orig  = lv_mtorg
          mwskz          = lv_mwskz
          ncm            = lv_ncm
          date           = lv_date
          ipi            = 'X'
          i_bukrs        = lv_bukrs
          i_werks        = lv_werks
        IMPORTING
          rate           = gv_rate
          base           = gv_base
          taxlaw         = lv_taxlaw
          tax_group      = lv_tax_group.

      IF gv_rate IS INITIAL AND lv_taxlaw IS INITIAL.

        CALL FUNCTION 'J_1B_READ_TXIP1'
          EXPORTING
            ncm_code = lv_ncm
            date     = lv_date
          IMPORTING
            rate     = gv_rate.

        gv_base = 100.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD calcula_condicao_ipi0.
    ev_kbetr = 0.
    ev_kwert = 0.
  ENDMETHOD.

  METHOD calcula_condicao_ipi1.
    "Variáveis
    DATA: lv_base_calc_ipi TYPE j_1bnfpri, "kwert,
          lv_valor_ipi     TYPE j_1bnfpri. "kwert.

    "Calculando base de calculo IPI
    lv_base_calc_ipi = ( gv_base / 100 ) * gs_delivery_values-kwert.

    "Calculando valor IPI
    lv_valor_ipi = ( gv_rate / 100 ) * lv_base_calc_ipi.

    "Retornando valores
    ev_kbetr = gv_rate.
    ev_kwert = lv_valor_ipi.
  ENDMETHOD.

  METHOD calcula_condicao_ipi2.
    calcula_condicao_ipi1( IMPORTING ev_kbetr = ev_kbetr
                                     ev_kwert = ev_kwert ).

  ENDMETHOD.

  METHOD constructor.
    gs_delivery_values = is_delivery_values.
    go_pricing         = io_pricing.

    "Calculando base e rate
    calcula_base_rate_ipi( ).

    "Calculando condição
    IF is_condition_settings IS NOT INITIAL.
      CALL METHOD (is_condition_settings-metodo)
        IMPORTING
          ev_kbetr = gv_kbetr
          ev_kwert = gv_kwert.
    ENDIF.
  ENDMETHOD.

  METHOD get_values.
    ev_base  = gv_base.
    ev_kbetr = gv_kbetr.
    ev_kwert = gv_kwert.
    ev_rate  = gv_rate.
  ENDMETHOD.
ENDCLASS.
