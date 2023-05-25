@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit de Inventário - Cabeçalho'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_INVENTARIO_H
  as select from ztmm_inventory_h
  association [0..1] to ZI_MM_INVENTARIO_H_TOTAL   as _Total  on _Total.Documentid = $projection.Documentid
  composition [0..*] of ZI_MM_INVENTARIO_ITEM      as _Itens
  association [0..1] to ZI_MM_INVENTARIO_H_INV     as _Inv    on _Inv.Documentid = $projection.Documentid
  association [0..1] to ZI_MM_INVENTARIO_ITEM_H    as _ItemH  on _ItemH.Documentid = $projection.Documentid
  association [0..1] to I_Plant                    as _Plant  on _Plant.Plant = $projection.Plant
  association [0..1] to ZI_MM_VH_INVENTARIO_STATUS as _Status on _Status.Status = $projection.Status


{
  key documentid            as Documentid,
      documentno            as Documentno,
      countid               as Countid,
      datesel               as Datesel,
      plant                 as Plant,
      _Plant.PlantName      as PlantText,
      status                as Status,
      _Status.StatusText    as StatusText,

      _ItemH.mblnr          as DocMaterial,
      _ItemH.budat          as DataLanc,
      _ItemH.docnum         as DocEntSai,
      _ItemH.belnr          as DocComp,
      _ItemH.GJAHR_BKPF     as DataComp,
      _ItemH.awref_rev      as DocContEst,
      _ItemH.bldat          as DatDocCont,
      _ItemH.nfenum         as NumNF,
      _ItemH.cancel         as EstornoNfe,
      _ItemH.docstat        as DocStat,
      _ItemH.Bukrs          as Empresa,
      _Inv.Physinventory    as PhysicalInventoryDocument,
      _ItemH.FiscalYear,
      _ItemH.ExternalRef,


      case status
        when '  ' then 0    -- 'Criado'
        when '00' then 2    -- 'Processamento Incompleto'
        when '01' then 3    -- 'Liberado'
        when '02' then 1    -- 'Cancelado'
        when '03' then 3    -- 'Concluido'
                  else 0
      end                   as StatusCriticality,

      description           as Description,

      case when _Total.Accuracy < 0
           then 0
           when _Total.Accuracy > 100
           then 100
           else _Total.Accuracy
           end              as Accuracy,



      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _Itens,
      _Total,
      _ItemH,
      _Inv

}
