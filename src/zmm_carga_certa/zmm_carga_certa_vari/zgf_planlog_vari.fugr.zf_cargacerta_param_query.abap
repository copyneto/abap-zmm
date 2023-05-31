FUNCTION zf_cargacerta_param_query.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REPORT) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_PARAM) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PLANLOG_PARAM) TYPE  ZTTPLANLOG_PARAM
*"----------------------------------------------------------------------


  DATA: lt_planlog_param TYPE TABLE OF ztplanlog_param,
        ls_planlog_param TYPE zst_planlog_param.

  SELECT *  "#EC CI_NOWHERE
   FROM ztplanlog_param
    INTO TABLE lt_planlog_param.
  IF IV_report IS NOT INITIAL.
    DELETE lt_planlog_param WHERE report <> IV_report.
  ENDIF.

  IF IV_param IS NOT INITIAL.
    DELETE lt_planlog_param WHERE param <> IV_param.
  ENDIF.

  LOOP AT lt_planlog_param INTO DATA(ls_planlog_param1).
    MOVE-CORRESPONDING ls_planlog_param1 TO ls_planlog_param.
    APPEND ls_planlog_param TO et_planlog_param.
  ENDLOOP.

  SORT et_planlog_param BY report ascending param ascending.

ENDFUNCTION.
