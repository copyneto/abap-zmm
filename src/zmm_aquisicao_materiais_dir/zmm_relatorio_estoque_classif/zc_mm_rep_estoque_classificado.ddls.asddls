@EndUserText.label: 'Relatório Estoque Classificado'
@UI.headerInfo: { typeName: 'Estoque Classificado',
                  typeNamePlural: 'Estoque Classificado' }

@ObjectModel: { query.implementedBy: 'ABAP:ZCLMM_ESTOQUE_CLASSIFICADO'}
//@UI.lineItem: [{criticality: 'StatusCrit'}]

define custom entity ZC_MM_REP_ESTOQUE_CLASSIFICADO
{
      @UI                 : { lineItem: [{ position: 10 }],
      selectionField      : [{ position: 10 }] }
      //      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { element: 'Material', name: 'I_MaterialVH' } }]
      @Consumption.filter.defaultValue: ' '
  key Material            : matnr;

      @UI                 : { lineItem: [{ position: 40 }],
      selectionField      : [{ position: 20 }]  }
      //      @ObjectModel.text.element: ['PlantName']
      @Consumption.valueHelpDefinition: [{ entity: { element: 'Plant', name: 'I_Plant' } }]
  key Plant               : werks_d;

      @UI                 : { lineItem: [{ position: 50 }],
      selectionField      : [{ position: 30 }]  }
      //      @ObjectModel.text.element: ['StorageLocationName']
      @Consumption.valueHelpDefinition: [{ entity: { element: 'StorageLocation', name: 'I_StorageLocation' } }]
  key StorageLocation     : lgort_d;

      @UI                 : { lineItem: [{ position: 70 }],
      selectionField      : [{ position: 40 }]  }
      @Consumption.valueHelpDefinition: [{ entity: { element: 'Batch', name: 'I_Batch' } }]
  key Batch               : charg_d;
      //      @UI                 : { lineItem    : [{ position: 60 }] }
      //      @UI                 : { lineItem: [{ position: 60 }],
      //      selectionField      : [{ position: 50 }]  }
      //      @Consumption.valueHelpDefinition: [{ entity: { element: 'ManufacturingOrder', name: 'I_MfgOrderStdVH' } }]
      //  key Ordem               : aufnr;
      @UI                 : { lineItem: [ { position: 1, type: #WITH_URL, url: 'URL_Guia' } ],
      selectionField      : [{ position: 60 }] }
      @EndUserText.label  : 'Guia'
  key Documentno          : ze_nr_nrm_aprop;

//      @UI                 : { lineItem    : [{ position: 11 }] }
//      MaterialText        : maktx;
      @UI                 : { lineItem    : [{ position: 12 }] }
      MaterialText1        : maktx;

//      @UI                 : { lineItem    : [{ position: 41 }] }
//      @EndUserText.label  : 'Descrição do Centro'
//      PlantName           : name1;
      @UI                 : { lineItem    : [{ position: 42 }] }
      @EndUserText.label  : 'Descrição do Centro'
      PlantName1           : name1;

//      @UI                 : { lineItem    : [{ position: 51 }] }
//      @EndUserText.label  : 'Descrição do Depósito'
//      StorageLocationName : lgobe;
      @UI                 : { lineItem    : [{ position: 52 }] }
      @EndUserText.label  : 'Descrição do Depósito'
      StorageLocationName1 : lgobe;

      //      @UI                 : { lineItem    : [{ position: 60 }] }
      //      //@UI                 : { lineItem: [{ position: 60 }],
      //      //selectionField      : [{ position: 50 }]  }
      //      //@Consumption.valueHelpDefinition: [{ entity: { element: 'ManufacturingOrder', name: 'I_MfgOrderStdVH' } }]
      @UI.hidden          : true
      Ordem               : aufnr;

      /*@UI                 : { selectionField: [{ position: 60 }] }
      @Consumption.valueHelpDefinition: [{ entity: { element: 'StatusId', name: 'ZI_MM_NRM_APR_STATUS' } }]
      @ObjectModel.text.element: ['StatusTxt']
      Status              : ze_status_nrm_apr;
      StatusTxt           : val_text;
      StatusCrit          : abap.char(1);*/

      @UI                 : { selectionField: [{ position: 70 }] }
      @Consumption.valueHelpDefinition: [{ entity: { element: 'Id', name: 'ZI_MM_VH_OPCOES' } }]
      @Consumption.filter.defaultValue: 'O'
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label  : 'Opções'
      Options             : abap.char(1);

      //      @UI                 : { lineItem: [ { position: 1, semanticObjectAction: 'create', type: #WITH_INTENT_BASED_NAVIGATION } ],
      //            @UI                 : { lineItem: [ { position: 1, type: #WITH_URL, url: 'URL_Guia' } ],
      //            selectionField      : [{ position: 60 }] }
      //            @EndUserText.label  : 'Guia'
      //      //      //      @Consumption.semanticObject: 'apropriacaograos'
      //            Documentno          : ze_nr_nrm_aprop;

      /*@UI                 : { selectionField: [{ position: 80 }] }
      @Consumption.valueHelpDefinition: [{ entity: { element: 'LglCntntMIsChecked', name: 'C_LCMBooleanValueHelp' } }]
      @Consumption.filter.selectionType: #SINGLE
      @EndUserText.label  : 'Lotes com Estoque'
      BatchManagement     : xfeld;*/

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI.hidden          : true //--
      TotalOrdem          : bstmg;

      @UI                 : { lineItem: [{ position: 20 }] }
      //      @ObjectModel.text.element: ['MaterialGroupText']
      MaterialGroup       : matkl;
//      @UI                 : { lineItem: [{ position: 21 }] }
//      @EndUserText.label  : 'Grupo de Mercadoria'
//      MaterialGroupText   : wgbez60;
      
      @UI                 : { lineItem: [{ position: 22 }] }
      @EndUserText.label  : 'Texto Grupo de Mercadoria'
      @EndUserText.quickInfo: 'Texto Grupo de Mercadoria'
      MaterialGroupText1   : wgbez60;
      
      @UI                 : { lineItem: [{ position: 80 }] }
      @EndUserText.label  : 'Localização 1'
      Localizacao         : abap.sstring(20);

      @UI                 : { lineItem: [{ position: 82 }] }
      @EndUserText.label  : 'Localização 2'
      Localizacao2        : abap.sstring(20);

      @UI                 : { lineItem: [{ position: 84 }] }
      @EndUserText.label  : 'Localização 3'
      Localizacao3        : abap.sstring(20);

      @UI                 : { lineItem: [{ position: 86 }] }
      @EndUserText.label  : 'Localização 4'
      Localizacao4        : abap.sstring(20);

      @UI                 : { selectionField: [{ position: 90 }] }
      @Consumption.valueHelpDefinition: [{ entity: { element: 'UnitOfMeasure', name: 'ZI_MM_VH_UNITOFMEASURE' } }]
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.filter.defaultValue: 'SAC'
      @Consumption.filter.mandatory: true
      @Semantics.unitOfMeasure: true
      MaterialBaseUnit    : meins;

      //@Aggregation.default: #SUM
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Quantidade', position: 90 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'BAG', position: 1 }]
      Quantidade          : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'BAG', position: 2 }]
      //@Aggregation.default: #SUM
      @UI.hidden: true
      QtdBag              : dec9_2;

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Peneira 19', position: 100 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '19', position: 1 }]
      @EndUserText.label  : 'Peneira 19'
      @EndUserText.quickInfo: 'Peneira 19'
      QtdPeneira19        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '19', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 19', position: 101 }] }
      @EndUserText.label  : '% Peneira 19'
      @EndUserText.quickInfo: '% Peneira 19'
      Peneira19           : wsd_margin_percentage;

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Peneira 18', position: 110 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '18', position: 1 }]
      QtdPeneira18        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '18', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 18', position: 111 }] }
      @EndUserText.label  : '% Peneira 18'
      @EndUserText.quickInfo  : '% Peneira 18'
      Peneira18           : wsd_margin_percentage;

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Peneira 17', position: 120 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '17', position: 1 }]
      QtdPeneira17        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '17', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 17', position: 121 }] }
      @EndUserText.label  : '% Peneira 17'
      @EndUserText.quickInfo  : '% Peneira 17'
      Peneira17           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '16', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Peneira 16', position: 130 }] }
      QtdPeneira16        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '16', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 16', position: 131 }] }
      @EndUserText.label  : '% Peneira 16'
      @EndUserText.quickInfo  : '% Peneira 16'
      Peneira16           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Peneira 15', position: 140 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '15', position: 1 }]
      QtdPeneira15        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '15', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 15', position: 141 }] }
      @EndUserText.label  : '% Peneira 15'
      @EndUserText.quickInfo  : '% Peneira 15'
      Peneira15           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '14', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Peneira 14', position: 150 }] }
      QtdPeneira14        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '14', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 14', position: 151 }] }
      @EndUserText.label  : '% Peneira 14'
      @EndUserText.quickInfo  : '% Peneira 14'
      Peneira14           : wsd_margin_percentage;

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Peneira 13', position: 160 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '13', position: 1 }]
      QtdPeneira13        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '13', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 13', position: 161 }] }
      @EndUserText.label  : '% Peneira 13'
      @EndUserText.quickInfo  : '% Peneira 13'
      Peneira13           : wsd_margin_percentage;

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Peneira 12', position: 170 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '12', position: 1 }]
      QtdPeneira12        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '12', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 12', position: 171 }] }
      @EndUserText.label  : '% Peneira 12'
      @EndUserText.quickInfo  : '% Peneira 12'
      Peneira12           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '11', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Peneira 11', position: 180 }] }
      QtdPeneira11        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '11', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 11', position: 181 }] }
      @EndUserText.label  : '% Peneira 11'
      @EndUserText.quickInfo  : '% Peneira 11'
      Peneira11           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: '10', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{  label: 'Peneira 10',  position: 190 }] }
      QtdPeneira10        : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: '10', position: 2 }]
      //      @Analytics.hidden   : true
      @UI                 : { lineItem: [{ label: '% Peneira 10', position: 191 }] }
      @EndUserText.label  : '% Peneira 10'
      @EndUserText.quickInfo  : '% Peneira 10'
      Peneira10           : wsd_margin_percentage;

      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      //      QtdeDefeitos        : bstmg;
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Def', position: 1 }]
      @UI                 : { lineItem: [{ label: 'Defeitos',  position: 200 }] }
      QtdeDefeitos        : dec9_2;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Def', position: 2 }]
      @EndUserText.label  : '% Defeitos'
      @EndUserText.quickInfo  : '% Defeitos'
      @UI.hidden: true
      Defeitos            : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //     @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Imp', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Impurezas', position: 210 }] }
      QtdeImpurezas       : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Imp', position: 2 }]
      @EndUserText.label  : '% Impurezas'
      @EndUserText.quickInfo  : '% Impurezas'
      Impurezas           : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Fnd', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Fundo', position: 220 }] }
      QtdeFundo           : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Fnd', position: 2 }]
      @EndUserText.label  : '% Fundo'
      @EndUserText.quickInfo  : '% Fundo'
      Fundo               : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Vrd', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Verde', position: 230 }] }
      QtdeVerde           : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Vrd', position: 2 }]
      @EndUserText.label  : '% Verde'
      @EndUserText.quickInfo  : '% Verde'
      Verde               : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Prt', position: 1 }]
      @UI                 : { lineItem: [{ label: 'Preto-Ardido',  position: 240 }] }
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      QtdePretoArdido     : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Prt', position: 2 }]
      @EndUserText.label  : '% Preto-Ardido'
      @EndUserText.quickInfo  : '% Preto-Ardido'
      PretoArdido         : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Cat', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'Catação', position: 250 }] }
      QtdeCatacao         : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Cat', position: 2 }]
      @EndUserText.label  : '% Catação'
      @EndUserText.quickInfo  : '% Catação'
      Catacao             : wsd_margin_percentage;

      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      //      QtdeUmidade         : bstmg;
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Umi', position: 1 }]
      @UI                 : { lineItem: [{  label: 'Umidade',  position: 260 }] }
      QtdeUmidade         : dec9_2;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Umi', position: 2 }]
      @EndUserText.label  : '% Umidade'
      @EndUserText.quickInfo  : '% Umidade'
      @UI.hidden: true
      Umidade             : wsd_margin_percentage;

      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'MK', position: 1 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @UI                 : { lineItem: [{ label: 'MK10',  position: 270 }] }
      QtdeMk10            : bstmg;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'MK', position: 2 }]
      @EndUserText.label  : '% MK10'
      @EndUserText.quickInfo  : '% MK10'
      MK10                :  wsd_margin_percentage;

      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      //      QtdeBrocados        : bstmg;
      @UI                 : { lineItem: [{  label: 'Brocados',  position: 280 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Brc', position: 1 }]
      QtdeBrocados        : dec9_2;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Brc', position: 2 }]
      @EndUserText.label  : '% Brocados'
      @EndUserText.quickInfo  : '% Brocados'
      Brocados            : wsd_margin_percentage;

      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      @UI                 : { lineItem: [{ label: 'Paladar',  position: 290 }] }
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Pld', position: 1 }]
      QtdePaladar         : char30;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Pld', position: 2 }]
      @EndUserText.label  : '% Paladar'
      @EndUserText.quickInfo  : '% Paladar'
      //      Paladar             : wsd_margin_percentage;
      @UI.hidden: true
      Paladar             : wsd_margin_percentage;

      //      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      //@Aggregation.default: #SUM
      //@UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Sfr', position: 1 }]
      //      QtdeSafra           : bstmg;
      @UI                 : { lineItem: [{ label: 'Safra', position: 300 }] }
      QtdeSafra           : char10;
      //      @UI.fieldGroup      : [{ type: #STANDARD, qualifier: 'Sfr', position: 2 }]
      @EndUserText.label  : '% Safra'
      @EndUserText.quickInfo  : '% Safra'
      @UI.hidden: true
      Safra               : wsd_margin_percentage;
      @UI.hidden          : true
      URL_Guia            : eso_longtext;

}
