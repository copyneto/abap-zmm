***********************************************************************
*** © 3corações ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Programa de Interface para integração de req           *
*** AUTOR : Emilio – Meta                                             *
*** FUNCIONAL: Rodrigo - Meta                                         *
*** DATA : 10.02.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** | | *
***********************************************************************
REPORT zmmr_envioreq_me.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.

    METHODS: on_link_click   FOR EVENT link_click OF
      cl_salv_events_table
      IMPORTING row column.

ENDCLASS.

TYPES: BEGIN OF ty_cdpos,
         doc_sap  TYPE cdobjectv,
         doc_item TYPE ze_doc_item,
         tabkey   TYPE cdtabkey,
       END OF ty_cdpos,
       BEGIN OF ty_req,
         banfn TYPE banfn,
         bnfpo TYPE bnfpo,
       END OF ty_req,
       BEGIN OF ty_ret,
         type    TYPE c,
         message TYPE string,
         banfn   TYPE banfn,
         bnfpo   TYPE bnfpo,
       END OF ty_ret.

TYPES: ty_cdpo TYPE STANDARD TABLE OF ty_cdpos WITH DEFAULT KEY,
       ty_retn TYPE STANDARD TABLE OF ty_ret WITH DEFAULT KEY.

CONSTANTS: gc_2     TYPE banpr VALUE '02',
           gc_5     TYPE banpr VALUE '05',
           gc_zmm   TYPE c LENGTH 3 VALUE 'ZMM',
           gc_banpr TYPE fieldname VALUE 'BANPR',
           gc_banf  TYPE cdobjectcl VALUE 'BANF',
           gc_e     TYPE c VALUE 'E'.


DATA: gt_req           TYPE TABLE OF ty_req,
      gt_return        TYPE ty_retn,
      gt_msg           TYPE bapiret2_tab,
      gv_dummy         TYPE string,
      go_table         TYPE REF TO cl_salv_table,
      go_event_handler TYPE REF TO lcl_handle_events.

CLASS lcl_handle_events IMPLEMENTATION.

  METHOD on_link_click.

    READ TABLE gt_return INTO DATA(ls_ret) INDEX row.

    CHECK sy-subrc = 0.

    CASE column.
      WHEN 'BANFN'.

        SET PARAMETER ID 'BAN'  FIELD ls_ret-banfn.
        CALL TRANSACTION 'ME52N' AND SKIP FIRST SCREEN.

    ENDCASE.


  ENDMETHOD.
ENDCLASS.

SELECTION-SCREEN BEGIN OF BLOCK txt1 WITH FRAME.
  SELECT-OPTIONS:  s_dat FOR sy-datum DEFAULT sy-datum.
SELECTION-SCREEN END OF BLOCK txt1.

START-OF-SELECTION.

  PERFORM f_validate.

  IF gt_msg IS INITIAL.
    PERFORM f_call_me.
  ENDIF.

END-OF-SELECTION.

  PERFORM f_return_screen.

FORM f_validate.

  DATA: lt_envio_req TYPE TABLE OF ty_cdpos.

  SELECT doc_sap, doc_item  FROM ztmm_envio_req
    WHERE data_c IN @s_dat
      AND data_i IS INITIAL
  INTO TABLE @lt_envio_req.

  IF sy-subrc EQ 0.

    lt_envio_req = VALUE ty_cdpo( FOR ls_req IN lt_envio_req (
                                    doc_item = ls_req-doc_item
                                    doc_sap  = ls_req-doc_sap
                                    tabkey   = sy-mandt && ls_req-doc_sap &&  ls_req-doc_item
                                   ) ).

    SELECT objectid,
           tabkey
    FROM cdpos AS a
    INNER JOIN eban AS b
    ON  a~objectid = b~banfn
    AND b~banpr    = '05'
    FOR ALL ENTRIES IN @lt_envio_req
    WHERE  objectid   = @lt_envio_req-doc_sap
      AND fname       = @gc_banpr
      AND tabkey      = @lt_envio_req-tabkey
      AND objectclas  = @gc_banf
      AND ( value_new = @gc_2
       OR   value_new = @gc_5 )
    INTO TABLE @DATA(lt_cdpos).

    IF sy-subrc EQ 0.

      LOOP AT lt_cdpos ASSIGNING FIELD-SYMBOL(<fs_cdpos>).

        DATA(lv_lines) = strlen( <fs_cdpos>-tabkey ) - 5.

        gt_req = VALUE #( BASE gt_req (
            banfn = <fs_cdpos>-objectid
            bnfpo = <fs_cdpos>-tabkey+lv_lines(5)
        ) ).

      ENDLOOP.

    ELSE.
      PERFORM f_erro.
    ENDIF.

  ELSE.
    PERFORM f_erro.
  ENDIF.

ENDFORM.

