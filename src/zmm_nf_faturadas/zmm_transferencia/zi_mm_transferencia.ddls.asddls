@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface Transferência'
define root view entity ZI_MM_TRANSFERENCIA
  as select from ZI_MM_TRANSFERENCIA_DOCS
{

  key NumeroDocumento,
  key NumeroDocumentoItem,
      BR_NotaFiscal,
      Empresa,
      DataLancamento,
      LocalNegocioOrigem,
      LocalNegocioDestino,
      DocRefEntreda1,
      DocRefEntrada,
      max( DataRecebimento )  as DataRecebimento,
      max( DataRecebimento1 ) as DataRecebimento1,
      Status,
      CFOP,
      DataDocumento,
      DataDocumento1,
      Material,
      NumeroNf,
      DescricaoMaterial,
      Quantidade1,
      BaseUnit,
      Quantidade2,
      UnidadePeso,
      max( Dias )             as Dias,
      BR_NFSourceDocumentNumber,
      PurchaseOrder,
      PurchaseOrderItem,
      ReversalGoodsMovementType
}
where
  ReversalGoodsMovementType <> '864'
group by
  NumeroDocumento,
  NumeroDocumentoItem,
  BR_NotaFiscal,
  Empresa,
  DataLancamento,
  LocalNegocioOrigem,
  LocalNegocioDestino,
  DocRefEntreda1,
  DocRefEntrada,
  Status,
  CFOP,
  DataDocumento,
  DataDocumento1,
  Material,
  NumeroNf,
  DescricaoMaterial,
  Quantidade1,
  BaseUnit,
  Quantidade2,
  UnidadePeso,
  BR_NFSourceDocumentNumber,
  PurchaseOrder,
  PurchaseOrderItem,
  ReversalGoodsMovementType
