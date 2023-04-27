@AbapCatalog.sqlViewName: 'ZVMM_VH_COLCI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Colci'
define view ZI_MM_VH_COLCI as select from ztmm_coligada {
    key col_ci as ColCi
}group by col_ci
