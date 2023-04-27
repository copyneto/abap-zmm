@AbapCatalog.sqlViewName: 'ZVMM_PARAM_GOODM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetro GoodsMovement'
define view ZI_MM_PARAM_MOVEMENT
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(3) ) as TpMov
}
where
      modulo = 'MM'
  and chave1 = 'GRAOVERDE'
  and chave2 = 'REL_DEVOL'
  and chave3 = 'BWART'
