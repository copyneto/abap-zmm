@EndUserText.label: 'Adm. Retorno de Armazenagem Mensagens'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity zc_mm_ret_armazenagem_msg 
as projection on zi_mm_ret_armazenagem_msg {
  
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
     @EndUserText.label: 'Material'
  key Material,
  @EndUserText.label: 'Centro Origem'
  key CentroOrigem,
   @EndUserText.label: 'Depósito Origem'
  key DepositoOrigem,
   @EndUserText.label: 'Lote'
  key Lote,
  @EndUserText.label: 'Centro Destino'
  key CentroDestino,
  @EndUserText.label: 'Depósito Destino'
  key DepositoDestino,
  @EndUserText.label: 'ID'
  key Guid,
  @EndUserText.label: 'Unidade Original'
  key UmbOrigin,
  @EndUserText.label: 'Destino'
  key UmbDestino,
   @EndUserText.label: 'Etapa'
  key ProcessStep,
  @EndUserText.label: 'Configuração'
  key PrmDepFecId,
  @EndUserText.label: 'Dados do historico'
  key DadosDoHistorico,
   @EndUserText.label: 'Tipo de Estoque'
  key EANType,
   @EndUserText.label: 'Nº Mensagem'
  key Sequencial,
  @EndUserText.label: 'Tipo'
  Type,
  @EndUserText.label: 'Mensagem'
  Msg,
  @EndUserText.label: 'Executor'
  CreatedBy,
  @EndUserText.label: 'Data Hora'
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  
  /* Associations */
  _Emissao : redirected to parent ZC_MM_RET_ARMAZENAGEM_APP
}
