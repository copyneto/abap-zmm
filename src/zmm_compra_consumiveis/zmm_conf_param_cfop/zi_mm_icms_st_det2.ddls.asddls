@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ICMS_ST_DET2 
as select from 
ZI_MM_ICMS_ST_DET 
{   
    key Ncm,
    max(Valid_From) as data,
    Cest,
    Cest_Out
}
group by
Ncm,
Cest,
Cest_Out
