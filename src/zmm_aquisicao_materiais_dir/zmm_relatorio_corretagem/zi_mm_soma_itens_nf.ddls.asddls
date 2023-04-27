@AbapCatalog.sqlViewName: 'ZVMM_SUMITENSNF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Soma itens da NF'

@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
//@ObjectModel.semanticKey: 'NotaFiscal'
//@ObjectModel.representativeKey: 'NotaFiscal'
define view ZI_MM_SOMA_ITENS_NF
  as select from I_BR_NFItem
{
  key       BR_NotaFiscal,
            max(Material)           as Material,
            BaseUnit,
            SalesDocumentCurrency,
            @Semantics.amount.currencyCode:'SalesDocumentCurrency'
            sum(NetValueAmount)     as NetValueAmount,
            @Semantics.quantity.unitOfMeasure:'BaseUnit'
            sum(QuantityInBaseUnit) as QuantityInBaseUnit
}
group by
  BR_NotaFiscal,
  BaseUnit,
  SalesDocumentCurrency
