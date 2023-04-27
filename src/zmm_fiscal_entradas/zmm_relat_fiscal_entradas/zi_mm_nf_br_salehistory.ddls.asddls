@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_NF_BR_SALEHISTORY
  as select from I_BR_SaleHistory
{
  key SubsequentDocument        as SubseqDoc,
  key SubsequentDocumentItem    as SubseqDocItem,
      PrecedingDocumentCategory as Categoria,
      PrecedingDocument         as Doc,
      PrecedingDocumentItem     as DocItem
}
