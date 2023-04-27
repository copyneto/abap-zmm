@AbapCatalog.sqlViewName: 'ZMM_REL_UNION'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS UNION'
define view ZI_MM_REL_TERC_UNION

//  as select from           ZI_MM_REL_TERC_MAIN as _Main
//    inner join             ZI_MM_REL_TERC_REM  as _Remessa on  _Remessa.Empresa         = _Main.Empresa
//                                                           and _Remessa.BusinessPartner = _Main.CodFornecedor
//                                                           and _Remessa.Material        = _Main.Material
//                                                           and _Remessa.LocalNegocios   = _Main.LocalNegocio
 as select from  ZI_MM_REL_TERC_REM  as _Remessa                                                           
                                                           
                                                           
//                                                           and (
//                                                              _Remessa.TipoImposto      = 'ICM1'
//                                                              or _Remessa.TipoImposto   = 'ICM2'
//                                                              or _Remessa.TipoImposto   = 'ICM3'
//                                                              or _Remessa.TipoImposto   = 'ICM0'
//                                                              or _Remessa.TipoImposto   = 'ICM4'
//                                                            )

    left outer to one join ZI_MM_REL_TERC_RET  as _Retorno on  _Retorno.Empresa         = _Remessa.Empresa
                                                           and _Retorno.BusinessPartner = _Remessa.BusinessPartner
                                                           and _Retorno.Material        = _Remessa.Material
                                                           and _Retorno.TipoImposto     = _Remessa.TipoImposto
                                                           and _Retorno.DocRef          = ltrim(
      _Remessa.DocnumRemessa, '0'
    )
{

//  key _Main.Empresa,
//  key _Main.CodFornecedor,
//  key _Main.Material,
//  key _Main.LocalNegocio,
//  
  key _Remessa.Empresa,
  key _Remessa.CodFornecedor,
  key _Remessa.Material,
  key _Remessa.LocalNegocio,
  
  key _Remessa.Centro,
  key _Remessa.DocnumRemessa,
  key _Remessa.NfItem             as NfItemRM,
  key _Retorno.DocnumRetorno,
  key _Retorno.NfItem,
      _Remessa.TipoImposto        as TipoImpostoRM,
      _Retorno.TipoImposto,
      
//      _Main.DescEmpresa,
//      _Main.DescFornecedor,
//      _Main.DescMaterial,
      
      _Remessa.DescEmpresa,
      _Remessa.DescFornecedor,
      _Remessa.DescMaterial,
     
      _Remessa.CodFornecedor      as CodFornecedorRM,
      _Remessa.DescFornecedor     as DescFornecedorRM,
      _Remessa.ValorItem          as ValorItemRM,
      _Remessa.CfopRemessa,
      _Remessa.Movimento          as MovimentoRM,
      _Remessa.NFRemessa,
      _Remessa.DataRemessa,
      _Remessa.MaterialMovement,
      _Remessa.CodMaterial        as CodMaterialRM,
      _Remessa.DescMaterial       as DescMaterialRM,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRM'
      _Remessa.Qtde               as QtdeRM,
      _Remessa.UnidMedida         as UnidMedidaRM,
      _Remessa.Moeda              as MoedaRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.ValorTotal         as ValorTotalRM,
      _Remessa.Deposito           as DepositoRM,
      _Remessa.Lote               as LoteRM,
      _Remessa.Ncm                as NcmRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno   as MontBasicRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno2  as MontBasicRetornoRM2,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno3  as MontBasicRetornoRM3,
      _Remessa.TaxaRetorno        as TaxaRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.IcmsRetorno        as IcmsRetornoRM,
      _Retorno.CodFornecedorRT    as CodFornecedorRT,
      _Retorno.DescFornecedor     as DescFornecedorRT,
      _Retorno.ValorItem          as ValorItemRT,
      _Retorno.CfopRetorno,
      _Retorno.Movimento          as MovimentoRT,
      _Retorno.NFRetorno,
      _Retorno.DataRetorno,
      _Retorno.DocMaterial,
      _Retorno.CodMaterial        as CodMaterialRT,
      _Retorno.DescMaterial       as DescMaterialRT,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRT'
      //_Retorno.Qtde               as QtdeRT,
      _Retorno.QtdeRT,
      _Retorno.UnidMedida         as UnidMedidaRT,
      _Retorno.Moeda              as MoedaRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.ValorTotal         as ValorTotalRT,
      _Retorno.Deposito           as DepositoRT,
      _Retorno.Lote               as LoteRT,
      _Retorno.Ncm                as NcmRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno2,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno3,
      //      @Semantics.amount.currencyCode: 'MoedaRT'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CDS_REMRET'
      //      cast( 0 as abap.curr(15,2)) as MontBasicRetornoRT,
      _Retorno.TaxaRetorno        as TaxaRetornoRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.IcmsRetorno        as IcmsRetornoRT,
      cast( '' as abap.char(12) ) as Status,
      _Remessa.DiasAberto,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRM,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRT,
      case
      when _Retorno.QtdeRT is not null
      then (_Remessa.QtdeRM - _Retorno.QtdeRT )
      else _Remessa.QtdeRM end    as SaldoFornecedor,
      cast( '' as abap.char(12) ) as NumSerie,
      _Remessa.Operacao           as Operacao,
      _Remessa.Regio              as Regio,
      _Remessa.DataDocumentoRM,
      _Remessa.DataLancamentoRM,
      _Remessa.PedidoSub,
      _Remessa.Iva,
      _Remessa.CategoriaNFE,
      _Remessa.GrupoCompra,
      _Remessa.GrupoMercado,
      _Retorno.DataDocumentoRT,
      _Retorno.DataLancamentoRT
}
where
  _Remessa.Operacao = '2'

