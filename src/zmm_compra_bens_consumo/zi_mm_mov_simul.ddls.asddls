@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Controle de Mercadoria'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MOV_SIMUL
  as select from ztmm_mov_simul
  //association to parent ZI_MM_MOV_CNTRL as _MovCntrl on $projection.IdMov = _MovCntrl.Id
{
  key id          as Id,
  key id_mov      as IdMov,
      netpr       as Netpr,
      taxtyp_icm3 as TaxtypIcm3,
      @Semantics.amount.currencyCode : 'Currency'
      base_bx13   as BaseBx13,
      rate_bx13   as RateBx13,
      @Semantics.amount.currencyCode : 'Currency'
      taxval_bx13 as TaxvalBx13,
      taxtyp_ipi3 as TaxtypIpi3,
      @Semantics.amount.currencyCode : 'Currency'
      base_ipva   as BaseIpva,
      rate_ipva   as RateIpva,
      @Semantics.amount.currencyCode : 'Currency'
      taxval_bx23 as TaxvalBx23,
      taxtyp_ipis as TaxtypIpis,
      @Semantics.amount.currencyCode : 'Currency'
      base_bpi1   as BaseBpi1,
      rate_bx82   as RateBx82,
      @Semantics.amount.currencyCode : 'Currency'
      taxval_bx82 as TaxvalBx82,
      taxtyp_icof as TaxtypIcof,
      @Semantics.amount.currencyCode : 'Currency'
      base_bco1   as BaseBco1,
      rate_bx72   as RateBx72,
      @Semantics.amount.currencyCode : 'Currency'
      taxval_bx72 as TaxvalBx72,
      netpr_final as NetprFinal,
      waers       as Currency
}
