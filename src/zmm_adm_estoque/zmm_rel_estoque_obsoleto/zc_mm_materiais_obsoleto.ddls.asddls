@EndUserText.label: 'Materiais Obsoletos'
@UI.headerInfo: { typeName: 'Material Obsoleto',
                  typeNamePlural: 'Materiais Obsoletos' }

@ObjectModel: { query.implementedBy: 'ABAP:ZCLMM_MATERIAIS_OBSOLETOS'}

define root custom entity ZC_MM_MATERIAIS_OBSOLETO

{
      @UI.selectionField           : [{ position: 50 }]
     @UI.lineItem                 : [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'C_Materialvh', element: 'Material' }}]
      @EndUserText.label           : 'Material'
  key Material                     : matnr;
  
      @UI.selectionField           : [{ position: 30 }]
      @UI.lineItem                 : [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_MM_VH_PLANTVALUEHELP', element: 'Plant' }}]
      @EndUserText.label           : 'Centro'
  key Plant                        : werks_d;
  
      @UI.selectionField           : [{ position: 10 }]
      @UI.lineItem                 : [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_CA_VH_COMPANY', element: 'CompanyCode' }}]
      @EndUserText.label           : 'Empresa'
  key CompanyCode                  : bukrs;


      @UI.lineItem                 : [{ position: 60 }]
      @EndUserText.label           : 'Descrição do Material'
      MaterialName                 : maktx;

      @UI.lineItem                 : [{ position: 40 }]
      @EndUserText.label           : 'Descrição do Centro'
      PlantName                    : text30;

//      @UI.lineItem                 : [{ position: 20 }]
      @EndUserText.label           : 'Descrição da Empresa'
      CompanyCodeName : text25;

      @UI.selectionField           : [{ position: 70 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'C_SalesOrganizationVH', element: 'SalesOrganization' }}]
      @EndUserText.label           : 'Organização de vendas'
      OrgVendas                    : vkorg;
      
      @UI.selectionField           : [{ position: 80 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'C_StorageLocationVH', element: 'StorageLocation' }}]
      @EndUserText.label           : 'Deposito'
      StorageLocation              : lgort_d;
      
      @UI.selectionField           : [{ position: 90 }]
      @EndUserText.label           : 'Data para análise'
      @Consumption.filter.selectionType: #SINGLE
      DataAnalise                  : dats;
      
      @EndUserText.label           : 'Data de corte'
      DataUltimoConsumo            : dats;
      
      @EndUserText.label           : 'Dias até último consumo'
      @UI.selectionField           : [{ position: 110 }]
      @Consumption.filter.selectionType: #SINGLE
      DiasUltimoConsumo            : abap.int4;
      
      @UI.selectionField           : [{ position: 120 }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'C_MM_MaterialGroupValueHelp', element: 'MaterialGroup' }}]
      @EndUserText.label           : 'Grupo de mercadorias'
      GrupoMaterial                : matkl;
      
      @UI.selectionField           : [{ position: 130 }]
      @Consumption.valueHelpDefinition: [{ entity:{name: 'C_MM_MaterialValueHelp', element: 'MaterialType'} }]
      @EndUserText.label           : 'Tipo de material'
      MaterialType                 : mtart;
      
      @UI.lineItem                 : [{ position: 140 }]
      @EndUserText.label           : 'Denominação do tipo'
      MaterialTypeName             : mtbez;
      
      @UI.lineItem                 : [{ position: 150, label: 'Segmento' }]
      @UI.selectionField           : [{ position: 150, element: 'Segmento' }]
      @EndUserText.label           : 'Segmento'
      Segmento                     : abap.sstring( 10 );
      
      @UI.lineItem                 : [{ position: 160 }]
      //@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation          : #SUM
      @EndUserText.label           : 'Quantidade'
      //MatlWrhsStkQtyInMatlBaseUnit : nsdm_material_stock_in_buom;
      MatlWrhsStkQtyInMatlBaseUnit : abap.dec( 17, 2 );
      
      @UI.lineItem                 : [{ position: 170 }]
      @EndUserText.label           : 'Unidade'
      MaterialBaseUnit             : meins;
      
      @UI.lineItem                 : [{ position: 180 }]
      //@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @EndUserText.label           : 'Valor'
      @DefaultAggregation          : #SUM
      //StockValueInCCCrcy           : nsdm_stock_value_in_cccrcy;
      StockValueInCCCrcy           : abap.dec( 17, 2 );
      
      @UI.lineItem                 : [{ position: 190 }]
      CompanyCodeCurrency          : waers;
      
      @UI.lineItem                 : [{ position: 200 }]
      @EndUserText.label           : 'Qtd. dias sem movimentação'
      AnaliseDias                  : abap.int4;
      
      @UI.lineItem                 : [{ position: 210 }]
      @EndUserText.label           : 'Mês'
      PeriodoCorrente              : abap.int2;
      
      @UI.lineItem                 : [{ position: 220 }]
      @EndUserText.label           : 'Ano'
      Exercicio                    : gjahr;
      
      @UI.lineItem                 : [{ position: 230 }]
      @EndUserText.label           : 'Nº da conta'
      GLAccount                    : sakto;
      
      @UI.lineItem                 : [{ position: 240 }]
      @EndUserText.label           : 'Desc. da conta'
      GLAccountName                : txt20;
      
      @UI.lineItem                 : [{ position: 250 }]
      @EndUserText.label           : 'Data última movimentação'
      PostingDate                  : budat;
};
