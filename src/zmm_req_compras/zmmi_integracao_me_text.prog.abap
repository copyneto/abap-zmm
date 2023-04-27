*&---------------------------------------------------------------------*
*& Include          ZMMI_INTEGRACAO_ME_TEXT
*&---------------------------------------------------------------------*

CHECK l_pr_item_data-zz1_statu = 'M'.

LOOP AT lt_texttypes ASSIGNING FIELD-SYMBOL(<fs_textypes>).
  <fs_textypes>-displaymode = abap_true.
ENDLOOP.

* transfer data to MMTE (function group for text handling)
CALL FUNCTION 'MMPUR_TEXT_EXP_SUBSCREEN'
  EXPORTING
    im_textobject = l_tdobject
    im_language   = l_language
  TABLES
    imt_texttypes = lt_texttypes
    imt_textlines = lt_all_lines.
