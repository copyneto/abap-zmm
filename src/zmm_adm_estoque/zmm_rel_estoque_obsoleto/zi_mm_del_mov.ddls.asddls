@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos movi. periodo de 180 dias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_DEL_MOV
  as select from ZI_MM_TIPO_MOV
{
  key Material,
  key Plant,
  AnaliseDias
}
//where
//  AnaliseDias <= 180 //
group by
  Material,
  Plant,
  AnaliseDias
