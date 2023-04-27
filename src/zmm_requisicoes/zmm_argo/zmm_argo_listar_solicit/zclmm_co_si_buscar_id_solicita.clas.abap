class ZCLMM_CO_SI_BUSCAR_ID_SOLICITA definition
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
  methods SI_BUSCAR_ID_SOLICITACAO_OUT
    importing
      !OUTPUT type ZMT_STATUS_VIAGEM
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CO_SI_BUSCAR_ID_SOLICITA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLMM_CO_SI_BUSCAR_ID_SOLICITA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_BUSCAR_ID_SOLICITACAO_OUT.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_BUSCAR_ID_SOLICITACAO_OUT'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
