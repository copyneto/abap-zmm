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
  as select from I_MaterialDocumentItem as _Matdoc
{
      /* -----------------------------------------------------------------------------------------------------------
         Chamado 8000007486 - Nova regra para exibir o último documento de material, independente de estar estornado
      --------------------------------------------------------------------------------------------------------------
         Chamado 8000007487 - Atualizado regra para funcionar com documentos 101, 861, 862
      ----------------------------------------------------------------------------------------------------------- */

  key _Matdoc.PurchaseOrder           as PurchaseOrder,
  key _Matdoc.PurchaseOrderItem       as PurchaseOrderItem,

      max( _Matdoc.MaterialDocument ) as MaterialDocument

}
where
     _Matdoc.GoodsMovementType = '101' -- EM entr.mercadorias
  or _Matdoc.GoodsMovementType = '861' -- EM TE SD/MM
  or _Matdoc.GoodsMovementType = '862' -- SM TE SD/MM

group by

  _Matdoc.PurchaseOrder,
  _Matdoc.PurchaseOrderItem
