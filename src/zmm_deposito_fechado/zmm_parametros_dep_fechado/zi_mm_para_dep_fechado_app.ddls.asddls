@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Parâmetros Depósito Fechado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_PARA_DEP_FECHADO_APP
  as select from ztmm_prm_dep_fec

  association [0..1] to ZI_MM_VH_CENTRO         as _OriginPlant            on  _OriginPlant.Plant = $projection.OriginPlant
  association [0..1] to ZI_SD_VH_DF_TIPO_CENTRO as _OriginPlantType        on  _OriginPlantType.PlantType = $projection.OriginPlantType
  association [0..1] to ZI_CA_VH_DEPOSITO       as _OriginStorageLocation  on  _OriginStorageLocation.Werks = $projection.OriginPlant
                                                                           and _OriginStorageLocation.Lgort = $projection.OriginStorageLocation

  association [0..1] to ZI_MM_VH_CENTRO         as _DestinyPlant           on  _DestinyPlant.Plant = $projection.DestinyPlant
  association [0..1] to ZI_SD_VH_DF_TIPO_CENTRO as _DestinyPlantType       on  _DestinyPlantType.PlantType = $projection.DestinyPlantType
  association [0..1] to ZI_CA_VH_DEPOSITO       as _DestinyStorageLocation on  _DestinyStorageLocation.Werks = $projection.DestinyPlant
                                                                           and _DestinyStorageLocation.Lgort = $projection.DestinyStorageLocation
{
  key guid                            as Guid,
      description                     as Description,

      origin_plant                    as OriginPlant,
      _OriginPlant.PlantName          as OriginPlantName,

      case origin_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as OriginPlantCrit,

      origin_plant_type               as OriginPlantType,
      _OriginPlantType.PlantTypeText  as OriginPlantTypeName,

      case origin_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as OriginPlantTypeCrit,

      origin_storage_location         as OriginStorageLocation,
      _OriginStorageLocation.Lgobe    as OriginStorageLocationName,

      case origin_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as OriginStorageLocationCrit,

      destiny_plant                   as DestinyPlant,
      _DestinyPlant.PlantName         as DestinyPlantName,

      case destiny_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as DestinyPlantCrit,

      destiny_plant_type              as DestinyPlantType,
      _DestinyPlantType.PlantTypeText as DestinyPlantTypeName,

      case destiny_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as DestinyPlantTypeCrit,

      destiny_storage_location        as DestinyStorageLocation,
      _DestinyStorageLocation.Lgobe   as DestinyStorageLocationName,

      case destiny_plant_type
      when '01' then 1 -- Centro Depósito Fechado
      when '02' then 2 -- Centro Faturamento
      when '03' then 3 -- Centro Reserva
          else 0 end                  as DestinyStorageLocationCrit,

      @Semantics.user.createdBy: true
      created_by                      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                 as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                 as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at           as LocalLastChangedAt
}
