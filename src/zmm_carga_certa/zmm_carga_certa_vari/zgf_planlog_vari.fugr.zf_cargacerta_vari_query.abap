FUNCTION zf_cargacerta_vari_query.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_REPORT) TYPE  CHAR30 OPTIONAL
*"     VALUE(I_VARI) TYPE  CHAR30 OPTIONAL
*"     VALUE(I_APP) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PLANLOG_VARI) TYPE  ZTTPLANLOG_VARI
*"----------------------------------------------------------------------

  CONSTANTS: lc_mb52 TYPE sy-cprog VALUE 'RM07MLBS'.

  DATA: lt_planlog_vari TYPE TABLE OF ztplanlog_vari,
        es_planlog_vari TYPE zsplanlog_vari,
        lc_vari         TYPE c LENGTH 4 VALUE 'VARI',
        lv_cont         TYPE i.

  SELECT *  "#EC CI_NOWHERE "#EC CI_SEL_DEL
   FROM ztplanlog_vari
    INTO TABLE lt_planlog_vari.
  IF i_report IS NOT INITIAL.
    DELETE lt_planlog_vari WHERE report <> i_report. "#EC CI_SEL_DEL
    IF i_report = 'MB52'.
      CLEAR lt_planlog_vari.
      SELECT *
        FROM varid
        INTO TABLE @DATA(lt_varid_mb52)
        WHERE report = @lc_mb52.
      IF sy-subrc EQ 0.
        LOOP AT lt_varid_mb52 INTO DATA(ls_varid_mb52).
          lv_cont = +1.
          es_planlog_vari-cont = lv_cont.
          es_planlog_vari-vari = ls_varid_mb52-variant.
          es_planlog_vari-report = lc_mb52.
          APPEND es_planlog_vari TO et_planlog_vari.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

  IF i_vari IS NOT INITIAL.
    DELETE lt_planlog_vari WHERE vari <> i_vari.
  ENDIF.

  LOOP AT lt_planlog_vari INTO DATA(ls_planlog_vari).
    MOVE-CORRESPONDING ls_planlog_vari TO es_planlog_vari.

    CASE es_planlog_vari-opti.
      WHEN 'EQ'.
        es_planlog_vari-opti_desc = 'Igual'.
      WHEN 'BT'.
        es_planlog_vari-opti_desc = 'Entre'.
      WHEN 'NE'.
        es_planlog_vari-opti_desc = 'Diferente de'.
    ENDCASE.

    CONDENSE es_planlog_vari-cont NO-GAPS.
    APPEND es_planlog_vari TO et_planlog_vari.
  ENDLOOP.

  IF i_app = 'CARGA'.
    SORT et_planlog_vari BY vari.
    DELETE ADJACENT DUPLICATES FROM et_planlog_vari COMPARING vari.
  ENDIF.


  SORT et_planlog_vari BY report vari.

ENDFUNCTION.
