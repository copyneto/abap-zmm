@AbapCatalog.sqlViewAppendName: 'ZCPCITEMEXTEND'
@EndUserText.label: 'Extend Item Pedido de Compra'
extend view C_PurOrdItemEnh with ZC_mm_pc_item_extend
  association [1..1] to zi_mm_pc_item as _AddFieldItem on  I_PurchaseorderItemEnhanced.PurchaseOrder     = _AddFieldItem.PurchaseOrder
                                                       and I_PurchaseorderItemEnhanced.PurchaseOrderItem = _AddFieldItem.PurchaseOrderItem
{
//  @UI.lineItem: [{
//            qualifier: 'PurchItem',
//            position: 130,
//            importance: #HIGH },{
//            position: 130,
//            importance: #HIGH
//            }]
//  @Semantics.amount.currencyCode: 'DocumentCurrency'
//  _AddFieldItem.ValorBrutoAnterior,
//
//  @UI.lineItem: [{
//            qualifier: 'PurchItem',
//            position: 140,
//            importance: #HIGH },{
//            position: 140,
//            importance: #HIGH
//            }]
//  @Semantics.amount.currencyCode: 'DocumentCurrency'
//  _AddFieldItem.PrecoAnteriorPMM,
//
//  @UI.lineItem: [{
//            qualifier: 'PurchItem',
//            position: 150,
//            importance: #HIGH },{
//            position: 150,
//            importance: #HIGH
//            }]
//  @Semantics.amount.currencyCode: 'DocumentCurrency'
//  _AddFieldItem.ValorBruto
  
  
  @UI.lineItem: [{
            qualifier: 'PurchItem',
            position: 89,
            importance: #HIGH },{
            position: 89,
            importance: #HIGH
            }]
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  _AddFieldItem.ValorBrutoAnterior,

  @UI.lineItem: [{
            qualifier: 'PurchItem',
            position: 90,
            importance: #HIGH },{
            position: 90,
            importance: #HIGH
            }]
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  _AddFieldItem.PrecoAnteriorPMM,

  @UI.lineItem: [{
            qualifier: 'PurchItem',
            position: 88,
            importance: #HIGH },{
            position: 88,
            importance: #HIGH
            }]
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  _AddFieldItem.ValorBruto

}
