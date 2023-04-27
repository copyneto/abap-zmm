interface ZCLMM_II_SI_CANCELAR_ITEM_REQU
  public .


  methods SI_CANCELAR_ITEM_REQUISICAO_IN
    importing
      !INPUT type ZCLMM_MT_CANCELAR_ITEM_REQUISI
    raising
      ZCLMM_CX_FMT_CANCELAR_ITEM_REQ .
endinterface.
