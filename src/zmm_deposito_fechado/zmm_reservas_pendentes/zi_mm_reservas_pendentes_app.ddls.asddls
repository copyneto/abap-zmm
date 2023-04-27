@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reservas Pendentes - Principal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_RESERVAS_PENDENTES_APP
  as select from ZI_MM_RESERVAS_PENDENTES_UNION as _App
 
  association [0..1] to ZI_MM_VH_DF_TIPO_EAN as _EANType                on  _EANType.EANType = $projection.EANType


  association [1..1] to mard                 as _Mard                   on  _Mard.matnr = _App.Material
                                                                        and _Mard.werks = _App.Plant
                                                                        and _Mard.lgort = _App.StorageLocation 

  association [0..1] to ZI_CA_VH_MATERIAL    as _Material               on  _Material.Material = $projection.Material

  association [0..1] to ZI_CA_VH_WERKS       as _OriginPlant            on  _OriginPlant.WerksCode = $projection.Plant

  association [0..1] to ZI_CA_VH_LGORT       as _OriginStorageLocation  on  _OriginStorageLocation.Plant           = $projection.Plant
                                                                        and _OriginStorageLocation.StorageLocation = $projection.StorageLocation

  association [0..1] to ZI_CA_VH_WERKS       as _DestinyPlant           on  _DestinyPlant.WerksCode = $projection.DestinyPlant

  association [0..1] to ZI_CA_VH_LGORT       as _DestinyStorageLocation on  _DestinyStorageLocation.Plant           = $projection.DestinyPlant
                                                                        and _DestinyStorageLocation.StorageLocation = $projection.DestinyStorageLocation

  association [0..1] to ZI_MM_VH_DF_STATUS   as _StatusHistorico        on  _StatusHistorico.Status = $projection.StatusHistorico

{
  key _App.Reservation, 
  key _App.PrmDepFec, 
  key _App.EANType,
  key _App.DadosDoHistorico,

      _EANType.EANTypeText                                                       as EANTypeText,

      _App.CreatedBy,
      _App.Material,
      _Material.Text                                                             as MaterialText,
      _App.BaseUnit,
      _App.Unit,
      _App.StorageLocation,
      _OriginStorageLocation.StorageLocationText                                 as DepositoText,
      _App.Plant,
      _App.Batch,
      _OriginPlant.WerksCodeName                                                 as PlantName,
      _App.CreationDateTime,
      _App.UseAvailable,

      UseAvailable                                                               as UseAvailableCheckBox,

      cast( case StatusHistorico
      when '00' then 'X' -- Inicial
      when '01' then 'X' -- Em processamento
      when '02' then ''  -- Incompleto
      when '03' then ''  -- Completo
      when '04' then ''  -- Aguardando job Entrada Mercadoria
      when '05' then ''  -- Nota Rejeitada pela SEFAZ
      when '06' then ''  -- Erro na composição da Nota
      when '07' then ''  -- Em trânsito
                else 'X'
      end as boole_d )                                                           as UseAvailableCheckBoxEnable,

      _App.StatusHistorico,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      _Mard.labst                                                                as UtilizacaoLivre,

      //Campos Logicos
      case StatusHistorico 
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '07' then 2 -- Em trânsito
                else 0
      end                                                                        as StatusHistoricoCriticality,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      AvailableStock                                                             as AvailableStock,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      fltp_to_dec(AvailableStock_Conve as abap.quan(13,3))                       as AvailableStock_Conve,

      cast( unit_conversion( quantity => _App.AvailableStock ,
                             source_unit => _App.BaseUnit,
                             target_unit => _App.Unit,
                             error_handling => 'SET_TO_NULL' )
                             as abap.int4) -  cast(_Mard.labst as abap.int4)     as Diferenca,

      @Semantics.quantity.unitOfMeasure : 'Unit'
      UsedStock                                                                  as UsedStock,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      fltp_to_dec(UsedStock_conve as mng06 )                                     as UsedStock_conve,

      case
      when UseAvailable = 'X'     then cast( '' as boole_d )  -- Utilização completa marcado
      when StatusHistorico = '02' then cast( '' as boole_d )  -- Incompleto
      when StatusHistorico = '03' then cast( '' as boole_d )  -- Completo
      when StatusHistorico = '04' then cast( '' as boole_d )  -- Aguardando job Entrada Mercadoria
      when StatusHistorico = '05' then cast( '' as boole_d )  -- Nota Rejeitada pela SEFAZ
      when StatusHistorico = '06' then cast( '' as boole_d )  -- Erro na composição da Nota
      when StatusHistorico = '07' then cast( '' as boole_d )  -- Em trânsito
                                  else cast( 'X' as boole_d )
      end                                                                        as UsedStockEnable,

      /* Campos de apoio - Histórico */
      Guid,
      PrmDepFecId,
      Description,
      OriginPlantType, 
      DestinyPlant,
      _DestinyPlant.WerksCodeName                                                as DestinyPlantName,
      DestinyPlantType,
      DestinyStorageLocation,
      _DestinyStorageLocation.StorageLocationText                                as DestinyStorageLocationName,

      //Campos do Pop UP
      //      cast( '' as lifnr  )                                                   as Transportador,
      //      cast( '' as bu_partner )                                               as Driver,
      //      cast( '' as equnr )                                                    as Equipment,
      //      cast( '' as vsbed )                                                    as Shipping_conditions,
      //      cast( '' as vsart )                                                    as Shipping_type,
      //      cast( '' as equnr )                                                    as Equipment_tow1,
      //      cast( '' as equnr )                                                    as Equipment_tow2,
      //      cast( '' as equnr )                                                    as Equipment_tow3,
      //      cast( '' as ze_mm_freight_mode )                                       as Freight_mode,
      //      cast( 0 as abap.dec(13,3) )                                            as NewUsedStock,

      Transportador,
      Driver,
      Equipment,
      Shipping_conditions,
      Shipping_type,
      Equipment_tow1,
      Equipment_tow2,
      Equipment_tow3,
      Freight_mode,
      NewUsedStock,

      _StatusHistorico

}
