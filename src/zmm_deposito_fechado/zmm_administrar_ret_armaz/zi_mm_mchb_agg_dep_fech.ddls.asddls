@AbapCatalog.sqlViewName: 'ZMCHBAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'nsdm_e_mard_agg para deposito fechado'
define view ZI_MM_MCHB_AGG_DEP_FECH
  as select from nsdm_e_mchb_agg as _mchb_agg
{
  key matnr,
  key werks,
  key lgort,
  key charg,
      cast( 0 as nsdm_stock_qty_l1 ) as AvalibleStock,
      stock_qty                      as AvalibleBlock
}
where
  lbbsa = '07'
union 
  select from nsdm_e_mchb_agg as _mchb_agg
{
  key matnr,
  key werks,
  key lgort,
  key charg,
      stock_qty as AvalibleStock,
      cast( 0 as nsdm_stock_qty_l1 )   as AvalibleBlock
}
where
  lbbsa = '01'
