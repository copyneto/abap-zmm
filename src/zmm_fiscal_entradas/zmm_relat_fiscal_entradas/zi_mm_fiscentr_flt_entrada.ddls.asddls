@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_MM_FISCENTR_FLT_ENTRADA
  as select from dd07t
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['Descr']
  key domvalue_l as Entrad,
      ddtext     as Descr

}
where
      domname    = 'ZD_MM_ENTRAD'
  and ddlanguage = $session.system_language
