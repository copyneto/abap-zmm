@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Consumo Desconto Financeiro e Comercial'
@Metadata.allowExtensions: true
define view entity ZC_MM_LIB_PGTO_DES_FIN_COM
  as projection on ZI_MM_LIB_PGTO_DES_FIN_COM
{
  key     Guid,
  key     NumDocumento,
  key     Empresa,
          Ano,
          Status,
          Moeda,
          DocNumComercial,
          DocContabilComercial,
          VlrDescontoCom,
          ObservacaoCom,
          UsuarioCom,
          DataCom,
          GjahrComercial,
          DocNumFinanceiro,
          DocContabilFinanceiro,
          VlrDescontoFin,
          ObservacaoFin,
          UsuarioFin,
          DataFin,
          GjahrFinanceiro,
          CreatedBy,
          CreatedAt,
          LastChangedBy,
          LastChangedAt,
          LocalLastChangedAt,
          Marcado,
          CreatedByControle,
          CreatedAtControle,
          LastChangedByControle,
          LastChangedAtControle,
          LocalLastChangedAtControle,

          @ObjectModel: { virtualElement: true, virtualElementCalculatedBy: 'ABAP:ZCLMM_LIB_PGTO_GRAOVERDE_URL' }
  virtual URL_DocNumFinanceiro     : eso_longtext,
          @ObjectModel: { virtualElement: true, virtualElementCalculatedBy: 'ABAP:ZCLMM_LIB_PGTO_GRAOVERDE_URL' }
  virtual URL_DocContabilComercial : eso_longtext,

          /* Associations */
          _App : redirected to parent ZC_MM_LIB_PGTO_APP
}
