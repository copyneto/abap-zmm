@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Consumo Adiantamentos'
@Metadata.allowExtensions: true
define view entity ZC_MM_LIB_PGTO_ADI
  as projection on ZI_MM_LIB_PGTO_ADI
{
  key Empresa,
  key Ano,
  key NumDocumentoRef,
  key NumDocumento,
  key Item,
      Bloqueio,
      TipoDocumento,
      ReferenciaCab1,
      ReferenciaCab2,
      TextoCab,
      DocReferencia,
      Moeda,
      VlMontante,
      DtVencimentoLiquido,
      Marcado,
      MarcadoCriticality,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      @ObjectModel: { virtualElement: true, virtualElementCalculatedBy: 'ABAP:ZCLMM_LIB_PGTO_GRAOVERDE_URL' }
      virtual URL_NumDocumento : eso_longtext,      
      /* Associations */
      _App : redirected to parent ZC_MM_LIB_PGTO_APP
}
