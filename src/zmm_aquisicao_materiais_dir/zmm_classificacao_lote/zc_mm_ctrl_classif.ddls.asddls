@EndUserText.label: 'Controle de Classificação'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_MM_CTRL_CLASSIF
  as projection on ZI_MM_CTRL_CLASSIF
{
      @EndUserText.label: 'Nº Pedido'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PurchaseOrderStdVH', element: 'PurchaseOrder' }}]
  key Pedido,

      @EndUserText.label: 'Item'
  key ItemPedido,

      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusName']
      Status,
      @EndUserText.label: 'Descrição do Status'
      _StatusText.PurchasingDocumentStatusName as StatusName,

      @EndUserText.label: 'Fornecedor'
      @ObjectModel.text.element: ['NomeFornecedor']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Fornecedor,
      @EndUserText.label: 'Nome do Fornecedor'
      _Fornecedor.SupplierName                 as NomeFornecedor,

      @EndUserText.label: 'Nome Corretor'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Corretor,

      @EndUserText.label: 'Corretora'
      @ObjectModel.text.element: ['NomeCorretora']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Corretora,
      @EndUserText.label: 'Nome da Corretora'
      _Corretora.SupplierName                  as NomeCorretora,

      @EndUserText.label: 'Embarcador'
      @ObjectModel.text.element: ['NomeEmbarcador']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Embarcador,
      @EndUserText.label: 'Nome do Embarcador'
      _Embarcador.SupplierName                  as NomeEmbarcador,

      @EndUserText.label: 'Percentual Corretagem (%)'
      @Semantics.quantity.unitOfMeasure: 'Porcentagem'
      PercCorretagem,

      @EndUserText.label: 'Tipo de Sacaria'
      @ObjectModel.text.element: ['NomeSacaria']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_SACARIA', element: 'Valor' }}]
      TpSacaria,
      @EndUserText.label: 'Desc. Tipo de Sacaria'
      _Sacaria.Texto                           as NomeSacaria,

      @EndUserText.label: 'Tipo de Embalagem'
      @ObjectModel.text.element: ['NomeEmbalagem']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_EMBALAGEM', element: 'Valor' }}]
      TpEmbal,
      @EndUserText.label: 'Desc. Tipo de Embalagem'
      _Embalagem.Texto                         as NomeEmbalagem,

      @EndUserText.label: 'Nº Contrato'
      Contrato,

      @EndUserText.label: 'Preço por embalagem Embarque'
      PrecoUnitEmbarcador,

      @EndUserText.label: 'Valor Total Corretagem'
      VlrTotalCorretagem,
      
      @EndUserText.label: 'Valor Total Embarcador'
      VlrTotalEmbarcador,

      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['NomeMaterial']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MaterialVH', element: 'Material' }}]
      Material,
      @EndUserText.label: 'Nome do Material'
      _MaterialText.MaterialName               as NomeMaterial,

      @EndUserText.label: 'Quantidade do Item'
      Quantidade,

      @EndUserText.label: 'Unidade Medida Pedido'
      UnidadeMedidaPedido,

      @EndUserText.label: 'Unidade Medida Base'
      UnidadeMedida,

      @EndUserText.label: 'Quantidade UGE'
      QuantidadeEstoque,

      @EndUserText.label: 'Fornecedor Destino'
      @ObjectModel.text.element: ['NomeDestinatario']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' }}]
      Destinatario,
      @EndUserText.label: 'Nome Forn. Destino'
      _Destinatario.SupplierName               as NomeDestinatario,

      @EndUserText.label: 'Observação'
      Observacao,

      @EndUserText.label: 'Status Classif.'
      @ObjectModel.text.element: ['NomeStatusClassific']
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_STATUS_CLASSIFIC', element: 'Valor' }}],
                      filter.defaultValue: 'N' }
      StatusClassific,
      @EndUserText.label: 'Desc. Status Classif.'
      _StatusClassific.Texto                   as NomeStatusClassific,

      @EndUserText.label: 'Pedido em Aberto'
      @Consumption.filter.selectionType: #SINGLE
      PedidoAberto,

      @EndUserText.label: 'Data Classif.'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      DataClassif,

      @EndUserText.label: 'Frete'
      Incoterms,

      @EndUserText.label: 'Empresa'
      @ObjectModel.text.element: ['NomeEmpresa']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' }}]
      Empresa,
      @EndUserText.label: 'Nome da Empresa'
      NomeEmpresa,

      @EndUserText.label: 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' }}]
      @ObjectModel.text.element: ['NomeCentro']
      Centro,
      @EndUserText.label: 'Nome do Centro'
      _Plant.PlantName as NomeCentro,

      @EndUserText.label: 'Local de Negócio'
      @ObjectModel.text.element: ['NomeLocalNegocios']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BR_BusinessPlace', element: 'Branch' },
                                           additionalBinding: [{ element: 'CompanyCode', localElement: 'Empresa' }]}]
      LocalNegocios,
      @EndUserText.label: 'Nome Local Negócio'
      _BusinessPlace.BusinessPlaceName         as NomeLocalNegocios,

      @EndUserText.label: 'Divisão'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BusinessAreaStdVH', element: 'BusinessArea' }}]
      @ObjectModel.text.element: ['NomeDivisao']
      Divisao,
      _BusinessAreaText.BusinessAreaName as NomeDivisao,

      @EndUserText.label: 'Valor Líquido Pedido'
      @Semantics.amount.currencyCode: 'Moeda'
      ValorTotal,

      @EndUserText.label: 'Moeda do Pedido'
      @Semantics.currencyCode: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' }}]
      Moeda,

      @EndUserText.label: 'Quantidade'
      QuantidadeTotal,

      @EndUserText.label: 'Percentual'
      @Semantics.unitOfMeasure: true
      Porcentagem,

      @EndUserText.label: 'Criticidade do Status'
      CriticStatusClassific,

      @EndUserText.label: 'Criado Por'
      @ObjectModel.text.element: ['NomeCriador']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CreatedByUser', element: 'UserName' }}]
      CreatedBy,
      @EndUserText.label: 'Nome do Criador'
      _CreatedByUser.UserDescription           as NomeCriador,

      @EndUserText.label: 'Criado Em'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      CreatedAt,

      @EndUserText.label: 'Modificado Por'
      @ObjectModel.text.element: ['NomeModificador']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ChangedByUser', element: 'UserName' }}]
      LastChangedBy,
      @EndUserText.label: 'Nome do Modificador'
      _ChangedByUser.UserDescription           as NomeModificador,

      @EndUserText.label: 'Modificado Em'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      LastChangedAt,

      @EndUserText.label: 'Última Modif.'
      @Consumption : { filter: { selectionType: #INTERVAL } }
      LocalLastChangedAt,

      /* Associations */
      _Caract : redirected to composition child ZC_MM_VLR_CARACTERISTICA,
      _DadosBancarios,
      _BusinessAreaText,
      _BusinessPlace,
      _Plant,
      _PurchaseOrderTP,
      _QuantTotal,
      _MaterialText,
      _StatusText,
      _StatusClassific,
      _Sacaria,
      _Embalagem,
      _Fornecedor,
      _Corretora,
      _Destinatario,
      _CreatedByUser,
      _ChangedByUser

}
