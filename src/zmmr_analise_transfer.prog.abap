*----------------------------------------------------------------------------*
* META
* Programa/Função: ZMMR_ANALISE_TRANSFER
* MÛdulo.........: MM
* Descrição....: Simula imposto do item da remessa
* Autores........: Cleverson Faria
* Data...........: 10/02/2022
*----------------------------------------------------------------------------*
REPORT zmmr_analise_transfer.

*----------------------------------------------------------------------------*
* Tabelas Transparentes                                                      *
*----------------------------------------------------------------------------*
TABLES: lips. "Documento SD: fornecimento: dados de item

*----------------------------------------------------------------------------*
* Tipos                                                                      *
*----------------------------------------------------------------------------*
TYPES: BEGIN OF ty_s_log,
         msgid   TYPE sy-msgid,
         msgno   TYPE sy-msgno,
         msgty   TYPE sy-msgty,
         message TYPE char100,
       END OF ty_s_log.

*----------------------------------------------------------------------------*
* Estruturas                                                                 *
*----------------------------------------------------------------------------*
DATA: gs_imkpf      TYPE imkpf,
      gs_emkpf      TYPE emkpf,
      gs_imseg      TYPE imseg,
      gs_obj_header TYPE j_1bnfdoc.

*----------------------------------------------------------------------------*
* Tabelas Internas                                                           *
*----------------------------------------------------------------------------*
DATA: gt_imseg             TYPE TABLE OF imseg,
      gt_emseg             TYPE TABLE OF emseg,
      gt_vbpa              TYPE TABLE OF vbpa,
      gt_log               TYPE TABLE OF ty_s_log,
      gt_obj_partner       TYPE TABLE OF  j_1bnfnad,
      gt_obj_item          TYPE TABLE OF  j_1bnflin,
      gt_obj_item_tax      TYPE TABLE OF  j_1bnfstx,
      gt_obj_header_msg    TYPE TABLE OF  j_1bnfftx,
      gt_obj_refer_msg     TYPE TABLE OF  j_1bnfref,
      gt_obj_ot_partner    TYPE TABLE OF  j_1bnfcpd,
      gt_obj_import_di     TYPE TABLE OF  j_1bnfimport_di,
      gt_obj_import_adi    TYPE TABLE OF  j_1bnfimport_adi,
      gt_obj_cte_res       TYPE TABLE OF  j_1bcte_d_res,
      gt_obj_cte_docref    TYPE TABLE OF  j_1bcte_d_docref,
      gt_obj_trans_volumes TYPE TABLE OF  j_1bnftransvol,
      gt_obj_trailer_info  TYPE TABLE OF  j_1bnftrailer,
      gt_obj_trade_notes   TYPE TABLE OF  j_1bnftradenotes,
      gt_obj_add_info      TYPE TABLE OF  j_1bnfadd_info,
      gt_obj_ref_proc      TYPE TABLE OF  j_1bnfrefproc,
      gt_obj_sugar_suppl   TYPE TABLE OF  j_1bnfsugarsuppl,
      gt_obj_sugar_deduc   TYPE TABLE OF  j_1bnfsugardeduc,
      gt_obj_vehicle       TYPE TABLE OF  j_1bnfvehicle,
      gt_obj_pharmaceut    TYPE TABLE OF  j_1bnfpharmaceut,
      gt_obj_fuel          TYPE TABLE OF  j_1bnffuel,
      gt_obj_export        TYPE TABLE OF  j_1bnfe_export,
      gt_obj_nve           TYPE TABLE OF  j_1bnfnve,
      gt_obj_traceability  TYPE TABLE OF  j_1bnfetrace,
      gt_obj_pharma        TYPE TABLE OF  j_1bnfepharma,
      gt_obj_payment       TYPE TABLE OF  j_1bnfepayment.


*----------------------------------------------------------------------------*
* Constantes                                                                 *
*----------------------------------------------------------------------------*

