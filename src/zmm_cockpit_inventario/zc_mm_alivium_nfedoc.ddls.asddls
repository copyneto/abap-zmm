@AbapCatalog.sqlViewName: 'ZCMMINVNFDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Notas Fiscais - Alivium'
define view ZC_MM_ALIVIUM_NFEDOC
  as select from ZI_MM_ALIVIUM_NFEDOC
{
  key docnum,
      nfenum,
      docstat,
      cfop,
      direct,
      case direct
        when '1'
          then case
                 when ( code <> '100' and docstat = '1' ) or cancel = 'X'
                   then 'X'
                 else ''
               end
        else ''
      end as status_nf_en,

      case direct
        when '1'
          then case
                 when ( code <> '100' and docstat = '1' ) or cancel = 'X'
                   then '1'
                 else ''
               end
          else ''
      end       as docstat_icon_en,

      case direct
        when '1'
          then docnum
        else ''
      end       as Nfenum_en,

      code,
      cancel,
      action_requ
}
