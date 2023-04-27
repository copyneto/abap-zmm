@AbapCatalog.sqlViewName: 'ZVMM_NFHISTDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do ultimo item Historico'
define view ZI_MM_INNFHIST_DATA
  as select from /xnfe/innfhist as _hist
  inner join ZI_MM_INNFHIST as _max on _max.guid_header = _hist.guid_header
                                   and _max.histcount   = _hist.histcount  
{
    _hist.guid_header,
    _hist.proctyp,
    _hist.procstep,
    _hist.createtime,
    _hist.username
  } 
