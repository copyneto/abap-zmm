@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Dados MIRO e MIGO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_MIRO_MIGO
  as select from    I_BR_NFItem                 as NFItem
    inner join      I_BR_NFDocument             as _NFDoc on _NFDoc.BR_NotaFiscal = NFItem.BR_NotaFiscal

    left outer join ZI_MM_PURCHASE_HISTORY_MIGO as _MIGO  on  _MIGO.PurchaseOrder     = NFItem.PurchaseOrder
                                                          and _MIGO.PurchaseOrderItem = lpad( NFItem.PurchaseOrderItem, 6, '0' )
                                                          and _MIGO.ReverseDocument   = '' -- Não estornado

    left outer join ZI_MM_PURCHASE_HISTORY_MIRO as _MIRO  on  _MIRO.PurchaseOrder     = NFItem.PurchaseOrder
                                                          and _MIRO.PurchaseOrderItem = lpad( NFItem.PurchaseOrderItem, 6, '0' )
                                                          and _MIRO.ReverseDocument   = '' -- Não estornado
{ 
  key _NFDoc.BR_NotaFiscal                as BR_NotaFiscal,
  key NFItem.BR_NotaFiscalItem            as BR_NotaFiscalItem,
      NFItem.PurchaseOrder                as PurchaseOrder,
      NFItem.PurchaseOrderItem            as PurchaseOrderItem,
      _NFDoc.BR_NFPartnerType             as BR_NFPartnerType,
      NFItem.BR_NFSourceDocumentNumber    as BR_NFSourceDocumentNumber,
      NFItem.BR_NFSourceDocumentItem      as BR_NFSourceDocumentItem,

      _MIGO.BR_NFSourceDocumentNumberYear as AnoMigo,
      _MIGO.BR_NFSourceDocumentNumber     as DocMigo,
      _MIGO.BR_NFSourceDocumentNumberItem as ItemMigo,
      _MIGO.ReverseDocument               as EstornoMigo,

      _MIRO.BR_NFSourceDocumentNumberYear as AnoMiro,
      _MIRO.BR_NFSourceDocumentNumber     as DocMiro,
      _MIRO.BR_NFSourceDocumentNumberItem as ItemMiro,
      _MIRO.ReverseDocument               as EstornoMiro
}
where
      _NFDoc.BR_NFDirection   = '1'
  and _NFDoc.BR_NFPartnerType = 'V'
