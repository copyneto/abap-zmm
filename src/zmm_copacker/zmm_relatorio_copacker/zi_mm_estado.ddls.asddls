@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busa Estado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ESTADO
  as select from    I_PurchasingDocumentItem as PurchasingDocumentItem
    left outer join t001w on PurchasingDocumentItem.Plant = t001w.werks
{
  key  PurchasingDocumentItem.PurchasingDocument,
  key  PurchasingDocumentItem.PurchasingDocumentItem,
       PurchasingDocumentItem.Plant,
       t001w.regio as Estado
}
where
  PurchasingDocumentItem.Plant <> ''
