@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados para Redeterminação CST'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_DADOS_NF_REDETERM
  as select from I_BR_NFItem as _NFItem

  association [0..1] to I_PurchaseOrderItem as _PurchaseOrderItem on  _PurchaseOrderItem.PurchaseOrder     = $projection.ebeln
                                                                  and _PurchaseOrderItem.PurchaseOrderItem = $projection.ebelp
{
  key _NFItem.BR_NotaFiscal                                    as docnum,
  key _NFItem.BR_NotaFiscalItem                                as itmnum,

      _NFItem.PurchaseOrder                                    as ebeln,
      _NFItem.PurchaseOrderItem                                as ebelp,

      _PurchaseOrderItem._PurchaseOrder.PurchasingOrganization as ekorg,
      _NFItem.Plant                                            as werks,
      _NFItem._BR_NotaFiscal.BR_NFPartner                      as lifnr,
      _NFItem.Material                                         as matnr,
      _PurchaseOrderItem.AccountAssignmentCategory             as knttp,
      _NFItem.GLAccount                                        as sakto,
      _NFItem.BR_CFOPCode                                      as cfop
}
where
  _NFItem._BR_NotaFiscal.BR_NFDirection = '1' -- Entrada
