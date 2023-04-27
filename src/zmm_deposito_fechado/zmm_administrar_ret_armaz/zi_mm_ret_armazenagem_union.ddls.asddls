@AbapCatalog.sqlViewName: 'ZI_MM_RETARMA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ret Armazenagem Pendentes - Union'
define view ZI_MM_RET_ARMAZENAGEM_UNION
  as select from ZI_MM_RET_ARMAZENAGEM_REAL as _Real
{
  key Guid,
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key PrmDepFecId,
  key CentroOrigem,
  key DepositoOrigem,
  key CentroDestino,
  key DepositoDestino,
  key Lote,
  key EANType,
  key cast ( '' as boole_d preserving type ) as DadosDoHistorico,
  ProcessStep,
      QtdOrdVenda,
      Status,
      EstoqueRemessaOF,
      UtilizacaoLivre,
      UseAvailable,
      StatusHistorico,
      EstoqueEmReserva,
      EstoqueBloqueado,
      EstoqueLivreUtilizacao,
      QtdTransportada,
      Description,
      OriginPlantType,
      DestinyPlantType,
      SalesDistrict,
      purchaseorder,
      outbr_notafiscal
}
union all select from ZI_MM_RET_ARMAZENAGEM_HIST as _Hist
{
  key Guid,
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key PrmDepFecId,
  key CentroOrigem,
  key DepositoOrigem,
  key CentroDestino,
  key DepositoDestino,
  key Lote,
  key EANType,
  key cast ( 'X' as boole_d preserving type ) as DadosDoHistorico,
  ProcessStep,
      QtdOrdVenda,
      Status,
      EstoqueRemessaOF,
      UtilizacaoLivre,
      UseAvailable,
      StatusHistorico,
      EstoqueEmReserva,
      EstoqueBloqueado,
      EstoqueLivreUtilizacao,
      QtdTransportada,
      Description,
      OriginPlantType,
      DestinyPlantType,
      SalesDistrict,
      purchaseorder,
      outbr_notafiscal

}
