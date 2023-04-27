@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Doc. Entrada Transf.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity ZI_MM_VH_ENTRADA_TRANSF
  as select from I_MaterialDocumentHeader
{
      @EndUserText.label: 'Entrada Transf.'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key concat( MaterialDocument, MaterialDocumentYear ) as EntradaTransf,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      MaterialDocument                                 as MaterialDocument,
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      MaterialDocumentYear                             as MaterialDocumentYear
}
