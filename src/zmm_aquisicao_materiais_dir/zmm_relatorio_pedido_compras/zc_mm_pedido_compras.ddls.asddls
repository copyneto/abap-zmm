@EndUserText.label: 'Relatório Pedidos de Compras'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity Zc_MM_PEDIDO_COMPRAS
  as projection on ZI_MM_PEDIDO_COMPRAS
{
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_RLTPED_VH_PEDIDO', element: 'ebeln' } }]
          @Search.defaultSearchElement: true
  key     PurchaseOrder,
          @Search.defaultSearchElement: true
  key     PurchaseOrderItem,
          @Search.defaultSearchElement: true
  key     PurchaseOrderScheduleLine,
          @Search.defaultSearchElement: true
  key     SupplierInvoice,
          @Search.defaultSearchElement: true
  key     FiscalYear,
          @Search.defaultSearchElement: true
  key     SupplierInvoiceItem,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_BUKRS', element: 'Empresa' } }]
          CompanyCode,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_BSART', element: 'Bsart' } }]
          PurchaseOrderType,
          PurchaseOrderDate,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_USER', element: 'Bname' } }]
          CreatedByUser,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
          Supplier,
          PurchasingOrganization,
          PurchasingGroup,
          SupplierRespSalesPersonName,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_FRGKE', element: 'Frgke' } }]
          ReleaseCode,
          ReleaseIsNotCompleted,
          PurchasingReleaseStrategy,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_ELIKZ', element: 'Process' } }]
          PurchasingCompletenessStatus,
          PurgReleaseTimeTotalAmount,
          DocumentCurrency,
          PaymentTerms,
          PurgReleaseSequenceStatus,
          PricingDocument,
          @Consumption.filter.selectionType: #INTERVAL
          CreationDate,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_KNTTP', element: 'CategoriaCode' } }]
          AccountAssignmentCategory,
          PurchaseOrderCategory,
          TaxCode,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LOEKZ', element: 'loekz' } }]
          PurchasingDocumentDeletionCode,
          PurchaseOrderItemText,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
          Material,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
          Plant,
          @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                               additionalBinding: [{ element: 'Plant', localElement: 'Plant' }]} ]
          StorageLocation,
          RequirementTracking,
          OrderQuantity,
          PurchaseOrderQuantityUnit,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_ELIKZ', element: 'Process' } }]
          IsCompletelyDelivered,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_ELIKZ', element: 'Process' } }]
          IsFinallyInvoiced,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZGRV_AFNAM', element: 'afnam' } }]
          RequisitionerName,
          PlannedDeliveryDurationInDays,
          OrderPriceUnit,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
          IncotermsClassification,
          IncotermsTransferLocation,
          PurchaseRequisition,
          PurchaseRequisitionItem,
          PurchasingInfoRecord,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_RLTPED_VH_PEDIDO', element: 'ebeln' } }]
          PurchaseContract,
          PurchaseContractItem,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATKL', element: 'Matkl' } }]
          MaterialGroup,
          BrutoConditionType,
          BrutoConditionRateValue,
          GrossAmount,
          BrutoConditionCurrency,
          BrutoConditionAmount,
          BrutoTransactionCurrency,
          IpiConditionType,
          IpiConditionRateValue,
          IpiConditionCurrency,
          IpiConditionAmount,
          IcmsConditionType,
          IcmsConditionRateValue,
          IcmsConditionCurrency,
          IcmsConditionAmount,
          DescBrtConditionAmount,
          DescBrtConditionRateValue,
          DespAcessConditionAmount,
          DespAcessConditionRateValue,
          DespAcessConditionCurrency,
          @Consumption.filter.selectionType: #INTERVAL
          ScheduleLineDeliveryDate,
          ReleaseIsNotCompletedPO,
          @Consumption.filter.selectionType: #SINGLE
          pendente,
          GrupLiberacao,
          PurchaseOrderNetAmount,
          NetAmount,
          ecompras,
          me,
          QuantityInPurchaseOrderUnitSup,
          PurchaseOrderQuantityUnitSup,
          DocumentDate,
          PostingDate,
          SupplierInvoiceIDByInvcgParty,
          NomeFornec,
          Cnpj,
          Cpf,
          FornRegion,
          @EndUserText.label: 'Qtd a ser faturado'
          aserfat,
          @EndUserText.label: 'Qtd a ser fornecido'
          aserforn,
          @EndUserText.label: 'Valor a ser faturado'
          aserfatvalor,
          OrderQuantityUnit,
          CompanyCodeCurrency,
          QtdDevolucao,
          PrevPagamento,
          Frete,
          DataLibera,
          HoraLibera,
          EstratLibera,
          LiberacIncompl,
          MatGroupName,
          QtdFornecida,
          ASerFornec,
          SerFaturado,
          SerFatValor,
          NetPriceAmount,
          @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRT_RELAT_PEDCOMPRAS' }
  virtual Migo        : menge_d,

          @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRT_RELAT_PEDCOMPRAS' }
  virtual QtdPendente : menge_d,

          @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRT_RELAT_PEDCOMPRAS' }
  virtual SaldoPend   : menge_d,

          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRT_RELAT_PEDCOMPRAS' }
  virtual EstLiberac  : numc1
}
