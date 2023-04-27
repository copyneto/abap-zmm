@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cálculo de Prazo de Pagamento'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_calculo_prazo_pagamento
  as select from    V_WB2_RBKP_RSEG_1        as _rbkp_rseg
    inner join      I_SupplierInvoice        as _supplierInvoice        on  _supplierInvoice.SupplierInvoice = _rbkp_rseg.belnr
                                                                        and _supplierInvoice.FiscalYear      = _rbkp_rseg.gjahr

    inner join      C_SuplrInvcItQty         as _suplrInvcItQty         on  _suplrInvcItQty.SupplierInvoice     = _rbkp_rseg.belnr
                                                                        and _suplrInvcItQty.SupplierInvoiceYear = _rbkp_rseg.gjahr
                                                                        and _suplrInvcItQty.SupplierInvoiceItem = _rbkp_rseg.buzei
    inner join      rbkp                     as _rbkp                   on  _rbkp.belnr = _rbkp_rseg.belnr
                                                                        and _rbkp.gjahr = _rbkp_rseg.gjahr


    left outer join I_SupDmndOvwItemPO       as _supDmndOvwItemPO       on  _supDmndOvwItemPO.PurchasingDocument     = _suplrInvcItQty.PurchaseOrder
                                                                        and _supDmndOvwItemPO.PurchasingDocumentItem = _suplrInvcItQty.PurchaseOrderItem
  //    left outer join P_PurOrdItemAcctAssgmt as _purOrdItemAcctAssgmt on  _purOrdItemAcctAssgmt.PurchaseOrder  = _suplrInvcItQty.PurchaseOrder
  //                                                                    and _purOrdItemAcctAssgmt.PurchaseOrderItem = _suplrInvcItQty.PurchaseOrderItem
  //   left outer join C_ChartOfAccountsListItem
    left outer join R_PurchasingDocumentItem as _purchasingDocumentItem on  _purchasingDocumentItem.PurchasingDocument     = _suplrInvcItQty.PurchaseOrder
                                                                        and _purchasingDocumentItem.PurchasingDocumentItem = _suplrInvcItQty.PurchaseOrderItem


{
  key _rbkp_rseg.belnr                               as belnr,
  key _rbkp_rseg.gjahr                               as gjahr,
  key _rbkp_rseg.buzei                               as buzei,
      _supplierInvoice.SupplierInvoiceIDByInvcgParty as SupplierInvoiceIDByInvcgParty,
      _rbkp_rseg.bukrs                               as bukrs,
      _suplrInvcItQty.PurchaseOrder                  as PurchaseOrder,
      _rbkp_rseg.budat                               as budat,
      _rbkp_rseg.llief                               as llief,
      _rbkp_rseg.matnr                               as matnr,
      _supDmndOvwItemPO.DocumentCurrency             as DocumentCurrency,
      @Semantics.amount.currencyCode : 'DocumentCurrency'
      _supDmndOvwItemPO.NetPriceAmount               as NetPriceAmount,
      _supDmndOvwItemPO.NetPriceQuantity             as NetPriceQuantity,
      @Semantics.amount.currencyCode : 'DocumentCurrency'
      _rbkp.rmwwr                                    as NetAmount,
      //      _supDmndOvwItemPO.NetAmount                    as NetAmount,
      //P_PurOrdItemAcctAssgmt    GLAccount                  "CONTA CONTÁBIL
      //C_ChartOfAccountsListItem GLAccountName              "DESCRIÇÃO DA CONTA
      //P_PurOrdItemAcctAssgmt    CostCenter                 "CENTRO DE CUSTO
      _purchasingDocumentItem.TaxCode                as TaxCode,
      _rbkp_rseg.werks                               as werks,
      _rbkp_rseg.bldat                               as bldat,
      //_rbkp_rseg.budat as budat,
      _supplierInvoice.CreatedByUser                 as CreatedByUser,
      _rbkp_rseg.bupla                               as bupla


      //I_SupplierInvoice         SupplierInvoiceIDByInvcgParty    "NÚMERO DE REFERÊNCIA DA NOTA
      //V_WB2_RBKP_RSEG_1         bukrs                            "EMPRESA
      //C_SuplrInvcItQty          PurchaseOrder                    "PEDIDO
      //V_WB2_RBKP_RSEG_1         budat                            "LANÇAMENTO
      //V_WB2_RBKP_RSEG_1         llief                            "FORNECEDOR
      //A_BusinessPartner         BusinessPartnerFullName          "NOME FORNECEDOR
      //V_WB2_RBKP_RSEG_1         matnr                      "MATERIAL
      //I_SupDmndOvwItemPO        NetPriceAmount             "VALOR ITEM DO PEDIDO
      //I_SupDmndOvwItemPO        NetAmount                  "VALOR TOTAL PEDIDO
      //P_PurOrdItemAcctAssgmt    GLAccount                  "CONTA CONTÁBIL
      //C_ChartOfAccountsListItem GLAccountName              "DESCRIÇÃO DA CONTA
      //P_PurOrdItemAcctAssgmt    CostCenter                 "CENTRO DE CUSTO
      //CDS_PO_ITEMS_P            MWSKZ                      "IVA
      //V_WB2_RBKP_RSEG_1         werks                      "CENTRO
      //V_WB2_RBKP_RSEG_1         bldat                      "DATA DOCUMENTO
      //V_WB2_RBKP_RSEG_1         budat                      "DATA LANÇAMENTO
      //I_SupplierInvoice         CreatedByUser              "USUÁRIO
      //V_WB2_RBKP_RSEG_1         bupla                      "LOCAL DE NEGÓCIO




}
