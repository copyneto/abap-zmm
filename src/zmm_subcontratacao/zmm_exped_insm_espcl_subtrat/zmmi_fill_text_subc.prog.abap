*&---------------------------------------------------------------------*
*& Include          ZMMI_FILL_TEXT_SUBC
*&---------------------------------------------------------------------*

DATA:
  lv_j_1bnfadd_info TYPE j_1bnfadd_info,
  ls_message        TYPE j_1bnfftx,
  lt_msg            TYPE TABLE OF char72.

FIELD-SYMBOLS:
  <fs_armaz_key> TYPE zsmm_armaz_key,
  <fs_wa_nf_ftx> TYPE j_1b_tt_nfftx.

ASSIGN ('(SAPLZFGMM_PICKING)GS_ARMAZ_KEY') TO <fs_armaz_key>.
IF <fs_armaz_key> IS ASSIGNED.
  SELECT SINGLE nfenum, series, docdat, parid, name1
    FROM j_1bnfdoc
    WHERE docnum = @<fs_armaz_key>-docnum
    INTO @DATA(ls_j_1bnfdoc).

  IF sy-subrc <> 0.
    DATA(lv_skip) = abap_true.
  ELSE.
    SELECT docnum, cgc UP TO 1 ROWS FROM j_1bnfnad
      INTO @DATA(ls_j_1bnfnad)
      WHERE docnum = @<fs_armaz_key>-docnum.
      ENDSELECT.
  ENDIF.

  IF <fs_armaz_key>-especial = abap_false.
    DATA(lv_msg_sub) = |{ TEXT-f65 } { ls_j_1bnfdoc-nfenum }-{ ls_j_1bnfdoc-series }|.
  ELSE.
    DATA(lv_docdata_format) = |{ ls_j_1bnfdoc-docdat+6(2) }.{ ls_j_1bnfdoc-docdat+4(2) }.{ ls_j_1bnfdoc-docdat(4) }|.
    lv_msg_sub = |REMESSA SIMBÓLICA DE MERCADORIA JÁ ENTREGUE AO DESTINATÁRIO POR CONTA E ORDEM. CONFORME | &&
                 |NF-E  { ls_j_1bnfdoc-nfenum }-{ ls_j_1bnfdoc-series }, data de emissão { lv_docdata_format }, | &&
                 |Fornecedor { ls_j_1bnfdoc-parid }-{ ls_j_1bnfdoc-name1 } e CNPJ do fornecedor { ls_j_1bnfnad-cgc }|.

  ENDIF.

  ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_wa_nf_ftx>.
  LOOP AT <fs_wa_nf_ftx> ASSIGNING FIELD-SYMBOL(<fs_wa_nf_ftx_1>).
    IF <fs_wa_nf_ftx_1>-seqnum > ls_message-seqnum.
      ls_message-seqnum = <fs_wa_nf_ftx_1>-seqnum.
    ENDIF.
    IF <fs_armaz_key>-especial = abap_false.
      IF <fs_wa_nf_ftx_1>-message(20) = lv_msg_sub(20).
        lv_skip = abap_true.
      ENDIF.
    ELSE.
      IF <fs_wa_nf_ftx_1>-message(20) = lv_msg_sub(20).
        lv_skip = abap_true.
      ENDIF.
    endif.
  ENDLOOP.

  ADD 1 TO ls_message-seqnum.

  IF <fs_wa_nf_ftx> IS ASSIGNED AND lv_skip = abap_false.

    CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
      EXPORTING
        text        = lv_msg_sub
        line_length = 72
      TABLES
        text_tab    = lt_msg.

    LOOP AT lt_msg ASSIGNING FIELD-SYMBOL(<fs_msg_sub>).
      ls_message-linnum  = sy-tabix.
      ls_message-docnum  = is_header-docnum.
      ls_message-message  = <fs_msg_sub>.
      APPEND ls_message TO <fs_wa_nf_ftx>.
    ENDLOOP.

  ENDIF.
ENDIF.
