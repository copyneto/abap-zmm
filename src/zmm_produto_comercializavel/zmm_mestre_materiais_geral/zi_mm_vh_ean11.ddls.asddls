@AbapCatalog.sqlViewName: 'ZVMM_EAN11'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help EAN11'
@Search.searchable: true

define view ZI_MM_VH_EAN11
  as select distinct from mara
  //  association [0..1] to I_ProductText as _Text on  _Text.Product = $projection.Product
  //                                               and _Text.Language = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      @Search.ranking: #HIGH
  key mara.ean11 as EAN11
      //      @ObjectModel.text.association: '_Text'
      //  key mara.matnr as Product,
      //
      //      _Text
}
where
  ean11 <> ''
group by
  ean11
