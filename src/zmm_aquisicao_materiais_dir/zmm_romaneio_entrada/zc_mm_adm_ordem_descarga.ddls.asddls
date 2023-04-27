@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Projection Administrar Ordem de Descarga'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_ADM_ORDEM_DESCARGA
  as projection on ZI_MM_ADM_ORDEM_DESCARGA as _Ordem
{
  key DocUuidH,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_ADMDESCRG_FLT_ROMAN', element: 'Romaneio' }}]
      Romaneio,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_ADMDESCRG_FLT_PEDID', element: 'Ebeln' }}]
      Pedido,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_DECISARM_FILTRO_RECEB', element: 'Vbeln' }}]
      Recebimento,
      //ItemRecebimento,
      ItemPedido,
      //NotaFiscal,
      //NotaFiscalPed,*/
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_ROMANEIO_VH_NF', element: 'nfenum' }}] }
      NotaFiscal,      
      Placa,
      Motorista,
      @Semantics.systemDateTime.createdAt: true
      DtEntrada,
      DtChegada,
      //      Lote,
      /*    QtdeKgOrig,

          Material,
          DescMaterial,

          Unidade,
          Quantidade,
      */
      StatusOrdem,
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_ORDEM_ROMA', element: 'Valor' }}] }
      @EndUserText.label: 'Status da Ordem'
      StatusOrdemConv,
      StatusOrdemCriti,
      @EndUserText.label: 'Armazenado'
      StatusArmazenado,
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_ARMAZENADO', element: 'Valor' }}] }
      @EndUserText.label: 'Armazenado'
      StatusArmazenadoConv,
      StatusArmazenadoCriti,
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_COMPENSADO', element: 'Valor' }}] }
      StatusCompensado,
      StatusCompensadoConv,
      StatusCompensadoCriti,

      CreatedAt,

      CreatedBy,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _OrdemItem : redirected to composition child ZC_MM_ADM_ORDEM_DESCARGA_ITEM
      //_ConfPedido
}
