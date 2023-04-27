*&---------------------------------------------------------------------*
*& Include          ZMMI_MSG_INSUMOS
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_msg,
    msg TYPE char60,
  END OF ty_msg.

FIELD-SYMBOLS:
  <fs_tb_header_msg> TYPE j_1bnfftx_tab,
  <fs_tb_xml_obs>    TYPE j1b_nf_xml_obs_tab,
  <fs_xmlh_msg>      TYPE j1b_nf_xml_header,
  <fs_xmlitem>       TYPE j1b_nf_xml_item.
DATA:
  lv_msg_string TYPE string,
  lt_tab_msg    TYPE TABLE OF ty_msg.

ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER_MSG[]') TO <fs_tb_header_msg>.
ASSIGN ('(SAPLJ_1B_NFE)XML_OBS_CONT_TAB[]') TO <fs_tb_xml_obs>.
ASSIGN ('(SAPLJ_1B_NFE)xmlh') TO <fs_xmlh_msg>.

IF <fs_xmlh_msg>-infcomp IS INITIAL.
  LOOP AT <fs_tb_header_msg> ASSIGNING FIELD-SYMBOL(<fs_header_msg1>).
    IF sy-tabix = 1.
      lv_msg_string = <fs_header_msg1>-message.
      DATA(lv_seqnum) = <fs_header_msg1>-seqnum.
      DATA(lv_docnum_msg) = <fs_header_msg1>-docnum.
    ELSE.
      IF lv_seqnum =  <fs_header_msg1>-seqnum.
        lv_msg_string = |{ lv_msg_string }{ <fs_header_msg1>-message }|.
      ELSE.
*        SEARCH lv_msg_string FOR <fs_header_msg1>-message.
*        IF sy-subrc NE 0.
        lv_msg_string = |{ lv_msg_string } - { <fs_header_msg1>-message }|.
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF lv_msg_string IS NOT INITIAL.

    <fs_xmlh_msg>-infcomp = lv_msg_string.

*  CALL FUNCTION 'SOTR_SERV_STRING_TO_TABLE'
*    EXPORTING
*      text        = lv_msg_string
*      line_length = 60
*    TABLES
*      text_tab    = lt_tab_msg.
*
*
*  LOOP AT it_tab_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
*    APPEND INITIAL LINE TO <fs_tb_xml_obs> ASSIGNING FIELD-SYMBOL(<fs_xml_obs>).
*    <fs_xml_obs>-docnum  = lv_docnum_msg.
*    <fs_xml_obs>-x_campo = 'infCpl'.
*    <fs_xml_obs>-x_texto = <fs_msg>.
*  ENDLOOP.
  ENDIF.
ENDIF.

IF it_lin-itmtyp = '02' AND it_lin-reftyp = 'MD'.
  SELECT vbeln_im
     FROM mseg WHERE mblnr = @it_lin-refkey(10)
   AND mjahr = @it_lin-refkey+10(4)
   INTO @DATA(lv_doc)
    UP TO 1 ROWS.
  ENDSELECT.
  IF sy-subrc EQ 0 AND
     <fs_tb_xml_obs> IS INITIAL AND
     NOT lv_doc IS INITIAL.
    APPEND INITIAL LINE TO <fs_tb_xml_obs> ASSIGNING FIELD-SYMBOL(<fs_xml_obs>).
    <fs_xml_obs>-docnum  = lv_docnum_msg.
    <fs_xml_obs>-x_campo = 'REMESSA'.
    <fs_xml_obs>-x_texto = lv_doc.
  ENDIF.
ENDIF.
