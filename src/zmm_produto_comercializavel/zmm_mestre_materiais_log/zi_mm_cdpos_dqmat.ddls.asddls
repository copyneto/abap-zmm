@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Modificações visão DQMAT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CDPOS_DQMAT
  as select from cdpos
{
  key objectclas,
  key objectid,
  key changenr,
  key tabname,
  key tabkey,
  key cast( substring(tabkey,1,4) as char4 ) as werks,
      //  key cast( substring(tabkey,44,4) as char4 )  as werks,
  key fname,
  key chngind,
      text_case,
      unit_old,
      unit_new,
      cuky_old,
      cuky_new,
      value_new,
      value_old,
      _dataaging
}
where
      objectclas = 'MATERIAL'
  and tabname    = 'DQMAT'
