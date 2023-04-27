@AbapCatalog.sqlViewName: 'ZVMM_VH_GSBER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help GSBER'
define view ZI_MM_VH_Gsber as select from ztmm_divisao {
    key gsber as Gsber
} group by gsber
