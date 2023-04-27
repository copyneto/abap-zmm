@AbapCatalog.sqlViewName: 'ZI_MM_REL_CONS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de retorno'
define view ZI_MM_REL_TERC_RET3
  as select from           I_BR_NFDocument          as Doc
    inner join             ZI_MM_REL_TERC_NFITEM    as Item    on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                               and Item.BR_NFSourceDocumentType = 'MD'
  //    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
  //                                                            and MatDoc.InventorySpecialStockType <> '' //is not null
    left outer to one join I_MaterialDocumentItem   as MatDoc  on  MatDoc.MaterialDocument       = Item.BR_NFSourceDocumentNumber
                                                               and MatDoc.MaterialDocumentYear   = Item.BR_NFSourceDocumentNumberYear // right( Item.BR_NFSourceDocumentNumber ,4 )
                                                               and MatDoc.IssgOrRcvgSpclStockInd = 'O'
                                                               and MatDoc.Material               = Item.Material

    left outer join        I_BR_NFTax               as Tax     on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                               and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                               and Tax.TaxGroup           = 'ICMS'

    left outer to one join ZI_MM_REL_TERC_PURS      as Item2   on  Item2.BR_NotaFiscal           = Doc.BR_NotaFiscal
    //                                                                Item2.PurchaseOrder           = MatDoc.PurchaseOrder
    //                                                            and Item2.PurchaseOrderItem       = MatDoc.PurchaseOrderItem
    //                                                            and Item2.Material                = MatDoc.Material
                                                               and Item2.BR_NFSourceDocumentType = 'MD'

    left outer to one join I_MaterialDocumentHeader as MatDocH on  MatDocH.MaterialDocument = Item2.DocumentNumber
                                                               and MatDocH.DocumentDate     = Doc.CreationDate
    left outer to one join I_BR_NFDocument          as Doc2    on  Doc2.BR_NFeNumber = ltrim(
      MatDocH.MaterialDocumentHeaderText, '0'
    )
                                                               and Doc2.BR_NFPartner = Doc.BR_NFPartner
                                                               and Doc2.CreationDate = Doc.CreationDate

    inner join             ztmm_operacao            as Oper    on  Item.BR_CFOPCode = Oper.cfop_int
                                                               and Oper.tipo        = '2'                                                                                                      

{
  key Doc2.BR_NotaFiscal                                           as DocRef,
      //  Doc2.BR_NFeNumber,
      //  MatDocH.MaterialDocumentHeaderText,
      //  Item2.DocumentNumber,
      //  Item2.PurchaseOrderItem       ,
      //  MatDoc.PurchaseOrderItem as xxx,
      //      Item2.BR_NotaFiscal                                          as DocRef,
      Doc2.CompanyCode                                             as Empresa,
      Doc2.BR_NFPartner                                            as BusinessPartner,
      cast('' as matnr)                                            as MaterialRemessa,
      cast('' as matnr)                                            as MaterialAtribuido,
      Item.Material                                                as Material,
      Item.BR_NotaFiscalItem                                       as NfItem,
      Item.BR_NotaFiscal                                           as DocnumRetorno,
      Tax.BR_TaxType                                               as TipoImposto,
      //     'teste'                                             as CodFornecedorRT,
      Doc2.BR_NFPartner                                            as CodFornecedorRT,
      Doc2.BR_NFPartnerName1                                       as DescFornecedor,

      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRetorno,
      MatDoc.GoodsMovementType                                     as Movimento,
      //      '000001'                   as NFRetorno,
      cast( Doc.BR_NFeNumber  as abap.char( 6 ) )                  as NFRetorno,
      //Doc.BR_NFNumber                                              as NFRetorno,
      //Doc2.BR_NFeNumber                                             as NFRetorno,
      Doc2.BR_NFIssueDate                                          as DataRetorno,
      Item.BR_NFSourceDocumentNumber                               as DocMaterial,
      Item.Material                                                as CodMaterial,
      Item.MaterialName                                            as DescMaterial,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      Item.QuantityInBaseUnit                                      as Qtde,
      cast(Item.QuantityInBaseUnit as abap.dec(13,3))               as QtdeRT,
      Item.BaseUnit                                                as UnidMedida,
      cast( 'BRL' as abap.cuky( 5 ) )                              as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      Item.NetValueAmount                                          as ValorTotal,
      MatDoc.StorageLocation                                       as Deposito,
      //      Item.Batch                                                   as Lote,
      MatDoc.Batch                                                 as Lote,
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

      Doc2.BR_NFPostingDate                                        as DataLancamentoRT,
      Doc2.BR_NFIssueDate                                          as DataDocumentoRT
      //      MatDocH.MaterialDocumentHeaderText
      //,MatDoc.MaterialDocument
}
where
      Item.BR_CFOPCode    <> ''

  and Doc.BR_NFIsCanceled is initial
