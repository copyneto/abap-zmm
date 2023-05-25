@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento de material de transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_TRANSFERENCIA_MATDOC
  as select from    I_MaterialDocumentItem as _Matdoc

    left outer join I_MaterialDocumentItem as _DocumentReversal on  _DocumentReversal.ReversedMaterialDocument     = _Matdoc.MaterialDocument
                                                                and _DocumentReversal.ReversedMaterialDocumentYear = _Matdoc.MaterialDocumentYear
                                                                and _DocumentReversal.ReversedMaterialDocumentItem = _Matdoc.MaterialDocumentItem

    left outer join ztsd_ped_interco       as _Intercompany     on _Intercompany.pedido = _Matdoc.PurchaseOrder

    left outer join lips                   as _Remessa          on  _Remessa.vbeln = _Intercompany.remessa
                                                                and _Remessa.matnr = _Matdoc.Material

    left outer join vbfa                   as _SalesFlow        on  _SalesFlow.vbelv   = _Remessa.vbeln
                                                                and _SalesFlow.posnv   = _Remessa.posnr
                                                                and _SalesFlow.vbtyp_n = 'M'
{
  key _Matdoc.MaterialDocument,
  key _Matdoc.MaterialDocumentYear,
  key _Matdoc.MaterialDocumentItem,
  key case when _SalesFlow.vbeln is not initial
           then _SalesFlow.vbeln
           else concat(_Matdoc.MaterialDocument, _Matdoc.MaterialDocumentYear)
           end as Refkey,

  key case when _SalesFlow.posnn is not initial
           then _SalesFlow.posnn
           else cast( concat( '00', _Matdoc.MaterialDocumentItem) as abap.numc( 6 ))
           end as Refitem,

      case when _SalesFlow.vbeln is not initial
           then cast( 'H' as shkzg )
           else _Matdoc.DebitCreditCode
           end as DebitCreditCode,

      _Matdoc.Material,
      _Matdoc.PurchaseOrder,
      _Matdoc.PurchaseOrderItem,
      _Matdoc.GoodsMovementType,
      _Matdoc.DocumentDate,
      _Matdoc.Plant,
      _Matdoc.IssuingOrReceivingPlant,
      _Matdoc._PurchaseOrder.PurchaseOrderType,

      case when _DocumentReversal.MaterialDocument is not initial
           then cast( 'X' as boole_d )
           else cast( '' as boole_d )
           end as IsCancelled,

      case when _DocumentReversal.GoodsMovementType is not initial
           then _DocumentReversal.GoodsMovementType
           else cast( '' as bwart )
           end as ReversalGoodsMovementType

}
