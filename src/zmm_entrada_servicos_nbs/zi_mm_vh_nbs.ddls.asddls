@AbapCatalog.sqlViewName: 'ZVMMVHNBS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Help Searsh: NBS'
define view ZI_MM_VH_NBS as 
select from j_1btnbs
{
   key nbs     as Nbs,
   description as Description
}
