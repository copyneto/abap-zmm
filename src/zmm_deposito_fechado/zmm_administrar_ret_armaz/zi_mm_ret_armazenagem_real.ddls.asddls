@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Retorno de Armazenagem - Real Time Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RET_ARMAZENAGEM_REAL
  as select from    ztmm_prm_dep_fec             as _Configuracao

    left outer join ZI_MM_MARD_ARMAZENAGEM_AGR   as _Deposito        on  _Deposito.werks = _Configuracao.origin_plant
                                                                     and _Deposito.lgort = _Configuracao.origin_storage_location
    inner join      mara                         as _mara            on _mara.matnr = _Deposito.matnr
    left outer join ZI_MM_DF_MATERIAL_UNIDADE    as _MaterialUnidade on  _MaterialUnidade.Material = _Deposito.matnr
                                                                     and _MaterialUnidade.Plant    = _Deposito.werks

    left outer join ztmm_his_dep_fec             as _Historico       on  _Historico.material              = _Deposito.matnr
                                                                     and _Historico.plant                 = _Deposito.werks
                                                                     and _Historico.storage_location      = _Deposito.lgort
                                                                     and _Historico.plant_dest            = _Configuracao.destiny_plant
                                                                     and _Historico.storage_location_dest = _Configuracao.destiny_storage_location
                                                                     and _Historico.batch                 = _Deposito.charg
                                                                     and _Historico.process_step          = 'F05'
                                                                     and _Historico.guid                  = hextobin(
            '00000000000000000000000000000000'
        )

    left outer join ZI_MM_SINGLE_ORDEM_E_REMESSA as _Base            on  _Historico.freight_order_id  = _Base.tor_id
                                                                     and _Historico.delivery_document = substring(
      _Base.base_btd_id, 26, 10
    )


    left outer join /scmtms/d_torrot             as _OrdemFrete      on _Base.tor_id = _OrdemFrete.tor_id


    left outer join I_SalesOrder                 as _SalesOrder      on _SalesOrder.SalesOrder = _Base.ReferenceSDDocument

    left outer join ZI_MM_RESB_SUM               as _RESB            on  _RESB.Matnr           = _Base.Material
                                                                     and _RESB.CentroDestino   = _Configuracao.destiny_plant
                                                                     and _RESB.DepositoDestino = _Configuracao.destiny_storage_location

    left outer join ZI_MM_ZMENG_SUM              as _ZMENG           on  _ZMENG.Vbeln = _SalesOrder.SalesOrder
                                                                     and _ZMENG.Zieme = _MaterialUnidade.OriginUnit


{
  key hextobin( '00000000000000000000000000000000' )            as Guid,
  key _Deposito.matnr                                           as Material, // MATERIAL
  key _Deposito.werks                                           as CentroOrigem,   // Centro Origem
  key _Deposito.lgort                                           as DepositoOrigem, // Depósito Destino
  key _Deposito.charg                                           as Lote,
  key _MaterialUnidade.OriginUnit                               as UmbOrigin,        // UMB Origin
  key _MaterialUnidade.Unit                                     as UmbDestino,       // UMB Destino
  key _OrdemFrete.tor_id                                        as NumeroOrdemDeFrete, // Nº ordem de frete
  key cast( substring( _Base.base_btd_id, 26, 10) as vbeln_vl ) as NumeroDaRemessa, // Nº da remessa

      //Texto breve do material -- VH
  key _Configuracao.destiny_plant                               as CentroDestino,
  key _Configuracao.destiny_storage_location                    as DepositoDestino,
  key _MaterialUnidade.EANType                                  as EANType,
      case when _Historico.process_step is not null
         then _Historico.process_step
         else 'F05' end                                         as ProcessStep,
      //Denominação do depósito -- VH
      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      _ZMENG.sunZMENGE                                          as QtdOrdVenda, //Qtd.Ord.Venda
      //Nome cliente -- VH

      _OrdemFrete.confirmation                                  as Status,           // Status da ordem de frete
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Base.OriginalDeliveryQuantity                            as EstoqueRemessaOF, // Estoque em remessa com OF
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Deposito.AvalibleStock                                   as UtilizacaoLivre, // Utilização livre

      _Historico.use_available                                  as UseAvailable,
      case when _Historico.status is not null
       then _Historico.status
       else '00' end                                            as StatusHistorico, -- Inicial

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _RESB.SunLbast                                            as EstoqueEmReserva,


      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Deposito.AvalibleBlock                                   as EstoqueBloqueado, //Estoque bloqueado (devoluções)

      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      unit_conversion( quantity => _Base.OriginalDeliveryQuantity,
                       source_unit => _MaterialUnidade.OriginUnit,
                       target_unit => _MaterialUnidade.Unit,
                       error_handling => 'SET_TO_NULL' )        as EstoqueLivreUtilizacao, // Estoque livre utilização
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      _Historico.order_quantity                                 as QtdTransportada,


      _Configuracao.guid                                        as PrmDepFecId,
      _Configuracao.description                                 as Description,
      _Configuracao.origin_plant_type                           as OriginPlantType,
      _Configuracao.destiny_plant_type                          as DestinyPlantType,
      _SalesOrder.SalesOrder                                    as SalesOrder,
      _SalesOrder.SalesDistrict                                 as SalesDistrict,
      _Historico.purchase_order                                 as purchaseorder,
      _Historico.out_br_nota_fiscal                             as outbr_notafiscal

}
// where
//   _SalesOrder.SalesOrder is initial or
//  _SalesOrder.OverallSDProcessStatus = 'C'
