@AbapCatalog.sqlViewName: 'ZVMM_NFHIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca ultimo historico NF'
define view ZI_MM_INNFHIST
  as select from /xnfe/innfhist as _max
{

  _max.guid_header,
  max(_max.histcount) as histcount

}
where procstep = 'NFESIMUL'
group by
  _max.guid_header
  
