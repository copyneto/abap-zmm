@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Buscar por Remessa view 3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_REM_3
  as select from           I_BR_NFDocument        as Doc
  //    inner join             I_BR_NFItem            as Item   on Doc.BR_NotaFiscal = Item.BR_NotaFiscal
    inner join             ZI_MM_REL_TERC_NFITEM  as Item   on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'
    left outer to one join ZI_MM_REL_TERC_WERKS   as Regio  on Regio.BR_NotaFiscal = Item.BR_NotaFiscal

//left outer to one join
    left outer join I_MaterialDocumentItem as MatDoc on  MatDoc.MaterialDocument       = Item.BR_NFSourceDocumentNumber
                                                            and MatDoc.MaterialDocumentYear   = Item.BR_NFSourceDocumentNumberYear // right( Item.BR_NFSourceDocumentNumber ,4 )
                                                            and (MatDoc.IssgOrRcvgSpclStockInd = 'O' or MatDoc.IssgOrRcvgSpclStockInd = 'M' or MatDoc.IssgOrRcvgSpclStockInd is initial)
                                                            and MatDoc.Material               = Item.Material
                                                            and MatDoc.MaterialDocumentItem   = right(Item.BR_NFSourceDocumentItem,4 )
  //                                                            and MatDoc.InventorySpecialStockType is not initial

  //                                                            and Item.Material = MatDoc.Material
    left outer to one join I_BR_NFTax             as Tax    on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup           = 'ICMS'
    inner join             ztmm_operacao          as Oper   on  Item.BR_CFOPCode         = Oper.cfop_int
                                                            and MatDoc.GoodsMovementType = Oper.tp_mov
                                                            and (
                                                               Oper.tipo                 = '1'
                                                             )
    left outer to one join I_PurchaseOrderAPI01   as Purc   on Item.PurchaseOrder = Purc.PurchaseOrder

  association to parent ZI_MM_REL_TERC as _Main on  $projection.Empresa         = _Main.Empresa
                                                and $projection.BusinessPartner = _Main.CodFornecedor
                                                and $projection.Material        = _Main.Material

{

  key Doc.CompanyCode                                              as Empresa,

  key Doc.BR_NFPartner                                             as BusinessPartner,
  key Item.Material                                                as Material,
  key Item.BR_NotaFiscalItem                                       as NfItem,
  key Item.BR_NotaFiscal                                           as DocnumRemessa,
  key Tax.BR_TaxType                                               as TipoImposto,
      Doc.BR_NFPartner                                             as CodFornecedor,
      Doc.BR_NFPartnerName1                                        as DescFornecedor,
      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRemessa,
      MatDoc.GoodsMovementType                                     as Movimento,
      //      matdoc.bwart        as Movimento,
      //Doc.BR_NFeNumber                                             as NFRemessa,
      Doc.BR_NFeNumber                                             as NFRemessa,
      Doc.BR_NFIssueDate                                           as DataRemessa,
      //            Item.BR_NFSourceDocumentNumber  as DocMaterial,
      Item.BR_NFSourceDocumentNumber                               as MaterialMovement,
      Item.Material                                                as CodMaterial,
      Item.MaterialName                                            as DescMaterial,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      Item.QuantityInBaseUnit                                      as Qtde,
//      cast(Item.QuantityInBaseUnit as abap.dec(13,3))              as QtdeRM,
      cast(MatDoc.QuantityInBaseUnit as abap.dec(13,3))              as QtdeRM ,
      
      Item.BaseUnit                                                as UnidMedida,
      cast( 'BRL' as abap.cuky( 5 ) )                              as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      Item.NetValueAmount                                          as ValorTotal,
      MatDoc.Plant                                                 as Centro,
      MatDoc.StorageLocation                                       as Deposito,
      //      matdoc.werks                    as Centro,
      //      matdoc.lgort        as Deposito,
      Doc.BR_NFIssueDate                                           as DiasAberto,
      MatDoc.Batch                                                 as Lote,
      //      Item.Batch                                                   as Lote,
      Item.NCMCode                                                 as Ncm,
      @Semantics.amount.currencyCode: 'Moeda'
      Tax.BR_NFItemBaseAmount                                      as MontBasicRetorno,
      @Semantics.amount.currencyCode: 'Moeda'
      Tax.BR_NFItemOtherBaseAmount                                 as MontBasicRetorno2,
      @Semantics.amount.currencyCode: 'Moeda'
      cast(Tax.BR_NFItemExcludedBaseAmount as abap.curr( 15, 2 ) ) as MontBasicRetorno3,
      Tax.BR_NFItemTaxRate                                         as TaxaRetorno,
      @Semantics.amount.currencyCode: 'Moeda'
      Tax.BR_NFItemTaxAmount                                       as IcmsRetorno,
      Doc.BusinessPlace                                            as LocalNegocios,
      Oper.operacao                                                as Operacao,
      Regio.Regio                                                  as Regio,
      Regio.RegioDC                                                as RegioDC,
      Regio.RegioTW                                                as RegioTW,
      Doc.BR_NFPostingDate                                         as DataLancamentoRM,
      Doc.BR_NFIssueDate                                           as DataDocumentoRM,
      Item.BR_TaxCode                                              as Iva,
      Doc.BR_NFType                                                as CategoriaNFE,
      MatDoc.PurchaseOrder                                         as PedidoSub,
      Purc.PurchasingGroup                                         as GrupoCompra,
      Item.MaterialGroup                                           as GrupoMercado,
      //      Doc.BR_NFPartner                as CodFornecedor,

      Doc.CompanyCodeName                                          as DescEmpresa,
      Doc.BusinessPlace                                            as LocalNegocio,
      _Main,
      right(Item.BR_NotaFiscalItem,4 ) as xx
}
where
      Item.BR_CFOPCode    <> ''
  and Doc.BR_NFIsCanceled is initial
