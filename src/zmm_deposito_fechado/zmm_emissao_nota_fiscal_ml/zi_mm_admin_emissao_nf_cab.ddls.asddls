@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissão de Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MM_ADMIN_EMISSAO_NF_CAB
  as select from ztmm_his_dep_fec

  composition [0..*] of ZI_MM_ADMIN_EMISSAO_NF_ITM as _Item

  association [0..1] to ZI_MM_VH_DF_STATUS         as _Status on _Status.Status = $projection.Status


{
  key status             as Status,
      _Status.StatusText as StatusText,

      case status
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '99' then 2 -- Rascunho
                else 0
      end                as StatusCriticality,

      /* Compositions */
      _Item
}
where
      process_step = 'F02'
  and status       = '99' -- Rascunho
group by
  status,
  _Status.StatusText
