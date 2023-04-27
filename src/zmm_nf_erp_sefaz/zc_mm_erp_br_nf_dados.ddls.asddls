@AbapCatalog.sqlViewName: 'ZVMM_C_NFERP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
define view ZC_MM_ERP_BR_NF_DADOS
  as select distinct from ZI_MM_ERP_BR_NF_Dados as _Nfe
    inner join            zvmm_c_xnfe           as _Xnfe on  _Nfe.ChaveAcesso       = _Xnfe.nfeid
//                                                        and _Nfe.Material      = _Xnfe.cprod
////                                                      and _Nfe.PurchaseOrder      = _Xnfe.ponumber
                                                        and _Nfe.BR_NFExternalItemNumber  = _Xnfe.nitem
{
  key ChaveAcesso,
      BR_NotaFiscal,
      BR_NotaFiscalItem,
      BR_NFPostingDate,
      BR_NFeNumber,
      BR_NFType,
      @ObjectModel.text.element: ['BR_NFPartnerName1']
      BR_NFPartner,
      @Semantics.text: true
      BR_NFPartnerName1,
      CompanyCode,
      BusinessPlace,
      Material,
      PurchaseOrder,
      PurchaseOrderItem,
      MaterialDocument,
      @ObjectModel.text.element: ['MaterialDocumentItemText']
      MaterialDocumentItem,
      @Semantics.text: true
      MaterialDocumentItemText,
      NCMCode,
      guidheader,
      nfeid,
      @EndUserText.label: 'NF Origem'
      nnf,
      cnpjdest,
      cnpjemit,
      ponumber,
      poitem,
      //@ObjectModel.text.element: ['Xprod']
      cprod,
      cfop,
      @Semantics.text: true
      xprod,
      ncm,
      BR_NFExternalItemNumber,
      AccountingDocument,
      case
        when ChaveAcesso <> nfeid
          then '3'
        else '1'
      end as Critical,

      /* Associations */
      _Active,
      _Item
}
