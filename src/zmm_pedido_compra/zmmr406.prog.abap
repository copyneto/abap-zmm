************************************************************************
****                     3CORAÇÕES                                     *
****                                                                   *
**** PROGRAMA: ZMMR406                                                 *
****                                                                   *
**** DESCRIÇÃO: - Modificação Massiva                                  *
****                                                                   *
**** AUTOR:        Luciano Casado                                      *
**** DATA:         11.07.2023                                          *
************************************************************************
**** HISTÓRICO DAS MODIFICAÇÕES                                        *
****-------------------------------------------------------------------*
**** DATA | AUTOR | DESCRIÇÃO                                          *
****-------------------------------------------------------------------*
****      |       |                                                    *
************************************************************************
REPORT zmmr406.

*----------------------------------------------------------------------*
*** Tipos
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_dados,
         ebeln      TYPE ebeln,   "Pedido
         ebelp      TYPE ebelp,   "Item pedido

         "POITEM - Item Data
         val_type   TYPE bwtar_d, "Tipo de avaliação
         preq_no    TYPE banfn,   "Nº requisição de compra
         preq_item  TYPE bnfpo,   "Nº do item da requisição de compra

         "POCOND - Conditions (Items)
         cond_p_unt TYPE char5,   "Unidade de preço da condição
         cond_value TYPE char28,  "Montante de condição
         cond_unit  TYPE char3,   "Unidade de medida da condição
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
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS p_file TYPE string OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*&---------------------------------------------------------------------*
*&      EVENTOS
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  gv_title = TEXT-002.
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
    PERFORM altera_itens_pedido.
    PERFORM mostra_alv.
  ENDIF.

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
    REPLACE ALL OCCURRENCES OF ',' IN ls_dados-cond_value  WITH '.'.
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
    REPLACE ALL OCCURRENCES OF ',' IN ls_dados-cond_value  WITH '.'.
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
  gs_dados_line-val_type   "Tipo de avaliação
  gs_dados_line-preq_no    "Nº requisição de compra
  gs_dados_line-preq_item  "Nº do item da requisição de compra
  gs_dados_line-cond_p_unt "Unidade de preço da condição
  gs_dados_line-cond_value "Montante de condição
  gs_dados_line-cond_unit  "Unidade de medida da condição
  IN CHARACTER MODE.

ENDFORM.

*&---------------------------------------------------------------------*
*       Chama BAPI para alterar itens pedido
*----------------------------------------------------------------------*
FORM altera_itens_pedido.

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

    IF ls_dados-val_type IS NOT INITIAL OR ls_dados-preq_no IS NOT INITIAL OR
       ls_dados-preq_item IS NOT INITIAL.

      UNPACK ls_dados-ebelp TO ls_dados-ebelp.
      UNPACK ls_dados-ebeln TO ls_dados-ebeln.

      ls_poitem-po_item   = ls_dados-ebelp.
      ls_poitemx-po_item  = ls_dados-ebelp.
      ls_poitemx-po_itemx = abap_true.

      IF ls_dados-val_type IS NOT INITIAL.
        ls_poitem-val_type  = ls_dados-val_type.
        ls_poitemx-val_type = abap_true.
      ENDIF.

      IF ls_dados-preq_no IS NOT INITIAL.
        ls_poitem-preq_no  = ls_dados-preq_no.
        UNPACK ls_poitem-preq_no TO ls_poitem-preq_no.

        ls_poitemx-preq_no = abap_true.
      ENDIF.

      IF ls_dados-preq_item IS NOT INITIAL.
        ls_poitem-preq_item  = ls_dados-preq_item.
        UNPACK ls_poitem-preq_item TO ls_poitem-preq_item.

        ls_poitemx-preq_item = abap_true.
      ENDIF.

      APPEND ls_poitem TO lt_poitem.
      CLEAR ls_poitem.

      APPEND ls_poitemx TO lt_poitemx.
      CLEAR ls_poitemx.
    ENDIF.

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

    IF ls_dados-cond_unit IS NOT INITIAL OR ls_dados-cond_p_unt IS NOT INITIAL OR
       ls_dados-cond_value IS NOT INITIAL.

      ls_pocond-itm_number = ls_dados-ebelp.
      ls_pocond-change_id  = |U|.
      ls_pocond-currency   = lv_waers.

      ls_pocondx-itm_number = ls_dados-ebelp.
      ls_pocondx-currency   = abap_true.
      ls_pocondx-change_id  = abap_true.

      IF ls_dados-cond_p_unt IS NOT INITIAL.
        ls_pocond-cond_p_unt  = ls_dados-cond_p_unt.
        ls_pocondx-cond_p_unt = abap_true.
      ENDIF.

      IF ls_dados-cond_value IS NOT INITIAL.
        ls_pocond-cond_value  = ls_dados-cond_value.
        ls_pocondx-cond_value = abap_true.
      ENDIF.

      IF ls_dados-cond_unit IS NOT INITIAL.
        ls_pocond-cond_unit  = |{ ls_dados-cond_unit ALPHA = IN }|.
        ls_pocondx-cond_unit = abap_true.
      ENDIF.
    ENDIF.

    APPEND ls_pocond TO lt_pocond.
    CLEAR ls_pocond.

    APPEND ls_pocondx TO lt_pocondx.
    CLEAR ls_pocondx.

    AT END OF ebeln.

      lv_purchaseorder = ls_dados-ebeln.

*&----Calling BAPI function module
      CALL FUNCTION 'BAPI_PO_CHANGE'
        EXPORTING
          purchaseorder = lv_purchaseorder
        TABLES
          return        = lt_return
          poitem        = lt_poitem
          poitemx       = lt_poitemx
          pocond        = lt_pocond
          pocondx       = lt_pocondx.

      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'. "#EC CI_STDSEQ

      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = space.
      ENDIF.

      LOOP AT lt_return INTO DATA(ls_return).            "#EC CI_NESTED
        PERFORM return_to_alv USING ls_return
                                    lv_purchaseorder
                               CHANGING ti_alv.
      ENDLOOP.

      CLEAR: lt_poitem[], lt_poitemx[], lt_pocond[], lt_pocondx[], lt_return[].

    ENDAT.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*       Trata o retorno em report ALV
*----------------------------------------------------------------------*
FORM return_to_alv  USING u_return TYPE bapiret2
                          u_ebeln  TYPE ebeln
                 CHANGING cv_alv TYPE tt_alv.

  APPEND INITIAL LINE TO cv_alv ASSIGNING FIELD-SYMBOL(<fs_alv>).
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
