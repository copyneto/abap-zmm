class ZCLMM_CO_SI_PROCESSAR_MENSAGEM definition
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
  methods SI_PROCESSAR_MENSAGEM_STATUS_F
    importing
      !OUTPUT type ZCLMM_MT_MENSAGEM_STATUS_FRS
    exporting
      !INPUT type ZCLMM_MT_MENSAGEM_STATUS_FRSRE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_CO_SI_PROCESSAR_MENSAGEM IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLMM_CO_SI_PROCESSAR_MENSAGEM'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_PROCESSAR_MENSAGEM_STATUS_F.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_PROCESSAR_MENSAGEM_STATUS_F'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