*----------------------------------------------------------------------------*
* Vari·veis                                                                  *
*----------------------------------------------------------------------------*
DATA: gv_ebeln TYPE ebeln,
      gv_nfobj TYPE j_1bdocnum,
      gv_msg   TYPE bapi_msg.

*----------------------------------------------------------------------------*
* Objetos                                                                    *
*----------------------------------------------------------------------------*
DATA: go_salv TYPE REF TO cl_salv_table.

*----------------------------------------------------------------------------*
* Selection Screen                                                           *
*----------------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-b01.
  PARAMETERS:     p_vbeln TYPE vbeln OBLIGATORY.
  SELECT-OPTIONS: s_posnr FOR lips-posnr.
  PARAMETERS:     p_budat TYPE budat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK bl1.

*----------------------------------------------------------------------------*
* Start of Selection                                                         *
*----------------------------------------------------------------------------*
START-OF-SELECTION.

  SELECT SINGLE *
  FROM likp
  INTO @DATA(gs_likp)
  WHERE vbeln = @p_vbeln.

  SELECT *
  FROM lips
  INTO TABLE @DATA(gt_lips)
  WHERE vbeln EQ @p_vbeln
    AND posnr IN @s_posnr
    AND nowab = @space.

  SELECT *
  FROM vbpa
  INTO TABLE gt_vbpa
  WHERE vbeln = p_vbeln.

  gs_imkpf-budat          = p_budat.
  gs_imkpf-bldat          = p_budat.
  gs_imkpf-bfwms          = '2'.
  gs_imkpf-xblnr          = gs_likp-vbeln.
  gs_imkpf-spe_budat_zone = gs_likp-tzonis.
  gs_imkpf-le_vbeln       = gs_likp-vbeln.

