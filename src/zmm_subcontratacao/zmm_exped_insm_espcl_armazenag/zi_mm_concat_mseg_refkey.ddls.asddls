@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Concatena MSEG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CONCAT_MSEG_REFKEY
  as select from nsdm_e_mseg
{
  key mblnr,
  key mjahr,
  key zeile,
      concat( mblnr, mjahr) as REFKEY
}
