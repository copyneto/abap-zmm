@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados do Produto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MM_CONF_PROD_HIERA
  as select from    t179             as a
{
  key a.prodh,
  substring(a.prodh, 1, 5)  as herar1,
  substring(a.prodh, 1, 10) as herar2 
  }
