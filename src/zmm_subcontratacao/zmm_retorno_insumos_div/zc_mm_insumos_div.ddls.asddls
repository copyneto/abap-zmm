@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS ADM Ret de Insumos Div'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@VDM.viewType: #CONSUMPTION

@OData.publish: true


@UI.headerInfo: {
     typeName      : 'Adm Retorno Insumos Div' ,
     typeNamePlural: 'Adm Retorno Insumos Div' }
     
define view entity ZC_MM_INSUMOS_DIV 
as select from ZI_MM_INSUMOS_DIV {
  @UI.facet: [


              { id:           'geral',
               purpose:       #STANDARD,
               label:         'Dados Gerais',
               type:          #FIELDGROUP_REFERENCE,
               targetQualifier: 'Dados',
               position:      10 } ]
               
 @UI.hidden: true       
 key Key1,  
  @UI.hidden: true       
 key Key2,  
  @UI.hidden: true       
 key Key3,            
  @UI.hidden: true       
 key Key4,  
  @UI.hidden: true       
 key Key5,         
  @UI.hidden: true       
 key Key6,      
 
  @UI: { lineItem:        [ { position: 10, label: 'Fornecedor' } ],
         identification:  [ { position: 10, label: 'Fornecedor' } ] ,
         selectionField: [ { position: 10} ],
         fieldGroup: [    { qualifier: 'Dados', label: 'Fornecedor' }] }
  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
//  @ObjectModel.text.element: ['LifnrCodeName']
  key lifnr,
  @UI: { lineItem:        [ { position: 30, label: 'Centro' } ],
         identification:  [ { position: 30, label: 'Centro' } ] ,
         selectionField: [ { position: 20} ],
         fieldGroup: [    { qualifier: 'Dados', label: 'Centro' }] }
 @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
 @Consumption.filter.mandatory: true
  key werks,
  
  @UI: { lineItem:        [ { position: 50, label: 'Material' } ],
         identification:  [ { position: 50, label: 'Material' } ],
         selectionField: [ { position: 30} ],
  fieldGroup: [    { qualifier: 'Dados', label: 'Material' }] }
  @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_MATNR_VH', element: 'MatnrCode' } }]
  key matnr,
  
  @UI: { lineItem:        [ { position: 70, label: 'Pedido' } ],
  identification:  [ { position: 70, label: 'Pedido' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Pedido' }] }
   key ebeln,
  
  @UI: { lineItem:        [ { position: 80, label: 'Item' } ],
  identification:  [ { position: 80, label: 'Item' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Item' }] }
   key ebelp,
  
  @UI: { lineItem:        [ { position: 150, label: 'Doc.Material' } ],
  identification:  [ { position: 150, label:  'Doc.Material' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label:  'Doc.Material' }] }
  
key mblnr,
  

 
   @UI: { lineItem:        [ { position: 90, label: 'Qtd.' } ],
  identification:  [ { position: 90, label: 'Qtd.' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Qtd.' }] }
  
 LvQtdePed,
  
  @UI : { selectionField: [ { position: 30} ]}
  @Consumption.filter.mandatory: true
  
 budat,
  
    @UI: { lineItem:        [ { position: 100, label: 'Qtd.Retorno' } ],
  identification:  [ { position: 100, label: 'Qtd.Retorno' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Qtd.Retorno' }] }

LvQtdeRet,
  
  @UI: { lineItem:        [ { position: 20, label: 'Desc. Fornecedor' } ],
  identification:  [ { position: 20, label: 'Desc. Fornecedor' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Desc. Fornecedor' }] }
  LifnrCodeName,

  @UI: { lineItem:        [ { position: 40, label: 'Desc.Centro' } ],
  identification:  [ { position: 40, label: 'Desc. Centro' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Desc. Centro' }] }
  WerksCodeName,

  @UI: { lineItem:        [ { position: 60, label: 'Desc. Material' } ],
  identification:  [ { position: 60, label: 'Desc. Material' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Desc. Material' }] }
  maktx,

    @UI: { lineItem:        [ { position: 130, label: 'NF-e' } ],
  identification:  [ { position: 130, label: 'NF-e' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'NF-e' }] }
nfenum,
  
  @UI: { lineItem:        [ { position: 140, label: 'Docnum' } ],
  identification:  [ { position: 140, label: 'Docnum' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Docnum' }] }
 docnum,

  

  
  @UI: { lineItem:        [ { position: 110, label: 'Divergência', value: 'Divergencia', criticality: 'Criticality', criticalityRepresentation: #WITHOUT_ICON} ],
  identification:  [ { position: 110, label: 'Divergência' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'Divergência' }] }
  Divergencia,
  Criticality,
  
  @UI: { lineItem:        [ { position: 120, label: 'UM' } ],
  identification:  [ { position: 120, label: 'UM' } ] ,
  fieldGroup: [    { qualifier: 'Dados', label: 'UM' }] }
  meins
  
}
where Marca = 'X'
