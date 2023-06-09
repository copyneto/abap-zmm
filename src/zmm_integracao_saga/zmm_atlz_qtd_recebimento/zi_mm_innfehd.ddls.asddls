@AbapCatalog.sqlViewName: 'ZVMM_I_INNFEHD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF-e Inbound: Header Data'
define view ZI_MM_INNFEHD
  as select from /xnfe/innfehd
{
  key guid_header      as GuidHeader,
      nfeid            as Nfeid,
      type             as Type,
      finnfe           as Finnfe,
      version          as Version,
      intctr           as Intctr,
      baseproctyp      as Baseproctyp,
      proctyp          as Proctyp,
      logsys           as Logsys,
      actstat          as Actstat,
      infotext         as Infotext,
      not_code         as NotCode,
      notctr           as Notctr,
      createtime       as Createtime,
      statcod          as Statcod,
      nprot            as Nprot,
      digval           as Digval,
      dsaient          as Dsaient,
      conting          as Conting,
      tpemis           as Tpemis,
      tpamb            as Tpamb,
      cnpj_emit        as CnpjEmit,
      cpf_emit         as CpfEmit,
      cnpj_avulsa      as CnpjAvulsa,
      c_xnome          as CXnome,
      cnpj_dest        as CnpjDest,
      e_xnome          as EXnome,
      cfop             as Cfop,
      s1_vnf           as S1Vnf,
      s1_vicms         as S1Vicms,
      s1_vipi          as S1Vipi,
      s1_vpis          as S1Vpis,
      s1_vcofins       as S1Vcofins,
      t1_cnpj          as T1Cnpj,
      cuf              as Cuf,
      serie            as Serie,
      nnf              as Nnf,
      uf_emit          as UfEmit,
      uf_dest          as UfDest,
      mod              as Mod,
      demi             as Demi,
      natop            as Natop,
      waers            as Waers,
      dhcont           as Dhcont,
      xjust            as Xjust,
      arch             as Arch,
      last_step        as LastStep,
      last_step_status as LastStepStatus,
      log_workplace    as LogWorkplace,
      sitopprg         as Sitopprg,
      xmlversion       as Xmlversion,
      steptimestamp    as Steptimestamp,
      sitopprg_status  as SitopprgStatus,
      dtd_timestamp    as DtdTimestamp,
      dtf_timestamp    as DtfTimestamp,
      sitopprg_id_dest as SitopprgIdDest,
      dhemi            as Dhemi,
      dhrecbto         as Dhrecbto
}
