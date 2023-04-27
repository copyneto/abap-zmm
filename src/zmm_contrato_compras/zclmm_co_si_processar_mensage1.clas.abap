class ZCLMM_CO_SI_PROCESSAR_MENSAGE1 definition
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
  methods SI_PROCESSAR_MENSAGEM_STATUS_C
    importing
      !OUTPUT type ZCLMM_MT_MENSAGEM_STATUS_CONTR
    exporting
      !INPUT type ZCLMM_MT_CONTRATO_COMPRA_STATU
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CO_SI_PROCESSAR_MENSAGE1 IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLMM_CO_SI_PROCESSAR_MENSAGE1'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_PROCESSAR_MENSAGEM_STATUS_C.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_PROCESSAR_MENSAGEM_STATUS_C'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
