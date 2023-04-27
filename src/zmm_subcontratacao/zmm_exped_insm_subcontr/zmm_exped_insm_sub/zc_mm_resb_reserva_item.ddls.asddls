@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Exped. Insumos - Subcontratação - Item'
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}@Metadata.allowExtensions: true

define view entity zc_mm_resb_reserva_item
  as projection on zi_mm_resb_reserva_item
  association [0..1] to ZI_CA_VH_LIFNR      as _VHLifnr on _VHLifnr.LifnrCode = $projection.Transptdr
  association [0..1] to ZI_CA_VH_INCO1_VIEW as _VHInco1 on _VHInco1.inco1 = $projection.Incoterms1
  //association [0..1] to ZI_MM_VH_TXSDC      as _VHTxsdc on _VHTxsdc.taxcode = $projection.txsdc
  association [0..1] to ZI_MM_VH_ARMZ_TXSDC  as _VHTxsdc on _VHTxsdc.taxcode = $projection.TXSDC

{
  key Rsnum,
  key Rspos,
  key Item,
      Charg,
      Matnr,
      Werks,
      Lgort,
      Quantidade,
      QtdePicking,
      Meins,
      Bwtar,
      Status,
      StatusCriticality,
      @EndUserText.label: 'Transportadora'
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
      Transptdr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
      @EndUserText.label: 'Incoterms 1'
      Incoterms1,
      @EndUserText.label: 'Incoterms 2'
      Incoterms2,
      @EndUserText.label: 'Placa'
      TRAID,
     // @EndUserText.label: 'Código de imposto SD Padrão'
       @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_TXSDC', element: 'taxcode' } }]
     
     // @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_TXSDC', element: 'taxcode' } }]
      TXSDC,
      Ebeln,
      Ebelp,
      /* Associations */
      _VHLifnr,
      _VHInco1,
      _VHTxsdc,
      _Header : redirected to parent zc_mm_rkpf_reserva

}
