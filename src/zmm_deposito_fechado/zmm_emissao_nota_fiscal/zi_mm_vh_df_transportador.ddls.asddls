@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Transportador'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_DF_TRANSPORTADOR
  as select from lfa1 as _Fornecedor {
      @ObjectModel.text.element: ['CarrierText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _Fornecedor.lifnr as Carrier,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Fornecedor.name1 as CarrierText
  
  }
 
/*  as select from wyt3           as Parceiro
    inner join   ztca_param_val as _Param on  _Param.modulo = 'MM'
                                          and _Param.chave1 = 'FUNCAO_PARCEIRO'
                                          and _Param.chave2 = 'TRANSPORTADOR'
                                          and _Param.chave3 = ''
                                          and _Param.sign   = 'I'
                                          and _Param.opt    = 'EQ'
                                          and _Param.low    = Parceiro.parvw

  association [0..1] to lfa1 as _Fornecedor on _Fornecedor.lifnr = $projection.Carrier

{
      @ObjectModel.text.element: ['CarrierText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Parceiro.lifnr    as Carrier,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Fornecedor.name1 as CarrierText
}
group by
  Parceiro.lifnr,
  _Fornecedor.name1 */
