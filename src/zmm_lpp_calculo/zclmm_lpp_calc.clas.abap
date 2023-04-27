CLASS zclmm_lpp_calc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !iv_mwskz           TYPE mwskz OPTIONAL
        !is_delivery_values TYPE zsmm_delivery_data
      RAISING
        zcxmm_lpp_calc.

    METHODS check_condition
      IMPORTING
        !iv_kschl       TYPE kschl
      RETURNING
        VALUE(rv_check) TYPE abap_bool.

    METHODS get_lpp_net_value
      IMPORTING
        iv_kawrt        TYPE komv-kawrt OPTIONAL
      RETURNING
        VALUE(rv_value) TYPE kwert.

  PROTECTED SECTION.

  PRIVATE SECTION.

    "Tabelas internas
    DATA: gt_kschl         TYPE TABLE OF zsmm_conditions,
          gt_condition_map TYPE TABLE OF ztmm_map_cond.

    "Estruturas
    DATA: gs_delivery_values TYPE zsmm_delivery_data.

    "Objetos
    DATA: go_icms_tax TYPE REF TO zclmm_LPP_CALC_icms,
          go_ipi_tax  TYPE REF TO zclmm_LPP_CALC_ipi.

    METHODS get_a003
      RAISING
        zcxmm_lpp_calc.

    METHODS unit_measure_conversion_in
      IMPORTING
                iv_meins_in     TYPE meins
                iv_meins_out    TYPE meins
                iv_kwert        TYPE j_1bnfpri
      RETURNING VALUE(rv_value) TYPE j_1bnfpri.

    METHODS unit_measure_conversion_out
      IMPORTING
                iv_meins_in     TYPE meins
                iv_meins_out    TYPE meins
                iv_kwert        TYPE j_1bnfpri
      RETURNING VALUE(rv_value) TYPE j_1bnfpri.

    METHODS get_methods_calculate
      RAISING
        zcxmm_lpp_calc.

    METHODS get_pricing
      RAISING
        zcxmm_lpp_calc.

    METHODS get_pricing_icms
      IMPORTING
        !is_condition_settings TYPE ztmm_map_cond.

    METHODS get_pricing_ipi
      IMPORTING
        !is_condition_settings TYPE ztmm_map_cond.

ENDCLASS.



