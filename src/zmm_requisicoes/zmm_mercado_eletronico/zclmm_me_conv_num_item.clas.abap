class ZCLMM_ME_CONV_NUM_ITEM definition
  public
  final
  create public .

public section.

  methods GET_N_ITEM
    importing
      !IV_NUM type CHAR5
    returning
      value(RV_NUM) type EBELP .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_ME_CONV_NUM_ITEM IMPLEMENTATION.


  METHOD get_n_item.

    DATA: lv_n_item TYPE c LENGTH 5.
    lv_n_item = iv_num.

    CONDENSE lv_n_item NO-GAPS.

*    IF lv_n_item >= 10.
*      rv_num = ( iv_num / 10 ).
*    ELSE.
      rv_num = ( iv_num * 10 ).
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
