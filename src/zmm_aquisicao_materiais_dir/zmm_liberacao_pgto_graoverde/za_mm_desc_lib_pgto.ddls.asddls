@EndUserText.label: 'Action: Desconto Financeiro'
define abstract entity ZA_MM_DESC_LIB_PGTO
{
  @Semantics.amount.currencyCode : 'MoedaFat'
  @EndUserText.label: 'Montante'
  vlr_desconto_fin : kbetr;
  @UI.hidden: true
  MoedaFat         : waers;
  @UI.multiLineText: true
  observacao_fin   : abap.sstring(1024);
}
