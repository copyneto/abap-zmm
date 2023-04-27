@AbapCatalog.sqlViewName: 'ZVMM_PED_CAFE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Cafe'
define root view ZI_MM_PEDIDO_CAFE
  as select from ztmm_control_cla as _ControlClassif
  association [1..1] to ZI_MM_PURCHASEORDERHISTORY  as _History             on  $projection.Ebeln = _History.PurchaseOrder
                                                                            and $projection.Ebelp = _History.PurchaseOrderItem

  association [1..1] to I_PurchaseOrder             as _PurchaseOrder       on  $projection.Ebeln = _PurchaseOrder.PurchaseOrder

  association [1..1] to I_PurchaseOrderItemTP       as _PurchaseOrderItemTP on  $projection.Ebeln = _PurchaseOrderItemTP.PurchaseOrder
                                                                            and $projection.Ebelp = _PurchaseOrderItemTP.PurchaseOrderItem

  association [1..1] to I_Supplier                  as _Supplier            on  $projection.Lifnr = _Supplier.Supplier

  association [1..1] to I_Supplier                  as _Corretora           on  $projection.Corretora = _Corretora.Supplier

  association [1..1] to I_PurchaseOrderScheduleLine as _SheduleLine         on  $projection.Ebeln = _SheduleLine.PurchaseOrder
                                                                            and $projection.Ebelp = _SheduleLine.PurchaseOrderItem

  association [1..1] to ZI_MM_VALOR_CARAC_DIV       as _ValorCarac          on  $projection.Ebeln = _ValorCarac.Ebeln
                                                                            and $projection.Ebelp = _ValorCarac.Ebelp

  association [1..1] to I_PurOrdDeliveryAddressTP   as _OrdemItem           on  $projection.Ebeln = _OrdemItem.PurchaseOrder
                                                                            and $projection.Ebelp = _OrdemItem.PurchaseOrderItem 

  association [1..1] to ZI_MM_VLR_CARACTERISTICA    as _Carac               on  $projection.Ebeln = _Carac.Pedido
                                                                            and $projection.Ebelp = _Carac.ItemPedido


{
  key ebeln                 as Ebeln,
  key ebelp                 as Ebelp,
      gsber                 as Gsber,
      branch                as Branch,
      lifnr                 as Lifnr,
      corretor              as Corretor,
      corretora             as Corretora,
      perc_corretagem       as PercCorretagem,
      tp_sacaria            as TpSacaria,
      tp_embal              as TpEmbal,
      nro_contrato          as NroContrato,
      menge                 as Menge,
      meins                 as Meins,
      lagmg                 as Lagmg,
      emlif                 as Emlif,
      observacao            as Observacao,
      status_classific      as StatusClassific,
      open_purchorder       as OpenPurchorder,
      data_classif          as DataClassif,
      inco1                 as Inco1,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,

      _PurchaseOrder,
      _PurchaseOrderItemTP,
      _Supplier,
      _SheduleLine,
      _ValorCarac,
      _History,
      _Corretora,
      _OrdemItem,
      _Carac
}
