@AbapCatalog.sqlViewName: 'ZVMM_NFERP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal - ERP'
define view ZI_MM_ERP_BR_NF_Dados
  as select distinct from I_BR_NFDocument as _Header
  association [0..1] to I_BR_NFeActive        as _Active   on $projection.BR_NotaFiscal = _Active.BR_NotaFiscal
  association [0..*] to ZI_MM_ERP_BR_NF_ITEMS as _Item     on $projection.BR_NotaFiscal = _Item.BR_NotaFiscal
{
  key _Header.BR_NotaFiscal,
  key _Item.BR_NotaFiscalItem,
      _Header.BR_NFPostingDate,
      _Header.BR_NFeNumber,
      _Header.BR_NFType,
      _Header.BR_NFPartner,
      _Header.BR_NFPartnerName1,
      _Header.CompanyCode,
      _Header.BusinessPlace,
      _Header.AccountingDocument,
//      concat( _Active.BR_NotaFiscal,
      concat( _Active.Region,
      concat( _Active.BR_NFeIssueYear,
      concat( _Active.BR_NFeIssueMonth,
      concat( _Active.BR_NFeAccessKeyCNPJOrCPF,
      concat( _Active.BR_NFeModel,
      concat( _Active.BR_NFeSeries,
      concat( _Active.BR_NFeNumber,
      concat( _Active.BR_NFeRandomNumber, _Active.BR_NFeCheckDigit ) ) ) ) ) ) ) )  as ChaveAcesso,
      _Item.Material,
      _Item.PurchaseOrder,
      _Item.PurchaseOrderItem,
      _Item.MaterialDocument,
      _Item.MaterialDocumentItem,
      _Item.MaterialDocumentItemText,
      _Item.NCMCode,
      _Item.BR_NFExternalItemNumber,

      _Active,
      _Item
} where _Header.BR_NFDirection = '1'
    and _Header.BR_NFPartnerType = 'V'
    and _Header.BR_NFIsCanceled <> 'X'
