@EndUserText.label: 'Conferência de Produtos'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['werks','mtart','matnr','meinh']
@Search.searchable: true

define root view entity ZC_MM_CONF_PROD
  as projection on ZI_MM_CONF_PROD
{
          @Search.defaultSearchElement: true
  key     werks,
          @Search.defaultSearchElement: true
  key     mtart,
          @Search.defaultSearchElement: true
  key     matnr,
  key     meinh,
          @Search.defaultSearchElement: true 
          maxlz,
          meins,
          gewei,
          mhdrz,
          mhdhb,
          prdha,
          maktx,
          umrez,
          umren,
          z_lastro,
          z_altura,
          z_unit,
          VTEXT1,
          VTEXT2,
          VTEXT3,
          ean11,
          numtp,
          laeng,
          breit,
          hoehe,
          meabm,
          volum,
          voleh,
          zbrgew,
          zntgew
//          @UI.hidden: true
//          brgew,
//          @UI.hidden: true
//          ntgew,
//          @UI.hidden: true
//          brgew_mara
}
