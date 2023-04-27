@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Ordem de Descarga'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_ADM_ORDEM_DESCARGA
  as select from ztmm_romaneio_in as _Romaneio
  composition [0..*] of ZI_MM_ADM_ORDEM_DESCARGA_ITEM as _OrdemItem
  association [0..1] to ZI_MM_VH_STATUS_ORDEM_ROMA    as _StatusOrdem  on _StatusOrdem.Valor = $projection.StatusOrdem
  association [0..1] to ZI_MM_VH_STATUS_ARMAZENADO    as _StatusArmaze on _StatusArmaze.Valor = $projection.StatusArmazenado
  association [0..1] to ZI_MM_VH_STATUS_COMPENSADO    as _StatusCompen on _StatusCompen.Valor = $projection.StatusCompensado

{
  key _Romaneio.doc_uuid_h            as DocUuidH,
      _Romaneio.sequence              as Romaneio,
      _Romaneio.ebeln                 as Pedido,
      _Romaneio.vbeln                 as Recebimento,
      //  _Romaneio.posnr               as ItemRecebimento,
      _Romaneio.ebelp                 as ItemPedido,
      //_Romaneio.nfnum               as NotaFiscal,
      //_ConfPedido.xblnr             as NotaFiscalPed,*/
      _Romaneio.placa                 as Placa,
      _Romaneio.motorista             as Motorista,

      _Romaneio.dt_entrada            as DtEntrada,
      _Romaneio.dt_chegada            as DtChegada,
      _Romaneio.nfnum                 as NotaFiscal,      
      //cast(_Romaneio.nfnum as xblnr_long ) as xblnr,      
      //      _Romaneio.charg                 as Lote,

      /*  @Semantics.quantity.unitOfMeasure:'Unidade'
        _Romaneio.qtd_kg_original     as QtdeKgOrig,
        _ConfPedido.matnr             as Material,
        _ConfPedido.maktx             as DescMaterial,

        _ConfPedido.meins             as Unidade,
        @Semantics.quantity.unitOfMeasure:'Unidade'
        _ConfPedido.ormng             as Quantidade,
      */

      //  case _Romaneio.status_ordem when '1' then 'Pendente'
      //                              when '2' then 'Em andamento'
      //                              when '3' then 'Finalizado'
      //                              when '4' then 'Cancelado'
      //                              else 'Não Criado'
      //                              end
      //                                as StatusOrdem,

      //  case _Romaneio.status_ordem when '1' then 1
      //                              when '2' then 2
      //                              when '3' then 3
      //                              when '4' then 0
      //                              else 0
      //                              end
      //                                as StatusOrdemCriti,

      case _Romaneio.status_armazenado when 'S' then 'Sim'
                                       else 'Não'
                                  end as StatusArmazenado,

      //      case _Romaneio.status_armazenado when 'S' then 'X'
      //                                       else ''
      //                                  end as StatusArmazenadoConv,
      _Romaneio.status_armazenado     as StatusArmazenadoConv,

      case _Romaneio.status_armazenado when 'S' then 3
                                  else 2
                                  end as StatusArmazenadoCriti,

      case _Romaneio.status_compensado when 'S' then 'Sim'
                                       else 'Não'
                                  end as StatusCompensado,

      case _Romaneio.status_compensado when 'S' then 'T'
                                       else 'N'
                                  end as StatusCompensadoConv,

      case _Romaneio.status_compensado when 'S' then 3
                                  else 2
                                  end as StatusCompensadoCriti,

      case _Romaneio.status_ordem  when '1' then 'Pendente'
                                   when '2' then 'Em andamento'
                                   when '3' then 'Finalizado'
                                  else 'Pendente'
                                  end as StatusOrdem,

      case _Romaneio.status_ordem  when 'S' then '3'
                                  else '1'
                                  end as StatusOrdemConv,

      case _Romaneio.status_ordem  when '1' then 0
                                   when '2' then 2
                                   when '3' then 3
                                   else 0
                                  end as StatusOrdemCriti,

      @Semantics.systemDateTime.createdAt: true
      _Romaneio.created_at            as CreatedAt,
      @Semantics.user.createdBy: true
      _Romaneio.created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      _Romaneio.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Romaneio.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Romaneio.local_last_changed_at as LocalLastChangedAt,
      _OrdemItem,
      _StatusOrdem,
      _StatusArmaze,
      _StatusCompen

      //_ConfPedido

}
