@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Remove Nftype cadastrado nos parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REMOVE_NFTYPE_PARAM
  as select from    ztmm_control_cla               as control_cla

    inner join      ZI_MM_PurgDocHistory           as _purgdoc    on control_cla.ebeln = _purgdoc.DocumentoCompra

    inner join      I_BR_NFItemDocumentFlowFirst_C as _NFITEMDOC  on _purgdoc.ReferenceDocument = _NFITEMDOC.ReferenceDocument

    inner join      C_BR_VerifyNotaFiscal          as _VERIFYnf   on  _NFITEMDOC.BR_NotaFiscal  = _VERIFYnf.BR_NotaFiscal
                                                                  and _VERIFYnf.BR_NFIsCanceled = ''
    inner join      ZI_MM_CALC_VAL_CORRETAGEM      as _calcvlrcor on  _purgdoc.DocumentoCompra = _calcvlrcor.DocumentoCompra
                                                                  and _NFITEMDOC.BR_NotaFiscal = _calcvlrcor.Docnum
  //left outer
    left outer join ZI_MM_DOCS_COMPENSADOS         as _doccomp    on  _purgdoc.ReferenceDocument = _doccomp.OrigDocument
                                                                  and _doccomp.Conta             = '111023'

    left outer join ztmm_corretagem                as _Corretagem on  _purgdoc.DocumentoCompra = _Corretagem.ebeln
                                                                  and _NFITEMDOC.BR_NotaFiscal = _Corretagem.docnum

    left outer join ZI_MM_PARAM_NF_DEVOL_NFTYPE    as _Param      on _Param.NfType = _VERIFYnf.BR_NFType

  association [0..1] to ZI_MM_VH_STATUS_APURACAO as _StatusApur    on  _StatusApur.Valor = $projection.StatusApuracao

  association [0..1] to ZI_MM_VH_STATUS_COMPENSA as _StatusComp    on  _StatusComp.Valor = $projection.StatusCompensacao

  association [1..1] to I_BR_NFItem              as _NFItem        on  $projection.Docnum        = _NFItem.BR_NotaFiscal
                                                                   and _NFItem.BR_NotaFiscalItem = '000010'

  association [1..1] to I_Supplier               as _FornCorre     on  _FornCorre.Supplier = control_cla.corretora

  association [1..1] to I_Supplier               as _FornCorretor  on  _FornCorretor.Supplier = control_cla.corretor

  association [1..1] to I_Supplier               as _FornEmbar     on  _FornEmbar.Supplier = control_cla.embarcador

  association [0..1] to I_CreatedByUser          as _CreatedByUser on  _CreatedByUser.UserName = $projection.CreatedBy

  association [0..1] to I_ChangedByUser          as _ChangedByUser on  _ChangedByUser.UserName = $projection.LastChangedBy

