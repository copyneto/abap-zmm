interface ZCLMM_II_SI_CANCELAR_PEDIDO_IN
  public .


  methods SI_CANCELAR_PEDIDO_IN
    importing
      !INPUT type ZCLMM_MT_CANCELAR_PEDIDO
    raising
      ZCLMM_CX_FMT_CANCELAR_PEDIDO .
endinterface.
