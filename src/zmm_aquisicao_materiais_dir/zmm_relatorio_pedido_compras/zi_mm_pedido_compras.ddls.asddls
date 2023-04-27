@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedidos de compras'
define root view entity ZI_MM_PEDIDO_COMPRAS
  as select from    I_PurchaseOrderAPI01           as _Header

    join            I_PurchaseOrder                as _HeaderPO                 on _HeaderPO.PurchaseOrder = _Header.PurchaseOrder
    join            I_PurchaseOrderItemAPI01       as _Item                     on _Item.PurchaseOrder = _Header.PurchaseOrder
    left outer join I_PurchaseOrderItem            as _ItemInf                  on _Item.PurchaseOrder = _ItemInf.PurchaseOrder
                                                                                and _Item.PurchaseOrderItem = _ItemInf.PurchaseOrderItem
                                                                                
    left outer join I_PurOrdScheduleLineAPI01      as _ScheduleLine             on  _ScheduleLine.PurchaseOrder     = _Item.PurchaseOrder
                                                                                and _ScheduleLine.PurchaseOrderItem = _Item.PurchaseOrderItem
    left outer join ZI_MM_RLTPED_FILT_SUPPINVPUR   as _SupInvItmOrdRef          on  _SupInvItmOrdRef.PurchaseOrder     = _Item.PurchaseOrder
                                                                                and _SupInvItmOrdRef.PurchaseOrderItem = _Item.PurchaseOrderItem
    left outer join I_SupplierInvoice              as _SupplierInvoice          on  _SupplierInvoice.SupplierInvoice = _SupInvItmOrdRef.SupplierInvoice
                                                                                and _SupplierInvoice.FiscalYear      = _SupInvItmOrdRef.FiscalYear
    left outer join ZI_MM_RLTPED_FILT_PRICING      as _PricingElement_Bruto     on  _PricingElement_Bruto.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PricingElement_Bruto.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PricingElement_Bruto.ConditionType          = 'PB00'
    left outer join ZI_MM_RLTPED_FILT_PRICING      as _PricingElement_Ipi       on  _PricingElement_Ipi.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PricingElement_Ipi.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PricingElement_Ipi.ConditionType          = 'ZIPI'
    left outer join ZI_MM_RLTPED_FILT_PRICING      as _PricingElement_Icms      on  _PricingElement_Icms.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PricingElement_Icms.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PricingElement_Icms.ConditionType          = 'ZICM'
    left outer join ZI_MM_RLTPED_FILT_PRICING      as _PricingElement_DescBruto on  _PricingElement_DescBruto.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PricingElement_DescBruto.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PricingElement_DescBruto.ConditionType          = 'RA01'
    left outer join ZI_MM_RLTPED_FILT_PRICING      as _PricingElement_DespAcess on  _PricingElement_DespAcess.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PricingElement_DespAcess.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PricingElement_DespAcess.ConditionType          = 'ZDAC'

    //left outer join I_Businesspartnertaxnumber     as _Taxnumber_Cnpj           on  _Taxnumber_Cnpj.BusinessPartner = _Header.Supplier
                                                                                //and _Taxnumber_Cnpj.BPTaxType       = 'BR1'

    left outer join I_Businesspartnertaxnumber     as _Taxnumber_Cpf            on  _Taxnumber_Cpf.BusinessPartner = _Header.Supplier
                                                                                and _Taxnumber_Cpf.BPTaxType       = 'BR2'

    left outer join I_CentralPurchaseOrder         as _Central                  on _Central.PurchaseOrder = _Header.PurchaseOrder

    left outer join zi_mm_PurchaseOrdHistory       as _GRIRPur                  on  _GRIRPur.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _GRIRPur.PurchasingDocumentItem = _Item.PurchaseOrderItem

    //left outer join I_BusinessPartner              as _BusinessPartner          on _BusinessPartner.BusinessPartner = _Header.Supplier

    //left outer join ZI_MM_RLTPED_FILTER_BSNSSPTNR  as _FilterAdr                on _FilterAdr.BUSINESSPARTNER = _Header.Supplier
    
    //left outer join I_BusinessPartnerAddress       as _BusinessAdr              on  _BusinessAdr.BusinessPartner = _FilterAdr.BUSINESSPARTNER
                                                                                //and _BusinessAdr.AddressNumber   = _FilterAdr.ADDRESSNUMBER
    left outer join PurgOrder                      as _PurgOrder                on _PurgOrder.EBELN = _Header.PurchaseOrder

    left outer join P_GRIRPurchaseOrderHistory1    as _PurOrderHistor           on  _PurOrderHistor.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PurOrderHistor.PurchasingDocumentItem = _Item.PurchaseOrderItem
                                                                                and _PurOrderHistor.GoodsMovementType      = '122'

    left outer join I_SupplierInvoiceAPI01         as _SuplInvAPI01             on  _SuplInvAPI01.SupplierInvoice = _SupInvItmOrdRef.SupplierInvoice
                                                                                and _SuplInvAPI01.FiscalYear      = _SupInvItmOrdRef.FiscalYear

    left outer join rbkp                           as _Rbkp                     on  _Rbkp.belnr = _SuplInvAPI01.SupplierInvoice
                                                                                and _Rbkp.gjahr = _SuplInvAPI01.FiscalYear
    left outer join ZI_MM_RLTPED_FILTER_FRETE      as _Frete                    on  _Frete.Ebeln = _Item.PurchaseOrder
                                                                                and _Frete.Ebelp = _Item.PurchaseOrderItem

    left outer join ZI_MM_RLTPED_ULT_CHANGDOC_ITEM as _ChngDocItemLast          on _ChngDocItemLast.ChangeDocObject = _Header.PurchaseOrder

    left outer join I_ChangeDocument               as _ChngDoc                  on  _ChngDoc.ChangeDocObjectClass = _ChngDocItemLast.ChangeDocObjectClass
                                                                                and _ChngDoc.ChangeDocObject      = _ChngDocItemLast.ChangeDocObject
                                                                                and _ChngDoc.ChangeDocument       = _ChngDocItemLast.ChangeDocument
    left outer join I_PdReleaseIndicatorDesc       as _ReleaseIndicDesc         on  _ReleaseIndicDesc.Language                = $session.system_language
                                                                                and _ReleaseIndicDesc.PurchasingReleaseStatus = _Header.ReleaseCode
    left outer join I_MaterialGroupText            as _MatGroupText             on  _MatGroupText.MaterialGroup = _Item.MaterialGroup
                                                                                and _MatGroupText.Language      = $session.system_language
    left outer join ZI_MM_RLTPED_FILT_PURORDHIS    as _PurOrderHist             on  _PurOrderHist.PurchasingDocument     = _Item.PurchaseOrder
                                                                                and _PurOrderHist.PurchasingDocumentItem = _Item.PurchaseOrderItem
    //left outer join ZI_MM_RLTPED_FILT_EKPO         as _VlrsSerFat               on  _VlrsSerFat.Ebeln = _Item.PurchaseOrder
                                                                                //and _VlrsSerFat.Ebelp = _Item.PurchaseOrderItem
                                                                                
    left outer join lfa1                           as _Lfa1                     on _Header.Supplier = _Lfa1.lifnr
    
    left outer join ZI_MM_RLTPED_FILT_FORN_CALC      as _VlrForCalc             on  _VlrForCalc.ebeln = _Item.PurchaseOrder
                                                                                and _VlrForCalc.ebelp = _Item.PurchaseOrderItem

    left outer join ZI_MM_RLTPED_FILT_FAT_CALC       as _VlrFatCalc             on  _VlrFatCalc.ebeln = _Item.PurchaseOrder
                                                                                and _VlrFatCalc.ebelp = _Item.PurchaseOrderItem                                                                                                                                                                   
                                                                                                                                                                  
