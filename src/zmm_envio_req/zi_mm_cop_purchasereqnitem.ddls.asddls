@AbapCatalog.sqlViewName: 'ZVMM_CPURREQNITM'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Reqn Consumption Item View'
@ClientHandling.algorithm: #SESSION_VARIABLE
//@AccessControl.privilegedAssociations:  [ '_PurchaseReqnItemSituations' ]

@VDM.viewType: #CONSUMPTION
//@ObjectModel.type: #CONSUMPTION
@ObjectModel: {
    semanticKey   : ['PurchaseRequisition', 'PurchaseRequisitionItem'],
    createEnabled : 'EXTERNAL_CALCULATION',
    //deleteEnabled : 'EXTERNAL_CALCULATION',
    updateEnabled : 'EXTERNAL_CALCULATION'
}
@UI.headerInfo: {
      typeName        : 'Purchase Requisition Item',
      typeNamePlural  : 'Purchase Requisition Items',
      title           : {value: 'PurchaseRequisitionItem'},
      description     : {value: 'PurchaseRequisitionItemText'}
}
//@Metadata.ignorePropagatedAnnotations:true
@ObjectModel.transactionalProcessingDelegated
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL

@AccessControl.personalData.blocking: #BLOCKED_DATA_EXCLUDED

define view ZI_MM_COP_PurchaseReqnItem
  as select from T_PurchaseReqnItem as Document

  association [1..1] to ZI_MM_COP_PurchaseReqnHeader   as _PurchaseReqn                 on  _PurchaseReqn.PurchaseRequisition = $projection.PurchaseRequisition

  association [0..*] to C_PurchaseReqnAcctAssgmt       as _PurchaseReqnAcctAssgmt       on  _PurchaseReqnAcctAssgmt.PurchaseRequisition     = $projection.PurchaseRequisition
                                                                                        and _PurchaseReqnAcctAssgmt.PurchaseRequisitionItem = $projection.PurchaseRequisitionItem

  association [0..1] to C_PurchaseReqnDelivAdd         as _PurchaseReqnDeliveryAddress  on  _PurchaseReqnDeliveryAddress.PurchaseRequisition     = $projection.PurchaseRequisition
                                                                                        and _PurchaseReqnDeliveryAddress.PurchaseRequisitionItem = $projection.PurchaseRequisitionItem

  association [0..*] to C_PurchaseReqnItemText         as _PurchaseReqnItemText         on  _PurchaseReqnItemText.PurchaseRequisition     = $projection.PurchaseRequisition
                                                                                        and _PurchaseReqnItemText.PurchaseRequisitionItem = $projection.PurchaseRequisitionItem

  association [1..*] to C_PurchaseReqnProposedSoS      as _PurchaseReqnProposedSoS      on  _PurchaseReqnProposedSoS.Material = $projection.Material
                                                                                        and _PurchaseReqnProposedSoS.Plant    = $projection.Plant

  association [0..*] to C_PurchaseReqnAssignedSoS      as _PurchaseReqnAssignedSoS      on  _PurchaseReqnAssignedSoS.PurchaseRequisition     = $projection.PurchaseRequisition
                                                                                        and _PurchaseReqnAssignedSoS.PurchaseRequisitionItem = $projection.PurchaseRequisitionItem

  association [0..1] to C_PurReqnReleaseStatus         as _PurchaseReqnReleaseStatus    on  _PurchaseReqnReleaseStatus.DomainValue = $projection.PurReqnReleaseStatus

  association [0..1] to I_PurReqnExtApprovalStsT       as _PurReqnExtApprovalStatusText on  _PurReqnExtApprovalStatusText.ExternalApprovalStatus = $projection.ExternalApprovalStatus
                                                                                        and _PurReqnExtApprovalStatusText.Language               = $session.system_language

  association [0..1] to C_PurchaseReqnItemCategoryVH   as _PurchaseReqnItemCategory     on  _PurchaseReqnItemCategory.PurchasingDocumentItemCategory = $projection.PurchasingDocumentItemCategory

  association [0..1] to I_PurgDocumentItemCategoryText as _PurgDocumentItemCategoryText on  $projection.PurchasingDocumentItemCategory = _PurgDocumentItemCategoryText.PurchasingDocumentItemCategory
                                                                                        and _PurgDocumentItemCategoryText.Language     = $session.system_language

  association [0..1] to C_MM_PurOrdPriceTypeVH         as _PurOrdPriceTypeVH            on  _PurOrdPriceTypeVH.PurchaseOrderPriceType = $projection.PurchaseOrderPriceType



  association [0..1] to C_MM_AccountAssignCatValueHelp as _AccountAssignCatValueHelp    on  _AccountAssignCatValueHelp.AccountAssignmentCategory = $projection.AccountAssignmentCategory



  //Material Value help cardionality * instead of 1 as it is at plant level
  association [0..1] to C_MM_MaterialValueHelp         as _MaterialValueHelp            on  _MaterialValueHelp.Material = $projection.Material
                                                                                        and _MaterialValueHelp.Plant    = $projection.Plant

  association [0..1] to C_MM_MaterialGroupValueHelp    as _MaterialGroupValueHelp       on  _MaterialGroupValueHelp.MaterialGroup = $projection.MaterialGroup

  association [0..1] to C_MM_StorLocValueHelp          as _StorageLocationValueHelp     on  _StorageLocationValueHelp.StorageLocation = $projection.StorageLocation
                                                                                        and _StorageLocationValueHelp.Plant           = $projection.Plant // 2801321

  association [0..1] to C_PurchasingOrgValueHelp       as _PurchasingOrgValueHelp       on  _PurchasingOrgValueHelp.PurchasingOrganization = $projection.PurchasingOrganization


  association [0..1] to C_PurchasingGroupValueHelp     as _PurchasingGroupValueHelp     on  _PurchasingGroupValueHelp.PurchasingGroup = $projection.PurchasingGroup


  // association [0..*] to C_MM_PlantValueHelp            as _PlantValueHelp              on  _PlantValueHelp.Plant = $projection.Plant

  association [0..1] to C_PurReqnProcessingStatus      as _PurReqnProcessingStatus      on  _PurReqnProcessingStatus.DomainValue = $projection.ProcessingStatus


  association [0..1] to C_PurReqnSupplierVH            as _SupplierValueHelp            on  _SupplierValueHelp.Supplier = $projection.Supplier
  //or  _SupplierValueHelp.Supplier = $projection.FixedSupplier

  association [0..1] to C_PurReqnCreationInd           as _PurchaseReqnOrigin           on  _PurchaseReqnOrigin.DomainValue = $projection.PurReqnOrigin


  association [0..*] to C_MM_ServicePerformerValueHelp as _ServicePerformerValueHelp    on  _ServicePerformerValueHelp.ServicePerformer = $projection.ServicePerformer


  association [0..1] to C_MM_ProductTypeValueHelp      as _ProductTypeValueHelp         on  _ProductTypeValueHelp.ProductType = $projection.ProductType


  association [0..1] to C_MM_MatlBatchValueHelp        as _MM_MatlBatchValueHelp        on  _MM_MatlBatchValueHelp.Material = $projection.Material
                                                                                        and _MM_MatlBatchValueHelp.Batch    = $projection.Batch


  association [0..*] to C_MM_RevisionLvlValueHelp      as _MM_RevisionLvlValueHelp      on  _MM_RevisionLvlValueHelp.ObjectType            = $projection.Material
                                                                                        and _MM_RevisionLvlValueHelp.MaterialRevisionLevel = $projection.MaterialRevisionLevel

  association [0..1] to C_MM_MRPCtrlrsValueHelp        as _MM_MRPCtrlrsValueHelp        on  _MM_MRPCtrlrsValueHelp.Plant         = $projection.Plant
                                                                                        and _MM_MRPCtrlrsValueHelp.MRPController = $projection.MRPController


  association [1..*] to C_PurchaseReqnInfoRecordVH     as _PurchaseReqnInfoRecordVH     on  $projection.Material               = _PurchaseReqnInfoRecordVH.Material
                                                                                        and $projection.PurchasingOrganization = _PurchaseReqnInfoRecordVH.PurchasingOrganization
                                                                                        and $projection.Plant                  = _PurchaseReqnInfoRecordVH.Plant

  association [1..*] to C_PurchaseReqnContractVH       as _PurchaseReqnContractVH       on  _PurchaseReqnContractVH.Material = $projection.Material

  association [1..*] to C_PurReqnSchedAgrmtVH          as _PurReqnSchedAgrmtVH          on  _PurReqnSchedAgrmtVH.Material = $projection.Material

  association [0..1] to C_SupplierPurchOrgVH           as _SupplierPurchOrgVH           on  _SupplierPurchOrgVH.Supplier               = $projection.FixedSupplier
                                                                                        and _SupplierPurchOrgVH.PurchasingOrganization = $projection.PurchasingOrganization

  association [0..1] to I_Proccatalogcalldetails       as _ProcCatalogCallDetails       on  _ProcCatalogCallDetails.OpnCtlgWebServiceID = $projection.PurReqnCatalog

  association [0..*] to I_Mmpur_Polling                as _Mmpur_Polling                on  _Mmpur_Polling.OpnCtlgWebServiceID = $projection.PurReqnCatalog

  //Code for Situations POC - Please comment before releasing the Request
  //  association [0..1] to C_SitnOnOpnPurReqnForContr as _PurchaseReqnItemSituations     on _PurchaseReqnItemSituations.PurchaseReqnItemUniqueID  = $projection.PurchaseReqnItemUniqueID
  association [0..1] to C_SitnForContrRdyToUse         as _SitnForContrRdyToUse         on  _SitnForContrRdyToUse.PurchaseContract     = $projection.PurchaseContract
                                                                                        and _SitnForContrRdyToUse.PurchaseContractItem = $projection.PurchaseContractItem

  association [0..1] to C_MltplAcctAssgmtDistrVH       as _MltplAcctAssgmtDistrVH       on  _MltplAcctAssgmtDistrVH.MultipleAcctAssgmtDistribution = $projection.MultipleAcctAssgmtDistribution

  association [0..1] to C_PartialInvoiceIndVH          as _PartialInvoiceIndVH          on  _PartialInvoiceIndVH.PartialInvoiceDistribution = $projection.PartialInvoiceDistribution

  association [0..*] to C_PurReqnItemApprvlPreview     as _PurReqnItemApprvlPreview     on  _PurReqnItemApprvlPreview.PurchaseRequisition     = $projection.PurchaseRequisition
                                                                                        and _PurReqnItemApprvlPreview.PurchaseRequisitionItem = $projection.PurchaseRequisitionItem

  //association [0..1] to I_Employee                     as _Employee                     on  _Employee.Employee = $projection.PurReqnSSPRequestor
  association [0..1] to I_BusinessUser                 as _BusinessUser                 on  _BusinessUser.BPIdentificationNumber = $projection.PurReqnSSPRequestor

  association [0..1] to I_EarmarkedFundsStdVH          as _EarmarkedFundsStdVH          on  _EarmarkedFundsStdVH.EarmarkedFunds     = $projection.EarmarkedFundsDocument
                                                                                        and _EarmarkedFundsStdVH.EarmarkedFundsItem = $projection.EarmarkedFundsDocumentItem
{


      @UI.lineItem:[
                    {dataAction: 'BOPF:UPDATE_CTLG_ITM_PRICE', type: #FOR_ACTION, label:'Update Price', qualifier: 'Item'},
                    {dataAction: 'BOPF:DELETE_ITEM', type: #FOR_ACTION, label:'Delete', qualifier: 'Item',requiresContext: true },
                    {dataAction: 'BOPF:DELETE_ITEM', type: #FOR_ACTION, label:'Delete', qualifier: 'LimitItem'}
                    ]

  key Document.PurchaseRequisition,

      @UI: {
        lineItem: [
          { position: 10, importance: #HIGH, qualifier: 'LimitItem' },
          { position: 10, importance: #HIGH, qualifier: 'Item' }]
      }
      @ObjectModel.text.element: 'PurchaseRequisitionItemText'
  key Document.PurchaseRequisitionItem,

      Document.PurchaseRequisitionItemForEdit,

      Document.PurchasingDocument,

      Document.PurchasingDocumentItem,

      @UI:  {
            fieldGroup: { qualifier: 'Status01', position: 10, importance: #HIGH },
            dataPoint: { targetValueElement: 'PurReqnReleaseStatus' },
            textArrangement: #TEXT_ONLY
            }
      @ObjectModel.text.association: '_PurchaseReqnReleaseStatus'
      Document.PurReqnReleaseStatus,

      @UI:  {
            fieldGroup: { qualifier: 'Status01', position: 20, importance: #HIGH },
            dataPoint: { targetValueElement: 'ExternalApprovalStatus' },
            textArrangement: #TEXT_ONLY
            }
      @ObjectModel.text.association: '_PurReqnExtApprovalStatusText'
      @EndUserText.label: 'External Processing Status'
      Document.ExternalApprovalStatus,

      Document.PurchaseRequisitionType,

      Document.PurchasingDocumentSubtype,

      @UI:  {
              identification: { position: 20, importance: #HIGH },
              textArrangement: #TEXT_ONLY
            }
      @ObjectModel.text.element: ['PurgDocItemCategoryName']
      @Consumption.valueHelp:'_PurchaseReqnItemCategory'
      Document.PurchasingDocumentItemCategory,

      @ObjectModel.readOnly: true
      @Semantics.text: true
      _PurgDocumentItemCategoryText.PurgDocItemCategoryName,

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation02', position: 10, importance: #HIGH }
            }
      Document.PurchaseRequisitionItemText,

      @UI:  {
              identification: { position: 50, importance: #HIGH },
              lineItem: { position: 30, importance: #HIGH, type: #STANDARD, qualifier: 'LimitItem' }
            }
      @ObjectModel.foreignKey.association: '_AccountAssignCatValueHelp'
      @Consumption.valueHelp:'_AccountAssignCatValueHelp'
      Document.AccountAssignmentCategory,

      @UI:  {
            lineItem: { position: 30, importance: #HIGH, type: #STANDARD, qualifier: 'Item' },
            //textArrangement: #TEXT_FIRST,
            fieldGroup: { qualifier: 'GeneralInformation02', position: 15, importance: #HIGH }
            }
      @ObjectModel.foreignKey.association: '_MaterialValueHelp'
      @Consumption.valueHelp:'_MaterialValueHelp'
      @Consumption.semanticObject: 'Material'
      //  @Consumption.valueHelpDefinition: [{ entity: { name : 'C_MM_MaterialValueHelp', element: 'Material' } }]
      Document.Material,

      @UI:  {
            lineItem: { position: 40, importance: #MEDIUM, type: #STANDARD, qualifier: 'Item' },
            fieldGroup: { qualifier: 'GeneralInformation02', position: 20, importance: #HIGH }
            }

      @ObjectModel.foreignKey.association: '_MaterialGroupValueHelp'
      @Consumption.valueHelp:'_MaterialGroupValueHelp'
      // @Consumption.valueHelpDefinition: [{ entity: { name : 'C_MM_MaterialGroupValueHelp', element: 'MaterialGroup' } }]
      Document.MaterialGroup,

      Document.PurchasingDocumentCategory,

      @UI:  {
              lineItem: { position: 60, importance: #HIGH, type: #STANDARD,qualifier: 'Item'},
              fieldGroup: { qualifier: 'QuantityDate01', position: 10, importance: #HIGH }
            }
      @Semantics.quantity.unitOfMeasure: 'ItemUoM'
      Document.RequestedQuantity,


      @UI.fieldGroup: { qualifier: 'Valuation01', position: 40, importance: #HIGH }
      Document.BaseUnit,

      @ObjectModel.readOnly: true
      @Semantics.unitOfMeasure: true
      Document.BaseUnit                             as ItemUoM,

      @UI:  {
            //lineItem: { position: 70, importance: #HIGH, type: #STANDARD,qualifier: 'Item' },
            fieldGroup: { qualifier: 'Valuation01', position: 10, importance: #HIGH }
            }
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      Document.PurchaseRequisitionPrice,


      @UI.fieldGroup: { qualifier: 'Valuation01', position: 30, importance: #HIGH }
      @Semantics.quantity.unitOfMeasure: 'ItemUoM'
      Document.PurReqnPriceQuantity,

      @UI.fieldGroup: { qualifier: 'QuantityDate02', position: 50, importance: #HIGH }
      Document.MaterialGoodsReceiptDuration,
      Document.ReleaseCode,

      @UI.fieldGroup: [ { qualifier: 'QuantityDate02', position: 30, importance: #HIGH },
                        { qualifier: 'LimitDate02', position: 20, importance: #HIGH } ]

      Document.PurchaseRequisitionReleaseDate,

      @UI:  {
              fieldGroup: { qualifier: 'Contact03', position: 10, importance: #HIGH }
            }
      @ObjectModel.foreignKey.association: '_PurchasingOrgValueHelp'
      @Consumption.valueHelp:'_PurchasingOrgValueHelp'
      Document.PurchasingOrganization,

      @UI:  {
              fieldGroup: { qualifier: 'Contact03', position: 20, importance: #HIGH }
            }


      @ObjectModel.foreignKey.association: '_PurchasingGroupValueHelp'
      @Consumption.valueHelp:'_PurchasingGroupValueHelp'
      Document.PurchasingGroup,

      @UI:  {
              lineItem: [
                { position: 50, importance: #HIGH, qualifier: 'LimitItem' },
                { position: 50, importance: #HIGH, qualifier: 'Item' }],
              identification: { position: 40, importance: #HIGH }
            }

      @Consumption.valueHelpDefinition: [{ entity: { name : 'C_MM_PlantValueHelp', element: 'Plant' } }]
      // @Consumption.semanticObject: 'Plant'
      Document.Plant,

      Document.SourceOfSupplyIsAssigned,

      @UI.hidden: true
      Document.SupplyingPlant,

      @UI:  {
              fieldGroup: { qualifier: 'QuantityDate01', position: 20, importance: #HIGH }
            }
      @Semantics.quantity.unitOfMeasure: 'ItemUoM'
      Document.OrderedQuantity,

      @UI:  {
              //lineItem: { position: 70, importance: #HIGH, type: #STANDARD },
              fieldGroup: { qualifier: 'QuantityDate02', position: 10, importance: #HIGH }
            }
      Document.DeliveryDate,

      @UI:  {
              fieldGroup: { qualifier: 'Contact01', position: 20, importance: #HIGH }
            }
      Document.CreationDate,

      @UI:  {
            fieldGroup: { qualifier: 'Status02', position: 10, importance: #HIGH }
            }

      @ObjectModel.text : { association : '_PurReqnProcessingStatus' }
      Document.ProcessingStatus,

      Document.PurchasingInfoRecord,

      @UI:  {
              lineItem: [
                { position: 90, importance: #HIGH, qualifier: 'LimitItem' },
                { position: 90, importance: #HIGH, qualifier: 'Item' }],
              fieldGroup: { qualifier: 'GeneralInformation03', position: 15, importance: #HIGH }
            }


      @Consumption.valueHelpDefinition: [{ entity:{ name : 'C_MM_SupplierValueHelp', element: 'Supplier'} }]
      @ObjectModel.foreignKey.association: '_SupplierValueHelp'
      @Consumption.semanticObject: 'Supplier'
      //      @Consumption.valueHelp:'_SupplierValueHelp'
      Document.Supplier,


      Document.IsDeleted,

      @Consumption.valueHelpDefinition: [{ entity:{ name : 'C_MM_SupplierValueHelp', element: 'Supplier'} }]
      @ObjectModel.foreignKey.association: '_SupplierPurchOrgVH'

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation03', position: 16, importance: #HIGH }
            }
      @Consumption.semanticObject: 'Supplier'
      @EndUserText.label: 'Fixed Supplier' //Annotation reference from limititem view
      Document.FixedSupplier,

      @UI:  {
              lineItem: { position: 80, importance: #HIGH, type: #STANDARD, qualifier: 'Item' },
              fieldGroup: { qualifier: 'Contact02', position: 10, importance: #HIGH }
            }
      Document.RequisitionerName,

      @UI.fieldGroup: [{ qualifier: 'Contact02', position: 15, importance: #HIGH }]
      // @ObjectModel.text.element: 'EmployeeFullName'
      @ObjectModel.text.element: 'PersonFullName'
      Document.PurReqnSSPRequestor,
      @ObjectModel.readOnly: true
      @Consumption.filter.hidden: true
      @Semantics.text: true
      // _Employee.EmployeeFullName,
      _BusinessUser.PersonFullName,

      @UI:  {
            fieldGroup: { qualifier: 'Contact01', position: 10, importance: #HIGH }
            }
      Document.CreatedByUser,

      Document.UserDescription,

      @UI:  {
            fieldGroup:[ { qualifier: 'QuantityDate02', position: 20, importance: #HIGH },
                          { qualifier: 'LimitDate02', position: 20, importance: #HIGH } ]
            }
      Document.PurReqCreationDate,

      Document.ManualDeliveryAddressID,
      Document.ItemDeliveryAddressID,
      Document.DeliveryAddressID,


      Document.PurReqnItemCurrency,

      @UI:  {
            fieldGroup: { qualifier: 'QuantityDate02', position: 40, importance: #HIGH }
            }
      Document.MaterialPlannedDeliveryDurn,
      Document.DelivDateCategory,

      @UI:  {
              identification: { position: 70, importance: #HIGH }
            }
      @ObjectModel.foreignKey.association: '_MltplAcctAssgmtDistrVH'
      @Consumption.valueHelp: '_MltplAcctAssgmtDistrVH'
      Document.MultipleAcctAssgmtDistribution,

      @UI:  {
              identification: { position: 80, importance: #HIGH }
            }
      @ObjectModel.foreignKey.association:'_PartialInvoiceIndVH'
      @Consumption.valueHelp:'_PartialInvoiceIndVH'
      Document.PartialInvoiceDistribution,

      @UI:  {
                    fieldGroup: { qualifier: 'GeneralInformation03', position: 20, importance: #HIGH }
             }
      @ObjectModel.foreignKey.association:'_StorageLocationValueHelp'             // 2801321
      @Consumption.valueHelp:'_StorageLocationValueHelp'                          // 2801321
      Document.StorageLocation,

      @UI.fieldGroup: { qualifier: 'SourcesofSupply', position: 10, importance: #HIGH }
      Document.PurchaseContract,

      @Consumption.hidden: true
      Document.PurReqnSourceOfSupplyType,

      @UI.fieldGroup: { qualifier: 'SourcesofSupply1', position: 20, importance: #HIGH }
      Document.PurchaseContractItem,
      Document.ConsumptionPosting,

      @UI:  {
            fieldGroup: { qualifier: 'Contact01', position: 30, importance: #HIGH }
            }
      @ObjectModel.text : { association : '_PurchaseReqnOrigin' }

      Document.PurReqnOrigin,

      @Consumption.valueHelpDefinition: [{entity:{name:'C_PurReqnBlockedIndicator' , element: 'IsPurReqnBlocked'}}]
      Document.IsPurReqnBlocked,

      Document.Language,

      @UI:  {
            fieldGroup: [{ qualifier: 'QuantityDate01', position: 40, importance: #HIGH },
                         { qualifier: 'LimitDocFlow01', position: 10, importance: #HIGH }]
            }
      Document.IsClosed,

      Document.ReleaseIsNotCompleted,

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation03', position: 10, importance: #HIGH }
            }
      @Consumption.valueHelp:'_ServicePerformerValueHelp'
      Document.ServicePerformer,

      @UI:  {
              identification: { position: 10, importance: #HIGH },
              lineItem: { position: 20, importance: #HIGH, type: #STANDARD, qualifier: 'Item'}
            }
      @Consumption.valueHelp:'_ProductTypeValueHelp'
      @ObjectModel.foreignKey.association: '_ProductTypeValueHelp'
      @ObjectModel.readOnly: true
      Document.ProductType,

      Document.PurchaseRequisitionStatus,
      Document.ReleaseStrategy,
      @UI:  {
              fieldGroup:[ { qualifier: 'QuantityDate02', position: 11, importance: #HIGH },
                           { qualifier: 'LimitDate01', position: 10, importance: #HIGH } ]
            }
      Document.PerformancePeriodStartDate,

      @UI:  {
              fieldGroup: [ { qualifier: 'QuantityDate02', position: 12, importance: #HIGH },
                            { qualifier: 'LimitDate01', position: 20, importance: #HIGH } ]
            }
      Document.PerformancePeriodEndDate,

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation02', position: 30, importance: #HIGH }
            }
      Document.SupplierMaterialNumber,

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation03', position: 25, importance: #HIGH }
            }
      @Consumption.valueHelp:'_MM_MatlBatchValueHelp'
      @ObjectModel.foreignKey.association: '_MM_MatlBatchValueHelp'
      Document.Batch,

      @UI:  {
              fieldGroup: { qualifier: 'GeneralInformation03', position: 30, importance: #HIGH }
            }
      @Consumption.valueHelp:'_MM_RevisionLvlValueHelp'
      Document.MaterialRevisionLevel,

      @UI:  {
            fieldGroup: { qualifier: 'QuantityDate03', position: 10, importance: #HIGH }
            }
      Document.MinRemainingShelfLife,

      @Semantics.currencyCode: true
      @ObjectModel.readOnly: true
      PurReqnItemCurrency                           as Currency,

      //@ObjectModel.virtualElement : true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_ITM_TRA_EXIT'
      //cast('' as waers )   as Currency,
      @EndUserText.label: 'Total Value'
      @UI:  {
            fieldGroup: { qualifier: 'Valuation01', position: 50, importance: #HIGH }
            }
      //@ObjectModel.readOnly: true
      @Semantics.amount.currencyCode: 'Currency'
      Document.ItemNetAmount,

      @UI:  {

            fieldGroup: { qualifier: 'Valuation02', position: 10, importance: #HIGH },
            textArrangement: #TEXT_ONLY
            }
      //      @ObjectModel.foreignKey.association: '_PurOrdPriceTypeVH'
      //      @Consumption.valueHelp:'_PurOrdPriceTypeVH'
      @Consumption.valueHelpDefinition: [{entity:{name:'C_MM_PurOrdPriceTypeVH' , element: 'PurchaseOrderPriceType'}}]
      @ObjectModel: {text: {element: [ 'PurchaseOrderPriceTypeDesc' ]}}
      @EndUserText.label: 'PO Price Type'
      Document.PurchaseOrderPriceType,

      @Consumption.filter.hidden:true
      @ObjectModel.readOnly: true
      _PurOrdPriceTypeVH.PurchaseOrderPriceTypeDesc,

      @UI:  {

            fieldGroup:[ { qualifier: 'Valuation02', position: 20, importance: #HIGH },
                         { qualifier: 'LimitDocFlow02', position: 10, importance: #HIGH }]
            }
      Document.GoodsReceiptIsExpected,

      @UI:  {

            fieldGroup: [{ qualifier: 'Valuation02', position: 30, importance: #HIGH },
                         { qualifier: 'LimitDocFlow02', position: 20, importance: #HIGH }]
            }
      Document.InvoiceIsExpected,

      @UI:  {

            fieldGroup: { qualifier: 'Valuation02', position: 40, importance: #HIGH }
            }
      Document.GoodsReceiptIsNonValuated,

      @UI:  {
            fieldGroup: { qualifier: 'Contact02', position: 30, importance: #HIGH }
            }
      Document.RequirementTracking,

      @UI:  {
              fieldGroup: { qualifier: 'Contact02', position: 20, importance: #HIGH }
            }
      @Consumption.valueHelp:'_MM_MRPCtrlrsValueHelp'
      @ObjectModel.foreignKey.association: '_MM_MRPCtrlrsValueHelp'
      Document.MRPController,

      @UI:  {
            fieldGroup: [{ qualifier: 'QuantityDate01', position: 50, importance: #HIGH },
                          { qualifier: 'LimitDocFlow01', position: 20, importance: #HIGH }]
            }
      Document.PurchaseRequisitionIsFixed,

      @UI:  {
              identification: { position: 60, importance: #HIGH }
            }
      @ObjectModel.text.element:  [ 'OpnCtlgWebServiceName' ]
      Document.PurReqnCatalog,

      @ObjectModel.readOnly: true
      _ProcCatalogCallDetails.OpnCtlgWebServiceName as OpnCtlgWebServiceName,

      @UI:  {
            fieldGroup: { qualifier: 'GeneralInformation02', position: 35, importance: #HIGH }
            }
      Document.PurReqnCatalogItem,

      //@ObjectModel.readOnly: true
      Document.PurReqnCrossCatalogItem,

      @ObjectModel.readOnly: true
      Document.PurchaseReqnItemUniqueID,

      /*Transient Fields*/
      @UI:  {
            fieldGroup: { qualifier: 'QuantityDate01', position: 30, importance: #HIGH }
            }
      @ObjectModel.readOnly: true
      @EndUserText.label: 'Open Quantity'
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_ITM_TRA_EXIT'
      @Semantics.quantity.unitOfMeasure: 'ItemUoM'
      cast ( 0 as abap.quan( 13, 3 ))               as OpenQuantity,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_ITM_TRA_EXIT'
      cast ( '' as xfeld )                          as PurgIsWrkflwScenActvForDocType,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_ITM_TRA_EXIT'
      cast ( '' as abap.char(10) )                  as WorkflowScenarioDefinition,

      @UI:  {
              fieldGroup: { qualifier: 'Contact03', position: 30, importance: #HIGH }
            }
      @ObjectModel.readOnly: true
      Document._PurchasingGroup.PhoneNumber,

      @UI:  {
              fieldGroup: { qualifier: 'Contact03', position: 40, importance: #HIGH }
            }
      @ObjectModel.readOnly: true
      @EndUserText.label: 'Fax Number'
      Document._PurchasingGroup.FaxNumber,

      @ObjectModel.readOnly: true
      Document.IsPurReqnOvrlRel,

      @UI:  {
              lineItem: { position: 20, importance: #HIGH, type: #STANDARD, qualifier: 'LimitItem' },
              fieldGroup: { qualifier: 'GeneralInformation02', position: 15, importance: #HIGH }

            }
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      // @ObjectModel.mandatory: true
      Document.ExpectedOverallLimitAmount,

      @UI:  {
              lineItem: { position: 30, importance: #HIGH, type: #STANDARD, qualifier: 'LimitItem' },
              fieldGroup: { qualifier: 'GeneralInformation02', position: 15, importance: #HIGH }

            }
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      //@ObjectModel.mandatory: true
      Document.OverallLimitAmount,


      /*******************************Start Code for PSM Account Object Integration***************************************/

      @UI:  {
          fieldGroup: { qualifier: 'PSMAccounting01', position: 10, importance: #HIGH }
        }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_FundStdVH', element: 'Fund' } }]
      Document.Fund                                 as Fund,

      @UI:  {
        fieldGroup: { qualifier: 'PSMAccounting01', position: 20, importance: #HIGH }
      }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_BudgetPeriodStdVH', element: 'BudgetPeriod' } }]
      Document.BudgetPeriod                         as BudgetPeriod,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting01', position: 30, importance: #HIGH }
            }

      @Consumption.valueHelp: '_EarmarkedFundsStdVH'
      Document.EarmarkedFundsDocument               as EarmarkedFundsDocument,

      @UI:  {
           fieldGroup: { qualifier: 'PSMAccounting02', position: 40, importance: #HIGH }
         }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_FundsCenterStdVH', element: 'FundsCenter' } }]
      Document.FundsCenter                          as FundsCenter,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting02', position: 50, importance: #HIGH }
            }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_CommitmentItemStdVH', element: 'CommitmentItem' } }]
      Document.CommitmentItem                       as CommitmentItem,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting02', position: 60, importance: #HIGH }
            }

      Document.EarmarkedFundsDocumentItem           as EarmarkedFundsDocumentItem,

      @UI:  {
             fieldGroup: { qualifier: 'PSMAccounting03', position: 70, importance: #HIGH }
           }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_GrantStdVH', element: 'GrantID' } }]
      Document.GrantID                              as GrantID,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting03', position: 80, importance: #HIGH }
            }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_FndsMgmtFuncnlAreaStdVH', element: 'FunctionalArea' } }]
      Document.FunctionalArea                       as FunctionalArea,

      @UI:  {
            fieldGroup: { qualifier: 'PSMAccounting03', position: 90, importance: #HIGH }
          }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_MM_GLAccountVH', element: 'GLAccount' } }]
      Document.GLAccount                            as GLAccount,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting03', position: 100, importance: #HIGH }
            }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_MM_CostCenterValueHelp', element: 'CostCenter' } }]
      Document.CostCenter                           as CostCenter,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting03', position: 110, importance: #HIGH }
            }
      Document.WBSElement                           as WBSElement,

      @UI:  {
              fieldGroup: { qualifier: 'PSMAccounting03', position: 120, importance: #HIGH }
            }
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_FundedProgramStdVH', element: 'FundedProgram' } }]
      Document.FundedProgram                        as FundedProgram,

      //      Document.FundMgmtIsActive                     as FundMgmtIsActive,
      /*Transient Fields*/
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_ITM_TRA_EXIT'
      Document.FundMgmtIsActive                     as FundMgmtIsActive,
      /*******************************End Code for PSM Account Object Integration*****************************************/

      /* Associations */
      Document._AccAssgnmtCategory,
      Document._Currency,
      Document._PurchasingGroup,
      @Consumption.hidden: true
      Document._Supplier,
      Document._UnitOfMeasure,
      Document._Plant,
      _PurchaseReqnProposedSoS,
      _PurchaseReqnAssignedSoS,
      _PurchaseReqnInfoRecordVH,
      _PurchaseReqnContractVH,
      _PurchaseReqnItemCategory,
      _SupplierPurchOrgVH,
      _PurReqnSchedAgrmtVH,
      //_PlantValueHelp,
      _MaterialValueHelp,
      _MaterialGroupValueHelp,
      _StorageLocationValueHelp, //2801321
      // @Consumption.hidden: true
      _SupplierValueHelp,
      _AccountAssignCatValueHelp,
      _PurchasingGroupValueHelp,
      _PurchasingOrgValueHelp,
      _PurchaseReqnOrigin,
      _PurReqnProcessingStatus,
      _PurchaseReqnReleaseStatus,
      _PurReqnExtApprovalStatusText,
      _MM_MatlBatchValueHelp,
      _MM_MRPCtrlrsValueHelp,
      _MM_RevisionLvlValueHelp,
      _Mmpur_Polling,
      _ServicePerformerValueHelp,
      _ProductTypeValueHelp,
      _SitnForContrRdyToUse,
      _ProcCatalogCallDetails,
      _MltplAcctAssgmtDistrVH,
      _PartialInvoiceIndVH,
      _PurOrdPriceTypeVH,
      _EarmarkedFundsStdVH,
      @Consumption.hidden: true
      _PurReqnItemApprvlPreview,
      @Consumption.hidden: true
      // _Employee,
      _BusinessUser,

      @ObjectModel.association.type: [ #TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT ]
      _PurchaseReqn,
      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _PurchaseReqnAcctAssgmt,
      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _PurchaseReqnDeliveryAddress,
      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _PurchaseReqnItemText

}
