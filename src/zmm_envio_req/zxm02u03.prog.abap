*&---------------------------------------------------------------------*
*& Include          ZXM02U03
*&---------------------------------------------------------------------*

DATA: ls_mereq_item TYPE mereq_item,
      lv_aktvt       TYPE aktvt.

IF NOT im_req_item IS INITIAL.
  " read item data from system
  ls_mereq_item = im_req_item->get_data( ).

  lv_aktvt = im_req_item->get_activity( ).

*  IF lv_aktvt EQ 'A'.

*  ELSEIF lv_aktvt EQ 'V' OR lv_aktvt EQ 'H'.
    IF ls_mereq_item-zz1_statu NE ci_ebandb-zz1_statu.
      ls_mereq_item-zz1_statu = ci_ebandb-zz1_statu.
      ex_changed = abap_true.
    ENDIF.
    IF ls_mereq_item-zz1_matnr NE ci_ebandb-zz1_matnr.
      ls_mereq_item-zz1_matnr = ci_ebandb-zz1_matnr.
      ex_changed = abap_true.
    ENDIF.

    IF ls_mereq_item-zz1_verid NE ci_ebandb-zz1_verid.
      ls_mereq_item-zz1_verid = ci_ebandb-zz1_verid.
      ex_changed = abap_true.
    ENDIF.

    IF ex_changed = abap_true.
      CALL METHOD im_req_item->set_data( ls_mereq_item ).
    ENDIF.

*  ENDIF.

ENDIF.
