@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Liberação'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MM_COCKPIT
  as select from    ZC_MM_COCKPIT_BASE as _Base
    left outer join ZI_MM_LOG_LIB_PAG  as _Log on _Log.LogExternalId = _Base.ExtLogNumber
    left outer to one join ekko as _ekko on _Base.PurchaseOrder = _ekko.ebeln and _Base.CompanyCode = _ekko.bukrs
    
  association [1] to I_Material               as _Material  on $projection.Material = _Material.Material
  association [1] to I_Plant                  as _Plant     on $projection.Plant = _Plant.Plant
  //  association [1] to I_BusinessPartner        as _Partner  on $projection.lifnr = _Partner.BusinessPartner
  association [1] to ZI_MM_VH_SACARIA         as _Sacaria   on $projection.Sacaria = _Sacaria.Valor
  association [1] to ZI_MM_VH_EMBALAGEM       as _Embalagem on $projection.Embalagem = _Embalagem.Valor
  association [1] to ZI_MM_VH_DOC_STATUS      as _status    on $projection.status = _status.Valor
  //  association [0..1] to ZI_MM_LOG_LIB_PAG     as _Log       on _Log.extnumber = $projection.ExtNumber
  composition [0..*] of ZI_MM_CHARACTERISTICS as _Char
  
  composition [0..*] of ZI_MM_CHARACTERISTICS_RECEB_V2 as _Char2
  
  composition [0..*] of ZI_MM_CHARACTERISTICS_PED as _Char3
{
  key _Base.PurchaseOrder,
  key _Base.PurchaseOrderItem,
  key _Base.BR_NotaFiscal,
      _Base.BR_NFeNumber,
      _Base.BR_NFSeries,
      _Base.ReferencedDocument,
      _Base.AccountingDocument,
      _Base.FiscalYear,
      _Base.CompanyCode,
      @ObjectModel.text.element: ['MaterialName']
      _Base.Material,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      _Base.OrderQuantity,
      _Base.PurchaseOrderQuantityUnit,
      @ObjectModel.text.element: ['PlantName']
      _Base.Plant,
      @ObjectModel.text.element: ['StatusName']
      _Base.status,
      _status.Texto        as StatusName,
      //////      tipo,
      _Base.DescontoCriticality,
      @Semantics.amount.currencyCode: 'waers'
      @EndUserText.label: 'Desc. Comercial'
      _Base.DescontoComercial,
      _Base.ObservComercial,
      _Base.UsuarioComercial,
      _Base.DataComercial,
      _Base.docok_com,
      @Semantics.amount.currencyCode: 'waers'
      @EndUserText.label: 'Desc. Financeiro'
      _Base.DescontoFinanceiro,
      _Base.ObservFinanceiro,
      _Base.UsuarioFinanceiro,
      _Base.DataFinanceiro,
      _Base.docok_fin,
      @Semantics.amount.currencyCode: 'waers'
      @EndUserText.label: 'Devol. Futura'
      _Base.DevolucaoFutura,
      _Base.Contrato,
      @ObjectModel.text.element: ['SacariaName']
      _Base.Sacaria,
      @ObjectModel.text.element: ['EmbalagemName']
      _Base.Embalagem,
      case when
        _Base.waers is null  
        then cast( 'BRL' as waers ) 
        else _Base.waers end as waers,          
      //_Base.waers,
      //      @ObjectModel.text.element: ['BusinessPartnerName']
      _Base.lifnr,
      @Semantics.quantity.unitOfMeasure: 'meins'
      _Base.menge,
      _Base.meins,
      @Semantics.quantity.unitOfMeasure: 'meins'
      _Base.lagmg,
      _Base.observacao,

      _Base.BR_ReferenceNFNumber,
      @EndUserText.label: 'Nota Fiscal'
      _Base.Nfnum,
      @ObjectModel.text.element: ['SupplierName']
      @EndUserText.label: 'Nome Emitente'
      _Base.Supplier,
      _Base.SupplierName,
      _Base.NFTotalAmount,
      @Semantics.quantity.unitOfMeasure: 'NFBaseUnit'
      _Base.NFTotalQuantity,
      @EndUserText.label: 'Vl. Apurado Fim'
      _Base.NFTotalReversalValue,
      _Base.NFBaseUnit,
      _Base.NFCurrency,
      @Semantics.amount.currencyCode: 'NFCurrency'
      @EndUserText.label: 'Valor Apurado'
      _Base.ValorApurado,
      @Semantics.amount.currencyCode: 'NFCurrency'
      @EndUserText.label: 'Montante Adiantamento'
      _Base.MontanteAdiantamento,
      @EndUserText.label: 'Compensado'
      _Base.StatusCompensado,
      _Base.CompensadoCriticality,

      case when _Log.LogExternalId is initial or _Log.LogExternalId is null
        then ''
        else  'Exibir' end as Log,

      _Log.LogObjectId,
      _Log.LogObjectSubId,
      _Log.LogExternalId,
      _Log.DateFrom,

      _Base.CreatedBy,
      _Base.CreatedAt,
      _Base.LastChangedBy,
      _Base.LastChangedAt,
      _Base.LocalLastChangedAt,

      _Material._Text[Language = $session.system_language].MaterialName,
      _Plant.PlantName,
      //      _Partner.BusinessPartnerName,
      _Sacaria.Texto       as SacariaName,
      _Embalagem.Texto     as EmbalagemName,
      _ekko.aedat          as DtPedido,

      _Char,
      _Char2,
      _Char3,
      _Material,
      _Plant,
      _status,
      _Sacaria,
      _Embalagem
}
