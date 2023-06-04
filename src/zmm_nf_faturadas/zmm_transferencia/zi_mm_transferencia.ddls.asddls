@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface Transferência'
define root view entity ZI_MM_TRANSFERENCIA
  as select from ZI_MM_TRANSFERENCIA_DOC_DIAS
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
      DataRecebimento,
      DataRecebimento1,
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

      case when DataRecebimento is initial or DataRecebimento is null
           then dats_days_between( DataDocumento, $session.system_date )
           else dats_days_between( DataDocumento, DataRecebimento )
           end as Dias,

      BR_NFSourceDocumentNumber,
      PurchaseOrder,
      PurchaseOrderItem,
      ReversalGoodsMovementType
}