group by
  _Remessa.Empresa,
  _Remessa.CodFornecedor,
  _Remessa.Material,
  _Remessa.LocalNegocio,
  _Remessa.Centro,
  _Remessa.NfItem,
  _Remessa.DocnumRemessa,
  _Remessa.TipoImposto,
  _Retorno.NfItem,
  _Retorno.DocnumRetorno,
  _Retorno.TipoImposto,
  _Remessa.DescEmpresa,
  _Remessa.DescFornecedor,
  _Remessa.DescMaterial,
  _Remessa.CodFornecedor,
  _Remessa.DescFornecedor,
  _Remessa.ValorItem,
  _Remessa.CfopRemessa,
  _Remessa.Movimento,
  _Remessa.NFRemessa,
  _Remessa.DataRemessa,
  _Remessa.MaterialMovement,
  _Remessa.CodMaterial,
  _Remessa.DescMaterial,
  _Remessa.Qtde,
  _Remessa.UnidMedida,
  _Remessa.Moeda,
  _Remessa.ValorTotal,
  _Remessa.Deposito,
  _Remessa.Lote,
  _Remessa.Ncm,
  _Remessa.MontBasicRetorno,
  _Remessa.MontBasicRetorno2,
  _Remessa.MontBasicRetorno3,
  _Remessa.TaxaRetorno,
  _Remessa.IcmsRetorno,
  _Retorno.CodFornecedorRT,
  _Retorno.DescFornecedor,
  _Retorno.ValorItem,
  _Retorno.CfopRetorno,
  _Retorno.Movimento,
  _Retorno.NFRetorno,
  _Retorno.DataRetorno,
  _Retorno.DocMaterial,
  _Retorno.CodMaterial,
  _Retorno.DescMaterial,
  _Retorno.Qtde,
  _Retorno.UnidMedida,
  _Retorno.Moeda,
  _Retorno.ValorTotal,
  _Retorno.Deposito,
  _Retorno.Lote,
  _Retorno.Ncm,
  _Retorno.MontBasicRetorno,
  _Retorno.MontBasicRetorno2,
  _Retorno.MontBasicRetorno3,
  _Retorno.TaxaRetorno,
  _Retorno.IcmsRetorno,
  _Remessa.DiasAberto,
  _Remessa.QtdeRM,
  _Retorno.QtdeRT,
  _Remessa.Operacao,
  _Remessa.Regio,
  _Remessa.DataDocumentoRM,
  _Remessa.DataLancamentoRM,
  _Remessa.PedidoSub,
  _Remessa.Iva,
  _Remessa.CategoriaNFE,
  _Remessa.GrupoCompra,
  _Remessa.GrupoMercado,
  _Retorno.DataDocumentoRT,
  _Retorno.DataLancamentoRT
  
  
