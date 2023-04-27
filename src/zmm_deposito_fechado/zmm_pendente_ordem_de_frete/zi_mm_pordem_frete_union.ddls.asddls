@AbapCatalog.sqlViewName: 'ZI_MM_PORDEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Junção dos dados'
define view ZI_MM_PORDEM_FRETE_UNION
  as select distinct from ZI_MM_ORDENS_FRETE_PENDENTE
{
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key CentroRemessa,
  key Deposito,
  key Lote,
  key CentroDestino, 
  key DepositoDestino,
  key PrmDepFecId,    
  key EANType,
      SoldToParty,
      Status,
      EstoqueRemessaOF,
      UtilizacaoLivre,
      AvailableStock,
      AvailableStock_Conve,
      UsedStock,
      UsedStock_conve,
      UseAvailable,
      StatusHistorico,
      cast ( '' as boole_d preserving type ) as DadosDoHistorico,
      Guid,
      Description,
      OriginPlantType,
      DestinyPlant,
      DestinyPlantType,
      DestinyStorageLocation
}
union all select from ZI_MM_ORDENS_FRETE_HIST
{
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key CentroRemessa,
  key Deposito,
  key Lote,
  key CentroDestino,
  key DepositoDestino,
  key PrmDepFecId,    
  key EANType,
      SoldToParty,
      Status,
      EstoqueRemessaOF,
      UtilizacaoLivre,
      AvailableStock,
      AvailableStock_Conve,
      UsedStock,
      UsedStock_conve,
      UseAvailable,
      StatusHistorico,
      cast ( 'X' as boole_d preserving type ) as DadosDoHistorico,
      Guid,
      Description,
      OriginPlantType,
      DestinyPlant,
      DestinyPlantType,
      DestinyStorageLocation
}
