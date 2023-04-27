@AbapCatalog.sqlViewName: 'ZVMMVHDOCSTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help - Status da Liberação'
@ObjectModel.resultSet.sizeCategory: #XS
define view ZI_MM_VH_DOC_STATUS
  as select from    dd07l as _Domain
    left outer join dd07t as _Text on  _Text.domname    = _Domain.domname
                                   and _Text.as4local   = _Domain.as4local
                                   and _Text.valpos     = _Domain.valpos
                                   and _Text.as4vers    = _Domain.as4vers
                                   and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['Texto']
      @UI.textArrangement: #TEXT_ONLY
  key _Domain.domvalue_l as Valor,
      _Text.ddtext       as Texto
}
where
      _Domain.as4local = 'A'
  and _Domain.domname  = 'ZD_DOC_STATUS'
