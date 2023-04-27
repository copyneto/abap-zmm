@AbapCatalog.sqlViewAppendName: 'ZCPCCABEEXTEND'
@EndUserText.label: 'Extend Cabeçalho Pedido de Compra'
extend view C_PurchaseOrderFs with ZC_mm_pc_cabecalho_extend
  association [1..1] to zi_mm_pc_cabecalho as _AddField on I_PurchaseOrderEnhanced.PurchaseOrder = _AddField.PurchaseOrder
{
  @ObjectModel.text.element: [ 'ValorBruto' ]
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  @UI.identification: [{
         position: 40,
         importance: #HIGH }]
  _AddField.ValorBruto
}
