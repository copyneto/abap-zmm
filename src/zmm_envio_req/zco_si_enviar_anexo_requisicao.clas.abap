class ZCO_SI_ENVIAR_ANEXO_REQUISICAO definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods SI_ENVIAR_ANEXO_REQUISICAO_COM
    importing
      !OUTPUT type ZMT_ANEXO_REQUISICAO_COMPRA
    exporting
      !INPUT type ZMT_ANEXO_REQUISICAO_COMPRA_RE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_SI_ENVIAR_ANEXO_REQUISICAO IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_SI_ENVIAR_ANEXO_REQUISICAO'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_ENVIAR_ANEXO_REQUISICAO_COM.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_ENVIAR_ANEXO_REQUISICAO_COM'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
