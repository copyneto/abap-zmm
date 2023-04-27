@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ret Armazenagem - Principal '
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_RET_ARMAZENAGEM_APP
  as select from    ZI_MM_RET_ARMAZENAGEM_UNION as _App

    left outer join ztmm_his_dep_fec            as _Historico on  _Historico.material              = _App.Material
                                                              and _Historico.plant                 = _App.CentroOrigem
                                                              and _Historico.storage_location      = _App.DepositoOrigem
                                                              and _Historico.plant_dest            = _App.CentroDestino
                                                              and _Historico.storage_location_dest = _App.DepositoDestino
                                                              and _Historico.freight_order_id      = _App.NumeroOrdemDeFrete
                                                              and _Historico.delivery_document     = _App.NumeroDaRemessa
                                                              and _Historico.process_step          = 'F05'
                                                              and _Historico.batch                 = _App.Lote
                                                              and _Historico.guid                  = _App.Guid
  //                                                              and _Historico.guid                  = hextobin('00000000000000000000000000000000' )
  
   inner join I_Material                   as _MaterialInfo           on  _MaterialInfo.Material = _App.Material

  association [1..1] to mard                         as _Mard                   on  _Mard.matnr = _App.Material
                                                                                and _Mard.werks = _App.CentroOrigem
                                                                                and _Mard.lgort = _App.DepositoOrigem

  association [0..1] to ZI_CA_VH_MATERIAL            as _Material               on  _Material.Material = $projection.Material

  association [0..1] to ZI_CA_VH_WERKS               as _OriginPlant            on  _OriginPlant.WerksCode = $projection.CentroOrigem
  association [0..1] to ZI_CA_VH_WERKS               as _DestinyPlant           on  _DestinyPlant.WerksCode = $projection.CentroDestino

  association [0..1] to ZI_CA_VH_LGORT               as _OriginStorageLocation  on  _OriginStorageLocation.Plant           = $projection.CentroOrigem
                                                                                and _OriginStorageLocation.StorageLocation = $projection.DepositoOrigem

  association [0..1] to ZI_CA_VH_LGORT               as _DestinyStorageLocation on  _DestinyStorageLocation.Plant           = $projection.CentroDestino
                                                                                and _DestinyStorageLocation.StorageLocation = $projection.DepositoDestino

  association [0..1] to ZI_MM_VH_CONFIRM_STATUS      as _Status                 on  _Status.confirmation = $projection.Status

  association [0..1] to ZI_MM_VH_DF_STATUS           as _StatusHistorico        on  _StatusHistorico.Status = $projection.StatusHistorico

  association [0..1] to ZI_MM_VH_DF_TIPO_EAN         as _EANType                on  _EANType.EANType = $projection.EANType

  association [0..1] to ZI_MM_VH_DF_TRANSPORTADOR    as _Carrier                on  _Carrier.Carrier = $projection.Transportador
  association [0..1] to ZI_MM_VH_DF_MOTORISTA        as _Driver                 on  _Driver.Parceiro = $projection.Driver
  association [0..1] to ZI_MM_VH_DF_VEICULO          as _Equipment              on  _Equipment.Equipment = $projection.Equipment
  association [0..1] to ZI_CA_VH_VSBED               as _ShippingConditions     on  _ShippingConditions.CondicaoExpedicao = $projection.Shipping_conditions
  association [0..1] to ZI_CA_VH_VSART               as _ShippingType           on  _ShippingType.TipoExpedicao = $projection.Shipping_type
  //  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow1          on  _EquipmentTow1.Equipment = $projection.Equipment_tow1
  //  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow2          on  _EquipmentTow2.Equipment = $projection.Equipment_tow2
  //  association [0..1] to ZI_MM_VH_DF_VEICULO          as _EquipmentTow3          on  _EquipmentTow3.Equipment = $projection.Equipment_tow3
  association [0..1] to ZI_MM_VH_DF_MODALIDADE_FRETE as _FreightMode            on  _FreightMode.FreightMode = $projection.Freight_mode
  association [0..1] to I_BR_NFeActive               as _NFActive               on  _NFActive.BR_NotaFiscal = $projection.OutBr_NotaFiscal
  association [0..1] to ZI_CA_VH_STATUSNFE           as _NFActiveStatusText     on  _NFActiveStatusText.DomvalueL = $projection.StatusNF

  composition [0..*] of ZI_MM_RET_ARMAZENAGEM_SERIE  as _Serie
  composition [0..*] of zi_mm_ret_armazenagem_msg    as _Mensagem

