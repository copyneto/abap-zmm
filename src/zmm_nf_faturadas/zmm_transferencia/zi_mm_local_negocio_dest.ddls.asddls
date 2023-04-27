@AbapCatalog.sqlViewName: 'ZVMM_LOCNEG_DEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para Local de Negocio Destino'
define view ZI_MM_LOCAL_NEGOCIO_DEST
  as select from I_BR_NFDocument as NFBrief

  association [0..*] to ZI_CA_PARAM_VAL as _Param on  Modulo            = 'MM'
                                                  and Chave1            = 'NFTYPE'
                                                  and Chave2            = 'DESTINO'
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
      NFBrief.BR_NFPartnerFunction = 'BR'
  and NFBrief.BR_NFDirection       = '1'
