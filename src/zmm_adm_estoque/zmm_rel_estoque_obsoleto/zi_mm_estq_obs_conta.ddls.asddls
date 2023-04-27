@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Materiais obsoletos - Conta Contábil'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_ESTQ_OBS_CONTA
  as select from    Mbv_Mbew       as _Material

    left outer join t030           as _Account     on  _Account.ktopl = 'PC3C'
                                                   and _Account.ktosl = 'BSX'
                                                   and _Account.bklas = _Material.bklas

    left outer join ZI_PM_VH_CONTA as _AccountText on  _AccountText.Conta = _Account.konts
                                                   and _AccountText.ktopl = _Account.ktopl

{
  key _Material.matnr        as Material,
  key _Material.bwkey        as Plant,
      _Account.konts         as GLAccount,
      _AccountText.NomeConta as GLAccountName
}
group by
  _Material.matnr,
  _Material.bwkey,
  _Account.konts,
  _AccountText.NomeConta
