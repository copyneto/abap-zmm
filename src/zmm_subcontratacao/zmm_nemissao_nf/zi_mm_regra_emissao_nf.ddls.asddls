@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Regra para não emissão de Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_REGRA_EMISSAO_NF
  as select from ztmm_emissa_nf

  association [0..1] to j_1btregxt as _Regtxtfrom on  _Regtxtfrom.spras = $session.system_language
                                                  and _Regtxtfrom.land1 = 'BR'
                                                  and _Regtxtfrom.txreg = $projection.ShipFrom
  association [0..1] to j_1btregxt as _Regtxtto   on  _Regtxtto.spras = $session.system_language
                                                  and _Regtxtto.land1 = 'BR'
                                                  and _Regtxtto.txreg = $projection.ShipTo

{
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_TXREG', element: 'Txreg' } }]
  key shipfrom              as ShipFrom,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_TXREG', element: 'Txreg' } }]
  key shipto                as ShipTo,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDate.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDate.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDate.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Regtxtfrom,
      _Regtxtto
}
