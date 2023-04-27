/*
====================================================================================
   Compositional Hierarchy (Nodes):

   C_PurchaseReqnHeader
     |
     |   1..*
     +------ C_PurchaseReqnItem
                |
                |   0..*
                +-------- C_PurchaseReqnAcctAssgmt
                |   0..1
                +-------- C_PurchaseReqnDelivAdd
                |   0..*
                +-------- C_PurchaseReqnItemText
                |   0..*
                +-------- C_PurchaseReqnAssignedSoS
==================================================================================== */
@AbapCatalog.sqlViewName: 'ZVMM_CPURREQN'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Reqn Consumption Header View'

@VDM.viewType: #CONSUMPTION
//@ObjectModel.type: #CONSUMPTION
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.compositionRoot: true
@ObjectModel: {
    semanticKey: ['PurchaseRequisition'],
    createEnabled: true,
    deleteEnabled: 'EXTERNAL_CALCULATION',
    updateEnabled: true
}
@UI.headerInfo: {
      typeName        : 'Purchase Requisition',
      typeNamePlural  : 'Purchase Requisitions',
      title           : {value: 'PurchaseRequisitionForEdit'},
      description     : {value: 'PurReqnHeaderDescription'},
      typeImageUrl    : '/sap/bc/ui5_ui5/sap/mm_ppr_maints1/images/PurchaseReqn.jpg'
}
@Search.searchable : true
//@Metadata.ignorePropagatedAnnotations:true
@ObjectModel.draftEnabled:true
@ObjectModel.transactionalProcessingDelegated
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@AccessControl.personalData.blocking: #BLOCKED_DATA_EXCLUDED
@Consumption.semanticObject: 'PurchaseRequisition'

@AccessControl.privilegedAssociations:  [ '_PurchaseReqnCommitment' ]

define view ZI_MM_COP_PurchaseReqnHeader
  as select from T_PurchaseReqn as Document

  association [1..*] to ZI_MM_COP_PurchaseReqnItem as _PurchaseReqnItem       on _PurchaseReqnItem.PurchaseRequisition = $projection.PurchaseRequisition

  association [0..*] to C_PurchaseReqnCommitment   as _PurchaseReqnCommitment on _PurchaseReqnCommitment.PurchaseRequisition = $projection.PurchaseRequisition

  //association [1..*] to C_PurchaseReqnLimitItem as _PurchaseReqnLimitItem    on _PurchaseReqnLimitItem.PurchaseRequisition = $projection.PurchaseRequisition

  //association [0..1] to C_PurchaseReqnTypeVH    as _PurchaseReqnType         on _PurchaseReqnType.PurchaseRequisitionType = $projection.PurchaseRequisitionType

  // association [0..1] to C_PurReqnLifeCycleStatus as _PurReqnLifeCycleStatus    on _PurReqnLifeCycleStatus.DomainValue = $projection.PurReqnLifeCycleStatus

