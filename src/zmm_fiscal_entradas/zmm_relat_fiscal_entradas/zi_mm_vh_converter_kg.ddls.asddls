@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Boolean'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_VH_CONVERTER_KG
  as select from dd07l as Objeto
    join         dd07t as Text on  Text.domname    = Objeto.domname
                               and Text.as4local   = Objeto.as4local
                               and Text.valpos     = Objeto.valpos
                               and Text.as4vers    = Objeto.as4vers
                               and Text.ddlanguage = $session.system_language
{
  key Text.ddtext                                                            as ObjetoName,
      @Semantics.language: true
  key cast( Text.ddlanguage as spras preserving type )                       as Language,
      cast ( substring( Objeto.domvalue_l, 1, 1 ) as xfeld preserving type ) as ObjetoId
}
where
      Objeto.domname  = 'FOPC_B_YNBOOL'
  and Objeto.as4local = 'A'
