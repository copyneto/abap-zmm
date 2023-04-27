@AbapCatalog.sqlViewName: 'ZVCMMCLACARAC2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Compra, Lotes e Romaneio'
define view ZC_MM_CLA_CARAC_2
  as select from ZI_MM_CLA_CARAC          as _Carac
    inner join   ZC_MM_CLA_BATCH_ROMANEIO as _Batch on _Carac.Ebeln = _Batch.PurchaseOrder
    inner join   ZC_MM_ACCOUNT_DOCUMENT   as _Acc   on  _Carac.Ebeln = _Acc.PurchaseOrder
                                                    and _Carac.Ebeln = _Acc.PurchaseOrderItem
    inner join   ZC_MM_BR_NF_DOCUMENT     as _NFDoc on  _Carac.Ebeln = _NFDoc.PurchaseOrder
                                                    and _Carac.Ebeln = _NFDoc.PurchaseOrderItem
{
  key Ebeln                    as PurchaseOrder,
  key Ebelp                    as PurchaseOrderItem,
  key _Acc.ReferencedDocument,
  key _NFDoc.BR_NotaFiscal,
  key Charg,
  key '2'                      as ViewType,
      Vbeln                    as SalesDocument,
      Posnr                    as SalesDocumentItem,

      cast(
            case when _Batch.Characteristic = 'YGV_QTD_KG'
                 then  _Batch.CharacteristicValue
                 else 0
            end as abap.fltp ) as QuantidadeKg,

      cast(
            case when _Batch.Characteristic = 'YGV_QTD_SACAS'
                 then  _Batch.CharacteristicValue
                 else 0
            end as abap.fltp ) as QuantidadeSacas,

      cast(
            case when _Batch.Characteristic = 'YGV_QTD_BAG'
                 then  _Batch.CharacteristicValue
                 else 0
            end as abap.fltp ) as QuantidadeBag,

      cast(
            case when _Batch.Characteristic = 'YGV_MK10'
                 then  Mk10
                 else 0
            end as abap.fltp ) as Mk10,

      cast(
            case when _Batch.Characteristic = 'YGV_P10'
                 then  Peneira10
                 else 0
            end as abap.fltp ) as Peneira10,

      cast(
            case when _Batch.Characteristic = 'YGV_P11'
                 then  Peneira11
                 else 0
            end as abap.fltp ) as Peneira11,

      cast(
            case when _Batch.Characteristic = 'YGV_P12'
                 then  Peneira12
                 else 0
            end as abap.fltp ) as Peneira12,

      cast(
            case when _Batch.Characteristic = 'YGV_P13'
                 then  Peneira13
                 else 0
            end as abap.fltp ) as Peneira13,

      cast(
            case when _Batch.Characteristic = 'YGV_P14'
                 then  Peneira14
                 else 0
            end as abap.fltp ) as Peneira14,

      cast(
            case when _Batch.Characteristic = 'YGV_P15'
                 then  Peneira15
                 else 0
            end as abap.fltp ) as Peneira15,

      cast(
            case when _Batch.Characteristic = 'YGV_P16'
                 then  Peneira16
                 else 0
            end as abap.fltp ) as Peneira16,

      cast(
            case when _Batch.Characteristic = 'YGV_P17'
                 then  Peneira17
                 else 0
            end as abap.fltp ) as Peneira17,

      cast(
            case when _Batch.Characteristic = 'YGV_P18'
                 then  Peneira18
                 else 0
            end as abap.fltp ) as Peneira18,

      cast(
            case when _Batch.Characteristic = 'YGV_P19'
                 then  Peneira19
                 else 0
            end as abap.fltp ) as Peneira19,

      cast(
            case when _Batch.Characteristic = 'YGV_FUNDO'
                 then  Fundo
                 else 0
            end as abap.fltp ) as Fundo,

      cast(
            case when _Batch.Characteristic = 'YGV_CATACAO'
                 then  Catacao
                 else 0
            end as abap.fltp ) as Catacao,

      cast(
            case when _Batch.Characteristic = 'YGV_UMIDADE'
                 then  Umidade
                 else 0
            end as abap.fltp ) as Umidade,

      cast(
            case when _Batch.Characteristic = 'YGV_DEFEITO'
                 then  Defeito
                 else 0
            end as abap.fltp ) as Defeito,

      cast(
            case when _Batch.Characteristic = 'YGV_IMPUREZA'
                 then  Impureza
                 else 0
            end as abap.fltp ) as Impureza,

      cast(
            case when _Batch.Characteristic = 'YGV_VERDE'
                 then  Verde
                 else 0
            end as abap.fltp ) as Verde,

      cast(
            case when _Batch.Characteristic = 'YGV_PRETO-ARDIDO'
                 then  PretoArdido
                 else 0
            end as abap.fltp ) as PretoArdido,

      cast(
            case when _Batch.Characteristic = 'YGV_BROCADOS'
                 then  Brocado
                 else 0
            end as abap.fltp ) as Brocado,

      cast(
            case when _Batch.Characteristic = 'YGV_DENSIDADE'
                 then  Densidade
                 else 0
            end as abap.fltp ) as Densidade,

      Observacao
}
