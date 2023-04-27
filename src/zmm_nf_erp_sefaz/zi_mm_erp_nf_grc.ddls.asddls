@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Report ERP x GRC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ERP_NF_GRC
  as select from ZC_MM_ERP_BR_NF_DADOS as _Dados
  association [0..1] to I_CompanyCode   as _CompanyCode  on  _CompanyCode.CompanyCode = $projection.CompanyCode
                                                         and _CompanyCode.Language    = $session.system_language
  association [0..1] to I_Branch        as _Branch       on  _Branch.Branch      = $projection.BusinessPlace
                                                         and _Branch.CompanyCode = $projection.CompanyCode
  association [0..1] to I_MaterialText  as _MaterialText on  _MaterialText.Material = $projection.Material
                                                         and _MaterialText.Language = $session.system_language
  association [0..1] to ZI_CA_VH_NFTYPE as _NFType       on  _NFType.BR_NFType = $projection.BR_NFType
{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      ChaveAcesso,
      BR_NFPostingDate,
      BR_NFeNumber,
      @ObjectModel.text.element: ['BR_NFTypeName']
      BR_NFType,
      @Semantics.text: true
      _NFType.BR_NFTypeName,
 //     @ObjectModel.text.element: ['BR_NFPartnerName1']
      BR_NFPartner,
      @Semantics.text: true
      BR_NFPartnerName1,
      @ObjectModel.text.element: ['CompanyCodeName']
      CompanyCode,
      @Semantics.text: true
      _CompanyCode.CompanyCodeName,
      @ObjectModel.text.element: ['BranchName']
      BusinessPlace,
      @Semantics.text: true
      _Branch.BranchName,
      //@ObjectModel.text.element: ['MaterialName']
      Material,
      @Semantics.text: true
      _MaterialText.MaterialName,
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
      nnf,
      //      cnpjdest,
      //      cnpjemit,
      ponumber,
      poitem,
      //@ObjectModel.text.element: ['Xprod']
      cprod,
      cfop,
      @Semantics.text: true
      xprod,
      ncm,
      AccountingDocument,
      Critical,
      /* Associations */
      _Active,
      _Item,
      _CompanyCode,
      _Branch,
      _MaterialText,
      _NFType
}
