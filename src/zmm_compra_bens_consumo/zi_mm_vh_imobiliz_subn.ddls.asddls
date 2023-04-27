@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Imobilizado Subnumero'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_IMOBILIZ_SUBN
  as select from ZI_MM_IMOBILIZADO
{
  key Anln2,
      @EndUserText.label: 'Inventário'
      max(Invnr) as Invnr,
      @EndUserText.label: 'Centro'
      max(Werks) as Werks,
      @EndUserText.label: 'Depósito'
      max(Lgort) as Lgort
}
where
      Anln2 is not initial
  and Anln2 <> '0'
group by
  Anln2
