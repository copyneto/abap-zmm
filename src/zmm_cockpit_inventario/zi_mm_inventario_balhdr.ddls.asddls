@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_INVENTARIO_BALHDR 
as select from balhdr 
{
   key extnumber as Extnumber,
   max( altime ) as Altime

}
where
object = 'ITMF_BR'
and subobject = 'TMFPCO'
group by
extnumber
