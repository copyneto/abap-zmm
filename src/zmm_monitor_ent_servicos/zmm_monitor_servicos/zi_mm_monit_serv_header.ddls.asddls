@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Header Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_MONIT_SERV_HEADER
  as select from    ztmm_monit_cabec             as Header

    left outer join lfa1                         as Lfa1   on lfa1.lifnr = Header.lifnr
    left outer join ekko                         as Ekko   on ekko.ebeln = Header.pedido
    left outer join ZI_MM_MONIT_SERV_FILTRO_ITEM as Item1  on Item1.Ebeln = Header.pedido
    left outer join t001w                        as T001w  on t001w.werks = Item1.Werks

    left outer join t604n                                  on  t604n.spras = $session.system_language
                                                           and t604n.land1 = 'BR'
                                                           and t604n.steuc = Header.nbm

    left outer join j_1bnfdoc                    as _NfDoc on  _NfDoc.belnr =  Header.belnr
                                                           and _NfDoc.gjahr =  Header.gjahr
                                                           and Header.belnr <> ''

  composition [0..*] of ZI_MM_MONIT_SERV_ITEM   as _Item
  composition [0..*] of ZI_MM_MONIT_SERV_ANEXO  as _Anexo
  composition [0..*] of ZI_MM_MONIT_SERV_SIMULA as _Simula

  association [0..1] to ZI_CA_VH_BUKRS          as _Bukrs     on  _Bukrs.Empresa = '2000'

  association [0..1] to ZI_CA_VH_BRANCH         as _Branch    on  _Branch.CompanyCode   = $projection.Empresa
                                                              and _Branch.BusinessPlace = $projection.Filial

  association [0..1] to ZI_CA_VH_LIFNR          as _Lifnr     on  _Lifnr.LifnrCode = $projection.Lifnr
  association [0..1] to ZI_CA_VH_USER           as _User      on  _User.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_BUKRS          as _BukrsDest on  _BukrsDest.Empresa = $projection.EmpresDest


{
  key Header.empresa                                                                                  as Empresa,
  key Header.filial                                                                                   as Filial,
  key Header.lifnr                                                                                    as Lifnr,
  key Header.nr_nf                                                                                    as NrNf,
      Header.cnpj_cpf                                                                                 as CnpjCpf,
//      Header.nr_nf                                                                                    as NrNf2,
      lfa1.name1                                                                                      as RazSocial,
      Header.dt_emis                                                                                  as DtEmis,
      Header.dt_venc                                                                                  as DtVenc,
      Header.dt_reg                                                                                   as DtReg,
      Header.hr_reg                                                                                   as HrReg,
      Header.erro                                                                                     as FlagErro,
      cast(Header.vl_tot_nf as abap.dec( 15, 2 ))                                                     as VlTotNf,
      cast(Header.vl_iss as abap.dec(15,2)) +
      cast(Header.vl_inss as abap.dec(15,2)) +
      cast(Header.vl_cofins as abap.dec(15,2)) +
      cast(Header.vl_csll as abap.dec(15,2)) +
      cast(Header.vl_pis as abap.dec(15,2)) +
      cast(Header.vl_ir as abap.dec(15,2))                                                            as VlTotImpostos,
      Header.pedido                                                                                   as Pedido,
      Header.belnr                                                                                    as Miro,
      Header.gjahr                                                                                    as FiscalYear,
      Header.gjahr                                                                                    as MiroAno,
      Header.created_by                                                                               as Uname,
      Header.nbm                                                                                      as LC,
      _NfDoc.docnum                                                                                   as Docnum,
      _NfDoc.nftype                                                                                   as NFType,
      concat(t604n.text1, concat(t604n.text2, concat(t604n.text3, concat(t604n.text4, t604n.text5)))) as LCText,
      concat(Header.empresa, concat(Header.filial, concat(Header.lifnr, Header.nr_nf)))               as LogExternalID,
      // Aba de Dados do Emitente
      lfa1.ort01                                                                                      as MunicForn,
      lfa1.txjcd                                                                                      as MunicFornDomicilio,
      t001w.ort01                                                                                     as MunicRemes,
      t001w.txjcd                                                                                     as MunicRemesDomicilio,


      // Aba de Dados do Destinatário
      ekko.bukrs                                                                                      as EmpresDest,
      Header.dt_lancto                                                                                as DtLancto,

      // Aba de Dados Pagamento
      Header.dt_base                                                                                  as DtBase,
      Header.step_validacao                                                                           as Valid,

      case
        when Header.erro  is not initial and Header.belnr is not initial then 'Erro Estorno'
        when Header.erro  is not initial and Header.belnr is initial     then 'Erro Lançamento'
        when Header.belnr is not initial and Header.job   is not initial then 'Lançada'
        when Header.belnr is not initial                                 then 'Concluído'
        when Header.step_validacao is not initial                        then 'Em Validação'
        else 'Pendente'
        end                                                                                           as StatusFiscal,
      case
        when Header.erro  is not initial then 1
        when Header.belnr is not initial then 3
      else 2
      end                                                                                             as StFiscCritic,

      ''                                                                                              as SlaFinanc,
      case
      when dats_days_between($session.system_date, Header.dt_base) > 2
           then 3
      when dats_days_between($session.system_date, Header.dt_base) <= 2
       and dats_days_between($session.system_date, Header.dt_base) >= 0
           then 2
      else 1 end                                                                                      as SlaFinancCritc,

      ''                                                                                              as SlaFiscal,
      case
      when dats_days_between($session.system_date, Header.dt_venc) > 1
           then 3
      when dats_days_between($session.system_date, Header.dt_venc) <= 1
       and dats_days_between($session.system_date, Header.dt_venc) >= 0
           then 2
      else 1 end                                                                                      as SlaFiscalCritc,

      @Semantics.user.createdBy: true
      Header.created_by                                                                               as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Header.created_at                                                                               as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Header.last_changed_by                                                                          as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Header.last_changed_at                                                                          as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Header.local_last_changed_at                                                                    as LocalLastChangedAt,

      _Item,
      _Anexo,
      _Simula,
      _Bukrs,
      _Branch,
      _Lifnr,
      _User,
      _BukrsDest

}
where
  Header.liberado = 'X'
