@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento de material de transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_TRANSFERENCIA_MATDOC_101
  as select from ZI_MM_TRANSFERENCIA_MATDOC_N_L as _Matdoc
{
      /* -----------------------------------------------------------------------------------------------------------
         Chamado 8000007486 - Nova regra para exibir o último documento de material, independente de estar estornado
      --------------------------------------------------------------------------------------------------------------
         Chamado 8000007487 - Atualizado regra para funcionar com documentos 101, 861, 862
      ----------------------------------------------------------------------------------------------------------- */

  key _Matdoc.PurchaseOrder                                              as PurchaseOrder,
  key _Matdoc.PurchaseOrderItem                                          as PurchaseOrderItem,

      cast( left( _Matdoc.MaterialDocument, 10 ) as mblnr )              as MaterialDocument,
      cast( substring( _Matdoc.MaterialDocument, 11, 4 ) as nsdm_mjahr ) as MaterialDocumentYear,
      cast( right( _Matdoc.MaterialDocument, 4 ) as nsdm_mblpo  )        as MaterialDocumentItem

}
