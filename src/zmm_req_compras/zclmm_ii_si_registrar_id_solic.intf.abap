interface ZCLMM_II_SI_REGISTRAR_ID_SOLIC
  public .


  methods SI_REGISTRAR_ID_SOLICITACAO_IN
    importing
      !INPUT type ZMT_ID_SOLICITACAO
    raising
      ZCX_FMT_ID_SOLICITACAO .
endinterface.
