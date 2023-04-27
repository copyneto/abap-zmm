@AbapCatalog.sqlViewName: 'ZVFIGROUPDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados Fin. KOSTL-GSBER-PRCTR-SEGMENT'
define view ZI_FI_FIN_GROUP_DATA
  as select distinct from tka3a          as _cska
    inner join            I_CostCenter   as _csks on  _cska.kokrs = _csks.ControllingArea
                                                  and _cska.kostl = _csks.CostCenter
                                                  and _cska.bukrs = _csks.CompanyCode
    inner join            I_ProfitCenter as _cepc on  _csks.ControllingArea   = _cepc.ControllingArea
                                                  and _csks.ProfitCenter      = _cepc.ProfitCenter
                                                  and _cepc.ValidityEndDate   >= $session.system_date
                                                  and _cepc.ValidityStartDate <= $session.system_date
{
  key  _cska.bukrs as CompanyCode,
  key  _cska.kstar as CostClass,
  key  _csks.CostCenter,
  key  _csks.ControllingArea,
       _csks.BusinessArea,
       _csks.ProfitCenter,
       _cepc.Segment
}
where
      _csks.ControllingArea   = 'AC3C'
  and _csks.ValidityEndDate   >= $session.system_date
  and _csks.ValidityStartDate <= $session.system_date
