@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Visão de Vendas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity ZI_MM_VISAO_VENDAS
  as select from    mara
    left outer join makt             as makt   on  makt.matnr = mara.matnr
                                               and makt.spras = $session.system_language
    left outer join makt             as maktpt on  maktpt.matnr = mara.matnr
                                               and maktpt.spras = 'P'
    left outer join makt             as makten on  makten.matnr = mara.matnr
                                               and makten.spras = 'E'
    left outer join makt             as maktes on  maktes.matnr = mara.matnr
                                               and maktes.spras = 'S'
    left outer join marc                       on marc.matnr = mara.matnr
    left outer join mvke                       on mvke.matnr = mara.matnr
    left outer join ztmm_catalogorfb as rfb    on rfb.material = mara.matnr
{
  key mara.matnr,
  key marc.werks,
  key mvke.vkorg,
  key mvke.vtweg,
  key rfb.idrfb,
      mara.mtart,
      @EndUserText.label: 'Descrição PT'
      maktpt.maktx as maktxpt,
      @EndUserText.label: 'Descrição EN'
      makten.maktx as maktxen,
      @EndUserText.label: 'Descrição ES'
      maktes.maktx as maktxes,
      makt.maktg,
      mara.ersda,
      mara.ernam,
      mara.matkl,
      mara.spart,
      mara.prdha,
      mara.mstav,
      marc.mmsta,
      mvke.vrkme,
      mvke.prodh,

      mvke.ktgrm,
      mvke.pmatn,
      mvke.versg,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.lfmng,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.aumng,
      mvke.prat1,
      mvke.dwerk,
      mvke./bev1/emdrckspl,
      mvke.sktof,
      mvke.bonus,
      mvke.provg,
      mvke.mtpos,
      mvke.kondm,
      mvke.pvmso,
      @EndUserText.label: 'Peneira'
      mvke.mvgr1,
      @Semantics.quantity.unitOfMeasure: 'meins'
      mvke.lfmax,
      mara.meins,
      @EndUserText.label: 'Familia Grão Verde'
      mvke.mvgr2,
      @EndUserText.label: 'Grupo de materiais 3'
      mvke.mvgr3,
      @EndUserText.label: 'Grupo mercadorias 4'
      mvke.mvgr4,
      @EndUserText.label: 'Sirius-ZBR'
      mvke.mvgr5,
      mara.bismt
}
