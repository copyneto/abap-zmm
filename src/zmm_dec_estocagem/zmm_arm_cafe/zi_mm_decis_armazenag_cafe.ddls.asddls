@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Decisão de Armazenagem do Café'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_DECIS_ARMAZENAG_CAFE
  as select from ztmm_romaneio_it as Item

    inner join   ztmm_romaneio_in as Header on Item.doc_uuid_h = Header.doc_uuid_h

  composition [0..*] of ZI_MM_DECIS_ARMAZENAG_LOTE  as _Lote

  association [0..1] to ZI_MM_ORD_DESCA_CONF_PEDIDO as _ConfPedido on  _ConfPedido.vbeln = Item.vbeln
                                                                   and _ConfPedido.vbelp = Item.posnr
  association [0..1] to t001w                       as _Centro     on  _Centro.werks = $projection.Werks

  association [0..1] to t001l                       as _Dep        on  _Dep.werks = $projection.Werks
                                                                   and _Dep.lgort = $projection.Lgort

{
  key Item.doc_uuid_h                              as DocUuidH,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_ADMDESCRG_FLT_ROMAN', element: 'Romaneio' }}]
      Header.sequence                              as Romaneio,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_DECISARM_FILTRO_RECEB', element: 'Vbeln' }}]
      Item.vbeln                                   as Vbeln,
      Item.ebelp                                   as Ebelp,
      cast(Item.qtd_kg_original as abap.dec(13,3)) as QtdKG,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
      _ConfPedido.Werks                            as Werks,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
      _ConfPedido.matnr                            as Material,
      _ConfPedido.maktx                            as DescMat,
      Item.charg                                   as Charg,
      @EndUserText.label: 'Depósito de Descarga'
      Item.lgort                                   as Lgort,
      _ConfPedido.meins                            as Unidade,
      @Semantics.quantity.unitOfMeasure:'Unidade'
      _ConfPedido.menge                            as Quantidade, 

      @Semantics.systemDateTime.createdAt: true
      Item.created_at                              as CreatedAt,
      @Semantics.user.createdBy: true
      Item.created_by                              as CreatedBy,
      @Semantics.user.lastChangedBy: true
      Item.last_changed_by                         as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Item.last_changed_at                         as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Item.local_last_changed_at                   as LocalLastChangedAt,

      _Lote,
      _Centro,
      _Dep
}
