@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Formatação campo NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CONF_PEDIDO_NF_FORMART as 
select from ekes 
{
  key ekes.ebeln,
  key ekes.ebelp,
  key ekes.etens,
  case instr(ekes.xblnr, '-')
  when 2 then cast ( substring( ekes.xblnr, 1, 1 ) as xblnr_long )      
  when 3 then cast ( substring( ekes.xblnr, 1, 2 ) as xblnr_long )       
  when 4 then cast ( substring( ekes.xblnr, 1, 3 ) as xblnr_long )      
  when 5 then cast ( substring( ekes.xblnr, 1, 4 ) as xblnr_long )
  when 6 then cast ( substring( ekes.xblnr, 1, 5 ) as xblnr_long )
  when 7 then cast ( substring( ekes.xblnr, 1, 6 ) as xblnr_long )
  when 8 then cast ( substring( ekes.xblnr, 1, 7 ) as xblnr_long )
  when 9 then cast ( substring( ekes.xblnr, 1, 8 ) as xblnr_long )
  when 10 then cast ( substring( ekes.xblnr, 1, 9 ) as xblnr_long )
  when 11 then cast ( substring( ekes.xblnr, 1, 10 ) as xblnr_long )
  when 12 then cast ( substring( ekes.xblnr, 1, 11 ) as xblnr_long )
  when 13 then cast ( substring( ekes.xblnr, 1, 12 ) as xblnr_long )
  when 14 then cast ( substring( ekes.xblnr, 1, 13 ) as xblnr_long )
  when 15 then cast ( substring( ekes.xblnr, 1, 14 ) as xblnr_long )
  when 16 then cast ( substring( ekes.xblnr, 1, 15 ) as xblnr_long )                                                                                        
  else cast( ekes.xblnr as xblnr_long ) end as xblnr_format      
}
