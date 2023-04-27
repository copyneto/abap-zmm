@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help MOTDESICMS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_MOTDESICMS 
 as select from    dd07l as FixedValue
    left outer join dd07t as ValueText on  FixedValue.domname    = ValueText.domname
                                       and FixedValue.domvalue_l = ValueText.domvalue_l
                                       and FixedValue.as4local   = ValueText.as4local

{
      @UI.hidden
  key FixedValue.domname    as DomainName,
      @UI.hidden
  key FixedValue.as4local   as Status,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key FixedValue.domvalue_l as Low,
      @Semantics.text: true -- identifies the text field
      ValueText.ddtext      as Text
}

where
      FixedValue.as4local  = 'A' --Active
  and ValueText.ddlanguage = $session.system_language 
  and ValueText.domname = 'J_1B_ICMS_EXEM_REASON';
