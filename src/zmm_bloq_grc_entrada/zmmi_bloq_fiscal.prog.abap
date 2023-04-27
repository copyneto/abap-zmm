*&---------------------------------------------------------------------*
*& Include          ZMMI_BLOQ_FISCAL
*&---------------------------------------------------------------------*

  DATA: lv_ok TYPE boolean.

  "Validar componente de aplicação
  IF ms_current_query-applid = '/XNFE/POWL_LOGISTICS_WORKPLACE'.

    lv_ok = abap_true.

    SELECT COUNT(*)
      FROM ztmm_data_bloq
      WHERE data_inicio <= sy-datum
      AND data_fim >= sy-datum.

    IF sy-subrc = 0.

      SELECT COUNT(*)
        FROM ztmm_user_libgrc
        WHERE usuario = sy-uname.

      IF sy-subrc <> 0.

        APPEND INITIAL LINE TO ms_current_results-messages ASSIGNING FIELD-SYMBOL(<fs_msg>).
        <fs_msg>-msgid = 'ZMM_GRC'.
        <fs_msg>-msgnumber = '000'.
        <fs_msg>-msgtype = 'E'.
        <fs_msg>-message_v1 = 'Bloq. monitor logístico ativado pela área fiscal' ##NO_TEXT.

        lv_ok = abap_false.

      ENDIF.

    ENDIF.

    CHECK lv_ok = abap_true.

  ENDIF.
