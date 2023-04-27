@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '3Collaboration - NF Faturada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_3C_NF_FATURADA
  as select from ZI_MM_3C_NF_FATURADA_U
  
  association [0..1] to ZI_MM_3C_VH_DOC_TYPE  as _Doctype       on  _Doctype.Doctype = $projection.Doctype
  
  association [0..1] to ZI_MM_3C_VH_TP_EVENTO as _TpEvento      on  _TpEvento.TpEvento = $projection.TpEvento 

  association [0..1] to /xnfe/inctexml        as _Cte           on  _Cte.guid = $projection.Guid
                                                                and _Cte.type = '1' -- CT-e

  association [0..1] to /xnfe/inxml           as _Nfe           on  _Nfe.guid_header = $projection.Guid
                                                                and _Nfe.type        = '1' -- NF-e                                                                    
    
  association [0..1] to /xnfe/event_xml       as _EventNfe      on  _EventNfe.guid = $projection.Guid
  
  association [0..1] to /xnfe/event_xml       as _EventCte      on  _EventCte.guid = $projection.Guid
  
  //association [0..1] to ZI_CA_VH_CPF_CNPJ     as _PartnerEmissor  on  _PartnerEmissor.CpfCnpj = $projection.BR_NFPartnerCNPJ  
{
  
  
  //key BR_NotaFiscal,
  key NumRegistro                      as NumRegistro,
  key Doctype                          as Doctype,
  key Guid                             as Guid,

      _Doctype.DoctypeText             as DoctypeText,

      case Doctype when '1' then 3
                   when '2' then 2
                            else 0 end as DoctypeCrit,
            
      DtDocumento                      as DtDocumento,
      NomeEmissor                      as NomeEmissor,
      CNPJEmissor                      as CNPJEmissor,
      CNPJDestinatario                 as CNPJDestinatario,
      NomeDestinatario                 as NomeDestinatario,
      NumRegistro                      as BR_NFeNumber,
      AccessKey                        as AccessKey,
      Cfop                             as Cfop,
      TpEvento                         as TpEvento,
      _TpEvento.TpEventoText           as TpEventoText,
      Filename                         as Filename,       
      _Cte.xmlstring                   as FileCteXml,
      _Nfe.xmlstring                   as FileNfeXml,
      _EventNfe.xmlstring              as FileEventCteXml,
      _EventCte.xmlstring              as FileEventNfeXml
}

