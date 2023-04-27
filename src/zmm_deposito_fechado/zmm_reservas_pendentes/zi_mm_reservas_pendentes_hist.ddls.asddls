@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reservas Pendentes - Historic Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESERVAS_PENDENTES_HIST
  as select from ztmm_his_dep_fec          as _Historico

    inner join   ZI_MM_DF_MATERIAL_UNIDADE as _MaterialUnidade on  _MaterialUnidade.Material = _Historico.material
                                                               and _MaterialUnidade.Plant    = _Historico.plant
{
  key _Historico.delivery_document                      as Reservation,
  key _Historico.prm_dep_fec_id                         as PrmDepFec,
  key _Historico.ean_type                               as EANType,
      _Historico.created_by                             as CreatedBy,
      _Historico.material                               as Material,
      _MaterialUnidade.OriginUnit                       as BaseUnit,
      _MaterialUnidade.Unit,
      _Historico.storage_location                       as StorageLocation,
      _Historico.plant                                  as Plant,
      _Historico.batch                                  as Batch,
      _Historico.created_at                             as CreationDateTime,
      _Historico.use_available                          as UseAvailable,
      _Historico.status                                 as StatusHistorico,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Historico.available_stock                        as AvailableStock, //Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'Unit'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.available_stock as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as AvailableStock_Conve,

      @Semantics.quantity.unitOfMeasure: 'Unit'
      _Historico.used_stock                             as UsedStock, //Estoque livre utilização

      @Semantics.quantity.unitOfMeasure: 'Unit'
      ( cast( _MaterialUnidade.Marmumren as abap.fltp )
      * cast( _Historico.used_stock  as abap.fltp ) )
      / cast( _MaterialUnidade.MarmUmrez as abap.fltp ) as UsedStock_conve,

      /* Campos de apoio - Histórico */

      _Historico.guid                                   as Guid,
      _Historico.guid                                   as PrmDepFecId,
      _Historico.description                            as Description,
      _Historico.origin_plant_type                      as OriginPlantType,
      _Historico.plant_dest                             as DestinyPlant,
      _Historico.destiny_plant_type                     as DestinyPlantType,
      _Historico.storage_location_dest                  as DestinyStorageLocation,

      _Historico.carrier                                as Transportador,
      _Historico.driver                                 as Driver,
      _Historico.equipment                              as Equipment,
      _Historico.shipping_conditions                    as Shipping_conditions,
      _Historico.shipping_type                          as Shipping_type,
      _Historico.equipment_tow1                         as Equipment_tow1,
      _Historico.equipment_tow2                         as Equipment_tow2,
      _Historico.equipment_tow3                         as Equipment_tow3,
      _Historico.freight_mode                           as Freight_mode,
      cast( _Historico.used_stock as abap.dec(13,3) )   as NewUsedStock

}
where
      _Historico.process_step = 'F13'
  and _Historico.guid != hextobin('00000000000000000000000000000000')
