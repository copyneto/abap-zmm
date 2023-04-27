@AbapCatalog.sqlViewName: 'ZI_MM_RPENDU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Reservas Pendentes - Union'
define view ZI_MM_RESERVAS_PENDENTES_UNION
  as select from ZI_MM_RESERVAS_PENDENTES_REAL as _Real
{
  key Reservation,
  key PrmDepFec,  
  key EANType,    
  key cast ( '' as boole_d preserving type ) as DadosDoHistorico,
      CreatedBy,
      Material,
      BaseUnit, 
      Unit,
      StorageLocation,
      Plant,
      Batch,
      CreationDateTime,
      UseAvailable,
      StatusHistorico,
      AvailableStock,
      AvailableStock_Conve,
      UsedStock,
      UsedStock_conve,
      

      /* Campos de apoio - Histórico */
      Guid,
      PrmDepFecId,
      Description,
      OriginPlantType,
      DestinyPlant,
      DestinyPlantType,
      DestinyStorageLocation,
      
      Transportador,
      Driver,
      Equipment,
      Shipping_conditions,
      Shipping_type,
      Equipment_tow1,
      Equipment_tow2,
      Equipment_tow3,
      Freight_mode,
      NewUsedStock

}
union all select from ZI_MM_RESERVAS_PENDENTES_HIST as _Hist
{
  key Reservation,
  key PrmDepFec,  
  key EANType,    
  key cast ( 'X' as boole_d preserving type ) as DadosDoHistorico,
      CreatedBy,
      Material,
      BaseUnit,
      Unit,
      StorageLocation,
      Plant,
      Batch,
      CreationDateTime,
      UseAvailable,
      StatusHistorico,
      AvailableStock,
      AvailableStock_Conve,
      UsedStock,
      UsedStock_conve,

      /* Campos de apoio - Histórico */
      Guid,
      PrmDepFecId,
      Description,
      OriginPlantType,
      DestinyPlant,
      DestinyPlantType,
      DestinyStorageLocation,
      
      Transportador,
      Driver,
      Equipment,
      Shipping_conditions,
      Shipping_type,
      Equipment_tow1,
      Equipment_tow2,
      Equipment_tow3,
      Freight_mode,
      NewUsedStock
}
