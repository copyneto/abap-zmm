@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Visão Remessa e Retorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_VISAO_REMESSA_RETORNO
  as select from    ztmm_his_dep_fec         as Historico

    left outer join I_BR_NFDocument          as NFDocumentEntrada   on NFDocumentEntrada.BR_NotaFiscal = Historico.in_br_nota_fiscal

    left outer join I_BR_NFDocument          as NFDocumentSaida     on NFDocumentSaida.BR_NotaFiscal = Historico.out_br_nota_fiscal

  //    left outer join I_BR_NFeActive             as NFeActive           on NFeActive.BR_NotaFiscal = Historico.in_br_nota_fiscal
    left outer join I_BR_NFeActive           as NFeActive           on NFeActive.BR_NotaFiscal = Historico.out_br_nota_fiscal

    left outer join I_MaterialDocumentHeader as MaterialHeader      on  MaterialHeader.MaterialDocument     = Historico.out_material_document
                                                                    and MaterialHeader.MaterialDocumentYear = Historico.out_material_document_year

    left outer join I_MaterialDocumentItem   as MaterialItem        on  MaterialItem.PurchaseOrder        = Historico.purchase_order
                                                                    and MaterialItem.MaterialDocument     = Historico.out_material_document
                                                                    and MaterialItem.MaterialDocumentYear = Historico.out_material_document_year
                                                                    and MaterialItem.MaterialDocumentItem = Historico.out_material_document_item

    left outer join I_PurchaseOrderAPI01     as PurchaseOrderAPI01  on  PurchaseOrderAPI01.PurchaseOrder     = Historico.purchase_order
                                                                    and PurchaseOrderAPI01.PurchaseOrderType = 'ZDF'

  //    left outer join I_BR_NFeDocumentStatusText as NomeStatusSefaz     on  NFDocumentEntrada.BR_NFeDocumentStatus = NomeStatusSefaz.BR_NFeDocumentStatus
  //                                                                      and NomeStatusSefaz.Language               = $session.system_language

    left outer join zi_StatusSefazText       as NomeStatusSefaz     on NomeStatusSefaz.StatusNF = NFDocumentEntrada.BR_NFeDocumentStatus

    left outer join j_1bnfe_active           as j1bnfeActive        on j1bnfeActive.docnum = Historico.out_br_nota_fiscal

    left outer join ZI_MM_NUM_TRANSPORTE     as _OrdemFrete         on _OrdemFrete.OutDeliveryDocument = Historico.out_delivery_document

    left outer join I_DeliveryDocument       as OutDeliveryDocument on OutDeliveryDocument.DeliveryDocument = Historico.out_delivery_document

    left outer join I_DeliveryDocument       as InDeliveryDocument  on InDeliveryDocument.DeliveryDocument = Historico.in_delivery_document

  association [0..1] to ZI_MM_VH_CENTRO_ORIGEM_DEP_FEC as _VHCentroOrigem    on  $projection.OriginPlant = _VHCentroOrigem.Plant

  association [0..1] to ZI_MM_VH_CENTRO_DEST_DEP_FEC   as _VHCentroDestino   on  $projection.DestinyPlant = _VHCentroDestino.Plant

  association [0..1] to ZI_CA_VH_DEPOSITO              as _VHDepositoOrigem  on  $projection.S_deposito_origem = _VHDepositoOrigem.Lgort
                                                                             and $projection.OriginPlant       = _VHDepositoOrigem.Werks

  association [0..1] to ZI_CA_VH_DEPOSITO              as _VHDepositoDestino on  $projection.S_deposito_destino = _VHDepositoDestino.Lgort
                                                                             and $projection.DestinyPlant       = _VHDepositoDestino.Werks

  association [0..1] to ZI_CA_VH_STATUS_CODE           as _CodigoStatus      on  _CodigoStatus.StatusCode = $projection.CodigoStatus
  association [0..1] to zi_StatusSefazText           as _NomeStatusSefaz      on  _NomeStatusSefaz.StatusNF = $projection.StatusSefaz
  
  
  
