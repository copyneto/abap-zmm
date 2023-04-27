FUNCTION zf_cargacerta_vari_update.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI OPTIONAL
*"     VALUE(I_BATCH) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------


  DATA: ls_planlogvari TYPE ztplanlog_vari,
        lt_planlogvari TYPE TABLE OF ztplanlog_vari,
        lv_cont        TYPE i,
        lv_cont_str    TYPE string,
        lv_batch       TYPE string,
        lv_field       TYPE zsplanlog_vari-field,
        lv_opti        TYPE zsplanlog_vari-opti,
        lv_low         TYPE zsplanlog_vari-low,
        lv_high        TYPE zsplanlog_vari-high,
        lv_report      TYPE zsplanlog_vari-report,
        lv_vari        TYPE zsplanlog_vari-vari,
        lv_split1      TYPE string,
        lv_split2      TYPE string.


  MOVE-CORRESPONDING is_planlog_vari TO ls_planlogvari.

  IF i_batch IS INITIAL.

    SELECT SINGLE *
  FROM ztplanlog_vari
  INTO ls_planlogvari
  WHERE report = is_planlog_vari-report
  AND vari = is_planlog_vari-vari.
    IF sy-subrc EQ 0.
      ls_planlogvari-field = is_planlog_vari-field.
      ls_planlogvari-low = is_planlog_vari-low.
      ls_planlogvari-high = is_planlog_vari-high.
    ELSE.
      return-type = 'E'.
      return-message = 'Registro não existe'.
    ENDIF.
    MODIFY ztplanlog_vari FROM ls_planlogvari.
  ELSE.
    DO.
      SPLIT i_batch AT ';' INTO lv_split1 lv_split2.
      IF lv_split1 IS NOT INITIAL.
        CLEAR: lv_report, lv_vari, lv_cont_str, lv_field, lv_opti, lv_low, lv_high.

        SPLIT lv_split1 AT '/' INTO lv_report lv_vari lv_cont_str lv_field lv_opti lv_low lv_high.
        IF lv_report IS NOT INITIAL AND lv_vari IS NOT INITIAL.
          lv_cont = lv_cont + 1.
          ls_planlogvari-cont = lv_cont_str.
          CASE lv_opti.
            WHEN 'Ig'.
              lv_opti = 'EQ'.
            WHEN 'En'.
              lv_opti = 'BT'.
            WHEN 'Di'.
              lv_opti = 'NE'.
          ENDCASE.
          ls_planlogvari-opti = lv_opti.
          ls_planlogvari-low = lv_low.
          ls_planlogvari-report = lv_report.
          ls_planlogvari-vari = lv_vari.
          ls_planlogvari-field = lv_field.
          ls_planlogvari-high = lv_high.
          APPEND ls_planlogvari TO lt_planlogvari.
        ENDIF.
         i_batch = lv_split2.
      ELSE.
        EXIT.
      ENDIF.

    ENDDO.
    MOVE-CORRESPONDING ls_planlogvari TO is_planlog_vari.
    MODIFY ztplanlog_vari FROM TABLE lt_planlogvari.


  ENDIF.
ENDFUNCTION.
