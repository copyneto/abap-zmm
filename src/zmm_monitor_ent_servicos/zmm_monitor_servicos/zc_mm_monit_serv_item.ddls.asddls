@EndUserText.label: 'Item Monitor de Serviço'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_MONIT_SERV_ITEM
  as projection on ZI_MM_MONIT_SERV_ITEM
{
      @EndUserText.label: 'Empresa'
  key Empresa,
      @EndUserText.label: 'Filial/centro'
  key Filial,
      @EndUserText.label: 'Fornecedor'
  key Lifnr,
      @EndUserText.label: 'N° da NF'
  key NrNf,
      @EndUserText.label: 'Nº Doc. Compras'
  key NrPedido,
      @EndUserText.label: 'Nº Item Compras'
  key ItmPedido,
//      NrNf2,
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: ['WerksText']
      Werks,
      @EndUserText.label: 'Conta contábil'
      CntContb,
      @EndUserText.label: 'IVA'
      Iva,
      @EndUserText.label: 'Categoria da NF'
      CtgNf,
      @EndUserText.label: 'CFOP'
      Cfop,
      @EndUserText.label: 'Direito fiscal ICMS'
      CstIcms,
      @EndUserText.label: 'Direito fiscal IPI'
      CstIpi,
      @EndUserText.label: 'Direito fiscal PIS'
      CstPis,
      @EndUserText.label: 'Direito fiscal COFINS'
      CstCofins,
      @EndUserText.label: 'Material'
      @ObjectModel.text.element: ['MatnrText']
      Matnr,
      @EndUserText.label: 'LC'
      Lc,
      @EndUserText.label: 'Qtd. Pedido'
      Qtdade,
      @EndUserText.label: 'Qtd. Lançamento'
      Qtdade_Lcto,
      @EndUserText.label: 'Valor do item'
      VlUnit,
      @EndUserText.label: 'Total do item'
      VlTotUn,
      @EndUserText.label: 'Centro de custo'
      CentroCust,
      Unid,
      _Matnr.Text          as MatnrText,
      _Werks.WerksCodeName as WerksText,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      Currency,
      /* Associations */
      _Header : redirected to parent ZC_MM_MONIT_SERV_HEADER,
      _Matnr,
      _Werks
}
