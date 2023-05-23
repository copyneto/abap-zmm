FUNCTION zf_cargacerta_param_query.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_REPORT) TYPE  CHAR30 OPTIONAL
*"     VALUE(I_PARAM) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PLANLOG_PARAM) TYPE  ZTTPLANLOG_PARAM
*"----------------------------------------------------------------------


  DATA: lt_planlog_param TYPE TABLE OF ztplanlog_param,
        es_planlog_param TYPE zst_planlog_param.

  SELECT *  "#EC CI_NOWHERE
   FROM ztplanlog_param
    INTO TABLE lt_planlog_param.
  IF i_report IS NOT INITIAL.
    DELETE lt_planlog_param WHERE report <> i_report.
  ENDIF.

  IF i_param IS NOT INITIAL.
    DELETE lt_planlog_param WHERE param <> i_param.
  ENDIF.

  LOOP AT lt_planlog_param INTO DATA(ls_planlog_param).
    MOVE-CORRESPONDING ls_planlog_param TO es_planlog_param.
    APPEND es_planlog_param TO et_planlog_param.
  ENDLOOP.

  SORT et_planlog_param BY report ascending param ascending.

ENDFUNCTION.
