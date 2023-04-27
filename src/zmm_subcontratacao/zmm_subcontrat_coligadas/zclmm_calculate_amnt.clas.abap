class ZCLMM_CALCULATE_AMNT definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_BADI_CALCULATE_AMNT .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CALCULATE_AMNT IMPLEMENTATION.


  METHOD /xnfe/if_badi_calculate_amnt~calculate_amnt.

    CHECK it_item[] IS NOT INITIAL.

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      IF <fs_item>-indtot EQ 1.
        ev_amnt = ev_amnt - <fs_item>-vprod.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
