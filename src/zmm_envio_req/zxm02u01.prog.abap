*&---------------------------------------------------------------------*
*& Include          ZXM02U01
*&---------------------------------------------------------------------*
TABLES: ci_ebandb.

CONSTANTS: BEGIN OF gc_param,
             modulo	TYPE ze_param_modulo VALUE 'MM',
             chave1	TYPE ze_param_chave VALUE 'GAP_292',
             chave2	TYPE ze_param_chave VALUE 'BSART',
             chave3	TYPE ze_param_chave_3 VALUE 'TP_REQ',
           END OF gc_param.

DATA : ls_mereq_item   TYPE mereq_item,
       ls_mereq_header TYPE mereq_header,
       lv_cur_activity TYPE aktvt,
       lv_flag         TYPE char1.

* clear eban values if no PReq item
IF im_req_item IS INITIAL.
  CLEAR: ci_ebandb.
ELSE.

* read item data from system
  ls_mereq_item = im_req_item->get_data( ).

  ci_ebandb-zz1_statu    = ls_mereq_item-zz1_statu.
  ci_ebandb-zz1_verid    = ls_mereq_item-zz1_verid.
  ci_ebandb-zz1_matnr    = ls_mereq_item-zz1_matnr.

ENDIF.

SELECT sign, opt, low, high
  FROM ztca_param_val
  WHERE modulo = @gc_param-modulo
    AND chave1 = @gc_param-chave1
    AND chave2 = @gc_param-chave2
    AND chave3 = @gc_param-chave3
  INTO TABLE @DATA(lt_bsart).

CALL METHOD im_req_item->get_activity
  RECEIVING
    re_aktvt = lv_cur_activity.

IF ls_mereq_item-bsart IN lt_bsart.
  CASE lv_cur_activity.
    WHEN 'A'.
      lv_flag = 0.
    WHEN 'V'.
      lv_flag = 1. "Modify
  ENDCASE.
ELSE.
  lv_flag = 2.
ENDIF.

FREE MEMORY ID 'Z_FLAG_INPUT_ZXM02U01'.
EXPORT lv_flag FROM lv_flag TO MEMORY ID 'Z_FLAG_INPUT_ZXM02U01'.
