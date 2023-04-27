@AbapCatalog.sqlViewName: 'ZVMM_ACCESSKEY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para AccessKey'
define view ZI_MM_ACCESSKEY
  as select from    I_BR_NFElectronic_C as NFElectronic
    left outer join j_1bnfdoc           as _NFHeader on docnum = BR_NotaFiscal

  //  association [0..1] to I_BR_NFBrief_C as _NFBrief on $projection.BR_NotaFiscal = _NFBrief.BR_NotaFiscal


{
  key NFElectronic.BR_NotaFiscal   as BR_NotaFiscal,
      NFElectronic.BR_NFeAccessKey as BR_NFeAccessKey,
      _NFHeader.direct             as BR_NFDirection
      //      _NFBrief.BR_NFDirection      as BR_NFDirection,

      //      _NFBrief


}
