@EndUserText.label: 'Cds Consumo Aprovadores'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_WFAPROV as projection on ZI_MM_WFAPROV {
        
    key Guid,
    @ObjectModel.text.element: ['WerksName']
    @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_WERKS', element: 'WerksCode'  } }]    
    Werks,    
    @ObjectModel.text.element: ['StorageText']
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' },
                                         additionalBinding: [{  element: 'Plant', localElement: 'Werks' } ] } ]
    Lgort,
    @ObjectModel.text.element: ['UserName']
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_USER', element: 'Bname' }}]    
    Usnam,
    _Centro.WerksCodeName       as WerksName,
    _User.Text                  as UserName,
    _Dep.StorageLocationText    as StorageText, 
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt   
    
}
