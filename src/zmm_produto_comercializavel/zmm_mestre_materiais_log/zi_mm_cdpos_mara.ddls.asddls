@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Modificações tabela MARA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CDPOS_MARA
  as select from cdpos

    inner join   mara on mara.matnr = substring(
      cdpos.tabkey, 4, 40
    )
{
  key cdpos.objectclas,
  key cdpos.objectid,
  key cdpos.changenr,
  key cdpos.tabname,
  key cdpos.tabkey,
  key cast( substring(cdpos.tabkey,4,40) as char40 ) as matnr,
  key cdpos.fname,
  key cdpos.chngind,
      cdpos.text_case,
      cdpos.unit_old,
      cdpos.unit_new,
      cdpos.cuky_old,
      cdpos.cuky_new,
      cdpos.value_new,
      cdpos.value_old,
      cdpos._dataaging
}
where
      cdpos.objectclas = 'MATERIAL'
  and cdpos.tabname    = 'MARA'
