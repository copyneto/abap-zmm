*&---------------------------------------------------------------------*
*& Include zmmi_update_status
*&---------------------------------------------------------------------*

TYPES: ty_eban     TYPE STANDARD TABLE OF ueban WITH EMPTY KEY.

CONSTANTS:
  gc_m TYPE c VALUE 'M',
  gc_u TYPE c VALUE 'U'.

DATA:
  lt_xeban TYPE STANDARD TABLE OF ueban,
  lt_yeban TYPE STANDARD TABLE OF ueban,
  lt_xebkn TYPE STANDARD TABLE OF uebkn,
  lt_yebkn TYPE STANDARD TABLE OF uebkn.

SELECT a~* FROM eban AS a
INNER JOIN ztmm_envio_req AS b
ON a~banfn = b~doc_sap
AND a~bnfpo = b~doc_item
AND b~status = @gc_m
WHERE banfn = @im_banfn
AND loekz IS INITIAL
AND zz1_statu IS INITIAL
INTO CORRESPONDING FIELDS OF TABLE @lt_xeban.

IF lt_xeban IS NOT INITIAL.

  lt_yeban = lt_xeban.

  LOOP AT lt_xeban ASSIGNING FIELD-SYMBOL(<fs_eban>).
    <fs_eban>-zz1_statu = gc_m .
    <fs_eban>-kz        = gc_u.
  ENDLOOP.

  CALL FUNCTION 'ME_UPDATE_REQUISITION'
    TABLES
      xeban = lt_xeban
      xebkn = lt_xebkn
      yeban = lt_yeban
      yebkn = lt_yebkn.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

ENDIF.

*CALL FUNCTION 'ZFMMM_VALIDATE_STATUSME'
*  STARTING NEW TASK 'ZMM_MEATUALIZA'
*  EXPORTING
*    iv_banfn = im_banfn.
