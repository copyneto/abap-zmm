interface ZCLMM_II_SI_GERAR_CONTRATO_COM
  public .


  methods SI_GERAR_CONTRATO_COMPRA_IN
    importing
      !INPUT type ZCLMM_MT_CONTRATO_COMPRA
    raising
      ZCLMM_CX_FMT_CONTRATO_COMPRA .
endinterface.
