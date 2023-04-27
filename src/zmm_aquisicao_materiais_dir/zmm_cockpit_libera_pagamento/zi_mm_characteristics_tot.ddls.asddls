@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes Totais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARACTERISTICS_TOT
  as select from ztmm_romaneio_in      as Romaneio
    inner join   C_PurchaseOrderItemTP as _Purch     on  _Purch.PurchaseOrder     = Romaneio.ebeln
                                                     and _Purch.PurchaseOrderItem = Romaneio.ebelp
    inner join   ZC_MM_BR_NF_DOCUMENT  as _NFDoc     on  _NFDoc.PurchaseOrder     = Romaneio.ebeln
                                                     and _NFDoc.PurchaseOrderItem = Romaneio.ebelp

    inner join   ZI_MM_CHARAC_AGRUP    as _CharReceb on  _CharReceb.Pedido   = Romaneio.ebeln
                                                     and _CharReceb.Material = _Purch.Material

  association [0..1] to ZI_MM_CHARACTERISTICS_PED as _CharPed on  _CharPed.PurchaseOrder     = $projection.PurchaseOrder
                                                              and _CharPed.PurchaseOrderItem = $projection.PurchaseOrderItem
                                                              and _CharPed.BR_NotaFiscal     = $projection.BR_NotaFiscal
{
  key Romaneio.ebeln                               as PurchaseOrder,
  key Romaneio.ebelp                               as PurchaseOrderItem,
  key _NFDoc.BR_NotaFiscal,
  key '*'                                          as Charg,
      _CharReceb.Material,
      //      Romaneio.sequence                            as Ordem,
      //      Romaneio.nfnum,
      _CharPed.SalesDocument                       as SalesDocument,
      _CharPed.SalesDocumentItem                   as SalesDocumentItem,

      cast( _CharReceb.YGV_QTD_KG as abap.fltp )   as QuantidadeKg,
      case when _CharReceb.YGV_QTD_KG = _CharPed.QuantidadeKg
        then 0 else 1 end                          as QuantidadeKgCriticality,

      cast(_CharReceb.YGV_QTD_SACAS as abap.fltp ) as QuantidadeSacas,
      case when _CharReceb.YGV_QTD_SACAS = _CharPed.QuantidadeSacas
        then 0 else 1 end                          as QuantidadeSacasCriticality,

      cast( _CharReceb.YGV_QTD_BAG as abap.fltp )  as QuantidadeBag,
      case when _CharReceb.YGV_QTD_BAG = _CharPed.QuantidadeBag
        then 0 else 1 end                          as QuantidadeBagCriticality,

      _CharReceb.YGV_P10                           as Peneira10,
      case when _CharReceb.YGV_P10  > _CharPed.Peneira10
             or _CharReceb.YGV_P10  < _CharPed.Peneira10
           then 1 else 0 end                       as Peneira10Criticality,

      _CharReceb.YGV_P11                           as Peneira11,
      case when _CharReceb.YGV_P11 > _CharPed.Peneira11
             or _CharReceb.YGV_P11 < _CharPed.Peneira11
           then 1 else 0 end                       as Peneira11Criticality,

      _CharReceb.YGV_P12                           as Peneira12,
      case when _CharReceb.YGV_P12 > _CharPed.Peneira12
             or _CharReceb.YGV_P12 < _CharPed.Peneira12
           then 1 else 0 end                       as Peneira12Criticality,

      _CharReceb.YGV_P13                           as Peneira13,
      case when _CharReceb.YGV_P13 > _CharPed.Peneira13
             or _CharReceb.YGV_P13 < _CharPed.Peneira13
           then 1 else 0 end                       as Peneira13Criticality,

      _CharReceb.YGV_P14                           as Peneira14,
      case when _CharReceb.YGV_P14 > _CharPed.Peneira14
             or _CharReceb.YGV_P14 < _CharPed.Peneira14
           then 1 else 0 end                       as Peneira14Criticality,

      _CharReceb.YGV_P15                           as Peneira15,
      case when _CharReceb.YGV_P15 > _CharPed.Peneira15
             or _CharReceb.YGV_P15 < _CharPed.Peneira15
           then 1 else 0 end                       as Peneira15Criticality,

      _CharReceb.YGV_P16                           as Peneira16,
      case when _CharReceb.YGV_P16 > _CharPed.Peneira16
             or _CharReceb.YGV_P16 < _CharPed.Peneira16
           then 1 else 0 end                       as Peneira16Criticality,

      _CharReceb.YGV_P17                           as Peneira17,
      case when _CharReceb.YGV_P17 > _CharPed.Peneira17
             or _CharReceb.YGV_P17 < _CharPed.Peneira17
           then 1 else 0 end                       as Peneira17Criticality,

      _CharReceb.YGV_P18                           as Peneira18,
      case when _CharReceb.YGV_P18 > _CharPed.Peneira18
             or _CharReceb.YGV_P18 < _CharPed.Peneira18
           then 1 else 0 end                       as Peneira18Criticality,

      _CharReceb.YGV_P19                           as Peneira19,
      case when _CharReceb.YGV_P19 > _CharPed.Peneira19
             or _CharReceb.YGV_P19 < _CharPed.Peneira19
           then 1 else 0 end                       as Peneira19Criticality,

      _CharReceb.YGV_MK10                          as Mk10,
      case when _CharReceb.YGV_MK10 > _CharPed.Mk10
             or _CharReceb.YGV_MK10 < _CharPed.Mk10
           then 1 else 0 end                       as Mk10Criticality,

      _CharReceb.YGV_FUNDO                         as Fundo,
      case when _CharReceb.YGV_FUNDO > _CharPed.Fundo
             or _CharReceb.YGV_FUNDO < _CharPed.Fundo
           then 1 else 0 end                       as FundoCriticality,

      _CharReceb.YGV_CATACAO                       as Catacao,
      case when _CharReceb.YGV_CATACAO > _CharPed.Catacao
             or _CharReceb.YGV_CATACAO < _CharPed.Catacao
           then 1 else 0 end                       as CatacaoCriticality,

      _CharReceb.YGV_UMIDADE                       as Umidade,
      case when _CharReceb.YGV_UMIDADE > _CharPed.Umidade
             or _CharReceb.YGV_UMIDADE < _CharPed.Umidade
           then 1 else 0 end                       as UmidadeCriticality,

      _CharReceb.YGV_DEFEITO                       as Defeito,
      case when _CharReceb.YGV_DEFEITO > _CharPed.Defeito
             or _CharReceb.YGV_DEFEITO < _CharPed.Defeito
           then 1 else 0 end                       as DefeitoCriticality,

      _CharReceb.YGV_IMPUREZAS                     as Impureza,
      case when _CharReceb.YGV_IMPUREZAS > _CharPed.Impureza
             or _CharReceb.YGV_IMPUREZAS < _CharPed.Impureza
           then 1 else 0 end                       as ImpurezaCriticality,

      _CharReceb.YGV_VERDE                         as Verde,
      case when _CharReceb.YGV_VERDE > _CharPed.Verde
             or _CharReceb.YGV_VERDE < _CharPed.Verde
           then 1 else 0 end                       as VerdeCriticality,

      _CharReceb.YGV_PRETO_ARDIDO                  as PretoArdido,
      case when _CharReceb.YGV_PRETO_ARDIDO > _CharPed.PretoArdido
             or _CharReceb.YGV_PRETO_ARDIDO < _CharPed.PretoArdido
           then 1 else 0 end                       as PretoArdidoCriticality,

      _CharReceb.YGV_BROCADOS                      as Brocado,
      case when _CharReceb.YGV_BROCADOS > _CharPed.Brocado
             or _CharReceb.YGV_BROCADOS < _CharPed.Brocado
           then 1 else 0 end                       as BrocadoCriticality,

      cast(0 as abap.fltp)                         as Densidade,
      0                                            as DensidadeCriticality
}
