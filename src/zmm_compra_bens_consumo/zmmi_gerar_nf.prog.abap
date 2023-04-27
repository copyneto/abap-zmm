*&---------------------------------------------------------------------*
*& Include zmmi_gerar_nf
*&---------------------------------------------------------------------*

CALL FUNCTION 'ZFMMM_GERAR_NF_INVENTARIO'
  STARTING NEW TASK 'GERAR_NF_INVENTARIO'
  TABLES
    it_mseg = xmseg[]
    it_mkpf = xmkpf[].
