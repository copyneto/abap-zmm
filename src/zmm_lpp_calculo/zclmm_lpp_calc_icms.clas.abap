CLASS ZCLmm_lpp_calc_icms DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.



    METHODS constructor
      IMPORTING
        !is_delivery_values    TYPE zsmm_delivery_data
        !is_condition_settings TYPE ztmm_map_cond OPTIONAL
        !io_pricing            TYPE REF TO zclmm_lpp_calc.

    METHODS calcula_condicao_icm0
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
      RAISING
        zcxmm_lpp_calc.

    METHODS calcula_condicao_icm1
      EXPORTING
        !ev_kbetr TYPE kbetr
        !ev_kwert TYPE j_1bnfpri "kwert
      RAISING
        zcxmm_lpp_calc.

    METHODS calcula_condicao_icm2
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

    METHODS calcula_base_rate_icms.
ENDCLASS.

CLASS ZCLmm_lpp_calc_icms IMPLEMENTATION.

  METHOD calcula_base_rate_icms.

    "Variáveis
    DATA: lv_state_from    TYPE j_1btaxjur-state,
          lv_state_to      TYPE j_1btaxjur-state,
          lv_matnr         TYPE mara-matnr,
          lv_kunnr         TYPE kna1-kunnr,
          lv_date_form(10),
          lv_date          TYPE j_1btxdatf,
          lv_bukrs         TYPE bukrs,
          lv_werks         TYPE werks_d,
          lv_ncm           TYPE marc-steuc,
          lv_mwskz         TYPE mwskz,
          lv_mtuse         TYPE j_1bmatuse,
          lv_mtorg         TYPE j_1bmatorg,
          lv_matkl         TYPE matkl,
          lv_taxlaw        TYPE j_1btxic3-taxlaw,
          lv_tax_group     TYPE j_1btxgruop-gruop.

    lv_state_from = gs_delivery_values-ship_from.
    lv_state_to   = gs_delivery_values-ship_to.
    lv_matnr      = gs_delivery_values-matnr.
    lv_kunnr      = gs_delivery_values-kunnr.
    lv_bukrs      = gs_delivery_values-bukrs.
    lv_werks      = gs_delivery_values-werks.
    lv_ncm        = gs_delivery_values-steuc.
    lv_mwskz      = gs_delivery_values-mwskz.
    lv_mtuse      = gs_delivery_values-mtuse.
    lv_mtorg      = gs_delivery_values-mtorg.
    lv_matkl      = gs_delivery_values-matkl.

    WRITE sy-datum TO lv_date_form DD/MM/YYYY.

    "Convertendo data
    CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
      EXPORTING
        input  = lv_date_form
      IMPORTING
        output = lv_date.

    CALL FUNCTION 'J_1B_READ_TXIC2'
      EXPORTING
        country    = 'BR'
        state_from = lv_state_from
        state_to   = lv_state_to
        material   = lv_matnr
        date       = lv_date
      IMPORTING
        rate       = gv_rate
        base       = gv_base
        taxlaw     = lv_taxlaw.

    IF gv_rate IS INITIAL AND lv_taxlaw IS INITIAL.

      CALL FUNCTION 'J_1B_READ_DYNAMIC_TABLE'
        EXPORTING
          caller         = 'MM'
          country        = 'BR'
          state_from     = lv_state_from
          state_to       = lv_state_to
          material       = lv_matnr
          material_group = lv_matkl
          customer       = lv_kunnr
          material_usage = lv_mtuse
          material_orig  = lv_mtorg
          mwskz          = lv_mwskz
          ncm            = lv_ncm
          date           = lv_date
          icms           = 'X'
          i_bukrs        = lv_bukrs
          i_werks        = lv_werks
        IMPORTING
          rate           = gv_rate
          base           = gv_base
          taxlaw         = lv_taxlaw
          tax_group      = lv_tax_group.

      IF gv_rate IS INITIAL AND lv_taxlaw IS INITIAL.

        CALL FUNCTION 'J_1B_READ_TXIC1'
          EXPORTING
            country    = 'BR'
            state_from = lv_state_from
            state_to   = lv_state_to
            date       = lv_date
          IMPORTING
            rate       = gv_rate.

        gv_base = 100.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD calcula_condicao_icm0.
    ev_kbetr = 0.
    ev_kwert = 0.
  ENDMETHOD.

  METHOD calcula_condicao_icm1.
    "Variáveis
    DATA: lv_base_calc_icms TYPE j_1bnfpri, "kwert,
          lv_valor_icms     TYPE j_1bnfpri, "kwert,
          lv_check.

    "Calculando base de calculo ICMS
    lv_base_calc_icms = ( gv_base / 100 ) * gs_delivery_values-kwert.

    "Calculando valor ICMS
    lv_valor_icms = ( gv_rate / 100 ) * lv_base_calc_icms.

    "Retornando valores
    ev_kbetr = gv_rate.
    ev_kwert = lv_valor_icms.
  ENDMETHOD.

  METHOD calcula_condicao_icm2.
    "Variáveis
    DATA: lv_base_calc_ipi  TYPE j_1bnfpri, "kwert,
          lv_base_calc_icms TYPE j_1bnfpri, "kwert,
          lv_valor_ipi      TYPE j_1bnfpri, "kwert,
          lv_valor_icms     TYPE j_1bnfpri. "kwert.

    "Objetos
    DATA: lo_ipi TYPE REF TO zclmm_LPP_CALC_ipi.


    "Verificando se existe IPI2 para o IVA processado
    DATA(lv_check) = go_pricing->check_condition( 'IPI2' ).

    IF lv_check IS NOT INITIAL AND gs_delivery_values-mtuse NE 0. "Caso existir o IPI2
      "Criando objeto para calculo de IPI
      CREATE OBJECT lo_ipi
        EXPORTING
          is_delivery_values = gs_delivery_values
          io_pricing         = go_pricing.

      "Calculando taxa IPI2
      lo_ipi->calcula_condicao_ipi2( IMPORTING ev_kwert = lv_valor_ipi ).

      "Calculando base de calculo ICMS
      lv_base_calc_icms = ( gv_base / 100 ) * ( gs_delivery_values-kwert + lv_valor_ipi ).

      "Calculando valor ICMS
      lv_valor_icms = ( gv_rate / 100 ) * lv_base_calc_icms.
    ELSE. "Caso não existir o IPI2
      "Calculando base de calculo ICMS
      lv_base_calc_icms = ( gv_base / 100 ) * gs_delivery_values-kwert.

      "Calculando valor ICMS
      lv_valor_icms = ( gv_rate / 100 ) * lv_base_calc_icms.
    ENDIF.

    "Retornando valores
    ev_kbetr = gv_rate.
    ev_kwert = lv_valor_icms.
  ENDMETHOD.

  METHOD constructor.
    gs_delivery_values = is_delivery_values.
    go_pricing         = io_pricing.

    "Calculando base e rate
    calcula_base_rate_icms( ).

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
