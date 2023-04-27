@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ajuda de pesquisa para NF - Dep.Fechado'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define root view entity ZI_MM_VH_STATUS_NF_DEP_FECH
  as select from    dd07l as Domain
    left outer join dd07t as _Text on  _Text.domname    = Domain.domname
                                   and _Text.as4local   = Domain.as4local
                                   and _Text.valpos     = Domain.valpos
                                   and _Text.as4vers    = Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['TextoStatusNF']
      @Search.ranking: #MEDIUM
  key cast( Domain.domvalue_l as j_1bnfedocstatus ) as StatusNF,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.8
      //      case when Domain.domvalue_l is initial
      //        then ''
      //        else _Text.ddtext end                       as TextoStatusNF
      _Text.ddtext                                  as TextoStatusNF
}
where
      Domain.domname    = 'J_1BNFEDOCSTATUS'
  and Domain.as4local   = 'A'
  and Domain.domvalue_l is not initial;
