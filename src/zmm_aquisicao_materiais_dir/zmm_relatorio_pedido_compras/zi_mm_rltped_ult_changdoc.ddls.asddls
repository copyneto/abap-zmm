@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro do I_CHANGEDOCUMENT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_ULT_CHANGDOC
  as select from I_ChangeDocument
{
  key ChangeDocObjectClass,
  key ChangeDocObject,
  key max(ChangeDocument) as ChangeDocument
}
group by
  ChangeDocObjectClass,
  ChangeDocObject