//***************************************************************************  
//union select from        ZI_MM_REL_TERC_MAIN as _Main
//  inner join             ZI_MM_REL_TERC_REM  as _Remessa on  _Remessa.Empresa         = _Main.Empresa
//                                                             and _Remessa.BusinessPartner = _Main.CodFornecedor
//                                                         and _Remessa.Material        = _Main.Material
//                                                         and _Remessa.LocalNegocios   = _Main.LocalNegocio
union select from ZI_MM_REL_TERC_REM  as _Remessa 

//                                                         and (
//                                                            _Remessa.TipoImposto      = 'ICM1'
//                                                            or _Remessa.TipoImposto   = 'ICM2'
//                                                            or _Remessa.TipoImposto   = 'ICM3'
//                                                            or _Remessa.TipoImposto   = 'ICM0'
//                                                            or _Remessa.TipoImposto   = 'ICM4'
//                                                          )

  //left outer to one join ZI_MM_REL_TERC_RET2 as _Retorno on  (_Retorno.Material    = _Remessa.Material or (_Retorno.Material <> _Remessa.Material and _Retorno.MaterialRemessa = _Remessa.Material))  
  //                                                       and _Retorno.DocRef        = _Remessa.DocnumRemessa  
  left outer to one join ZI_MM_REL_TERC_RET2 as _Retorno on  _Retorno.Material      = _Remessa.Material
                                                         and _Retorno.DocRef        = _Remessa.DocnumRemessa
                                                         
//                                                         and (
//                                                            _Retorno.TipoImposto    = 'ICM1'
//                                                            or _Retorno.TipoImposto = 'ICM2'
//                                                            or _Retorno.TipoImposto = 'ICM3'
//                                                            or _Remessa.TipoImposto = 'ICM0'
//                                                            or _Remessa.TipoImposto = 'ICM4'
//                                                          )

{

//  key _Main.Empresa,
//  key _Main.CodFornecedor,
//  key _Main.Material,
//  key _Main.LocalNegocio,
  
  key _Remessa.Empresa,
  key _Remessa.CodFornecedor,
  key _Remessa.Material,
  key _Remessa.LocalNegocio,
  
  key _Remessa.Centro,
  key _Remessa.DocnumRemessa,
  key _Remessa.NfItem             as NfItemRM,
  key _Retorno.DocnumRetorno,
  key _Retorno.NfItem,
      _Remessa.TipoImposto        as TipoImpostoRM,
      _Retorno.TipoImposto,
      
//      _Main.DescEmpresa,
//      _Main.DescFornecedor,
//      _Main.DescMaterial,
      _Remessa.DescEmpresa,
      _Remessa.DescFornecedor,
      _Remessa.DescMaterial,
      _Remessa.CodFornecedor      as CodFornecedorRM,
      _Remessa.DescFornecedor     as DescFornecedorRM,
      _Remessa.ValorItem          as ValorItemRM,
      _Remessa.CfopRemessa,
      _Remessa.Movimento          as MovimentoRM,
      _Remessa.NFRemessa,
      _Remessa.DataRemessa,
      _Remessa.MaterialMovement,
      _Remessa.CodMaterial        as CodMaterialRM,
      _Remessa.DescMaterial       as DescMaterialRM,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRM'
      _Remessa.Qtde               as QtdeRM,
      _Remessa.UnidMedida         as UnidMedidaRM,
      _Remessa.Moeda              as MoedaRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.ValorTotal         as ValorTotalRM,
      _Remessa.Deposito           as DepositoRM,
      _Remessa.Lote               as LoteRM,
      _Remessa.Ncm                as NcmRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno   as MontBasicRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno2  as MontBasicRetornoRM2,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno3  as MontBasicRetornoRM3,
      _Remessa.TaxaRetorno        as TaxaRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.IcmsRetorno        as IcmsRetornoRM,
      _Retorno.CodFornecedorRT    as CodFornecedorRT,
      _Retorno.DescFornecedor     as DescFornecedorRT,
      _Retorno.ValorItem          as ValorItemRT,
      _Retorno.CfopRetorno,
      _Retorno.Movimento          as MovimentoRT,
      _Retorno.NFRetorno,
      _Retorno.DataRetorno,
      _Retorno.DocMaterial,
      _Retorno.CodMaterial        as CodMaterialRT,
      _Retorno.DescMaterial       as DescMaterialRT,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRT'
      //_Retorno.Qtde               as QtdeRT,
      _Retorno.QtdeRT,
      _Retorno.UnidMedida         as UnidMedidaRT,
      _Retorno.Moeda              as MoedaRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.ValorTotal         as ValorTotalRT,
      _Retorno.Deposito           as DepositoRT,
      _Retorno.Lote               as LoteRT,
      _Retorno.Ncm                as NcmRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno2,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno3,
      //      @Semantics.amount.currencyCode: 'MoedaRT'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CDS_REMRET'
      //      cast( 0 as abap.curr(15,2)) as MontBasicRetornoRT,
      _Retorno.TaxaRetorno        as TaxaRetornoRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.IcmsRetorno        as IcmsRetornoRT,
      cast( '' as abap.char(12) ) as Status,
      _Remessa.DiasAberto,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRM,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRT,
      case
      when _Retorno.QtdeRT is not null
      then (_Remessa.QtdeRM - _Retorno.QtdeRT )
      else _Remessa.QtdeRM end    as SaldoFornecedor,
      cast( '' as abap.char(12) ) as NumSerie,
      _Remessa.Operacao           as Operacao,
      _Remessa.Regio,
      _Remessa.DataDocumentoRM,
      _Remessa.DataLancamentoRM,
      _Remessa.PedidoSub,
      _Remessa.Iva,
      _Remessa.CategoriaNFE,
      _Remessa.GrupoCompra,  
      _Remessa.GrupoMercado,
      _Retorno.DataDocumentoRT,
      _Retorno.DataLancamentoRT

}
where
  _Remessa.Operacao = '1'
  or _Remessa.Operacao = '4' 
