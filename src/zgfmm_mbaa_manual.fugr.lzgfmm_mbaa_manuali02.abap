*&---------------------------------------------------------------------*
*&  Include           LMBAA_MANUALI02
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CONSTANTS: lc_wemng_string_for_messages TYPE feldn VALUE 'EKPO-WEMNG', "#EC DECL_MODUL
             lc_remng_string_for_messages TYPE feldn VALUE 'EKPO-REMNG'. "#EC DECL_MODUL

  DATA: lv_difference TYPE menge_d,                     "#EC DECL_MODUL
        lv_msgtxt     TYPE string,          "#EC NEEDED "#EC DECL_MODUL
        lv_error      TYPE abap_bool,                   "#EC DECL_MODUL
        lv_text20     TYPE text20,                      "#EC DECL_MODUL
        lv_msg_text   TYPE symsgv,          "#EC NEEDED "#EC DECL_MODUL
        lv_rc_help    LIKE sy-subrc,                    "#EC DECL_MODUL
        lv_answer     TYPE c.                           "#EC DECL_MODUL


  CLEAR: gv_actual_distributed,
         gt_messages,
         lv_difference,
         lv_text20,
         lv_error,
         lv_rc_help.

* calculate actual distributed quantity on material document item level
* --> check, if IR-quantity is reduced completely
* --> check, if not more is returned than delivered
  LOOP AT gt_accounting_lines INTO gs_accounting_line.
*   no negativ quantities are allowed
    IF gs_accounting_line-quantity LT 0.
      MESSAGE e334(c1) INTO lv_msgtxt.
      gs_message-id   = sy-msgid.
      gs_message-type = sy-msgty.
      gs_message-number = sy-msgno.
      gs_message-message_v1 = sy-msgv1.
      gs_message-message_v2 = sy-msgv2.
      gs_message-message_v3 = sy-msgv3.
      gs_message-message_v4 = sy-msgv4.

      APPEND gs_message TO gt_messages.
      CLEAR: gs_message, lv_msg_text.
    ENDIF.

    gv_actual_distributed = gv_actual_distributed + gs_accounting_line-quantity.

    IF gv_shkzg EQ 'S'.
*   check if invoiced quantity is reduced completely
      lv_difference = ( gs_accounting_line-received_quantity + gs_accounting_line-quantity ) - gs_accounting_line-invoiced_quantity.
      IF lv_difference LT 0.

*       Read message text for field
        SELECT SINGLE text20 FROM t157t
                             INTO lv_text20
                               WHERE spras = sy-langu
                                 AND feldn = lc_remng_string_for_messages.

        CALL FUNCTION 'MB_EDIT_MESSAGE'
          EXPORTING
            t1      = ':'
            t2      = gs_accounting_line-zekkn
            t3      = gv_matnr
            t4      = gv_matnr_short_descr
            nouline = abap_true
          IMPORTING
            message = lv_msg_text.

        MESSAGE e021(m7) WITH lv_text20 lv_difference gv_mseg_erfme lv_msg_text INTO lv_msgtxt. "Deficit of & & & &
        gs_message-id   = sy-msgid.
        gs_message-type = sy-msgty.
        gs_message-number = sy-msgno.
        gs_message-message_v1 = sy-msgv1.
        gs_message-message_v2 = sy-msgv2.
        gs_message-message_v3 = sy-msgv3.
        gs_message-message_v4 = sy-msgv4.

        APPEND gs_message TO gt_messages.
        CLEAR: gs_message, lv_msg_text.

        lv_error = abap_true.
      ENDIF.
    ELSE. "gv_shkzg = H
*   check that not more can be returned than has been received
      IF gs_accounting_line-quantity GT gs_accounting_line-received_quantity.