CLASS zclmm_lpp_calc IMPLEMENTATION.

  METHOD constructor.
    IF is_delivery_values IS INITIAL.
      "O preenchimento dos dados da remessa são obrigatórios
      RAISE EXCEPTION TYPE zcxmm_lpp_calc
        EXPORTING
          is_textid = zcxmm_lpp_calc=>gc_erro_po_values_is_empty.
    ENDIF.

    "Armazenando os valores
    gs_delivery_values = is_delivery_values.


    "Checando a necessidade de fazer conversão unidade de medida ( UN NF X UN Material )
    IF gs_delivery_values-meins_nf NE gs_delivery_values-meins.
      gs_delivery_values-kwert = unit_measure_conversion_in( iv_meins_in  = gs_delivery_values-meins_nf
                                                             iv_meins_out = gs_delivery_values-meins
                                                             iv_kwert     = gs_delivery_values-kwert ).
    ENDIF.

    "Buscando as condições do IVA
    get_a003( ).

    "Buscando os métodos de cálculo para cada condição
    get_methods_calculate( ).

    "Cálculando as condições
    get_pricing( ).
  ENDMETHOD.

  METHOD get_a003.
    "Selecionando as condições da tabela A003 pelo IVA
    SELECT kschl
      FROM a003
      INTO TABLE gt_kschl
      WHERE mwskz = gs_delivery_values-mwskz.

    IF sy-subrc IS NOT INITIAL.
      "Não foi encontrado as condições para o IVA &
      RAISE EXCEPTION TYPE zcxmm_lpp_calc
        EXPORTING
          is_textid = zcxmm_lpp_calc=>gc_erro_conditions_not_found
          iv_msgv1  = CONV #( gs_delivery_values-mwskz ).
    ENDIF.
  ENDMETHOD.

  METHOD get_methods_calculate.
    IF gt_kschl IS NOT INITIAL.
      "Selecionando os métodos para cálculo
      SELECT *                                     "#EC CI_NO_TRANSFORM
        FROM ztmm_map_cond
        INTO TABLE gt_condition_map
        FOR ALL ENTRIES IN gt_kschl
        WHERE kschl   = gt_kschl-kschl
          AND calcula = abap_true.
    ENDIF.

    IF gt_kschl IS INITIAL.
      "Mapeamento não encontrados na transação ZMM_LPP_CONDITIONS_MAP
      RAISE EXCEPTION TYPE zcxmm_lpp_calc
        EXPORTING
          is_textid = zcxmm_lpp_calc=>gc_erro_methods_not_found.
    ENDIF.

  ENDMETHOD.

  METHOD get_pricing.
    LOOP AT gt_condition_map ASSIGNING FIELD-SYMBOL(<fs_s_condition_map>).
      AT NEW grupo.
        CASE <fs_s_condition_map>-grupo.
          WHEN '01'. "IPI
            get_pricing_ipi( <fs_s_condition_map> ).

          WHEN '02'. "ICMS
            get_pricing_icms( <fs_s_condition_map> ).
          WHEN OTHERS.
        ENDCASE.
      ENDAT.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_pricing_icms.
    CREATE OBJECT go_icms_tax
      EXPORTING
        is_delivery_values    = gs_delivery_values
        is_condition_settings = is_condition_settings
        io_pricing            = me.
  ENDMETHOD.

  METHOD get_pricing_ipi.
    CREATE OBJECT go_ipi_tax
      EXPORTING
        is_delivery_values    = gs_delivery_values
        is_condition_settings = is_condition_settings
        io_pricing            = me.

  ENDMETHOD.

  METHOD check_condition.
    TRY.
        DATA(ls_kschl) = gt_kschl[ kschl = iv_kschl ].   "#EC CI_STDSEQ

        rv_check = abap_true.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD get_lpp_net_value.
    "Variáveis
    DATA: lv_kwert_ipi     TYPE j_1bnfpri,
          lv_kwert_icms    TYPE j_1bnfpri,
          lv_kawrt         TYPE komv-kawrt,
          lv_lpp_net_value TYPE j_1bnfpri.

    "IPI
    IF go_ipi_tax IS NOT INITIAL.
      go_ipi_tax->get_values(
        IMPORTING
          ev_kwert = lv_kwert_ipi ).
    ENDIF.

    "ICMS
    IF go_icms_tax IS NOT INITIAL.
      go_icms_tax->get_values(
        IMPORTING
          ev_kwert = lv_kwert_icms ).
    ENDIF.

    IF iv_kawrt IS INITIAL.
      lv_kawrt = 1.
    ELSE.
      lv_kawrt = iv_kawrt / 10.
    ENDIF.

    lv_lpp_net_value = ( ( gs_delivery_values-kwert - lv_kwert_icms ) * lv_kawrt ).

    "Checando a necessidade de fazer conversão unidade de medida ( UN Remessa X UN Material )
    IF gs_delivery_values-meins_rem NE gs_delivery_values-meins.
      lv_lpp_net_value = unit_measure_conversion_out( iv_meins_in  = gs_delivery_values-meins_rem
                                                      iv_meins_out = gs_delivery_values-meins
                                                      iv_kwert     = lv_lpp_net_value ).
    ENDIF.

    rv_value = lv_lpp_net_value.
  ENDMETHOD.


  METHOD unit_measure_conversion_in.
    "Variáveis
    DATA: lv_menge_old TYPE bstmg,
          lv_menge     TYPE bstmg.

    lv_menge_old = 1.

    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = gs_delivery_values-matnr
        i_in_me              = iv_meins_in
        i_out_me             = iv_meins_out
        i_menge              = lv_menge_old
      IMPORTING
        e_menge              = lv_menge
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.

    IF sy-subrc <> 0.
      lv_menge = 1.
    ENDIF.

    SELECT SINGLE umrez,
                  umren
      FROM marm
      INTO @DATA(ls_marm)
      WHERE matnr = @gs_delivery_values-matnr
        AND meinh = @iv_meins_in.

    IF ls_marm-umrez > ls_marm-umren.
      rv_value = iv_kwert / lv_menge.
    ELSE.
      rv_value = iv_kwert * lv_menge.
    ENDIF.
  ENDMETHOD.

  METHOD unit_measure_conversion_out.
    "Variáveis
    DATA: lv_menge_old TYPE bstmg,
          lv_menge     TYPE bstmg.

    lv_menge_old = 1.

    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = gs_delivery_values-matnr
        i_in_me              = iv_meins_in
        i_out_me             = iv_meins_out
        i_menge              = lv_menge_old
      IMPORTING
        e_menge              = lv_menge
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.

    IF sy-subrc <> 0.
      lv_menge = 1.
    ENDIF.

    SELECT SINGLE umrez,
                  umren
      FROM marm
      INTO @DATA(ls_marm)
      WHERE matnr = @gs_delivery_values-matnr
        AND meinh = @iv_meins_in.

    IF ls_marm-umrez > ls_marm-umren.
      rv_value = iv_kwert * lv_menge.
    ELSE.
      rv_value = iv_kwert / lv_menge.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
