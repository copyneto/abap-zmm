@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de REFKEY Active'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_FILTRO_LIN_ACTIVE
  as select from j_1bnflin
{
  key max(docnum) as Docnum,
  key max(itmnum) as Itmnum,
      refkey

}
group by
  refkey
