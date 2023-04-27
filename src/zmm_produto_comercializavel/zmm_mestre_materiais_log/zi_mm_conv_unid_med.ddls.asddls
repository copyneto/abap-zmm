@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Converte unidade de medida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CONV_UNID_MED
  as select from t006a
{
//      @UI.hidden: true
  key spras as Language,
//      @Semantics.unitOfMeasure: true
      @ObjectModel.text.element: ['UnitOfMeasureCommercialName']
  key msehi as UnitOfMeasure,
      @Semantics.text: true
      mseh3 as UnitOfMeasureCommercialName
}