group by
//  _Main.Empresa,
//  _Main.CodFornecedor,
//  _Main.Material,
//  _Main.LocalNegocio,
  _Remessa.Empresa,
  _Remessa.CodFornecedor,
  _Remessa.Material,
  _Remessa.LocalNegocio,
  
  _Remessa.Centro,
  _Remessa.NfItem,
  _Remessa.DocnumRemessa,
  _Remessa.TipoImposto,
  _Retorno.NfItem,
  _Retorno.DocnumRetorno,
  _Retorno.TipoImposto,
  
  _Remessa.DescEmpresa,
  _Remessa.DescFornecedor,
  _Remessa.DescMaterial,
  
//  _Main.DescEmpresa,
//  _Main.DescFornecedor,
//  _Main.DescMaterial,
  
  _Remessa.CodFornecedor,
  _Remessa.DescFornecedor,
  _Remessa.ValorItem,
  _Remessa.CfopRemessa,
  _Remessa.Movimento,
  _Remessa.NFRemessa,
  _Remessa.DataRemessa,
  _Remessa.MaterialMovement,
  _Remessa.CodMaterial,
  _Remessa.DescMaterial,
  _Remessa.Qtde,
  _Remessa.UnidMedida,
  _Remessa.Moeda,
  _Remessa.ValorTotal,
  _Remessa.Deposito,
  _Remessa.Lote,
  _Remessa.Ncm,
  _Remessa.MontBasicRetorno,
  _Remessa.MontBasicRetorno2,
  _Remessa.MontBasicRetorno3,
  _Remessa.TaxaRetorno,
  _Remessa.IcmsRetorno,
  _Retorno.CodFornecedorRT,
  _Retorno.DescFornecedor,
  _Retorno.ValorItem,
  _Retorno.CfopRetorno,
  _Retorno.Movimento,
  _Retorno.NFRetorno,
  _Retorno.DataRetorno,
  _Retorno.DocMaterial,
  _Retorno.CodMaterial,
  _Retorno.DescMaterial,
  _Retorno.Qtde,
  _Retorno.UnidMedida,
  _Retorno.Moeda,
  _Retorno.ValorTotal,
  _Retorno.Deposito,
  _Retorno.Lote,
  _Retorno.Ncm,
  _Retorno.MontBasicRetorno,
  _Retorno.MontBasicRetorno2,
  _Retorno.MontBasicRetorno3,
  _Retorno.TaxaRetorno,
  _Retorno.IcmsRetorno,
  _Remessa.DiasAberto,
  _Remessa.QtdeRM,
  _Retorno.QtdeRT,
  _Remessa.Operacao,
  _Remessa.Regio,
  _Remessa.DataDocumentoRM,
  _Remessa.DataLancamentoRM,
  _Remessa.PedidoSub,
  _Remessa.Iva,
  _Remessa.CategoriaNFE,
  _Remessa.GrupoCompra,
  _Remessa.GrupoMercado,
  _Retorno.DataDocumentoRT,
  _Retorno.DataLancamentoRT

