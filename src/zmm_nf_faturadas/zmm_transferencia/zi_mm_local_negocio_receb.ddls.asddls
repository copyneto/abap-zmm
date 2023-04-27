@AbapCatalog.sqlViewName: 'ZVMM_LOCNEG_REC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para Local de Negocio Origem'
define view ZI_MM_LOCAL_NEGOCIO_RECEB
  as select from I_BR_NFPartner as NFPartner
    inner join   ztca_param_val as _Param on  modulo = 'MM'
                                          and chave1 = 'FUNCAO_PARCEIRO'
                                          and chave2 = 'DEPOSITO_FECHADO'
                                          and sign   = 'I'
                                          and opt    = 'EQ'
                                          and low    = NFPartner.BR_NFPartnerFunction

  //    join   ZI_CA_PARAM_VAL as _Param on  Modulo = 'MM'
  //                                     and Chave1 = 'FUNCAO_PARCEIRO'
  //                                     and Chave2 = 'DEPOSITO_FECHADO'
  //                                     and Sign   = 'I'
  //                                     and Opt    = 'EQ'
  //                                     and Low    = NFPartner.BR_NFPartnerFunction
{
  key BR_NotaFiscal        as NotaFiscal,
      BR_NFPartner         as NFPartner,
      BR_NFPartnerFunction as NFPartnerFunction
}
