@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Retorno De Armazenagem'
define root view entity ZI_MM_PENDENTE_ORDEM_FRETE_APP
  as select from ZI_MM_PORDEM_FRETE_UNION

  association [0..1] to I_Customer           as _Customer               on  _Customer.Customer = $projection.SoldToParty
  association [0..1] to ZI_CA_VH_MATERIAL    as _Material               on  _Material.Material = $projection.Material
  association [0..1] to ZI_CA_VH_WERKS       as _OriginPlant            on  _OriginPlant.WerksCode = $projection.CentroRemessa
  association [0..1] to ZI_CA_VH_LGORT       as _OriginStorageLocation  on  _OriginStorageLocation.Plant           = $projection.CentroRemessa
                                                                        and _OriginStorageLocation.StorageLocation = $projection.Deposito
  association [0..1] to ZI_CA_VH_WERKS       as _DestinyPlant           on  _DestinyPlant.WerksCode = $projection.CentroDestino
  association [0..1] to ZI_CA_VH_LGORT       as _DestinyStorageLocation on  _DestinyStorageLocation.Plant           = $projection.CentroDestino
                                                                        and _DestinyStorageLocation.StorageLocation = $projection.DepositoDestino

  association [0..1] to ZI_MM_VH_DF_STATUS   as _StatusHistorico        on  _StatusHistorico.Status = $projection.StatusHistorico
  association [0..1] to ZI_MM_VH_DF_TIPO_EAN as _EANType                on  _EANType.EANType = $projection.EANType

{
  key NumeroOrdemDeFrete,
  key NumeroDaRemessa,
  key Material,
  key UmbOrigin,
  key UmbDestino,
  key CentroRemessa,
  key Deposito,
  key Lote,
  key CentroDestino,
  key DepositoDestino,
  key DadosDoHistorico,
  key PrmDepFecId,
  key EANType,
      _EANType.EANTypeText,
      SoldToParty,
      Status,
      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      EstoqueRemessaOF,
      //      @Semantics.quantity.unitOfMeasure: 'UmbDestino'
      //      UtilizacaoLivre,
      StatusHistorico,
      UseAvailable,
      UseAvailable                                                                 as UseAvailableCheckBox,

      cast( case StatusHistorico
      when '00' then 'X' -- Inicial
      when '01' then 'X' -- Em processamento
      when '02' then ''  -- Incompleto
      when '03' then ''  -- Completo
      when '04' then ''  -- Aguardando job Entrada Mercadoria
      when '05' then ''  -- Nota Rejeitada pela SEFAZ
      when '06' then ''  -- Erro na composição da Nota
      when '07' then ''  -- Em trânsito
                else 'X'
      end as boole_d )                                                             as UseAvailableCheckBoxEnable,

      case StatusHistorico
      when '00' then 0 -- Inicial
      when '01' then 2 -- Em processamento
      when '02' then 1 -- Incompleto
      when '03' then 3 -- Completo
      when '04' then 2 -- Aguardando job Entrada Mercadoria
      when '05' then 1 -- Nota Rejeitada pela SEFAZ
      when '06' then 1 -- Erro na composição da Nota
      when '07' then 2 -- Em trânsito
          else 0
      end                                                                          as StatusHistoricoCriticality,

      //Campos Logicos
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      AvailableStock,
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      fltp_to_dec(AvailableStock_Conve as abap.quan(13,3))                         as AvailableStock_Conve,
      cast( EstoqueRemessaOF as abap.int4 ) - cast( UtilizacaoLivre as abap.int4 ) as Diferenca,
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      UsedStock,
      @Semantics.quantity.unitOfMeasure : 'UmbDestino'
      fltp_to_dec(UsedStock_conve as mng06 )                                       as UsedStock_conve,

      case
      when UseAvailable = 'X'     then cast( '' as boole_d )  -- Utilização completa marcado
      when StatusHistorico = '02' then cast( '' as boole_d )  -- Incompleto
      when StatusHistorico = '03' then cast( '' as boole_d )  -- Completo
      when StatusHistorico = '04' then cast( '' as boole_d )  -- Aguardando job Entrada Mercadoria
      when StatusHistorico = '05' then cast( '' as boole_d )  -- Nota Rejeitada pela SEFAZ
      when StatusHistorico = '06' then cast( '' as boole_d )  -- Erro na composição da Nota
      when StatusHistorico = '07' then cast( '' as boole_d )  -- Em trânsito
                                  else cast( 'X' as boole_d )
      end                                                                          as UsedStockEnable,

      //Textos
      _Customer.CustomerFullName                                                   as SoldToPartyName,
      _Material.Text                                                               as MaterialText,
      _OriginPlant.WerksCodeName                                                   as CentroText,
      _OriginStorageLocation.StorageLocationText                                   as DepositoText,
      _DestinyPlant.WerksCodeName                                                  as CentroDestinoText,
      _DestinyStorageLocation.StorageLocationText                                  as DepositoDestinoText,

      //Campos de apoio - Histórico
      Guid,
      Description,
      OriginPlantType,
      DestinyPlant,
      DestinyPlantType,
      DestinyStorageLocation,

      //Campos do Pop UP
      cast( '' as lifnr  )                                                         as Transportador,
      cast( '' as bu_partner )                                                     as Driver,
      cast( '' as equnr )                                                          as Equipment,
      cast( '' as vsbed )                                                          as Shipping_conditions,
      cast( '' as vsart )                                                          as Shipping_type,
      cast( '' as equnr )                                                          as Equipment_tow1,
      cast( '' as equnr )                                                          as Equipment_tow2,
      cast( '' as equnr )                                                          as Equipment_tow3,
      cast( '' as ze_mm_freight_mode )                                             as Freight_mode,
      cast( 0 as abap.dec(13,3) )                                                  as NewUsedStock,

      _StatusHistorico

}
