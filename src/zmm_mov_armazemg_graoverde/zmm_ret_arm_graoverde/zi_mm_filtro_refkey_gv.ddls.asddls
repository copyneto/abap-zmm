@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Filtro para campos REFKEY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_REFKEY_GV
  as select from j_1bnflin
{
  key docnum                                          as Docnum,
      //    key itmnum as Itmnum,
      substring (refkey,1,10)                         as MBLNR,
      cast( substring (refkey,11,4) as abap.numc(4) ) as MJAHR

}
group by
  docnum,
  refkey
