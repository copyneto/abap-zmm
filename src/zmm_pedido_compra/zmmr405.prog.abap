************************************************************************
****                     3CORAÇÕES                                     *
****                                                                   *
**** PROGRAMA: ZMMR405                                                 *
****                                                                   *
**** DESCRIÇÃO: - Modificação Massiva Preço Unitário Pedido de Compra  *
****                                                                   *
**** AUTOR:        Jocelio Pereira                                     *
**** DATA:         01.11.2021                                          *
************************************************************************
**** HISTÓRICO DAS MODIFICAÇÕES                                        *
****-------------------------------------------------------------------*
**** DATA | AUTOR | DESCRIÇÃO                                          *
****-------------------------------------------------------------------*
****      |       |                                                    *
************************************************************************
REPORT zmmr405.

*----------------------------------------------------------------------*
*** Tipos
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_dados,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         peinh TYPE char5,
         netpr TYPE char17,
       END OF ty_dados,

       BEGIN OF ty_alv,
         ebeln   TYPE ebeln,
         type    TYPE bapi_mtype,
         id      TYPE symsgid,
         number  TYPE symsgno,
         message TYPE bapi_msg,
       END OF ty_alv,
       tt_alv TYPE STANDARD TABLE OF ty_alv WITH EMPTY KEY.

*----------------------------------------------------------------------*
*** Tabelas Internas
*----------------------------------------------------------------------*
DATA: it_dados     TYPE TABLE OF  ty_dados,
      ti_alv       TYPE tt_alv,
      it_filetable TYPE filetable.

*----------------------------------------------------------------------*
*** Estruturas
*----------------------------------------------------------------------*
DATA: gs_dados_line LIKE LINE OF it_dados,
      gs_input_rec  TYPE char100.

*----------------------------------------------------------------------*
*** Variáveis
*----------------------------------------------------------------------*
DATA: gv_file  TYPE rlgrap-filename,
      gv_title TYPE string,
      gv_rc    TYPE i.

*----------------------------------------------------------------------*
*** Constantes
*----------------------------------------------------------------------*
CONSTANTS: c_split TYPE c VALUE cl_abap_char_utilities=>horizontal_tab,
           x       VALUE 'X'.

*----------------------------------------------------------------------*
*** Parâmetros
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS p_file TYPE string OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*&---------------------------------------------------------------------*
*&      EVENTOS
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  gv_title = text-002.
  CLEAR it_filetable[].
*** Caixa de diálogo para abertura de arquivo
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = gv_title
      initial_directory       = 'C:'
    CHANGING
      file_table              = it_filetable
      rc                      = gv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  READ TABLE it_filetable INTO p_file INDEX 1.

*----------------------------------------------------------------------*
*** START OF SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  IF sy-batch IS INITIAL.
    PERFORM ler_planilha_foreground.
  ELSE.
    PERFORM ler_planilha_background.
  ENDIF.
  IF it_dados[] IS NOT INITIAL.
    PERFORM altera_preco_pedido.
    PERFORM mostra_alv.
  ENDIF.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*       ler arquivo em foreground
*----------------------------------------------------------------------*
FORM ler_planilha_foreground.

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = p_file
      filetype                = 'ASC'
      has_field_separator     = 'X'
    CHANGING
      data_tab                = it_dados
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
  DELETE it_dados INDEX 1.

  " Modificar valor para formanto SAP
  LOOP AT it_dados INTO DATA(ls_dados).
    REPLACE ALL OCCURENCES OF ',' IN ls_dados-netpr  WITH '.'.
    MODIFY it_dados FROM ls_dados.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*       Ler arquivo em background
*----------------------------------------------------------------------*
FORM ler_planilha_background .

  gv_file = p_file.
  DATA lv_mess TYPE string.

  OPEN DATASET gv_file FOR INPUT IN TEXT MODE MESSAGE lv_mess ENCODING UTF-8.
  IF sy-subrc = 0.
    DO.
      READ DATASET gv_file INTO gs_input_rec.
      IF sy-subrc <> 0.
        EXIT.
      ELSE.
        PERFORM split_records.
        APPEND gs_dados_line TO it_dados.
        CLEAR: gs_input_rec, gs_dados_line.
      ENDIF.
    ENDDO.
    CLOSE DATASET gv_file.
  ELSE.
    IF sy-subrc = 8.
      MESSAGE lv_mess TYPE 'I'.
    ENDIF.
  ENDIF.

  " Apagar linha de cabeçalho
  DELETE it_dados INDEX 1.

  " Modificar valor para formanto SAP
  LOOP AT it_dados INTO DATA(ls_dados).
    REPLACE ALL OCCURENCES OF ',' IN ls_dados-netpr  WITH '.'.
    MODIFY it_dados FROM ls_dados.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*       Separar dados por colunas
*----------------------------------------------------------------------*
FORM split_records .

  CLEAR gs_dados_line.

  SPLIT gs_input_rec AT c_split INTO
  gs_dados_line-ebeln
  gs_dados_line-ebelp
  gs_dados_line-peinh
  gs_dados_line-netpr
  IN CHARACTER MODE.

