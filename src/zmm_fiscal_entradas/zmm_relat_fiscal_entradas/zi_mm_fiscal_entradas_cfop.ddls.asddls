@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_FISCAL_ENTRADAS_CFOP 
  as select from ZI_CA_CFOP as J_1bagn
  
   inner join   j_1bagnt as _Text on  _Text.cfop   =  J_1bagn.Cfop
                                  and _Text.version = J_1bagn.Version
                                  and _Text.cfotxt <> ''
                                  and _Text.spras  = $session.system_language
{
      @EndUserText.label: 'CFOP'
      //@Search.ranking: #MEDIUM
      //@Search.defaultSearchElement: true
      //@Search.fuzzinessThreshold: 0.8
  //key J_1bagn.Cfop as CfopHeader,      
  key left( J_1bagn.Cfop, 4 ) as CfopHeader,
      @EndUserText.label: 'CFOP Interno'
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      J_1bagn.Cfop            as Cfop,
      @EndUserText.label: 'Descrição'
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.cfotxt             as Text

}
