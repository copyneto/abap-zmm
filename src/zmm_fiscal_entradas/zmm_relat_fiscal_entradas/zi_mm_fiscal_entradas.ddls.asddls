@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Fiscal de Entradas'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MM_FISCAL_ENTRADAS
  as select from           I_BR_NFItem                 as NFItem
    inner join             I_BR_NFDocument             as _NFDoc                    on _NFDoc.BR_NotaFiscal = NFItem.BR_NotaFiscal
    inner join             j_1bnfdoc                   as _Doc                      on _Doc.docnum = NFItem.BR_NotaFiscal
    left outer join        I_Product                   as _Material                 on _Material.Product = NFItem.Material

    left outer join        ZI_MM_RETENCAO_FILT_ACCOUNT as _DocCont                  on _DocCont.OriginalReferenceDocument = NFItem.BR_NFSourceDocumentNumber

    left outer join        ZI_MM_RETENCAO_FILT_BRHIST  as _DeliveryReference        on  _DeliveryReference.SubsequentDocument     = NFItem.BR_NFSourceDocumentNumber
                                                                                    and _DeliveryReference.SubsequentDocumentItem = NFItem.BR_NFSourceDocumentItem

    left outer join        I_DeliveryDocument          as _DeliveryDocument         on _DeliveryDocument.DeliveryDocument = _DeliveryReference.PrecedingDocument

  //  I_PurgDocScheduleLineBasic
  //    left outer to one join ZI_MM_SCHED_LINE            as _SchedLine                on  _SchedLine.PurchasingDocument     = NFItem.PurchaseOrder
  //                                                                                    and _SchedLine.PurchasingDocumentItem = NFItem.PurchaseOrderItem

    left outer to one join ZI_MM_SCHED_LINE_GROUP      as _SchedLine                on  _SchedLine.PurchasingDocument     = NFItem.PurchaseOrder
                                                                                    and _SchedLine.PurchasingDocumentItem = NFItem.PurchaseOrderItem

  //and (_SchedLine.PurchasingDocumentItem = lpad(NFItem.PurchaseOrderItem, 6, '0') or _SchedLine.PurchasingDocumentItem2 = lpad(NFItem.PurchaseOrderItem, 6, '0'))
  //and _SchedLine.ScheduleLine           = '0001'

    left outer to one join        ztsd_gp_mercador            as _regra_gp_mercador        on  _regra_gp_mercador.centro        = NFItem.Plant
                                                                                    and _regra_gp_mercador.uf            = 'CE'
                                                                                    and _regra_gp_mercador.grpmercadoria = NFItem.MaterialGroup

    left outer to one join        ztsd_material               as _regra_material           on  _regra_material.centro   = NFItem.Plant
                                                                                    and _regra_material.uf       = 'CE'
                                                                                    and _regra_material.material = NFItem.Material


    left outer to one join t001w                       as _RegioOrigem              on _RegioOrigem.werks = NFItem.Plant



    left outer to one join ZI_MM_IMPOSTOS_PRINCIPAL    as _ICMSTax                  on  _ICMSTax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _ICMSTax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                                    and _ICMSTax.TaxGroup          = 'ICMS'

    left outer to one join ZI_MM_IMPOSTOS_PRINCIPAL    as _SubstTax                 on  _SubstTax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _SubstTax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                                    and _SubstTax.TaxGroup          = 'ICST'

    left outer to one join ZI_MM_IMPOSTOS_PRINCIPAL    as _IPITax                   on  _IPITax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _IPITax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                                    and _IPITax.TaxGroup          = 'IPI'

    left outer to one join ZI_MM_IMPOSTOS_PRINCIPAL    as _IITax                    on  _IITax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _IITax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                                    and _IITax.TaxGroup          = 'II'

    left outer to one join ztsd_gp_mercador            as _st_reembolso_gp_mercador on  _st_reembolso_gp_mercador.centro        = NFItem.Plant
                                                                                    and _st_reembolso_gp_mercador.uf            = _NFDoc.BR_NFPartnerRegionCode
                                                                                    and _st_reembolso_gp_mercador.grpmercadoria = NFItem.MaterialGroup

    left outer to one join ztsd_material               as _st_reembolso_material    on  _st_reembolso_material.centro   = NFItem.Plant
                                                                                    and _st_reembolso_material.uf       = _NFDoc.BR_NFPartnerRegionCode
                                                                                    and _st_reembolso_material.material = NFItem.Material

    left outer to one join ZI_MM_FIS_ENT_BASE_INSS     as _baseInssNew              on  _baseInssNew.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _baseInssNew.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
    left outer to one join        ZI_MM_FIS_ENT_MONT_ST       as _montanteST               on  _montanteST.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _montanteST.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

    left outer to one join        ZI_MM_IMPOSTOS_TOTAL        as _totalImposto             on  _totalImposto.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _totalImposto.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
    left outer to one join        I_Supplier                  as _supplier                 on _supplier.Supplier = _Doc.parid
    left outer to one join        I_Customer                  as _customer                 on _customer.Customer = _Doc.parid

    left outer to one join ZI_MM_IMPOSTOS_TOT_ICST     as _totICST                  on  _totICST.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                                    and _totICST.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
    left outer to one join        ZI_MM_LAST_CLSCONTAB        as _FltEKKN                  on  _FltEKKN.Pedido = NFItem.PurchaseOrder
                                                                                    and _FltEKKN.Item   = NFItem.PurchaseOrderItem
    left outer to one join        ekkn                        as _Ekkn                     on  _Ekkn.ebeln = _FltEKKN.Pedido
                                                                                    and _Ekkn.ebelp = _FltEKKN.ItemNconv
                                                                                    and _Ekkn.zekkn = _FltEKKN.Contador

  --------------------------------------------------------------------------------------------------------------
  -- Sempre criaremos dois registros, e no filtro de seleção será filtrado um dos dois
  --------------------------------------------------------------------------------------------------------------
  association [0..1] to ZI_MM_VH_CONVERTER_KG     as _ConverterKG           on  _ConverterKG.ObjetoName = 'Sim'
                                                                            or  _ConverterKG.ObjetoName = 'Não'

  //    left outer join ESH_N_ACCOUNTING_DOC_BKPF as _DocCont       on _DocCont.awkey = NFItem.BR_NFSourceDocumentNumber
  //    left outer join acdoca                   as _DocCont        on  _DocCont.rbukrs = _NFDoc.CompanyCode
  //                                                                and _DocCont.belnr  = _NFDoc.AccountingDocument
  //                                                                and _DocCont.gjahr  = _NFDoc.BR_NFFiscalYear
  //    LEFT OUTER JOIN ZI_MM_RETENCAO_INSS AS _RINSS on  _RINSS.Docnum

  association [0..1] to I_BR_NFeActive            as _NFeActive             on  _NFeActive.BR_NotaFiscal = NFItem.BR_NotaFiscal

  association [0..1] to ZI_MM_PARCEIRO            as _Parceiro              on  _Parceiro.BR_NotaFiscal = NFItem.BR_NotaFiscal

  association [0..1] to ZI_MM_EMISSOR_ORDEM       as _EmissOrdem            on  _EmissOrdem.BR_NotaFiscal = NFItem.BR_NotaFiscal

  association [0..1] to ZI_MM_MONTANTE            as _Montante              on  _Montante.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _Montante.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to I_PurchasingDocument      as _PurchasingDocument    on  _PurchasingDocument.PurchasingDocument = NFItem.PurchaseOrder

  association [0..1] to ZI_MM_NF_BR_SALEORDER     as _SalesOrder            on  _SalesOrder.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _SalesOrder.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to ZI_MM_DOC_FATURAMENTO     as _DocFaturamento        on  _DocFaturamento.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _DocFaturamento.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to ZI_MM_VENCTO_DOC_FAT      as _VenctoDocFat          on  _VenctoDocFat.SupplierInvoice = _NFDoc.AccountingDocument
                                                                            and _VenctoDocFat.FiscalYear      = _NFDoc.BR_NFFiscalYear

  //  association [0..1] to V_WB2_RBKP_RSEG_1          as _DocFat                 on  _DocFat.belnr = NFItem.BR_ReferenceNFNumber
  //                                                                              and _DocFat.gjahr = _NFDoc.BR_NFFiscalYear
  //                                                                              and _DocFat.buzei = NFItem.BR_ReferenceNFItem

  //  association [0..1] to ZI_MM_DOC_REMESSA          as _Remessa               on  _Remessa.BR_NotaFiscal     = NFItem.BR_NotaFiscal
  //                                                                             and _Remessa.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to ZI_MM_MIRO_MIGO           as _Miro_Migo             on  _Miro_Migo.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _Miro_Migo.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to I_ProductUnitsOfMeasure   as _MarmNF                on  _MarmNF.Product         = NFItem.Material
                                                                            and _MarmNF.AlternativeUnit = $projection.NFBaseUnit

  association [0..1] to I_ProductUnitsOfMeasure   as _MarmKG                on  _MarmKG.Product         = NFItem.Material
                                                                            and _MarmKG.AlternativeUnit = 'KG '

  association [0..1] to I_ProductUnitsOfMeasure   as _MarmBase              on  _MarmBase.Product         = NFItem.Material
                                                                            and _MarmBase.AlternativeUnit = _Material.BaseUnit

  association [0..1] to I_BR_NFTax                as _DifAliquota           on  _DifAliquota.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _DifAliquota.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _DifAliquota.TaxGroup          = 'ICOP'


  association [0..1] to ZI_MM_IMPOSTOS_PRINCIPAL  as _PISTax                on  _PISTax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _PISTax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _PISTax.TaxGroup          = 'PIS'

  association [0..1] to ZI_MM_IMPOSTOS_PRINCIPAL  as _COFINSTax             on  _COFINSTax.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _COFINSTax.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _COFINSTax.TaxGroup          = 'COFI'

  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSICAP              on  _ICMSICAP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _ICMSICAP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _ICMSICAP.TaxGroup          = 'ICMS'
                                                                            and _ICMSICAP.TaxType           = 'ICAP'

  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSICEP              on  _ICMSICEP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _ICMSICEP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _ICMSICEP.TaxGroup          = 'ICMS'
                                                                            and _ICMSICEP.TaxType           = 'ICEP'

  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSICSP              on  _ICMSICSP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _ICMSICSP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _ICMSICSP.TaxGroup          = 'ICMS'
                                                                            and _ICMSICSP.TaxType           = 'ICSP'

  //Substituído por ZI_MM_IMPOSTOS_TOT_ICST
  //  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSICFP              on  _ICMSICFP.BR_NotaFiscal     = NFItem.BR_NotaFiscal
  //                                                                            and _ICMSICFP.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
  //                                                                            and _ICMSICFP.TaxGroup          = 'ICST'
  //                                                                            and _ICMSICFP.TaxType           = 'ICFP'
  //
  //  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSFPS2              on  _ICMSFPS2.BR_NotaFiscal     = NFItem.BR_NotaFiscal
  //                                                                            and _ICMSFPS2.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
  //                                                                            and _ICMSFPS2.TaxGroup          = 'ICST'
  //                                                                            and _ICMSFPS2.TaxType           = 'FPS2'
  //
  //  association [0..1] to ZI_MM_IMPOSTOS            as _ICMSICS1              on  _ICMSICS1.BR_NotaFiscal     = NFItem.BR_NotaFiscal
  //                                                                            and _ICMSICS1.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
  //                                                                            and _ICMSICS1.TaxGroup          = 'ICST'
  //                                                                            and _ICMSICS1.TaxType           = 'ICS1'



  association [0..1] to I_Withholdingtaxitem      as _Funrural              on  _Funrural.CompanyCode        = _NFDoc.CompanyCode
                                                                            and _Funrural.AccountingDocument = _DocCont.AccountingDocument
                                                                            and _Funrural.FiscalYear         = _NFDoc.BR_NFFiscalYear
                                                                            and _Funrural.WithholdingTaxType = 'IF'

  association [0..1] to I_Withholdingtaxitem      as _Inss                  on  _Inss.CompanyCode        = _NFDoc.CompanyCode
                                                                            and _Inss.AccountingDocument = _DocCont.AccountingDocument
                                                                            and _Inss.FiscalYear         = _NFDoc.BR_NFFiscalYear
                                                                            and _Inss.WithholdingTaxType = 'IJ'

  //  association [0..1] to I_Businesspartnerwhldgtax  as _WTax                  on  _WTax.BusinessPartner = $projection.Parceiro
  //                                                                             and _WTax.Supplier        = $projection.Parceiro
  //                                                                             and _WTax.CompanyCode     = $projection.companycode


  //    association [0..1] to I_MaterialDocumentRecord   as _MIGO                  on  _MIGO.PurchaseOrder     =  NFItem.PurchaseOrder
  //                                                                               and _MIGO.PurchaseOrderItem =  NFItem.PurchaseOrderItem
  //                                                                               and _MIGO.PurchaseOrder     <> ''

  association [0..1] to I_PurOrdAccountAssignment as _AccPO                 on  _AccPO.PurchaseOrder           = NFItem.PurchaseOrder
                                                                            and _AccPO.PurchaseOrderItem       = NFItem.PurchaseOrderItem
                                                                            and _AccPO.AccountAssignmentNumber = '01'

  //    association [0..1] to I_BR_PurchaseHistory       as _GoodsReceiptReference on  _GoodsReceiptReference.PurchaseOrder                = NFItem.PurchaseOrder
  //                                                                               and _GoodsReceiptReference.PurchaseOrderItem            = NFItem.PurchaseOrderItem
  //                                                                               and _GoodsReceiptReference.PurchaseOrderTransactionType = '1' //Goods Receipt

  //                                                                             and _DeliveryReference.PrecedingDocumentCategory = 'J' //Delivery
  //
  //    association [0..1] to I_BR_SaleHistory           as _SalesOrderReference   on  _SalesOrderReference.SubsequentDocument        = NFItem.BR_NFSourceDocumentNumber
  //                                                                               and _SalesOrderReference.SubsequentDocumentItem    = NFItem.BR_NFSourceDocumentItem
  //                                                                               and _SalesOrderReference.PrecedingDocumentCategory = 'C' //Order
  //
  //  association [0..1] to I_BR_SaleHistory           as _DebitMemoReference    on  _DebitMemoReference.SubsequentDocument        = NFItem.BR_NFSourceDocumentNumber
  //                                                                             and _DebitMemoReference.SubsequentDocumentItem    = NFItem.BR_NFSourceDocumentItem
  //                                                                             and _DebitMemoReference.PrecedingDocumentCategory = 'L' //Debit Memo

  //  association [0..1] to ZI_MM_RETENCAO_INSS       as _INSS                  on  _INSS.Docnum            = NFItem.BR_NotaFiscal
  //                                                                            and _INSS.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to ZI_MM_RETENCAO_TRIO       as _TRIO                  on  _TRIO.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _TRIO.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  association [0..1] to I_BR_NFTax                as _IRRF                  on  _IRRF.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _IRRF.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _IRRF.TaxGroup          = 'WHIR'

  association [0..1] to I_BR_NFTax                as _ISS                   on  _ISS.BR_NotaFiscal     = NFItem.BR_NotaFiscal
                                                                            and _ISS.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                                                            and _ISS.TaxGroup          = 'ISSS'

  //  association [0..1] to ZI_MM_BASE_INSS           as _BaseINSS              on  _BaseINSS.BR_NotaFiscal     = NFItem.BR_NotaFiscal
  //                                                                            and _BaseINSS.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem

  //  association [0..1] to bseg                       as _DocFatExt             on  _DocFatExt.bukrs = $projection.companycode
  //                                                                             and _DocFatExt.belnr = $projection.BR_ReferenceNFNumber
  //                                                                             and _DocFatExt.gjahr = $projection.BR_NFFiscalYear
  //                                                                             and _DocFatExt.buzei = $projection.BR_ReferenceNFItem3
  association [0..1] to v_ml_cepc_view            as _CEPC                  on  _CEPC.kokrs = 'AC3C'
                                                                            and _CEPC.prctr = NFItem.ProfitCenter

  //  association [0..1] to I_BR_ICMSTaxSituationText   as _ICMSTxt               on  _ICMSTxt.BR_ICMSTaxSituation = NFItem.BR_ICMSTaxSituation
  //                                                                              and _ICMSTxt.Language            = $session.system_language
  //
  //  association [0..1] to I_BR_TaxSituationIPIText    as _IPITxt                on  _IPITxt.BR_IPITaxSituation = NFItem.BR_IPITaxSituation
  //                                                                              and _IPITxt.Language           = $session.system_language
  //
  //  association [0..1] to I_BR_TaxSituationCOFINSText as _COFINSTxt             on  _COFINSTxt.BR_COFINSTaxSituation = NFItem.BR_COFINSTaxSituation
  //                                                                              and _COFINSTxt.Language              = $session.system_language
  //
  //  association [0..1] to I_BR_TaxSituationPISText    as _PISTxt                on  _PISTxt.BR_PISTaxSituation = NFItem.BR_COFINSTaxSituation
  //                                                                              and _PISTxt.Language           = $session.system_language

  association [0..1] to I_SalesDocumentTypeText   as _SalesDocumentTypeText on  _SalesDocumentTypeText.SalesDocumentType = $projection.TipoDocVenda
                                                                            and _SalesDocumentTypeText.Language          = $session.system_language

  association [0..1] to I_BR_TaxLawICMSText       as _ICMSTxt               on  _ICMSTxt.BR_ICMSTaxLaw = NFItem.BR_ICMSTaxLaw
                                                                            and _ICMSTxt.Language      = $session.system_language

  association [0..1] to I_BR_TaxLawIPIText        as _IPITxt                on  _IPITxt.BR_IPITaxLaw = NFItem.BR_IPITaxLaw
                                                                            and _IPITxt.Language     = $session.system_language

  association [0..1] to I_BR_TaxLawCOFINSText     as _COFINSTxt             on  _COFINSTxt.BR_COFINSTaxLaw = NFItem.BR_COFINSTaxLaw
                                                                            and _COFINSTxt.Language        = $session.system_language

  association [0..1] to I_BR_TaxLawPISText        as _PISTxt                on  _PISTxt.BR_PISTaxLaw = NFItem.BR_PISTaxLaw
                                                                            and _PISTxt.Language     = $session.system_language

  association [0..1] to tvaut                     as _MotivoOrdem           on  _MotivoOrdem.augru = $projection.MotivoOrdem
                                                                            and _MotivoOrdem.spras = $session.system_language

  association [0..1] to I_GLAccountText           as _AccPOText             on  _AccPOText.GLAccount       = $projection.glaccount
                                                                            and _AccPOText.ChartOfAccounts = 'PC3C'
                                                                            and _AccPOText.Language        = $session.system_language


