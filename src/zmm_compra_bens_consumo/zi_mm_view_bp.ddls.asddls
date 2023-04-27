@EndUserText.label: 'View para BP'
define abstract entity ZI_MM_VIEW_BP {
  @Consumption.defaultValue: 'BP'
  @EndUserText.label: 'BP'
@Consumption.valueHelpDefinition: [{
    entity: { name: 'I_BusinessPartner', element: 'BusinessPartner' }
   }]
    key Partner : bu_partner;
}
