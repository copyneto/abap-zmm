*&---------------------------------------------------------------------*
*& Include ZMMI_LOTE_RESTRITO
*&---------------------------------------------------------------------*
* Atualização Lote Restrito
  CALL FUNCTION 'ZFMMM_ATU_LOTE_RESTRITO' IN BACKGROUND TASK
    TABLES
      it_mseg = xmseg.