*       Read message text for field
        SELECT SINGLE text20 FROM t157t
                             INTO lv_text20
                               WHERE spras = sy-langu
                                 AND feldn = lc_wemng_string_for_messages.

        CALL FUNCTION 'MB_EDIT_MESSAGE'
          EXPORTING
            t1      = ':'
            t2      = gs_accounting_line-zekkn
            t3      = gv_matnr
            t4      = gv_matnr_short_descr
            nouline = abap_true
          IMPORTING
            message = lv_msg_text.

        lv_difference = gs_accounting_line-received_quantity - gs_accounting_line-quantity.
        lv_difference = abs( lv_difference ).

        MESSAGE e021(m7) WITH lv_text20 lv_difference gv_mseg_erfme lv_msg_text INTO lv_msgtxt. "Deficit of & & & &
        gs_message-id   = sy-msgid.
        gs_message-type = sy-msgty.
        gs_message-number = sy-msgno.
        gs_message-message_v1 = sy-msgv1.
        gs_message-message_v2 = sy-msgv2.
        gs_message-message_v3 = sy-msgv3.
        gs_message-message_v4 = sy-msgv4.

        APPEND gs_message TO gt_messages.
        CLEAR: gs_message, lv_msg_text, lv_difference.

        lv_error = abap_true.
      ENDIF.

*     check that on accounting line level not more than GR-surplus is returned
      IF gs_accounting_line-invoiced_quantity IS NOT INITIAL.
        lv_difference = ( gs_accounting_line-received_quantity - gs_accounting_line-invoiced_quantity )
                          - gs_accounting_line-quantity.

        IF lv_difference LT 0. "The GR-surplus is exceeded by the posting quantity
*       Read message text for field
          SELECT SINGLE text20 FROM t157t
                               INTO lv_text20
                                 WHERE spras = sy-langu
                                   AND feldn = lc_remng_string_for_messages.

          CALL FUNCTION 'MB_EDIT_MESSAGE'
            EXPORTING
              t1      = ':'
              t2      = gs_accounting_line-zekkn
              t3      = gv_matnr
              t4      = gv_matnr_short_descr
              nouline = abap_true
            IMPORTING
              message = lv_msg_text.

          lv_difference = abs( lv_difference ).

          MESSAGE e021(m7) WITH lv_text20 lv_difference gv_mseg_erfme lv_msg_text INTO lv_msgtxt. "Deficit of & & & &
          gs_message-id   = sy-msgid.
          gs_message-type = sy-msgty.
          gs_message-number = sy-msgno.
          gs_message-message_v1 = sy-msgv1.
          gs_message-message_v2 = sy-msgv2.
          gs_message-message_v3 = sy-msgv3.
          gs_message-message_v4 = sy-msgv4.

          APPEND gs_message TO gt_messages.
          CLEAR: gs_message, lv_msg_text, lv_difference.

          lv_error = abap_true.
        ENDIF.
      ENDIF.

*     check if a return is against a final flagged AA-line and send message if necessary
      IF gs_accounting_line-final_indicator EQ abap_true
       AND gs_accounting_line-quantity IS NOT INITIAL.

        CALL FUNCTION 'MB_CHECK_T160M'
          EXPORTING
            i_msgnr = '445'
          IMPORTING
            rc      = lv_rc_help.

*       possible values for lv_rc_help and their meaning:
*       nothing = 0 warning = 1 error = 2  success = 3 popup = 4  information = 5.
        IF lv_rc_help EQ 1.
          MESSAGE w445(m7) WITH gs_accounting_line-zekkn gs_accounting_line-ebeln gs_accounting_line-ebelp INTO lv_msgtxt.
        ELSEIF lv_rc_help EQ 2.
          MESSAGE e445(m7) WITH gs_accounting_line-zekkn gs_accounting_line-ebeln gs_accounting_line-ebelp INTO lv_msgtxt.

          lv_error = abap_true.
        ELSE.
          CLEAR lv_msgtxt.
        ENDIF.

        IF lv_msgtxt IS NOT INITIAL.
          gs_message-id   = sy-msgid.
          gs_message-type = sy-msgty.
          gs_message-number = sy-msgno.
          gs_message-message_v1 = sy-msgv1.
          gs_message-message_v2 = sy-msgv2.
          gs_message-message_v3 = sy-msgv3.
          gs_message-message_v4 = sy-msgv4.

          APPEND gs_message TO gt_messages.
          CLEAR: gs_message, lv_msg_text.
        ENDIF.

      ENDIF.
    ENDIF.
    CLEAR lv_difference.
  ENDLOOP.

