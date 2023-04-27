@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de NFE - Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_EXPEDIN_NFE
  as select from ZI_MM_EXPEDINSUM_ESPC_SUBCONTR
{
  key Nfenum

}
group by
  Nfenum
