*&---------------------------------------------------------------------*
*& Include zmmr_emissao_nf_inventario_s01
*&---------------------------------------------------------------------*

************************************************************************
* TELA DE SELEÇÃO                                                      *
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_iblnr FOR ztmm_alivium-iblnr,
                  s_gjahr FOR ztmm_alivium-gjahr OBLIGATORY NO INTERVALS NO-EXTENSION,
                  s_werks FOR ikpf-werks,
                  s_budat FOR ikpf-budat,
                  s_bldat FOR ikpf-bldat,
                  s_mblnr FOR ztmm_alivium-mblnr.
SELECTION-SCREEN END OF BLOCK b1.
