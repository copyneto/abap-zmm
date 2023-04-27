@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Decisão de Armazenagem do café'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_01_CAFE
  as select from    ztmm_romaneio_in      as a
    inner join      ZI_MM_03_NFNUM        as y on a.nfnum = y.nfnum
    inner join      I_BR_NFItem_C         as c on  c.PurchaseOrder     = a.ebeln
                                               and c.PurchaseOrderItem = a.ebelp
    inner join      C_BR_VerifyNotaFiscal as b on b.BR_NotaFiscal = c.BR_NotaFiscal
    inner join      mara                  as d on d.matnr = c.Material
    inner join      nsdm_e_mchb           as e on  e.matnr = c.Material
                                               and e.werks = c.Plant
//                                               and e.charg = c.Batch
    left outer join mch1                  as f on  f.matnr = c.Material
//                                               and f.charg = a.charg
{
  key         a.sequence,
  key         a.ebeln,
  key         a.ebelp,
  key         a.nfnum,
  key         b.CompanyCode,
  key         c.Material,
  key         c.Plant,
  key         b.BR_NotaFiscal,
  key         c.BR_NotaFiscalItem,
              a.status_armazenado,
              a.dt_entrada,
              a.vbeln,
//              a.charg                                      as CHARG,
              cast( a.peso_dif_ori as abap.dec( 13, 3 ) )  as peso_dif_ori,
              cast( a.qtde_dif_ori as abap.dec( 13, 3 ) )  as qtde_dif_ori,
              cast( a.calc_dif_peso as abap.dec( 13, 3 ) ) as calc_dif_pesoas,
              cast( a.calc_dif_qtde as abap.dec( 13, 3 ) ) as calc_dif_qtdeas,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONV_MATERIAL'
              cast( 0 as abap.dec( 13, 3 ) )               as menge,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_SUM_VALUE'
              cast( 0 as abap.dec( 13, 3 ) )               as QTD_TOTAL_KG,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONV_MATERIAL'
              cast( 0 as abap.dec( 13, 3 ) )               as PESO_DIF_NF,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CONV_MATERIAL'
              cast( 0 as abap.int2 )                       as StatusCriticality,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_SUM_VALUE'
              cast( 0 as abap.dec( 13, 3 ) )               as QTD_DIF_NF,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_SUM_VALUE'
              cast( 0 as abap.int2 )                       as StatusCriticality2,
              @ObjectModel.virtualElement: true
              @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_SUM_VALUE'
              cast( 0 as abap.char( 12 ) )                 as BATCH_NUMBER,
              b.BR_NFIssuerNameFrmtdDesc,
              b.BR_NFPostingDate,
              b.BR_NFTotalAmount,
              @Semantics.quantity.unitOfMeasure: 'BaseUnit'
              c.QuantityInBaseUnit,
              c.BaseUnit,
              cast( 0 as abap.dec( 13, 3 ) )               as QTD_TOTAL_SACAS,
              c.Batch,
              c.BR_NFItemTitle,
              @Semantics.quantity.unitOfMeasure : 'meins'
              e.ceinm,
              e.lgort,
              d.meins,
              @Semantics.user.createdBy: true
              a.created_by                                 as CreatedBy,
              @Semantics.systemDateTime.createdAt: true
              a.created_at                                 as CreatedAt,
              @Semantics.user.lastChangedBy: true
              a.last_changed_by                            as LastChangedBy,
              @Semantics.systemDateTime.lastChangedAt: true
              a.last_changed_at                            as LastChangedAt,
              @Semantics.systemDateTime.localInstanceLastChangedAt: true
              a.local_last_changed_at                      as LocalLastChangedAt
}
where
      a.status_ordem      = '1'
  and a.status_armazenado = 'N'
