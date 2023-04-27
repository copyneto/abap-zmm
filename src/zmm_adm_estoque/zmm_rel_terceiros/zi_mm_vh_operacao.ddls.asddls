@AbapCatalog.sqlViewName: 'ZVMM_OPERACAO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_MM_VH_OPERACAO
  as select from dd07l as Base
    join         dd07t as Text on  Text.domname  = Base.domname
                               and Text.as4local = Base.as4local
                               and Text.valpos   = Base.valpos
                               and Text.as4vers  = Base.as4vers

  association [0..1] to I_Language as _Language on $projection.Language = _Language.Language
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['Descricao']
  key cast ( substring( Base.domvalue_l, 1, 1 ) as ze_operacao preserving type ) as Operacao,

      @Semantics.language: true
      @UI.hidden: true
  key cast( Text.ddlanguage as spras preserving type )                             as Language,

      @UI.hidden: true
      substring ( Text.ddtext, 1, 60 )                                             as Descricao,

      // Association
      _Language
}
where
      Base.domname  = 'ZD_OPERACAO'
  and Base.as4local = 'A'
