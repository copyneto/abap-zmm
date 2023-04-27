@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection Adm Ordem de Descarga Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true

define view entity ZC_MM_ADM_ORDEM_DESCARGA_ITEM
  as projection on ZI_MM_ADM_ORDEM_DESCARGA_ITEM as OrdemItem
{
  key DocUuidH,
      Recebimento,
      ItemPedido,
      ItemRecebimento,
      NotaFiscal,
      NotaFiscalPed,
      QtdeKgOrig,
      Material,
      DescMaterial,
      Lote,
      Unidade,
//      Quantidade,
      Lgort,
      CreatedAt,
      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Ordem : redirected to parent ZC_MM_ADM_ORDEM_DESCARGA


}
