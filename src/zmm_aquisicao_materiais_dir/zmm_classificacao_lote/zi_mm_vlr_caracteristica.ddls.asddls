@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valor da característica para o material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_VLR_CARACTERISTICA
  as select from ztmm_valor_carac as _Carac
  association        to parent ZI_MM_CTRL_CLASSIF as _Classif       on  _Classif.Pedido     = $projection.Pedido
                                                                    and _Classif.ItemPedido = $projection.ItemPedido
  association [0..1] to I_CreatedByUser           as _CreatedByUser on  $projection.CreatedBy = _CreatedByUser.UserName

  association [0..1] to I_ChangedByUser           as _ChangedByUser on  $projection.LastChangedBy = _ChangedByUser.UserName

{
  key _Carac.ebeln                 as Pedido,
  key _Carac.ebelp                 as ItemPedido,
  key _Carac.charg                 as Lote,
      _Carac.categoria_documento   as CagetoriaDocumento,
      _Carac.vbeln                 as Remessa,
      _Carac.posnr                 as ItemRemessa,
      //      _Classif.Material        as Material,
      //      _Classif.Status          as Status,
      //      _Classif.StatusClassific as StatusClassific,
      //      _Classif.Centro          as Centro,
      _Carac.peneira_10            as Peneira10,
      _Carac.peneira_11            as Peneira11,
      _Carac.peneira_12            as Peneira12,
      _Carac.peneira_13            as Peneira13,
      _Carac.peneira_14            as Peneira14,
      _Carac.peneira_15            as Peneira15,
      _Carac.peneira_16            as Peneira16,
      _Carac.peneira_17            as Peneira17,
      _Carac.peneira_18            as Peneira18,
      _Carac.peneira_19            as Peneira19,
      _Carac.mk10                  as Mk10,
      _Carac.fundo                 as Fundo,
      _Carac.catacao               as Catacao,
      _Carac.umidade               as Umidade,
      _Carac.defeito               as Defeito,
      _Carac.impureza              as Impureza,
      _Carac.verde                 as Verde,
      _Carac.preto_ardido          as PretoArdido,
      _Carac.brocado               as Brocado,
      _Carac.densidade             as Densidade,
      _Carac.paladar               as Paladar,
      _Carac.safra                 as Safra,
      _Carac.observacao            as Observacao,
      @Semantics.user.createdBy: true
      _Carac.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Carac.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Carac.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Carac.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Carac.local_last_changed_at as LocalLastChangedAt,

      cast( '%' as meins )         as Porcentagem,

      _Classif,
      _CreatedByUser,
      _ChangedByUser
}