*Preenche dados localizaÁ„o Inicio
  CALL FUNCTION 'J_1B_IM_TF_SET_GLOBAL_VAR'
    EXPORTING
      i_tf_sd_data_reset = 'X'.

  LOOP AT gt_lips INTO DATA(gs_lips).

    CLEAR gs_imseg.
    gs_imseg-called_by = 'VL02N'.
    gs_imseg-bwart     = gs_lips-bwart.
    gs_imseg-xdeliv    = '1'.
    gs_imseg-xnocon    = 'X'.
    gs_imseg-matnr     = gs_lips-matnr.
    gs_imseg-werks     = gs_lips-werks.
    gs_imseg-lgort     = gs_lips-lgort.
    gs_imseg-kzbew     = 'L'.
    gs_imseg-erfmg     = gs_lips-lfimg.
    gs_imseg-erfme     = gs_lips-vrkme.
    gs_imseg-menge     = gs_lips-lgmng. "Verificar
    gs_imseg-meins     = gs_lips-meins.
    gs_imseg-ebeln     = gs_lips-vgbel.
    gs_imseg-ebelp     = gs_lips-vgpos.
    gs_imseg-wempf     = gs_likp-kunnr.
    gs_imseg-vbeln     = gs_lips-vbeln.
    gs_imseg-posnr     = gs_lips-posnr.
    gs_imseg-umrez     = gs_lips-umvkz. "Verificar
    gs_imseg-umren     = gs_lips-umvkn. "Verificar
    APPEND gs_imseg TO gt_imseg.

    gv_ebeln = gs_lips-vgbel.

    CALL FUNCTION 'J_1B_IM_TF_SET_GLOBAL_VAR'
      EXPORTING
        i_tf_sd_header      = gs_likp
        i_tf_sd_item        = gs_lips
        i_tf_sd_data_active = 'X'
        i_tf_sd_fkarv       = 'ZF2'
        i_tf_mm_doc_num     = gv_ebeln                "1879100
      TABLES
        t_partner           = gt_vbpa.

  ENDLOOP.

  CALL FUNCTION 'MB_SIMULATE_GOODS_MOVEMENT'
    EXPORTING
      sim_imkpf = gs_imkpf
      ctcod     = 'VL02N'
      xvalues   = 'X'
    IMPORTING
      sim_emkpf = gs_emkpf
    TABLES
      sim_emseg = gt_emseg
      sim_imseg = gt_imseg.

  LOOP AT gt_emseg ASSIGNING FIELD-SYMBOL(<fs_emseg>).

    DATA(gs_log) = VALUE ty_s_log( msgid = <fs_emseg>-msgid msgno = <fs_emseg>-msgno msgty = <fs_emseg>-msgty ).

    IF gs_log-msgid IS NOT INITIAL.
      CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
        EXPORTING
          id         = gs_log-msgid
          number     = gs_log-msgno
          language   = sy-langu
          textformat = 'ASC'
          message_v1 = <fs_emseg>-msgv1
          message_v2 = <fs_emseg>-msgv2
          message_v3 = <fs_emseg>-msgv3
          message_v4 = <fs_emseg>-msgv4
        IMPORTING
          message    = gv_msg.

      gs_log-message = gv_msg.
      APPEND gs_log TO gt_log.
    ENDIF.
  ENDLOOP.

  IF gs_emkpf-msgid <> ''.

    gs_log-msgid = gs_emkpf-msgid.
    gs_log-msgno = gs_emkpf-msgno.
    gs_log-msgty = gs_emkpf-msgty.

    CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
      EXPORTING
        id         = gs_log-msgid
        number     = gs_log-msgno
        language   = sy-langu
        textformat = 'ASC'
        message_v1 = gs_emkpf-msgv1
        message_v2 = gs_emkpf-msgv2
        message_v3 = gs_emkpf-msgv3
        message_v4 = gs_emkpf-msgv4
      IMPORTING
        message    = gv_msg.

    gs_log-message = gv_msg.
    APPEND gs_log TO gt_log.
  ENDIF.

  IF gt_log IS NOT INITIAL.
    TRY .
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = go_salv
          CHANGING
            t_table      = gt_log.
      CATCH cx_salv_msg.
    ENDTRY.

    go_salv->set_screen_popup( EXPORTING start_column = '1'
                                         end_column   = '100'
                                         start_line   = '1'
                                         end_line     = '20' ).

    go_salv->display( ).
    REFRESH gt_log.
  ENDIF.

