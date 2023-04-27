@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Administrar Corretagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ADM_CORRETAGEM
  as select from ZI_MM_REMOVE_NFTYPE_PARAM as control_cla
{
  key DocumentoCompra,
  key Docnum,
      Periodo,
      Centro,
      DataEntrada,
      DtEntradaNF,
      Corretora,
      Corretor,
      DocNF,
      NrNF,
      SalesDocumentCurrency,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      ValorTotLiq,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      QuantityInBaseUnit,
      PercCorretagem,
      ValorCorretagem,
      Embarcador,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      PrecoUnitEmb,
      ValorEmbarcador,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      ValorDesconto,
      ValorDevCorretagem,
      ValorAPagar,
      NrContrato,
      Fornecedor,
      Observacao,
      StatusApuracao,
      StatusApurCrityc,
      DocCompensacao,
      DataCompensacao,
      StatusCompensacao,
      StatusCompCrityc,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      NomeModificador,
      LastChangedAt,
      LocalLastChangedAt,
      BR_NFType,
      /* Associations */
      _ChangedByUser,
      _CreatedByUser,
      _FornCorre,
      _FornCorretor,
      _FornEmbar,
      _NFItem,
      _StatusApur,
      _StatusComp
}
where
  BR_NFType = 'VAZIO'
group by
  DocumentoCompra,
  Docnum,
  Periodo,
  Centro,
  DataEntrada,
  DtEntradaNF,
  Corretora,
  Corretor,
  DocNF,
  NrNF,
  SalesDocumentCurrency,
  ValorTotLiq,
  BaseUnit,
  QuantityInBaseUnit,
  PercCorretagem,
  ValorCorretagem,
  Embarcador,
  PrecoUnitEmb,
  ValorEmbarcador,
  ValorDesconto,
  ValorDevCorretagem,
  ValorAPagar,
  NrContrato,
  Fornecedor,
  Observacao,
  StatusApuracao,
  StatusApurCrityc,
  DocCompensacao,
  DataCompensacao,
  StatusCompensacao,
  StatusCompCrityc,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  NomeModificador,
  LastChangedAt,
  LocalLastChangedAt,
  BR_NFType
