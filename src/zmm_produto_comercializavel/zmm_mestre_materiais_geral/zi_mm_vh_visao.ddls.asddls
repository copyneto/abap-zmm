@AbapCatalog.sqlViewName: 'ZVMM_VISAO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.resultSet.sizeCategory: #XS
@EndUserText.label: 'CDS View para Visão'
@ObjectModel.dataCategory: #TEXT
define view ZI_MM_VH_VISAO
  as select from dd07l as Visao
    join         dd07t as Text on  Text.domname  = Visao.domname
                               and Text.as4local = Visao.as4local
                               and Text.valpos   = Visao.valpos
                               and Text.as4vers  = Visao.as4vers

  association [0..1] to I_Language as _Language on $projection.Language = _Language.Language
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['VisionName']
  key cast ( substring( Visao.domvalue_l, 1, 1 ) as ze_visao preserving type ) as VisionId,

      @Semantics.language: true
  key cast( Text.ddlanguage as spras preserving type )                         as Language,

      @UI.hidden: true
      substring ( Text.ddtext, 1, 60 )                                         as VisionName,

      _Language
}
where
      Visao.domname  = 'ZD_VISAO'
  and Visao.as4local = 'A'
