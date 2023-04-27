@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS inventário para Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTARIO_H_INV
  as select from ztmm_inventory_i
{
  key documentid         as Documentid,
      max(physinventory) as Physinventory

}
group by
  documentid
