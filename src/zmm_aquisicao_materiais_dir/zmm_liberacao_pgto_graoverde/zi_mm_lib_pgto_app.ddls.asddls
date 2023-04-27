@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Principal do APP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_LIB_PGTO_APP
  as select from ZI_MM_LIB_PGTO_CAB as _cab

  composition [0..*] of ZI_MM_LIB_PGTO_FAT         as _fat
  composition [0..*] of ZI_MM_LIB_PGTO_ADI         as _adi
  composition [0..*] of ZI_MM_LIB_PGTO_DEV         as _dev
  composition [0..*] of ZI_MM_LIB_PGTO_DES         as _des
  composition [0..*] of ZI_MM_LIB_PGTO_DES_FIN_COM as _desComFin

  association [0..1] to ZI_MM_LIB_PGTO_TOT         as _tot on  _tot.Empresa      = $projection.Empresa
                                                           and _tot.Ano          = $projection.Ano
                                                           and _tot.NumDocumento = $projection.NumDocumento



{
      @ObjectModel.text.element: ['NomeEmpresa']
  key _cab.Empresa,
  key _cab.Ano,
  key _cab.NumDocumento,
      //_cab.Ano,
      _cab.NomeEmpresa,
      @ObjectModel.text.element: ['NomeFornecedor']
      _cab.Fornecedor,
      _cab.NomeFornecedor,
      @ObjectModel.text.element: ['DescricaoStatus']
      _cab.Status,
      _cab.DescricaoStatus,


      _cab.PedidoCriadoEm,
      _cab.PedidoCriadoPor,
      _cab.CreatedBy,
      _cab.CreatedAt,
      _cab.LastChangedBy,
      _cab.LastChangedAt,
      _cab.LocalLastChangedAt,

      cast( '00000000' as dzfbdt )     as VctoResidual,

      @Semantics.amount.currencyCode : 'MoedaFat'
      @EndUserText.label: 'Montante'
      cast( 0 as kbetr)                as vlr_desconto_fin,
      
      cast( '' as abap.sstring(1024) ) as observacao_fin,

      _tot.MoedaFat,
      @Semantics.amount.currencyCode: 'MoedaFat'
      _tot.VlMontanteFatura,

      _tot.MoedaAdi,
      @Semantics.amount.currencyCode: 'MoedaAdi'
      _tot.VlMontanteAdiantamento,

      _tot.MoedaDev,
      @Semantics.amount.currencyCode: 'MoedaDev'
      _tot.VlMontanteDevolucao,

      _tot.MoedaDesFin,
      @Semantics.amount.currencyCode: 'MoedaDesFin'
      _tot.VlMontanteDescontoFinanceiro,

      _tot.MoedaDesCom,
      @Semantics.amount.currencyCode: 'MoedaDesCom'
      _tot.VlMontanteDescontoComercial,

      _tot.MoedaTot,
      @Semantics.amount.currencyCode: 'MoedaTot'
      cast(_tot.VlTotal as abap.dec( 23, 2 )) as VlTotal, 


      /* Associations */
      _fat,
      _adi,
      _dev,
      _des,
      _desComFin

}
