FUNCTION zf_cargacerta_vari_read.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI OPTIONAL
*"  EXPORTING
*"     VALUE(ES_PLANLOG_VARI) TYPE  ZSPLANLOG_VARI
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------

  DATA: ls_planlog_vari TYPE ztplanlog_Vari.


  SELECT SINGLE *
    FROM ztplanlog_Vari
    INTO ls_Planlog_Vari
    WHERE report = is_Planlog_Vari-report
    AND   vari = is_Planlog_Vari-vari
"   AND   field = is_planlog_Vari-field
    AND   cont = is_planlog_vari-cont.
  IF sy-subrc EQ 0.
    MOVE-CORRESPONDING ls_planlog_vari TO es_planlog_vari.
  ELSE.
    es_return-type = 'E'.
    es_return-message = 'Registro não existe!'.


  ENDIF.

ENDFUNCTION.
