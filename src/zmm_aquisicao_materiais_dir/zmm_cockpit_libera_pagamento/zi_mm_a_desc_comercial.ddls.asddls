@EndUserText.label: 'Popup - Desconto Comercial'
define abstract entity ZI_MM_A_DESC_COMERCIAL
{  
  @Semantics.amount.currencyCode : 'waers'
  @EndUserText.label: 'Desconto Comercial'
  DescontoComercial : abap.curr(11,2);
  @UI.hidden: true   
  //@Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }  ]         
  waers             : waers;
  @EndUserText.label: 'Observações'
  @UI.multiLineText: true
  ObservComercial   : abap.sstring(1024);

}
