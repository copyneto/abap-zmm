@AbapCatalog.sqlViewName: 'ZVIMMCLACARAC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Compra, Lotes e Romaneio'
define view ZI_MM_CLA_CARAC
  as select from ztmm_control_cla as _Cla
    inner join   ztmm_valor_carac as _Carac on  _Carac.ebeln = _Cla.ebeln
                                            and _Carac.ebelp = _Cla.ebelp
{
  key _Carac.ebeln                      as Ebeln,
  key _Carac.ebelp                      as Ebelp,
  key _Carac.charg                      as Charg,
      vbeln                             as Vbeln,
      posnr                             as Posnr,
      cast( peneira_10   as abap.fltp ) as Peneira10,
      cast( peneira_11   as abap.fltp ) as Peneira11,
      cast( peneira_12   as abap.fltp ) as Peneira12,
      cast( peneira_13   as abap.fltp ) as Peneira13,
      cast( peneira_14   as abap.fltp ) as Peneira14,
      cast( peneira_15   as abap.fltp ) as Peneira15,
      cast( peneira_16   as abap.fltp ) as Peneira16,
      cast( peneira_17   as abap.fltp ) as Peneira17,
      cast( peneira_18   as abap.fltp ) as Peneira18,
      cast( peneira_19   as abap.fltp ) as Peneira19,
      cast( mk10         as abap.fltp ) as Mk10,
      cast( fundo        as abap.fltp ) as Fundo,
      cast( catacao      as abap.fltp ) as Catacao,
      cast( umidade      as abap.fltp ) as Umidade,
      cast( defeito      as abap.fltp ) as Defeito,
      cast( impureza     as abap.fltp ) as Impureza,
      cast( verde        as abap.fltp ) as Verde,
      cast( preto_ardido as abap.fltp ) as PretoArdido,
      cast( brocado      as abap.fltp ) as Brocado,
      cast( densidade    as abap.fltp ) as Densidade,
      _Carac.observacao                 as Observacao

}