//      and Doc.BR_NotaFiscal = '9000008486'
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
  //Doc.BR_NFNumber,
  Doc.BR_NFeNumber,
  //Doc2.BR_NFeNumber,
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
  //  Item.Batch,
  MatDoc.Batch,
  Item.NCMCode,
  Tax.BR_NFItemBaseAmount,
  Tax.BR_NFItemOtherBaseAmount,
  Tax.BR_NFItemExcludedBaseAmount,
  Tax.BR_NFItemTaxRate,
  Tax.BR_NFItemTaxAmount,
  Doc2.BR_NFPostingDate,
  Doc2.BR_NFIssueDate
//  ,MatDoc.MaterialDocument

//  *****************************************************************

union select from        I_BR_NFDocument         as Doc
  inner join             ZI_MM_REL_TERC_NFITEM   as Item    on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'

  inner join             j_1bnfe_active          as active  on active.docnum = Doc.BR_NotaFiscal

//  left outer to one join I_MaterialDocumentItem  as MatDoc  on  Item.BR_NFSourceDocumentNumber   =  MatDoc.MaterialDocument
//                                                            and MatDoc.InventorySpecialStockType <> '' //is not null
  left outer to one join I_MaterialDocumentItem  as MatDoc  on  MatDoc.MaterialDocument       = Item.BR_NFSourceDocumentNumber
                                                            and MatDoc.MaterialDocumentYear   = Item.BR_NFSourceDocumentNumberYear // right( Item.BR_NFSourceDocumentNumber ,4 )
                                                            and MatDoc.IssgOrRcvgSpclStockInd = 'O'
                                                            and MatDoc.Material               = Item.Material

  left outer join        I_BR_NFTax              as Tax     on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup           = 'ICMS'


  left outer to one join ZI_MM_REL_TERC_PURS     as Item2   on  Item2.BR_NotaFiscal           = Doc.BR_NotaFiscal
                                                            and Item2.BR_NFSourceDocumentType = 'MD'

  left outer to one join ZI_MM_REL_TERC_CHAVE_NF as ChvNF   on ChvNF.docnum = Doc.BR_NotaFiscal
  left outer to one join /xnfe/innfehd           as xnfehd  on xnfehd.nfeid = ChvNF.BR_NFeAccessKey
  left outer join        /xnfe/innfenfe          as xnfeitm on xnfeitm.guid_header = xnfehd.guid_header
  left outer to one join ZI_MM_REL_TERC_CHAVE_NF as ChvNF2  on ChvNF2.BR_NFeAccessKey = xnfeitm.access_key


//   left outer to one join I_MaterialDocumentHeader as MatDocH on MatDocH.MaterialDocument = Item2.DocumentNumber
//                                                                 and MatDocH.DocumentDate = Doc.CreationDate
//

  left outer to one join I_BR_NFDocument         as Doc2    on Doc2.BR_NotaFiscal = ChvNF2.docnum
//                                                     Doc2.BR_NFeNumber = ltrim(MatDocH.MaterialDocumentHeaderText, '0')
//                                                      Doc2.BR_NFPartner = Doc.BR_NFPartner
//                                                     and Doc2.CreationDate = Doc.CreationDate

  inner join             ztmm_operacao           as Oper    on  Item.BR_CFOPCode = Oper.cfop_int
                                                            and Oper.tipo        = '2'
                                                            
  left outer join ZI_MM_REL_TERC_NFITEM as IteRem2 on   Doc2.BR_NotaFiscal = IteRem2.BR_NotaFiscal
                                                        and IteRem2.BR_NFSourceDocumentType = 'MD'                                                                                                                         

  left outer to one join ztmm_ret_arm_gv as retArmazenagem on  ChvNF.BR_NFeAccessKey = retArmazenagem.nfeid and 
                                                        //Item.Material = retArmazenagem.materialatribuido and
                                                        retArmazenagem.processo = '2' 
                                                                                                                                                                                
