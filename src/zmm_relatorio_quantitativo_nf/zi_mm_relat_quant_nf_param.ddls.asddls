@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Quantitativo NF - Parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RELAT_QUANT_NF_PARAM
  as select from    I_BR_NFDocument as Doc
    left outer join ZI_CA_PARAM_VAL as _Param on  _Param.Modulo = 'MM'
                                              and _Param.Chave1 = 'RELAT_QUANT_NF'
                                              and _Param.Chave2 = 'CATEGORIA_ENTRADA'
                                              and _Param.Sign   = 'I'
                                              and _Param.Opt    = 'EQ'
                                              and _Param.Low    = Doc.BR_NFType
{
  key Doc.BR_NotaFiscal as BR_NotaFiscal, 
      Doc.BR_NFType     as BR_NFType,

      case when _Param.Low is not initial
        then 'Fiscal'
        else 'Não Fiscal'
        end             as EntryCategory,

      case when _Param.Low is not initial
        then 3    -- Green
        else 1    -- Red
        end             as EntryCategoryCriticality

}
