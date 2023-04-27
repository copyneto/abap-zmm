@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Serie'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_MM_RET_ARMAZENAGEM_SERIE
  as projection on ZI_MM_RET_ARMAZENAGEM_SERIE
{
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key CentroOrigem,
  key DepositoOrigem,
  key CentroDestino,
  key DepositoDestino,
  key Lote,
  key EANType,
  key DadosDoHistorico,
  key SerialNo,
  key Guid,
      SerialNoText,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Emissao : redirected to parent ZC_MM_RET_ARMAZENAGEM_APP

}
