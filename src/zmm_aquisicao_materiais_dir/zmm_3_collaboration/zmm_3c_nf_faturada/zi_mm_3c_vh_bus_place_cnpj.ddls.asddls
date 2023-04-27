@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Local Negócio CNPJ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_3C_VH_BUS_PLACE_CNPJ
  as select from I_BR_NFDocument as NF

    inner join   lfa1            as _LFA1 on _LFA1.stcd1 = NF.BR_BusinessPlaceCNPJ

{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key NF.BR_BusinessPlaceCNPJ,
      _LFA1.lifnr as BR_BusinessPlace,
      _LFA1.name1 as BR_BusinessPlaceName1
}
where
  NF.BR_BusinessPlaceCNPJ is not initial
group by
  NF.BR_BusinessPlaceCNPJ,
  _LFA1.lifnr,
  _LFA1.name1
