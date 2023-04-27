@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Veículo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_DF_VEICULO
  as select from    equi as Equipment
    left outer join eqkt as _Text on  _Text.equnr = Equipment.equnr
                                  and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['EquipmentText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Equipment.equnr as Equipment,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.eqktx     as EquipmentText

}
where
    Equipment.eqtyp = 'J'
or Equipment.eqtyp = 'K'
or Equipment.eqtyp = 'T'
