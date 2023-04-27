class ZCLMM_CL_SI_GERAR_PEDIDO_COMPR definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_GERAR_PEDIDO_COMPR .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_GERAR_PEDIDO_COMPR IMPLEMENTATION.


  METHOD zclmm_ii_si_gerar_pedido_compr~si_gerar_pedido_compra_in.

    NEW zclmm_argo_pedido_compra( )->gera_pedido( input ).

  ENDMETHOD.
ENDCLASS.
