@EndUserText.label: 'Administrar Corretagem'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_ADM_CORRETAGEM
  as projection on ZI_MM_ADM_CORRETAGEM
{
      @EndUserText.label: 'Pedido de Compras'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key DocumentoCompra            as PedidoCompra,
      @EndUserText.label: 'Doc NF'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key Docnum                     as DocNF,
      @EndUserText.label: 'Período'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      Periodo,
      @EndUserText.label: 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' }}]
      Centro,
      @EndUserText.label: 'Data Entrada Mercadoria'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      DataEntrada,
      @EndUserText.label: 'Data Entrada NF'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      DtEntradaNF,
      @EndUserText.label: 'Corretora'
      @ObjectModel.text.element: ['NomeCorretora']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Corretora,
      @EndUserText.label: 'Nome Corretora'
      _FornCorre.SupplierName    as NomeCorretora,
      @EndUserText.label: 'Corretor'
      @ObjectModel.text.element: ['NomeCorretor']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Corretor,
      @EndUserText.label: 'Nome Corretor'
      _FornCorretor.SupplierName as NomeCorretor,
      @EndUserText.label: 'Nro. Nota Fiscal'
      NrNF,
      @EndUserText.label: 'Moeda'
      SalesDocumentCurrency      as Moeda,
      @EndUserText.label: 'Valor Total Liq. NF'
      ValorTotLiq,
      @EndUserText.label: 'Unidade'
      BaseUnit                   as Unidade,
      @EndUserText.label: 'Quantidade NF'
      QuantityInBaseUnit,
      @EndUserText.label: '% Corretagem'
      PercCorretagem,
      @EndUserText.label: 'Valor Corretagem'
      ValorCorretagem,
      @EndUserText.label: 'Embarcador'
      @ObjectModel.text.element: ['NomeEmbarcador']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Embarcador,
      @EndUserText.label: 'Nome Embarcador'
      _FornEmbar.SupplierName    as NomeEmbarcador,
      @EndUserText.label: 'Preço Unid. Embarque'
      PrecoUnitEmb,
      @EndUserText.label: 'Valor Embarcador'
      ValorEmbarcador,
      @EndUserText.label: 'Valor Desconto'
      ValorDesconto,
      @EndUserText.label: 'Valor Devol. Corretagem'
      ValorDevCorretagem,
      @EndUserText.label: 'Valor a Pagar'
      ValorAPagar,
      @EndUserText.label: 'Contrato Grão Verde'
      NrContrato,
      @EndUserText.label: 'Fornecedor'
      Fornecedor,
      @EndUserText.label: 'Obs. Comercial'
      @Consumption.filter.selectionType: #SINGLE
      Observacao,
      @EndUserText.label: 'Status Apuração'
      @ObjectModel.text.element: ['NomeStatusApur']
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_APURACAO', element: 'Valor' }}] }
      StatusApuracao,
      @EndUserText.label: 'Desc. Status Apuração'
      _StatusApur.Texto          as NomeStatusApur,
      @EndUserText.label: 'Documento Compensação'
      DocCompensacao,
      @EndUserText.label: 'Data Compensação'
      DataCompensacao,
      @EndUserText.label: 'Status Compensação'
      @ObjectModel.text.element: ['NomeStatusComp']
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_COMPENSA', element: 'Valor' }}] }
      StatusCompensacao,
      @EndUserText.label: 'Desc. Status Compens.'
      _StatusComp.Texto          as NomeStatusComp,
      StatusCompCrityc,
      StatusApurCrityc

}
