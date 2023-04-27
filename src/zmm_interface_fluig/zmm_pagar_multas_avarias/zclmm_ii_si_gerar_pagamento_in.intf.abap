interface ZCLMM_II_SI_GERAR_PAGAMENTO_IN
  public .


  methods SI_GERAR_PAGAMENTO_INB
    importing
      !INPUT type ZCLMM_MT_PAGAMENTO
    exporting
      !OUTPUT type ZCLMM_MT_PAGAMENTO_RESP
    raising
      ZCLMM_CX_FMT_PAGAMENTO_ERRO .
endinterface.
