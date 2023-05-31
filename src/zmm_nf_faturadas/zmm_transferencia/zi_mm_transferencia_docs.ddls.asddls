@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface Transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TRANSFERENCIA_DOCS
  as select from    I_BR_NFDocument            as NFBrief
    left outer join I_BR_NFItem                as _NFItem             on _NFItem.BR_NotaFiscal = NFBrief.BR_NotaFiscal

  /* -----------------------------------------------------------------------------------------------------------
     Chamado 8000007486 - Nova regra para exibir o último documento de material, independente de estar estornado
  ----------------------------------------------------------------------------------------------------------- */
    left outer join ZI_MM_TRANSFERENCIA_MATDOC as _MatDocItem         on  _MatDocItem.Refkey   = _NFItem.BR_NFSourceDocumentNumber
                                                                      and _MatDocItem.Refitem  = _NFItem.BR_NFSourceDocumentItem
                                                                      and _MatDocItem.Material = _NFItem.Material

    left outer join ZI_MM_TRANSF_EKBE          as _EkbeDocRef         on  _EkbeDocRef.Ebeln = _MatDocItem.PurchaseOrder
                                                                      and _EkbeDocRef.Ebelp = _MatDocItem.PurchaseOrderItem
    //                                                                      and _EkbeDocRef.Gjahr = _MatDocItem.MaterialDocumentYear
    //                                                                      and _EkbeDocRef.Belnr = _MatDocItem.MaterialDocument
    //                                                                      and _EkbeDocRef.Buzei = _MatDocItem.MaterialDocumentItem
                                                                      and _EkbeDocRef.Gjahr = _MatDocItem.RefMaterialDocumentYear
                                                                      and _EkbeDocRef.Belnr = _MatDocItem.RefMaterialDocument
                                                                      and _EkbeDocRef.Buzei = _MatDocItem.RefMaterialDocumentItem
                                                                      and _EkbeDocRef.Bwart = '862'
  /* -----------------------------------------------------------------------------------------------------------
    Chamado 8000007487 - Nova regra para exibir o último documento de material quando ZDF
 ----------------------------------------------------------------------------------------------------------- */
    left outer join ZI_MM_TRANSF_EKBE_ZDF      as _EkbeDocRef1        on  _EkbeDocRef1.ebeln = _MatDocItem.PurchaseOrder
                                                                      and _EkbeDocRef1.ebelp = _MatDocItem.PurchaseOrderItem
                                                                      and _EkbeDocRef1.gjahr = _MatDocItem.MaterialDocumentYear
                                                                      and _EkbeDocRef1.bwart = '861'

  /* -----------------------------------------------------------------------------------------------------------
     Chamado 8000007486 - Nova regra para exibir o último documento de material, independente de estar estornado
  ----------------------------------------------------------------------------------------------------------- */
    left outer join ZI_MM_TRANSFERENCIA_MATDOC as _MatDocItemRef      on  _MatDocItemRef.Refkey                      = _NFItem.BR_NFSourceDocumentNumber
                                                                      and _MatDocItemRef.Refitem                     = _NFItem.BR_NFSourceDocumentItem
                                                                      and _MatDocItemRef.Material                    = _NFItem.Material
                                                                      and (
                                                                         _MatDocItemRef.GoodsMovementType            = '861'
                                                                         or _MatDocItemRef.GoodsMovementType         = '101'
                                                                         or _MatDocItemRef.ReversalGoodsMovementType = '864' // Para desconsiderar no Where
                                                                       )

    left outer join ekbe                       as _Ekbe               on  _Ekbe.ebeln   = _MatDocItem.PurchaseOrder
                                                                      and _Ekbe.ebelp   = _MatDocItem.PurchaseOrderItem
                                                                      and _Ekbe.gjahr   = _MatDocItem.MaterialDocumentYear
                                                                      and (
                                                                         _Ekbe.bwart    = '861'
                                                                         or _Ekbe.bwart = '101'
                                                                       )
    left outer join ZI_MM_LC_DEST              as _LocalCentroDestino on  _LocalCentroDestino.BR_NotaFiscal     = _NFItem.BR_NotaFiscal
                                                                      and _LocalCentroDestino.BR_NotaFiscalItem = _NFItem.BR_NotaFiscalItem

    left outer join ZI_MM_LC_DEST_EKPA         as _LocalCentroEKPA    on _LocalCentroEKPA.BR_NotaFiscal = _NFItem.BR_NotaFiscal

    left outer join C_BR_VerifyNotaFiscal      as _VerifyNF1          on _VerifyNF1.BR_NotaFiscal = NFBrief.BR_NotaFiscal
    left outer join zi_mm_vbap_werks           as _Vbap               on _Vbap.vbeln = _VerifyNF1.OriginReferenceDocument
    left outer join zi_mm_ekpo_bstkd           as _EkpoCol            on _EkpoCol.ebeln = _Vbap.bstkd_ana
    left outer join vbak                       as _VBAk               on _VBAk.vbeln = _VerifyNF1.OriginReferenceDocument
    left outer join ekko                       as _VBAk_ekko          on _VBAk_ekko.ebeln = LEFT(
      _VBAk.bstnk, 10
    )


  //    left outer join zi_mm_t001w_werks      as _T001w         on _T001w.kunnr = _Vbap.kunnr_ana
    left outer join j_1bnfe_active             as _NFActive           on _NFActive.docnum = NFBrief.BR_NotaFiscal

  //***
    left outer join I_BR_NFItem                as _NFItemSaida        on  _NFItemSaida.BR_NotaFiscal     = NFBrief.BR_NotaFiscal
                                                                      and _NFItemSaida.PurchaseOrder     = _NFItem.PurchaseOrder
                                                                      and _NFItemSaida.PurchaseOrderItem = _NFItem.PurchaseOrderItem
  //***
  //    left outer join j_1bnfe_active             as _NFActiveSaida      on  _NFActiveSaida.regio                  = _NFActive.regio
    left outer join j_1bnfe_active             as _NFActiveSaida      on  _NFActiveSaida.docnum                 = _NFItemSaida.BR_NotaFiscal
                                                                      and _NFActiveSaida.regio                  = _NFActive.regio
                                                                      and _NFActiveSaida.nfyear                 = _NFActive.nfyear
                                                                      and _NFActiveSaida.nfmonth                = _NFActive.nfmonth
                                                                      and _NFActiveSaida.stcd1                  = _NFActive.stcd1
                                                                      and _NFActiveSaida.model                  = _NFActive.model
                                                                      and _NFActiveSaida.serie                  = _NFActive.serie
                                                                      and _NFActiveSaida.nfnum9                 = _NFActive.nfnum9
                                                                      and _NFActiveSaida.docnum9                = _NFActive.docnum9
                                                                      and _NFActiveSaida.cdv                    = _NFActive.cdv
                                                                      and (
                                                                         (
                                                                           _NFActiveSaida.direct                = '1'
                                                                           and _MatDocItemRef.GoodsMovementType = '861'
                                                                         )
                                                                         or(
                                                                           _NFActiveSaida.direct                = '2'
                                                                           and _MatDocItemRef.GoodsMovementType = '101'
                                                                         )
                                                                       )
                                                                      and _NFActiveSaida.cancel                 is initial
  //    left outer join I_BR_NFItem                as _NFItemSaida        on  _NFItemSaida.BR_NotaFiscal = _NFActiveSaida.docnum
  //                                                                      and _NFItemSaida.Material      = _NFItem.Material

    left outer join ekpa                       as _Ekpa               on  _Ekpa.ebeln = _NFItem.PurchaseOrder
                                                                      and _Ekpa.parvw = 'ZU'
    left outer join I_PurchasingDocument       as _PurchasingDocument on _PurchasingDocument.PurchasingDocument = _NFItem.PurchaseOrder
    left outer join ekko                       as _EkkoValPed         on _EkkoValPed.ebeln = _NFItem.PurchaseOrder

  association [0..*] to I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlow  on  _NFDocumentFlow.BR_NotaFiscal = $projection.NumeroDocumento
  //                                                                              and $projection.NotaFiscalItem  = _NFDocumentFlow.BR_NotaFiscalItem

  association [1..1] to ZI_MM_QUANTIDADE               as _Quantidade      on  _Quantidade.NumeroDocumento     = $projection.NumeroDocumento
                                                                           and _Quantidade.NumeroDocumentoItem = $projection.NumeroDocumentoItem
  association [1..1] to ZI_MM_LOCAL_NEGOCIO_ORIGEM     as _LocNegOrigem    on  _LocNegOrigem.BR_NotaFiscal = $projection.NumeroDocumento
  association [1..1] to ZI_MM_LOCAL_NEGOCIO_DEST       as _LocNegDestino   on  _LocNegDestino.BR_NotaFiscal = $projection.NumeroDocumento
  association [1..1] to ZI_MM_LOCAL_NEGOCIO_RECEB      as _LocNegRecebedor on  _LocNegRecebedor.NotaFiscal = NFBrief.BR_NotaFiscal
  //  association [0..1] to I_BR_NFPartner                 as _LocNegRecebedor on  _LocNegRecebedor.BR_NotaFiscal = $projection.NumeroDocumento
  association [1..1] to ZI_MM_ACCESSKEY2               as _AccessKey       on  _AccessKey.NF = $projection.NumeroDocumento
  association [1..1] to mara                           as _Mara            on  _Mara.matnr = _NFItem.Material
  association [1..1] to marm                           as _Marm            on  _Marm.matnr = _NFItem.Material
                                                                           and _Marm.meinh = _NFItem.BaseUnit
  //  association [0..1] to mkpf                           as _Mkpf            on  _Mkpf.mblnr = $projection.SourceDocument
  //                                                                           and _Mkpf.mjahr = $projection.SourceYear

  association [0..1] to ZI_MM_MAT_DOC                  as _MatDoc          on  _MatDoc.BR_NFSourceDocumentNumber = $projection.BR_NFSourceDocumentNumber

  association [0..1] to I_PurchasingDocumentItem       as _Ekpo            on  _Ekpo.PurchasingDocument     = _NFItem.PurchaseOrder
                                                                           and _Ekpo.PurchasingDocumentItem = _NFItem.PurchaseOrderItem

  association [0..1] to C_BR_VerifyNotaFiscal          as _VerifyNF        on  _VerifyNF.BR_NotaFiscal = $projection.NumeroDocumento

  association [0..1] to I_BR_NFItem                    as _BRNFItem        on  _BRNFItem.BR_NotaFiscal     = NFBrief.BR_NotaFiscal
                                                                           and _BRNFItem.BR_NotaFiscalItem = _NFItem.BR_NotaFiscalItem

  //  association [0..1] to I_MaterialDocumentItem         as _MatDocItem      on  _MatDocItem.MaterialDocument = _NFItem.BR_NFSourceDocumentNumber
  //                                                                           and _MatDocItem.DebitCreditCode  = 'H'



  //association [0..1] to ZI_MM_TRANSF_EKBE              as _Ekbe            on  _Ekbe.PurchaseOrder    = _MatDocItem.PurchaseOrder
  //                                                                        and _Ekbe.PurchaseOrderItem = _MatDocItem.PurchaseOrderItem

