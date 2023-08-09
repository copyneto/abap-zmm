@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help NF/NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_NFENTRAD
  as select from ZI_MM_FISCAL_ENTRADAS
  join I_BR_NFItem as NFItem on ZI_MM_FISCAL_ENTRADAS.BR_NotaFiscal = NFItem.BR_NotaFiscal and
                                ZI_MM_FISCAL_ENTRADAS.BR_NotaFiscalItem = NFItem.BR_NotaFiscalItem
                                
  join j_1bnfdoc as _Doc on NFItem.BR_NotaFiscal = _Doc.docnum                                  
{
 @EndUserText.label: 'Nota Fiscal'
 
//Comentado pois ocorre dump quando utiliza pesquisa em campos com expressões (concat, case, etc..)      
//      @Search.ranking: #MEDIUM
//      @Search.defaultSearchElement: true
//      @Search.fuzzinessThreshold: 0.8
  key ZI_MM_FISCAL_ENTRADAS.BR_NFNumber,  
  //Implementados para não ocorrer dump utilizando pesquisas em campos com expressões (concat, case, etc..)
  @Search.defaultSearchElement: true
  @Search.ranking: #HIGH  
  @Search.fuzzinessThreshold: 0.7  
  @UI.hidden: true  
  key _Doc.docnum,
  @Search.defaultSearchElement: true  
  @Search.ranking: #HIGH
  @Search.fuzzinessThreshold: 0.7
  @UI.hidden: true  
  key NFItem._BR_NotaFiscal.BR_NFeNumber,
  ZI_MM_FISCAL_ENTRADAS.Parceiro,
  ZI_MM_FISCAL_ENTRADAS.NomeParceiro   
  
}
where
  ZI_MM_FISCAL_ENTRADAS.BR_NFNumber is not initial
group by
  ZI_MM_FISCAL_ENTRADAS.BR_NFNumber,  
  _Doc.docnum,
  NFItem._BR_NotaFiscal.BR_NFeNumber,
  ZI_MM_FISCAL_ENTRADAS.Parceiro,
  ZI_MM_FISCAL_ENTRADAS.NomeParceiro   
