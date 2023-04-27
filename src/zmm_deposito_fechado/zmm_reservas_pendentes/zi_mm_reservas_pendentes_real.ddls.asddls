@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reservas Pendentes - Real Time Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESERVAS_PENDENTES_REAL
  as select from    ZI_MM_RESERVAS_PENDENTES_SUM as _ReservationDoc

    inner join      ZI_MM_DF_MATERIAL_UNIDADE    as _MaterialUnidade on  _MaterialUnidade.Material = _ReservationDoc.Material
                                                                     and _MaterialUnidade.Plant    = _ReservationDoc.Plant

    inner join      ztmm_prm_dep_fec             as _Configuracao    on  _Configuracao.origin_plant            = _ReservationDoc.Plant
                                                                     and _Configuracao.origin_storage_location = _ReservationDoc.StorageLocation

    left outer join ztmm_his_dep_fec             as _Historico       on  _Historico.material              = _ReservationDoc.Material
                                                                     and _Historico.plant                 = _ReservationDoc.Plant
                                                                     and _Historico.storage_location      = _ReservationDoc.StorageLocation
                                                                     and _Historico.plant_dest            = _Configuracao.destiny_plant
                                                                     and _Historico.storage_location_dest = _Configuracao.destiny_storage_location
                                                                     and _Historico.batch                 = _ReservationDoc.Batch
                                                                     and _Historico.delivery_document     = LTRIM( _ReservationDoc.Reservation, '0' )
                                                                     and _Historico.process_step          = 'F13'
                                                                     and _Historico.guid                  = hextobin( '00000000000000000000000000000000' )
{

  key _ReservationDoc.Reservation                     as Reservation, -- Reserva pendente
  key _Configuracao.guid                              as PrmDepFec,
  key _MaterialUnidade.EANType                        as EANType,
      _ReservationDoc.CreatedBy                       as CreatedBy, -- Criado por
      _ReservationDoc.Material                        as Material, -- Material
      _ReservationDoc.BaseUnit                        as BaseUnit, -- UMB
      _MaterialUnidade.Unit                           as Unit, -- UMB Destino
      _ReservationDoc.StorageLocation                 as StorageLocation, -- Depósito
      _ReservationDoc.Plant                           as Plant, -- Centro da reserva
      _ReservationDoc.Batch                           as Batch, 
      _ReservationDoc.CreationDateTime                as CreationDateTime, -- Data criação
      _Historico.use_available                        as UseAvailable,

      case when _Historico.status is not null
       then _Historico.status
       else '00' end                                  as StatusHistorico, -- Inicial
      
      @Semantics.quantity.unitOfMeasure: 'Unit'
      unit_conversion( quantity => _ReservationDoc.EstoqueReservaPendente,
                       source_unit => _MaterialUnidade.OriginUnit,
                       target_unit => _MaterialUnidade.Unit,
                       error_handling => 'SET_TO_NULL' ) as AvailableStock, // Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'Unit'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _ReservationDoc.EstoqueReservaPendente as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as AvailableStock_Conve,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Historico.used_stock                              as UsedStock,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.used_stock  as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp )  as UsedStock_conve,

      /* Campos de apoio - Histórico */

      hextobin( '00000000000000000000000000000000' )  as Guid,
      _Configuracao.guid                              as PrmDepFecId,
      _Configuracao.description                       as Description,
      _Configuracao.origin_plant_type                 as OriginPlantType,
      _Configuracao.destiny_plant                     as DestinyPlant,
      _Configuracao.destiny_plant_type                as DestinyPlantType,
      _Configuracao.destiny_storage_location          as DestinyStorageLocation,

      _Historico.carrier                              as Transportador,
      _Historico.driver                               as Driver,
      _Historico.equipment                            as Equipment,
      _Historico.shipping_conditions                  as Shipping_conditions,
      _Historico.shipping_type                        as Shipping_type,
      _Historico.equipment_tow1                       as Equipment_tow1,
      _Historico.equipment_tow2                       as Equipment_tow2,
      _Historico.equipment_tow3                       as Equipment_tow3,
      _Historico.freight_mode                         as Freight_mode,
      cast( _Historico.used_stock as abap.dec(13,3) ) as NewUsedStock

}
