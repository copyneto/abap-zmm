@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS ADM Ret de Armaxenagem Grão Verde'
define root view entity ZI_MM_RET_ARM_GRAOVERDE
  as select from    /xnfe/innfehd               as _ehd

    inner join      ZI_MM_FILTRO_REFERENCIA_XML as _RefXML on _RefXML.guid_header = _ehd.guid_header
    inner join      ZI_MM_FILTRO_ITEMS_GV       as _eit    on _ehd.guid_header = _eit.GuidHeader
    inner join      /xnfe/innfeit               as _eit2   on _eit.GuidHeader = _eit2.guid_header
    inner join      ZI_MM_FILTRO_LIFNR_GV       as _lif    on _ehd.cnpj_emit = _lif.Stcd1
    inner join      ZI_MM_FILTRO_KUNNR_GV       as _kun    on _ehd.cnpj_dest = _kun.Stcd1
    inner join      ZI_MM_FILTRO_WERKS_GV       as _wer    on _kun.Kunnr = _wer.Kunnr
    inner join      ZI_MM_FILTRO_DEMI_GV        as _dem    on _ehd.guid_header = _dem.GuidHeader

  /*    inner join      ZI_MM_INNFENFE_GV      as _innfenfe on _innfenfe.GuidHeader = _dem.GuidHeader

      left outer join j_1bnfe_active         as _act  on  _innfenfe.nfyear   = _act.nfyear
                                                      and _innfenfe.nfmonth  = _act.nfmonth
                                                      and _innfenfe.stcd1    = _act.stcd1
                                                      and _innfenfe.model    = _act.model
                                                      and _innfenfe.nfnum9   = _act.nfnum9
                                                      and _act.cancel    is initial */

    left outer join j_1bnfe_active              as _act    on  _dem.NFYEAR    = _act.nfyear
                                                           and _dem.NFMONTH   = _act.nfmonth
                                                           and _ehd.cnpj_emit = _act.stcd1
                                                           and _ehd.mod       = _act.model
                                                           and _ehd.nnf       = _act.nfnum9
                                                           and _act.cancel    is initial

    left outer join ZI_MM_AGRUPA_JFLIN          as _fli    on _act.docnum = _fli.docnum
    left outer join ZI_MM_FILTRO_REFKEY_GV      as _ref    on _fli.docnum = _ref.Docnum
  //                                                    and _fli.itmnum = _ref.Itmnum
  //    left outer join matdoc                 as _mat  on  _ref.MBLNR = _mat.mblnr
  //                                                    and _ref.MJAHR = _mat.mjahr
  //                                                    and ''         = _mat.sobkz

    left outer join ztmm_ret_arm_gv             as _ztm    on  _ztm.lifnr = _lif.Lifnr
                                                           and _ztm.werks = _wer.Werks
                                                           and _ztm.cfop  = _eit.Cfop
                                                           and _ztm.nnf   = _ehd.nnf
                                                           and _ztm.nfeid = _ehd.nfeid
                                                           and _ztm.demi  = _ehd.demi
                                                           and _ztm.nitem = _eit2.nitem

  association [0..1] to ZI_CA_VH_LIFNR           as _LIFNR   on _LIFNR.LifnrCode = $projection.LifnrCode
  association [0..1] to ZI_CA_VH_WERKS           as _WERKS   on _WERKS.WerksCode = $projection.WerksCode
  association [0..1] to ZI_CA_VH_MATERIAL        as _Matnr   on _Matnr.Material = $projection.MaterialAtribuido
  association [0..1] to ZI_MM_FILTRO_NNF_GV      as _NNF     on _NNF.nnf = $projection.Nnf
  //  association [0..1] to ZI_MM_FILTRO_STATUS_GV   as _STATUS  on _STATUS.Status = $projection.Status
  association [0..1] to ZI_MM_VH_ARMZGRV_PROCESS as _Process on _Process.Process = $projection.Processo

  //  association [0..1] to makt                   as _Makt   on  _Makt.matnr = $projection.Material
  //                                                          and _Makt.spras = $session.system_language
  //  association [0..1] to makt                   as _Makt2  on  _Makt2.matnr = $projection.MaterialAtribuido
  //                                                          and _Makt2.spras = $session.system_language
{
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
  key    _lif.Lifnr                          as LifnrCode,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
  key    _wer.Werks                          as WerksCode,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_CFOP_INS', element: 'Cfop1' } }]
  key    _eit.Cfop                           as Cfop,
         @EndUserText.label: 'NF-e'
         //@Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_FILTRO_NNF', element: 'Nnf' } }]
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_DOCNUM', element: 'DocNum' } }]
  key    _ehd.nnf                            as Nnf,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_ARMZ_XML_CFOP', element: 'ChaveAcesso' } }]
  key    _ehd.nfeid                          as XML,
  key    _ehd.demi                           as DataEmissao,
  key    _eit2.nitem                         as Nitem,
         case
         when _act.action_requ = 'C' and _act.cancel <> 'X'
         then _act.docnum
                     else  '0000000000' end  as DocNum,
         //          else  '0000000000' end as BR_NotaFiscal,
         //         case
         //         when _act.action_requ  = 'C' and _act.cancel <> 'X'
         //         then _act.credat
         //         else '00000000' end                                        as Credat,
         //         case
         //         when _act.action_requ  = 'C' and _act.cancel <> 'X'
         //         then _mat.matnr
         //         else 'N/A' end                      as Material,
         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
         _ztm.materialatribuido              as MaterialAtribuido,
         _ztm.processo                       as Processo,
         //         case
         //         when _act.action_requ  = 'C' and _act.cancel <> 'X'
         //         then _mat.mblnr
         //         else '00000000' end                 as DocMaterial,
         //         _mat.mblnr                                                 as DocMaterial,
         //                  case when _ztm.processo <> '' then _mat.charg  else '' end as Lote,
         //         case when _ztm.processo = '1' then _mat.matnr else '' end  as MatRemessa,
         //                  case when _ztm.processo = '2' then _mat.matnr else '' end  as MatRetorno,
         //         @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_FILTRO_STATUS', element: 'Descricao' } }]
         //         case
         //         when _act.action_requ = 'C' and _act.cancel <> 'X'
         //         then 'Concluído'
         //         else 'Pendente' end                 as Status,
         //
         //         case
         //         when _act.action_requ = 'C' and _act.cancel <> 'X'
         //         then 3
         //         else 1 end                          as StatusCriticality,

         //         _LIFNR.LifnrCodeName,
         //         _eit2.xprod                         as Xprod,
         _eit2.qcom                          as Qcom,
         _eit2.ucom                          as Ucom,
         cast(_eit2.vprod as abap.dec(13,2)) as Vprod,
         _eit2.cprod                         as Cprod,
         _ehd.serie                          as Serie,
         _act.action_requ,


         _LIFNR,
         _WERKS,
         //_Matnr.Material,
         _Matnr.Text                         as MaterialText,

         _NNF,
         //         _STATUS,
         _Process
         //         _Makt,
         //         _Makt2


}
