@AbapCatalog.sqlViewName: 'ZVCMMACCDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cocumentos Contábeis'
define view ZC_MM_ACCOUNT_DOCUMENT
  as select from ZI_MM_ACCOUNT_DOCUMENT
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key ReferencedDocument,
      AccountingDocument,
      FiscalYear,
      CompanyCode,
      MontanteAdiantamento,
      status_compensado as StatusCompensado,

      case status_compensado
        when 'X'
          then 3
        else
          1
      end               as CompensadoCriticality
}
