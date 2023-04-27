@EndUserText.label: 'Relatório Fiscal de Entradas'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_FISCAL_ENTRADAS
  as projection on ZI_MM_FISCAL_ENTRADAS
{
      @EndUserText.label: 'Nº Documento'
  key BR_NotaFiscal,
      @EndUserText.label: 'Item NF'
  key BR_NotaFiscalItem,
      @EndUserText.label: ''
      BR_NFPostingDate,
      @EndUserText.label: ''
      BR_NFIssueDate,
      @EndUserText.label: 'Nota Fiscal'
      BR_NFNumber,
      //      @EndUserText.label: 'Nº NF-e'
      //      BR_NFeNumber,
      @EndUserText.label: ''
      @Consumption.filter.defaultValue: '00'
      BR_NFSituationCode,
      @EndUserText.label: ''
      Material,
      @EndUserText.label: ''
      ValuationArea,
      @EndUserText.label: ''
      ValuationType,
      @EndUserText.label: ''
      BR_CFOPCode,
      @EndUserText.label: ''
      CompanyCode,
      @EndUserText.label: 'Ordem Venda'
      SalesOrder,
      @EndUserText.label: ''
      SalesOrganization,
      @EndUserText.label: ''
      DistributionChannel,
      @EndUserText.label: ''
      OrganizationDivision,
      @EndUserText.label: 'Tipo Doc. Vendas'
      //@ObjectModel.text.element: ['SalesDocumentTypeName']
      //@UI.textArrangement: #TEXT_LAST
      TipoDocVenda,
      @EndUserText.label: 'Desc. Tp. Doc. Vendas'
      _SalesDocumentTypeText.SalesDocumentTypeName,
      @EndUserText.label: ''
      BusinessPlace,
      @EndUserText.label: ''
      Plant,
      @EndUserText.label: ''
      MaterialGroup,
      @EndUserText.label: 'Motivo da Ordem'
      MotivoOrdem,
      @EndUserText.label: ''
      PurchasingGroup,
      @EndUserText.label: 'Segmento'
      segment,
      @EndUserText.label: 'IVA'
      BR_TaxCode,
      @EndUserText.label: 'Contrib. ICMS'
      icmstaxpay,
      @EndUserText.label: 'Tipo de Parceiro'
      BR_NFPartnerType,
      @EndUserText.label: 'Parceiro'
      Parceiro,
      @EndUserText.label: ''
      BR_NFPartnerTaxJurisdiction,
      @EndUserText.label: 'Ctg.NF'
      BR_NFType,
      @EndUserText.label: 'Regime Trbutário'
      crtn,
      @EndUserText.label: 'Nota Manual'
      BR_NFIsCreatedManually,
      //      @EndUserText.label: 'Nota fiscal entrada'
      //      NF_Entrada,
      @EndUserText.label: 'NF Serviço'
      BR_NFHasServiceItem,
      @EndUserText.label: 'Converter KG'
      ConverterKG,
      @EndUserText.label: ''
      BR_NFPartnerCountryCode,
      @EndUserText.label: ''
      MaterialName,
      @EndUserText.label: 'UF'
      BR_NFPartnerRegionCode,
      @EndUserText.label: 'Descrição Parceiro'
      NomeParceiro,
      @EndUserText.label: 'Emissor Ordem'
      EmissorOrdem,
      @EndUserText.label: 'Quantidade'
      QuantityInBaseUnit,
      @EndUserText.label: 'Unid.Med.'
      BaseUnit,
      @EndUserText.label: 'Valor Total'
      ValorTotal,
      @EndUserText.label: 'Valor Produtos'
      ValorProdutos,
      @EndUserText.label: 'Base de Cálculo ICMS'
      BaseICMS,
      @EndUserText.label: 'Valor ICMS'
      ValorICMS,
      @EndUserText.label: 'Base IPI'
      BaseIPI,
      @EndUserText.label: 'Valor IPI'
      ValorIPI,
      @EndUserText.label: 'Base SUBST'
      BaseSubst,
      @EndUserText.label: 'Valor SUBST'
      ValorSubst,
      @EndUserText.label: 'Base Dif Aliquota'
      BaseDifAliquota,
      @EndUserText.label: 'ICMS Df Aliquota'
      ICMSDifAliquota,
      @EndUserText.label: 'Base COFINS'
      BaseCOFINS,
      @EndUserText.label: 'Valor COFINS'
      ValorCOFINS,
      @EndUserText.label: 'Base PIS'
      BasePIS,
      @EndUserText.label: 'Valor PIS'
      ValorPIS,
      @EndUserText.label: 'Direito Fiscal ICMS'
      BR_ICMSTaxLaw,
      @EndUserText.label: 'Texto Direito Fiscal ICMS'
      BR_ICMSTaxLawDesc,
      @EndUserText.label: 'ST ICMS'
      BR_ICMSTaxSituation,
      @EndUserText.label: 'Direito Fiscal IPI'
      BR_IPITaxLaw,
      @EndUserText.label: 'Texto Direito Fiscal IPI'
      BR_IPITaxLawDesc,
      @EndUserText.label: 'ST IPI'
      BR_IPITaxSituation,
      @EndUserText.label: 'Direito Fiscal COFINS'
      BR_COFINSTaxLaw,
      @EndUserText.label: 'Texto Direito Fiscal COFINS'
      BR_COFINSTaxLawDesc,
      @EndUserText.label: 'ST COFINS'
      BR_COFINSTaxSituation,
      @EndUserText.label: 'Direito Fiscal PIS'
      BR_PISTaxLaw,
      @EndUserText.label: 'Texto Direito Fiscal PIS'
      BR_PISTaxLawDesc,
      @EndUserText.label: 'ST PIS'
      BR_PISTaxSituation,
      Batch,
      @EndUserText.label: 'Conta Contábil PO'
      GLAccount,
      @EndUserText.label: 'Descrição da Conta'
      _AccPOText.GLAccountName,
      @EndUserText.label: 'Nº CNPJ'
      BR_NFPartnerCNPJ,
      @EndUserText.label: 'Nº CPF'
      BR_NFPartnerCPF,
      @EndUserText.label: 'Inscrição Estadual'
      BR_NFPartnerStateTaxNumber,
      CostCenter,
      @EndUserText.label: 'NFe'
      BR_IsNFe,
      @EndUserText.label: 'Pedido de Compra'
      PurchaseOrder,
      @EndUserText.label: 'Item Pedido de Compra'
      PurchaseOrderItem,
      @EndUserText.label: 'Data Remessa Pedido'
      ScheduleLineDeliveryDate,
      @EndUserText.label: 'Data Criação Pedido'
      CreationDate,
      @EndUserText.label: 'Referência'
      BR_NFObservationText,
      @EndUserText.label: 'Vencimento NF'
      VencNota,
      @EndUserText.label: 'NCM'
      NCMCode,
      @EndUserText.label: 'INSS'
      INSS,
      @EndUserText.label: '% INSS'
      PercentINSS,
      @EndUserText.label: 'IRRF'
      IRRF,
      @EndUserText.label: '% IRRF'
      PercentIRRF,
      @EndUserText.label: 'ISS'
      ISS,
      @EndUserText.label: '% ISS'
      PercentISS,
      @EndUserText.label: 'TRIO'
      TRIO,
      @EndUserText.label: '% TRIO'
      PercentTRIO,
      @EndUserText.label: 'FUNRURAL'
      Funrural,
      @EndUserText.label: '% FUNRURAL'
      PercFunrural,
      @EndUserText.label: 'Documento Contábil'
      AccountingDocument,
      @EndUserText.label: 'Isentos ICMS'
      IsentosICMS,
      @EndUserText.label: 'Outras ICMS'
      OutrasICMS,
      @EndUserText.label: 'Isentos IPI'
      IsentosIPI,
      @EndUserText.label: 'Outras IPI'
      OutrasIPI,
      BR_MaterialOrigin,
      @EndUserText.label: 'Base Calc. INSS'
      BaseCalcINSS,
      @EndUserText.label: 'Desconto INC'
      DescontoINC,
      @EndUserText.label: 'Doc. Fatura'
      BR_NFSourceDocumentNumber,
      @EndUserText.label: 'Município'
      BR_NFPartnerCityName,
      @EndUserText.label: 'ICMS ICAP'
      ICMSICAP,
      @EndUserText.label: 'ICMS ICEP'
      ICMSICEP,
      @EndUserText.label: 'ICMS ICSP'
      ICMSICSP,
      @EndUserText.label: 'Desc. Motivo Ordem'
      _MotivoOrdem.bezei as DescrMotivoOrdem,
      @EndUserText.label: 'Chave de Acesso'
      AchaveAcesso,
      @EndUserText.label: 'Nº doc Original da NFe'
      BR_NFReferenceDocument,
      @EndUserText.label: 'Nº doc Original do Item'
      BR_ReferenceNFNumber,
      BR_SUFRAMACode,
      @EndUserText.label: 'TDT'
      TDT,
      @EndUserText.label: 'BC. ICMS FCP'
      BcICMSFCP,
      @EndUserText.label: 'Valor ICMS FCP'
      ValorICMSFCP,
      @EndUserText.label: 'Base ST FCP'
      BaseSTFCP,
      @EndUserText.label: 'Valor ST FCP'
      ValorSTFCP,
      @EndUserText.label: 'Base cálculo FUNRURAL'
      BaseCalcFunrural,
      @EndUserText.label: 'Base Calc IRRF'
      BaseIRRF,
      @EndUserText.label: 'Base Calc ISS'
      BaseISS,
      @EndUserText.label: 'Base Calc TRIO'
      BaseTRIO,
      @EndUserText.label: 'Total da Nota'
      TotalNF,
      @EndUserText.label: 'Domicílio Fiscal ISS'
      DomFiscISS,
      @EndUserText.label: 'Cod Receita IRRF'
      CodReceitaIRRF,
      @EndUserText.label: 'Cod Receita TRIO'
      CodReceitaTRIO,
      @EndUserText.label: 'Usuário criador'
      CreatedByUser,
      @EndUserText.label: 'Base ST reembolso'
      BaseST,
      @EndUserText.label: 'ICMS ST reembolso'
      MontanteST,
      @EndUserText.label: 'Desconto ICMS ZF'
      BR_ExemptedICMSAmount,
      @EndUserText.label: 'Unid. Med. NF'
      NFBaseUnit,
      @EndUserText.label: 'ST entrada Ceará'
      STEntradaCE,
      @EndUserText.label: 'GTIN'
      ProductStandardID,
      @EndUserText.label: 'Doc. MIRO'
      DocMiro,
      @EndUserText.label: 'Ano MIRO'
      AnoMiro,
      @EndUserText.label: 'Doc. MIGO'
      MaterialDocument,
      @EndUserText.label: 'Ano MIGO'
      MaterialDocumentYear,
      @EndUserText.label: 'Aliq ICMS'
      AliqICMS,
      @EndUserText.label: 'Aliq IPI'
      AliqIPI,
      @EndUserText.label: 'Doc. Faturamento'
      DocFat_NFSourceDocumentNumber,
      @EndUserText.label: 'Doc. Remessa'
      DocRemessa,
      BR_NFeModel,
      @EndUserText.label: 'MVA'
      BR_ICMSSTMarginAddedPercent,
      @EndUserText.label: 'Cod.Imposto SD'
      CodImposto,
      @EndUserText.label: 'Qtd. UM Material'
      QtdUnMedMaterial,
      @EndUserText.label: 'UM Material'
      UnidMedMaterial,
      @EndUserText.label: 'Peso Bruto NF'
      HeaderGrossWeight,
      @EndUserText.label: 'Base s/ Benef'
      BaseSemBenef,
      @EndUserText.label: 'ICMS s/ Benef'
      ICMSSemBenef,
      @EndUserText.label: 'ICMS Deson'
      BR_ICMSStatisticalExemptionAmt,
      @EndUserText.label: 'Cod. Benef'
      TaxIncentiveCode,
      @EndUserText.label: 'Ind Tipo Prin'
      indtyp,
      @EndUserText.label: 'Frete'
      Frete,
      @EndUserText.label: 'Valor sem Frete'
      TotalSemFrete,
      @EndUserText.label: 'Setor Industrial'
      BRSCH,
      @EndUserText.label: 'Escritório de Vendas'
      SalesOffice,
      @EndUserText.label: 'Exercício'
      BR_NFFiscalYear,
      @EndUserText.label: 'Item Referência NF'
      BR_ReferenceNFItem,
      @EndUserText.label: 'Moeda INSS'
      MoedaINSS,
      @EndUserText.label: 'Moeda Doc.'
      SalesDocumentCurrency,
      @EndUserText.label: 'Unid. Peso'
      HeaderWeightUnit,
      @UI.hidden: true
      BR_NFItemTaxRate,
      @UI.hidden: true
      BR_NFTotalAmount
}
