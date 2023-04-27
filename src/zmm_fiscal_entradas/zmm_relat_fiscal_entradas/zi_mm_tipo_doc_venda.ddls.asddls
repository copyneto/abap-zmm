@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Tipo Doc.  Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_TIPO_DOC_VENDA
  as select from    I_BR_NFItem             as NFItem
    inner join      I_SDDocumentProcessFlow as _DocumentFlow     on  _DocumentFlow.SubsequentDocument         = NFItem.BR_NFSourceDocumentNumber
                                                                 and _DocumentFlow.SubsequentDocumentCategory = 'C'

    inner join      vbap                    as _SalesOrderItem   on  _SalesOrderItem.vbeln = _DocumentFlow.PrecedingDocument
                                                                 and _SalesOrderItem.posnr = _DocumentFlow.PrecedingDocumentItem

    inner join      I_SalesOrder            as _SalesOrder       on _SalesOrder.SalesOrder = _DocumentFlow.PrecedingDocument

    left outer join ZI_SD_VH_MotivoOrdem    as _DescrMotivoOrdem on _DescrMotivoOrdem.Augru = _SalesOrder.SDDocumentReason
{
  key NFItem.BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem,

      _SalesOrderItem.j_1btxsdc    as CodImposto,

      _SalesOrder.SalesOrderType   as TipoDocVenda,
      _SalesOrder.SDDocumentReason as MotivoOrdem,
      _SalesOrder.SalesOrganization,
      _SalesOrder.DistributionChannel,
      _SalesOrder.OrganizationDivision,
      _SalesOrder.SalesOffice,
      _DescrMotivoOrdem.Text       as DescrMotivoOrdem
}
where
  NFItem._BR_NotaFiscal.BR_NFPartnerType = 'C'
