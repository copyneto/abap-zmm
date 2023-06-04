@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento de material de transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_TRANSFERENCIA_MATDOC_N
  as select from    I_MaterialDocumentItem         as _MatdocRef

  /* -----------------------------------------------------------------------------------------------------------
     Chamado 8000007486 - Nova regra para exibir o último documento de material, independente de estar estornado
  --------------------------------------------------------------------------------------------------------------
     Chamado 8000007487 - Atualizado regra para funcionar com documentos 101, 861, 862
  ----------------------------------------------------------------------------------------------------------- */
    left outer join ZI_MM_TRANSFERENCIA_MATDOC_101 as _Matdoc_101       on  _Matdoc_101.PurchaseOrder     = _MatdocRef.PurchaseOrder
                                                                        and _Matdoc_101.PurchaseOrderItem = _MatdocRef.PurchaseOrderItem

    left outer join I_MaterialDocumentItem         as _Matdoc           on  _Matdoc.MaterialDocumentYear = _Matdoc_101.MaterialDocumentYear
                                                                        and _Matdoc.MaterialDocument     = _Matdoc_101.MaterialDocument
                                                                        and _Matdoc.MaterialDocumentItem = _Matdoc_101.MaterialDocumentItem

    left outer join I_MaterialDocumentItem         as _DocumentReversal on  _DocumentReversal.ReversedMaterialDocument     = _Matdoc.MaterialDocument
                                                                        and _DocumentReversal.ReversedMaterialDocumentYear = _Matdoc.MaterialDocumentYear
                                                                        and _DocumentReversal.ReversedMaterialDocumentItem = _Matdoc.MaterialDocumentItem

    left outer join ztsd_ped_interco               as _Intercompany     on _Intercompany.pedido = _Matdoc.PurchaseOrder

    left outer join lips                           as _Remessa          on  _Remessa.vbeln = _Intercompany.remessa
                                                                        and _Remessa.matnr = _Matdoc.Material

    left outer join vbfa                           as _SalesFlow        on  _SalesFlow.vbelv   = _Remessa.vbeln
                                                                        and _SalesFlow.posnv   = _Remessa.posnr
                                                                        and _SalesFlow.vbtyp_n = 'M'
{
  key case when _SalesFlow.vbeln is not initial
           then _SalesFlow.vbeln
           else concat(_MatdocRef.MaterialDocument, _MatdocRef.MaterialDocumentYear)
           end                        as Refkey,

  key case when _SalesFlow.posnn is not initial
           then _SalesFlow.posnn
           else cast( concat( '00', _MatdocRef.MaterialDocumentItem) as abap.numc( 6 ))
           end                        as Refitem,

  key _Matdoc.Material,

      _MatdocRef.MaterialDocument     as RefMaterialDocument,
      _MatdocRef.MaterialDocumentYear as RefMaterialDocumentYear,
      _MatdocRef.MaterialDocumentItem as RefMaterialDocumentItem,

      _Matdoc.MaterialDocument,
      _Matdoc.MaterialDocumentYear,
      _Matdoc.MaterialDocumentItem,

      case when _SalesFlow.vbeln is not initial
           then cast( 'H' as shkzg )
           else _Matdoc.DebitCreditCode
           end                        as DebitCreditCode,

      _Matdoc.PurchaseOrder,
      _Matdoc.PurchaseOrderItem,
      _Matdoc.GoodsMovementType,

      case when _DocumentReversal.GoodsMovementType = '863'
             or _DocumentReversal.GoodsMovementType = '864'
             or _DocumentReversal.GoodsMovementType = '102'
           then cast( '00000000' as bldat )
      //           else _Matdoc.DocumentDate
           else _Matdoc.PostingDate
           end                        as DocumentDate,

      _Matdoc.Plant,
      _Matdoc.IssuingOrReceivingPlant,
      _Matdoc._PurchaseOrder.PurchaseOrderType,

      case when _DocumentReversal.MaterialDocument is not initial
            and _DocumentReversal.MaterialDocument is not null
           then cast( 'X' as boole_d )
           else cast( '' as boole_d )
           end                        as IsCancelled,

      case when _DocumentReversal.GoodsMovementType is not initial
            and _DocumentReversal.GoodsMovementType is not null
           then _DocumentReversal.GoodsMovementType
           else cast( '' as bwart )
           end                        as ReversalGoodsMovementType,

      case when _DocumentReversal.ReversedMaterialDocument is not initial
            and _DocumentReversal.ReversedMaterialDocument is not null
           then _DocumentReversal.ReversedMaterialDocument
           else cast( '' as nsdm_smbln )
           end                        as ReversedMaterialDocument,

      case when _DocumentReversal.ReversedMaterialDocumentYear is not initial
            and _DocumentReversal.ReversedMaterialDocumentYear is not null
           then _DocumentReversal.ReversedMaterialDocumentYear
           else cast( '' as nsdm_sjahr )
           end                        as ReversedMaterialDocumentYear,

      case when _DocumentReversal.ReversedMaterialDocumentItem is not initial
            and _DocumentReversal.ReversedMaterialDocumentItem is not null
           then _DocumentReversal.ReversedMaterialDocumentItem
           else cast( '' as nsdm_smblp )
           end                        as ReversedMaterialDocumentItem
}