* Check, if exacatly the same quantity has been distributed as has been entered for posting
  IF gv_actual_distributed NE gv_mseg_erfmg.
    lv_difference = gv_actual_distributed - gv_mseg_erfmg.

    CALL FUNCTION 'MB_EDIT_MESSAGE'
      EXPORTING
        t1      = ':'
        t2      = gv_matnr
        t3      = gv_matnr_short_descr
        nouline = abap_true
      IMPORTING
        message = lv_msg_text.

    IF lv_difference LT 0.
      MESSAGE e021(m7) WITH text-001 lv_difference gv_mseg_erfme lv_msg_text INTO lv_msgtxt. "Deficit of & & & &
    ELSE.
      MESSAGE e022(m7) WITH text-001 lv_difference gv_mseg_erfme lv_msg_text INTO lv_msgtxt. "& exceeded by & & &
    ENDIF.

    gs_message-id   = sy-msgid.
    gs_message-type = sy-msgty.
    gs_message-number = sy-msgno.
    gs_message-message_v1 = sy-msgv1.
    gs_message-message_v2 = sy-msgv2.
    gs_message-message_v3 = sy-msgv3.
    gs_message-message_v4 = sy-msgv4.

    APPEND gs_message TO gt_messages.
    CLEAR: gs_message, lv_msg_text.

    lv_error = abap_true.
  ENDIF.

  CASE sy-ucomm.
    WHEN 'OK'.
*     Only in case no error has occurred the processing may continue
      IF lv_error EQ abap_false.
        CLEAR gt_messages.
        LEAVE SCREEN.
      ELSE.
        CALL SCREEN 0100.
      ENDIF.
    WHEN 'RESET'.
*     Brings back original system distribution
      gt_accounting_lines = gt_accounting_lines_back.       "#EC ENHOK
      gv_actual_distributed = gv_mseg_erfmg.
      CLEAR gt_messages.
      CALL SCREEN 0100.
    WHEN 'CHECK'.
      IF lv_error EQ abap_false.
        MESSAGE i444(m7) WITH gv_mseg_zeile INTO lv_msgtxt. "Distribution ok
        gs_message-id   = sy-msgid.
        gs_message-type = sy-msgty.
        gs_message-number = sy-msgno.
        gs_message-message_v1 = sy-msgv1.
        gs_message-message_v2 = sy-msgv2.
        gs_message-message_v3 = sy-msgv3.
        gs_message-message_v4 = sy-msgv4.

        APPEND gs_message TO gt_messages.
        CLEAR: gs_message, lv_msg_text.
      ENDIF.
      CALL SCREEN 0100.
    WHEN 'BACK'.
      CLEAR lv_answer.

*     check, if posting shall really be aborted
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question         = text-004
          text_button_1         = text-002
          text_button_2         = text-003
          default_button        = '2'
          display_cancel_button = abap_false
        IMPORTING
          answer                = lv_answer
        EXCEPTIONS
          OTHERS                = 0.

      IF lv_answer = '1'
       OR lv_answer = 'A' .
*     Brings back original system distribution and contiunes processing
        gt_accounting_lines = gt_accounting_lines_back.
        LEAVE TO CURRENT TRANSACTION.
      ELSE.
        CALL SCREEN 0100.
      ENDIF.

    WHEN OTHERS.
      CLEAR gt_messages.
      CALL SCREEN 0100.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_0100  INPUT
