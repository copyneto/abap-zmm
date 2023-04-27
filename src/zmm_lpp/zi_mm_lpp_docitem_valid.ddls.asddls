@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens válidos para LPP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LPP_DOCITEM_VALID
  as select from I_BR_NFItem            as Lin
    inner join   ZI_MM_LPP_DOCNUM_VALID as Doc on Doc.br_notafiscal = Lin.BR_NotaFiscal
{
  key Lin.Material               as Matnr,
  key Lin.ValuationArea          as Bwkey,
  key Lin.ValuationType          as Bwtar,
  key Lin.BR_NotaFiscal          as BR_NotaFiscal,
  key max(Lin.BR_NotaFiscalItem) as BR_NotaFiscalItem

}
group by
  Lin.Material,
  Lin.ValuationArea,
  Lin.ValuationType,
  Lin.BR_NotaFiscal
