@EndUserText.label: 'Processo Depósito Fechado - Série'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['SerialNo']

define view entity ZC_MM_ADMINISTRAR_SERIE
  as projection on ZI_MM_ADMINISTRAR_SERIE
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
      @EndUserText.label: 'Nº de série'
      @ObjectModel.text.element: ['SerialNoText']
  key SerialNo,
      SerialNoText,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Emissao : redirected to parent ZC_MM_ADMINISTRAR_EMISSAO_NF
}
