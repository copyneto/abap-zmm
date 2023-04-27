@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Simulação Fatura Monitor de Serviço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MONIT_SERV_SIMULA
  as select from ztmm_monit_simul as Simula

  association to parent ZI_MM_MONIT_SERV_HEADER as _Header on  _Header.Empresa = $projection.Empresa
                                                           and _Header.Filial  = $projection.Filial
                                                           and _Header.Lifnr   = $projection.Lifnr
                                                           and _Header.NrNf    = $projection.NrNf
{
  key Simula.empresa               as Empresa,
  key Simula.filial                as Filial,
  key Simula.lifnr                 as Lifnr,
  key Simula.nr_nf                 as NrNf,
  key Simula.linha                 as Linha,
      Simula.hkont                 as Hkont,
      Simula.bschl                 as Bschl,
      Simula.shkzg                 as Shkzg,
      Simula.waers                 as Waers,
      @Semantics.amount.currencyCode: 'waers'
      Simula.dmbtr                 as Dmbtr,
      Simula.ebeln                 as Ebeln,
      Simula.ebelp                 as Ebelp,
      Simula.mwskz                 as Mwskz,
      Simula.qsskz                 as Qsskz,
      Simula.ktext                 as Ktext,
      Simula.created_by            as CreatedBy,
      Simula.created_at            as CreatedAt,
      Simula.last_changed_by       as LastChangedBy,
      Simula.last_changed_at       as LastChangedAt,
      Simula.local_last_changed_at as LocalLastChangedAt,

      _Header
}