{

  key Historico.origin_plant               as OriginPlant,          //Coluna Centro Origem
  key Historico.destiny_plant              as DestinyPlant,         //Coluna Centro Destino
  key Historico.out_br_nota_fiscal         as OutBrNotaFiscal,      //Coluna Docnum Saída Remessa
  key Historico.purchase_order             as PurchaseOrder,        //Coluna Num. Pedido de Transferência da Remessa

      Historico.rep_br_nota_fiscal         as RepBrNotaFiscal, // NF Replicação

      _VHCentroOrigem.PlantName            as NomeCentroOrigem,
      _VHCentroDestino.PlantName           as NomeCentroDestino,
      _VHDepositoOrigem.Lgobe              as NomeDepositoOrigem,
      _VHDepositoDestino.Lgobe             as NomeDepositoDestino,

      NFDocumentEntrada.BR_NFIssueDate     as E_data_doc,           //Filtro Data Doc. Saida e Entrada
      NFDocumentEntrada.BR_NFDirection     as E_direct,

      NFDocumentSaida.BR_NFIssueDate       as S_data_doc,           //Filtro Data Doc. Saida e Entrada
      NFDocumentSaida.BR_NFDirection       as S_direct,

      Historico.origin_storage_location    as S_deposito_origem,    //Filtro Deposito Origem
      Historico.destiny_storage_location   as S_deposito_destino,   //Filtro Deposito Destino

      Historico.out_delivery_document      as OutDeliveryDocnum,    //Num. fornecimento de transferência remessa

      concat( Historico.out_material_document,
              Historico.out_material_document_year
            )                              as DocMovimentoSaida,    //Coluna Doc. Movimento saída

      Historico.out_material_document      as OutMaterialDocument,
      Historico.out_material_document_year as OutMaterialDocumentYear,

      concat( Historico.out_material_document,
              Historico.out_material_document_year
            )                              as S_doc_material,       //Filtro Doc. Material

      //      Historico.out_material_document_item     as OutMaterialDocnumItem,
      Historico.in_br_nota_fiscal          as InBrNotaFiscal,

      case
        when MaterialHeader.PostingDate is not initial
            then MaterialHeader.PostingDate
        when NFDocumentSaida.CreationDate is not initial
            then NFDocumentSaida.CreationDate
        end                                as DataDocumentoSaida,   //Coluna Data Documento Saida

      NFeActive.BR_NFeNumber               as NumNotaFiscalRemessa, //Coluna Nº Nota Fiscal remessa

      j1bnfeActive.code                    as CodigoStatus,         //Coluna Código status
      _CodigoStatus.StatusCodeText         as CodigoStatusTexto,

//      NFDocumentSaida.BR_NFeDocumentStatus as StatusSefaz,          //Coluna Status Sefaz
      case NFDocumentSaida.BR_NFeDocumentStatus
        when '1' then '1'
        when '2' then '3'
        when '3' then '3'
                 else ''
        end                                as StatusSefaz,          //Coluna Status Sefaz

      case NFDocumentSaida.BR_NFeDocumentStatus
        when '1' then 3
        when '2' then 1
        when '3' then 1
                 else 0
        end                                as CriticalStatus,

      NomeStatusSefaz.TextoStatusNF        as StatusSefazDesc,

      _OrdemFrete.NumTransporte            as TorId,                //Coluna Nº transporte

      OutDeliveryDocument.CreatedByUser    as SaidaCriadoPor,       //Coluna Saida Criado Por

      Historico.in_br_nota_fiscal          as DocnumEntrada,        //Coluna Docnum Entrada

      concat( Historico.in_material_document,
              Historico.in_material_document_year
            )                              as MovMercaEntra,        //Coluna Mov. Mercadoria entrada

      Historico.in_material_document       as InMaterialDocument,
      Historico.in_material_document_year  as InMaterialDocumentYear,

      InDeliveryDocument.CreatedByUser     as EntCriadoPor,         //Coluna Entrada Criado Por
      $session.system_date                 as CurrentDate,
      
      PurchaseOrderAPI01.CreationDate as DataPedido,

      _VHCentroOrigem,
      _VHCentroDestino,
      _VHDepositoOrigem,
      _VHDepositoDestino,
      _NomeStatusSefaz

}
group by
  Historico.origin_plant,
  Historico.destiny_plant,
  Historico.out_br_nota_fiscal,
  Historico.purchase_order,
  Historico.rep_br_nota_fiscal,
  _VHCentroOrigem.PlantName,
  _VHCentroDestino.PlantName,
  _VHDepositoOrigem.Lgobe,
  _VHDepositoDestino.Lgobe,
  NFDocumentEntrada.BR_NFIssueDate,
  NFDocumentEntrada.BR_NFDirection,
  NFDocumentSaida.BR_NFIssueDate,
  NFDocumentSaida.BR_NFDirection,
  Historico.origin_storage_location,
  Historico.destiny_storage_location,
  Historico.out_delivery_document,
  Historico.out_material_document,
  Historico.out_material_document_year,
  //      Historico.out_material_document_item     ,
  Historico.in_br_nota_fiscal,
  MaterialHeader.PostingDate,
  NFDocumentSaida.CreationDate,
  NFeActive.BR_NFeNumber,
  j1bnfeActive.code,
  _CodigoStatus.StatusCodeText,
  NFDocumentSaida.BR_NFeDocumentStatus,
  NomeStatusSefaz.TextoStatusNF,
  _OrdemFrete.NumTransporte,
  OutDeliveryDocument.CreatedByUser,
  Historico.in_br_nota_fiscal,
  InDeliveryDocument.CreatedByUser,
  Historico.in_material_document,
  Historico.in_material_document_year,
  PurchaseOrderAPI01.CreationDate
