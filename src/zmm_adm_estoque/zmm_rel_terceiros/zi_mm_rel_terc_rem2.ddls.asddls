@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Remessa para armazenagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_REM2 as select from           I_BR_NFDocument        as Doc
    inner join             ZI_MM_REL_TERC_NFITEM  as Item   on  Doc.BR_NotaFiscal            = Item.BR_NotaFiscal
                                                            and Item.BR_NFSourceDocumentType = 'MD'
    inner join j_1bnfe_active as active   on  active.docnum = Doc.BR_NotaFiscal
    
    left outer to one join ZI_MM_REL_TERC_WERKS   as Regio  on Regio.BR_NotaFiscal = Item.BR_NotaFiscal
    left outer to one join I_MaterialDocumentItem as MatDoc on  Item.BR_NFSourceDocumentNumber   = MatDoc.MaterialDocument
                                                            and MatDoc.InventorySpecialStockType is not initial 
    left outer to one join I_BR_NFTax             as Tax    on  Item.BR_NotaFiscal     = Tax.BR_NotaFiscal
                                                            and Item.BR_NotaFiscalItem = Tax.BR_NotaFiscalItem
                                                            and Tax.TaxGroup = 'ICMS'                                                            
{

  key Doc.CompanyCode                                              as Empresa,

  key Doc.BR_NFPartner                                             as BusinessPartner,
  key Item.Material                                                as Material,
  key Item.BR_NotaFiscalItem                                       as NfItem,
  key Item.BR_NotaFiscal                                           as DocnumRemessa,
  key Tax.BR_TaxType                                               as TipoImposto

    
}
