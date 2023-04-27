@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Fiscal GRC'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_mm_relatorio_fiscal_grc
  as select from    I_BR_NFDocument         as _document
    inner join      I_BR_NFItem             as _item            on _item.BR_NotaFiscal = _document.BR_NotaFiscal
    inner join      ZI_MM_CHAVE_NFE         as _chave           on _chave.docnum = _document.BR_NotaFiscal

    left outer join I_BR_NFDocumentFlow_C   as _documentFlow    on  _documentFlow.BR_NotaFiscal     = _item.BR_NotaFiscal
                                                                and _documentFlow.BR_NotaFiscalItem = _item.BR_NotaFiscalItem
    left outer join I_PurchaseOrderAPI01    as _purchaseOrder   on _purchaseOrder.PurchaseOrder = _item.PurchaseOrder
    left outer join I_SupplierInvoiceAPI01  as _supplierInvoice on  _supplierInvoice.SupplierInvoice = _document.SupplierInvoice
                                                                and _supplierInvoice.FiscalYear      = _document.BR_NFFiscalYear
    inner join      /xnfe/innfehd           as _innfehd         on _innfehd.nfeid = _chave.chaveNFE
  //    left outer join ZI_MM_ATIVIDADE        as _ATIV            on _innfehd.nfeid = _ATIV.Nfeid
    left outer join /xnfe/innfeit           as _innfeit         on  _innfeit.guid_header = _innfehd.guid_header
                                                                and _innfeit.nitem       = _item.BR_NFExternalItemNumber
  //    left outer join ZI_MM_INNFHIST_DATA    as _hist            on _innfehd.guid_header = _hist.guid_header
    left outer join ZI_MM_INVENTARIO_ETAPAS as _hist            on _innfehd.guid_header = _hist.guid_header

    left outer join ZI_MM_NFDATES           as _dates           on _innfehd.guid_header = _dates.guid_header
    left outer join /xnfe/procstept         as _step            on  _hist.procstep = _step.procstep
                                                                and _step.langu    = $session.system_language

  //    left outer join /xnfe/events           as _events          on _events.chnfe = _innfehd.nfeid
  //    left outer join /xnfe/event_stat       as _event_stat      on  _event_stat.guid       = _events.guid
  //                                                               and _event_stat.proctyp    = _events.proctyp
  //                                                               and _event_stat.procstep   = _events.last_step
  //                                                               and _event_stat.stepstatus = _events.last_step_status
  //    left outer join /xnfe/event_hist       as _event_hist      on  _event_hist.guid       = _event_stat.guid
  //                                                               and _event_hist.proctyp    = _event_stat.proctyp
  //                                                               and _event_hist.procstep   = _event_stat.procstep
  //                                                               and _event_hist.stepstatus = _event_stat.stepstatus
  //    left outer join /xnfe/nfeit            as _nfeit           on  _nfeit.docnum = _item.BR_NotaFiscal
  //                                                               and _nfeit.itmnum = _item.BR_NotaFiscalItem

{
  key       _document.BR_NotaFiscal,
  key       _item.BR_NotaFiscalItem,
  key       _hist.description                                                                                                               as proctyp,
            _document.BR_NFIsCreatedManually,
            _document.BR_NFPostingDate,
            _document.BR_NFIssueDate,
            _document.BR_NFNumber,
            _document.BR_NFeNumber,
            _item.Material,
            _item.MaterialName,
            _item.BR_CFOPCode,
            _document.CompanyCode,
            _document.BusinessPlace,
            _item.Plant,
            _document.BR_NFPartnerType,
            _document.BR_NFPartner,
            _document.BR_NFPartnerName1,
            _document.BR_NFPartnerRegionCode,
            _document.BR_NFPartnerTaxJurisdiction,
            _document.BR_NFType,
            _document.BR_NFPartnerCNPJ,
            _documentFlow.OriginReferenceDocument,
            _purchaseOrder.PurchasingGroup,
            _purchaseOrder.CreatedByUser,
            _supplierInvoice.SupplierPostingLineItemText,
            _document.AccountingDocument,
            _innfeit.ncm,
            //      ''                                                                                                                              as ncm,
            cast(left(cast(_innfehd.createtime as abap.char( 23 ) ), 8) as abap.dats)                                                       as dsaient,
            tstmp_to_tims( cast(_innfehd.createtime as timestamp), abap_system_timezone( $session.client,'NULL' ), $session.client, 'NULL') as createtime,
            //      case _hist.procstep when 'COMPLETE' then 'Concluído'
            //                          else case _step.description when ' ' then _hist.procstep
            //                               else _step.description end end as proctyp,
            //      _step.description                                                                                                               as proctyp,
            //      _ATIV.description                                                                                                               as proctyp,
            //      _hist.createtime                                                                                                                as histCreatetime,
            tstmp_to_dats(cast(_hist.createtime as tzntstmps) ,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL') as DateCreatetime,
            tstmp_to_tims(cast(_hist.createtime as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' ) as HoraCreatetime,
            _hist.username,
            //      _event_stat.proctyp,
            //      _event_hist.createtime                                                                                                          as histCreatetime,
            //      _event_hist.username,
            case when _dates.createtime is not initial
            then dats_days_between(_dates.createtime,_dates.histcreatetime)
            else 0
            end                                                                                                                             as quantidadeDias,
            _innfeit.cprod

}
where
  _document.CreatedByUser = 'SVC-JOB-USER'
