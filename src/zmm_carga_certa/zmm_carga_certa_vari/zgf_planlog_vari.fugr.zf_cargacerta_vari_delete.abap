FUNCTION zf_cargacerta_vari_delete.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI OPTIONAL
*"  EXPORTING
*"     VALUE(ES_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI
*"  CHANGING
*"     VALUE(I_BATCH) TYPE  STRING OPTIONAL
*"----------------------------------------------------------------------


  DATA: ls_planlogvari TYPE ztplanlog_vari,
        lt_planlogvari TYPE TABLE OF ztplanlog_vari,
        lv_cont        TYPE i,
        lv_field       TYPE ZSPLANLOG_vARI-field,
        lv_opti        TYPE zsplanlog_vari-opti,
        lv_low         TYPE zsplanlog_vari-low,
        lv_high        TYPE ZSPLANLOG_vARI-high,
        lv_split1      TYPE string,
        lv_split2      TYPE string.

  DELETE FROM ztplanlog_vari WHERE report = is_planlog_vari-report
                             AND vari =  is_planlog_vari-vari
                             AND field =  is_planlog_vari-field
                             AND  opti = is_planlog_vari-opti
                             AND cont =  is_planlog_vari-cont
                             AND low = is_planlog_vari-low
                             AND high = is_Planlog_vari-high.
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING is_planlog_Vari TO  es_planlog_vari.
    SELECT *
      FROM ztplanlog_vari
      INTO TABLE lt_planlogvari
      WHERE report = is_planlog_Vari-report
      AND vari = is_planlog_Vari-vari.
    IF sy-subrc EQ 0.
      LOOP AT lt_planlogvari ASSIGNING FIELD-SYMBOL(<fs_planlog_vari>).
        lv_cont = lv_cont + 1.
        <fs_planlog_vari>-cont = lv_cont.
      ENDLOOP.
      MODIFY ztplanlog_vari FROM TABLE lt_planlogvari.
    ENDIF.
  ENDIF.

ENDFUNCTION.
