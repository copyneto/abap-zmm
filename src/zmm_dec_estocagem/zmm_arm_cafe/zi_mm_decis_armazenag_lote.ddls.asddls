@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Decisão de Armazenagem do Café - Lote'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_DECIS_ARMAZENAG_LOTE
  as select from ztmm_romaneio_lo as Lote
  
  association to parent ZI_MM_DECIS_ARMAZENAG_CAFE as _Header on _Header.DocUuidH = $projection.DocUuidH
  
{
  key Lote.doc_uuid_h                     as DocUuidH,
  key Lote.doc_uuid_lot                   as DocUuidLot,
      Lote.charg                          as Charg,
      cast( Lote.qtde  as abap.dec(13,3)) as Qtde,

      @Semantics.systemDateTime.createdAt: true
      Lote.created_at                     as CreatedAt,
      @Semantics.user.createdBy: true
      Lote.created_by                     as CreatedBy,
      @Semantics.user.lastChangedBy: true
      Lote.last_changed_by                as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Lote.last_changed_at                as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Lote.local_last_changed_at          as LocalLastChangedAt,

      _Header
}
