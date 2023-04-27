interface ZCLMM_II_SI_GRAVAR_INVENTARIO
  public .


  methods SI_GRAVAR_INVENTARIO_FISICO_IN
    importing
      !INPUT type ZCLMM_MT_INVENTARIO_FISICO
    raising
      ZCLMM_CX_FMT_INVENTARIO_FISICO .
endinterface.
