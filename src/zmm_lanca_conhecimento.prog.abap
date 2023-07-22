***********************************************************************
***                      © 3corações                                ***
***********************************************************************
*** DESCRIÇÃO: Lançamento de Conhecimento de Transporte               *
*** AUTOR : Luiz Carlos Timbó                                         *
*** FUNCIONAL: Leandro Oliveira                                       *
*** DATA : 21.07.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
***            |                    |                                 *
***********************************************************************
REPORT zmm_lanca_conhecimento.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      open_file CHANGING cv_file TYPE string.

    METHODS:
      start_process IMPORTING iv_file TYPE string.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_fileline,
             doc_date     TYPE char10,
             pstng_date   TYPE char10,
             comp_code    TYPE char4,
             gross_amount TYPE char28,
             header_txt   TYPE bktxt,
             item_text    TYPE sgtxt,
             j_1bnftype   TYPE char2,
             po_number    TYPE char10,
             po_item      TYPE numc5,
             item_amount  TYPE char28,
           END OF ty_fileline,
           ty_fileline_itab TYPE TABLE OF ty_fileline.
    TYPES: BEGIN OF ty_input,
             bldat        TYPE bldat,
             budat        TYPE budat,
             bukrs        TYPE bukrs,
             gross_amount TYPE bapi_rmwwr,
             bktxt        TYPE bktxt,
             sgtxt        TYPE sgtxt,
             j_1bnftype   TYPE j_1bnftype,
             ebeln        TYPE ebeln,
             ebelp        TYPE ebelp,
             item_amount  TYPE bapiwrbtr,
           END OF ty_input.

    CONSTANTS gc_extension_xlsx TYPE string VALUE 'XLSX'.

    METHODS:
      read_file IMPORTING iv_file TYPE string
                EXPORTING et_itab TYPE ty_fileline_itab,
      convert_date IMPORTING im_date        TYPE char10
                   RETURNING VALUE(re_date) TYPE d,
      save_data IMPORTING is_itab TYPE ty_input.
ENDCLASS.

PARAMETERS p_file TYPE string OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  lcl_main=>open_file( CHANGING cv_file = p_file ).

START-OF-SELECTION.
  DATA(lr_main) = NEW lcl_main( ).
  lr_main->start_process( p_file ).

CLASS lcl_main IMPLEMENTATION.
  METHOD open_file.
    DATA: lt_file_table TYPE filetable,
          lv_rc         TYPE i.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        default_extension       = gc_extension_xlsx
      CHANGING
        file_table              = lt_file_table
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ELSE.
      TRY.
          cv_file = lt_file_table[ 1 ]-filename.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.
  ENDMETHOD.
  METHOD start_process.
    "Ler arquivo.
    read_file( EXPORTING iv_file = iv_file
               IMPORTING et_itab = DATA(lt_data) ).


    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      "Salvar dados.
      save_data( is_itab = VALUE ty_input( bldat        = convert_date( <fs_data>-doc_date )
                                           "budat        = CONVERT_DATE( <fs_data>-pstng_date )
                                           bukrs        = <fs_data>-comp_code
                                           "gross_amount = <fs_data>-gross_amount
                                           bktxt        = <fs_data>-header_txt
                                           sgtxt        = <fs_data>-item_text
                                           j_1bnftype   = <fs_data>-j_1bnftype
                                           ebeln        = <fs_data>-po_number
                                           ebelp        = <fs_data>-po_item
                                           "item_amount  = <fs_data>-item_amount
                                           ) ).
    ENDLOOP.
  ENDMETHOD.
  METHOD read_file.
    DATA lt_raw TYPE truxs_t_text_data.
    DATA(lv_filename) = CONV localfile( iv_file ).

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
*       I_FIELD_SEPERATOR    =
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw
        i_filename           = lv_filename
      TABLES
        i_tab_converted_data = et_itab
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.
    IF sy-subrc <> 0.
      CLEAR et_itab.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
  METHOD convert_date.
    DATA(lv_data) = im_date.
    TRANSLATE lv_data USING '. '.
    TRANSLATE lv_data USING '/ '.
    CONDENSE lv_data NO-GAPS.
    re_date = lv_data+6(4) && lv_data+4(2) && lv_data(2).
  ENDMETHOD.

  METHOD save_data.
    DATA: ls_headerdata    TYPE bapi_incinv_create_header,
          lt_itemdata      TYPE tcm_bapi_incinv_create_item_t,
          lt_return        TYPE bapiret2_t,
          lv_invoicenumber TYPE bapi_incinv_fld-inv_doc_no,
          lv_fiscalyear    TYPE bapi_incinv_fld-fisc_year.

    ls_headerdata-invoice_ind  = abap_true.
    ls_headerdata-doc_type     = 'RE'.
    ls_headerdata-doc_date     = ''.
    ls_headerdata-pstng_date   = ''.
    ls_headerdata-comp_code    = ''.
    ls_headerdata-currency     = 'BRL'.
    ls_headerdata-gross_amount = ''.
    ls_headerdata-calc_tax_ind = abap_true.
    ls_headerdata-pmnttrms     = ''.
    ls_headerdata-header_txt   = ''.
    ls_headerdata-item_text    = ''.
    ls_headerdata-j_1bnftype   = ''.

    APPEND VALUE #( invoice_doc_item = '000001'
                    po_number        = ''
                    po_item          = ''
                    tax_code         = ''
                    taxjurcode       = ''
                    item_amount      = ''
                    quantity         = '1.000'
                    po_unit          = '' ) TO lt_itemdata.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata       = ls_headerdata
*       ADDRESSDATA      =
*       INVOICESTATUS    = '5'
      IMPORTING
        invoicedocnumber = lv_invoicenumber
        fiscalyear       = lv_fiscalyear
      TABLES
        itemdata         = lt_itemdata
        return           = lt_return.

  ENDMETHOD.

ENDCLASS.
