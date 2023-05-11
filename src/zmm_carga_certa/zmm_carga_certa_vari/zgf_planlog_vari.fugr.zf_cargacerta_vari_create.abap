FUNCTION zf_cargacerta_vari_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(RETURN) TYPE  BAPIRET2
*"  CHANGING
*"     VALUE(IS_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI OPTIONAL
*"     VALUE(I_BATCH) TYPE  STRING OPTIONAL
*"----------------------------------------------------------------------

  DATA: ls_planlogvari TYPE ztplanlog_vari,
        lt_planlogvari TYPE TABLE OF ztplanlog_vari,
        lv_cont        TYPE i,
        lv_field       TYPE zsplanlog_vari-field,
        lv_opti        TYPE zsplanlog_vari-opti,
        lv_low         TYPE zsplanlog_vari-low,
        lv_high        TYPE zsplanlog_vari-high,
        lv_split1      TYPE string,
        lv_split2      TYPE string.

  TRANSLATE is_planlog_vari-field TO UPPER CASE.
  TRANSLATE is_planlog_vari-vari TO UPPER CASE.

  MOVE-CORRESPONDING is_planlog_vari TO ls_planlogvari.

  IF i_batch IS INITIAL.
    SELECT SINGLE MAX( cont )
      FROM ztplanlog_vari
      INTO lv_cont
      WHERE report = is_planlog_vari-report
      AND vari = is_planlog_vari-vari.
    IF sy-subrc EQ 0.
      SELECT SINGLE *
        FROM ztplanlog_vari
        INTO ls_planlogvari
        WHERE report = is_planlog_vari-report
        AND vari = is_planlog_vari-vari
        AND low = is_planlog_vari-low
        AND high = is_planlog_vari-high
        AND opti = is_planlog_vari-opti.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_planlogvari TO is_planlog_vari.
        RETURN.
      ENDIF.
      ls_planlogvari-cont = lv_cont + 1.
      is_planlog_vari-cont = ls_planlogvari-cont.

    ELSE.
      ls_planlogvari-cont = '1'.
    ENDIF.
    IF ls_planlogvari-field IS INITIAL.
      return-type = 'E'.
      return-message = TEXT-e01.
      RETURN.
    ENDIF.
    MODIFY ztplanlog_vari FROM ls_planlogvari.
  ELSE.

    ls_planlogvari-report = is_planlog_vari-report.
    ls_planlogvari-vari = is_planlog_vari-vari.

    SELECT SINGLE MAX( cont )
     FROM ztplanlog_vari
     INTO lv_cont
     WHERE report = is_planlog_vari-report
     AND vari = is_planlog_vari-vari.
    DO.
      SPLIT i_batch AT ';' INTO lv_split1 lv_split2.
      SPLIT lv_split1 AT '/' INTO lv_field lv_opti lv_low lv_high.
*      IF sy-subrc EQ 0 AND lv_split1 IS NOT INITIAL.
      IF lv_split1 IS NOT INITIAL.
        lv_cont               = lv_cont + 1.
        ls_planlogvari-cont   = lv_cont.
        ls_planlogvari-opti   = lv_opti.
        CASE ls_planlogvari-opti.
          WHEN 'Ig'.
            ls_planlogvari-opti = 'EQ'.
          WHEN 'En'.
            ls_planlogvari-opti = 'BT'.
          WHEN 'Di'.
            ls_planlogvari-opti = 'NE'.
        ENDCASE.
        ls_planlogvari-low    = lv_low.
        ls_planlogvari-field  = lv_field.
        ls_planlogvari-high   = lv_high.
        APPEND ls_planlogvari TO lt_planlogvari.
        i_batch = lv_split2.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
    MOVE-CORRESPONDING ls_planlogvari TO is_planlog_vari.

    IF lt_planlogvari IS NOT INITIAL.
      MODIFY ztplanlog_vari FROM TABLE lt_planlogvari.
    ELSE.
      MODIFY ztplanlog_vari FROM ls_planlogvari.
    ENDIF.

  ENDIF.

ENDFUNCTION.