//***************************************************************************

//union select from        ZI_MM_REL_TERC_MAIN as _Main
//  inner join             ZI_MM_REL_TERC_REM_3  as _Remessa on  _Remessa.Empresa         = _Main.Empresa
//                                                         and _Remessa.BusinessPartner = _Main.CodFornecedor
//                                                         and _Remessa.Material        = _Main.Material
//                                                         and _Remessa.LocalNegocios   = _Main.LocalNegocio

union select from ZI_MM_REL_TERC_REM_3  as _Remessa
inner join  ZI_MM_REL_TERC_RET3 as _Retorno on  (_Retorno.Material    = _Remessa.Material or (_Retorno.Material <> _Remessa.Material and _Retorno.MaterialRemessa = _Remessa.Material))
//left outer to one join ZI_MM_REL_TERC_RET3 as _Retorno on  (_Retorno.Material    = _Remessa.Material or (_Retorno.MaterialRemessa = _Remessa.Material))
                                                          and _Retorno.DocRef    = _Remessa.DocnumRemessa
                                                          and _Retorno.Material  = _Remessa.CodMaterial
{

//  key _Main.Empresa,
//  key _Main.CodFornecedor,
//  key _Main.Material,
//  key _Main.LocalNegocio,
  
  key _Remessa.Empresa,
  key _Remessa.CodFornecedor,
  key _Remessa.Material,
  key _Remessa.LocalNegocio,
  
  key _Remessa.Centro,
  key _Remessa.DocnumRemessa,
  key _Remessa.NfItem             as NfItemRM,
  key _Retorno.DocnumRetorno,
  key _Retorno.NfItem,
      _Remessa.TipoImposto        as TipoImpostoRM,
      _Retorno.TipoImposto,
      
//      _Main.DescEmpresa,
//      _Main.DescFornecedor,
//      _Main.DescMaterial,
//      
      _Remessa.DescEmpresa,
      _Remessa.DescFornecedor,
      _Remessa.DescMaterial,
      
      _Remessa.CodFornecedor      as CodFornecedorRM,
      _Remessa.DescFornecedor     as DescFornecedorRM,
      _Remessa.ValorItem          as ValorItemRM,
      _Remessa.CfopRemessa,
      _Remessa.Movimento          as MovimentoRM,
      _Remessa.NFRemessa,
      _Remessa.DataRemessa,
      _Remessa.MaterialMovement,
      _Remessa.CodMaterial        as CodMaterialRM,
      _Remessa.DescMaterial       as DescMaterialRM,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRM'
      _Remessa.Qtde               as QtdeRM,
      _Remessa.UnidMedida         as UnidMedidaRM,
      _Remessa.Moeda              as MoedaRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.ValorTotal         as ValorTotalRM,
      _Remessa.Deposito           as DepositoRM,
      _Remessa.Lote               as LoteRM,
      _Remessa.Ncm                as NcmRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno   as MontBasicRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno2  as MontBasicRetornoRM2,
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.MontBasicRetorno3  as MontBasicRetornoRM3,
      _Remessa.TaxaRetorno        as TaxaRetornoRM,
      
      @Semantics.amount.currencyCode: 'MoedaRM'
      _Remessa.IcmsRetorno        as IcmsRetornoRM,
      _Retorno.CodFornecedorRT    as CodFornecedorRT,
      _Retorno.DescFornecedor     as DescFornecedorRT,
      _Retorno.ValorItem          as ValorItemRT,
      _Retorno.CfopRetorno,
      _Retorno.Movimento          as MovimentoRT,
      _Retorno.NFRetorno,
      _Retorno.DataRetorno,
      _Retorno.DocMaterial,
      _Retorno.CodMaterial        as CodMaterialRT,
      _Retorno.DescMaterial       as DescMaterialRT,
      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRT'
      //_Retorno.Qtde               as QtdeRT,
      _Retorno.QtdeRT,
      _Retorno.UnidMedida         as UnidMedidaRT,
      _Retorno.Moeda              as MoedaRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.ValorTotal         as ValorTotalRT,
      _Retorno.Deposito           as DepositoRT,
      _Retorno.Lote               as LoteRT,
      _Retorno.Ncm                as NcmRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno2,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.MontBasicRetorno3,
      _Retorno.TaxaRetorno        as TaxaRetornoRT,
      @Semantics.amount.currencyCode: 'MoedaRT'
      _Retorno.IcmsRetorno        as IcmsRetornoRT,
      cast( '' as abap.char(12) ) as Status,
      _Remessa.DiasAberto,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRM,
      cast( '' as abap.char(12) ) as ContaContabilIcmsRT,
      case
      when _Retorno.QtdeRT is not null
      then (_Remessa.QtdeRM - _Retorno.QtdeRT )
      else _Remessa.QtdeRM end    as SaldoFornecedor,
      cast( '' as abap.char(12) ) as NumSerie,
      _Remessa.Operacao           as Operacao,
      _Remessa.Regio,
      _Remessa.DataDocumentoRM,
      _Remessa.DataLancamentoRM,
      _Remessa.PedidoSub,
      _Remessa.Iva,
      _Remessa.CategoriaNFE,
      _Remessa.GrupoCompra,  
      _Remessa.GrupoMercado,
      _Retorno.DataDocumentoRT,
      _Retorno.DataLancamentoRT

}
where
  _Remessa.Operacao = '3'  
