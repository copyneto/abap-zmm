//GENERATED:005:GFBfhxvv7kY3c12AoPcutG
@AbapCatalog.sqlViewName: 'ZVMM_EMPRESA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey:true 
@VDM.viewType: #BASIC

@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.representativeKey: 'CompanyCode'

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.usageType.dataClass: #ORGANIZATIONAL
@ObjectModel.usageType.serviceQuality: #A

@AccessControl.authorizationCheck: #NOT_REQUIRED

@ClientHandling.algorithm: #SESSION_VARIABLE

@Search.searchable: true

@Metadata.ignorePropagatedAnnotations: true

@EndUserText.label: 'Company Code'
define view ZI_MM_VH_EMPRESA as select from t001  // direct select from T001 as field f_obsolete to be used in where condition
left outer to one join tka02 on tka02.bukrs = t001.bukrs
left outer to one join P_UserParameter
  on t001.mandt = P_UserParameter.mandt 
  and P_UserParameter.UserParameter = 'F_SHOW_OBSOLETE_T001'
  
  association [0..*] to I_ChartOfAccountsText      as _ChartOfAccountsText on   $projection.ChartOfAccounts = _ChartOfAccountsText.ChartOfAccounts
  association [0..*] to I_ChartOfAccountsText      as _CountryChartOfAccountsText on   $projection.CountryChartOfAccounts = _CountryChartOfAccountsText.ChartOfAccounts
  association [0..1] to I_ControllingArea      as _ControllingAreaText on   $projection.ControllingArea = _ControllingAreaText.ControllingArea
  association [0..*] to I_CreditControlAreaText      as _CreditControlAreaText on   $projection.CreditControlArea = _CreditControlAreaText.CreditControlArea
  // ]--GENERATED
  association [0..1] to I_Currency            as _Currency               on $projection.Currency = _Currency.Currency
  association [0..1] to I_Country             as _Country                on $projection.Country = _Country.Country
  association [0..1] to I_Address             as _Address                on $projection.addressid = _Address.AddressID
  association [0..1] to I_Language            as _Language               on $projection.Language = _Language.Language
  association [0..1] to I_ChartOfAccounts     as _ChartOfAccounts        on $projection.ChartOfAccounts = _ChartOfAccounts.ChartOfAccounts
  association [0..1] to I_FiscalYearVariant   as _FiscalYearVariant      on $projection.FiscalYearVariant = _FiscalYearVariant.FiscalYearVariant
  association [0..1] to I_ChartOfAccounts     as _CountryChartOfAccounts on $projection.CountryChartOfAccounts = _CountryChartOfAccounts.ChartOfAccounts
  association [0..1] to I_ControllingArea     as _ControllingArea        on $projection.ControllingArea = _ControllingArea.ControllingArea
  association [0..1] to I_CreditControlArea   as _CreditControlArea      on $projection.CreditControlArea = _CreditControlArea.CreditControlArea
  association [0..1] to I_FieldStatusVariant  as _FieldStatusVariant     on $projection.fieldstatusvariant = _FieldStatusVariant.FieldStatusVariant
  association [0..1] to I_Globalcompany       as _GlobalCompany          on $projection.Company = _GlobalCompany.Company
  association [0..*] to I_CompanyCodeHierNode as _CompanyCodeHierNode    on $projection.CompanyCode = _CompanyCodeHierNode.CompanyCode  
 {
  @ObjectModel.text.element: ['CompanyCodeName']
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @Search.ranking: #HIGH
  key t001.bukrs    as CompanyCode,
  @Semantics.text: true
  @Search: { defaultSearchElement: true, ranking: #LOW }
  t001.butxt    as CompanyCodeName,
  @ObjectModel.foreignKey.association: '_ControllingArea'
  @Search: { defaultSearchElement: true, ranking: #LOW }
  tka02.kokrs   as ControllingArea,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  t001.ort01    as CityName,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  @ObjectModel.foreignKey.association: '_Country'
  t001.land1    as Country,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  @ObjectModel.foreignKey.association: '_Currency'
  t001.waers    as Currency,
  @ObjectModel.foreignKey.association: '_Language'
  t001.spras    as Language,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  @ObjectModel.foreignKey.association: '_ChartOfAccounts'
  t001.ktopl    as ChartOfAccounts,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  @ObjectModel.foreignKey.association: '_FiscalYearVariant'
  t001.periv    as FiscalYearVariant,
  @Search: { defaultSearchElement: true, ranking: #LOW }
  t001.rcomp    as Company,
  @ObjectModel.foreignKey.association: '_CreditControlArea'
  t001.kkber    as CreditControlArea,
  @ObjectModel.foreignKey.association: '_CountryChartOfAccounts'
  cast(t001.ktop2   as fis_ktop2 preserving type) as CountryChartOfAccounts,
  t001.fikrs    as FinancialManagementArea,
 
  @Consumption.hidden: true 
  _ControllingArea,
  @Consumption.hidden: true  
  _Country,
  @Consumption.hidden: true
  _Currency,
  @Consumption.hidden: true
  _Language,
  @Consumption.hidden: true
  _ChartOfAccounts,
  @Consumption.hidden: true
  _FiscalYearVariant,
  @Consumption.hidden: true
  _CreditControlArea,
  @Consumption.hidden: true
  _CountryChartOfAccounts
  
} where P_UserParameter.UserParameterValue = 'X' or t001.f_obsolete <> 'X' and t001.spras = $session.system_language
