@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento de Material tipo ZDF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TRANSF_EKBE_ZDF 
as select from ekbe   
{
    key ebeln,
    key ebelp,
    key zekkn,
    key vgabe,
    key gjahr,
    key belnr,
    key buzei,
    bwart,
    xblnr
}
