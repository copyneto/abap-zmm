@AbapCatalog.sqlViewName: 'ZMM_INV_H'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS HIS'
define view ZI_MM_INVENTARIO_ETAPAS
  as select from /xnfe/innfhist  as _hist
    inner join   ZI_MM_INNFHIST2 as _max on  _max.guid_header = _hist.guid_header
                                         and _max.histcount   = _hist.histcount
    inner join   /xnfe/procstept as PT   on  PT.procstep = _hist.procstep
                                         and PT.langu    = 'P'
{
  _hist.guid_header,
  _hist.proctyp,
  _hist.procstep,
  _hist.createtime,
  _hist.username,
  PT.description
}
union all select from /xnfe/innfhist  as _hist
  inner join          ZI_MM_INNFHIST  as _max on  _max.guid_header = _hist.guid_header
                                              and _max.histcount   = _hist.histcount
  inner join          /xnfe/procstept as PT   on  PT.procstep = _hist.procstep
                                              and PT.langu    = 'P'
{
  _hist.guid_header,
  _hist.proctyp,
  _hist.procstep,
  _hist.createtime,
  _hist.username,
  PT.description
}
union all select from /xnfe/innfhist  as _hist
  inner join          ZI_MM_INNFHIST3 as _max on  _max.guid_header = _hist.guid_header
                                              and _max.histcount   = _hist.histcount
  inner join          /xnfe/procstept as PT   on  PT.procstep = _hist.procstep
                                              and PT.langu    = 'P'
{
  _hist.guid_header,
  _hist.proctyp,
  _hist.procstep,
  _hist.createtime,
  _hist.username,
  PT.description
}
