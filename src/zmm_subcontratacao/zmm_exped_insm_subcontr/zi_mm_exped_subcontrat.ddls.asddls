@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_EXPED_SUBCONTRAT
  as select from    ZI_MM_EXPED_SUBCONTRT_UNION as Subctr


    left outer join j_1bsdica                   as _J_1BSDICA on  _J_1BSDICA.auart  = 'DL'
                                                              and _J_1BSDICA.pstyv  = 'LBN'
                                                              and _J_1BSDICA.itmtyp = '32'

  association [0..1] to makt                        as _Makt    on  _Makt.matnr = $projection.Matnr
                                                                and _Makt.spras = $session.system_language

  association [0..1] to ZI_CA_VH_WERKS              as _Werks   on  _Werks.WerksCode = $projection.Werks

  association [0..1] to ZC_MM_PARAM_PICKING_SUBC    as _Picking on  _Picking.Picking = $projection.Picking

  association [0..1] to ZI_MM_EXPEDISUBC_URL_ESTRN  as _URL     on  _URL.Rsnum = $projection.Rsnum
                                                                and _URL.Rspos = $projection.Rspos
                                                                and _URL.Item = $projection.Item
                                                                and _URL.Vbeln = $projection.Vbeln

//  association [0..*] to ZI_MM_EXPED_SUBCONTRAT_ITEM as _Item    on  _Item.Rsnum = $projection.Rsnum
  //composition [0..*] of ZI_MM_EXPED_SUBCONTRAT_ITEM as _Item



{

  key Subctr.Rsnum,
  key Subctr.Rspos,
  key Subctr.Item,
  key Subctr.Vbeln,
//   Subctr.Vbeln,
      @EndUserText.label: 'Pedido'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_PEDIDO_SUBCONT', element: 'Ebeln' } }]
      Subctr.Ebeln,
      Subctr.Ebelp,
      Subctr.BDTER,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Subctr.Werks,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      Subctr.Lifnr,
      Subctr.DescForn,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_MATNR', element: 'Matnr' } }]
      Subctr.Matnr,
      Subctr.Meins,
      Subctr.Charg,
      Subctr.Picking,
      Subctr.Picking as NewPicking,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_STATUS', element: 'Status' } }]
      Subctr.Status,
      Subctr.StatusCriticality,
      Subctr.Mblnr,
      Subctr.BR_NotaFiscal,
      @EndUserText.label: 'Data da Emissão'
      Subctr.PSTDAT,
      @EndUserText.label: 'NF-e'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_NFE_SUBCONT', element: 'NFENUM' } }]
      Subctr.NFENUM,
      Subctr.Quantidade,
      @EndUserText.label: 'Transportadora'
      Subctr.Transptdr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
      @EndUserText.label: 'Incoterms 1'
      Subctr.Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      Subctr.Incoterms2,
      @EndUserText.label: 'Placa'
      Subctr.TRAID,
      @EndUserText.label: 'Código de imposto SD Padrão'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_TXSDC', element: 'taxcode' } }]
      _J_1BSDICA.txsdc,
      Subctr.Lgort,
      _Makt,
      _Werks,
      _Picking,
      _URL

//      _Item

}
