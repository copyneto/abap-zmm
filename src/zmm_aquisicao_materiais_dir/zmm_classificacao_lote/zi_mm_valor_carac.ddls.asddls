@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor das Características do material de um item de pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VALOR_CARAC
  as select from ztmm_valor_carac
{
  key ebeln             as Ebeln,
  key ebelp             as Ebelp,

      sum( peneira_10 ) as Peneira10,
      sum( peneira_11 ) as Peneira11,
      sum( peneira_12 ) as Peneira12,
      sum( peneira_13 ) as Peneira13,
      sum( peneira_14 ) as Peneira14,
      sum( peneira_15 ) as Peneira15,
      sum( peneira_16 ) as Peneira16,
      sum( peneira_17 ) as Peneira17,
      sum( peneira_18 ) as Peneira18,
      sum( peneira_19 ) as Peneira19,
      sum( catacao )    as CatacaoCompra,
      sum( catacao )    as CatacaoChegada,
     
      count( * )        as Registros

}
group by
  ebeln,
  ebelp
