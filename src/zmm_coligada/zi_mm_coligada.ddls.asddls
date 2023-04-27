@AbapCatalog.sqlViewName: 'ZVMMCOLIGADA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface'
define root view ZI_MM_COLIGADA as select from ztmm_coligada {
 key bukrs as Bukrs,
 key bupla as Bupla,
 key cgc as Cgc,
 key filial as Filial,
 kunnr as Kunnr,
 lifnr as Lifnr,
// filial as Filial,
 vkorg as Vkorg,
 col_ci as ColCi   
}
