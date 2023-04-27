@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca NFITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_NFITEM 
  as select from I_BR_NFItem
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      substring(BR_NFSourceDocumentNumber, 1, 10) as BR_NFSourceDocumentNumber,
      BR_NFSourceDocumentType,
      Material,
      NetPriceAmount,
      BR_CFOPCode,
      MaterialName,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      QuantityInBaseUnit,
      cast( 'BRL' as abap.cuky( 5 ) )               as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      NetValueAmount,
      Batch,
      NCMCode,
      BaseUnit                                      as BaseUnit,
      BR_TaxCode,
      PurchaseOrder,
      MaterialGroup    ,  
      BR_NFSourceDocumentItem  ,
      right(BR_NFSourceDocumentNumber, 4)   as BR_NFSourceDocumentNumberYear     
}
