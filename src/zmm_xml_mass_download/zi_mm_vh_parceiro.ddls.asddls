@AbapCatalog.sqlViewName: 'ZVIMMVHPARCEIRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parceiro de negócios'
define view ZI_MM_VH_PARCEIRO
  as select from I_BusinessPartner as _Partner
  association [1..1] to I_Supplier as _Supplier on _Supplier.Supplier = $projection.BusinessPartner
  association [1..1] to I_Customer as _Customer on _Customer.Customer = $projection.BusinessPartner
{
  key _Partner.BusinessPartner,
      BusinessPartnerFullName,
      coalesce(_Supplier.Region, _Customer.Region )          as Region,
      coalesce( _Supplier.TaxNumber1, _Customer.TaxNumber1 ) as TaxNumber,

      _Supplier,
      _Customer
}
where
  IsMarkedForArchiving is initial
