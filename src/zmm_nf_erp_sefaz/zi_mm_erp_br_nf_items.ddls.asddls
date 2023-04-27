@AbapCatalog.sqlViewName: 'ZVMM_NFERPITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Items de Nota Fiscal - ERP'
define view ZI_MM_ERP_BR_NF_ITEMS
  as select distinct from I_BR_NFItem as _NFItem
    left outer join       matdoc      as _Item on  _Item.matnr             =  _NFItem.Material
                                               and _Item.werks             =  _NFItem.Plant
                                               and _Item.ebeln             =  _NFItem.PurchaseOrder
                                               and _Item.ebelp             =  _NFItem.PurchaseOrderItem
                                               and _Item.line_id           =  _NFItem.BR_NFSourceDocumentItem
                                               and _Item.cancelled         <> 'X'
                                               and _Item.reversal_movement <> 'X'
                                               and _Item.kzbew             =  'B'
  //  association [*] to I_MaterialDocumentItem as _Item on   _Item.Material = $projection.Material
  //                                                     and  _Item.Plant = $projection.Plant
  //                                                     and  _Item.PurchaseOrder = $projection.PurchaseOrder
  //                                                     and  _Item.PurchaseOrderItem = $projection.PurchaseOrderItem
  //                                                     and _Item.GoodsMovementRefDocType = 'B'
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      Material,
      MaterialName,
      Plant,
      Batch,
      NCMCode,
      PurchaseOrder,
      PurchaseOrderItem,
      BR_NFExternalItemNumber,

      _Item.mblnr as MaterialDocument,
      _Item.zeile as MaterialDocumentItem,
      _Item.sgtxt as MaterialDocumentItemText

      //      _Item
}
