@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de retorno 2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_MM_TERC_RET3 

as select from           I_BR_NFDocument        as Doc
    inner join             ZI_MM_REL_TERC_NFITEM  as Item   on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'
    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
                                                            and MatDoc.InventorySpecialStockType is not null

    left outer join        I_BR_NFTax             as Tax    on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup = 'ICMS'

    left outer to one join ZI_MM_REL_TERC_PURS    as Item2  on  
                                                                Item2.BR_NotaFiscal       = Doc.BR_NotaFiscal
//                                                                Item2.PurchaseOrder           = MatDoc.PurchaseOrder
//                                                            and Item2.PurchaseOrderItem       = MatDoc.PurchaseOrderItem
//                                                            and Item2.Material                = MatDoc.Material
                                                            and Item2.BR_NFSourceDocumentType = 'MD'
                                                            
   left outer to one join I_MaterialDocumentHeader as MatDocH on MatDocH.MaterialDocument = Item2.DocumentNumber
                                                                 and MatDocH.DocumentDate = Doc.CreationDate   
   left outer to one join I_BR_NFDocument as Doc2 on 
                                                     Doc2.BR_NFeNumber = ltrim(MatDocH.MaterialDocumentHeaderText, '0') 
                                                     and Doc2.BR_NFPartner = Doc.BR_NFPartner
                                                     and Doc2.CreationDate = Doc.CreationDate  

    inner join             ztmm_operacao          as Oper   on  Item.BR_CFOPCode = Oper.cfop_int
                                                            and Oper.tipo        = '2'

{
  key Doc2.BR_NotaFiscal                                          as DocRef,
//  Doc2.BR_NFeNumber,
//  MatDocH.MaterialDocumentHeaderText,
//  Item2.DocumentNumber,
//  Item2.PurchaseOrderItem       ,
//  MatDoc.PurchaseOrderItem as xxx,
//      Item2.BR_NotaFiscal                                          as DocRef,
      Doc2.CompanyCode                                              as Empresa,
      Doc2.BR_NFPartner                                             as BusinessPartner,
      
      Item.Material                                                as Material,
      Item.BR_NotaFiscalItem                                       as NfItem,
      Item.BR_NotaFiscal                                           as DocnumRetorno,
      Tax.BR_TaxType                                               as TipoImposto,
//     'teste'                                             as CodFornecedorRT,
      Doc2.BR_NFPartner                                             as CodFornecedorRT,
      Doc2.BR_NFPartnerName1                                        as DescFornecedor,
      
      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRetorno,
      MatDoc.GoodsMovementType                                     as Movimento,
      //      Doc.BR_NFNumber                                              as NFRetorno,
      Doc2.BR_NFeNumber                                             as NFRetorno,
      Doc2.BR_NFIssueDate                                           as DataRetorno,
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
      
      Doc2.BR_NFPostingDate                                         as DataLancamentoRT,  
      Doc2.BR_NFIssueDate                                           as DataDocumentoRT
//      MatDocH.MaterialDocumentHeaderText

}
where
      Item.BR_CFOPCode    <> ''
  and Doc.BR_NFIsCanceled is initial
      and Doc.BR_NotaFiscal = '0000008486'
group by
  Doc2.BR_NotaFiscal,
  Doc2.CompanyCode,
  Doc2.BR_NFPartner,
  Item.Material,
  Item.BR_NotaFiscalItem,
  Item.BR_NotaFiscal,
  Tax.BR_TaxType,
  Doc2.BR_NFPartner,
  Doc2.BR_NFPartnerName1,
  Item.NetPriceAmount,
  Item.BR_CFOPCode,
  MatDoc.GoodsMovementType,
  //  Doc.BR_NFNumber,
  Doc2.BR_NFeNumber,
  Doc2.BR_NFIssueDate,
  Item.BR_NFSourceDocumentNumber,
  Item2.BR_NotaFiscal,
  Item.Material,
  Item.MaterialName,
  Item.QuantityInBaseUnit,
  Item.QuantityInBaseUnit,
  Item.BaseUnit,
  Item.NetValueAmount,
  MatDoc.StorageLocation,
  Item.Batch,
  Item.NCMCode,
  Tax.BR_NFItemBaseAmount,
  Tax.BR_NFItemOtherBaseAmount,
  Tax.BR_NFItemExcludedBaseAmount,
  Tax.BR_NFItemTaxRate,
  Tax.BR_NFItemTaxAmount,
  Doc2.BR_NFPostingDate,
  Doc2.BR_NFIssueDate 
