interface ZCLMM_II_SI_GERAR_REQUISICAO_C
  public .


  methods SI_GERAR_REQUISICAO_COMPRA_IN
    importing
      !INPUT type ZCLMM_MT_REQUISICAO_COMPRA
    raising
      ZCLMM_CX_FMT_REQUISICAO_COMPRA .
endinterface.
