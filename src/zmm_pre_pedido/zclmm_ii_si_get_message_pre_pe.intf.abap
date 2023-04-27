interface ZCLMM_II_SI_GET_MESSAGE_PRE_PE
  public .


  methods SI_GET_MESSAGE_PRE_PEDIDO_IN
    importing
      !INPUT type ZCLMM_MT_PRE_PEDIDO
    raising
      ZCLMM_CX_FMT_PRE_PEDIDO .
endinterface.
