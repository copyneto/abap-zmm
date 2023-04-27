@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Faturada (CTE) - Menor CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_CTE_CFOP_MIN
  as select from /xnfe/inctenfcl
{
  key guid           as Guid,
      min( counter ) as Counter
}
group by
  guid
