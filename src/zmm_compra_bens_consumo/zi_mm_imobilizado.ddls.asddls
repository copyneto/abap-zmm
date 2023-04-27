@AbapCatalog.sqlViewName: 'ZVMM_IMOB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de ativos FI-AA'
define view ZI_MM_IMOBILIZADO
  as select distinct from anlz as b
    inner join            anla as a
    on  a.bukrs = b.bukrs
    and a.anln1 = b.anln1
    and a.anln2 = b.anln2
    inner join pstckbatchinfo as c
    on b.werks = c.werks
    inner join I_StorageLocation as d
    on d.Plant = b.werks
{
  key a.anln1 as Anln1,
  key a.anln2 as Anln2,
      a.invnr as Invnr,
      b.werks as Werks,
      d.StorageLocation as Lgort
}
where c.mng01 > 0
