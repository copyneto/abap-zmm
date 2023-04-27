@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Visão Remessa e Retorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_NUM_TRANSPORTE
  as select from    /scmtms/d_torrot as _OrdemFrete -- Referência: C_FrtUnitGenDataBasicFacts

    left outer join /scmtms/d_torite as _Entrega on  _Entrega.parent_key   = _OrdemFrete.db_key
                                                 and _Entrega.base_btd_tco = '73' -- Entrega

{
  key substring(_Entrega.base_btd_id, 26, 10) as OutDeliveryDocument,
      _OrdemFrete.db_key                      as KeyNumTransporte,
      _OrdemFrete.tor_id                      as NumTransporte

}
where 
      _Entrega.base_btd_id is not initial
  and _OrdemFrete.tor_id  is not initial
  and _OrdemFrete.tor_cat = 'TO' -- Ordem de frete

group by
  _Entrega.base_btd_id,
  _OrdemFrete.db_key,
  _OrdemFrete.tor_id
