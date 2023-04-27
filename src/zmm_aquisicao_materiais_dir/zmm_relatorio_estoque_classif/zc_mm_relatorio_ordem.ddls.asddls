@AbapCatalog.sqlViewName: 'ZVMM_CREPORDER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados Ordem Produção - Virtual Elements'
define view ZC_MM_RELATORIO_ORDEM
  as select from ZI_MM_RELATORIO_ORDEM
{
  key Material,
  key Plant,
  key StorageLocation,
  key Batch,
//      Ordem,      
      /*Status,
      StatusTxt,
      StatusCrit,*/
      cast( '' as xfeld )                              as BatchManagement,
      Opt                                              as Options,
      Documentno,
      cast( TotalOrdem as bstmg )                      as TotalOrdem,
      cast('' as meins )                               as Meins,

      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '' as abap.sstring(50) )                   as Localizacao,

      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg ) as Quantidade,

      @EndUserText.label: 'Quantidade (BAG)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 ) as QtdBag,

      @EndUserText.label: 'Qtde Peneira 19'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg ) as QtdPeneira19,

      @EndUserText.label: 'Peneira 19%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira19,

      @EndUserText.label: 'Qtde Peneira 18'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira18,

      @EndUserText.label: 'Peneira 18%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira18,

      @EndUserText.label: 'Qtde Peneira 17'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira17,

      @EndUserText.label: 'Peneira 17%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira17,

      @EndUserText.label: 'Qtde Peneira 16'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira16,

      @EndUserText.label: 'Peneira 16%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira16,

      @EndUserText.label: 'Qtde Peneira 15'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira15,

      @EndUserText.label: 'Peneira 19%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira15,

      @EndUserText.label: 'Qtde Peneira 14'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira14,

      @EndUserText.label: 'Peneira 14%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira14,

      @EndUserText.label: 'Qtde Peneira 13'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira13,

      @EndUserText.label: 'Peneira 13%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira13,

      @EndUserText.label: 'Qtde Peneira 12'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira12,

      @EndUserText.label: 'Peneira 12%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira12,

      @EndUserText.label: 'Qtde Peneira 11'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira11,

      @EndUserText.label: 'Peneira 11%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira11,

      @EndUserText.label: 'Qtde Peneira 10'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdPeneira10,

      @EndUserText.label: 'Peneira 10%'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Peneira10,

      @EndUserText.label: 'Qtde Defeitos'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeDefeitos,

      @EndUserText.label: 'Defeitos'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Defeitos,

      @EndUserText.label: 'Impurezas'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeImpurezas,

      @EndUserText.label: 'Impurezas (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Impurezas,

      @EndUserText.label: 'Fundo'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeFundo,

      @EndUserText.label: 'Fundo (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Fundo,

      @EndUserText.label: 'Qtde Verde'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeVerde,

      @EndUserText.label: 'Verde (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Verde,

      @EndUserText.label: 'Qtde Preto Ardido'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdePretoArdido,

      @EndUserText.label: 'Preto Ardido (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as PretoArdido,

      @EndUserText.label: 'Qtde Catação'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeCatacao,

      @EndUserText.label: 'Grau Catação (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Catacao,

      @EndUserText.label: 'Qtde Umidade'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeUmidade,

      @EndUserText.label: 'Umidade (%)'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Umidade,

      @EndUserText.label: 'Qtde MK10'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeMk10,

      @EndUserText.label: 'MK10'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as MK10,

      @EndUserText.label: 'Qtde Brocados'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeBrocados,

      @EndUserText.label: 'Brocados'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Brocados,

      @EndUserText.label: 'Qtde Paladar'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdePaladar,

      @EndUserText.label: 'Paladar'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Paladar,

      @EndUserText.label: 'Qtde Safra'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as bstmg )  as QtdeSafra,

      @EndUserText.label: 'Safra'
      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIF'
      cast( '0' as prz21 )  as Safra

}
where TotalOrdem > 0
