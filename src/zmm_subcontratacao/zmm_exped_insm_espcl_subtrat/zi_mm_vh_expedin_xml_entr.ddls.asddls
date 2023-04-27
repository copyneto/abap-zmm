@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help de XLML de Entrada- Expedição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_EXPEDIN_XML_ENTR
  as select from ZI_MM_EXPEDINSUM_ESPC_SUBCONTR
{
  key XmlEntrad
}
group by
  XmlEntrad
