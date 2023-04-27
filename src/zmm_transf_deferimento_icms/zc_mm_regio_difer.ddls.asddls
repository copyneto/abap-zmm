@EndUserText.label: 'Região e mensagens para regra do diferimento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_REGIO_DIFER as projection on ZI_MM_REGIO_DIFER {
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_REGIO', element: 'Regio' }}]    
    key Regio,
    @EndUserText.label: 'Mensagem'
    Msg,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
