@EndUserText.label: 'Projeção Dados Mestre de Materiais'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_MESTRE_MATERIAIS_LOG'

@UI: {
  headerInfo: {
  typeName: 'LogMaterial',
  typeNamePlural: 'Log Materiais'
  }
}
define root custom entity zc_mm_mestre_material_log
{

      @Consumption.semanticObject: 'Material'
      @UI         : { selectionField: [{ position: 10 }],
      lineItem    : [{ position: 30,
      importance  : #HIGH,
      type        : #WITH_INTENT_BASED_NAVIGATION,
      semanticObjectAction: 'display' }]}
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' } }]
  key Product     : matnr;
      @UI         : { lineItem:       [{position: 70}],
                    selectionField: [{position: 70}] }
      @Consumption.filter.selectionType: #SINGLE
  key lgort       : lgort_d;
      @UI         : { lineItem:       [{position: 60}],
                    selectionField: [{position: 60}] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO', element: 'Plant' } }]
  key werks       : werks_d;
      @UI         : { lineItem:       [{position: 110}],
                    selectionField: [{position: 110}] }
      @Consumption.filter.selectionType: #SINGLE
  key bwtar       : bwtar_d;
      @UI         : { lineItem:       [{position: 80}],
                    selectionField: [{position: 80}] }
      @Consumption.filter.selectionType: #SINGLE
  key vkorg       : vkorg;

      @UI         : { lineItem:       [{position: 90}],
                    selectionField: [{position: 90}] }
      @Consumption.filter.selectionType: #SINGLE
  key vtweg       : vtweg;
      @UI         : { lineItem:       [{position: 150}] }
      @ObjectModel.text.element: ['ChngindTxt']
  key chngind     : cdchngind;
      @UI         : { selectionField: [{position: 20}] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_VISAO', element: 'VisionId' } }]
      @Consumption.filter.mandatory: true
  key vpsta       : vpsta;
      @UI         : { lineItem:       [{position: 50}],
                    selectionField: [{position: 30}] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_TIPO_MATERIAL', element: 'ProductType' } }]
  key mtart       : mtart;
      @UI         : { lineItem:       [{position: 100}],
                    selectionField: [{position: 100}] }
      @Consumption: { valueHelpDefinition: [{ entity: { name: 'I_Division', element: 'Division'} }] }
  key spart       : spart;
      @EndUserText.label: 'Campo Técnico'
  key fname       : fieldname;
      @UI         : { lineItem:       [{position: 10, label: 'Data Modificação'}],
                    selectionField: [{position: 40}] }
      @Consumption.filter.selectionType: #INTERVAL
      @Consumption.filter.mandatory: true
  key udate       : cddatum;
      @UI         : { lineItem:       [{position: 20}] }
  key utime       : cduzeit;
      @UI         : { lineItem:       [{position: 130}] }
      @EndUserText.label: 'Campo'
  key ddtext      : ddtext;
      @UI         : { lineItem:       [{position: 170}] }
  key value_new   : value_new;
      @UI         : { lineItem:       [{position: 120}],
                    selectionField: [{position: 50}] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ChangeDocUser', element: 'UserName' } }]
      username    : cdusername;
      @UI         : { lineItem:       [{position: 40}] }
      @EndUserText.label: 'Descrição'
      maktx       : maktx;
      //      @UI         : { lineItem:       [{position: 140}] }
      //      @Consumption: { valueHelpDefinition: [{ entity: { name: 'I_ProdValnPriceControl', element: 'InventoryValuationProcedure'} }] }
      //      @ObjectModel.text.element: ['Description']
      //      //      @UI.textArrangement: #TEXT_ONLY
      //      vprsv       : vprsv;
      @UI.hidden  : true
      Description : val_text;
      @UI         : { lineItem:       [{position: 160}] }
      value_old   : value_old;
      @EndUserText.label: 'DescrIndicModif'
      ChngindTxt  : val_text;
}
