@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_ARMZ_NFE
  as select from ZI_MM_EXPED_ARMAZENAGEM
{
  key DocNFENUM

}
where
  DocNFENUM is not initial
group by
  DocNFENUM
