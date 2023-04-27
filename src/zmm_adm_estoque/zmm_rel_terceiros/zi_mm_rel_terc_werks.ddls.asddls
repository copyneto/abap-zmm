@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS valida centro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_WERKS
  as select from I_BR_NFItem     as _it
    inner join   t001w           as _tw on _tw.werks = _it.Plant
    inner join   I_BR_NFDocument as _dc on _dc.BR_NotaFiscal = _it.BR_NotaFiscal
{
  key _it.BR_NotaFiscal          as BR_NotaFiscal,
      _tw.regio                  as RegioTW,
      _dc.BR_NFPartnerRegionCode as RegioDC,

      case
      when _tw.regio = _dc.BR_NFPartnerRegionCode then 'DENTRO'
      else 'FORA'
      end                        as Regio
}
where
  _it.Plant is not initial
  
group by    
  _it.BR_NotaFiscal, _tw.regio, _dc.BR_NFPartnerRegionCode
