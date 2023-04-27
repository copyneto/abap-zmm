@AbapCatalog.sqlViewName: 'ZVMM_ORD_FRETE'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Armazenagem'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true

define view ZI_MM_ORDENS_FRETE_PENDENTE
  as select from    ZI_MM_SINGLE_ORDEM_E_REMESSA as _Base

    left outer join /scmtms/d_torrot             as _OrdemFrete      on _Base.tor_id = _OrdemFrete.tor_id


    left outer join I_SalesOrder                 as _SalesOrder      on _SalesOrder.SalesOrder = _Base.ReferenceSDDocument

    inner join      ztmm_prm_dep_fec             as _Configuracao    on  _Configuracao.origin_plant            = _Base.Plant
                                                                     and _Configuracao.origin_storage_location = _Base.StorageLocation

    inner join      mard                         as _Mard            on  _Mard.matnr = _Base.Material
                                                                     and _Mard.werks = _Base.Plant
                                                                     and _Mard.lgort = _Base.StorageLocation

    inner join      ZI_MM_DF_MATERIAL_UNIDADE    as _MaterialUnidade on  _MaterialUnidade.Material = _Base.Material
                                                                     and _MaterialUnidade.Plant    = _Base.Plant

    left outer join ztmm_his_dep_fec             as _Historico       on  _Historico.material              = _Base.Material
                                                                     and _Historico.plant                 = _Base.Plant
                                                                     and _Historico.storage_location      = _Mard.lgort
                                                                     and _Historico.plant_dest            = _Configuracao.destiny_plant
                                                                     and _Historico.storage_location_dest = _Configuracao.destiny_storage_location
                                                                     and _Historico.batch                 = _Base.Batch
                                                                     and _Historico.freight_order_id      = _OrdemFrete.tor_id
                                                                     and _Historico.delivery_document     = LTRIM( _Base.base_btd_id, '0' )
                                                                     and _Historico.process_step          = 'F12'
                                                                     and _Historico.guid                  = hextobin( '00000000000000000000000000000000' )
{
  key _OrdemFrete.tor_id                                 as NumeroOrdemDeFrete, // Nº ordem de frete
  key _Base.base_btd_id                                  as NumeroDaRemessa,    // Nº da remessa
  key _Base.Material                                     as Material,           // MATERIAL
      //Texto breve do material -- VH
  key _MaterialUnidade.OriginUnit                        as UmbOrigin,          // UMB Origin
  key _MaterialUnidade.Unit                              as UmbDestino,         // UMB Destino
  key _Base.Plant                                        as CentroRemessa,      // Centro remessa
  key _Base.StorageLocation                              as Deposito, // Depósito
  key _Base.Batch                                        as Lote,
  key _Configuracao.destiny_plant                        as CentroDestino,
  key _Configuracao.destiny_storage_location             as DepositoDestino,
  key _Configuracao.guid                                 as PrmDepFecId,    
  key _MaterialUnidade.EANType                           as EANType,
      //Denominação do depósito -- VH
      _SalesOrder.SoldToParty, //Código cliente
      //Nome cliente -- VH
      _OrdemFrete.confirmation                           as Status,             // Status da ordem de frete
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Base.OriginalDeliveryQuantity                     as EstoqueRemessaOF,   // Estoque em remessa com OF
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Mard.labst                                        as UtilizacaoLivre, // Utilização livre
      _Historico.use_available                           as UseAvailable,
      case when _Historico.status is not null
       then _Historico.status
       else '00' end                                     as StatusHistorico, -- Inicial

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      unit_conversion( quantity => _Base.OriginalDeliveryQuantity,
                       source_unit => _MaterialUnidade.OriginUnit,
                       target_unit => _MaterialUnidade.Unit,
                       error_handling => 'SET_TO_NULL' ) as AvailableStock, // Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Base.OriginalDeliveryQuantity as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as AvailableStock_Conve,

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.used_stock                              as UsedStock,

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.used_stock  as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as UsedStock_conve,

      hextobin( '00000000000000000000000000000000' )     as Guid,
      _Configuracao.description                          as Description,
      _Configuracao.origin_plant_type                    as OriginPlantType,
      _Configuracao.destiny_plant                        as DestinyPlant,
      _Configuracao.destiny_plant_type                   as DestinyPlantType,
      _Configuracao.destiny_storage_location             as DestinyStorageLocation
}
