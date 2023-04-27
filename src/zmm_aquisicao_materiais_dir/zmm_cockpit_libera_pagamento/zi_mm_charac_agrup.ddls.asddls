@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes - Agrupado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARAC_AGRUP
  as select from ZI_MM_CHARAC_GET as Internal
{
  key Internal.Pedido,
  key Internal.Material,
      //  key Internal.Ordem,
      sum(Internal.YGV_QTD_KG)                    as YGV_QTD_KG,
      sum(Internal.YGV_QTD_SACAS)                 as YGV_QTD_SACAS,
      sum(Internal.YGV_QTD_BAG)                   as YGV_QTD_BAG,
      avg(Internal.YGV_P10 as abap.fltp)          as YGV_P10,
      avg(Internal.YGV_P11 as abap.fltp)          as YGV_P11,
      avg(Internal.YGV_P12 as abap.fltp)          as YGV_P12,
      avg(Internal.YGV_P13 as abap.fltp)          as YGV_P13,
      avg(Internal.YGV_P14 as abap.fltp)          as YGV_P14,
      avg(Internal.YGV_P15 as abap.fltp)          as YGV_P15,
      avg(Internal.YGV_P16 as abap.fltp)          as YGV_P16,
      avg(Internal.YGV_P17 as abap.fltp)          as YGV_P17,
      avg(Internal.YGV_P18 as abap.fltp)          as YGV_P18,
      avg(Internal.YGV_P19 as abap.fltp)          as YGV_P19,
      sum(Internal.YGV_DEFEITO)                   as YGV_DEFEITO,
      avg(Internal.YGV_IMPUREZAS as abap.fltp)    as YGV_IMPUREZAS,
      avg(Internal.YGV_MK10 as abap.fltp)         as YGV_MK10,
      avg(Internal.YGV_FUNDO as abap.fltp)        as YGV_FUNDO,
      avg(Internal.YGV_VERDE as abap.fltp)        as YGV_VERDE,
      avg(Internal.YGV_PRETO_ARDIDO as abap.fltp) as YGV_PRETO_ARDIDO,
      avg(Internal.YGV_CATACAO as abap.fltp)      as YGV_CATACAO,
      avg(Internal.YGV_UMIDADE as abap.fltp)      as YGV_UMIDADE,
      avg(Internal.YGV_BROCADOS as abap.fltp)     as YGV_BROCADOS,
      ''                                          as MK10
}
group by
  Internal.Pedido,
  Internal.Material
//  Internal.Ordem,
