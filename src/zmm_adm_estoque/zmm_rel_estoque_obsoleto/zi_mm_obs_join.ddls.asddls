@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View obsoletos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_obs_JOIN
  as select from    ZI_MM_ESTQ_OBS       as tipo

    left outer join I_MaterialText       as _MaterialText     on  tipo.Material          = _MaterialText.Material
                                                              and _MaterialText.Language = $session.system_language

    left outer join I_MaterialTypeText   as _MaterialTypeText on  tipo.MaterialType          = _MaterialTypeText.MaterialType
                                                              and _MaterialTypeText.Language = $session.system_language

    left outer join I_GLAccountText      as _GLAccountText    on  tipo.ChartOfAccounts    = _GLAccountText.ChartOfAccounts
                                                              and tipo.GLAccount          = _GLAccountText.GLAccount
                                                              and _GLAccountText.Language = $session.system_language

    left outer join I_CalendarMonthName  as _MesText          on tipo.PeriodoCorrente = _MesText.CalendarMonth

  //    left outer join P_MatStkQtyValCur1   as _QtyValCur        on  tipo.Material = _QtyValCur.Material
  //                                                              and tipo.Plant    = _QtyValCur.Plant
    left outer join Mbv_Mbew             as _Mbew             on  _Mbew.matnr = tipo.Material
                                                              and _Mbew.bwkey = tipo.Plant
                                                              and _Mbew.bwtar = ''

    left outer join likp                 as _Org              on tipo.DeliveryDocument = _Org.vbeln

  //    left outer join ZI_MM_ESTQ_OBS_CC   as _ContaMat         on tipo.KeyDocYear = _ContaMat.Chave
    left outer join ZI_MM_ESTQ_OBS_CONTA as _ContaMat         on  _ContaMat.Material = tipo.Material
                                                              and _ContaMat.Plant    = tipo.Plant

  association [0..1] to ZI_CA_VH_COMPANY as _CompanyCode on _CompanyCode.CompanyCode = $projection.CompanyCode
  association [0..1] to ZI_CA_VH_WERKS   as _Plant       on _Plant.WerksCode = $projection.Plant

{
                    @Consumption.hidden: true
  key               tipo.MaterialDocumentYear,
                    @Consumption.hidden: true
  key               tipo.MaterialDocument,
                    @Consumption.hidden: true
  key               tipo.MaterialDocumentItem,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_Materialvh', element: 'Material' }}]
  key               tipo.Material,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_MM_VH_PlantValueHelp', element: 'Plant' }}]
  key               tipo.Plant,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' }}]
  key               tipo.CompanyCode,
  key               tipo.ChartOfAccounts,
                    //key               tipo.GLAccount,
  key               _ContaMat.GLAccount                as GLAccount,
  key               _MesText.CalendarMonthName         as CalendarMonthName,

                    _CompanyCode.CompanyCodeName       as CompanyCodeName,
                    _Plant.WerksCodeName               as PlantName,
                    _MaterialText.MaterialName         as MaterialName,

                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_StorageLocationVH', element: 'StorageLocation' }}]
                    tipo.StorageLocation,
                    @Consumption.hidden: true
                    tipo.Supplier,
                    @Consumption.hidden: true
                    tipo.WBSElementInternalID1,
                    @Consumption.hidden: true
                    max(tipo.Customer)                 as Customer,
                    max(tipo.GoodsMovementType)        as MovementType,
                    tipo.MaterialBaseUnit,
                    tipo.PostingDate2                  as PostingDate,
                    tipo.CompanyCodeCurrency,
                    @Consumption.valueHelpDefinition: [{entity:{name: 'C_MM_MaterialValueHelp', element: 'MaterialType'} }]
                    tipo.MaterialType,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_MM_MaterialGroupValueHelp', element: 'MaterialGroup' }}]
                    tipo.MaterialGroup                 as GrupoMaterial,
                    _MaterialTypeText.MaterialTypeName as MaterialTypeName,
                    @Consumption.valueHelpDefinition: [{entity: {name: 'C_SalesOrganizationVH', element: 'SalesOrganization' }}]
                    _Org.vkorg                         as OrgVendas,
                    @EndUserText.label: 'Data para Análise'
                    @Consumption.filter.selectionType: #SINGLE
                    tipo.DataAnalise,
                    tipo.AnaliseDias,
                    tipo.Segmento,
                    @EndUserText.label: 'Período Corrente'
                    @ObjectModel.text.element: ['CalendarMonthName']
                    tipo.PeriodoCorrente,

                    tipo.Exercicio,

                    @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
                    @DefaultAggregation : #SUM
                    //                    _QtyValCur.MatlWrhsStkQtyInMatlBaseUnit as MatlWrhsStkQtyInMatlBaseUnit,
                    _Mbew.lbkum                        as MatlWrhsStkQtyInMatlBaseUnit,
                    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
                    @DefaultAggregation : #SUM
                    //                    _QtyValCur.StockValueInCCCrcy           as StockValueInCCCrcy,
                    _Mbew.salk3                        as StockValueInCCCrcy,

                    _ContaMat.GLAccountName            as GLAccountName
}
where
      tipo.Exibir   =  'X'
  and tipo.Material <> ''
group by
  tipo.MaterialDocumentYear,
  tipo.MaterialDocument,
  tipo.MaterialDocumentItem,
  tipo.Material,
  _MaterialText.MaterialName,
  tipo.Plant,
  _Plant.WerksCodeName,
  tipo.CompanyCode,
  _CompanyCode.CompanyCodeName,
  tipo.ChartOfAccounts,
  _ContaMat.GLAccount,
  _MesText.CalendarMonthName,
  tipo.StorageLocation,
  tipo.Supplier,
  tipo.WBSElementInternalID1,
  tipo.MaterialBaseUnit,
  tipo.PostingDate2,
  tipo.CompanyCodeCurrency,
  tipo.MaterialType,
  tipo.MaterialGroup,
  _MaterialTypeText.MaterialTypeName,
  _Org.vkorg,
  tipo.DataAnalise,
  tipo.PeriodoCorrente,
  tipo.Exercicio,
  tipo.AnaliseDias,
  tipo.Segmento,
  //  _QtyValCur.MatlWrhsStkQtyInMatlBaseUnit,
  //  _QtyValCur.StockValueInCCCrcy,
  _Mbew.lbkum,
  _Mbew.salk3,
  _ContaMat.GLAccountName