{
  key NFBrief.BR_NotaFiscal                                                                    as NumeroDocumento,
  key _NFItem.BR_NotaFiscalItem                                                                as NumeroDocumentoItem,
      NFBrief.BR_NotaFiscal                                                                    as BR_NotaFiscal,
      NFBrief.CompanyCode                                                                      as Empresa,

      case when _MatDoc.PostingDate is null
        then NFBrief.BR_NFPostingDate
        else _MatDoc.PostingDate
      end                                                                                      as DataLancamento,

      case _VerifyNF.BR_NFReceiverType
       when 'B' then _NFItem.Plant
       when 'C' then _Vbap.werks
       else ' '
      end                                                                                      as LocalNegocioOrigem,

      //      case _PurchasingDocument.PurchasingDocumentType
      //        when 'UB'
      //        then _Ekpa.lifn2
      //        else
      //            case _VerifyNF.BR_NFReceiverType
      //             when 'B' then _MatDocItem.IssuingOrReceivingPlant
      //             when 'C' then _EkpoCol.werks // _NFItemSaida.Plant
      //             else ' '
      //             end
      //       end                                                               as LocalNegocioDestino,

      case
        when (_PurchasingDocument.PurchasingDocumentType = 'UB' or _PurchasingDocument.PurchasingDocumentType = 'NB') and (_Ekpa.lifn2 is not initial or _Ekpa.lifn2 is not null)
            then cast( ltrim( _Ekpa.lifn2, '0' ) as werks_d)
        when (_PurchasingDocument.PurchasingDocumentType = 'UB' or _PurchasingDocument.PurchasingDocumentType = 'NB') and (_Ekpa.lifn2 is initial or _Ekpa.lifn2 is null )  and _VerifyNF.BR_NFReceiverType = 'B' and (_LocalCentroDestino.IssuingOrReceivingPlant is not initial or _LocalCentroDestino.IssuingOrReceivingPlant is not null)
            then cast( ltrim( _LocalCentroDestino.IssuingOrReceivingPlant, '0' ) as werks_d)
//        when _VerifyNF.BR_NFReceiverType = 'B' and (_MatDocItem.IssuingOrReceivingPlant is not initial or _MatDocItem.IssuingOrReceivingPlant is not null)
//            then cast(_MatDocItem.IssuingOrReceivingPlant as werks_d)
                    when _VerifyNF.BR_NFReceiverType = 'B' and (_MatDocItem.Plant is not initial or _MatDocItem.Plant is not null)
            then cast(_MatDocItem.Plant as werks_d)
        when _VerifyNF.BR_NFReceiverType = 'C' and (_EkpoCol.werks is not initial or _EkpoCol.werks is not null)
      //then cast(_EkpoCol.werks as werks_d)
            then
                case when length(_EkpoCol.werks) >= 10
                    then cast(substring(_EkpoCol.werks, 7, 4) as werks_d)
                    else cast(_EkpoCol.werks as werks_d) end
        when (_LocalCentroEKPA.lifn2 is not initial or _LocalCentroEKPA.lifn2 is not null)
            then cast(_LocalCentroEKPA.lifn2 as werks_d)
        else cast(' ' as werks_d)
      //            case
      //                when _VerifyNF.BR_NFReceiverType = 'B' and _MatDocItem.IssuingOrReceivingPlant is not initial
      //                    then cast(_MatDocItem.IssuingOrReceivingPlant as werks_d)
      //                when _VerifyNF.BR_NFReceiverType = 'C' and _EkpoCol.werks is not initial
      //                    then cast(_EkpoCol.werks as werks_d)
      //                when _LocalCentroEKPA.lifn2 is not initial and _MatDocItem.IssuingOrReceivingPlant is initial and _EkpoCol.werks is initial
      //                    then cast(_LocalCentroEKPA.lifn2 as werks_d)
      //             else
      //                cast(' ' as werks_d)
      //             end
       end                                                                                     as LocalNegocioDestino,
      _MatDocItemRef.MaterialDocument                                                          as teste1,
      _EkbeDocRef1.belnr                                                                       as teste2,
      case when  ( _MatDocItemRef.MaterialDocument is initial or  _MatDocItemRef.MaterialDocument is null )
      then  concat( _EkbeDocRef1.belnr, _EkbeDocRef1.gjahr )
      else
      concat( _MatDocItemRef.MaterialDocument, _MatDocItemRef.MaterialDocumentYear )
      end                                                                                      as DocRefEntreda1,

      case _VerifyNF.BR_NFReceiverType
      when 'B'
      then concat( _EkbeDocRef.Xblnr, _EkbeDocRef.Gjahr )
      else concat( _VerifyNF.PredecessorReferenceDocument, substring(_VerifyNF.CreationDate, 1, 4 ) )
      end                                                                                      as DocRefEntrada,

      //      case _VerifyNF.BR_NFReceiverType
      //       when 'B'
      //       then _Ekbe.budat
      //       else _NFActiveSaida.credat
      //      end
      //      _MatDocItemRef.DocumentDate                                                              as DataRecebimento,
      //      case _VerifyNF.BR_NFReceiverType
      //       when 'B'
      //       then _Ekbe.budat
      //       when 'C'
      //       then _Ekbe.budat
      //       else _NFActiveSaida.credat
      //      end                                                                                      as DataRecebimento,
      //
      //      case _VerifyNF.BR_NFReceiverType
      //       when 'B'
      //       then _Ekbe.budat
      //       when 'C'
      //       then _Ekbe.budat
      //       else _NFActiveSaida.credat
      //      end                                                                                      as DataRecebimento1,

      case when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType ='C') and _Ekbe.budat is not initial and _Ekbe.budat is not null
           then _Ekbe.budat
           when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType ='C') and (_Ekbe.budat is initial or _Ekbe.budat is null)
           then _MatDocItemRef.DocumentDate
           else _NFActiveSaida.credat
      end                                                                                      as DataRecebimento,

      case when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType ='C') and _Ekbe.budat is not initial and _Ekbe.budat is not null
           then _Ekbe.budat
           when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType ='C') and (_Ekbe.budat is initial or _Ekbe.budat is null)
           then _MatDocItemRef.DocumentDate
           else _NFActiveSaida.credat
      end                                                                                      as DataRecebimento1,

      case when ( _MatDocItemRef.GoodsMovementType = '861' or _MatDocItemRef.GoodsMovementType = '101') and _VerifyNF.BR_NFReceiverType = 'C'
           then ''
           when _VerifyNF.BR_NFReceiverType = 'B'
           then case when _Ekbe.budat is null
                     then 'P'
                     else '' end
           else case when _NFActiveSaida.credat is null
                     then 'P'
                     else '' end
      end                                                                                      as Status,

      _NFItem.BR_CFOPCode                                                                      as CFOP,
      _VerifyNF.CreationDate                                                                   as DataDocumento,
      cast( _VerifyNF.CreationDate as dats )                                                   as DataDocumento1,
      _NFItem.Material                                                                         as Material,
      NFBrief.BR_NFeNumber                                                                     as NumeroNf,
      _NFItem.MaterialName                                                                     as DescricaoMaterial,
      cast(_NFItem.QuantityInBaseUnit as abap.dec(13,3))                                       as Quantidade1,
      _NFItem.BaseUnit                                                                         as BaseUnit,
      fltp_to_dec( cast(_NFItem.QuantityInBaseUnit as abap.fltp) *
      cast(_Marm.umrez as abap.fltp)  *   cast(_Mara.ntgew as abap.fltp) as abap.dec( 13, 3 )) as Quantidade2,
      //NFBrief.HeaderWeightUnit                                           as UnidadePeso,
      case
        when NFBrief.HeaderWeightUnit is initial
        then _Mara.gewei
        else NFBrief.HeaderWeightUnit
        end                                                                                    as UnidadePeso,


      //      case _VerifyNF.BR_NFReceiverType
      //       when 'B'
      //       then dats_days_between(_VerifyNF.CreationDate,_Ekbe.budat)
      //       else dats_days_between(_VerifyNF.CreationDate,_NFActiveSaida.credat)
      //      end                                                                                      as Dias,

      case
       when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType = 'C') and ( _Ekbe.budat is not initial or _Ekbe.budat is not null )
       then dats_days_between(_VerifyNF.CreationDate,_Ekbe.budat)
       when (_VerifyNF.BR_NFReceiverType = 'B' or _VerifyNF.BR_NFReceiverType = 'C') and ( _Ekbe.budat is initial or _Ekbe.budat is null ) and ( _MatDocItemRef.DocumentDate is not initial or _MatDocItemRef.DocumentDate is not null )
       then dats_days_between(_VerifyNF.CreationDate,_MatDocItemRef.DocumentDate)
       when (_VerifyNF.BR_NFReceiverType <> 'B' and _VerifyNF.BR_NFReceiverType <> 'C')  and ( _NFActiveSaida.credat is not initial or _NFActiveSaida.credat is not null )
       then dats_days_between(_VerifyNF.CreationDate,_NFActiveSaida.credat)
       else dats_days_between(_VerifyNF.CreationDate, $session.system_date)
      end                                                                                      as Dias,

      _NFItem.BR_NFSourceDocumentNumber,

      _NFItem.PurchaseOrder,
      _NFItem.PurchaseOrderItem,

      case when _MatDocItemRef.ReversalGoodsMovementType is not null
           then _MatDocItemRef.ReversalGoodsMovementType
           else cast( '' as bwart ) end                                                        as ReversalGoodsMovementType,

      _LocNegOrigem,
      _LocNegDestino,
      _LocNegRecebedor,
      _AccessKey,
      _Mara,
      _Marm,
      _MatDoc,
      _Ekpo,
      _VerifyNF,
      _BRNFItem
}
where
               NFBrief.BR_NFDirection             =  '2'
  and          NFBrief.BR_NFeDocumentStatus       =  '1'
  and          NFBrief.BR_NFIsCanceled            <> 'X'
  and          NFBrief.BR_NFType                  <> 'ZF'
  and          _VerifyNF1.BR_NFReceiverType       <> 'V'
  and(
    (
               _NFItem.PurchaseOrder              is not initial
      and(
               //       _EkkoValPed.bsart                  =  'NB'
               _EkkoValPed.bsart                  =  'UB'
        or     _EkkoValPed.bsart                  =  'ZCOL'
        or     _EkkoValPed.bsart                  =  'ZDF'
        or     _EkkoValPed.bsart                  =  'ZINT'
      )
    )
    or(
               _VerifyNF1.OriginReferenceDocument is not initial
      and(
               _VerifyNF1.BR_NFReceiverType       <> 'C'
        or(
               _VerifyNF1.BR_NFReceiverType       =  'C'
          and(
               // _VBAk_ekko.bsart                   =  'NB'
               _VBAk_ekko.bsart                   =  'UB'
            or _VBAk_ekko.bsart                   =  'ZCOL'
            or _VBAk_ekko.bsart                   =  'ZDF'
            or _VBAk_ekko.bsart                   =  'ZINT'
          )
        )
      )
    )
  )

