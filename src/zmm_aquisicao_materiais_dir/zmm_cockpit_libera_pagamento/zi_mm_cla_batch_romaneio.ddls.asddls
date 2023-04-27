@AbapCatalog.sqlViewName: 'ZVIMMROMANBATCH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Características Lotes Recebimento'
define view ZI_MM_CLA_BATCH_ROMANEIO
  as select distinct from I_BatchDistinct           as _Batch
    inner join            P_SpecCharacteristicValue as _Carac on _Carac.objek = _Batch.ClfnObjectInternalID
    inner join            ztmm_control_cla          as _Cla   on _Cla.ebeln = _Carac.CharacteristicValue
{
  key _Cla.ebeln as PurchaseOrder,
  key _Batch.Batch,
  key _Carac.objek

}
where
  _Carac.Characteristic = 'YGV_PEDIDO'

union

select from  I_BatchDistinct           as _Batch
  inner join P_SpecCharacteristicValue as _Carac    on _Carac.objek = _Batch.ClfnObjectInternalID
  inner join ztmm_romaneio_in          as _Romaneio on _Romaneio.ebeln = _Carac.CharacteristicValue
{
  key _Romaneio.ebeln as PurchaseOrder,
  key _Batch.Batch,
  key _Carac.objek

}
where
  _Carac.Characteristic = 'YGV_ORDEM'
