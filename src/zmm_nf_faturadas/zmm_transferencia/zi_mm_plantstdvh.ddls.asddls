@AbapCatalog: {
                sqlViewName: 'ZIPLANTSTDVH',
                preserveKey: true,
                compiler.compareFilter: true,
                buffering: {
                             status: #ACTIVE,
                             type: #GENERIC,
                             numberOfKeyFields: 001
                           }
              }
@EndUserText.label: 'Plant Std VH'
@AccessControl: {
                  authorizationCheck: #NOT_REQUIRED,
                  personalData.blocking: #NOT_REQUIRED
                }
@ObjectModel: {
    usageType: {
        sizeCategory: #S,
        serviceQuality: #A,
        dataClass:#CUSTOMIZING
    },
    dataCategory: #VALUE_HELP,
    representativeKey: 'werks'
} 
@VDM: {
        private: false,
        viewType: #BASIC,
        lifecycle.contract.type: #PUBLIC_LOCAL_API
        }
@ClientHandling.algorithm: #SESSION_VARIABLE
@Analytics.dataCategory: #DIMENSION
@Search.searchable: true
@Metadata.allowExtensions: true

define view ZI_MM_PLANTSTDVH
  as select from t001w
{
      @ObjectModel.text.element: 'PlantName'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key werks                     as werks,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      cast(name1 as werks_name) as PlantName
}                                             

