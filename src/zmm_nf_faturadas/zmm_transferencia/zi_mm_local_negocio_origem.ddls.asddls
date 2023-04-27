@AbapCatalog.sqlViewName: 'ZVMM_LOCNEG_ORIG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para Local de Negocio Origem'
define view ZI_MM_LOCAL_NEGOCIO_ORIGEM
  as select from I_BR_NFDocument as NFBrief

  association [0..*] to ZI_CA_PARAM_VAL as _Param on  Modulo            = 'MM'
                                                  and Chave1            = 'NFTYPE'
                                                  and Chave2            = 'ORIGEM'
                                                  and Sign              = 'I'
                                                  and Opt               = 'EQ'
                                                  and NFBrief.BR_NFType = _Param.Low
{
  key NFBrief.BR_NotaFiscal as BR_NotaFiscal,
      NFBrief.BusinessPlace as LocalNegocio,
      NFBrief.BR_NFType,

      _Param
}
where
      BR_NFPartnerFunction = 'BR'
  and BR_NFDirection       = '2'
