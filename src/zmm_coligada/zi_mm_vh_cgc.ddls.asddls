@AbapCatalog.sqlViewName: 'ZVMM_VH_CGC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help CGC'
define view ZI_MM_VH_CGC as select from ztmm_coligada {
    key cgc as Cgc
}group by cgc
