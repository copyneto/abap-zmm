@AbapCatalog.sqlViewName: 'ZVMARAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'nsdm_e_mard_agg para deposito fechado'
define view ZI_MM_MARD_ARMAZENAGEM_AGR as select from zi_mm_mard_armazenagem
{
key matnr, 
key werks, 
key lgort,
key charg,

sum(AvalibleStock) as AvalibleStock,
sum(AvalibleBlock) as AvalibleBlock
}
group by matnr, werks, lgort, charg
