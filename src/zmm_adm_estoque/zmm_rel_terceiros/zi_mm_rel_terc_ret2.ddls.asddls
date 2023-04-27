@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Retorno2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_RET2
  as select from           I_BR_NFDocument        as Doc
    inner join             ZI_MM_REL_TERC_NFITEM  as Item   on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'
  //    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
  //                                                            and MatDoc.InventorySpecialStockType <> '' //is not null
  //    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
  //                                                            and MatDoc.InventorySpecialStockType is not null
    left outer to one join I_MaterialDocumentItem as MatDoc on  MatDoc.MaterialDocument       = Item.BR_NFSourceDocumentNumber
                                                            and MatDoc.MaterialDocumentYear   = Item.BR_NFSourceDocumentNumberYear // right( Item.BR_NFSourceDocumentNumber ,4 )                                                            
                                                            and (MatDoc.IssgOrRcvgSpclStockInd = 'O' or MatDoc.IssgOrRcvgSpclStockInd is initial)
                                                            and MatDoc.Material               = Item.Material

    left outer join        I_BR_NFTax             as Tax    on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup           = 'ICMS'

    //left outer to one join ZI_MM_REL_TERC_PURS    as Item2 on Item2.BR_NotaFiscal           = Doc.BR_NotaFiscal 
                                                           //and Item2.BR_NFSourceDocumentType = 'MD'
                                                            //on  Item2.PurchaseOrder           = MatDoc.PurchaseOrder
                                                            //and Item2.PurchaseOrderItem       = MatDoc.PurchaseOrderItem
                                                            //and Item2.Material                = MatDoc.Material

   left outer to one join ZI_MM_REL_TERC_CHAVE_NF as ChvNF   on ChvNF.docnum = Doc.BR_NotaFiscal
   left outer to one join /xnfe/innfehd           as xnfehd  on xnfehd.nfeid = ChvNF.BR_NFeAccessKey
   left outer join        /xnfe/innfenfe          as xnfeitm on xnfeitm.guid_header = xnfehd.guid_header
   left outer to one join ZI_MM_REL_TERC_CHAVE_NF as ChvNF2  on ChvNF2.BR_NFeAccessKey = xnfeitm.access_key
   left outer to one join I_BR_NFDocument         as Doc2    on Doc2.BR_NotaFiscal = ChvNF2.docnum                                                            

   inner join             ztmm_operacao          as Oper   on  Item.BR_CFOPCode = Oper.cfop_int
                                                            and Oper.tipo        = '2'

{
//  key Item2.BR_NotaFiscal                                          as DocRef,
//      Doc.CompanyCode                                              as Empresa,
//      Doc.BR_NFPartner                                             as BusinessPartner,
  key Doc2.BR_NotaFiscal                                           as DocRef,
      Doc2.CompanyCode                                             as Empresa,
      Doc2.BR_NFPartner                                            as BusinessPartner, 
      //Item2.Material                                               as MaterialRemessa,
      Item.Material                                                as Material,
      Item.BR_NotaFiscalItem                                       as NfItem,
      Item.BR_NotaFiscal                                           as DocnumRetorno,
      Tax.BR_TaxType                                               as TipoImposto,
//      Doc.BR_NFPartner                                             as CodFornecedorRT,
//      Doc.BR_NFPartnerName1                                        as DescFornecedor,
      Doc2.BR_NFPartner                                            as CodFornecedorRT,
      Doc2.BR_NFPartnerName1                                       as DescFornecedor,
      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRetorno,
      MatDoc.GoodsMovementType                                     as Movimento,
      //      Doc.BR_NFNumber                                              as NFRetorno,
      Doc.BR_NFeNumber                                             as NFRetorno,
//      Doc.BR_NFIssueDate                                           as DataRetorno,
      Doc2.BR_NFIssueDate                                          as DataRetorno,
      
      Item.BR_NFSourceDocumentNumber                               as DocMaterial,
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
//      Doc.BR_NFPostingDate                                         as DataLancamentoRT,
//      Doc.BR_NFIssueDate                                           as DataDocumentoRT
      Doc2.BR_NFPostingDate                                        as DataLancamentoRT,
      Doc2.BR_NFIssueDate                                          as DataDocumentoRT

}
where
      Item.BR_CFOPCode      <> ''
  and Doc.BR_NFIsCanceled   is initial
  and Doc.BR_NFDocumentType <> '5'
group by
  //Doc.CompanyCode,
  //Doc.BR_NFPartner,
  //Item2.Material,
  Item.Material,
  Item.BR_NotaFiscalItem,
  Item.BR_NotaFiscal,
  Tax.BR_TaxType,
  //Doc.BR_NFPartner,
  //Doc.BR_NFPartnerName1,
  Item.NetPriceAmount,
  Item.BR_CFOPCode,
  MatDoc.GoodsMovementType,
  //  Doc.BR_NFNumber,
  Doc.BR_NFeNumber,
  //Doc.BR_NFIssueDate,
  Item.BR_NFSourceDocumentNumber,
  //Item2.BR_NotaFiscal,
  Item.Material,
  Item.MaterialName,
  Item.QuantityInBaseUnit,
  Item.QuantityInBaseUnit,
  Item.BaseUnit,
  Item.NetValueAmount,
  MatDoc.StorageLocation,
  MatDoc.Batch,
  //  Item.Batch,
  Item.NCMCode,
  Tax.BR_NFItemBaseAmount,
  Tax.BR_NFItemOtherBaseAmount,
  Tax.BR_NFItemExcludedBaseAmount,
  Tax.BR_NFItemTaxRate,
  Tax.BR_NFItemTaxAmount,
  Doc2.BR_NotaFiscal,
  Doc2.CompanyCode,
  Doc2.BR_NFPartner,
  Doc2.BR_NFPartner ,
  Doc2.BR_NFPartnerName1,
  Doc2.BR_NFIssueDate,
  Doc2.BR_NFPostingDate,
  Doc2.BR_NFIssueDate  
  //Doc.BR_NFPostingDate,
  //Doc.BR_NFIssueDate
