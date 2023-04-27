@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Imobilizado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_IMOBILIZ
  as select from ZI_MM_IMOBILIZADO
{
  key Anln1,
  key Anln2,
      @EndUserText.label: 'Inventário'
      max(Invnr) as Invnr,
      @EndUserText.label: 'Centro'
      max(Werks) as Werks,
      @EndUserText.label: 'Depósito'
      max(Lgort) as Lgort
}
group by
  Anln1,
  Anln2
