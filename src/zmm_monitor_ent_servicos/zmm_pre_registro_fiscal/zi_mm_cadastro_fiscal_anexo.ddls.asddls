@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro Fiscal - item'
define view entity ZI_MM_CADASTRO_FISCAL_ANEXO
  as select from ztmm_monit_cabec as Header

    inner join   ztmm_anexo_nf    as Anexo on  Anexo.nr_nf    = Header.nr_nf
                                           and Anexo.cnpj_cpf = Header.cnpj_cpf

  association to parent ZI_MM_CADASTRO_FISCAL_CABEC as _Header on  _Header.Empresa = $projection.Empresa
                                                               and _Header.Filial  = $projection.FilialHeader
                                                               and _Header.Lifnr   = $projection.Lifnr
//                                                               and _Header.NrNf    = $projection.NrNf
                                                               and _Header.NrNf    = $projection.NrNf


{
  key Header.empresa              as Empresa,
  key Header.filial               as FilialHeader,
  key Header.lifnr                as Lifnr,
//  key Anexo.nr_nf                 as NrNf,
  key Anexo.nr_nf                 as NrNf,
  key Anexo.cnpj_cpf              as CnpjCpf,
  key Anexo.linha                 as Linha,
//      Anexo.nr_nf                 as NrNf2,
      Anexo.filename              as Filename,
      Anexo.mimetype              as Mimetype,
      Anexo.conteudo              as Conteudo,
      Anexo.created_by            as CreatedBy,
      Anexo.created_at            as CreatedAt,
      Anexo.last_changed_by       as LastChangedBy,
      Anexo.last_changed_at       as LastChangedAt,
      Anexo.local_last_changed_at as LocalLastChangedAt,

      _Header
}
