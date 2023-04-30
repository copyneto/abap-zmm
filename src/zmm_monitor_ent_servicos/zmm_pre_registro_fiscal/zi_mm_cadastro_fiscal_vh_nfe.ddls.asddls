@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CADASTRO_FISCAL_VH_NFE
  as select from ZI_MM_CADASTRO_FISCAL_CABEC
{
      @Search.defaultSearchElement: true
  key NrNf as NrNf
}
where
  NrNf is not initial
group by
  NrNf
