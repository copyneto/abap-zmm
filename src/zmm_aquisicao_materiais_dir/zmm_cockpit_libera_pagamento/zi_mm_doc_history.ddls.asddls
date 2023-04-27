@AbapCatalog.sqlViewName: 'ZVIMMDOCHISDT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Histórico de Documentos'
define view ZI_MM_DOC_HISTORY
  as select distinct from PurgDocHistory
{
  key EBELN                  as PurchaseOrder,
  key EBELP                  as PurchaseOrderItem,
  key concat( BELNR, GJAHR ) as ReferencedDocument,
      BELNR,
      GJAHR
}
where
  BEWTP = 'Q'
