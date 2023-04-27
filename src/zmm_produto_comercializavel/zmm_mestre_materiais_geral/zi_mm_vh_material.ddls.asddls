@AbapCatalog.sqlViewName: 'ZVMM_MATERIAL'
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS View para Material'
@ObjectModel.representativeKey: 'Product'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory : #L
@ObjectModel.usageType.dataClass: #MASTER
@ClientHandling.algorithm: #SESSION_VARIABLE
@Search.searchable: true
@AbapCatalog.preserveKey:true
@Metadata.ignorePropagatedAnnotations: true

define view ZI_MM_VH_MATERIAL
  as select from makt
  association [1..1] to I_Product as _Product on $projection.Product = _Product.Product
{
  key makt.matnr                                              as Product,
      @Semantics.language: true
  key makt.spras                                              as Language,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      cast(makt.maktx as productdescription preserving type ) as ProductName,
      _Product
}
//where spras = $session.system_language
