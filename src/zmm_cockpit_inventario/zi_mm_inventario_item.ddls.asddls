@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Inventário - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INVENTARIO_ITEM
  as select from ztmm_inventory_i
  association [0..1] to marc                           as _Marc         on  _Marc.matnr = $projection.Material
                                                                        and _Marc.werks = $projection.Plant
  association [0..1] to I_MaterialText                 as _Material     on  _Material.Material = $projection.Material
                                                                        and _Material.Language = $session.system_language
  association [0..1] to I_Plant                        as _Plant        on  _Plant.Plant = $projection.Plant
  association [0..1] to mara                           as _Mara         on  _Mara.matnr = $projection.Material
  association [0..1] to I_StorageLocation              as _Storage      on  _Storage.Plant           = $projection.Plant
                                                                        and _Storage.StorageLocation = $projection.Storagelocation
  association [0..1] to ZI_MM_VH_INVENTARIO_STATUS_ITM as _Status       on  _Status.Status = $projection.Status

  association [0..1] to ZI_MM_INVENTARIO_ESTOQUE_TOTAL as _EstoqueAtual on  _EstoqueAtual.Material        = $projection.Material
                                                                        and _EstoqueAtual.Plant           = $projection.Plant
                                                                        and _EstoqueAtual.StorageLocation = $projection.Storagelocation
                                                                        and _EstoqueAtual.Batch           = $projection.Batch
  association [1..1] to ZI_MM_INVENTARIO_FLIN          as _Seg          on  _Seg.iblnr = $projection.PhysicalInventoryDocument
                                                                        and _Seg.gjahr = $projection.FiscalYear
                                                                        and _Seg.matnr = $projection.Material
  association [1..1] to ZI_MM_PHYSINVTRYDOCHEADER      as _Inv          on  _Inv.PhysicalInventoryDocument = $projection.PhysicalInventoryDocument
                                                                        and _Inv.FiscalYear                = $projection.FiscalYear
  association        to parent ZI_MM_INVENTARIO_H      as _H            on  $projection.Documentid = _H.Documentid

{

  key documentid                                                           as Documentid,
  key documentitemid                                                       as Documentitemid,
      @Consumption.valueHelpDefinition: [{
                 entity: {
                     name: 'C_Materialvh',
                     element: 'Material'
                 }
             }]
      material                                                             as Material,
      _Material.MaterialName                                               as MaterialText,
      plant                                                                as Plant,
      _Plant.PlantName                                                     as PlantText,
      storagelocation                                                      as Storagelocation,
      _Storage.StorageLocationName                                         as StorageLocationText,
      batch                                                                as Batch,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      quantitystock                                                        as Quantitystock,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      quantitycount                                                        as Quantitycount,
      //      @Semantics.quantity.unitOfMeasure : 'Unit'
      //      quantitycurrent              as Quantitycurrent,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      _EstoqueAtual.EstoqueAtual                                           as MaterialBaseQuantityCurrent,
      _EstoqueAtual.MaterialBaseUnit                                       as MaterialBaseUnit,
      //      @Semantics.quantity.unitOfMeasure : 'Unit'
      //      //      unit_conversion(
      //      //        quantity    => _EstoqueAtual.EstoqueAtual,
      //      //        source_unit => _EstoqueAtual.MaterialBaseUnit,
      //      //        target_unit => unit
      //      //      )                                                                    as Quantitycurrent,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      _EstoqueAtual.EstoqueAtual                                           as Quantitycurrent,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      balance                                                              as Balance,
      //      @Semantics.quantity.unitOfMeasure : 'Unit'
      //      //      balancecurrent                 as Balancecurrent,
      @Semantics.quantity.unitOfMeasure : 'Unit'
      cast( ( cast(_EstoqueAtual.EstoqueAtual as abap.dec(13,3) ) -
              cast(quantitycount as abap.dec(13,3) ) ) as abap.quan(13,3)) as Balancecurrent,
      unit                                                                 as Unit,
      @Semantics.amount.currencyCode : 'Currency'
      pricestock                                                           as Pricestock,
      @Semantics.amount.currencyCode : 'Currency'
      pricecount                                                           as Pricecount,
      @Semantics.amount.currencyCode : 'Currency'
      pricediff                                                            as Pricediff,
      cast( 'BRL' as currency )                                            as Currency,
      @Semantics.quantity.unitOfMeasure : 'Weightunit'
      weight                                                               as Weight,
      weightunit                                                           as Weightunit,
      _Mara.prdha                                                          as ProductHierarchy,

      case when accuracy < 0
           then 0
           when accuracy > 100
           then 100
           else accuracy
           end                                                             as Accuracy,

      physinventory                                                        as PhysicalInventoryDocument,

      _Marc.prctr                                                          as Prct,
      fiscalyear                                                           as FiscalYear,

      status                                                               as Status,
      _Status.StatusText                                                   as StatusText,

      case status
        when '  ' then 2    -- 'Pendente'
        when '01' then 3    -- 'Liberado'
        when '02' then 2    -- 'Pendente Contagem'
        when '03' then 3    -- 'Concluido'
        when '04' then 1    -- 'Cancelado'
                  else 0
      end                                                                  as StatusCriticality,
      _Seg.mblnr                                                           as DocMaterial,
      _Seg.budat                                                           as DataLanc,
      lpad(_Seg.docnum,10,'0')                                               as DocEntSai,
      _Seg.belnr                                                           as DocComp,
      _Seg.GJAHR_BKPF                                                      as DataComp,
      _Seg.awref_rev                                                       as DocContEst,
      _Seg.bldat                                                           as DatDocCont,
      _Seg.nfenum                                                          as NumNF,
      _Seg.cancel                                                          as EstornoNfe,
      _Seg.docstat                                                         as DocStat,
      _Inv.Bukrs                                                           as Empresa,

      @Semantics.user.createdBy: true
      created_by                                                           as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                                           as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                                      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                                      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                                as LocalLastChangedAt,

      _H, // Make association public
      _EstoqueAtual,
      _Inv

}