{
  key Doc2.BR_NotaFiscal                                           as DocRef,
      Doc2.CompanyCode                                             as Empresa,
      Doc2.BR_NFPartner                                            as BusinessPartner, 
      IteRem2.Material                                             as MaterialRemessa,
      retArmazenagem.materialatribuido                             as MaterialAtribuido,            
      Item.Material                                                as Material,
      Item.BR_NotaFiscalItem                                       as NfItem,
      Item.BR_NotaFiscal                                           as DocnumRetorno,
      Tax.BR_TaxType                                               as TipoImposto,
      Doc2.BR_NFPartner                                            as CodFornecedorRT,
      Doc2.BR_NFPartnerName1                                       as DescFornecedor,

      Item.NetPriceAmount                                          as ValorItem,
      Item.BR_CFOPCode                                             as CfopRetorno,
      MatDoc.GoodsMovementType                                     as Movimento,
      //      Doc.BR_NFNumber                                              as NFRetorno,
      cast( Doc.BR_NFeNumber  as abap.char( 6 ) )                  as NFRetorno,
      //      Doc2.BR_NFeNumber                                             as NFRetorno,
      //      Item.BR_NFeNumber                                             as NFRetorno,
      Doc2.BR_NFIssueDate                                          as DataRetorno,
      Item.BR_NFSourceDocumentNumber                               as DocMaterial,
      Item.Material                                                as CodMaterial,
      Item.MaterialName                                            as DescMaterial,
      @Semantics.quantity.unitOfMeasure: 'UnidMedida'
      Item.QuantityInBaseUnit                                      as Qtde,
      cast(Item.QuantityInBaseUnit as abap.dec(13,3))               as QtdeRT,
      Item.BaseUnit                                                as UnidMedida,
      cast( 'BRL' as abap.cuky( 5 ) )                              as Moeda,
      @Semantics.amount.currencyCode: 'Moeda'
      Item.NetValueAmount                                          as ValorTotal,
      MatDoc.StorageLocation                                       as Deposito,
      //      Item.Batch                                                   as Lote,
      MatDoc.Batch                                                 as Lote,
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

      Doc2.BR_NFPostingDate                                        as DataLancamentoRT,
      Doc2.BR_NFIssueDate                                          as DataDocumentoRT
      //        , MatDoc.MaterialDocument
}
where
      Item.BR_CFOPCode    <> ''
  and Doc.BR_NFIsCanceled is initial
//      and Doc2.BR_NotaFiscal = '0000008170'
//      and Doc.BR_NotaFiscal = '0000008725'
group by
  Doc2.BR_NotaFiscal,
  Doc2.CompanyCode,
  Doc2.BR_NFPartner,
  IteRem2.Material,
  retArmazenagem.materialatribuido,  
  Item.Material,
  Item.BR_NotaFiscalItem,
  Item.BR_NotaFiscal,
  Tax.BR_TaxType,
  Doc2.BR_NFPartner,
  Doc2.BR_NFPartnerName1,
  Item.NetPriceAmount,
  Item.BR_CFOPCode,
  MatDoc.GoodsMovementType,
  Doc.BR_NFeNumber,
  //  Doc.BR_NFNumber,
  //  Doc2.BR_NFeNumber,
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
  //  Item.Batch,
  MatDoc.Batch,
  Item.NCMCode,
  Tax.BR_NFItemBaseAmount,
  Tax.BR_NFItemOtherBaseAmount,
  Tax.BR_NFItemExcludedBaseAmount,
  Tax.BR_NFItemTaxRate,
  Tax.BR_NFItemTaxAmount,
  Doc2.BR_NFPostingDate,
  Doc2.BR_NFIssueDate
//  ,MatDoc.MaterialDocument
