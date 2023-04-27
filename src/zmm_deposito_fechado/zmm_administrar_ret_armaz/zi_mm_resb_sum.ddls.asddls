@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Soma do LBAST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESB_SUM
  as select from resb as _Base
    inner join   mard as _Mard on  _Mard.matnr = _Base.matnr
                               and _Mard.werks = _Base.werks
                               and _Mard.lgort = _Base.lgort
{
  key _Base.matnr        as Matnr,
      _Base.werks        as CentroDestino,
      _Base.lgort        as DepositoDestino,
      _Base.meins        as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      sum( _Mard.labst ) as SunLbast

 }
 where
  _Base.xwaok != 'X'
group by
  _Base.matnr,
  _Base.werks,
  _Base.meins,
  _Base.lgort
