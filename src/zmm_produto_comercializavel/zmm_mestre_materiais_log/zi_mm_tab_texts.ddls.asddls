@AbapCatalog.sqlViewName: 'ZVTABTEXTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Busca textos'
define view ZI_MM_TAB_TEXTS
  as select from dd02t
{
         //  key tabname,
  key    case when  tabname    = 'MARM' or
                    tabname    = 'MLAN' or
                    tabname    = 'MAKT' or
                    tabname    = 'MEAN' or
                    tabname    = 'MKAL' or
                    tabname    = 'QMAT'
                    then concat('D',tabname)
      else ''
      end as tabname,
  key    ddlanguage,
  key    as4local,
  key    as4vers,
         ddtext

}
where
  (
       tabname    = 'MARM'
    or tabname    = 'MLAN'
    or tabname    = 'MAKT'
    or tabname    = 'MEAN'
    or tabname    = 'MKAL'
    or tabname    = 'QMAT'
  )
  and  ddlanguage = $session.system_language
  and  as4local   = 'A'
  and  as4vers    = '0000'

union select from dd02t
{
  key tabname,
  key ddlanguage,
  key as4local,
  key as4vers,
      ddtext
}
where
  (
       tabname    = 'MARA'
    or tabname    = 'MARC'
    or tabname    = 'MARD'
    or tabname    = 'MBEW'
    or tabname    = 'MPOP'
    or tabname    = 'MVKE'
    or tabname    = 'MPOP'
    or tabname    = 'MLGN'
  )
  and  ddlanguage = $session.system_language
  and  as4local   = 'A'
  and  as4vers    = '0000'
