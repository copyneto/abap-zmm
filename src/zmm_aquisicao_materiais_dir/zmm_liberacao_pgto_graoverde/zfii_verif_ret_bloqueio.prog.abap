*&---------------------------------------------------------------------*
*& Include          ZFII_VERIF_RET_BLOQUEIO
*&---------------------------------------------------------------------*

  SELECT SINGLE zlspr
  FROM bseg
  INTO @DATA(lv_zlspr)
  WHERE bukrs EQ @bseg-bukrs
  AND belnr EQ @bseg-belnr
  AND gjahr EQ @bseg-gjahr
  AND buzei EQ @bseg-buzei
  AND koart EQ 'K'.

  CHECK sy-subrc IS INITIAL AND lv_zlspr EQ 'C'.

  DATA(lv_wf) = abap_false.

  IMPORT lv_wf TO lv_wf FROM MEMORY ID 'ZCLFI_DOC_PAGAR_WF'.

  IF sy-subrc EQ 0 AND lv_wf EQ abap_true.
    b_result = b_true.
    FREE MEMORY ID 'ZCLFI_DOC_PAGAR_WF'.
    EXIT.
  ENDIF.

  DATA(lv_flag) = abap_false.

  IMPORT lv_flag TO lv_flag FROM MEMORY ID 'ZRET_BLOQ'.

  IF bseg-zlspr IS INITIAL AND ( lv_flag IS INITIAL OR lv_flag EQ abap_false ).
    b_result = b_false.
    MESSAGE e002(zmm_lib_pgto_gv).
  ELSE.
    b_result = b_true.
    FREE MEMORY ID 'ZRET_BLOQ'.
  ENDIF.