*** Recupera objeto da nota fiscal
  GET PARAMETER ID 'J_1BNFE_OBJECT' FIELD gv_nfobj.

  IF gv_nfobj IS NOT INITIAL.

    CALL FUNCTION 'J_1B_NF_OBJECT_READ'
      EXPORTING
        obj_number        = gv_nfobj
      IMPORTING
        obj_header        = gs_obj_header
      TABLES
        obj_partner       = gt_obj_partner
        obj_item          = gt_obj_item
        obj_item_tax      = gt_obj_item_tax
        obj_header_msg    = gt_obj_header_msg
        obj_refer_msg     = gt_obj_refer_msg
        obj_ot_partner    = gt_obj_ot_partner
        obj_import_di     = gt_obj_import_di
        obj_import_adi    = gt_obj_import_adi
        obj_cte_res       = gt_obj_cte_res
        obj_cte_docref    = gt_obj_cte_docref
        obj_trans_volumes = gt_obj_trans_volumes
        obj_trailer_info  = gt_obj_trailer_info
        obj_trade_notes   = gt_obj_trade_notes
        obj_add_info      = gt_obj_add_info
        obj_ref_proc      = gt_obj_ref_proc
        obj_sugar_suppl   = gt_obj_sugar_suppl
        obj_sugar_deduc   = gt_obj_sugar_deduc
        obj_vehicle       = gt_obj_vehicle
        obj_pharmaceut    = gt_obj_pharmaceut
        obj_fuel          = gt_obj_fuel
        obj_export        = gt_obj_export
        obj_nve           = gt_obj_nve
        obj_traceability  = gt_obj_traceability
        obj_pharma        = gt_obj_pharma
        obj_payment       = gt_obj_payment
      EXCEPTIONS
        object_not_found  = 1
        OTHERS            = 2.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE a104(8b) WITH gv_nfobj.
    ENDIF.

    LOOP AT gt_obj_item ASSIGNING FIELD-SYMBOL(<fs_items>).
      <fs_items>-refitm = sy-tabix.
    ENDLOOP.

    CALL FUNCTION 'J_1B_NF_OBJECT_UPDATE'
      EXPORTING
        obj_number        = gv_nfobj
        obj_header        = gs_obj_header
      TABLES
        obj_partner       = gt_obj_partner
        obj_item          = gt_obj_item
        obj_item_tax      = gt_obj_item_tax
        obj_header_msg    = gt_obj_header_msg
        obj_refer_msg     = gt_obj_refer_msg
        obj_ot_partner    = gt_obj_ot_partner
        obj_import_di     = gt_obj_import_di
        obj_import_adi    = gt_obj_import_adi
        obj_cte_res       = gt_obj_cte_res
        obj_cte_docref    = gt_obj_cte_docref
        obj_trans_volumes = gt_obj_trans_volumes
        obj_trailer_info  = gt_obj_trailer_info
        obj_trade_notes   = gt_obj_trade_notes
        obj_add_info      = gt_obj_add_info
        obj_ref_proc      = gt_obj_ref_proc
        obj_sugar_suppl   = gt_obj_sugar_suppl
        obj_sugar_deduc   = gt_obj_sugar_deduc
        obj_vehicle       = gt_obj_vehicle
        obj_pharmaceut    = gt_obj_pharmaceut
        obj_fuel          = gt_obj_fuel
        obj_export        = gt_obj_export
        obj_nve           = gt_obj_nve
        obj_traceability  = gt_obj_traceability
        obj_pharma        = gt_obj_pharma
        obj_payment       = gt_obj_payment
      EXCEPTIONS
        object_not_found  = 1
        OTHERS            = 2.
    IF NOT sy-subrc IS INITIAL.
      MESSAGE a104(8b) WITH gv_nfobj.
    ENDIF.

    CALL FUNCTION 'J_1B_NF_OBJECT_EDIT'
      EXPORTING
        obj_number         = gv_nfobj
        modef              = 'CRE'
      EXCEPTIONS
        object_not_found   = 1
        scr_ctrl_not_found = 2
        screen_not_found   = 3
        error_message      = 4
        OTHERS             = 5.

    IF sy-subrc IS NOT INITIAL.

      gs_log-msgid = sy-msgid.
      gs_log-msgno = sy-msgno.
      gs_log-msgty = sy-msgty.

      CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
        EXPORTING
          id         = gs_log-msgid
          number     = gs_log-msgno
          language   = sy-langu
          textformat = 'ASC'
          message_v1 = gs_emkpf-msgv1
          message_v2 = gs_emkpf-msgv2
          message_v3 = gs_emkpf-msgv3
          message_v4 = gs_emkpf-msgv4
        IMPORTING
          message    = gv_msg.

      gs_log-message = gv_msg.
      REFRESH gt_log.
      APPEND gs_log TO gt_log.
    ENDIF.

  ELSE.
    gs_log-msgid   = '00'.
    gs_log-msgno   = '001'.
    gs_log-msgty   = 'E'.
    gs_log-message = 'Nota n„o foi gerada'.
    gs_log-message = gv_msg.
    REFRESH gt_log.
    APPEND gs_log TO gt_log.
  ENDIF.

  IF gt_log IS NOT INITIAL.
    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = go_salv
          CHANGING
            t_table      = gt_log.
      CATCH cx_salv_msg.
    ENDTRY.

    go_salv->set_screen_popup( EXPORTING start_column = '1'
                                         end_column   = '100'
                                         start_line   = '1'
                                         end_line     = '20' ).

    go_salv->display( ).
  ENDIF.
