@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do Historico'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ORDENS_FRETE_HIST
  as select from           ztmm_his_dep_fec          as _Historico
    inner join             /scmtms/d_torrot          as _OrdemFrete      on _OrdemFrete.tor_id = _Historico.freight_order_id
    left outer join        /scmtms/d_torite          as _Entrega         on  _Entrega.parent_key   = _OrdemFrete.db_key
                                                                         and _Entrega.base_btd_tco = '73' -- Entrega

    left outer to one join /scmtms/d_torrot          as _UnidadeFrete    on  _UnidadeFrete.db_key  = _Entrega.fu_root_key
                                                                         and _UnidadeFrete.tor_cat = 'FU' -- Unidade de Frete

    left outer to one join I_DeliveryDocumentItem    as _DocItem         on _DocItem.DeliveryDocument = substring( _Entrega.base_btd_id, 26, 10 )

    left outer join        I_SalesOrder              as _SalesOrder      on _SalesOrder.SalesOrder = _DocItem.ReferenceSDDocument

    inner join             ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Historico.material
                                                                         and _MaterialUnidade.Plant    = _Historico.plant
{
  key _Historico.freight_order_id                       as NumeroOrdemDeFrete, //Nº ordem de frete
  key _Historico.delivery_document                      as NumeroDaRemessa, //Nº da remessa
  key _Historico.material                               as Material,        //MATERIAL
      //Texto breve do material -- VH
  key _Historico.origin_unit                            as UmbOrigin, //UMB Origin
  key _Historico.unit                                   as UmbDestino, //UMB Destino
  key _Historico.plant                                  as CentroRemessa, //Centro remessa
  key _Historico.storage_location                       as Deposito, //Depósito
  key _Historico.batch                                  as Lote,
  key _Historico.destiny_plant                          as CentroDestino, //Centro remessa
  key _Historico.destiny_storage_location               as DepositoDestino, //Depósito
  key _Historico.prm_dep_fec_id                         as PrmDepFecId,    
  key _Historico.ean_type                               as EANType,
      //Denominação do depósito -- VH
      _SalesOrder.SoldToParty, //Código cliente
      //Nome cliente -- VH
      _OrdemFrete.confirmation                          as Status, //Status da ordem de frete
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.available_stock                        as EstoqueRemessaOF, //Estoque em remessa com OF
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.used_stock                             as UtilizacaoLivre, //Utilização livre
      _Historico.use_available                          as UseAvailable,

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.available_stock                        as AvailableStock,  //Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.available_stock as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as AvailableStock_Conve,

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.used_stock                             as UsedStock, //Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.used_stock  as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as UsedStock_conve,

      case when _Historico.status is not null
      then _Historico.status
      else '00' end                                     as StatusHistorico, -- Inicial

      _Historico.guid                                   as Guid,
      _Historico.description                            as Description,
      _Historico.origin_plant_type                      as OriginPlantType,
      _Historico.destiny_plant                          as DestinyPlant,
      _Historico.destiny_plant_type                     as DestinyPlantType,
      _Historico.destiny_storage_location               as DestinyStorageLocation

}
where
      _Historico.process_step = 'F12'
  and _Historico.guid != hextobin('00000000000000000000000000000000')
