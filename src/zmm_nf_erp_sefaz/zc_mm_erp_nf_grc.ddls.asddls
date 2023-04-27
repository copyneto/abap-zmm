@EndUserText.label: 'Report ERP x GRC'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_ERP_NF_GRC
  as projection on ZI_MM_ERP_NF_GRC
{
      @EndUserText.label: 'Nº documento'
  key BR_NotaFiscal,       
  key BR_NotaFiscalItem,
      @EndUserText.label: 'Chave de acesso'
      ChaveAcesso,
      @EndUserText.label: 'Data de lançamento'
      BR_NFPostingDate,
      @EndUserText.label: 'N° Nota Fiscal'
      BR_NFeNumber,      
      @EndUserText.label: 'Tp Nota Fiscal'
      BR_NFType,
      BR_NFTypeName,
      @EndUserText.label: 'Fornecedor'
      BR_NFPartner,
      @EndUserText.label: 'Nome'
      BR_NFPartnerName1,      
      @EndUserText.label: 'Empresa'
      CompanyCode,
      CompanyCodeName,      
      BusinessPlace,
      @EndUserText.label: 'Local de Negócio'
      BranchName,
      @EndUserText.label: 'Material SAP'
      Material,
      @EndUserText.label: 'Descr. Material SAP'
      MaterialName,
      @EndUserText.label: 'Ped Compra'
      PurchaseOrder,
      PurchaseOrderItem,
      @EndUserText.label: 'Doc.material SAP'
      MaterialDocument,
      MaterialDocumentItem,
      MaterialDocumentItemText,
      @EndUserText.label: 'NCM SAP'
      NCMCode,
      guidheader,
      nfeid,
      @EndUserText.label: 'NF Origem'
      nnf,
      //      cnpjdest,
      //      cnpjemit,
      @EndUserText.label: 'Ped Compra'
      ponumber,
      @EndUserText.label: 'Documento GRC'
      poitem,
      @EndUserText.label: 'Material GRC'
      cprod,
      @EndUserText.label: 'CFOP XML'
      cfop,
      @EndUserText.label: 'Desc. Material GRC'
      xprod,
      @EndUserText.label: 'NCM XML'
      ncm,
      @EndUserText.label: 'NºDoc SAP'
      AccountingDocument,
      //@Consumption.hidden: true
      Critical,
      /* Associations */
      _Active,
      _Branch,
      _CompanyCode,
      _Item,
      _MaterialText
}
