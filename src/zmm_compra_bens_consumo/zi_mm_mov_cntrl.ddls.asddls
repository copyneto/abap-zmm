@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DD - Registro de movimentações'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_MOV_CNTRL
  as select from ztmm_mov_cntrl

  composition [0..*] of ZI_MM_MAT_CNTRL    as _MatCntrl
  association [0..1] to ZI_MM_MOV_SIMUL    as _Simul     on  _Simul.Id = $projection.Id
  association [0..1] to ZI_MM_MOV_MATERIAL as _Material  on  _Material.Material = $projection.Matnr1
                                                         and _Material.Centro   = $projection.Werks
                                                         and _Material.Deposito = $projection.Lgort
  association [0..1] to I_BR_NFDocument    as _NFSaida   on  _NFSaida.BR_NotaFiscal = $projection.DocnumS
  association [0..1] to I_BR_NFDocument    as _NFEntrada on  _NFEntrada.BR_NotaFiscal = $projection.DocnumEnt
  association [0..1] to ZI_MM_NF_STATUS    as _URL       on  _URL.Id = $projection.Id
  association [0..1] to dd07t              as _Domain    on  _Domain.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain.ddlanguage = $session.system_language
                                                         and _Domain.domvalue_l = $projection.StatusGeral
  association [0..1] to dd07t              as _Domain1   on  _Domain1.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain1.ddlanguage = $session.system_language
                                                         and _Domain1.domvalue_l = $projection.Status1
  association [0..1] to dd07t              as _Domain2   on  _Domain2.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain2.ddlanguage = $session.system_language
                                                         and _Domain2.domvalue_l = $projection.Status2
  association [0..1] to dd07t              as _Domain3   on  _Domain3.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain3.ddlanguage = $session.system_language
                                                         and _Domain3.domvalue_l = $projection.Status3
  association [0..1] to dd07t              as _Domain4   on  _Domain4.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain4.ddlanguage = $session.system_language
                                                         and _Domain4.domvalue_l = $projection.Status4
  association [0..1] to dd07t              as _Domain5   on  _Domain5.domname    = 'ZD_STATUS_GERAL_IMOB'
                                                         and _Domain5.ddlanguage = $session.system_language
                                                         and _Domain5.domvalue_l = $projection.Status5
  association [0..1] to ztca_param_val     as _Param     on  _Param.modulo = 'MM'
                                                         and _Param.chave1 = 'MONITOR_IMOBILIZACAO'
                                                         and _Param.chave2 = 'DEPOSITO'
                                                         and _Param.chave3 = ''

