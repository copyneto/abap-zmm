@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro Fiscal - Total Anexos por NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CADASTRO_FISCAL_ANEXO_A
  as select from ZI_MM_CADASTRO_FISCAL_ANEXO
{
  key Empresa,
  key FilialHeader,
  key Lifnr,
  key NrNf,
  key CnpjCpf,
      count( distinct cast(Linha as abap.int8 ) ) as TotalAnexo
}
group by
  Empresa,
  FilialHeader,
  Lifnr,
  NrNf,
  CnpjCpf