{

  key _Header.PurchaseOrder                                as PurchaseOrder, //Número do pedido
  key _Item.PurchaseOrderItem                              as PurchaseOrderItem,
  key _ScheduleLine.PurchaseOrderScheduleLine              as PurchaseOrderScheduleLine,
  key _SupInvItmOrdRef.SupplierInvoice                     as SupplierInvoice,
  key _SupInvItmOrdRef.FiscalYear                          as FiscalYear,
  key _SupInvItmOrdRef.SupplierInvoiceItem                 as SupplierInvoiceItem,

      _Header.CompanyCode                                  as CompanyCode,                  // Empresa
      _Header.PurchaseOrderType                            as PurchaseOrderType,            // Tipo de pedido
      _Header.PurchaseOrderDate                            as PurchaseOrderDate,            // Data do pedido
      _Header.CreatedByUser                                as CreatedByUser,                // Nome do responsável que criou o objeto
      _Header.Supplier                                     as Supplier,                     // Fornecedor
      _Header.PurchasingOrganization                       as PurchasingOrganization,       // Organização de compras
      _Header.PurchasingGroup                              as PurchasingGroup,              // Grupo de compradores
      _Header.SupplierRespSalesPersonName                  as SupplierRespSalesPersonName,  // Vendedor responsável no escritório do fornecedor
      _Header.ReleaseCode                                  as ReleaseCode,                  // Código de liberação documento de compra
      _Header.ReleaseIsNotCompleted                        as ReleaseIsNotCompleted,        // Liberação incompleta
      _HeaderPO.PurchasingReleaseStrategy                  as PurchasingReleaseStrategy,    // Estrat.liberação
      _HeaderPO.ReleaseIsNotCompleted                      as ReleaseIsNotCompletedPO,
      _Header.PurchasingCompletenessStatus                 as PurchasingCompletenessStatus, // Pedido ainda não completo
      _Header.PurgReleaseTimeTotalAmount                   as PurgReleaseTimeTotalAmount,   // Valor total durante a liberação
      _Header.DocumentCurrency                             as DocumentCurrency, // Valor total durante a liberação
      _Header.PaymentTerms                                 as PaymentTerms,                 // Chave de condições de pagamento
      _Header.PurgReleaseSequenceStatus                    as PurgReleaseSequenceStatus,    // Estado de liberação
      //_Header.PurchaseOrderDate               as PurchaseOrderDate,             // Data do pedido
      _Header.PricingDocument                              as PricingDocument, // Nº condição do documento
      _Header.CreationDate                                 as CreationDate,
      _Item.AccountAssignmentCategory                      as AccountAssignmentCategory,
      _Item.PurchaseOrderCategory                          as PurchaseOrderCategory,          // Categoria do documento de compras
      _Item.TaxCode                                        as TaxCode,                        // Código do IVA
      _Item.PurchasingDocumentDeletionCode                 as PurchasingDocumentDeletionCode, // Código de eliminação no documento de compras
      _Item.PurchaseOrderItemText                          as PurchaseOrderItemText,          // Texto breve
      _Item.Material                                       as Material,                       // Nº do material
      _Item.Plant                                          as Plant,                          // Centro
      _Item.StorageLocation                                as StorageLocation,                // ORAGE_LOCATION  Depósito
      _Item.RequirementTracking                            as RequirementTracking,            // Nº acompanhamento
      _Item.OrderQuantity                                  as OrderQuantity,                  // Quantidade do pedido
      _Item.PurchaseOrderQuantityUnit                      as PurchaseOrderQuantityUnit,      // Unidade de medida do pedido
      _Item.IsCompletelyDelivered                          as IsCompletelyDelivered,          // Código de recebimento concluído
      _Item.IsFinallyInvoiced                              as IsFinallyInvoiced,              // Código da fatura final
      _Item.RequisitionerName                              as RequisitionerName,              // Nome do requisitante
      _Item.PlannedDeliveryDurationInDays                  as PlannedDeliveryDurationInDays,  // Prazo de entrega previsto em dias
      _Item.OrderPriceUnit                                 as OrderPriceUnit,                 // Unidade do preço do pedido
      //      _Item.PurchaseOrderQuantityUnit         as PurchaseOrderQuantityUnit,      // Unidade de medida do pedido
      //_Item.IncotermsClassification                        as IncotermsClassification,        // Incoterms parte 1
      //_Item.IncotermsTransferLocation                      as IncotermsTransferLocation,      // Incoterms parte 2
      _Header.IncotermsClassification                        as IncotermsClassification,
      _Header.IncotermsTransferLocation                      as IncotermsTransferLocation,
      _Item.PurchaseRequisition                            as PurchaseRequisition,            // Nº requisição de compra
      _Item.PurchaseRequisitionItem                        as PurchaseRequisitionItem,        // Nº do item da requisição de compra
      _Item.PurchasingInfoRecord                           as PurchasingInfoRecord,           // Nº registro info para compras
      _Item.PurchaseContract                               as PurchaseContract,               // Nº contrato superior
      _Item.PurchaseContractItem                           as PurchaseContractItem,           // Nº item do contrato superior
      _Item.MaterialGroup                                  as MaterialGroup,                  // Grupo de mercadorias


      //Bruto
      _PricingElement_Bruto.ConditionType                  as BrutoConditionType,
      _PricingElement_Bruto.ConditionRateValue             as BrutoConditionRateValue,
      _Item.GrossAmount                                    as GrossAmount,//NOVO Bruto
      _PricingElement_Bruto.ConditionCurrency              as BrutoConditionCurrency,
      _PricingElement_Bruto.ConditionAmount                as BrutoConditionAmount,
      _PricingElement_Bruto.TransactionCurrency            as BrutoTransactionCurrency,

      //IPI
      _PricingElement_Ipi.ConditionType                    as IpiConditionType,
      _PricingElement_Ipi.ConditionRateValue               as IpiConditionRateValue,
      _PricingElement_Ipi.ConditionCurrency                as IpiConditionCurrency,
      _PricingElement_Ipi.ConditionAmount                  as IpiConditionAmount,

      //ICMS
      _PricingElement_Icms.ConditionType                   as IcmsConditionType,
      _PricingElement_Icms.ConditionRateValue              as IcmsConditionRateValue,
      _PricingElement_Icms.ConditionCurrency               as IcmsConditionCurrency,
      _PricingElement_Icms.ConditionAmount                 as IcmsConditionAmount,

      //DESC. PREÇO BRUTO
      _PricingElement_DescBruto.ConditionAmount            as DescBrtConditionAmount,
      _PricingElement_DescBruto.ConditionRateValue         as DescBrtConditionRateValue,

      //DESP. ACESS.
      _PricingElement_DespAcess.ConditionAmount            as DespAcessConditionAmount,
      _PricingElement_DespAcess.ConditionRateValue         as DespAcessConditionRateValue,
      _PricingElement_DespAcess.ConditionCurrency          as DespAcessConditionCurrency,
      cast( ' ' as boole_d )                               as pendente,
      //GRP. LIBER.
      _PurgOrder.FRGGR                                     as GrupLiberacao,
      _Central.PurchaseOrderNetAmount                      as PurchaseOrderNetAmount, //PREÇO LÍQUIDO
      _Item.NetAmount                                      as NetAmount,//NOVO PREÇO LÍQUIDO
      _ScheduleLine.ScheduleLineDeliveryDate               as ScheduleLineDeliveryDate,

      _GRIRPur.OrderQuantityUnit                           as OrderQuantityUnit,
      _GRIRPur.aserforn,
      _GRIRPur.aserfat,
      _GRIRPur.aserfatvalor,
      _GRIRPur.CompanyCodeCurrency,

      //NOME FORNECEDOR
      //_BusinessPartner.BusinessPartnerName                 as NomeFornec,
      _Lfa1.name1                                          as NomeFornec,
      //_Taxnumber_Cnpj.BPTaxNumber                          as Cnpj,
      _Lfa1.stcd1                                          as Cnpj,
      _Taxnumber_Cpf.BPTaxNumber                           as Cpf,
      //REGIÃO
      //_BusinessAdr.Region                                  as FornRegion,
      _Lfa1.regio                                          as FornRegion,
      _SupplierInvoice.DocumentDate                        as DocumentDate, //  INVDT Data da fatura em documento
      _SupplierInvoice.PostingDate                         as PostingDate, //   BUDAT Data de lançamento no documento
      _SupplierInvoice.SupplierInvoiceIDByInvcgParty       as SupplierInvoiceIDByInvcgParty, // XBLNR1  Nº documento de referência
      //DEVOLUÇÃO
      cast(_PurOrderHistor.Quantity as abap.dec( 13, 3 ) ) as QtdDevolucao,
      //EST. LIBERAÇÃO - Campo Virtual
      //EST. PENDENTE Detalhamento do campo no item 3.2.4
      //FRETE
      case _Frete.Frete
      when 'X'
           then 'Sim'
      else 'Não' end                                       as Frete,
      _Central.CorrespncExternalReference                  as ecompras, //PEDIDO E-COMPRAS
      _Central.CorrespncExternalReference                  as me, //PEDIDO MERCADO ELETRÔNICO
      //PREV. PAGTO
      _Rbkp.zfbdt                                          as PrevPagamento,
      _SupInvItmOrdRef.TotalQTD                            as QuantityInPurchaseOrderUnitSup, //QTD
      _SupInvItmOrdRef.PurchaseOrderQuantityUnit           as PurchaseOrderQuantityUnitSup, //UM PEDIDO
      //QTD MIGO - Campo Virtual
      //QTD PENDENTE - Campo Virtual
      //SALDO PENDENTE - Campo Virtual
      //DATA LIB.
      _ChngDoc.CreationDate                                as DataLibera,
      //HORA LIB.
      _ChngDoc.CreationTime                                as HoraLibera,
      //ESTRAT. DE LIBERAÇÃO
      _ReleaseIndicDesc.PurchasingReleaseIndicatorDesc     as EstratLibera,
      //CÓDIGO LIBERAÇÃO DOC. COMPRAS = Mesma lógica do campo a cima
      //LIBERAÇÃO INCOMPLETA
      case _ReleaseIndicDesc.PurchasingReleaseCategory
       when '1'
           then 'Sim'
       else 'Não' end                                      as LiberacIncompl,
      //DENOM. GRP. MERCAD.
      _MatGroupText.MaterialGroupName                      as MatGroupName,

      
      //_PurOrderHist.Quantity                               as QtdFornecida,
      case when _ItemInf.OutwardDeliveryIsComplete = 'X'
      then 0
      else _PurOrderHist.Quantity
      end as QtdFornecida,
      
      //_PurOrderHist.QtyInPurchaseOrderPriceUnit            as ASerFornec,
      //cast(_VlrsSerFat.Menge as abap.dec( 13, 3 ))         as SerFaturado,
      _VlrForCalc.A_Ser_For                                as ASerFornec, //new     
      _VlrFatCalc.A_Ser_Fat                                as SerFaturado,//new      
      //(cast(_Item.NetPriceAmount as abap.dec(11,2)) * coalesce(cast(_VlrFatCalc.A_Ser_Fat as abap.dec(18,3)),0)) as SerFatValor,
      
      case when _Item.NetPriceQuantity <> 0
      then
        fltp_to_dec( ((cast(_Item.NetPriceAmount as abap.fltp ) / cast(_Item.NetPriceQuantity as abap.fltp )) * (cast(coalesce(_VlrFatCalc.A_Ser_Fat,0) as abap.fltp))) as abap.dec(18,2))         
      else 
        (cast(_Item.NetPriceAmount as abap.dec(11,2)) * coalesce(cast(_VlrFatCalc.A_Ser_Fat as abap.dec(18,3)),0)) end as SerFatValor,
      
      //cast(_VlrsSerFat.Wrbtr as abap.dec( 13, 2 ))         as SerFatValor,
      _Item.NetPriceAmount      
}
