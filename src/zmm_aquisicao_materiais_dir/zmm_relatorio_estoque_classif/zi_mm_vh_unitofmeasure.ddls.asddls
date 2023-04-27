@AbapCatalog.sqlViewName: 'ZVMM_VH_UOM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Unidade de Medida - Grão Verde'

@ObjectModel.resultSet.sizeCategory: #XS

define view ZI_MM_VH_UNITOFMEASURE
  as select from t006a
{
      @UI.hidden: true
  key spras as Language,
      @Semantics.unitOfMeasure: true
      @ObjectModel.text.element: ['UnitOfMeasureCommercialName']
  key msehi as UnitOfMeasure,
      @Semantics.text: true
      mseh3 as UnitOfMeasureCommercialName
}
where
       spras = $session.system_language
  and(
       msehi = 'KG'
    or msehi = 'BAG'
  )
