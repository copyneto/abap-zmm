@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Fiscal GRC'
@Metadata.allowExtensions: true
define root view entity zc_mm_relatorio_fiscal_grc
  as select from zi_mm_relatorio_fiscal_grc

{
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
  key       proctyp,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_VH_MANUAL', element: 'TpDoc' }}]
      BR_NFIsCreatedManually,
      BR_NFPostingDate,
      BR_NFIssueDate,
//      BR_NFNumber,
      BR_NFeNumber,
      Material,
      MaterialName,
      BR_CFOPCode,
      CompanyCode,
      BusinessPlace,
      Plant,
      BR_NFPartnerType,
      BR_NFPartner,
      BR_NFPartnerName1,
      BR_NFPartnerRegionCode,
      BR_NFPartnerTaxJurisdiction,
      BR_NFType,
      BR_NFPartnerCNPJ,
      OriginReferenceDocument,
      PurchasingGroup,
      CreatedByUser,
      SupplierPostingLineItemText,
      AccountingDocument,
      ncm,
      dsaient,
      createtime,
//      proctyp,
//      histCreatetime,
      DateCreatetime,
      HoraCreatetime,
      username,
      quantidadeDias,
      cprod
}
