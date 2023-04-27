interface ZCLMM_II_SI_REGISTRAR_STATUS_I
  public .


  methods SI_REGISTRAR_STATUS_IN
    importing
      !INPUT type ZCLMMMT_STATUS_PROCESSAMENTO
    raising
      ZCLMMCX_FMT_STATUS_PROCESSAMEN .
endinterface.
