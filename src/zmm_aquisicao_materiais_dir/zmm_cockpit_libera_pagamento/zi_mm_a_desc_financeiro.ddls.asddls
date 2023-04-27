@EndUserText.label: 'Popup - Desconto Comercial'
define abstract entity ZI_MM_A_DESC_FINANCEIRO
{
  @EndUserText.label : 'Desconto Financeiro'
  @Semantics.amount.currencyCode : 'waers'
  DescontoFinanceiro : abap.curr(11,2);
  @EndUserText.label : 'Devolução Futura'
  @Semantics.amount.currencyCode : 'waers'
  DevolucaoFutura    : abap.curr(11,2);
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
  waers              : waers;
  @EndUserText.label : 'Observações'
  @UI.multiLineText: true
  ObservFinanceiro   : abap.sstring(1024);

}
