@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Faturada (CTE) - Eventos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_3C_NF_FAT_CTE_EVENT
  as select from    /xnfe/inctehd   as _Cte

    //inner join      /xnfe/events    as _Events    on _Events.guid = _Cte.guid
//
////    left outer join /xnfe/inctexml  as _Xml       on  _Xml.guid = _Cte.guid
////                                                  and _Xml.type = '1' -- CT-e
//                                                  
                                                  

    inner join      ZI_MM_3C_NF_ULTIMO_EVENT as _UltimoEvent on _UltimoEvent.ChaveNFe = _Cte.cteid
    
    inner join      /xnfe/events             as _Events      on _Events.chnfe = _UltimoEvent.ChaveNFe and
                                                             _Events.dhevento = _UltimoEvent.DtEvento and
                                                             _Events.createtime = _UltimoEvent.Createtime
                                                            
    inner join /xnfe/event_xml               as _Xml        on  _Xml.guid = _Events.guid                                                            

{
  key  _Cte.nct                               as NumCTe,
  key  cast( '2' as ze_mm_3c_doc_type )       as Doctype,
  //key  _Cte.guid                              as Guid,
  key  _Events.guid                           as Guid,
       _Cte.cteid                             as AccessKey,
       cast( '' as /xnfe/cte_cfop )           as Cfop,
       _Events.tpevento                       as TpEvento,
       concat( _Cte.cteid,
       concat( 'cte-E',
       concat( _Events.tpevento, '.xml' ) ) ) as Filename,
       _Xml.xmlstring                         as Filexml,
      cast(substring(_Cte.dhemi, 1, 8) as /xnfe/demi  ) as DtDocumento,
      //_Cte.cnpj_emit                          as CNPJEmissor,
      cast(_Cte.cnpj_emit as abap.char( 20 )) as CNPJEmissor,
      _Cte.xnome_emit                         as NomeEmissor,
      //_Cte.cnpj_dest                          as CNPJDestinatario,
      cast(_Cte.cnpj_dest as abap.char( 20 )) as CNPJDestinatario,
      _Cte.xnome_dest                         as NomeDestinatario       
}
where 
    _Cte.dhemi is not initial
