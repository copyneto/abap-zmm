@EndUserText.label: 'Projection Rel Terceiro Retorno'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_MM_REL_TERC_RET as projection on ZI_MM_REL_TERC_RET {
    key Empresa,
    @ObjectModel.text.element: ['DescFornecedor']
    key BusinessPartner,    
//     @ObjectModel.text.element: ['DescMaterial']
    key Material,
    key NfItem,
    key DocnumRetorno,
    key TipoImposto,
    DescFornecedor,
    ValorItem,
    CfopRetorno,
    Movimento,
    NFRetorno,
    DataRetorno,
    DocMaterial,
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
