@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Controle de Transf. EKBE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TRANSF_EKBE
  as select from    ekbe                   as _Ekbe 
     inner join likp as _likp on  _likp.vbeln = _Ekbe.xblnr

{
  key _Ekbe.ebeln as Ebeln,
  key _Ekbe.ebelp as Ebelp,
  key _Ekbe.zekkn as Zekkn,
  key _Ekbe.vgabe as Vgabe,
  key _Ekbe.gjahr as Gjahr,
  key _Ekbe.belnr as Belnr,
  key _Ekbe.buzei as Buzei,
  key _likp.vbeln as Vbeln,
  _Ekbe.bwart as Bwart,
  _Ekbe.xblnr as Xblnr
  
  }
