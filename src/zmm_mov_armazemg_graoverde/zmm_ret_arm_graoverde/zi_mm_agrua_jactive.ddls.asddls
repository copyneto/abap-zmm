@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para agrupar registros JACTIVE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_AGRUA_JACTIVE 
as select from j_1bnfe_active 
{
    nfyear,
    nfmonth,
    stcd1,
    model,
    nfnum9
}
group by
nfyear,
nfmonth,
stcd1,
model,
nfnum9