{
  key NFItem.BR_NotaFiscal                                                                                                          as BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem                                                                                                      as BR_NotaFiscalItem,
      NFItem._BR_NotaFiscal.BR_NFPostingDate                                                                                        as BR_NFPostingDate,
      NFItem._BR_NotaFiscal.BR_NFIssueDate                                                                                          as BR_NFIssueDate,
      //      _Doc.nfnum                                                                                                                    as BR_NFNumber,
      //      NFItem._BR_NotaFiscal.BR_NFeNumber                                                                                            as BR_NFeNumber,
      case
          when _Doc.nfnum <> '000000'
            then lpad(_Doc.nfnum, 9, '0' )
            else cast(NFItem._BR_NotaFiscal.BR_NFeNumber as abap.numc( 9 )) end                                                     as BR_NFNumber,
      NFItem._BR_NotaFiscal.BR_NFSituationCode                                                                                      as BR_NFSituationCode,
      NFItem.Material                                                                                                               as Material,
      NFItem.ValuationArea                                                                                                          as ValuationArea,
      NFItem.ValuationType                                                                                                          as ValuationType,
      NFItem.BR_CFOPCode                                                                                                            as BR_CFOPCode,
      NFItem._BR_NotaFiscal.CompanyCode                                                                                             as CompanyCode,
      _SalesOrder._Header.SalesOrganization                                                                                         as SalesOrganization,
      _SalesOrder._Header.DistributionChannel                                                                                       as DistributionChannel,
      _SalesOrder._Header.OrganizationDivision                                                                                      as OrganizationDivision,
      _SalesOrder._Header.SalesDocumentType                                                                                         as TipoDocVenda,
      _SalesOrder._Header.SalesOffice                                                                                               as SalesOffice,
      NFItem._BR_NotaFiscal.BusinessPlace                                                                                           as BusinessPlace,
      NFItem.Plant                                                                                                                  as Plant,
      NFItem.MaterialGroup                                                                                                          as MaterialGroup,
      _SalesOrder._Header.SDDocumentReason                                                                                          as MotivoOrdem,
      _PurchasingDocument.PurchasingGroup                                                                                           as PurchasingGroup,
      _CEPC.segment                                                                                                                 as segment,
      _Parceiro.icmstaxpay                                                                                                          as icmstaxpay,
      _Parceiro.indtyp                                                                                                              as indtyp,
      _Parceiro.BRSCH                                                                                                               as BRSCH,
      _Parceiro.TDT                                                                                                                 as TDT,
      NFItem._BR_NotaFiscal.BR_NFPartnerType                                                                                        as BR_NFPartnerType,
      _Parceiro.Parceiro                                                                                                            as Parceiro,
      NFItem._BR_NotaFiscal.BR_NFPartnerTaxJurisdiction                                                                             as BR_NFPartnerTaxJurisdiction,
      NFItem._BR_NotaFiscal.BR_NFType                                                                                               as BR_NFType,
      _Parceiro.crtn                                                                                                                as crtn,

      cast( NFItem._BR_NotaFiscal.BR_NFIsCreatedManually as boole_d )                                                               as BR_NFIsCreatedManually,

      //      cast( case _NFDoc.BR_NFDirection
      //            when '1' then 'X'
      //                     else ' ' end as boole_d )                                                                                      as NF_Entrada,

      cast(_NFDoc.BR_NFHasServiceItem as boole_d)                                                                                   as BR_NFHasServiceItem,

      case _ConverterKG.ObjetoName
      when 'Sim' then cast( 'X' as boole_d )
      when 'Não' then cast( '' as boole_d )
      else '' end                                                                                                                   as ConverterKG,

      NFItem.MaterialName                                                                                                           as MaterialName,
      NFItem.SalesDocumentCurrency                                                                                                  as SalesDocumentCurrency,
      NFItem.BR_TaxCode                                                                                                             as BR_TaxCode,
      NFItem.BR_ICMSTaxLaw                                                                                                          as BR_ICMSTaxLaw,
      _ICMSTxt.BR_ICMSTaxLawDesc                                                                                                    as BR_ICMSTaxLawDesc,
      NFItem.BR_ICMSTaxSituation                                                                                                    as BR_ICMSTaxSituation,
      //      _ICMSTxt.BR_ICMSTaxSituationDesc,
      NFItem.BR_IPITaxLaw                                                                                                           as BR_IPITaxLaw,
      _IPITxt.BR_IPITaxLawDesc                                                                                                      as BR_IPITaxLawDesc,
      NFItem.BR_IPITaxSituation                                                                                                     as BR_IPITaxSituation,
      //      _IPITxt.BR_IPITaxSituationDesc,
      NFItem.BR_COFINSTaxLaw                                                                                                        as BR_COFINSTaxLaw,
      _COFINSTxt.BR_COFINSTaxLawDesc                                                                                                as BR_COFINSTaxLawDesc,
      NFItem.BR_COFINSTaxSituation                                                                                                  as BR_COFINSTaxSituation,
      //      _COFINSTxt.BR_COFINSTaxSituationDesc,
      NFItem.BR_PISTaxLaw                                                                                                           as BR_PISTaxLaw,
      _PISTxt.BR_PISTaxLawDesc                                                                                                      as BR_PISTaxLawDesc,
      NFItem.BR_PISTaxSituation                                                                                                     as BR_PISTaxSituation,
      //      _PISTxt.BR_PISTaxSituationDesc,
      NFItem.Batch                                                                                                                  as Batch,
      //      NFItem.CostCenter                                                                                                             as CostCenter,
      @EndUserText.label: 'Centro de Custo'
      case when NFItem.BR_NFSourceDocumentType <> 'BI'
             then _Ekkn.kostl
             else NFItem.CostCenter end                                                                                             as CostCenter,

      case when _NFDoc.BR_NFDirection = '1'
        then NFItem.PurchaseOrder
        else ''
      end                                                                                                                           as PurchaseOrder,

      case when _NFDoc.BR_NFDirection = '1'
        then NFItem.PurchaseOrderItem
        else ''
      end                                                                                                                           as PurchaseOrderItem,

      case when _NFDoc.BR_NFDirection = '1'
        then _SalesOrder.Ordem
        else ''
      end                                                                                                                           as SalesOrder,

      case when _NFDoc.BR_NFDirection = '1'
        then cast( _SalesOrder.OrdemItem as logbr_origin_refdocument )
        else ''
      end                                                                                                                           as SalesOrderItem,

      NFItem.NCMCode                                                                                                                as NCMCode,
      NFItem.BR_MaterialOrigin                                                                                                      as BR_MaterialOrigin,
      NFItem.BR_ReferenceNFNumber                                                                                                   as BR_ReferenceNFNumber,
      NFItem.BR_ReferenceNFItem                                                                                                     as BR_ReferenceNFItem,
      right(NFItem.BR_ReferenceNFItem,3)                                                                                            as BR_ReferenceNFItem3,
      abs( NFItem.BR_ExemptedICMSAmount )                                                                                           as BR_ExemptedICMSAmount,
      NFItem.BR_ICMSSTMarginAddedPercent                                                                                            as BR_ICMSSTMarginAddedPercent,
      NFItem.BaseUnit                                                                                                               as NFBaseUnit,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ICMSTax.BR_NFItemBaseAmount as abap.dec(15,2))                                                                         as BaseICMS,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast(
        case when _ICMSTax.BR_NFItemBaseAmount > 0
             then cast( _ICMSTax.BR_NFItemTaxAmount as abap.dec(15,2) )
             else cast( 0 as abap.dec(15,2) ) end as abap.dec(15,2) )                                                               as ValorICMS,

      _ICMSTax.BR_NFItemExcludedBaseAmount                                                                                          as IsentosICMS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ICMSTax.BR_NFItemOtherBaseAmount as abap.dec(15,2))                                                                    as OutrasICMS,

      case when _ICMSTax.BR_NFItemBaseAmount > 0 and _ICMSTax.BR_NFItemTaxAmount > 0
           then cast(_ICMSTax.BR_NFItemTaxRate as j_1btxrate preserving type)
           else cast('0' as abap.dec(6,2))
      end                                                                                                                           as AliqICMS,


      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _IPITax.BR_NFItemBaseAmount as abap.dec(15,2))                                                                          as BaseIPI,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'

      case when _IPITax.BR_NFItemBaseAmount = 0
      then 0
      else cast( _IPITax.BR_NFItemTaxAmount as abap.dec(15,2)) end                                                                  as ValorIPI,

      _IPITax.BR_NFItemExcludedBaseAmount                                                                                           as IsentosIPI,

      case when _IPITax.BR_NFItemBaseAmount = 0
      then 0
      else
      _IPITax.BR_NFItemTaxRate end                                                                                                  as AliqIPI,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _IPITax.BR_NFItemOtherBaseAmount as abap.dec(15,2))                                                                     as OutrasIPI,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _SubstTax.BR_NFItemBaseAmount as abap.dec(15,2))                                                                        as BaseSubst,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      case when _SubstTax.BR_NFItemBaseAmount = 0
      then 0
      else
      cast( _SubstTax.BR_NFItemTaxAmount as abap.dec(15,2)) end                                                                     as ValorSubst,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _PISTax.BR_NFItemBaseAmount as abap.dec(15,2))                                                                          as BasePIS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _PISTax.BR_NFItemTaxAmount as abap.dec(15,2))                                                                           as ValorPIS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _COFINSTax.BR_NFItemBaseAmount as abap.dec(15,2))                                                                       as BaseCOFINS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _COFINSTax.BR_NFItemTaxAmount as abap.dec(15,2))                                                                        as ValorCOFINS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ICMSICAP.BR_NFItemTaxAmount as abap.dec(15,2))                                                                         as ICMSICAP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ICMSICEP.BR_NFItemTaxAmount as abap.dec(15,2))                                                                         as ICMSICEP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ICMSICSP.BR_NFItemTaxAmount as abap.dec(15,2))                                                                         as ICMSICSP,

      case when _DeliveryDocument.CreationDate is not initial
            and _DeliveryDocument.CreationDate <> '00000000'
           then _DeliveryDocument.CreationDate
           else _SchedLine.ScheduleLineDeliveryDate end                                                                             as ScheduleLineDeliveryDate,

      _VenctoDocFat.VencNota                                                                                                        as VencNota,

      //      case when _st_reembolso_material.icms_efet is not initial
      //             or _st_reembolso_material.baseredefet is not initial
      //           then _st_reembolso_material.icms_efet
      //           when _st_reembolso_gp_mercador.icms_efet is not initial
      //             or _st_reembolso_gp_mercador.baseredefet is not initial
      //           then _st_reembolso_gp_mercador.icms_efet
      //           else cast( '0' as abap.dec(6,2) )
      //      end                                                                                                                           as MontanteST,

      //(cast(NFItem.BR_SubstituteICMSAmount as abap.dec(15,2)) + cast(NFItem.BR_WithholdingICMSSTAmount as abap.dec(15,2)) - cast(NFItem.BR_EffectiveICMSAmount as abap.dec(15,2))) as MontanteST,
      //      case when
      //        _montanteST.MontanteST < 0
      //      then 0
      //      else _montanteST.MontanteST end                                                                                               as MontanteST,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB_ENT'
      cast( 0  as abap.dec( 17, 2 ) )                                                                                               as MontanteST,

      //      case when _st_reembolso_material.icms_efet is not initial
      //             or _st_reembolso_material.baseredefet is not initial
      //           then _st_reembolso_material.baseredefet
      //           when _st_reembolso_gp_mercador.icms_efet is not initial
      //             or _st_reembolso_gp_mercador.baseredefet is not initial
      //           then _st_reembolso_gp_mercador.baseredefet
      //           else cast( '0' as abap.dec(6,2) )
      //      end                                                                                                                           as BaseST,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB_ENT'
      cast(NFItem.BR_WithholdingICMSSTBaseAmount as abap.dec(15,2))                                                                 as BaseST,

      case when _ConverterKG.ObjetoId = ' '
        then NFItem.BaseUnit
        else
          case when _MarmKG.AlternativeUnit = 'KG'
            then _MarmKG.AlternativeUnit
            else NFItem.BaseUnit
          end
      end                                                                                                                           as BaseUnit,

      //      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      cast(
      case when _ConverterKG.ObjetoId = ' '
        then
          cast( NFItem.QuantityInBaseUnit as abap.dec( 13, 3 ) )

        else

          case when _MarmKG.AlternativeUnit = 'KG'
            then
              cast( NFItem.QuantityInBaseUnit as abap.dec( 13, 3 ) ) *
              DIVISION( (_MarmNF.QuantityNumerator   * _MarmKG.QuantityDenominator ),
                        (_MarmNF.QuantityDenominator * _MarmKG.QuantityNumerator), 6)
            else
              cast( NFItem.QuantityInBaseUnit as abap.dec( 13, 3 ) ) *
              division( _MarmNF.QuantityNumerator, _MarmNF.QuantityDenominator, 6)
          end

      end
      as abap.dec(13,3))                                                                                                            as QuantityInBaseUnit,

      //      @Semantics.quantity.unitOfMeasure:'UnidMedMaterial'
      cast( cast( NFItem.QuantityInBaseUnit as abap.dec( 13, 3 ) ) *
        DIVISION( (_MarmNF.QuantityNumerator   * _MarmBase.QuantityDenominator ),
                  (_MarmNF.QuantityDenominator * _MarmBase.QuantityNumerator), 6)
                  as abap.dec(13,3) )                                                                                               as QtdUnMedMaterial,

      NFItem.BR_ICMSStatisticalExemptionAmt                                                                                         as BR_ICMSStatisticalExemptionAmt,
      NFItem.TaxIncentiveCode                                                                                                       as TaxIncentiveCode,
      _NFDoc.BR_NFFiscalYear                                                                                                        as BR_NFFiscalYear,
      _NFDoc.BR_NFPartnerCountryCode                                                                                                as BR_NFPartnerCountryCode,
      _NFDoc.BR_NFPartnerRegionCode                                                                                                 as BR_NFPartnerRegionCode,

      case when _NFDoc.BR_NFPartnerCNPJ is not initial
           then cast( _NFDoc.BR_NFPartnerCNPJ as abap.char(14) )
           else cast( ''  as abap.char(14) ) end                                                                                    as BR_NFPartnerCNPJ,

      case when _NFDoc.BR_NFPartnerCPF is not initial
           then cast( _NFDoc.BR_NFPartnerCPF as abap.char(11) )
           else cast( ''  as abap.char(11) ) end                                                                                    as BR_NFPartnerCPF,

      _NFDoc.BR_NFPartnerStateTaxNumber                                                                                             as BR_NFPartnerStateTaxNumber,
      _NFDoc.BR_IsNFe                                                                                                               as BR_IsNFe,
      _NFDoc.BR_NFObservationText                                                                                                   as BR_NFObservationText,
      _DocCont.AccountingDocument                                                                                                   as AccountingDocument,
      _NFDoc.BR_NFPartnerCityName                                                                                                   as BR_NFPartnerCityName,
      _NFDoc.BR_NFReferenceDocument                                                                                                 as BR_NFReferenceDocument,
      _NFDoc.BR_SUFRAMACode                                                                                                         as BR_SUFRAMACode,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      case when NFItem.TaxIncentiveCode is not initial
           then cast( NFItem.BR_NFTotalAmount as abap.dec(15,2) )
           else cast( '0' as abap.dec(15,2) ) end                                                                                   as BaseSemBenef,

      _NFDoc.CreatedByUser                                                                                                          as CreatedByUser,
      _NFDoc.HeaderWeightUnit                                                                                                       as HeaderWeightUnit,
      //      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      //      _NFDoc.HeaderGrossWeight                                                                   as HeaderGrossWeight,
      fltp_to_dec( (cast( _Material.GrossWeight as abap.fltp ) * cast( NFItem.QuantityInBaseUnit as abap.fltp )) as abap.dec(15,2)) as HeaderGrossWeight,

      _Miro_Migo.DocMigo                                                                                                            as MaterialDocument,
      _Miro_Migo.AnoMigo                                                                                                            as MaterialDocumentYear,

      _Miro_Migo.DocMiro                                                                                                            as DocMiro,
      _Miro_Migo.AnoMiro                                                                                                            as AnoMiro,

      //      case when _NFDoc.BR_NFExportShipmentRegion = 'CE'
      //           then 'X'
      //           else ' '
      //      end                                                                                        as STEntradaCE,

      case
      when _regra_gp_mercador.grpmercadoria is not initial or _regra_material.material is not initial
          then
             case
              when _RegioOrigem.regio = 'CE' and _NFDoc.BR_NFPartnerRegionCode <> 'CE'
                  then 'X'
              else ''
              end
      else ''
      end                                                                                                                           as STEntradaCE,

      NFItem.BR_NFSourceDocumentNumber                                                                                              as BR_NFSourceDocumentNumber,
      NFItem.BR_NFSourceDocumentItem                                                                                                as BR_NFSourceDocumentItem,
      _DocFaturamento.BR_NFSourceDocumentNumber                                                                                     as DocFat_NFSourceDocumentNumber,
      _Parceiro.NomeParceiro                                                                                                        as NomeParceiro,
      _EmissOrdem.EmissorOrdem                                                                                                      as EmissorOrdem,
      _Material.BaseUnit                                                                                                            as UnidMedMaterial,

      case when NFItem.InternationalArticleNumber is not initial
           then NFItem.InternationalArticleNumber
           else _Material.ProductStandardID end                                                                                     as ProductStandardID,

      _PurchasingDocument.CreationDate                                                                                              as CreationDate,
      _NFDoc.BR_NFModel                                                                                                             as BR_NFeModel,

      concat(_NFeActive.Region,
      concat(_NFeActive.BR_NFeIssueYear,
      concat(_NFeActive.BR_NFeIssueMonth,
      concat(_NFeActive.BR_NFeAccessKeyCNPJOrCPF,
      concat(_NFeActive.BR_NFeModel,
      concat(_NFeActive.BR_NFeSeries,
      concat(_NFeActive.BR_NFeNumber,
      concat(_NFeActive.BR_NFeRandomNumber, _NFeActive.BR_NFeCheckDigit) ) ) ) ) ) ) )                                              as AchaveAcesso,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _DifAliquota.BR_NFItemBaseAmount as abap.dec(15,2))                                                                     as BaseDifAliquota,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _DifAliquota.BR_NFItemTaxAmount  as abap.dec(15,2))                                                                     as ICMSDifAliquota,

      _SalesOrder._Item.j_1btxsdc                                                                                                   as CodImposto,
      _DeliveryReference.PrecedingDocument                                                                                          as DocRemessa,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //cast( _Montante.ValorProdutos as abap.dec(15,2))                                                                              as ValorProdutos,
      cast( NFItem.BR_NFValueAmountWithTaxes as abap.dec(15,2))                                                                     as ValorProdutos,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      _Montante.DescontoINC                                                                                                         as DescontoINC,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //cast( _Montante.Frete as abap.dec(15,2))                                                                                      as Frete,
      cast( NFItem.BR_NFFreightAmountWithTaxes as abap.dec(15,2))                                                                   as Frete,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //cast( _Montante.TotalSemFrete as abap.dec(15,2))                                                                              as TotalSemFrete,
      //@Semantics.amount.currencyCode:'SalesDocumentCurrency'
