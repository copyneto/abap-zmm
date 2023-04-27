@AbapCatalog.sqlViewName: 'ZVIMMDOCLOG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log Liberação Pagamento'
define view ZI_MM_LOG_LIB_PAG
  as select distinct from balhdr
{
  key extnumber                             as LogExternalId,
      object                                as LogObjectId,
      subobject                             as LogObjectSubId,
      cast( min( aldate ) as abap.char(8) ) as DateFrom

}
where
      object    = 'ZMM'
  and subobject = 'ZMM_LIB_PGTO'

group by
  extnumber,
  object,
  subobject
