@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cds ADM Recebimento de Insumo'
define root view entity ZI_MM_ADM_RECEBINSUMO
  as select from    /xnfe/innfehd        as _ehd

    inner join      ZI_MM_FILTRO_INNFEIT as _eit on _ehd.guid_header = _eit.GuidHeader
    inner join      ZI_MM_FILTRO_LIFNR   as _lif on _ehd.cnpj_emit = _lif.Stcd1
    inner join      ZI_MM_FILTRO_KUNNR   as _kun on _ehd.cnpj_dest = _kun.Stcd1
//    inner join      ZI_MM_FILTRO_WERKS   as _wer on _kun.Kunnr = _wer.Kunnr
    inner join      ZI_MM_FILTRO_DEMI    as _dem on _ehd.guid_header = _dem.GuidHeader
    left outer join j_1bnfe_active       as _act on  _dem.NFYEAR    = _act.nfyear
                                                 and _dem.NFMONTH   = _act.nfmonth
                                                 and _ehd.cnpj_emit = _act.stcd1
                                                 and _ehd.mod       = _act.model
                                                 and _ehd.nnf       = _act.nfnum9
                                                 and _act.direct    = '1'
                                                 and _act.cancel    <> 'X'
 
    left outer join j_1bnflin       as _lin on  _act.docnum    = _lin.docnum
//    inner join j_1bnflin       as _lin on  _act.docnum    = _lin.docnum
 
 
  //    left outer join      j_1bnfe_active       as _act on _can.DocNum = _act.docnum

  association [0..1] to ZI_CA_VH_LIFNR      as _LIFNR  on _LIFNR.LifnrCode = $projection.LifnrCode
  association [0..1] to ZI_CA_VH_WERKS      as _WERKS  on _WERKS.WerksCode = $projection.WerksCode
  association [0..1] to ZI_MM_FILTRO_NNF    as _NNF    on _NNF.nnf = $projection.Nnf
  association [0..1] to ZI_MM_FILTRO_STATUS as _STATUS on _STATUS.Status = $projection.Status
  //  association [0..1] to ZI_MM_VH_ARMZ_XML   as _XML    on _XML.XML_EntIns = $projection.XML
{
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
  key    _lif.Lifnr           as LifnrCode,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
  key    _eit.werks           as WerksCode,
//  key    _lin.werks           as WerksCode,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_CFOP_INS', element: 'Cfop1' } }]
  key    _eit.Cfop            as Cfop,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_FILTRO_NNF', element: 'nnf' } }]
  key    _ehd.nnf             as Nnf,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_XML', element: 'XML_EntIns' } }]
         @EndUserText.label: 'XML Entrada do Insumo'
  key    _ehd.nfeid           as XML,
         //      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_FILTRO_DOCNUM', element: 'DocNum' } }]
  key    case
      when _act.action_requ = 'C' and _act.cancel <> 'X'
      then _act.docnum
         //      else  '0000000000' end  as DocNum,
      else  '0000000000' end  as BR_NotaFiscal,

         _ehd.demi            as DataEmissao,
         case
          when _act.action_requ  = 'C' and _act.cancel <> 'X'
          then _act.credat
          else '00000000' end as Credat,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_FILTRO_STATUS', element: 'Status' } }]
         case
         when _act.action_requ = 'C' and _act.cancel <> 'X'
         then '1'
         else '0' end         as Status,

         case
         when _act.action_requ = 'C' and _act.cancel <> 'X'
         then 3
         else 2 end           as StatusCriticality,



         //      _act.docnum             as Docnum2,
         //      _act.docsta             as Docsta,
         //      _act.scssta             as Scssta,
         //      _act.conting            as Conting,
         //      _act.cancel             as Cancel,
         //      _act.code               as Code,
         //      _act.regio              as Regio,
         //      _act.nfyear             as Nfyear,
         //      _act.nfmonth            as Nfmonth,
         //      _act.stcd1              as Stcd1,
         //      _act.model              as Model,
         //      _act.serie              as Serie,
         //      _act.nfnum9             as Nfnum9,
         //      _act.docnum9            as Docnum9,
         //      _act.cdv                as Cdv,
         //      _act.authcod            as Authcod,
         //      _act.credat             as Credat2,
         //      _act.action_date        as ActionDate,
         //      _act.action_time        as ActionTime,
         //      _act.action_user        as ActionUser,
         //      _act.bukrs              as Bukrs,
         //      _act.branch             as Branch,
         //      _act.vstel              as Vstel,
         //      _act.parid              as Parid,
         //      _act.partyp             as Partyp,
         //      _act.direct             as Direct,
         //      _act.refnum             as Refnum,
         //      _act.form               as Form,
         //      _act.action_requ        as ActionRequ,
         //      _act.printd             as Printd,
         //      _act.conting_s          as ContingS,
         //      _act.msstat             as Msstat,
         //      _act.reason             as Reason,
         //      _act.reason1            as Reason1,
         //      _act.reason2            as Reason2,
         //      _act.reason3            as Reason3,
         //      _act.reason4            as Reason4,
         //      _act.crenam             as Crenam,
         //      _act.callrfc            as Callrfc,
         //      _act.tpamb              as Tpamb,
         //      _act.sefaz_active       as SefazActive,
         //      _act.scan_active        as ScanActive,
         //      _act.checktmpl          as Checktmpl,
         //      _act.authdate           as Authdate,
         //      _act.authtime           as Authtime,
         //      _act.tpemis             as Tpemis,
         //      _act.reason_conting     as ReasonConting,
         //      _act.reason_conting1    as ReasonConting1,
         //      _act.reason_conting2    as ReasonConting2,
         //      _act.reason_conting3    as ReasonConting3,
         //      _act.reason_conting4    as ReasonConting4,
         //      _act.conting_date       as ContingDate,
         //      _act.conting_time       as ContingTime,
         //      _act.contin_time_zone   as ContinTimeZone,
         //      _act.cancel_allowed     as CancelAllowed,
         //      _act.source             as Source,
         //      _act.cancel_pa          as CancelPa,
         //      _act.event_flag         as EventFlag,
         //      _act.active_service     as ActiveService,
         //      _act.svc_sp_active      as SvcSpActive,
         //      _act.svc_rs_active      as SvcRsActive,
         //      _act.svc_active         as SvcActive,
         //      _act.rps                as Rps,
         //      _act.nfse_number        as NfseNumber,
         //      _act.nfse_check_code    as NfseCheckCode,
         //      _act.code_description   as CodeDescription,
         //      _act.cmsg               as Cmsg,
         //      _act.xmsg               as Xmsg,
         //      _act.cloud_guid         as CloudGuid,
         //      _act.cloud_extens_flag  as CloudExtensFlag,
         //      _act.replacement_status as ReplacementStatus,

         _LIFNR,
         _WERKS,
         _NNF,
         _STATUS
         //         _XML




}
