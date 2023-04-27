@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Cabeçalho'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_LIB_PGTO_CAB
  as select from    ekko                as _ekko
    join            ZI_MM_LIB_PGTO_DOCS as _doc    on _ekko.ebeln = _doc.NumDocumento
    left outer join ZI_CA_VH_BUKRS      as _emp    on _emp.Empresa = _ekko.bukrs

    left outer join ztmm_pag_gv_cab     as _cab    on _ekko.ebeln = _cab.ebeln

    left outer join ZI_MM_VH_DOC_STATUS as _status on _cab.status = _status.Valor

    left outer join ZI_CA_VH_LIFNR      as _for    on _ekko.lifnr = _for.LifnrCode
{

  key _ekko.bukrs                  as Empresa,
  key substring(_ekko.aedat, 1, 4) as Ano,
  key _ekko.ebeln                  as NumDocumento,
      _emp.EmpresaText             as NomeEmpresa,
      _ekko.lifnr                  as Fornecedor,
      _for.LifnrCodeName           as NomeFornecedor,
      _ekko.aedat                  as PedidoCriadoEm,
      _ekko.ernam                  as PedidoCriadoPor,
      _cab.status                  as Status,
      _status.Texto                as DescricaoStatus,
      _cab.created_by              as CreatedBy,
      _cab.created_at              as CreatedAt,
      _cab.last_changed_by         as LastChangedBy,
      _cab.last_changed_at         as LastChangedAt,
      _cab.local_last_changed_at   as LocalLastChangedAt
}
//where
//  _ekko.ebeln = '4500005021' //para teste
