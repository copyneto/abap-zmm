@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped.Insumos-Especial - Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_EXPEDINSUM_URL_ESTRN
  as select from ZI_MM_EXPEDINSUM_SUBC_PROC
{

  key        Rsnum       as Rsnum,
  key        Rspos       as Rspos,
  key        Vbeln       as Vbeln,
  key        Docnum      as Docnum,
             Status      as Status,
             case
             when Status = 'Concluído' or ( Status = 'Verificar NF-e' and Docnum is not initial ) and ( Docnum is not null or Vbeln is not null )
                  then 'Estornar'
             else '' end as Estornar

}
where
  Status <> 'Pendente'
