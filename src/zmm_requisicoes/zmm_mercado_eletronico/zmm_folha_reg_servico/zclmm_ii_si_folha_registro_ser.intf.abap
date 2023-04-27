interface ZCLMM_II_SI_FOLHA_REGISTRO_SER
  public .


  methods SI_FOLHA_REGISTRO_SERVICO_IN
    importing
      !INPUT type ZCLMM_MT_FOLHA_REGISTRO_SERVIC
    raising
      ZCLMM_CX_FML_FOLHA_REGISTRO_SE .
endinterface.