FORM f_call_me.

  PERFORM f_progress USING 30.

  TRY.

      NEW zclmm_send_req(  )->get_data(
          EXPORTING it_req = gt_req
          IMPORTING et_msg = gt_msg ).

    CATCH cx_ai_system_fault.
  ENDTRY.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form write_msg
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_write_msg .

  LOOP AT gt_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).

    MESSAGE ID <fs_msg>-id
            TYPE <fs_msg>-type
            NUMBER <fs_msg>-number
            INTO gv_dummy
            WITH <fs_msg>-message_v1
                 <fs_msg>-message_v2
                 <fs_msg>-message_v3
                 <fs_msg>-message_v4.

    WRITE: / gv_dummy.

  ENDLOOP.

  "Colocar erro na execução do JOB
  IF line_exists( gt_msg[ type = 'E' ] )
    AND sy-batch = abap_true.
    MESSAGE e000(zmm) WITH TEXT-e01.
  ENDIF.


ENDFORM.

FORM f_erro.

  "Não possuem requisições para integração
  gt_msg = VALUE #( ( id      = gc_zmm
                      type    = gc_e
                      number  = 000
                      message_v1 = TEXT-e02 ) ).

ENDFORM.
FORM f_return_screen.

  PERFORM f_progress USING 90.

  TRY.

      IF gt_msg IS NOT INITIAL.

        gt_return  = VALUE ty_retn( FOR ls_ret IN gt_msg (
                                         type    = ls_ret-type
                                         message = COND #( WHEN ls_ret-message IS INITIAL THEN ls_ret-message_v1 ELSE ls_ret-message )
                                         banfn   = ls_ret-message_v2
                                         bnfpo   = ls_ret-message_v3
                                       ) ).

        cl_salv_table=>factory(
          IMPORTING
              r_salv_table = go_table
          CHANGING
              t_table = gt_return  ).

* Let's show all default buttons of ALV
        PERFORM f_function CHANGING go_table .

* Apply zebra style to lv_rows
        PERFORM f_settings CHANGING go_table .

* Enable cell selection mode
        PERFORM f_selections CHANGING go_table .

* Change columns
        PERFORM f_columns CHANGING go_table .

* Display table
        go_table->display( ).

*        CLEAR: gt_return[].

      ELSE.

        PERFORM f_write_msg.

      ENDIF.

    CATCH cx_salv_msg.
  ENDTRY.

ENDFORM.

FORM f_columns CHANGING cv_table TYPE REF TO cl_salv_table.

  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
        lr_column  TYPE REF TO cl_salv_column_table.
*        lr_events  TYPE REF TO cl_salv_events_table.

  lr_columns = cv_table->get_columns( ).

  TRY.

      lr_columns->set_optimize( abap_true ).

      lr_column ?= lr_columns->get_column( 'TYPE' ).
      lr_column->set_short_text( 'Tipo' ).
      lr_column->set_medium_text( 'Tipo' ).
      lr_column->set_long_text( 'Tipo' ).

      lr_column ?= lr_columns->get_column( 'MESSAGE' ).
      lr_column->set_short_text( 'Descrição' ).
      lr_column->set_medium_text( 'Descrição' ).
      lr_column->set_long_text( 'Descrição' ).

      lr_column ?= lr_columns->get_column( 'BANFN' ).
      lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
      lr_column->set_short_text( 'Documento' ).
      lr_column->set_medium_text( 'Documento' ).
      lr_column->set_long_text( 'Documento' ).


      lr_column ?= lr_columns->get_column( 'BNFPO' ).
      lr_column->set_short_text( 'Item' ).
      lr_column->set_medium_text( 'Item' ).
      lr_column->set_long_text( 'Item' ).


    CATCH cx_salv_not_found INTO DATA(lv_not_found).
  ENDTRY.

  DATA(lr_events) = cv_table->get_event( ).
  CREATE OBJECT go_event_handler.
  SET HANDLER go_event_handler->on_link_click FOR lr_events.

ENDFORM.

FORM f_function CHANGING cv_table TYPE REF TO cl_salv_table.

  DATA(lo_gr_functions) = cv_table->get_functions( ).
  lo_gr_functions->set_all( abap_true ).

ENDFORM.

FORM f_settings CHANGING cv_table TYPE REF TO cl_salv_table.

  DATA(lo_display) = cv_table->get_display_settings( ).
  lo_display->set_striped_pattern( cl_salv_display_settings=>true ).

ENDFORM.

FORM f_selections CHANGING cv_table  TYPE REF TO cl_salv_table.

  DATA(lo_selections) = cv_table->get_selections( ).
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).

ENDFORM.

FORM f_progress USING uv_percent TYPE i.

  CONSTANTS: lc_message TYPE string VALUE 'Integrando requisições...'.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = uv_percent
      text       = lc_message
    EXCEPTIONS
      OTHERS     = 1.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

ENDFORM.
