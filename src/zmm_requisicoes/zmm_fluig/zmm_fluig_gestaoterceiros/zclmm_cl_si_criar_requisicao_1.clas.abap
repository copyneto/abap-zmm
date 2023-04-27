class ZCLMM_CL_SI_CRIAR_REQUISICAO_1 definition
  public
  create public .

public section.

  interfaces ZCLMM_II_SI_CRIAR_REQUISICAO_1 .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CL_SI_CRIAR_REQUISICAO_1 IMPLEMENTATION.


  METHOD zclmm_ii_si_criar_requisicao_1~si_criar_requisicao_compras_in.

    DATA(lo_req_compra) = NEW zclmm_gestaoterceiros_rec( ).

    lo_req_compra->execute( input ).

  ENDMETHOD.
ENDCLASS.
