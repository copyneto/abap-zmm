@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS busca BUKRS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_PHYSINVTRYDOCHEADER
  as select from I_PhysInvtryDocHeader as _P
  association to t001k as _T on _T.bwkey = $projection.Plant
{
  key PhysicalInventoryDocument,
  key FiscalYear,
      InventoryTransactionType,
      _T.bukrs as Bukrs,
      Plant,
      _Plant,
      _T

}
