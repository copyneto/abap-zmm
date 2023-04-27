@EndUserText.label: 'Saldo de Remessa'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_RELAT_SALDO_REMESSA
  as projection on ZI_MM_RELAT_SALDO_REMESSA
{
  key     Rsnum,
  key     Rspos,
          @ObjectModel.text.element: ['DescMat']
          Matnr,
          @EndUserText.label: 'Pedido'
          Ebeln,
          Ebelp,
          @ObjectModel.text.element: ['DescWerks']
          Werks,
          @ObjectModel.text.element: ['Name']
          Lifnr,
          Vbeln,
          Lfimg,
          Meins,
          @Semantics.quantity.unitOfMeasure: 'Meins'
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRT_SALDO_REMESSA' }
  virtual SaldoNew : menge_d,
          @EndUserText.label: 'Pedido Novo'
          PedNv,
          QtdNova,
          _Lfa1.name1          as Name,
          _Makt.maktx          as DescMat,
          _Werks.WerksCodeName as DescWerks,
          BAUGR,
          Saldo                as Saldo,
          
          /* Associations */
          _Lfa1,
          _Makt,
          _Werks,
          _Fltr
}