group by
  _Remessa.Empresa,
  _Remessa.CodFornecedor,
  _Remessa.Material,
  _Remessa.LocalNegocio,
  _Remessa.Centro,
  _Remessa.NfItem,
  _Remessa.DocnumRemessa,
  _Remessa.TipoImposto,
  _Retorno.NfItem,
  _Retorno.DocnumRetorno,
  _Retorno.TipoImposto,
  _Remessa.DescEmpresa,
  _Remessa.DescFornecedor,
  _Remessa.DescMaterial,
  _Remessa.CodFornecedor,
  _Remessa.DescFornecedor,
  _Remessa.ValorItem,
  _Remessa.CfopRemessa,
  _Remessa.Movimento,
  _Remessa.NFRemessa,
  _Remessa.DataRemessa,
  _Remessa.MaterialMovement,
  _Remessa.CodMaterial,
  _Remessa.DescMaterial,
  _Remessa.Qtde,
  _Remessa.UnidMedida,
  _Remessa.Moeda,
  _Remessa.ValorTotal,
  _Remessa.Deposito,
  _Remessa.Lote,
  _Remessa.Ncm,
  _Remessa.MontBasicRetorno,
  _Remessa.MontBasicRetorno2,
  _Remessa.MontBasicRetorno3,
  _Remessa.TaxaRetorno,
  _Remessa.IcmsRetorno,
  _Retorno.CodFornecedorRT,
  _Retorno.DescFornecedor,
  _Retorno.ValorItem,
  _Retorno.CfopRetorno,
  _Retorno.Movimento,
  _Retorno.NFRetorno,
  _Retorno.DataRetorno,
  _Retorno.DocMaterial,
  _Retorno.CodMaterial,
  _Retorno.DescMaterial,
  _Retorno.Qtde,
  _Retorno.UnidMedida,
  _Retorno.Moeda,
  _Retorno.ValorTotal,
  _Retorno.Deposito,
  _Retorno.Lote,
  _Retorno.Ncm,
  _Retorno.MontBasicRetorno,
  _Retorno.MontBasicRetorno2,
  _Retorno.MontBasicRetorno3,
  _Retorno.TaxaRetorno,
  _Retorno.IcmsRetorno,
  _Remessa.DiasAberto,
  _Remessa.QtdeRM,
  _Retorno.QtdeRT,
  _Remessa.Operacao,
  _Remessa.Regio,
  _Remessa.DataDocumentoRM,
  _Remessa.DataLancamentoRM,
  _Remessa.PedidoSub,
  _Remessa.Iva,
  _Remessa.CategoriaNFE,
  _Remessa.GrupoCompra,
  _Remessa.GrupoMercado,
  _Retorno.DataDocumentoRT,
  _Retorno.DataLancamentoRT