{
      @UI.lineItem :{dataAction: 'BOPF:COPY_HEADER', type: #FOR_ACTION, label:'Copy'}
      @UI.identification :{dataAction: 'BOPF:COPY_HEADER', type: #FOR_ACTION, label:'Copy'}
      @Consumption.filter: {hidden: true}
      @EndUserText.label:'Purchase Requisition Number'
  key Document.PurchaseRequisition,

      @Search:  { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @UI:      {
                  lineItem: { position: 11, importance: #HIGH, type: #STANDARD },
                  selectionField: { position: 20 }
                }
      @ObjectModel.text: { element: 'PurReqnHeaderDescription' }
      Document.PurchaseRequisitionForEdit,


      @Search:  { defaultSearchElement: true, ranking: #HIGH, fuzzinessThreshold: 0.8 }
      @UI:      {
                  lineItem: { position: 20, importance: #HIGH, type: #STANDARD },
                  fieldGroup: { qualifier: 'DocumentType', position: 10, importance: #HIGH },
                  selectionField: { position: 30 },
                  textArrangement: #TEXT_FIRST
                }
      @Consumption.valueHelpDefinition: [{entity:{name:'C_PurchaseReqnTypeVH' , element: 'PurchaseRequisitionType'}}]
      @ObjectModel: {text: {element: [ 'PurchasingDocumentTypeName' ]}}
      Document.PurchaseRequisitionType,

      @Consumption.filter.hidden:true
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      // cast('' as batxt)                      as PurchasingDocumentTypeName,
      cast('' as abap.char( 20 ))          as PurchasingDocumentTypeName,

      @UI.fieldGroup: { qualifier: 'Description', position: 20, importance: #HIGH }
      @UI.identification: { importance: #HIGH }
      @Consumption.filter.hidden: true
      Document.PurReqnDescription,


      @UI.fieldGroup: { qualifier: 'SourceDetermination', position: 10, importance: #HIGH }
      @Consumption.filter.hidden: true
      Document.SourceDetermination,


      @UI.lineItem: { position: 40, importance: #HIGH, type: #STANDARD }
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @ObjectModel.readOnly: true
      @ObjectModel.mandatory: 'EXTERNAL_CALCULATION'
      @EndUserText.label: 'Number of Items'
      cast(0 as abap.int8 )                as NumberOfItems,

      @Consumption.filter.hidden: true
      @ObjectModel.readOnly: true
      Document.PurchasingDocumentSubtype,

      /*Transient Fields*/

      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @ObjectModel.readOnly: true
      @ObjectModel.mandatory: 'EXTERNAL_CALCULATION'
      @EndUserText.label: 'Is Purchase Requisition Advanced'
      cast('' as boolean)                  as PurReqnHasAdvncdUsrInterface,

      @UI:  {
              fieldGroup: { qualifier: 'Description', position: 10, importance: #HIGH },
              identification: { importance: #HIGH }
            }
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @EndUserText.label:'Purchase Requisition Description'
      @ObjectModel.readOnly: true
      @ObjectModel.mandatory: 'EXTERNAL_CALCULATION'
      Document.PurReqnHeaderDescription,


      @UI:      {
      //                   lineItem: { position: 30, importance: #HIGH, type: #STANDARD },
                   dataPoint: { targetValueElement: 'TotalNetAmount' }
                }
      @EndUserText.label: 'Total Value'
      @Semantics.amount: {currencyCode: 'Currency'}
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast ( ('00')  as abap.curr(15,2) )  as TotalNetAmount,

      //      @ObjectModel.readOnly: true
      //      @ObjectModel.virtualElement : true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      //      cast ( (0) as sadl_gw_dynamic_field_property ) as F_TotalNetAmount,
      //@Consumption.filter: {hidden: true}
      @Semantics.currencyCode: true
      @EndUserText.label: 'Currency'
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast ( ('')    as abap.cuky( 5 ) )   as Currency,

      @UI:      {
                   lineItem: { position: 50, importance: #HIGH, type: #STANDARD },
                   dataPoint: { targetValueElement: 'PurReqnLifeCycleStatusName' },
                   textArrangement: #TEXT_ONLY
                }
      @ObjectModel.text.element:  [ 'PurReqnLifeCycleStatusName' ]
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @EndUserText.label: 'Status'
      cast( '' as abap.char( 2 ) )         as PurReqnLifeCycleStatus,

      @Semantics.text: true
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @EndUserText.label: 'Status'
      cast( '' as abap.char( 60 ) )        as PurReqnLifeCycleStatusName,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as PurReqnIsItemCrtnSupported,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as PurReqnIsLimitItemSupported,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as PurReqnIsStandardItemSupported,

      @UI:      {
                   lineItem: { position: 60, importance: #HIGH, type: #STANDARD },
                   dataPoint: { targetValueElement: 'PurReqnOriginDesc' },
                   textArrangement: #TEXT_ONLY
                }
      @ObjectModel.text.element:  [ 'PurReqnOriginDesc' ]
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      @EndUserText.label: 'Origin'
      //  cast ( '' as abap.char( 1 ) )                   as PurReqnOrigin,
      cast ( '' as estkz preserving type ) as PurReqnOrigin,

      @Semantics.text: true
      @ObjectModel.readOnly: true
      @EndUserText.label: 'Origin'
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast ( '' as abap.char( 60 ) )       as PurReqnOriginDesc,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast ( '' as abap.char(10) )         as WorkflowScenarioDefinition,
      /* Associations */
      //   _PurchaseReqnType,
      // _PurReqnLifeCycleStatus,
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as IsPurReqnOvrlRel,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as PurReqnHasCommitmentItem,

      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement : true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:CL_PURCHASEREQN_PROF_TRA_EXIT'
      cast( '' as xfeld )                  as PurReqnPriceIsHidden,

      @ObjectModel.association.type: #TO_COMPOSITION_CHILD
      _PurchaseReqnItem                    as _PurchaseReqnItem,

      //,@ObjectModel.association.type: #TO_COMPOSITION_CHILD
      //_PurchaseReqnLimitItem

      /* Associations */
      _PurchaseReqnCommitment

}
