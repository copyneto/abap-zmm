@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration - NF Faturada (NFE)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_NFE_CFOP
  as select from    /xnfe/innfehd                as _Nfe

    inner join      ZI_MM_3C_NF_FAT_NFE_CFOP_MIN as _NfeItMin  on _NfeItMin.GuidHeader = _Nfe.guid_header

    inner join      /xnfe/innfeit                as _NfeIt     on  _NfeIt.guid_header = _NfeItMin.GuidHeader
                                                               and _NfeIt.nitem       = _NfeItMin.Nitem

    left outer join /xnfe/inxml                  as _Xml       on  _Xml.guid_header = _Nfe.guid_header
                                                               and _Xml.type        = '1' -- NF-e

{
  key _Nfe.nnf                          as NumNF,
  key cast( '1' as ze_mm_3c_doc_type )  as Doctype,
  key _Nfe.guid_header                  as Guid,
      _Nfe.nfeid                        as AccessKey,      
      _NfeIt.cfop                       as Cfop,
      cast( '' as /xnfe/ev_tpevento )   as TpEvento,
      concat( _Nfe.nfeid,
      concat( 'nfe-C',
      concat( _NfeIt.cfop, '.xml' ) ) ) as Filename,
      _Xml.xmlstring                    as Filexml,
      _Nfe.demi                         as DtDocumento,
      cast(_Nfe.cnpj_emit as abap.char( 20 )) as CNPJEmissor,
      _Nfe.c_xnome                      as NomeEmissor,
      //_Nfe.cnpj_dest                    as CNPJDestinatario,
      cast(_Nfe.cnpj_dest as abap.char( 20 )) as CNPJDestinatario,
      _Nfe.  e_xnome                    as NomeDestinatario
}