group by
  NFBrief.BR_NotaFiscal,
  _NFItem.BR_NotaFiscalItem,
  NFBrief.BR_NotaFiscal,
  NFBrief.CompanyCode,
  _MatDoc.PostingDate,
  NFBrief.BR_NFPostingDate,
  _VerifyNF.BR_NFReceiverType,
  _NFItem.Plant,
  _Vbap.werks,
  _PurchasingDocument.PurchasingDocumentType,
  _Ekpa.lifn2,
  _LocalCentroDestino.IssuingOrReceivingPlant,
  _VerifyNF.BR_NFReceiverType,
  _MatDocItem.IssuingOrReceivingPlant,
  _EkpoCol.werks,
  _VerifyNF.BR_NFReceiverType,
  _EkbeDocRef.Xblnr,
  _EkbeDocRef.Gjahr,
  _EkbeDocRef1.belnr,
  _EkbeDocRef1.gjahr,
  _VerifyNF.PredecessorReferenceDocument,
  _VerifyNF.BR_NFReceiverType,
  _Ekbe.budat,
  _NFActiveSaida.credat,
  _VerifyNF.BR_NFReceiverType,
  _Ekbe.budat,
  _NFActiveSaida.credat,
  _VerifyNF.BR_NFReceiverType,
  _Ekbe.budat,
  _NFActiveSaida.credat,
  _NFItem.BR_CFOPCode,
  _VerifyNF.CreationDate,
  _NFItem.Material,
  NFBrief.BR_NFeNumber,
  _NFItem.MaterialName,
  _NFItem.QuantityInBaseUnit,
  _NFItem.BaseUnit,
  _NFItem.QuantityInBaseUnit,
  _Marm.umrez,
  _Mara.ntgew,
  NFBrief.HeaderWeightUnit,
  _Mara.gewei,
  NFBrief.BR_NFIssueDate,
  _NFItem.BR_NFSourceDocumentNumber,
  _NFItem.PurchaseOrder,
  _NFItem.PurchaseOrderItem,
  _LocalCentroEKPA.lifn2,
  _MatDocItemRef.MaterialDocument,
  _MatDocItemRef.MaterialDocumentYear,
  _MatDocItemRef.DocumentDate,
  _MatDocItemRef.GoodsMovementType,
  _MatDocItemRef.ReversalGoodsMovementType,
  _MatDocItem.Plant
