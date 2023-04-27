@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Br Sale History'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENCAO_FILT_BRHIST
  as select from I_BR_SaleHistory
{
  key SubsequentDocument        as SubsequentDocument,
  key SubsequentDocumentItem    as SubsequentDocumentItem,
//  key PrecedingDocumentCategory as PrecedingDocumentCategory,
      max(PrecedingDocument)    as PrecedingDocument
}
where
       SubsequentDocument        is not initial
  and(
       PrecedingDocumentCategory = 'J' -- Fornecimento
    or PrecedingDocumentCategory = 'T' -- Recebimento de devoluções para ordem
  ) 


group by
  SubsequentDocument,
  SubsequentDocumentItem 
//  PrecedingDocumentCategory
