@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro Fiscal - cabeçalho'
define root view entity ZI_MM_CADASTRO_FISCAL_CABEC
  as select from ztmm_monit_cabec as Header

  composition [0..*] of ZI_MM_CADASTRO_FISCAL_ITEM    as _Item
  composition [0..*] of ZI_MM_CADASTRO_FISCAL_ANEXO   as _Anexo

  //    association        to j_1bnfdoc                          as _NFDoc         on $projection.NrNf = _NFDoc.nfnum

  association        to ekko                                 as _Ekko on  $projection.Pedido = _Ekko.ebeln
  association        to ZI_MM_CADASTRO_FISCAL_IMOB           as _Imob on  $projection.Pedido = _Imob.PurchaseOrder

  association [0..1] to t001                          as _T001        on  _T001.bukrs = $projection.Empresa
  association [0..1] to ZI_CA_VH_LIFNR                as _Lfa1        on  _Lfa1.LifnrCode = $projection.Lifnr
  association [0..1] to ZI_CA_VH_USER                 as _User        on  _User.Bname = $projection.Uname
  association [0..1] to ZI_CA_VH_USER                 as _UserCanc    on  _UserCanc.Bname = $projection.CancelUser
  association [0..1] to ZI_MM_CADASTRO_FISCAL_ANEXO_A as _AnexoCount  on  _AnexoCount.NrNf    = $projection.NrNf
                                                                      and _AnexoCount.CnpjCpf = $projection.CnpjCpf

{
  key Header.empresa                                                                    as Empresa,
  key Header.filial                                                                     as Filial,
  key Header.lifnr                                                                      as Lifnr,
  key Header.nr_nf                                                                      as NrNf,

      @EndUserText.label: 'Status'
      case
        when Header.erro     is not initial then 'Erro'
        when Header.belnr    is not initial and Header.job is not initial then 'Lançada'
        when Header.belnr    is not initial then 'Concluído'
        when Header.liberado is not initial and Header.step_validacao is not initial then 'Em Validação'
        when Header.liberado is not initial then 'Liberada'
        else 'Pendente'
      end                                                                               as StatusFiscal,

      case
        when Header.erro     is not initial then 1
        when Header.belnr    is not initial then 3
        when Header.liberado is not initial then 2
        else 1
      end                                                                               as StFiscCritic,

      Header.pedido                                                                     as Pedido,
      Header.cnpj_cpf                                                                   as CnpjCpf,
      Header.dt_emis                                                                    as DtEmis,
      Header.dt_lancto                                                                  as DtLancto,
      Header.dt_venc                                                                    as DtVenc,
      Header.dt_reg                                                                     as DtReg,
      Header.hr_reg                                                                     as HrReg,
      Header.lblni                                                                      as Lblni,
      Header.erro                                                                       as FlagErro,
      Header.txjcd                                                                      as DomicilioFiscal,
      Header.nbm                                                                        as Lc,
      Header.rpa                                                                        as FlagRpa,
      case
        when _AnexoCount.TotalAnexo > 0
        then 'X' else ''
      end                                                                               as FlagHasAnexo,
      @Semantics.amount.currencyCode : 'Currency'
      Header.vl_frete                                                                   as VlFrete,
      @Semantics.amount.currencyCode : 'Currency'
      Header.vl_desc                                                                    as VlDesc,
      @Semantics.amount.currencyCode : 'Currency'
      Header.vl_tot_nf                                                                  as VlTotNf,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. ISS'
      Header.vl_iss                                                                     as VlIss,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. PIS'
      Header.vl_pis                                                                     as VlPis,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. COFINS'
      Header.vl_cofins                                                                  as VlCofins,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. CSLL'
      Header.vl_csll                                                                    as VlCsll,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. IR'
      Header.vl_ir                                                                      as VlIr,
      @Semantics.amount.currencyCode : 'Currency'
      @EndUserText.label: 'Vlr. INSS'
      Header.vl_inss                                                                    as VlInss,

      cast(Header.vl_iss as abap.dec(15,2)) +
      cast(Header.vl_inss as abap.dec(15,2)) +
      cast(Header.vl_cofins as abap.dec(15,2)) +
      cast(Header.vl_csll as abap.dec(15,2)) +
      cast(Header.vl_pis as abap.dec(15,2)) +
      cast(Header.vl_ir as abap.dec(15,2))                                              as VlTotImpostos,
      concat(Header.empresa, concat(Header.filial, concat(Header.lifnr, Header.nr_nf))) as LogExternalID,

      //      Header.cond_pag                                                                   as CondPag,
      Header.incoterms                                                                  as Incoterms,
      Header.uname                                                                      as Uname,
      Header.atrib                                                                      as Atrib,
      Header.cancel                                                                     as Cancel,
      Header.cancel_user                                                                as CancelUser,
      Header.belnr                                                                      as Miro,
      Header.dt_venc2                                                                   as DtVenc2,
      Header.dt_venc3                                                                   as DtVenc3,
      Header.dt_venc4                                                                   as DtVenc4,
      Header.dt_venc5                                                                   as DtVenc5,
      Header.dt_base                                                                    as DtBase,
      Header.dt_recusa                                                                  as DtRecusa,
      Header.liberado                                                                   as Liberado,
      @Semantics.user.createdBy: true
      Header.created_by                                                                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Header.created_at                                                                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Header.last_changed_by                                                            as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Header.last_changed_at                                                            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Header.local_last_changed_at                                                      as LocalLastChangedAt,
      _Ekko.waers                                                                       as Currency,
      _Ekko.zterm                                                                       as CondPag,
      case
      when _Imob.PurchaseOrder is not null
      then 'Sim' else 'Não'
      end                                                                               as Imob,


      /* Associations */
      _Item,
      _Anexo,
      _T001,
      _Lfa1,
      _User,
      _UserCanc,
      _Ekko,
      _Imob

}
