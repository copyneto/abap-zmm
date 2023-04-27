@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Ordem de Descarga Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ADM_ORDEM_DESCARGA_ITEM
  as select from ztmm_romaneio_it as _RomaneioItem
  association        to parent ZI_MM_ADM_ORDEM_DESCARGA as _Ordem      on  $projection.DocUuidH = _Ordem.DocUuidH
  association [0..1] to ZI_MM_ORD_DESCA_CONF_PEDIDO     as _ConfPedido on  _ConfPedido.vbeln = _RomaneioItem.vbeln
                                                                       and _ConfPedido.vbelp = _RomaneioItem.posnr

{
  key _RomaneioItem.doc_uuid_h            as DocUuidH,
      _RomaneioItem.vbeln                 as Recebimento,
      //key _ConfPedido.vbeln                   as Recebimento,
      _RomaneioItem.ebelp                 as ItemPedido,
      _RomaneioItem.posnr                 as ItemRecebimento,
      _RomaneioItem.nfnum                 as NotaFiscal,
      _ConfPedido.xblnr                   as NotaFiscalPed,
      @Semantics.quantity.unitOfMeasure:'Unidade'
      _RomaneioItem.qtd_kg_original       as QtdeKgOrig,
      _ConfPedido.matnr                   as Material,
      _ConfPedido.maktx                   as DescMaterial,
      _RomaneioItem.charg                 as Lote,
      @EndUserText.label: 'Depósito de Descarga'
      _RomaneioItem.lgort                 as Lgort,
      _ConfPedido.meins                   as Unidade,
      @Semantics.quantity.unitOfMeasure:'Unidade'
      _ConfPedido.ormng                   as Quantidade,
      @Semantics.systemDateTime.createdAt: true
      _RomaneioItem.created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      _RomaneioItem.created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      _RomaneioItem.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _RomaneioItem.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _RomaneioItem.local_last_changed_at as LocalLastChangedAt,
      _Ordem
}
