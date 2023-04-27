@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'URL de Estorno Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDISUBC_URL_ESTRN
  as select from ZI_MM_EXPED_SUBCONTRAT

{

  key Rsnum         as Rsnum,
  key Rspos         as Rspos,
  key Item          as Item,
  key Vbeln         as Vbeln,
      BR_NotaFiscal as BR_NotaFiscal,
//      Vbeln         as Vbeln,
      Status        as Status,
      case
      when Status = 'Concluído' or ( Status = 'Verificar NF-e' and BR_NotaFiscal is not initial ) and ( BR_NotaFiscal is not null or Vbeln is not null )
           then 'Estornar'
      else '' end   as Estornar

}
