@AbapCatalog.sqlViewName: 'ZVMMTAXNUMLIFNR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Avulsa - Fornecedor TaxNumber'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view zi_mm_vh_taxnumber
  as select from zibp_taxnumber as _BPTax
  association [1..1] to tfktaxnumtype_t as _Text on  $projection.BPTaxType = _Text.taxtype
                                                 and _Text.spras           = $session.system_language
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key BusinessPartner,
      @Search.ranking: #HIGH
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element: ['_Text.text']
  key BPTaxType,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      BPTaxNumber,

      _Text
}
