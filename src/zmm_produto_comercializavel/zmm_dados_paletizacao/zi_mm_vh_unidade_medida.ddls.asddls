@AbapCatalog.sqlViewName: 'ZVMM_UNID_MED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AbapCatalog.buffering.status: #ACTIVE
@AbapCatalog.buffering.type: #GENERIC
@AbapCatalog.buffering.numberOfKeyFields: 2
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Texto Unidade de Medida'

@VDM.viewType: #BASIC 
@VDM.lifecycle.contract.type: #PUBLIC_LOCAL_API

@ClientHandling.type: #INHERITED
@ClientHandling.algorithm: #SESSION_VARIABLE
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.usageType.dataClass: #CUSTOMIZING
@ObjectModel.representativeKey: 'UnitOfMeasure'

@Analytics.internalName: #LOCAL
@Analytics.dataExtraction.enabled: true

define view ZI_MM_VH_UNIDADE_MEDIDA 
  as select from t006a
   
    association [0..1] to I_UnitOfMeasure as _UnitOfMeasure
        on  $projection.UnitOfMeasure = _UnitOfMeasure.UnitOfMeasure
    association [0..1] to I_Language as _Language
        on $projection.Language = _Language.Language 
             
 {
    @Semantics.language: true
    @ObjectModel.foreignKey.association: '_Language'
    key spras as Language,
    _Language,
    
    @Semantics.unitOfMeasure: true
    @ObjectModel.foreignKey.association: '_UnitOfMeasure'
    key msehi as UnitOfMeasure,
    _UnitOfMeasure,
       
    @Semantics.text: true
    msehl as UnitOfMeasureLongName,

    @Semantics.text: true
    mseht as UnitOfMeasureName,

    @Semantics.text: true
    mseh6 as UnitOfMeasureTechnicalName,    
           
    mseh3 as UnitOfMeasure_E,       
    
    @Semantics.text: true
    mseh3 as UnitOfMeasureCommercialName
}  
where spras = $session.system_language
