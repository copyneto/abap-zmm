@AbapCatalog.sqlViewName: 'ZVMM_ACCESSKEY2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View para AccessKey Selecionar'
define view ZI_MM_ACCESSKEY2
  as select distinct from ZI_MM_ACCESSKEY as AccessKey

    left outer join       ZI_MM_ACCESSKEY as _AccessKey3 on  AccessKey.BR_NFeAccessKey  = _AccessKey3.BR_NFeAccessKey
                                                         and _AccessKey3.BR_NFDirection = '1'
{
  key   AccessKey.BR_NotaFiscal     as NF,
        AccessKey.BR_NFeAccessKey   as Key2,
        _AccessKey3.BR_NFeAccessKey as Key1
}
where
  AccessKey.BR_NFDirection = '2'
