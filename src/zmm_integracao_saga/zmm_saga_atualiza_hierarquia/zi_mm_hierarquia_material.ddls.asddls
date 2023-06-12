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

      case when t179.stufe = '1'
            then t179.prodh
           else substring(t179.prodh, 1, 5)
            end   as Nivel1,

      case when t179.stufe = '1'
            then ''
           else substring(t179.prodh, 6, 5)
            end   as Nivel2,

      case when t179.stufe = '1' or t179.stufe = '2'
            then ''
           else substring(t179.prodh, 11, 8)
            end   as Nivel3,

      t179.stufe  as Nivel,
      _Text.vtext as Descricao
}
where
  _Text.spras = $session.system_language;
