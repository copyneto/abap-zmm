@AbapCatalog.sqlViewName: 'ZVMM_STATUS_NF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help para Status NF'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_MM_VH_STATUS_NF as select from dd07l as Status
    join         dd07t as Text on  Text.domname  = Status.domname
                               and Text.as4local = Status.as4local
                               and Text.valpos   = Status.valpos
                               and Text.as4vers  = Status.as4vers

  association [0..1] to I_Language as _Language on $projection.Language = _Language.Language
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['StatusName']
  key cast ( substring( Status.domvalue_l, 1, 1 ) as ze_status_rfb preserving type ) as StatusId,

      @Semantics.language: true
  key cast( Text.ddlanguage as spras preserving type )                               as Language,

      @UI.hidden: true
      substring ( Text.ddtext, 1, 60 )                                               as StatusName,

      _Language
}
where
      Status.domname  = 'ZD_STATUS_NF'
  and Status.as4local = 'A'
  
