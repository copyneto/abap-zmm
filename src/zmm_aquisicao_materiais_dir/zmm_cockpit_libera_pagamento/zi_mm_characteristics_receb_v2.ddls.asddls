@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados Recebimento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARACTERISTICS_RECEB_V2 
  as select from ztmm_romaneio_in      as Romaneio
    inner join   C_PurchaseOrderItemTP as _Purch     on  _Purch.PurchaseOrder     = Romaneio.ebeln
                                                     and _Purch.PurchaseOrderItem = Romaneio.ebelp
                                                     
    inner join   ZC_MM_BR_NF_DOCUMENT  as _NFDoc     on  _NFDoc.PurchaseOrder     = Romaneio.ebeln
                                                     and _NFDoc.PurchaseOrderItem = Romaneio.ebelp
                                                     and _NFDoc.BR_NFeNumber      = Romaneio.nfnum

    //inner join   ZI_MM_CHARAC_GET      as _CharReceb on  _CharReceb.Pedido   = Romaneio.ebeln
                                                     //and _CharReceb.Material = _Purch.Material
    inner join   ztmm_romaneio_lo          as _Lote      on Romaneio.doc_uuid_h = _Lote.doc_uuid_h 
    
    inner join   ZI_MM_CHARAC_GET_NEW      as _CharReceb on  _CharReceb.Batch   = _Lote.charg
                                                         and _CharReceb.Material = _Purch.Material
                                                         
  association to parent ZI_MM_COCKPIT as _Cockpit on  _Cockpit.PurchaseOrder     = $projection.PurchaseOrder
                                                  and _Cockpit.PurchaseOrderItem = $projection.PurchaseOrderItem
                                                  and _Cockpit.BR_NotaFiscal     = $projection.BR_NotaFiscal                                                                                                              
{
  key Romaneio.ebeln                               as PurchaseOrder,
  key Romaneio.ebelp                               as PurchaseOrderItem,
  key _NFDoc.BR_NotaFiscal,
  key _CharReceb.Batch                             as Charg,
  key _CharReceb.Material,

      cast('' as vbeln)                            as SalesDocument,
      cast('' as posnr)                            as SalesDocumentItem,      
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast( 0 as abap.fltp)                        as QuantidadeKg,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as QuantidadeKgCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as QuantidadeSacas,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as QuantidadeSacasCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as QuantidadeBag,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as QuantidadeBagCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira10,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira10Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast( 0 as abap.fltp)                        as Peneira11,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira11Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast( 0 as abap.fltp)                        as Peneira12,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira12Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira13,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira13Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira14,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira14Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira15,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira15Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira16,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira16Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira17,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira17Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira18,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira18Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Peneira19,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Peneira19Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Mk10,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as Mk10Criticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Fundo,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as FundoCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Catacao,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as CatacaoCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Umidade,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as UmidadeCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast( 0 as abap.fltp)                        as Defeito,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as DefeitoCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Impureza,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as ImpurezaCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Verde,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as VerdeCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast( 0 as abap.fltp)                        as PretoArdido,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as PretoArdidoCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      cast( 0 as abap.fltp)                        as Brocado,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as BrocadoCriticality,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'
      cast(0 as abap.fltp)                         as Densidade,
      //@ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REC_CHARACTERISTICS'      
      0                                            as DensidadeCriticality,
      
      _Cockpit       
}
