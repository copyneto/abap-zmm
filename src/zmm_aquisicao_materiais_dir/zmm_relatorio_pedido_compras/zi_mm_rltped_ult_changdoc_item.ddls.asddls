@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro do I_ChangeDocumentItem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RLTPED_ULT_CHANGDOC_ITEM
  as select from I_ChangeDocumentItem
{
  key ChangeDocObjectClass,
  key ChangeDocObject,
  key max(ChangeDocument) as ChangeDocument
}
where
      ChangeDocObjectClass        = 'EINKBELEG'
  and DatabaseTable               = 'EKKO'
  and ChangeDocDatabaseTableField = 'PROCSTAT'
  and ChangeDocNewFieldValue      = '05'
  and ChangeDocPreviousFieldValue = '03'
group by
  ChangeDocObjectClass,
  ChangeDocObject
