@EndUserText.label: 'Download de XML'

@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCLMM_DOWNLOAD_XML'
    }
}

@UI: { 
    headerInfo: { 
        typeName: 'Nota Fiscal' , 
        typeNamePlural: 'Notas Fiscais',
    title: {
        type: #STANDARD,
        label: 'Nota Fiscal',
        value: 'nfenum'
    }
},

presentationVariant: [{ sortOrder: [{ by: 'pstdat', direction: #DESC }], visualizations: [{ type: #AS_LINEITEM }] }]}


define root custom entity ZC_MM_XML_MASS
{

      @UI.facet    : [ { id: 'NFe', purpose: #STANDARD, type: #IDENTIFICATION_REFERENCE , label: 'Nota Fiscal', position: 10 } ]

      //@Consumption.filter.selectionType: #INTERVAL
      @Consumption.semanticObject: 'NotaFiscal'
      @UI          : { lineItem: [{ position: 10, type: #WITH_INTENT_BASED_NAVIGATION, semanticObjectAction: 'display', requiresContext: true  }],
                 identification: [{ position: 10 }],
                 selectionField: [{ position: 30 }] }
  key docnum       : j_1bdocnum;
      @UI          : { lineItem: [{ position: 20 }],
                 identification: [{ position: 20 }],
                 selectionField: [{ position: 40 }] }
      @Consumption.filter.selectionType: #INTERVAL
      nfenum       : j_1bnfnum9;
      @Consumption.filter.mandatory: false
      @Consumption.filter.selectionType: #INTERVAL
      @UI          : { lineItem: [{ position: 30 }],
                 identification: [{ position: 30 }],
                 selectionField: [{ position: 10 }] }
      pstdat       : j_1bpstdat;
      @Consumption.filter.mandatory: false
      @Consumption.filter.selectionType: #INTERVAL
      @UI          : { lineItem: [{ position: 40 }],
                 identification: [{ position: 40 }],
                 selectionField: [{ position: 20 }] }
      docdat       : j_1bdocdat;
      @UI          : { lineItem: [{ position: 50 }],
                 identification: [{ position: 50 }],
                 selectionField: [{ position: 50 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCode', element: 'CompanyCode' }  } ]
      @ObjectModel.text.element: ['butxt']
      bukrs        : bukrs;
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCode', element: 'CompanyCodeName' },
                     additionalBinding: [{ localElement: 'bukrs', element: 'CompanyCode', usage: #RESULT }] }]
      @UI.hidden   : true
      butxt        : butxt;
      @UI          : { lineItem: [{ position: 60 }],
                 identification: [{ position: 60 }],
                 selectionField: [{ position: 60 }] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Branch', element: 'Branch' },
                     additionalBinding: [{ localElement: 'bukrs', element: 'CompanyCode', usage: #FILTER_AND_RESULT }] } ]
      branch       : j_1bbranc_;
      @UI          : { lineItem: [{ position: 90 }],
                 identification: [{ position: 90 }],
                 selectionField: [{ position: 90 }] }
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PARCEIRO', element: 'TaxNumber' },
                     additionalBinding: [{ localElement: 'emissor_uf', element: 'Region', usage: #FILTER_AND_RESULT }] } ]
      @EndUserText.label: 'CNPJ Emissor'
      @ObjectModel.text.element: ['emissor']
      emissor_nfis : stcd1;
      @UI.hidden   : true
      emissor      : name1;
      @UI          : { lineItem: [{ position: 100 }],
                 identification: [{ position: 100 }],
                 selectionField: [{ position: 100 }] }
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PARCEIRO', element: 'Region' },
                     additionalBinding: [{ localElement: 'emissor_nfis', element: 'TaxNumber1', usage: #FILTER_AND_RESULT }] } ]
      @EndUserText.label: 'Região Emissor'
      emissor_uf   : regio;
      @UI          : { lineItem: [{ position: 70 }],
                 identification: [{ position: 70 }],
                 selectionField: [{ position: 70 }] }
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PARCEIRO', element: 'TaxNumber' },
                     additionalBinding: [{ localElement: 'recebe_uf', element: 'Region', usage: #FILTER_AND_RESULT }] } ]
      @EndUserText.label: 'CNPJ Recebedor'
      @ObjectModel.text.element: ['recebedor']
      recebe_nfis  : stcd1;
      @UI.hidden   : true
      recebedor    : name1;
      @UI          : { lineItem: [{ position: 80 }],
                 identification: [{ position: 20 }],
                 selectionField: [{ position: 80 }] }
      @Consumption.filter.selectionType: #SINGLE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_PARCEIRO', element: 'Region' },
                     additionalBinding: [{ localElement: 'recebe_nfis', element: 'TaxNumber', usage: #FILTER_AND_RESULT }] } ]
      @EndUserText.label: 'Região Recebedor'
      recebe_uf    : regio;
}
