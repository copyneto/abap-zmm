@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDARMAZ_URL_ESTRN
  as select from ZI_MM_EXPED_ARMAZENAGEM
{
  key Docnum,
  key Itmnum,
      case
      when Status = 'Concluído' or Status = 'Verificar NF-e'
           then 'Estornar'
      else '' end as Estornar

}
