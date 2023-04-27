@AbapCatalog.sqlViewName: 'ZVMM_DOCSCOMPENS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Documentos Compensados'
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
//@ObjectModel.semanticKey: 'DocumentosCompensados'
//@ObjectModel.representativeKey: 'DocumentosCompensados'
define view ZI_MM_DOCS_COMPENSADOS
  as select from I_AccountingDocument
    inner join   bsak_view on  bukrs = I_AccountingDocument.CompanyCode
                           and gjahr = I_AccountingDocument.FiscalYear
                           and belnr = I_AccountingDocument.AccountingDocument
                           and augbl is not initial


    inner join   bseg      on  bseg.bukrs = I_AccountingDocument.CompanyCode
                           and bseg.gjahr = I_AccountingDocument.FiscalYear
                           and bseg.belnr = bsak_view.augbl
  //                      and bseg.belnr   = I_AccountingDocument.AccountingDocument
{
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key OriginalReferenceDocument as OrigDocument,
  key substring(bseg.hkont,1,6) as Conta,
      bsak_view.augbl           as DocCompensacao,
      bsak_view.augdt           as DataCompensacao
}
//where bsak_view.augbl is not null
