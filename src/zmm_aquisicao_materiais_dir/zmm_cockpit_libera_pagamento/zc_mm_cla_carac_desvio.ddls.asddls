@AbapCatalog.sqlViewName: 'ZVCMMCLACARACDES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedido de Compra, Lotes e Romaneio'
define view ZC_MM_CLA_CARAC_DESVIO
  as select from ZC_MM_CLA_CARAC_1 as _Carac1
    inner join   ZC_MM_CLA_CARAC_1 as _Carac2 on  _Carac1.PurchaseOrder     = _Carac2.PurchaseOrder
                                              and _Carac1.PurchaseOrderItem = _Carac2.PurchaseOrderItem
{
  key _Carac1.PurchaseOrder,
  key _Carac1.PurchaseOrderItem,
  key _Carac1.Charg,
  key _Carac1.ViewType,
      _Carac1.SalesDocument,
      _Carac1.SalesDocumentItem,

      _Carac1.QuantidadeKg     / _Carac2.QuantidadeKg    as DesvioQuantidadeKg,
      _Carac1.QuantidadeSacas  / _Carac2.QuantidadeSacas as DesvioQuantidadeSacas,
      _Carac1.QuantidadeBag    / _Carac2.QuantidadeBag   as DesvioQuantidadeBag,
      _Carac1.Peneira10        / _Carac2.Peneira10       as DesvioPeneira10,
      _Carac1.Peneira11        / _Carac2.Peneira11       as DesvioPeneira11,
      _Carac1.Peneira12        / _Carac2.Peneira12       as DesvioPeneira12,
      _Carac1.Peneira13        / _Carac2.Peneira13       as DesvioPeneira13,
      _Carac1.Peneira14        / _Carac2.Peneira14       as DesvioPeneira14,
      _Carac1.Peneira15        / _Carac2.Peneira15       as DesvioPeneira15,
      _Carac1.Peneira16        / _Carac2.Peneira16       as DesvioPeneira16,
      _Carac1.Peneira17        / _Carac2.Peneira17       as DesvioPeneira17,
      _Carac1.Peneira18        / _Carac2.Peneira18       as DesvioPeneira18,
      _Carac1.Peneira19        / _Carac2.Peneira19       as DesvioPeneira19,
      _Carac1.Mk10             / _Carac2.Mk10            as DesvioMk10,
      _Carac1.Fundo            / _Carac2.Fundo           as DesvioFundo,
      _Carac1.Catacao          / _Carac2.Catacao         as DesvioCatacao,
      _Carac1.Umidade          / _Carac2.Umidade         as DesvioUmidade,
      _Carac1.Defeito          / _Carac2.Defeito         as DesvioDefeito,
      _Carac1.Impureza         / _Carac2.Impureza        as DesvioImpureza,
      _Carac1.Verde            / _Carac2.Verde           as DesvioVerde,
      _Carac1.PretoArdido      / _Carac2.PretoArdido     as DesvioPretoArdido,
      _Carac1.Brocado          / _Carac2.Brocado         as DesvioBrocado,
      _Carac1.Densidade        / _Carac2.Densidade       as DesvioDensidade,
      _Carac1.Observacao

      //  key Ebeln as PurchaseOrder,
      //  key Ebelp as PurchaseOrderItem,
      //  key Charg,
      //  key '3' as ViewType,
      //      Vbeln as SalesDocument,
      //      Posnr as SalesDocumentItem,
      //
      //      case when _Batch.Characteristic = 'YGV_QTD_KG'
      //           then ( _Batch.CharacteristicValue )
      //           else 0
      //      end as QuantidadeKg,
      //
      //      case when _Batch.Characteristic = 'YGV_QTD_SACAS'
      //           then ( _Batch.CharacteristicValue )
      //           else 0
      //      end as QuantidadeSacas,
      //
      //      case when _Batch.Characteristic = 'YGV_QTD_BAG'
      //           then ( _Batch.CharacteristicValue )
      //           else 0
      //      end as QuantidadeBag,
      //
      //      case when _Batch.Characteristic = 'YGV_MK10'
      //           then ( Mk10 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Mk10,
      //
      //      case when _Batch.Characteristic = 'YGV_P10'
      //           then ( Peneira10 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira10,
      //
      //      case when _Batch.Characteristic = 'YGV_P11'
      //           then ( Peneira11 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira11,
      //
      //      case when _Batch.Characteristic = 'YGV_P12'
      //           then ( Peneira12 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira12,
      //
      //      case when _Batch.Characteristic = 'YGV_P13'
      //           then ( Peneira13 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira13,
      //
      //      case when _Batch.Characteristic = 'YGV_P14'
      //           then ( Peneira14 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira14,
      //
      //      case when _Batch.Characteristic = 'YGV_P15'
      //           then ( Peneira15 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira15,
      //
      //      case when _Batch.Characteristic = 'YGV_P16'
      //           then ( Peneira16 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira16,
      //
      //      case when _Batch.Characteristic = 'YGV_P17'
      //           then ( Peneira17 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira17,
      //
      //      case when _Batch.Characteristic = 'YGV_P18'
      //           then ( Peneira18 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira18,
      //
      //      case when _Batch.Characteristic = 'YGV_P19'
      //           then ( Peneira19 / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Peneira19,
      //
      //      case when _Batch.Characteristic = 'YGV_FUNDO'
      //           then ( Fundo / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Fundo,
      //
      //      case when _Batch.Characteristic = 'YGV_CATACAO'
      //           then ( Catacao / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Catacao,
      //
      //      case when _Batch.Characteristic = 'YGV_UMIDADE'
      //           then ( Umidade / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Umidade,
      //
      //      case when _Batch.Characteristic = 'YGV_DEFEITO'
      //           then ( Defeito / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Defeito,
      //
      //      case when _Batch.Characteristic = 'YGV_IMPUREZA'
      //           then ( Impureza / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Impureza,
      //
      //      case when _Batch.Characteristic = 'YGV_VERDE'
      //           then ( Verde / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Verde,
      //
      //      case when _Batch.Characteristic = 'YGV_PRETO-ARDIDO'
      //           then ( PretoArdido / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as PretoArdido,
      //
      //      case when _Batch.Characteristic = 'YGV_BROCADOS'
      //           then ( Brocado / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Brocado,
      //
      //      case when _Batch.Characteristic = 'YGV_DENSIDADE'
      //           then ( Densidade / coalesce( _Batch.CharacteristicValue, 1 ) )
      //           else 0
      //      end as Densidade,
      //
      //      Observacao
}
