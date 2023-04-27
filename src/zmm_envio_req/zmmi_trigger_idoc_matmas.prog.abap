*&---------------------------------------------------------------------*
*& Include          ZMMI_TRIGGER_IDOC_MATMAS
*&---------------------------------------------------------------------*

NEW zclmm_trigger_matmas(  )->execute( EXPORTING iv_matnr = wmara-matnr
                                                 iv_mtart = wmara-mtart
                                                 iv_tcode = sy-tcode ).
