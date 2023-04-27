@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: NF Replicação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_REP_NOTA_FISCAL
  as select from ztmm_his_dep_fec
{
      @EndUserText.label: 'Spool NFE'
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key rep_br_nota_fiscal as RepBrNotaFiscal
}
where
  rep_br_nota_fiscal is not initial
group by
  rep_br_nota_fiscal
