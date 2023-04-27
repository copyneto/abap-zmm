@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca por Retorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_RET
  as select from           I_BR_NFDocument        as Doc
  //    inner join      I_BR_NFItem            as Item   on Doc.BR_NotaFiscal = Item.BR_NotaFiscal
    inner join             ZI_MM_REL_TERC_NFITEM  as Item   on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'
                                                            and Doc.BR_NFeDocumentStatus     = '1'
  //    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
  //                                                            and MatDoc.InventorySpecialStockType <> '' //is not initial
    left outer to one join I_MaterialDocumentItem as MatDoc on  MatDoc.MaterialDocument       = Item.BR_NFSourceDocumentNumber
                                                            and MatDoc.MaterialDocumentYear   = Item.BR_NFSourceDocumentNumberYear // right( Item.BR_NFSourceDocumentNumber ,4 )
                                                            and MatDoc.IssgOrRcvgSpclStockInd = 'O'
                                                            and MatDoc.Material               = Item.Material


  //    left outer join I_MaterialDocumentItem as MatDoc on Item.BR_NFSourceDocumentNumber = MatDoc.MaterialDocument
    left outer join        I_BR_NFTax             as Tax    on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup           = 'ICMS'
    inner join             ztmm_operacao          as Oper   on  Item.BR_CFOPCode = Oper.cfop_int
                                                            and Oper.tipo        = '2'

  association to parent ZI_MM_REL_TERC as _Main on  $projection.Empresa         = _Main.Empresa
                                                and $projection.BusinessPartner = _Main.CodFornecedor
                                                and $projection.Material        = _Main.Material
{

  key Doc.CompanyCode                                              as Empresa,
  key Doc.BR_NFPartner                                             as BusinessPartner,
  key Item.Material                                                as Material,
  key Item.BR_NotaFiscalItem                                       as NfItem,
  key Item.BR_NotaFiscal                                           as DocnumRetorno,
  key Tax.BR_TaxType                                               as TipoImposto,
      Doc.BR_NFPartner                                             as CodFornecedorRT,
      Doc.BR_NFPartnerName1                                        as DescFornecedor,
      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRetorno,


      MatDoc.GoodsMovementType                                     as Movimento,
      //      Doc.BR_NFNumber                                              as NFRetorno,
      Doc.BR_NFeNumber                                             as NFRetorno,
      Doc.BR_NFIssueDate                                           as DataRetorno,
      Item.BR_NFSourceDocumentNumber                               as DocMaterial,
      Doc.BR_NFReferenceDocument                                   as DocRef,
      Item.Material                                                as CodMaterial,
      Item.MaterialName                                            as DescMaterial,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      Item.QuantityInBaseUnit                                      as Qtde,
      cast(Item.QuantityInBaseUnit as abap.dec(8,3))               as QtdeRT,
      Item.BaseUnit                                                as UnidMedida,
      cast( 'BRL' as abap.cuky( 5 ) )                              as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      Item.NetValueAmount                                          as ValorTotal,
      MatDoc.StorageLocation                                       as Deposito,

      Item.Batch                                                   as Lote,
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
      Doc.BR_NFPostingDate                                         as DataLancamentoRT,
      Doc.BR_NFIssueDate                                           as DataDocumentoRT,

      _Main

}
where
      Item.BR_CFOPCode    <> ''
  and Doc.BR_NFIsCanceled is initial
