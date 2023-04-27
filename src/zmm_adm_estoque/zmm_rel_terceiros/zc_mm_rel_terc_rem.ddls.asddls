@EndUserText.label: 'Projection Rel Terceiro Remessa'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_REL_TERC_REM
  as projection on ZI_MM_REL_TERC_REM
{
  key Empresa,
      @ObjectModel.text.element: ['DescFornecedor']
  key BusinessPartner,
//      @ObjectModel.text.element: ['DescMaterial']
  key Material,
  key NfItem,
  key DocnumRemessa,
  key TipoImposto,
      DescFornecedor,
      ValorItem,
      CfopRemessa,
      Movimento,
      NFRemessa,
      DataRemessa,
//      DocMaterial,
      MaterialMovement,
      DescMaterial,
      Qtde,
      UnidMedida,
      Moeda,
      ValorTotal,
      Deposito,
      Lote,
      Ncm,
      MontBasicRetorno,
      TaxaRetorno,
      IcmsRetorno,

      /* Associations */
      _Main : redirected to parent ZC_MM_REL_TERC
}
