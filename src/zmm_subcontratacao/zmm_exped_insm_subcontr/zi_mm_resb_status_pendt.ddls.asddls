@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro por RESB Pendentes para Insumos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RESB_STATUS_PENDT
  as select from    resb

    inner join      lfa1                           on lfa1.lifnr = resb.lifnr

    left outer join ZI_MM_SUM_LIPS_SUBCTRT as Lips on  Lips.vgbel = resb.ebeln
                                                   and Lips.vgpos = resb.ebelp
                                                   and Lips.Matnr = resb.matnr

    left outer join ztmm_sbct_pickin       as Picking    on  Picking.rsnum = resb.rsnum
                                                         and Picking.rspos = resb.rspos
                                                         and Picking.vbeln is initial

{
  key resb.rsnum                                     as Rsnum,
  key resb.rspos                                     as Rspos,
  key ''                                             as Vbeln,
      @EndUserText.label: 'Pedido'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_PEDIDO_SUBCONT', element: 'Ebeln' } }]
      resb.ebeln                                     as Ebeln,
      resb.ebelp                                     as Ebelp,
      resb.bdter                                     as BDTER,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      resb.werks                                     as Werks,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      resb.lifnr                                     as Lifnr,
      lfa1.name1                                     as DescForn,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_MATNR', element: 'Matnr' } }]
      resb.matnr                                     as Matnr,
      resb.meins                                     as Meins,
      resb.charg                                     as Charg,
      cast(Picking.picking as abap.dec( 13, 3 ))     as Picking,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_EXPEDIN_STATUS', element: 'Status' } }]
      'Pendente'                                     as Status,
      2                                              as StatusCriticality,
      ''                                             as Mblnr,
      cast('' as abap.numc( 10 ))                    as BR_NotaFiscal,
      @EndUserText.label: 'Data da Emissão'
      '00000000'                                     as PSTDAT,
      @EndUserText.label: 'NF-e'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_NFE_SUBCONT', element: 'NFENUM' } }]
      ''                                             as NFENUM,
      case
      when Lips.LFIMG is not null
           then cast(resb.bdmng as abap.dec( 13, 3 )) - cast(Lips.LFIMG as abap.dec( 13, 3 ))
      else cast(resb.bdmng as abap.dec( 13, 3 )) end as Quantidade,

      @EndUserText.label: 'Transportadora'
      ''                                             as Transptdr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
      @EndUserText.label: 'Incoterms 1'
      ''                                             as Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      ''                                             as Incoterms2,
      @EndUserText.label: 'Placa'
      ''                                             as TRAID

}
where
      resb.bdart = 'BB'
  and resb.ebeln is not initial
//  and Lips.Vbeln is not initial