{

  key _App.Guid,
  key _App.NumeroOrdemDeFrete,
  key _App.NumeroDaRemessa,
  key _App.Material,
  key _App.UmbOrigin,
  key _App.UmbDestino,
  key _App.CentroOrigem,
  key _App.DepositoOrigem,
  key _App.CentroDestino,
  key _App.DepositoDestino,
  key _App.Lote,
  key _App.EANType,
  key _App.DadosDoHistorico,

      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.QtdOrdVenda,
      _App.Status,
      _Status.confirmation_txt                                               as StatusText,

      //Campos Logicos
      case _App.Status
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '07' then 2 -- Em trânsito
      when '09' then 2 -- Aguardando Saída de Material
      when '11' then 2 -- Aguardando Ordem de Frente
                else 0
      end                                                                    as StatusCriticality,

      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.EstoqueRemessaOF,
      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.UtilizacaoLivre,
      _App.UseAvailable,
      _App.UseAvailable                                                      as UseAvailableCheckBox,
      cast( case _App.StatusHistorico
      when '00' then 'X' -- Inicial
      when '01' then 'X' -- Em processamento
      when '02' then ''  -- Incompleto
      when '03' then ''  -- Completo
      when '04' then ''  -- Aguardando job Entrada Mercadoria
      when '05' then ''  -- Nota Rejeitada pela SEFAZ
      when '06' then ''  -- Erro na composição da Nota
      when '07' then ''  -- Em trânsito
                else 'X'
      end as boole_d )                                                       as UseAvailableCheckBoxEnable,

      _App.StatusHistorico,
      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.EstoqueEmReserva,
      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.EstoqueBloqueado,
      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      cast( _App.EstoqueLivreUtilizacao as abap.quan(31,3))                  as EstoqueLivreUtilizacao,

      //      @Semantics.quantity.unitOfMeasure : 'UmbOrigin'
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      _App.QtdTransportada,
      //      _App.Guid,

      //Campos Logicos
      case _App.StatusHistorico
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '07' then 2 -- Em trânsito
      when '09' then 2 -- Aguardando Saída de Material
      when '11' then 2 -- Aguardando Ordem de Frente
                else 0
      end                                                                    as StatusHistoricoCriticality,

      _NFActive.BR_NFeDocumentStatus                                         as StatusNF,

      case _NFActive.BR_NFeDocumentStatus
      when '3'  then 1
      when '2'  then 1
      when '1'  then 3
      else 0 end                                                             as StatusNFCriticality,

      cast( unit_conversion( quantity => _App.EstoqueLivreUtilizacao ,
                             source_unit => _App.UmbOrigin,
                             target_unit => _App.UmbDestino,
                             error_handling => 'SET_TO_NULL' )
                             as abap.int4) -  cast(_Mard.labst as abap.int4) as Diferenca,

      case when _App.QtdTransportada is not initial and _App.UseAvailable is not initial
      then 3
      //      when _App.QtdTransportada is initial and _App.QtdTransportada > 0
      when _App.UseAvailable is initial and _App.QtdTransportada > 0
      then 2
      else 0
      end                                                                    as QtdTransportadaCriticality,

      //Textos
      _Material.Text                                                         as MaterialText,
      _OriginPlant.WerksCodeName                                             as CentroOrigemText,
      _OriginStorageLocation.StorageLocationText                             as DepositoOrigemText,
      _DestinyPlant.WerksCodeName                                            as CentroDestinoText,
      _DestinyStorageLocation.StorageLocationText                            as DepositoDestinoText,

      /* Campos de apoio - Histórico */
      _App.PrmDepFecId,
      _App.Description,
      _App.OriginPlantType,
      _App.DestinyPlantType,

      _Historico.carrier                                                     as Transportador,
      _Historico.driver                                                      as Driver,
      _Historico.equipment                                                   as Equipment,
      _Historico.shipping_conditions                                         as Shipping_conditions,
      _Historico.shipping_type                                               as Shipping_type,
      _Historico.equipment_tow1                                              as Equipment_tow1,
      _Historico.equipment_tow2                                              as Equipment_tow2,
      _Historico.equipment_tow3                                              as Equipment_tow3,
      _Historico.freight_mode                                                as Freight_mode,
      _Historico.created_by                                                  as CreatedBy,
      _Historico.created_at                                                  as CreatedAt,
       _Historico.last_changed_by                     as LastChangedBy,
       _Historico.last_changed_at                     as LastChangedAt,
       _Historico.local_last_changed_at               as LocalLastChangedAt,      
      ''                                                                     as NewUsedStock,
      _Historico.out_delivery_document                                       as OutboundDelivery,

      // Campos para navegação
      _App.NumeroOrdemDeFrete                                                as FreightOrder,
      _App.SalesDistrict,
      case
      when _App.UseAvailable is not initial then 3
      when _App.UseAvailable is initial and _App.EstoqueLivreUtilizacao > 0 then 2
      else 0
      end                                                                    as EstoqueLivreUtilCriticality,

      case
      when _App.UseAvailable    = 'X'  then cast( '' as boole_d )  -- Utilização completa marcado
      when _App.StatusHistorico = '02' then cast( '' as boole_d )  -- Incompleto
      when _App.StatusHistorico = '03' then cast( '' as boole_d )  -- Completo
      when _App.StatusHistorico = '04' then cast( '' as boole_d )  -- Aguardando job Entrada Mercadoria
      when _App.StatusHistorico = '05' then cast( '' as boole_d )  -- Nota Rejeitada pela SEFAZ
      when _App.StatusHistorico = '06' then cast( '' as boole_d )  -- Erro na composição da Nota
      when _App.StatusHistorico = '07' then cast( '' as boole_d )  -- Em trânsito
                                       else cast( 'X' as boole_d )
      end                                                                    as EstoqueLivreUtilEnable,

      case
      when _App.UseAvailable    = 'X'  then 2  -- Utilização completa marcado
      when _App.StatusHistorico = '02' then 2  -- Incompleto
      when _App.StatusHistorico = '03' then 2  -- Completo
      when _App.StatusHistorico = '04' then 2  -- Aguardando job Entrada Mercadoria
      when _App.StatusHistorico = '05' then 2  -- Nota Rejeitada pela SEFAZ
      when _App.StatusHistorico = '06' then 2  -- Erro na composição da Nota
      when _App.StatusHistorico = '07' then 2  -- Em trânsito
                                       else 3
      end                                                                    as EstoqueLivreUEnableCriticality,
      _App.purchaseorder                                                     as PurchaseOrder,
      _App.outbr_notafiscal                                                  as OutBr_NotaFiscal,
      _MaterialInfo.MaterialType,
      _Mard,
      _StatusHistorico,
      _Material,
      _OriginPlant,
      _OriginStorageLocation,
      _EANType,
      _Carrier,
      _Driver,
      _Equipment,
      _NFActiveStatusText,
      _ShippingConditions,
      _ShippingType,
      //      _EquipmentTow1,
      //      _EquipmentTow2,
      //      _EquipmentTow3,
      _FreightMode,
      _Serie,
      _Mensagem

}
where
  _App.UtilizacaoLivre > 0 or _App.DadosDoHistorico = 'X'
