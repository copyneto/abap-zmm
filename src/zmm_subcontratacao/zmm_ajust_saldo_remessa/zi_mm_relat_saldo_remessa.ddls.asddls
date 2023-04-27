@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Saldo de Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_RELAT_SALDO_REMESSA
  as select from    resb

    left outer join ZI_MM_FILTRO_ULT_WB2 as Wb2    on  Wb2.Vgbel = resb.ebeln
                                                   and Wb2.Vgpos = resb.ebelp
                                                   and Wb2.MATNR = resb.matnr

    left outer join ztmm_remes_pednv     as _PedNv on  _PedNv.ebeln     = resb.ebeln
                                                   and _PedNv.matnr     = resb.matnr
                                                   and _PedNv.user_proc = $session.user

  association [0..1] to makt                  as _Makt    on  _Makt.matnr = $projection.Matnr
                                                          and _Makt.spras = $session.system_language

  association [0..1] to lfa1                  as _Lfa1    on  _Lfa1.lifnr = $projection.Lifnr

  association [0..1] to ZI_CA_VH_WERKS        as _Werks   on  _Werks.WerksCode = $projection.Werks

  association [0..1] to ZI_MM_VH_REMES_PEDIDO as _Fltr    on  _Fltr.Ebeln = $projection.Ebeln
                                                          and _Fltr.Matnr = $projection.Matnr

  association [0..1] to ZI_MM_VH_PED_NOVO     as _SHPedNv on  _SHPedNv.matnr = $projection.Matnr

{
  key resb.rsnum      as Rsnum,
  key resb.rspos      as Rspos,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_REMES_PEDIDO', element: 'Matnr' } }]
      @Consumption : { filter  : { selectionType: #SINGLE }}
      resb.matnr      as Matnr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_REMES_PEDIDO', element: 'Ebeln' } }]
      @Consumption : { filter  : { selectionType: #SINGLE }}
      resb.ebeln      as Ebeln,
      resb.ebelp      as Ebelp,
      resb.werks      as Werks,
      resb.lifnr      as Lifnr,
      resb.erfme      as erfme,
      @Semantics.quantity.unitOfMeasure: 'erfme'
      resb.erfmg      as erfmg,
      Wb2.Vbeln       as Vbeln,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      Wb2.Lfimg       as Lfimg,
      Wb2.Meins       as Meins,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_PED_NOVO', element: 'PedNv' } }]
      _PedNv.ebeln_nv as PedNv,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      _PedNv.qtd_nova as QtdNova,
      resb.baugr      as BAUGR,
      @Semantics.quantity.unitOfMeasure: 'Meins'
        unit_conversion( quantity => resb.erfmg,
        source_unit => resb.erfme,
        target_unit => Wb2.Meins,
        error_handling => 'KEEP_UNCONVERTED' ) as erfmgconvert,
      cast(Wb2.Lfimg as abap.dec(13,4)) - cast( resb.erfmg as abap.dec(13,4)) as Saldo,  

      _Makt,
      _Lfa1,
      _Werks,
      _Fltr,
      _SHPedNv

}
where
      resb.ebeln is not initial
  and resb.matnr is not initial
  and resb.bdart = 'BB'
