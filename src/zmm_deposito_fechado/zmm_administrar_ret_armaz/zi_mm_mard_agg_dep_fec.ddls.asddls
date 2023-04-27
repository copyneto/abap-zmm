@AbapCatalog.sqlViewName: 'ZMM_ARDAGG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Deposito Fechado'
define view ZI_MM_mard_agg_DEP_FEC   as select from nsdm_e_mard_agg as _mard_agg
   left outer join nsdm_e_mchb_agg as _mchb_agg on _mard_agg.matnr = _mchb_agg.matnr
                             and _mard_agg.werks = _mchb_agg.werks
                             and _mard_agg.lgort = _mchb_agg.lgort     
{
  key _mard_agg.matnr,
  key _mard_agg.werks,
  key _mard_agg.lgort,
  key coalesce( _mchb_agg.charg, '' )      as charg,

      _mard_agg.stock_qty                      as AvalibleStock,
      cast( 0 as nsdm_stock_qty_l1 ) as AvalibleBlock
}
where
  _mard_agg.lbbsa = '01'
union select from nsdm_e_mard_agg as _mard_agg
  left outer join nsdm_e_mchb_agg as _mchb_agg on _mard_agg.matnr = _mchb_agg.matnr
                                               and _mard_agg.werks = _mchb_agg.werks
                                               and _mard_agg.lgort = _mchb_agg.lgort     
{
  key _mard_agg.matnr,
  key _mard_agg.werks,
  key _mard_agg.lgort,
  key coalesce( _mchb_agg.charg, '' )      as charg,

      cast( 0 as nsdm_stock_qty_l1 ) as AvalibleStock,
      _mard_agg.stock_qty                      as AvalibleBlock
}
where
  _mard_agg.lbbsa = '07'