ENDFORM.

*&---------------------------------------------------------------------*
*       Chama BAPI para alterar preço no Pedido
*----------------------------------------------------------------------*
FORM altera_preco_pedido.

  DATA lv_purchaseorder TYPE bapimepoheader-po_number.
  DATA: lt_poitem  TYPE STANDARD TABLE OF bapimepoitem,
        ls_poitem  TYPE bapimepoitem,
        lt_poitemx TYPE STANDARD TABLE OF bapimepoitemx,
        ls_poitemx TYPE bapimepoitemx,
        lt_pocond  TYPE STANDARD TABLE OF bapimepocond,
        ls_pocond  TYPE bapimepocond,
        lt_pocondx TYPE STANDARD TABLE OF bapimepocondx,
        ls_pocondx TYPE bapimepocondx,
        lt_return  TYPE STANDARD TABLE OF bapiret2.

  SORT it_dados BY ebeln.

  LOOP AT it_dados INTO DATA(ls_dados).

*    ls_poitem-po_item     = ls_dados-ebelp.
*    ls_poitem-price_unit  = ls_dados-peinh.
*    ls_poitem-net_price   = ls_dados-netpr.
*    APPEND ls_poitem TO lt_poitem.
*
*    ls_poitemx-po_item    = ls_dados-ebelp.
*    ls_poitemx-po_itemx   = x.
*    ls_poitemx-net_price  = x.
*    ls_poitemx-price_unit = x.
*    APPEND ls_poitemx TO lt_poitemx.

    " Moeda
    SELECT SINGLE waers, knumv FROM ekko
      INTO (@DATA(lv_waers), @DATA(lv_knumv))
      WHERE ebeln = @ls_dados-ebeln.
    IF sy-subrc EQ 0.
      SELECT SINGLE kschl FROM v_konv
        INTO @ls_pocond-cond_type
        WHERE knumv = @lv_knumv
          AND kposn = @ls_dados-ebelp
          AND stunr = 1.
    ENDIF.

    ls_pocond-itm_number  = ls_dados-ebelp.
    "ls_pocond-cond_type   = |PBXX|.
    ls_pocond-cond_p_unt  = ls_dados-peinh.
    ls_pocond-cond_value  = ls_dados-netpr.
    ls_pocond-currency    = lv_waers.
    ls_pocond-change_id   = |U|.
    APPEND ls_pocond TO lt_pocond.

    ls_pocondx-itm_number = ls_dados-ebelp.
    ls_pocondx-cond_type  = x.
    ls_pocondx-cond_p_unt = x.
    ls_pocondx-cond_value = x.
    ls_pocondx-currency   = x.
    ls_pocondx-change_id  = x.
    APPEND ls_pocondx TO lt_pocondx.

    AT END OF ebeln.

      lv_purchaseorder      = ls_dados-ebeln.

*&----Calling BAPI function module
      CALL FUNCTION 'BAPI_PO_CHANGE'
        EXPORTING
          purchaseorder = lv_purchaseorder
          "testrun       = x
        TABLES
          return        = lt_return
*         poitem        = lt_poitem
*         poitemx       = lt_poitemx
          pocond        = lt_pocond
          pocondx       = lt_pocondx.
      IF sy-subrc EQ 0.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = space.

        LOOP AT lt_return INTO DATA(ls_return).
          PERFORM return_to_alv USING ls_return
                                      lv_purchaseorder
                                 CHANGING ti_alv.
        ENDLOOP.

      ENDIF.

      CLEAR: lt_poitem[], lt_poitemx[], lt_pocond[], lt_pocondx[], lt_return[].

    ENDAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*       Trata o retorno em report ALV
*----------------------------------------------------------------------*
FORM return_to_alv  USING u_return TYPE bapiret2
                          u_ebeln  TYPE ebeln
                 CHANGING c_alv TYPE tt_alv.

  APPEND INITIAL LINE TO c_alv ASSIGNING FIELD-SYMBOL(<fs_alv>).
  <fs_alv> = CORRESPONDING #( u_return ).
  <fs_alv>-ebeln = u_ebeln.

ENDFORM.
*&---------------------------------------------------------------------*
*       Mostra retorno da BAPI em ALV
*----------------------------------------------------------------------*
FORM mostra_alv .

  DATA: lr_table     TYPE REF TO cl_salv_table,
        lr_functions TYPE REF TO cl_salv_functions_list,
        lr_columns   TYPE REF TO cl_salv_columns_table,
        lr_column    TYPE REF TO cl_salv_column_table.

  TRY.
      cl_salv_table=>factory(
*        EXPORTING
*          list_display = abap_true
        IMPORTING
          r_salv_table = lr_table
        CHANGING
          t_table      = ti_alv ).
    CATCH cx_salv_msg.                                  "#EC NO_HANDLER
  ENDTRY.

  "Functions ALV
  lr_functions = lr_table->get_functions( ).
  lr_functions->set_all( abap_true ).

  "Columns ALV
  lr_columns = lr_table->get_columns( ).
  lr_columns->set_optimize( abap_true ).

  lr_table->display( ).

ENDFORM.