{
  key control_cla.ebeln                                                                     as DocumentoCompra,
  key _NFITEMDOC.BR_NotaFiscal                                                              as Docnum,
      _purgdoc.Periodo                                                                      as Periodo,
      _purgdoc.Centro                                                                       as Centro,
      _purgdoc.DataEntrada                                                                  as DataEntrada,
      _VERIFYnf.BR_NFPostingDate                                                            as DtEntradaNF,
      control_cla.corretora                                                                 as Corretora,
      control_cla.corretor                                                                  as Corretor,
      _VERIFYnf.BR_NotaFiscal                                                               as DocNF,
      concat(_VERIFYnf.BR_NFeNumber,
             concat('-',_VERIFYnf.BR_NFeSeries))                                            as NrNF,
      _NFItem.SalesDocumentCurrency                                                         as SalesDocumentCurrency,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      _NFItem.NetValueAmount                                                                as ValorTotLiq,
      _NFItem.BaseUnit                                                                      as BaseUnit,
      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      _NFItem.QuantityInBaseUnit                                                            as QuantityInBaseUnit,
      control_cla.perc_corretagem                                                           as PercCorretagem,
      //      fltp_to_dec(_calcvlrcor.ValorCorretagem as abap.dec( 15, 2 ))           as ValorCorretagem,
      //      fltp_to_dec( cast(_NFItem.NetValueAmount as abap.fltp) *
      //                 ( cast( control_cla.perc_corretagem as abap.fltp) /
      //                   cast( 100 as abap.fltp) ) as abap.dec( 15, 2 ))            as ValorCorretagem,

      fltp_to_dec( ( cast(_NFItem.NetValueAmount as abap.fltp) *
                   ( cast( control_cla.perc_corretagem as abap.fltp) /
                     cast( 100.00 as abap.fltp) ) ) as abap.dec( 15, 2 ))
      //                     -
      //                   ( cast(_calcvlrcor.ValorDesconto as abap.fltp ) *
      //                   ( cast( control_cla.perc_corretagem as abap.fltp) /
      //                     cast( 100.00 as abap.fltp) ) ) as abap.dec( 15, 2 ))
                                                                                            as ValorCorretagem,

      control_cla.embarcador                                                                as Embarcador,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      control_cla.prc_unit_embarcador                                                       as PrecoUnitEmb,
      fltp_to_dec(_calcvlrcor.ValorEmbarcador as abap.dec( 15, 2 ))                         as ValorEmbarcador,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      _calcvlrcor.ValorDesconto                                                             as ValorDesconto,

      fltp_to_dec(_calcvlrcor.ValorDevCorretagem as abap.dec( 15, 2 ) )                     as ValorDevCorretagem,


      fltp_to_dec( ( ( cast(_NFItem.NetValueAmount as abap.fltp) *
                     ( cast( control_cla.perc_corretagem as abap.fltp) / cast( 100 as abap.fltp) ) )
      //                       -
      //                     ( cast(_calcvlrcor.ValorDesconto as abap.fltp ) *
      //                     ( cast( control_cla.perc_corretagem as abap.fltp) /
      //                       cast( 100 as abap.fltp) ) ) )
                       +
                       _calcvlrcor.ValorEmbarcador
                       -
                       _calcvlrcor.ValorDevCorretagem
                       -
                       cast(_calcvlrcor.ValorDesconto as abap.fltp) ) as abap.dec( 15, 2 )) as ValorAPagar,


      control_cla.nro_contrato                                                              as NrContrato,
      _VERIFYnf.BR_NFIssuerNameFrmtdDesc                                                    as Fornecedor,
      _Corretagem.obs_apuracao                                                              as Observacao,
      //      _Corretagem.status_apuracao                                           as StatusApuracao,
      case
          when _Corretagem.status_apuracao is initial
          or   _Corretagem.status_apuracao is null then 'P'
          else _Corretagem.status_apuracao
      end                                                                                   as StatusApuracao,

      //      case
      //        when _Corretagem.vlr_desconto is initial
      //          or _Corretagem.vlr_desconto is null
      //         then 'P'
      //         else 'F' end                                                       as StatusApuracao,
      //      case
      //        when _Corretagem.vlr_desconto is initial
      //          or _Corretagem.vlr_desconto is null
      //         then 2
      //         else 3 end                                                         as StatusApurCrityc,
      case
        when _Corretagem.status_apuracao = 'P'
        or   _Corretagem.status_apuracao is initial
        or   _Corretagem.status_apuracao is null
         then 2
         else 3 end                                                                         as StatusApurCrityc,
      //      _doccomp.DocCompensacao                                                 as DocCompensacao,
      case
        when _doccomp.Conta = '111023' then _doccomp.DocCompensacao
         else '' end                                                                        as DocCompensacao,
      //      _doccomp.DataCompensacao                                                as DataCompensacao,
      case
        when _doccomp.Conta = '111023' then _doccomp.DataCompensacao
         else '00000000' end                                                                as DataCompensacao,

      //      _doccomp.DocCompensacao                                                 as StatusCompensacao,
      case
        when _doccomp.Conta = '111023' then 'X'
         else '' end                                                                        as StatusCompensacao,
      case
        when _doccomp.Conta = '111023' then 3
         else 1 end                                                                         as StatusCompCrityc,
      @Semantics.user.createdBy: true
      _Corretagem.created_by                                                                as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Corretagem.created_at                                                                as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Corretagem.last_changed_by                                                           as LastChangedBy,
      _ChangedByUser.UserDescription                                                        as NomeModificador,
      @Semantics.systemDateTime.lastChangedAt: true
      _Corretagem.last_changed_at                                                           as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Corretagem.local_last_changed_at                                                     as LocalLastChangedAt,

      //      _Parametros.Low,
      //      _VERIFYnf.BR_NFType,

      case
        when _Param.NfType is null then 'VAZIO'
        else _Param.NfType
      end                                                                                   as BR_NFType,

      _CreatedByUser,
      _ChangedByUser,
      _FornCorre,
      _FornCorretor,
      _FornEmbar,
      _StatusApur,
      _StatusComp,
      _NFItem
}
where
  control_cla.ebelp = '00010'
//group by
//  control_cla.ebeln,
//  _NFITEMDOC.BR_NotaFiscal,
//  _purgdoc.Periodo,
//  _purgdoc.Centro,
//  _purgdoc.DataEntrada,
//  _VERIFYnf.BR_NFPostingDate,
//  control_cla.corretora,
//  control_cla.corretor,
//  _VERIFYnf.BR_NotaFiscal,
//  _VERIFYnf.BR_NFeNumber,
//  _VERIFYnf.BR_NFeSeries,
//  _NFItem.SalesDocumentCurrency,
//  _NFItem.NetValueAmount,
//  _NFItem.BaseUnit,
//  _NFItem.QuantityInBaseUnit,
//  control_cla.perc_corretagem,
//  _calcvlrcor.ValorDesconto,
//  control_cla.embarcador,
//  control_cla.prc_unit_embarcador,
//  _calcvlrcor.ValorEmbarcador,
//  _calcvlrcor.ValorDevCorretagem,
//  control_cla.nro_contrato,
//  _VERIFYnf.BR_NFIssuerNameFrmtdDesc,
//  _Corretagem.obs_apuracao,
//  _Corretagem.vlr_desconto,
//  _doccomp.DocCompensacao,
//  _doccomp.DataCompensacao,
//  _Corretagem.created_by,
//  _Corretagem.created_at,
//  _Corretagem.last_changed_by,
//  _ChangedByUser.UserDescription,
//  _Corretagem.last_changed_at,
//  _Corretagem.local_last_changed_at,
//  _Param.NfType
