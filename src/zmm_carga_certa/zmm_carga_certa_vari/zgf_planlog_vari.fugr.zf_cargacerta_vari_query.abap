FUNCTION ZF_CARGACERTA_VARI_QUERY .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REPORT) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_VARI) TYPE  CHAR30 OPTIONAL
*"     VALUE(IV_APP) TYPE  CHAR30 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PLANLOG_VARI) TYPE  ZTTPLANLOG_VARI
*"----------------------------------------------------------------------

  CONSTANTS: lc_mb52 TYPE sy-cprog VALUE 'RM07MLBS'.

  DATA: lt_planlog_vari TYPE TABLE OF ztplanlog_vari,
        ls_planlog_vari TYPE zsplanlog_vari,
        lv_vari         TYPE c LENGTH 4 VALUE 'VARI',
        lv_cont         TYPE i.

  SELECT *   "#EC CI_NOWHERE "#EC CI_SEL_DEL
   FROM ztplanlog_vari
    INTO TABLE lt_planlog_vari.
  IF IV_report IS NOT INITIAL.
    DELETE lt_planlog_vari WHERE report <> IV_report. "#EC CI_SEL_DEL
    IF IV_report = 'MB52'.
      CLEAR lt_planlog_vari.
      SELECT *
        FROM varid
        INTO TABLE @DATA(lt_varid_mb52)
        WHERE report = @lc_mb52.
      IF sy-subrc EQ 0.
        LOOP AT lt_varid_mb52 INTO DATA(ls_varid_mb52).
          lv_cont = +1.
          ls_planlog_vari-cont = lv_cont.
          ls_planlog_vari-vari = ls_varid_mb52-variant.
          ls_planlog_vari-report = lc_mb52.
          APPEND ls_planlog_vari TO et_planlog_vari.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

  IF IV_vari IS NOT INITIAL.
    DELETE lt_planlog_vari WHERE vari <> IV_vari.
  ENDIF.

  LOOP AT lt_planlog_vari INTO DATA(ls_planlog_vari1).
    MOVE-CORRESPONDING ls_planlog_vari1 TO ls_planlog_vari.

    CASE ls_planlog_vari-opti.
      WHEN 'EQ'.
        ls_planlog_vari-optI_desc = 'Igual'.
      WHEN 'BT'.
        ls_planlog_vari-optI_desc = 'Entre'.
      WHEN 'NE'.
        ls_planlog_vari-optI_desc = 'Diferente de'.
    ENDCASE.

    CONDENSE ls_planlog_vari-cont NO-GAPS.
    APPEND ls_planlog_vari TO et_planlog_vari.
  ENDLOOP.

  IF IV_app = 'CARGA'.
    SORT et_planlog_vari BY vari.
    DELETE ADJACENT DUPLICATES FROM et_planlog_vari COMPARING vari.
  ENDIF.


  SORT et_planlog_vari BY report vari.

ENDFUNCTION.
