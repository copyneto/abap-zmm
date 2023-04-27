@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Faturada (NFE) - Eventos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_NFE_EVENT
  as select from    /xnfe/innfehd   as _Nfe
        
    
//    inner join        ZTB_MM_3C_NF_ULTIMO_EVENT as _UltimoEvent on _UltimoEvent.chnfe = _Nfe.nfeid
//    inner join        /xnfe/event_xml           as _Xml         on  _Xml.guid = _UltimoEvent.guid
   
    inner join      ZI_MM_3C_NF_ULTIMO_EVENT as _UltimoEvent on _UltimoEvent.ChaveNFe = _Nfe.nfeid
    
    left outer to one join /xnfe/events    as _Events    on _Events.chnfe = _UltimoEvent.ChaveNFe and
                                                            _Events.dhevento = _UltimoEvent.DtEvento and
                                                            _Events.createtime = _UltimoEvent.Createtime

    ////left outer join /xnfe/inxml     as _Xml       on  _Xml.guid_header = _Nfe.guid_header    
                                                  //and _Xml.type        = '1' -- NF-e
                                                  
    
    left outer join /xnfe/event_xml   as _Xml       on  _Xml.guid = _Events.guid                                                                                                                  
{
  
  key _Nfe.nnf                               as NumNF,
  key cast( '1' as ze_mm_3c_doc_type )       as Doctype,
  //key _Nfe.guid_header                       as Guid,
  key _Events.guid                      as Guid,
      _Nfe.nfeid                             as AccessKey,
      cast( '' as /xnfe/cte_cfop )           as Cfop,
      _Events.tpevento                  as TpEvento,
      //concat( _AccessKey.chaveNFE,
      concat( _Nfe.nfeid,
      concat( 'nfe-E',
      concat( _Events.tpevento, '.xml' ) ) ) as Filename,
      _Xml.xmlstring                         as Filexml,      
      _Nfe.demi                              as DtDocumento,
      //_Nfe.cnpj_emit                         as CNPJEmissor,
      cast(_Nfe.cnpj_emit as abap.char( 20 )) as CNPJEmissor,
      _Nfe.c_xnome                           as NomeEmissor,
      //_Nfe.cnpj_dest                         as CNPJDestinatario,
      cast(_Nfe.cnpj_dest as abap.char( 20 )) as CNPJDestinatario,
      _Nfe.e_xnome                           as NomeDestinatario
            
}    
//where
    //_Nfe.demi is not initial
