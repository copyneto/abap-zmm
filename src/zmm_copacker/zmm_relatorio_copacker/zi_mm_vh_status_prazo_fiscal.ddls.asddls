@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Status Prazo Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_VH_STATUS_PRAZO_FISCAL
  as select from dd07l as Dominio
    join         dd07t as Text on  Text.domname  = Dominio.domname
                               and Text.as4local = Dominio.as4local
                               and Text.valpos   = Dominio.valpos
                               and Text.as4vers  = Dominio.as4vers

  association [0..1] to I_Language as _Language on $projection.Language = _Language.Language
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['Valor']
  key cast ( substring( Dominio.domvalue_l, 1, 1 ) as ze_status_pfiscal preserving type ) as Id,

      @Semantics.language: true
  key cast( Text.ddlanguage as spras preserving type )                                    as Language,

      @UI.hidden: true
      substring ( Text.ddtext, 1, 60 )                                                    as Valor,

      _Language
}
where
      Dominio.domname  = 'ZD_PRAZO_FISCAL'
  and Dominio.as4local = 'A'
