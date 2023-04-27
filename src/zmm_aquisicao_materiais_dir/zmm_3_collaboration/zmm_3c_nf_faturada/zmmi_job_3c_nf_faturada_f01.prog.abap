*&---------------------------------------------------------------------*
*& Include          ZMMI_JOB_3C_NF_FATURADA_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_search_file_f4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_LOCL
*&      --> P_SERV
*&      <-- P_FILE
*&---------------------------------------------------------------------*
FORM f_search_file_f4  USING    uv_locl
                                uv_serv
                       CHANGING cv_file.

  DATA: lv_file TYPE string.

  lv_file = cv_file.
  IF uv_locl IS NOT INITIAL .

    CALL METHOD cl_gui_frontend_services=>directory_browse
      EXPORTING
        initial_folder       = 'C:'
      CHANGING
        selected_folder      = lv_file
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
        OTHERS               = 4.

    IF sy-subrc NE 0.
      gt_return[] = VALUE #( BASE gt_return ( type       = sy-msgty
                                              id         = sy-msgid
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message_v3 = sy-msgv3
                                              message_v4 = sy-msgv4 ) ).
      RETURN.

    ELSEIF lv_file IS INITIAL.
      " Operação cancelada.
      gt_return[] = VALUE #( BASE gt_return ( type       = gc_msg-type_e
                                              id         = gc_msg-id
                                              number     = '005' ) ).

      RETURN.

    ELSE.
      cv_file = lv_file && '\'.

    ENDIF.

* ----------------------------------------------------------------------
* Recupera o nome do arquivo no servidor
* ----------------------------------------------------------------------
  ELSEIF uv_serv IS NOT INITIAL.

    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
      IMPORTING
        serverfile       = lv_file
      EXCEPTIONS
        canceled_by_user = 1
        OTHERS           = 2.

    IF sy-subrc NE 0.
      gt_return[] = VALUE #( BASE gt_return ( type       = sy-msgty
                                              id         = sy-msgid
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message_v3 = sy-msgv3
                                              message_v4 = sy-msgv4 ) ).
      RETURN.

    ELSEIF lv_file IS INITIAL.
      " Operação cancelada.
      gt_return[] = VALUE #( BASE gt_return ( type       = gc_msg-type_e
                                              id         = gc_msg-id
                                              number     = '005' ) ).
      RETURN.

    ELSE.
      cv_file = lv_file && '/'.

    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_manage_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_manage_screen .

  IF p_serv IS NOT INITIAL.

    SELECT SINGLE *
        FROM zi_mm_3c_vh_pasta_servidor
        INTO @DATA(lv_path_default).

    IF sy-subrc IS INITIAL.
      p_file = lv_path_default-serverfolder.
    ENDIF.
  ELSEIF p_locl IS NOT INITIAL.
    CLEAR p_file.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_search_file_f4_tipo
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_FILE
*&---------------------------------------------------------------------*
FORM f_search_file_f4_tipo.

  SELECT doctype, doctypetext
    FROM zi_mm_3c_vh_doc_type
    WHERE doctype IS NOT INITIAL
    INTO TABLE @gt_tipo.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'DOCTYPETEXT'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'P_TIPO'
      value_org       = 'S'
    TABLES
      value_tab       = gt_tipo
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_start
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_start .

  PERFORM f_validation.

  PERFORM f_call_job.

  PERFORM f_display_log.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_call_job
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_call_job.

  DATA: lr_data   TYPE RANGE OF logbr_docdat,
        lr_cnpj_e TYPE RANGE OF logbr_nfpartnercnpj,
        lr_cnpj_d TYPE RANGE OF logbr_cnpj_bupla.

  IF s_data[] IS NOT INITIAL.
    lr_data = VALUE #( FOR ls_data IN s_data ( sign   = ls_data-sign
                                               option = ls_data-option
                                               low    = ls_data-low
                                               high   = ls_data-high ) ).
  ENDIF.

  IF s_cnpj_e[] IS NOT INITIAL.
    lr_cnpj_e = VALUE #( FOR ls_cnpj_e IN s_cnpj_e ( sign   = ls_cnpj_e-sign
                                                     option = ls_cnpj_e-option
                                                     low    = ls_cnpj_e-low
                                                     high   = ls_cnpj_e-high ) ).
  ENDIF.

  IF s_cnpj_d[] IS NOT INITIAL.
    lr_cnpj_d = VALUE #( FOR ls_cnpj_d IN s_cnpj_d ( sign   = ls_cnpj_d-sign
                                                     option = ls_cnpj_d-option
                                                     low    = ls_cnpj_d-low
                                                     high   = ls_cnpj_d-high ) ).
  ENDIF.

  gt_return = NEW zclmm_3c_nf_faturada_events( )->execute_job( EXPORTING iv_tipo   = p_tipo " VALUE #( gt_tipo[ doctypetext = p_tipo ]-doctype OPTIONAL )
                                                                         ir_data   = lr_data
                                                                         ir_cnpj_e = lr_cnpj_e
                                                                         ir_cnpj_d = lr_cnpj_d
                                                                         iv_nfe    = p_nfe
                                                                         iv_chave  = p_chave
                                                                         iv_path   = p_file
                                                                         iv_dest   = COND #( WHEN p_locl IS NOT INITIAL THEN 'L' ELSE 'S' ) ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_log
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_log .

  DATA: lt_message TYPE esp1_message_tab_type.

  CHECK gt_return[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Prepara as mensagens
* ----------------------------------------------------------------------

  LOOP AT gt_return REFERENCE INTO DATA(ls_return).

    lt_message = VALUE #( BASE lt_message ( msgid  = ls_return->id
                                            msgty  = ls_return->type
                                            msgno  = ls_return->number
                                            msgv1  = ls_return->message_v1
                                            msgv2  = ls_return->message_v2
                                            msgv3  = ls_return->message_v3
                                            msgv4  = ls_return->message_v4
                                            lineno = sy-tabix ) ).
  ENDLOOP.

* ----------------------------------------------------------------------
* Exibe apenas uma mensagem
* ----------------------------------------------------------------------
  IF lines( lt_message[] ) = 1.

    READ TABLE lt_message INTO DATA(ls_message) INDEX 1.

    MESSAGE ID ls_message-msgid
    TYPE 'S'
    NUMBER ls_message-msgno
    DISPLAY
    LIKE ls_message-msgty
    WITH ls_message-msgv1
    ls_message-msgv2
    ls_message-msgv3
    ls_message-msgv4.

* ----------------------------------------------------------------------
* Exibe múltiplas mensagens como pop-up
* ----------------------------------------------------------------------
  ELSE.

    CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
      TABLES
        i_message_tab = lt_message[].

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_init .
  SELECT doctype, doctypetext
    FROM zi_mm_3c_vh_doc_type
    WHERE doctype IS NOT INITIAL
    INTO TABLE @gt_tipo.

  IF sy-subrc IS INITIAL.
    LOOP AT gt_tipo ASSIGNING FIELD-SYMBOL(<fs_tipo>).
      TRANSLATE <fs_tipo>-doctypetext TO UPPER CASE.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_validation
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_validation .

  IF p_tipo IS INITIAL OR p_file IS INITIAL.
    MESSAGE TEXT-001 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