//     (
//       cast(NFItem.BR_NFValueAmountWithTaxes as abap.dec(15,2)) +
//           cast( _IPITax.BR_NFItemTaxAmount as abap.dec(15,2)) +
//           cast( _SubstTax.BR_NFItemTaxAmount as abap.dec(15,2))
//        +
//        cast(_Montante.ValorICMSFCP as abap.dec(15,2))
//     )                                                                                                                             as TotalSemFrete,

//     (
//       cast(NFItem.BR_NFValueAmountWithTaxes as abap.dec(15,2)) +
//       case
//          when _IPITax.BR_NFItemBaseAmount = 0
//           or _IPITax.BR_NFItemTaxAmount is initial
//            or _IPITax.BR_NFItemTaxAmount is null
//            then cast('0' as abap.dec(15,2))
//          else cast( _IPITax.BR_NFItemTaxAmount as abap.dec(15,2))
//        end +
//        case
//          when _SubstTax.BR_NFItemBaseAmount = 0
//            or _SubstTax.BR_NFItemTaxAmount is initial
//            or _SubstTax.BR_NFItemTaxAmount is null
//            then cast('0' as abap.dec(15,2))
//          else cast( _SubstTax.BR_NFItemTaxAmount as abap.dec(15,2))
//        end +
//        cast(_Montante.ValorICMSFCP as abap.dec(15,2))
//     )                                                                                                                             as TotalSemFrete,
      (

      case
        when _NFDoc.BR_NFPartnerCountryCode = 'BR'
          or _supplier.Country              = 'BR'
          or _customer.Country              = 'BR'
      then
          cast( NFItem.BR_NFValueAmountWithTaxes  as abap.dec(15,2))
          +
          cast( NFItem.BR_NFDiscountAmountWithTaxes  as abap.dec(15,2))
          +
          cast( NFItem.BR_NFExemptedICMSWithTaxes   as abap.dec(15,2))
          +
          cast( NFItem.BR_NFFreightAmountWithTaxes    as abap.dec(15,2))
          +
          cast( NFItem.BR_NFInsuranceAmountWithTaxes    as abap.dec(15,2))
          +
          cast( NFItem.BR_NFExpensesAmountWithTaxes     as abap.dec(15,2))
          +
      //coalesce(cast( _SubstTax.BR_NFItemTaxAmount as abap.dec(15,2)),0) -new
          +
          coalesce(cast( _IPITax.BR_NFItemTaxAmount as abap.dec(15,2)),0)
          +
          coalesce(cast( _IITax.BR_NFItemTaxAmount as abap.dec(15,2)),0)
          +
          coalesce(cast( _totICST.BR_NFItemTaxAmount as abap.dec(15,2)),0)

      //+
      //coalesce(cast( _ICMSICFP.BR_NFItemTaxAmount as abap.dec(15,2)),0) -new
      //+
      //coalesce(cast( _ICMSFPS2.BR_NFItemTaxAmount as abap.dec(15,2)),0) - new
      //                +
      //                coalesce(cast( _ICMSICS1.BR_NFItemTaxAmount as abap.dec(15,2)),0)
      else
        cast( NFItem.BR_NFValueAmountWithTaxes  as abap.dec(15,2))
        +
        cast( NFItem.BR_NFDiscountAmountWithTaxes  as abap.dec(15,2))
        +
        cast( NFItem.BR_NFExemptedICMSWithTaxes   as abap.dec(15,2))
        +
        cast( NFItem.BR_NFFreightAmountWithTaxes    as abap.dec(15,2))
        +
        cast( NFItem.BR_NFInsuranceAmountWithTaxes    as abap.dec(15,2))
        +
        cast( NFItem.BR_NFExpensesAmountWithTaxes     as abap.dec(15,2))
        +
        coalesce(cast( _totalImposto.BR_NFItemTaxAmount  as abap.dec(15,2)),0) end       
      
      
      
      
      
      - cast( NFItem.BR_NFFreightAmountWithTaxes as abap.dec(15,2))  )                                                                                                                              as TotalSemFrete,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      case when NFItem.BR_NotaFiscalItem = '000010'
      //             or NFItem.BR_NotaFiscalItem = '000001'
      //Observação: a cds _baseInssNew.BR_NotaFiscalItem retorna o menor item da NF, então uso ele aqui para setar valor com base no menor item
      case when NFItem.BR_NotaFiscalItem = _baseInssNew.BR_NotaFiscalItem
        then cast( _Montante.TotalNota as abap.dec(15,2))
        else cast( '0' as abap.dec(15,2)) end                                                                                       as TotalNF,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      case when _Funrural.WhldgTaxAmtInCoCodeCrcy is not null
        then cast( _Montante.BaseCalcFunrural as abap.dec(15,2))
        else cast( '0' as abap.dec(15,2)) end                                                                                       as BaseCalcFunrural,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _Montante.BcICMSFCP as abap.dec(15,2))                                                                                  as BcICMSFCP,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _Montante.ValorICMSFCP as abap.dec(15,2))                                                                               as ValorICMSFCP,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB_ENT'
      cast( _Montante.BaseSTFCP as abap.dec(15,2))                                                                                  as BaseSTFCP,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB_ENT'
      cast( _Montante.ValorSTFCP as abap.dec(15,2))                                                                                 as ValorSTFCP,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( NFItem.NetValueAmount as abap.dec(15,2))                                                                                as NetValueAmount,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      cast( NFItem.BR_NFValueAmountWithTaxes as abap.dec(15,2))                                                                     as ValorTotal,
      case
        when _NFDoc.BR_NFPartnerCountryCode = 'BR'
          or _supplier.Country              = 'BR'
          or _customer.Country              = 'BR'
      then
          cast( NFItem.BR_NFValueAmountWithTaxes  as abap.dec(15,2))
          +
          cast( NFItem.BR_NFDiscountAmountWithTaxes  as abap.dec(15,2))
          +
          cast( NFItem.BR_NFExemptedICMSWithTaxes   as abap.dec(15,2))
          +
          cast( NFItem.BR_NFFreightAmountWithTaxes    as abap.dec(15,2))
          +
          cast( NFItem.BR_NFInsuranceAmountWithTaxes    as abap.dec(15,2))
          +
          cast( NFItem.BR_NFExpensesAmountWithTaxes     as abap.dec(15,2))
          +
      //coalesce(cast( _SubstTax.BR_NFItemTaxAmount as abap.dec(15,2)),0) -new
          +
          coalesce(cast( _IPITax.BR_NFItemTaxAmount as abap.dec(15,2)),0)
          +
          coalesce(cast( _IITax.BR_NFItemTaxAmount as abap.dec(15,2)),0)
          +
          coalesce(cast( _totICST.BR_NFItemTaxAmount as abap.dec(15,2)),0)

      //+
      //coalesce(cast( _ICMSICFP.BR_NFItemTaxAmount as abap.dec(15,2)),0) -new
      //+
      //coalesce(cast( _ICMSFPS2.BR_NFItemTaxAmount as abap.dec(15,2)),0) - new
      //                +
      //                coalesce(cast( _ICMSICS1.BR_NFItemTaxAmount as abap.dec(15,2)),0)
      else
        cast( NFItem.BR_NFValueAmountWithTaxes  as abap.dec(15,2))
        +
        cast( NFItem.BR_NFDiscountAmountWithTaxes  as abap.dec(15,2))
        +
        cast( NFItem.BR_NFExemptedICMSWithTaxes   as abap.dec(15,2))
        +
        cast( NFItem.BR_NFFreightAmountWithTaxes    as abap.dec(15,2))
        +
        cast( NFItem.BR_NFInsuranceAmountWithTaxes    as abap.dec(15,2))
        +
        cast( NFItem.BR_NFExpensesAmountWithTaxes     as abap.dec(15,2))
        +
        coalesce(cast( _totalImposto.BR_NFItemTaxAmount  as abap.dec(15,2)),0) end                                                  as ValorTotal,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( cast( _Funrural.WhldgTaxAmtInCoCodeCrcy as abap.dec(23,2) ) * -1 as abap.dec(23,2) )                                    as Funrural,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _Funrural.WithholdingTaxPercent  as gvpro )                                                                             as PercFunrural,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      case when NFItem.TaxIncentiveCode is not initial
      //        then fltp_to_dec( cast(NFItem.NetValueAmount as abap.fltp)
      //                      * ( cast(_ICMSTax.BR_NFItemTaxRate as abap.fltp)
      //                        / cast( '100' as abap.fltp) )
      //                      - cast( _ICMSTax.BR_NFItemTaxAmount as abap.fltp ) as abap.dec( 15, 2 ) )
      //        else cast( '0' as abap.dec(15,2) ) end                                                                                      as ICMSSemBenef,

      //      case when NFItem.TaxIncentiveCode is not initial
      //        then fltp_to_dec( cast(NFItem.NetValueAmount as abap.fltp) *
      //                        ( cast(_ICMSTax.BR_NFItemTaxRate as abap.fltp) / cast( '100' as abap.fltp) ) as abap.dec( 15, 2 ) )
      //        else cast( '0' as abap.dec(15,2) ) end                                                                                      as ICMSSemBenef,


      //            case
      //              when NFItem.TaxIncentiveCode is not initial
      //              then
      //      //        cast(
      //      //        cast(NFItem.BR_NFTotalAmount as abap.dec( 15, 2 ) ) as teste *
      //      //             div( _ICMSTax.BR_NFItemTaxRate, 100 ) as abap.dec( 15, 2 ) )
      //                fltp_to_dec(
      //                  coalesce( cast(NFItem.BR_NFTotalAmount as abap.fltp), 0 ) *
      //                  coalesce( cast(_ICMSTax.BR_NFItemTaxRate as abap.fltp), 0 ) /
      //                  cast( '100' as abap.fltp)
      //                as abap.dec( 15, 2 ) )
      //              else
      //                0 end
      _ICMSTax.BR_NFItemTaxRate                                                                                                     as BR_NFItemTaxRate,
      cast(NFItem.BR_NFTotalAmount as abap.dec( 15, 2 ))                                                                            as BR_NFTotalAmount,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB_ENT'
      cast(0 as abap.dec( 15, 2 ))                                                                                                  as ICMSSemBenef,

      //        case when _ICMSTax.BR_NFItemTaxRate > 0
      //        then
      //            fltp_to_dec(coalesce(cast(NFItem.BR_NFTotalAmount as abap.fltp),0)  * coalesce(cast(_ICMSTax.BR_NFItemTaxRate as abap.fltp),0) / cast( '100' as abap.fltp) as abap.dec( 15, 2 ))
      //        else 0 end as ICMSSemBenef,

      ''                                                                                                                            as TextDirFiscICMS1,
      ''                                                                                                                            as TextDirFiscICMS2,
      ''                                                                                                                            as TextDirFiscICMS3,
      ''                                                                                                                            as TextDirFiscIPI,
      //      @Semantics.amount.currencyCode:'MoedaINSS'
      abs(cast( _Inss.WhldgTaxAmtInTransacCrcy as abap.dec(23,2)))                                                                  as INSS,
      _Inss.DocumentCurrency                                                                                                        as MoedaINSS,
      _Inss.WithholdingTaxPercent                                                                                                   as PercentINSS,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      abs(cast( _IRRF.BR_NFItemTaxAmount as abap.dec(15,2)))                                                                        as IRRF,
      _IRRF.BR_NFItemTaxRate                                                                                                        as PercentIRRF,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _IRRF.BR_NFItemBaseAmount as abap.dec(15,2))                                                                            as BaseIRRF,
      _IRRF.BR_NFItemWhldgCollectionCode                                                                                            as CodReceitaIRRF,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ISS.BR_NFItemTaxAmount as abap.dec(15,2))                                                                              as ISS,
      _ISS.BR_NFItemTaxRate                                                                                                         as PercentISS,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _ISS.BR_NFItemBaseAmount as abap.dec(15,2))                                                                             as BaseISS,
      _ISS.TaxJurisdiction                                                                                                          as DomFiscISS,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _TRIO.TRIO as abap.dec(15,2))                                                                                           as TRIO,
      _TRIO.PercentTRIO                                                                                                             as PercentTRIO,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      cast( _TRIO.BaseTRIO as abap.dec(15,2))                                                                                       as BaseTRIO,
      _TRIO.CodReceitaTRIO                                                                                                          as CodReceitaTRIO,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //cast( _BaseINSS.BR_NFItemBaseAmount  as abap.dec(15,2))                                                                       as BaseCalcINSS,
      case
        when _Inss.WhldgTaxAmtInTransacCrcy = 0 or _Inss.WhldgTaxAmtInTransacCrcy is null
      then
        0
      else
          case when _NFDoc.BR_NFHasServiceItem <> 'X'
               then 0
               else _baseInssNew.BR_NFNetAmount
           end
       end                                                                                                                          as BaseCalcINSS,


      NFItem.ProfitCenter                                                                                                           as ProfitCenter,

      /* Associatins */

      _AccPO.GLAccount,
      _AccPOText,
      _SalesDocumentTypeText,
      _MotivoOrdem
           
}
where
      _NFDoc.BR_NFDocumentType <> '5' -- Cancelar
  and _NFDoc.BR_NFDirection    <> '2' -- NF Saída
