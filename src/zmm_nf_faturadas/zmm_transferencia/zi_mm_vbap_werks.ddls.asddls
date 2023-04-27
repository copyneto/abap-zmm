@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Centro da VBAP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_vbap_werks as select from vbap {
  key vbeln,
      werks,
      kunnr_ana,
      bstkd_ana
} group by vbeln, werks, kunnr_ana, bstkd_ana
