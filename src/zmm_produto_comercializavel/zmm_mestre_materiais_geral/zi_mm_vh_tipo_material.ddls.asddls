@AbapCatalog:{
  sqlViewName: 'ZVMM_TIPO_MAT',
  preserveKey: true,
  compiler.compareFilter: true,
  buffering:{
    status: #ACTIVE,
    type: #GENERIC,
    numberOfKeyFields: 1
  }
 }
//@Analytics: { dataCategory: #DIMENSION, dataExtraction.enabled: true }
@VDM.viewType: #BASIC
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para Tipo de Material'
@ObjectModel:{
  dataCategory: #TEXT,
  representativeKey: 'ProductType',
  usageType:{
    serviceQuality: #A,
    sizeCategory : #L,
    dataClass: #CUSTOMIZING
  }
}  
@ClientHandling.algorithm: #SESSION_VARIABLE
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true

define view ZI_MM_VH_TIPO_MATERIAL
  as select from t134t

  association [0..1] to I_Producttype as _ProductType on $projection.ProductType = _ProductType.ProductType
  association [0..1] to I_Language    as _Language    on $projection.Language = _Language.Language

{
      @ObjectModel.foreignKey.association: '_ProductType'
  key cast(t134t.mtart as producttype preserving type )     as ProductType,
      @Semantics.language: true
  key t134t.spras                                           as Language,
      @Semantics.text: true
      @Search:{
        defaultSearchElement: true,
        fuzzinessThreshold: 0.8,
        ranking: #HIGH
      }  
      @EndUserText.label: 'Product Type Description'
      cast(t134t.mtbez as producttypename preserving type ) as MaterialTypeName,

      _Language,
      _ProductType
}
where spras = $session.system_language
