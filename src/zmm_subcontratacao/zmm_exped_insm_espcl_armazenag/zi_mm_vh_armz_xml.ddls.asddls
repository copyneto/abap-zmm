@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help XML'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_ARMZ_XML
  as select from ZI_MM_EXPED_ARMAZENAGEM
{
  @EndUserText.label: 'Chave de Acesso'
  key XML_EntIns 
}
where
  XML_EntIns is not initial
group by
  XML_EntIns
