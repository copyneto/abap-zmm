@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Romaneio ZTMM_ROMANEIO_IT e IN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ROMANEIO_COMPL
  as select from ztmm_romaneio_in as In
    inner join   ztmm_romaneio_it as It on In.doc_uuid_h = It.doc_uuid_h

  association [0..1] to ZI_MM_ORD_DESCA_CONF_PEDIDO as _ConfPedido on  _ConfPedido.vbeln = It.vbeln
                                                                   and _ConfPedido.vbelp = It.posnr
{
  key In.doc_uuid_h                              as DocUuidH,
  key In.sequence                                as Romaneio,
      It.vbeln                                   as Vbeln,
      It.posnr                                   as Posnr,
      In.ebeln                                   as Ebeln,
      In.ebelp                                   as Ebelp,
      In.nfnum                                   as Nfnum,
      In.placa                                   as Placa,
      In.motorista                               as Motorista,
      In.dt_entrada                              as DtEntrada,
      In.dt_chegada                              as DtChegada,
      In.status_ordem                            as StatusOrdem,
      In.status_armazenado                       as StatusArmazenado,
      In.status_compensado                       as StatusCompensado,
      In.destination                             as Destination,
      cast(In.peso_dif_ori  as abap.dec(13,3))   as PesoDifOri,
      cast(In.qtde_dif_ori  as abap.dec(13,3))   as QtdeDifOri,
      cast(In.calc_dif_peso as abap.dec(13,3))   as CalcDifPeso,
      cast(In.calc_dif_qtde as abap.dec(13,3))   as CalcDifQtde,
      It.charg                                   as Charg,
      @Semantics.quantity.unitOfMeasure:'Meins'
      _ConfPedido.ormng                          as Quantidade,
      cast(It.qtd_kg_original as abap.dec(13,3)) as QtdKgOriginal,
      It.lgort                                   as Lgort,
      _ConfPedido.Werks                          as Werks,
      _ConfPedido.matnr                          as Matnr,
      _ConfPedido.meins                          as Meins


}
