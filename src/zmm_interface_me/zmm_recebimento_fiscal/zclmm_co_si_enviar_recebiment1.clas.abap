class ZCLMM_CO_SI_ENVIAR_RECEBIMENT1 definition
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
  methods SI_ENVIAR_RECEBIMENTO_FISCAL_O
    importing
      !OUTPUT type ZCLMM_MT_RECEBIMENTO_FISCAL
    exporting
      !INPUT type ZCLMM_MT_RECEBIMENTO_FISCAL_RE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CO_SI_ENVIAR_RECEBIMENT1 IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLMM_CO_SI_ENVIAR_RECEBIMENT1'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_ENVIAR_RECEBIMENTO_FISCAL_O.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_ENVIAR_RECEBIMENTO_FISCAL_O'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
