@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes Recebimento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARACTERISTICS_RECEB
  as select from ztmm_romaneio_in      as Romaneio
    inner join   C_PurchaseOrderItemTP as _Purch     on  _Purch.PurchaseOrder     = Romaneio.ebeln
                                                     and _Purch.PurchaseOrderItem = Romaneio.ebelp
                                                     
    inner join   ZC_MM_BR_NF_DOCUMENT  as _NFDoc     on  _NFDoc.PurchaseOrder     = Romaneio.ebeln
                                                     and _NFDoc.PurchaseOrderItem = Romaneio.ebelp

    //inner join   ZI_MM_CHARAC_GET      as _CharReceb on  _CharReceb.Pedido   = Romaneio.ebeln
                                                     //and _CharReceb.Material = _Purch.Material
    inner join   ztmm_romaneio_lo          as _Lote      on Romaneio.doc_uuid_h = _Lote.doc_uuid_h 
    
    inner join   ZI_MM_CHARAC_GET_NEW      as _CharReceb on  _CharReceb.Batch   = _Lote.charg
                                                         and _CharReceb.Material = _Purch.Material                                                     
{
  key Romaneio.ebeln                               as PurchaseOrder,
  key Romaneio.ebelp                               as PurchaseOrderItem,
  key _NFDoc.BR_NotaFiscal,
  key _CharReceb.Batch                             as Charg,
      _CharReceb.Material,
      //      Romaneio.sequence                            as Ordem,
      //      Romaneio.nfnum,
      cast('' as vbeln)                            as SalesDocument,
      cast('' as posnr)                            as SalesDocumentItem,

      cast( _CharReceb.YGV_QTD_KG as abap.fltp )   as QuantidadeKg,
      0                                            as QuantidadeKgCriticality,

      cast(_CharReceb.YGV_QTD_SACAS as abap.fltp ) as QuantidadeSacas,
      0                                            as QuantidadeSacasCriticality,

      cast( _CharReceb.YGV_QTD_BAG as abap.fltp )  as QuantidadeBag,
      0                                            as QuantidadeBagCriticality,

      _CharReceb.YGV_P10                           as Peneira10,
      case when _CharReceb.YGV_P10 > 0
           then 1 else 0 end                       as Peneira10Criticality,

      _CharReceb.YGV_P11                           as Peneira11,
      case when _CharReceb.YGV_P11 > 0
           then 1 else 0 end                       as Peneira11Criticality,

      _CharReceb.YGV_P12                           as Peneira12,
      case when _CharReceb.YGV_P12 > 0
           then 1 else 0 end                       as Peneira12Criticality,

      _CharReceb.YGV_P13                           as Peneira13,
      case when _CharReceb.YGV_P13 > 0
           then 1 else 0 end                       as Peneira13Criticality,

      _CharReceb.YGV_P14                           as Peneira14,
      case when _CharReceb.YGV_P14 > 0
           then 1 else 0 end                       as Peneira14Criticality,

      _CharReceb.YGV_P15                           as Peneira15,
      case when _CharReceb.YGV_P15 > 0
           then 1 else 0 end                       as Peneira15Criticality,

      _CharReceb.YGV_P16                           as Peneira16,
      case when _CharReceb.YGV_P16 > 0
           then 1 else 0 end                       as Peneira16Criticality,

      _CharReceb.YGV_P17                           as Peneira17,
      case when _CharReceb.YGV_P17 > 0
           then 1 else 0 end                       as Peneira17Criticality,

      _CharReceb.YGV_P18                           as Peneira18,
      case when _CharReceb.YGV_P18 > 0
           then 1 else 0 end                       as Peneira18Criticality,

      _CharReceb.YGV_P19                           as Peneira19,
      case when _CharReceb.YGV_P19 > 0
           then 1 else 0 end                       as Peneira19Criticality,

      _CharReceb.YGV_MK10                          as Mk10,
      case when _CharReceb.YGV_MK10 > 0
           then 1 else 0 end                       as Mk10Criticality,

      _CharReceb.YGV_FUNDO                         as Fundo,
      case when _CharReceb.YGV_FUNDO > 0
           then 1 else 0 end                       as FundoCriticality,

      _CharReceb.YGV_CATACAO                       as Catacao,
      case when _CharReceb.YGV_CATACAO > 0
           then 1 else 0 end                       as CatacaoCriticality,

      _CharReceb.YGV_UMIDADE                       as Umidade,
      case when _CharReceb.YGV_UMIDADE > 0
           then 1 else 0 end                       as UmidadeCriticality,

      _CharReceb.YGV_DEFEITO                       as Defeito,
      case when _CharReceb.YGV_DEFEITO > 0
           then 1 else 0 end                       as DefeitoCriticality,

      _CharReceb.YGV_IMPUREZAS                     as Impureza,
      case when _CharReceb.YGV_IMPUREZAS > 0
           then 1 else 0 end                       as ImpurezaCriticality,

      _CharReceb.YGV_VERDE                         as Verde,
      case when _CharReceb.YGV_VERDE > 0
           then 1 else 0 end                       as VerdeCriticality,

      _CharReceb.YGV_PRETO_ARDIDO                  as PretoArdido,
      case when _CharReceb.YGV_PRETO_ARDIDO > 0
           then 1 else 0 end                       as PretoArdidoCriticality,

      _CharReceb.YGV_BROCADOS                      as Brocado,
      case when _CharReceb.YGV_BROCADOS > 0
           then 1 else 0 end                       as BrocadoCriticality,

      cast(0 as abap.fltp)                         as Densidade,
      0                                            as DensidadeCriticality
}
