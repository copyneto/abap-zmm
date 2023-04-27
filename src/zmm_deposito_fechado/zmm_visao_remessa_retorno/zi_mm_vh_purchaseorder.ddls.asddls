@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nome do usuário'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_PurchaseOrder as select from 
  ztmm_his_dep_fec as _ztmm_his_dep_fec 
{

 key _ztmm_his_dep_fec.purchase_order as PurchaseOrder
 
}
where _ztmm_his_dep_fec.purchase_order is not initial
