@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de CNPJ por Fornec'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_NFE_LIFNR
  as select from lfa1
{
  key max(lifnr) as Lifnr,
      stcd1
}
where
  stcd1 is not initial
group by
  stcd1
