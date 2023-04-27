*&---------------------------------------------------------------------*
*& Include          ZMMI_JOB_3C_NF_FATURADA_SCR
*&---------------------------------------------------------------------*
* ======================================================================
* Tela de seleção
* ======================================================================

DATA: gt_doc    TYPE logbr_docdat,
      gt_cnpj_e TYPE logbr_nfpartnercnpj,
      gt_cnpj_d TYPE logbr_cnpj_bupla.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_tipo   TYPE ze_mm_3c_doc_type AS LISTBOX VISIBLE LENGTH 10.
  SELECT-OPTIONS: s_data   FOR gt_doc,
                  s_cnpj_e FOR gt_cnpj_e,
                  s_cnpj_d FOR gt_cnpj_d.
  PARAMETERS: p_nfe   TYPE logbr_nfnum9,
              p_chave TYPE /xnfe/id.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-bl2.
  PARAMETERS: p_file TYPE ze_trm_filename MODIF ID arq,
              p_locl RADIOBUTTON GROUP arq MODIF ID arq DEFAULT 'X' USER-COMMAND arq,
              p_serv RADIOBUTTON GROUP arq MODIF ID arq.
SELECTION-SCREEN END OF BLOCK bl2.
