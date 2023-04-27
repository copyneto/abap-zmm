@AbapCatalog.sqlViewName: 'ZVMM_NFDATES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca datas com conversão Timestamp'
define view ZI_MM_NFDATES
  as select from /xnfe/innfehd       as _hd
    inner join   ZI_MM_INNFHIST_DATA as _hist on _hd.guid_header = _hist.guid_header
{
  _hd.guid_header,

  tstmp_to_dats( cast(_hd.createtime as timestamp),
                 abap_system_timezone( $session.client,'NULL' ),
                 $session.client,
                 'NULL' ) as createtime,

  tstmp_to_dats( cast(_hist.createtime as timestamp),
                 abap_system_timezone( $session.client,'NULL' ),
                 $session.client,
                 'NULL' ) as histcreatetime

}
