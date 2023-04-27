@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados Bancários'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_DADOS_BANCARIOS
  as select from lfbk

  //---> Decomment if you want to join further data sources
  //left outer to one join DatabaseTableOrBasicCdsView2 //recommendation: use addition "to one" or "to many"
  //   on LFBK.FieldName = DatabaseTableOrBasicCdsView2.FieldName2
  association [1..1] to I_Bank        as _Bank        on  $projection.BankCountry = _Bank.BankCountry
                                                      and $projection.Bank        = _Bank.BankInternalID

  association [1..1] to I_Supplier    as _Supplier    on  $projection.Supplier = _Supplier.Supplier

  association [1..1] to I_Country     as _Country     on  $projection.BankCountry = _Country.Country

  association [1..1] to I_CountryText as _CountryText on  _CountryText.Country  = $projection.BankCountry
                                                      and _CountryText.Language = $session.system_language

  association [1..1] to I_BankAccount as _BankAccount on  $projection.BankAccount = _BankAccount.BankAccountInternalID //Added to remove representative key ATC, DO NOT USE

  association [0..1] to I_Iban        as _IBAN        on  $projection.BankAccount    = _IBAN.BankAccount
                                                      and $projection.Bank           = _IBAN.Bank
                                                      and $projection.BankCountry    = _IBAN.BankCountry
                                                      and $projection.BankControlKey = _IBAN.BankControlKey

{
      //   key cast (lifnr as bu_partner) as Supplier,
      //--[ GENERATED:012:GlBfhyJl7kY4i6}7dD1KRG
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_Supplier_VH',
                     element: 'Supplier' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_Supplier'
      @ObjectModel.text.element: ['SupplierName']
  key lifnr                          as Supplier,
      @ObjectModel.foreignKey.association: '_Country'
      @ObjectModel.text.element: ['CountryName']
  key banks                          as BankCountry,
      @ObjectModel.text.element: ['BankName']
  key bankl                          as Bank,
      //--[ GENERATED:012:GlBfhyJl7kY4i6}7dD1KRG
      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_BankAccountStdVH',
                     element: 'BankAccountInternalID' }
        }]
      // ]--GENERATED
      @ObjectModel.foreignKey.association: '_BankAccount'
  key bankn                          as BankAccount,
      _CountryText.CountryName       as CountryName,
      bvtyp                          as BPBankAccountInternalID,
      koinh                          as BankAccountHolderName,
      bkont                          as BankControlKey,
      bkref                          as BankDetailReference,
      _Supplier.SupplierName         as SupplierName,
      //      kovon                    as ValidityStartDate,
      //      kobis                    as ValidityEndDate,
      _Bank.BankName                 as BankName,
      _BankAccount.ValidityStartDate as ValidityStartDate,
      _BankAccount.ValidityEndDate   as ValidityEndDate,

      //_TargetPublicBasicViewNameWithoutPrefix //expose the association for use by consumers
      _Bank,
      _Country,
      _CountryText,
      //      _Supplier.AuthorizationGroup,
      _Supplier,
      _BankAccount,
      _IBAN
}
