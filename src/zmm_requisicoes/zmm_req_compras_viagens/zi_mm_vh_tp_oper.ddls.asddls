@AbapCatalog.sqlViewName: 'ZIMM_TP_OPER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Tipo Operação'
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view ZI_MM_VH_TP_OPER
  as select from dd07t as Domain
{
      @UI.hidden: true
  key domname           as Domname,
      @UI.hidden: true
  key ddlanguage        as Ddlanguage,
      @UI.hidden: true
  key as4local          as As4local,
      @UI.hidden: true
  key valpos            as Valpos,
      @UI.hidden: true
  key as4vers           as As4vers,
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Domain.domvalue_l as Code,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      Domain.ddtext     as Text


}
where
      Domain.domname    = 'ZD_TIPO_OPERACAO'
  and Domain.ddlanguage = $session.system_language;
