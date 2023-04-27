@AbapCatalog:{
               sqlViewName: 'ZVMM_CENTRO',
               preserveKey: true,
               compiler.compareFilter: true
             }
@EndUserText.label: 'Plant'
@ObjectModel:{
               usageType:{
                           sizeCategory: #S,
                           serviceQuality: #A,
                           dataClass:#CUSTOMIZING
                         },
               representativeKey: 'Plant'
             }
@AccessControl:{
                 authorizationCheck: #NOT_REQUIRED,
                 personalData.blocking: #NOT_REQUIRED,
                 privilegedAssociations: ['_Address']
               }
@VDM:{
       viewType: #BASIC,
       lifecycle.contract.type: #PUBLIC_LOCAL_API
     }
@ClientHandling.algorithm: #SESSION_VARIABLE
@Analytics.dataCategory: #DIMENSION
@Search.searchable: true
@Metadata: {
             allowExtensions: true,
             ignorePropagatedAnnotations: true
           }

define view ZI_MM_VH_CENTRO
  as select from t001w
  association [0..1] to I_Address                     as _Address                on $projection.AddressID = _Address.AddressID
  association [0..1] to I_Customer                    as _Customer               on $projection.PlantCustomer = _Customer.Customer
  association [0..1] to I_Supplier                    as _Supplier               on $projection.PlantSupplier = _Supplier.Supplier
  association [0..*] to I_PlantPurchasingOrganization as _ResponsiblePurchaseOrg on $projection.Plant = _ResponsiblePurchaseOrg.Plant
  association [0..*] to I_PlantCategoryT              as _PlantCategoryText      on $projection.PlantCategory = _PlantCategoryText.PlantCategory
{
      @ObjectModel.text.element: 'PlantName'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key werks                                      as Plant,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      cast(name1 as werks_name preserving type ) as PlantName,
      bwkey                                      as ValuationArea,
      @ObjectModel.foreignKey.association: '_Customer'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_Customer_VH',
                     element: 'Customer' }
        }]
      kunnr                                      as PlantCustomer,
      @ObjectModel.foreignKey.association: '_Supplier'
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_Supplier_VH',
                     element: 'Supplier' }
        }]
      lifnr                                      as PlantSupplier,
      fabkl                                      as FactoryCalendar,
      ekorg                                      as DefaultPurchasingOrganization,
      vkorg                                      as SalesOrganization,
      @ObjectModel.foreignKey.association: '_Address'
      adrnr                                      as AddressID,
      vlfkz                                      as PlantCategory,
      vtweg                                      as DistributionChannel,
      spart                                      as Division,
      spras                                      as Language,
      achvm                                      as IsMarkedForArchiving, //2949107
      _Address,
      _Customer,
      _Supplier,
      _ResponsiblePurchaseOrg,
      _PlantCategoryText
}
where spras = $session.system_language
