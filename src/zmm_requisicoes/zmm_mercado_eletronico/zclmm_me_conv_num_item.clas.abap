CLASS zclmm_me_conv_num_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_n_item
      IMPORTING
        !iv_num       TYPE char5
      RETURNING
        VALUE(rv_num) TYPE ebelp .
    METHODS get_dt_fim
      IMPORTING
        !iv_dtfim       TYPE string
      RETURNING
        VALUE(rv_dtfim) TYPE dats .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_me_conv_num_item IMPLEMENTATION.


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


  METHOD get_dt_fim.

    DATA(lv_data) = iv_dtfim.

    REPLACE ALL OCCURRENCES OF REGEX '[^0-9]' IN lv_data WITH ''.
    rv_dtfim = lv_data.

    IF rv_dtfim LT sy-datum.
      rv_dtfim = sy-datum.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
