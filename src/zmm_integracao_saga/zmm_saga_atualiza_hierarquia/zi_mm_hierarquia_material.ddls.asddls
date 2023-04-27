@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Hierarquia materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_MM_HIERARQUIA_MATERIAL
  as select from t179
    inner join   t179t as _Text on _Text.prodh = t179.prodh
{
  key t179.prodh  as Hierarquia,
      t179.stufe  as Nivel,
      _Text.vtext as Descricao
}
where
  _Text.spras = $session.system_language;
