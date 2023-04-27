@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View estoque obsoleto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ESTQ_OBS
  as select from ZI_MM_TIPO_MOV as a
//    inner join   yi_teste_03    as b on  b.MaterialDocument     = a.MaterialDocument
//                                     and a.MaterialDocumentItem = b.MaterialDocumentItem
//                                     and a.MaterialDocumentYear = b.MaterialDocumentYear
{
  key a.MaterialDocumentYear                  as MaterialDocumentYear,
  key a.MaterialDocument,
  key a.MaterialDocumentItem                  as MaterialDocumentItem,
      a.Material,
      a.Plant,
      a.StorageLocation,
      a.StorageType,
      a.StorageBin,
      a.ShelfLifeExpirationDate,
      a.ManufactureDate,
      a.Supplier,
      a.SalesOrder,
      a.SalesOrderItem,
      a.SalesOrderScheduleLine,
      a.WBSElementInternalID,
      a.WBSElementInternalID1,
      a.Customer,
      a.InventorySpecialStockType,
      a.InventoryStockType,
      a.StockOwner,
      a.GoodsMovementType,
      a.DebitCreditCode,
      a.InventoryUsabilityCode,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.QuantityInBaseUnit,
      a.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      a.QuantityInEntryUnit,
      a.EntryUnit,
      a.PostingDate,
      a.DocumentDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.TotalGoodsMvtAmtInCCCrcy,
      a.CompanyCodeCurrency,
      a.InventoryValuationType,
      a.ReservationIsFinallyIssued,
      a.PurchaseOrder,
      a._DocumentRecord._ProfitCenter.Segment as Segmento,
      //      @EndUserText.label: 'Período de Análise em Dias'
      //      dats_days_between(a.PostingDate2,$session.system_date) as AnaliseDias,
      a.PurchaseOrderItem,
      a.ProjectNetwork,
      a.OrderID,
      a.OrderItem,
      a.Reservation,
      a.ReservationItem,
      a.DeliveryDocument,
      a.DeliveryDocumentItem,
      a.ReversedMaterialDocumentYear,
      a.ReversedMaterialDocument,
      a.ReversedMaterialDocumentItem,
      a.RvslOfGoodsReceiptIsAllowed,
      a.GoodsRecipientName,
      a.UnloadingPointName,
      a.CostCenter,
      a.GLAccount,
      a.ServicePerformer,
      a.EmploymentInternalID,
      a.PersonWorkAgreement,
      a.AccountAssignmentCategory,
      a.WorkItem,
      a.ServicesRenderedDate,
      a.IssgOrRcvgMaterial,
      a.IssuingOrReceivingPlant,
      a.IssuingOrReceivingStorageLoc,
      a.IssgOrRcvgBatch,
      a.IssgOrRcvgSpclStockInd,
      a.CompanyCode,
      a.BusinessArea,
      a.ControllingArea,
      a.FiscalYearPeriod,
      a.FiscalYearVariant,
      a.GoodsMovementRefDocType,
      a.IsCompletelyDelivered,
      a.MaterialDocumentItemText,
      a.IsAutomaticallyCreated,
      a.GoodsReceiptType,
      a.ConsumptionPosting,
      a.MaterialType,
      a.MaterialGroup,
      a.ChartOfAccounts,
      a.UltimoConsumo,
      a.DataAnalise,
      a.AnaliseDias,
//      b.AnaliseDias,
      a.Exibir,
      a.Low,
      a.Exercicio,
      a.PostingDate2,
      a.PeriodoCorrente,
      concat( a.MaterialDocument, a.MaterialDocumentYear ) as KeyDocYear,

      /* Associations */
      a._SalesOrder

}
