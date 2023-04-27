@AbapCatalog.sqlViewName: 'ZVMARDAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'nsdm_e_mard_agg para deposito fechado'
define view zi_mm_mard_armazenagem
  as select from ZI_MM_mard_agg_DEP_FEC as _mard_agg
{
key matnr,
key werks,
key lgort,
key charg,
AvalibleStock,
AvalibleBlock
}
where
  charg is initial
union select from ZI_MM_MCHB_AGG_DEP_FECH as _MCHB_agg
{
key matnr,
key werks,
key lgort,
key charg,
AvalibleStock,
AvalibleBlock
}
