@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Consumo Principal do APP'
@Metadata.allowExtensions: true
define root view entity ZC_MM_LIB_PGTO_APP
  as projection on ZI_MM_LIB_PGTO_APP
{
  @EndUserText.label: 'Cód. Empresa'
  key Empresa,
  @EndUserText.label: 'Exercício'
  key Ano,
  @EndUserText.label: 'Documento de Compras'
  key NumDocumento,  
  @EndUserText.label: 'Nome Empresa'
  NomeEmpresa,
  @EndUserText.label: 'Cód. Fornecedor'  
  Fornecedor,
  @EndUserText.label: 'Nome Fornecedor'
  NomeFornecedor,
  @EndUserText.label: 'Cód. Status'  
  Status,
  @EndUserText.label: 'Descrição Status'
  DescricaoStatus,
  @EndUserText.label: 'Dt Criação Pedido'
  PedidoCriadoEm,
  @EndUserText.label: 'Usuario Criação Pedido'
  PedidoCriadoPor,
  @EndUserText.label: 'Criado Por - Controle tabela Z'
  CreatedBy,
  @EndUserText.label: 'Criado Em  - Controle tabela Z'
  CreatedAt,
  @EndUserText.label: 'Alterado Por - Controle tabela Z'
  LastChangedBy,
  @EndUserText.label: 'Alteardo Em - Controle tabela Z'
  LastChangedAt,
  @EndUserText.label: 'Registro hora UTC - Controle tabela Z'
  LocalLastChangedAt,
  @EndUserText.label: 'Vencimento Residual'
  VctoResidual, 
  @EndUserText.label: 'Moeda Fatura'
  MoedaFat,
  @EndUserText.label: 'Total Fatura'
  VlMontanteFatura,
  @EndUserText.label: 'Moeda Adiantamento'
  MoedaAdi,
  @EndUserText.label: 'Total Adiantamento'
  VlMontanteAdiantamento,
  @EndUserText.label: 'Moeda Devolução'
  MoedaDev,
  @EndUserText.label: 'Total Devolução'
  VlMontanteDevolucao,   
  @EndUserText.label: 'Moeda Desconto Financeiro'
  MoedaDesFin,   
  @EndUserText.label: 'Total Desconto Financeiro'
  VlMontanteDescontoFinanceiro,
  @EndUserText.label: 'Moeda Desconto Comercial'
  MoedaDesCom,   
  @EndUserText.label: 'Total Desconto Comercial'
  VlMontanteDescontoComercial,
  @EndUserText.label: 'Moeda Total'      
  MoedaTot,   
  @EndUserText.label: 'A Pagar'
  VlTotal,
  @ObjectModel: { virtualElement: true, virtualElementCalculatedBy: 'ABAP:ZCLMM_LIB_PGTO_GRAOVERDE_URL' }
  virtual URL_NumDocumento : eso_longtext,
  @EndUserText.label: 'Montante'
  vlr_desconto_fin,
  @EndUserText.label: 'Observação Desc. Fin.'  
  observacao_fin,
  
  /* Associations */

  _fat       : redirected to composition child ZC_MM_LIB_PGTO_FAT,
  _adi       : redirected to composition child ZC_MM_LIB_PGTO_ADI,
  _dev       : redirected to composition child ZC_MM_LIB_PGTO_DEV,
  _des       : redirected to composition child ZC_MM_LIB_PGTO_DES,
  _desComFin : redirected to composition child ZC_MM_LIB_PGTO_DES_FIN_COM
}
