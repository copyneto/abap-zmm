@EndUserText.label: 'Simulação Fatura Monitor de Serviço'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_MONIT_SERV_SIMULA
  as projection on ZI_MM_MONIT_SERV_SIMULA
{
      @EndUserText.label: 'Empresa'
  key Empresa,
      @EndUserText.label: 'Filial/centro'
  key Filial,
      @EndUserText.label: 'Fornecedor'
  key Lifnr,
      @EndUserText.label: 'N° da NF'
  key NrNf,
      @EndUserText.label: 'Linha'
  key Linha,
//      NrNf2,
      @EndUserText.label: 'Conta razão'
      Hkont,
      @EndUserText.label: 'Chave Lcto'
      Bschl,
      @EndUserText.label: 'Cód. débito/crédito'
      Shkzg,
      @EndUserText.label: 'Moeda'
      Waers,
      @EndUserText.label: 'Montante'
      Dmbtr,
      @EndUserText.label: 'Iva'
      Mwskz,
      @EndUserText.label: 'Texto'
      Ktext,
      @EndUserText.label: 'Cód. IRF'      
      Qsskz,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Header : redirected to parent ZC_MM_MONIT_SERV_HEADER
}
