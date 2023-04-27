@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Tabela de Parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TIPO_MOV
  as select from I_MaterialDocumentItem  
  //association to I_SalesOrganization   as _SalesOrg            on  $projection.Empresa   = _SalesOrg.CompanyCode
   
  association [0..*] to ZI_CA_PARAM_VAL          as _Param          on  $projection.GoodsMovementType =    _Param.Low
                                                                    and _Param.Modulo                 like 'MM%'
                                                                    and _Param.Chave1                 =    'TIPO_MOV'

  association [0..1] to I_MaterialDocumentRecord as _DocumentRecord on  $projection.MaterialDocumentYear = _DocumentRecord.MaterialDocumentYear
                                                                    and $projection.MaterialDocumentItem = _DocumentRecord.MaterialDocumentItem
                                                                    and $projection.MaterialDocument     = _DocumentRecord.MaterialDocument
                                                                      

{
  key I_MaterialDocumentItem.MaterialDocumentYear,
  key I_MaterialDocumentItem.MaterialDocument,
  key I_MaterialDocumentItem.MaterialDocumentItem,
      I_MaterialDocumentItem.Material, //
      I_MaterialDocumentItem.Plant, //
      I_MaterialDocumentItem.StorageLocation,
      I_MaterialDocumentItem.StorageType,
      I_MaterialDocumentItem.StorageBin,
      I_MaterialDocumentItem.Batch,
      I_MaterialDocumentItem.ShelfLifeExpirationDate,
      I_MaterialDocumentItem.ManufactureDate,
      I_MaterialDocumentItem.Supplier,
      I_MaterialDocumentItem.SalesOrder,
      I_MaterialDocumentItem.SalesOrderItem,
      I_MaterialDocumentItem.SalesOrderScheduleLine,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONVERT_ABPSP'
      I_MaterialDocumentItem.WBSElementInternalID,
      cast(I_MaterialDocumentItem.WBSElementInternalID as abap.numc( 8 ) ) as WBSElementInternalID1,
      I_MaterialDocumentItem.Customer,
      I_MaterialDocumentItem.InventorySpecialStockType,
      I_MaterialDocumentItem.InventoryStockType,
      I_MaterialDocumentItem.StockOwner,
      I_MaterialDocumentItem.GoodsMovementType,
      I_MaterialDocumentItem.DebitCreditCode,
      I_MaterialDocumentItem.InventoryUsabilityCode,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      I_MaterialDocumentItem.QuantityInBaseUnit,
      I_MaterialDocumentItem.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      I_MaterialDocumentItem.QuantityInEntryUnit,
      I_MaterialDocumentItem.EntryUnit,
      I_MaterialDocumentItem.PostingDate, //
      I_MaterialDocumentItem.DocumentDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      I_MaterialDocumentItem.TotalGoodsMvtAmtInCCCrcy,
      I_MaterialDocumentItem.CompanyCodeCurrency,
      I_MaterialDocumentItem.InventoryValuationType,
      I_MaterialDocumentItem.ReservationIsFinallyIssued,
      I_MaterialDocumentItem.PurchaseOrder,
      I_MaterialDocumentItem.PurchaseOrderItem,
      I_MaterialDocumentItem.ProjectNetwork,
      I_MaterialDocumentItem.OrderID,
      I_MaterialDocumentItem.OrderItem,
      I_MaterialDocumentItem.Reservation,
      I_MaterialDocumentItem.ReservationItem,
      I_MaterialDocumentItem.DeliveryDocument,
      I_MaterialDocumentItem.DeliveryDocumentItem,
      I_MaterialDocumentItem.ReversedMaterialDocumentYear,
      I_MaterialDocumentItem.ReversedMaterialDocument,
      I_MaterialDocumentItem.ReversedMaterialDocumentItem,
      I_MaterialDocumentItem.RvslOfGoodsReceiptIsAllowed,
      I_MaterialDocumentItem.GoodsRecipientName,
      I_MaterialDocumentItem.UnloadingPointName,
      I_MaterialDocumentItem.CostCenter,
      I_MaterialDocumentItem.GLAccount,
      I_MaterialDocumentItem.ServicePerformer,
      I_MaterialDocumentItem.EmploymentInternalID,
      I_MaterialDocumentItem.PersonWorkAgreement,
      I_MaterialDocumentItem.AccountAssignmentCategory,
      I_MaterialDocumentItem.WorkItem,
      I_MaterialDocumentItem.ServicesRenderedDate,
      I_MaterialDocumentItem.IssgOrRcvgMaterial,
      I_MaterialDocumentItem.IssuingOrReceivingPlant,
      I_MaterialDocumentItem.IssuingOrReceivingStorageLoc,
      I_MaterialDocumentItem.IssgOrRcvgBatch,
      I_MaterialDocumentItem.IssgOrRcvgSpclStockInd,
      I_MaterialDocumentItem.CompanyCode,
      I_MaterialDocumentItem.BusinessArea,
      I_MaterialDocumentItem.ControllingArea,
      I_MaterialDocumentItem.FiscalYearPeriod,
      I_MaterialDocumentItem.FiscalYearVariant,
      I_MaterialDocumentItem.GoodsMovementRefDocType,
      I_MaterialDocumentItem.IsCompletelyDelivered,
      I_MaterialDocumentItem.MaterialDocumentItemText,
      I_MaterialDocumentItem.IsAutomaticallyCreated,
      I_MaterialDocumentItem.GoodsReceiptType,
      I_MaterialDocumentItem.ConsumptionPosting,

      I_MaterialDocumentItem._Material.MaterialType,
      I_MaterialDocumentItem._Material.MaterialGroup,
      I_MaterialDocumentItem._GLAccount.ChartOfAccounts,

      dats_days_between(_DocumentRecord.PostingDate,$session.system_date)  as AnaliseDias,

      dats_add_days($session.system_date, -180, 'INITIAL')                 as UltimoConsumo,
      $session.system_date                                                 as DataAnalise,

      case
      when _Param.Low is null then 'X'
      else ''
      end                                                                  as Exibir,
      _Param.Low,
      _DocumentRecord.FiscalYear                                           as Exercicio,
      _DocumentRecord.PostingDate                                          as PostingDate2,
      substring(PostingDate, 5, 2)                                         as PeriodoCorrente,
                

      /* Associations */

      I_MaterialDocumentItem._SalesOrder,
      _DocumentRecord
}
