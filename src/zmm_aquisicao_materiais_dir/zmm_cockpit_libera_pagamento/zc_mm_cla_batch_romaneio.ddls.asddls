@AbapCatalog.sqlViewName: 'ZVCMMROMANBATCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Características Lotes Recebimento'
define view ZC_MM_CLA_BATCH_ROMANEIO
  as select from ZI_MM_CLA_BATCH_ROMANEIO as _Batch
  association [1] to ZTB_MM_BATCH_CHARACTERISTC as _Carac on _Carac.objek = _Batch.objek
{
  key PurchaseOrder,
  key Batch,
  key objek,
      _Carac.Characteristic,
      cast( _Carac.CharacteristicValue as abap.fltp ) as CharacteristicValue,

      _Carac
}
where
  _Carac.CharacteristicValue <> 0.0
