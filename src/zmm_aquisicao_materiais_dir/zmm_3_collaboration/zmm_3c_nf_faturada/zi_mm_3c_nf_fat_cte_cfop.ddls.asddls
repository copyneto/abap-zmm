@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration - NF Faturada (CTE)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_CTE_CFOP
  as select from    /xnfe/inctehd                as _Cte

    inner join      ZI_MM_3C_NF_FAT_CTE_CFOP_MIN as _CteNfClMin on _CteNfClMin.Guid = _Cte.guid

    inner join      /xnfe/inctenfcl              as _CteNfCl    on  _CteNfCl.guid    = _CteNfClMin.Guid
                                                                and _CteNfCl.counter = _CteNfClMin.Counter

    left outer join /xnfe/inctexml               as _Xml        on  _Xml.guid = _Cte.guid
                                                                and _Xml.type = '1' -- CT-e

{
  key _Cte.nct                             as NumCTe,
  key cast( '2' as ze_mm_3c_doc_type )     as Doctype,
  key _Cte.guid                            as Guid,
      _Cte.cteid                           as AccessKey,
      _CteNfCl.ncfop                       as Cfop,
      cast( '' as /xnfe/ev_tpevento )      as TpEvento,
      concat( _Cte.cteid,
      concat( 'cte-C',
      concat( _CteNfCl.ncfop, '.xml' ) ) ) as Filename,
      _Xml.xmlstring                       as Filexml,
      _Cte.dhemi                           as DtDocumento,
      //_Cte.cnpj_emit                       as CNPJEmissor,
      cast(_Cte.cnpj_emit as abap.char( 20 )) as CNPJEmissor,
      _Cte.xnome_emit                      as NomeEmissor,
      //_Cte.cnpj_dest                       as CNPJDestinatario,
      cast(_Cte.cnpj_dest as abap.char( 20 )) as CNPJDestinatario,
      _Cte.xnome_dest                      as NomeDestinatario
}
