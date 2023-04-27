@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'BUSCA Retorno item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_PURS 
  as select from I_BR_NFItem
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      PurchaseOrder,
      PurchaseOrderItem,
      Material,
      BR_NFSourceDocumentType,
      BR_NFSourceDocumentNumber,
      left (BR_NFSourceDocumentNumber,10) as DocumentNumber
      
} 
//where BR_NotaFiscal = '8486'
