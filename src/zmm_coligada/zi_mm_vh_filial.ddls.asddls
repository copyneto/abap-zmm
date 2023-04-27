@AbapCatalog.sqlViewName: 'ZVMM_VH_FILIAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help Filial'
define view ZI_MM_VH_FILIAL as select from ztmm_coligada {
    key filial as Filial
}group by filial
