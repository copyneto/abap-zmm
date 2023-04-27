@AbapCatalog.sqlViewName: 'ZVMM_LOG_MVKE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log Modificação Dados de Venda Material'
define view ZI_MM_CDPOS_MVKE_MAT as select from cdpos {
    key objectclas,
    key objectid,
    key changenr,
    key tabname,
    key tabkey,
    key cast( substring(tabkey,4,40) as char40 ) as matnr,
    key cast( substring(tabkey,44,4) as char4 ) as vkorg,
    key cast( substring(tabkey,48,2) as char2 ) as vtweg,
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
where objectclas = 'MATERIAL'
  and tabname    = 'MVKE'