{
  key id                         as Id,
      bukrs                      as Bukrs,
      branch                     as Branch,
      mblnr_sai                  as MblnrSai,
      mjahr                      as Mjahr,
      mblpo                      as Mblpo,
      //status_geral          as StatusGeral,
      case mblnr_ent
        when '' then 'P'
            else
                case mblnr_est_ent
                    when '' then 'C'
                    else 'E'
                end
      end                        as StatusGeral,
      case mblnr_ent
        when '' then 0
            else
                case mblnr_est_ent
                    when '' then 3
                    else 2
                end
      end                        as StatusGeralCrit,
      //status1               as Status1,
      //      case mblnr_sai
      //        when '' then 'P'
      //            else
      //                case mblnr_est
      //                    when '' then 'C'
      //                    else 'D'
      //                end
      //      end                        as Status1,
      case
        when mblnr_est <> '' then 'E'
            else
                case
                    when mblnr_sai <> '' then 'C'
                    else 'P'
                end
      end                        as Status1,
      //      case mblnr_sai
      //        when '' then 0
      //            else
      //                case mblnr_est
      //                    when '' then 3
      //                    else 2
      //                end
      //      end                        as Status1Crit,
      case
        when mblnr_est <> '' then 2
            else
                case
                    when mblnr_sai <> '' then 3
                    else 0
                end
      end                        as Status1Crit,
      mblnr_est                  as MblnrEst,
      mjahr_est                  as MjahrEst,
      docnum_s                   as DocnumS,
      //status2               as Status2,
      //      case docnum_s
      //        when '0000000000' then 'P'
      //            else
      //                case docnum_est_sai
      //                    when '0000000000' then 'C'
      //                    else 'E'
      //                end
      //      end                        as Status2, // Status NF Saída
      case
        when docnum_est_sai <> '0000000000' then 'E'
            else
                case
                    when docnum_s <> '0000000000' then 'C'
                    else 'P'
                end
      end                        as Status2, // Status NF Saída
      //      case docnum_s
      //        when '0000000000' then 0
      //            else
      //                case docnum_est_sai
      //                    when '0000000000' then 3
      //                    else 2
      //                end
      //      end                        as Status2Crit,
      case
        when docnum_est_sai <> '0000000000' then 2
            else
                case
                    when docnum_s <> '0000000000' then 3
                    else 0
                end
      end                        as Status2Crit, // Status NF Saída
      belnr                      as Belnr,
      bukrs_dc                   as BukrsDc,
      gjahr_dc                   as GjahrDc,
      //status3               as Status3,
      //      case belnr
      //        when '' then 'P'
      //            else
      //                case belnr_est
      //                    when '' then 'C'
      //                    else 'E'
      //                end
      //      end                        as Status3,
      case
        when belnr_est <> '' then 'E'
            else
                case
                    when belnr <> '' then 'C'
                    else 'P'
                end
      end                        as Status3,
      //      case belnr
      //        when '' then 0
      //            else
      //                case belnr_est
      //                    when '' then 3
      //                    else 2
      //                end
      //      end                        as Status3Crit,
      case
        when belnr_est <> '' then 2
            else
                case
                    when belnr <> '' then 3
                    else 0
                end
      end                        as Status3Crit,
      mblnr_ent                  as MblnrEnt,
      mjahr_ent                  as MjahrEnt,
      mblpo_ent                  as MblpoEnt,
      //status4               as Status4,
      case
        when docnum_est_ent <> '0000000000'
         and docnum_ent     =  '0000000000' then 'E'
            else
                case
                    when docnum_ent <> '0000000000' then 'C'
                    else 'P'
                end
      end                        as Status4, // Status NFe Entrada
      //      case docnum_ent
      //        when '0000000000' then 'P'
      //            else
      //                case docnum_est_ent
      //                    when '0000000000' then 'C'
      //                    else 'E'
      //                end
      //      end                        as Status4,
      //      case docnum_ent
      //        when '0000000000' then 0
      //            else
      //                case docnum_est_ent
      //                    when '0000000000' then 3
      //                    else 2
      //                end
      //      end                        as Status4Crit,
      case
        when docnum_est_ent <> '0000000000'
         and docnum_ent     =  '0000000000' then 2
            else
                case
                    when docnum_ent <> '0000000000' then 3
                    else 0
                end
      end                        as Status4Crit,
      mblnr_est_ent              as MblnrEstEnt,
      mjahr_est_ent              as MjahrEstEnt,
      bldat                      as Bldat,
      docnum_ent                 as DocnumEnt,
      docdat                     as Docdat,
      //status5               as Status5,
      case mblnr_ent
        when '' then 'P'
            else
                case mblnr_est_ent
                    when '' then 'C'
                    else 'E'
                end
      end                        as Status5,
      case mblnr_ent
        when '' then 0
            else
                case mblnr_est_ent
                    when '' then 3
                    else 2
                end
      end                        as Status5Crit,
      docnum_est_ent             as DocnumEstEnt,
      docnum_est_sai             as DocnumEstSai,
      belnr_est                  as BelnrEst,
      gjahr_est                  as GjahrEst,
      bldat_est                  as BldatEst,
      etapa                      as Etapa,
      matnr1                     as Matnr1,
      matnr                      as Matnr,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      menge                      as Menge,
      meins                      as Meins,
      werks                      as Werks,
      lgort                      as Lgort,
      //cast(posid as numc08 preserving type) as Posid,
      posid                      as Posid,
      anln1                      as Anln1,
      anln2                      as Anln2,
      invnr                      as Invnr,
      partner                    as Partner,
      @Semantics.user.createdBy: true
      created_by                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by            as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at      as LocalLastChangedAt,
      cast( '' as abap.char(1) ) as HiddenEntrada,
      case matnr
        when '' then 'X'
        else ''
      end                        as HiddenPEP,
      case etapa
        when 0  then 'X'
        when 1  then ''
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenGoodsSaida,
      case etapa
        when 0  then 'X'
        when 1  then 'X'
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenSimulacao,
      case matnr
        when '' then 'X'
        else ''
      end                        as HiddenImobilizado,
      case etapa
        when 0  then 'X'
        when 1  then ''
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenNFSaida,
      case etapa
        when 0  then 'X'
        when 1  then ''
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenPosting,
      case etapa
        when 0  then 'X'
        when 1  then ''
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenNFEntrada,
      case etapa
        when 0  then 'X'
        when 1  then ''
        when 2  then ''
        when 3  then ''
        when 4  then ''
        when 5  then ''
        when 6  then ''
        else 'X'
      end                        as HiddenGoodsEntrada,

      //_MatCntrl,
      _Simul,
      _Material,
      _NFSaida,
      _NFEntrada,
      _MatCntrl,
      _URL,
      _Domain,
      _Domain1,
      _Domain2,
      _Domain3,
      _Domain4,
      _Domain5,
      _Param
      //1   Botão Registrar - baixa
      //2   Botão Verificar
      //3   Botão Gerar NFe saída
      //4   Botão Contabilizar
      //5   Botão Gerar NFe entrada
      //6   Botão Gerar Mov.Mercadoria Entrada
      //7   Estorno Documento de material de entrada
      //8   Estorno da NFe de entrada
      //9   Estorno da contabilização
      //10  Estorno Documento de material saída
      //11  Estorno da NFe de saída

}
