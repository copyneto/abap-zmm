*&---------------------------------------------------------------------*
*& Include          ZMMI_TRIGGER_IDOC_MATMAS
*&---------------------------------------------------------------------*

 DATA: lv_memory_id TYPE indx_srtfd,
       lv_werks     TYPE werks_d.

 CLEAR lv_werks.
 lv_memory_id = |{ wmara-matnr }{ sy-uname(4) }|.
 IMPORT lv_werks TO lv_werks FROM DATABASE indx(zp) ID lv_memory_id.
 " Export no método ZCLMM_ATUAL_MAT_PALETIZACAO~ATUALIZA_MAT

 " Execução restrita ao aplicativo de Paletização
 IF sy-subrc IS INITIAL.
   NEW zclmm_trigger_matmas(  )->execute( EXPORTING iv_matnr = wmara-matnr
                                                    iv_mtart = wmara-mtart
                                                    iv_tcode = sy-tcode ).
 ENDIF.
