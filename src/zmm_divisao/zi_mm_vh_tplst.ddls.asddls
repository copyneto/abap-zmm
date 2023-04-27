@AbapCatalog.sqlViewName: 'ZVMM_VH_TPLST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help TPLST'
define view ZI_MM_VH_TPLST as select from ztmm_divisao {
    key tplst as Tplst
}group by tplst
