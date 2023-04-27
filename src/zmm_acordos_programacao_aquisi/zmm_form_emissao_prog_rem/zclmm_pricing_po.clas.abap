class ZCLMM_PRICING_PO definition
  public
  final
  create public .

public section.

  methods SIMULATE_PRICING
    importing
      !IV_EBELN type EBELN
      !IV_EBELP type EBELP
      !IV_QTD_SIMULADA type KTMNG
    exporting
      !ET_KOMV type KOMV_T .
  methods GET_REMES_PRICING
    importing
      !IV_EBELN type EBELN
    exporting
      !ET_KOMP type KOMP_T
      !ET_KOMV type KOMV_T .
protected section.
private section.

  methods GET_EKKO_EKPO
    importing
      !IV_EBELN type EBELN
      !IV_EBELP type EBELP
    exporting
      !ES_EKKO type EKKO
      !ES_EKPO type EKPO .
ENDCLASS.



CLASS ZCLMM_PRICING_PO IMPLEMENTATION.


  METHOD get_ekko_ekpo.

    CHECK iv_ebeln IS NOT INITIAL.

    SELECT SINGLE *
      FROM ekko
     WHERE ebeln = @iv_ebeln
      INTO @es_ekko.

    SELECT SINGLE *
      FROM ekpo
     WHERE ebeln = @iv_ebeln
       AND ebelp = @iv_ebelp
      INTO @es_ekpo.

  ENDMETHOD.


  METHOD get_remes_pricing.

    DATA: lt_komv TYPE STANDARD TABLE OF komv.

    DATA: ls_komk TYPE komk,
          ls_komp TYPE komp.

    CHECK iv_ebeln IS NOT INITIAL.

    SELECT SINGLE *
      FROM ekko
     WHERE ebeln = @iv_ebeln
      INTO @DATA(ls_ekko).

    IF sy-subrc IS INITIAL.
      SELECT *
        FROM ekpo
       WHERE ebeln = @iv_ebeln
        INTO TABLE @DATA(lt_ekpo).

      IF sy-subrc IS INITIAL.

        LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

          CALL FUNCTION 'ME_PRICING_DIALOG'
            EXPORTING
              dunkel = abap_true
              i_ekpo = <fs_ekpo>
              meins  = <fs_ekpo>-meins
              menge  = <fs_ekpo>-ktmng
              termin = sy-datlo.

          CALL FUNCTION 'ME_PRICING_CONTRACT'
            EXPORTING
              dialog     = space
              kopf       = ls_ekko
              position   = <fs_ekpo>
              simulation = abap_true
            IMPORTING
              preisk     = ls_komk
              preisp     = ls_komp.

          IF ls_komk IS NOT INITIAL
         AND ls_komp IS NOT INITIAL.

            CALL FUNCTION 'PRICING'
              EXPORTING
                calculation_type = 'B'
                comm_head_i      = ls_komk
                comm_item_i      = ls_komp
              TABLES
                tkomv            = lt_komv.

            CALL FUNCTION 'PRICING'
              EXPORTING
                calculation_type = 'A'
                comm_head_i      = ls_komk
                comm_item_i      = ls_komp
              TABLES
                tkomv            = lt_komv.

            APPEND LINES OF lt_komv TO et_komv.
            APPEND ls_komp TO et_komp.

            CLEAR: ls_komk,
                   ls_komp.

            FREE: lt_komv.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD simulate_pricing.

    DATA: ls_komk TYPE komk,
          ls_komp TYPE komp.

    DATA: lv_qtd TYPE ktmng.

    me->get_ekko_ekpo(
      EXPORTING
        iv_ebeln = iv_ebeln
        iv_ebelp = iv_ebelp
      IMPORTING
        es_ekko  = DATA(ls_ekko)
        es_ekpo  = DATA(ls_ekpo) ).

    IF ls_ekko IS NOT INITIAL
   AND ls_ekpo IS NOT INITIAL.

      IF iv_qtd_simulada IS NOT INITIAL.
        lv_qtd = iv_qtd_simulada.
      ELSE.
        lv_qtd = ls_ekpo-ktmng.
      ENDIF.

      CALL FUNCTION 'ME_PRICING_DIALOG'
        EXPORTING
          dunkel = abap_true
          i_ekpo = ls_ekpo
          meins  = ls_ekpo-meins
          menge  = lv_qtd
          termin = sy-datlo.

      CALL FUNCTION 'ME_PRICING_CONTRACT'
        EXPORTING
          dialog     = space
          kopf       = ls_ekko
          position   = ls_ekpo
          simulation = abap_true
        IMPORTING
          preisk     = ls_komk
          preisp     = ls_komp.

      IF ls_komk IS NOT INITIAL
     AND ls_komp IS NOT INITIAL.

        CALL FUNCTION 'PRICING'
          EXPORTING
            calculation_type = 'B'
            comm_head_i      = ls_komk
            comm_item_i      = ls_komp
          TABLES
            tkomv            = et_komv.

        CALL FUNCTION 'PRICING'
          EXPORTING
            calculation_type = 'A'
            comm_head_i      = ls_komk
            comm_item_i      = ls_komp
          TABLES
            tkomv            = et_komv.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
