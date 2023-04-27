@EndUserText.label: 'Processo Depósito Fechado - Série'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_MM_ADMINISTRAR_MSG
  as projection on ZI_MM_ADMINISTRAR_MSG
{

      @EndUserText.label: 'Material'
  key Material,
      @EndUserText.label: 'Centro Origem'
  key OriginPlant,
      @EndUserText.label: 'Depósito Origem'
  key OriginStorageLocation,
      @EndUserText.label: 'Centro Origem'
  key Batch,
      @EndUserText.label: 'Unidade Original'
  key OriginUnit,
      @EndUserText.label: 'Unidade'
  key Unit,
      @EndUserText.label: 'ID'
  key Guid,
      @EndUserText.label: 'Etapa'
  key ProcessStep,
  @EndUserText.label: 'Configuração'
  key PrmDepFecId,
      @EndUserText.label: 'Centro Destino'
  key DestinyPlant,
      @EndUserText.label: 'Depósito Destino'
  key DestinyStorageLocation,  
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
      _Emissao : redirected to parent ZC_MM_ADMINISTRAR_EMISSAO_NF
}
