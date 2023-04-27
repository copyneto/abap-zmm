interface ZCLMM_II_SI_GERAR_PEDIDO_COMPR
  public .


  methods SI_GERAR_PEDIDO_COMPRA_IN
    importing
      !INPUT type ZCLMM_MT_PEDIDO_COMPRA
    raising
      ZCLMM_CX_FMT_PEDIDO_COMPRA .
endinterface.
