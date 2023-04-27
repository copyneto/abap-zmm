@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Anexo Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONIT_SERV_ANEXO
  as select from ztmm_monit_cabec as Header

    inner join   ztmm_anexo_nf    as Anexo on  Anexo.nr_nf    = Header.nr_nf
                                           and Anexo.cnpj_cpf = Header.cnpj_cpf

  association        to parent ZI_MM_MONIT_SERV_HEADER as _Header on  _Header.Empresa = $projection.Empresa
                                                                  and _Header.Filial  = $projection.FilialH
                                                                  and _Header.Lifnr   = $projection.Lifnr
                                                                  and _Header.NrNf    = $projection.NrNf

  association [0..1] to ZI_CA_VH_USER                  as _User1  on  _User1.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_USER                  as _User2  on  _User2.Bname = $projection.LastChangedBy

{
  key Header.empresa              as Empresa,
  key Header.filial               as FilialH,
  key Header.lifnr                as Lifnr,
  key Anexo.nr_nf                 as NrNf,
  key Anexo.cnpj_cpf              as CnpjCpf,
  key Anexo.linha                 as Linha,
      Anexo.filename              as Filename,
      Anexo.mimetype              as Mimetype,
      Anexo.conteudo              as Conteudo,
      Anexo.created_by            as CreatedBy,
      Anexo.created_at            as CreatedAt,
      Anexo.last_changed_by       as LastChangedBy,
      Anexo.last_changed_at       as LastChangedAt,
      Anexo.local_last_changed_at as LocalLastChangedAt,

      _Header,
      _User1,
      _User2
}
