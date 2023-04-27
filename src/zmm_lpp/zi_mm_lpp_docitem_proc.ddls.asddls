@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos/Itens válidos para LPP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LPP_DOCITEM_PROC
  as select from ZI_MM_LPP_DOCITEM_VALID as DocItem
    inner join   j_1bnflin               as Lin on  Lin.docnum = DocItem.BR_NotaFiscal
                                                and Lin.itmnum = DocItem.BR_NotaFiscalItem
{
  key Lin.matnr                 as Matnr,
  key Lin.bwkey                 as Bwkey,
  key Lin.bwtar                 as Bwtar,
  key DocItem.BR_NotaFiscal     as BR_NotaFiscal,
  key DocItem.BR_NotaFiscalItem as BR_NotaFiscalItem,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      Lin.menge                 as Menge,
      Lin.meins                 as Meins,
      Lin.netpr                 as Netpr,
      Lin.kalsm                 as Kalsm,
      Lin.mwskz                 as Mwskz,
      Lin.refkey                as Refkey,
      Lin.refitm                as Refitm


}
