@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de CNPJ por Cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_NFE_KUNNR
  as select from kna1
{
  key max(kunnr) as Kunnr,
      stcd1
}
where
  stcd1 is not initial
group by
  stcd1
