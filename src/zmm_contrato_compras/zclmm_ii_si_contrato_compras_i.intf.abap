interface ZCLMM_II_SI_CONTRATO_COMPRAS_I
  public .


  methods SI_CONTRATO_COMPRAS_IN
    importing
      !INPUT type ZCLMM_MT_CONTRATO_COMPRAS
    raising
      ZCLMM_CX_FMT_CONTRATO_COMPRA .
endinterface.
