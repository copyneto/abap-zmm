@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chave não duplicada para ordem e remessa'
define view entity ZI_MM_SINGLE_ORDEM_E_REMESSA
  as select from           /scmtms/d_torrot       as _OrdemFrete

    left outer join        /scmtms/d_torite       as _Entrega on  _Entrega.parent_key   = _OrdemFrete.db_key
                                                              and _Entrega.base_btd_tco = '73' -- Entrega

    left outer to one join I_DeliveryDocumentItem as _DocItem on _DocItem.DeliveryDocument = substring(
      _Entrega.base_btd_id, 26, 10
    )

{
  key _OrdemFrete.tor_id,
  key _Entrega.base_btd_id,
  key _DocItem.Material,
  key _DocItem.BaseUnit,
      _DocItem.ReferenceSDDocument,
      _DocItem.Plant,
      _DocItem.StorageLocation,
      _DocItem.Batch,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum( _DocItem.OriginalDeliveryQuantity ) as OriginalDeliveryQuantity
}
where
      _OrdemFrete.tor_id       is not initial
  and _OrdemFrete.tor_cat      = 'TO' -- Ordem de frete
  and _Entrega.base_btd_id     is not initial
  and _DocItem.Material        is not initial
  and _OrdemFrete.confirmation = '04' -- Confirmado
group by
  _OrdemFrete.tor_id,
  _Entrega.base_btd_id,
  _DocItem.Material,
  _DocItem.BaseUnit,
  _DocItem.ReferenceSDDocument,
  _DocItem.Plant,
  _DocItem.StorageLocation,
  _DocItem.Batch
