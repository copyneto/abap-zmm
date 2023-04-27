@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Valida se tem estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VALIDA_ESTORNO
  as select from ZI_MM_FORNECIMENTO2
{
  key    _MaterialDocumentRecord2.MaterialDocumentYear     as MaterialDocumentYear,
//  key    _MaterialDocumentRecord2.MaterialDocument         as MaterialDocument,
  key    _MaterialDocumentRecord2.ReversedMaterialDocument as MaterialDocument,
  key    _MaterialDocumentRecord2.MaterialDocumentItem     as MaterialDocumentItem

}
where
      _MaterialDocumentRecord2.MaterialDocumentYear     <> '0000'
//  and _MaterialDocumentRecord2.MaterialDocument         <> ''
  and _MaterialDocumentRecord2.ReversedMaterialDocument <> ''
  and _MaterialDocumentRecord2.MaterialDocumentItem     <> '0000'
