@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Terceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_REL_TERC_AGRUP
  as select from ZI_MM_REL_TERC_UNION
{
  key Empresa,
  key CodFornecedor,
  key Material,
  key LocalNegocio,
  key Centro,
  key DocnumRemessa,
  key NfItemRM,
  key DocnumRetorno,
  key NfItem,
      TipoImpostoRM,
      TipoImposto,
      DescEmpresa,
      DescFornecedor,
      DescMaterial,
      CodFornecedorRM,
      DescFornecedorRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      ValorItemRM,
      CfopRemessa,
      MovimentoRM,
      NFRemessa,
      DataRemessa,
      MaterialMovement,
      CodMaterialRM,
      DescMaterialRM,
      //      @Semantics.quantity.unitOfMeasure: 'MoedaRM'
      cast( QtdeRM as abap.dec(13,3))                                   as QtdeRM,
      UnidMedidaRM,
      MoedaRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      ValorTotalRM,
      DepositoRM,
      LoteRM,
      NcmRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetornoRM                                           as MontBasicRetornoRM1,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetornoRM2,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetornoRM3,
      @Semantics.amount.currencyCode: 'MoedaRM'
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REL_TERC_AGRUP'
      cast( 0 as abap.curr(15,2))                                  as MontBasicRetornoRM,
      TaxaRetornoRM,
      @Semantics.amount.currencyCode: 'MoedaRM'
      IcmsRetornoRM,
      CodFornecedorRT,
      DescFornecedorRT,
      @Semantics.amount.currencyCode: 'MoedaRM'
      ValorItemRT,
      CfopRetorno,
      MovimentoRT,
      NFRetorno,
      DataRetorno,
      DocMaterial,
      CodMaterialRT,
      DescMaterialRT,
      //      @Semantics.quantity.unitOfMeasure: 'MoedaRT'
      //cast( QtdeRM as abap.dec(13,3))                                   as QtdeRT,
      cast( QtdeRT as abap.dec(13,3)) as QtdeRT,
      case
      when UnidMedidaRT is not null
      then
      UnidMedidaRT
      else UnidMedidaRM end                                        as UnidMedidaRT,
      MoedaRT,
      @Semantics.amount.currencyCode: 'MoedaRM'
      ValorTotalRT,
      DepositoRT,
      LoteRT,
      NcmRT,
      Regio,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetorno,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetorno2,
      @Semantics.amount.currencyCode: 'MoedaRM'
      MontBasicRetorno3,
      @Semantics.amount.currencyCode: 'MoedaRM'
      IcmsRetornoRT,
      @Semantics.amount.currencyCode: 'MoedaRM'
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_REL_TERC_AGRUP'
      cast( 0 as abap.curr(15,2))                                  as MontBasicRetornoRT,
      TaxaRetornoRT,
      case
      when DocnumRetorno is null
      then  dats_days_between(DiasAberto,$session.system_date) end as DiasAberto,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_VH_STATUS_REL_TERC', element: 'Status' } }]
      case
         when (dats_days_between(DataRemessa,DataRetorno) < 91 and Regio = 'DENTRO') or
              (dats_days_between(DataRemessa,DataRetorno) < 181 and Regio = 'FORA')
         then 'Dentro do Prazo'
         when (dats_days_between(DiasAberto,$session.system_date) < 91 and DataRetorno is null and Regio = 'DENTRO')  or
              (dats_days_between(DiasAberto,$session.system_date) < 181 and DataRetorno is null and Regio = 'FORA')
          then 'Pendente'
         when (dats_days_between(DataRemessa,DataRetorno) > 91 and Regio = 'DENTRO')  or
              (dats_days_between(DataRemessa,DataRetorno) > 181 and Regio = 'FORA')
         then 'Fora do Prazo'
         when (dats_days_between(DiasAberto,$session.system_date) > 91 and DataRetorno is null and Regio = 'DENTRO')  or
              (dats_days_between(DiasAberto,$session.system_date) < 181 and DataRetorno is null and Regio = 'FORA')
         then 'Pendente'
         else 'Pendente'
      end                                                          as Status,

      case
         when (dats_days_between(DataRemessa,DataRetorno) < 91 and Regio = 'DENTRO') or
              (dats_days_between(DataRemessa,DataRetorno) < 181 and Regio = 'FORA')
         then 3
         when (dats_days_between(DiasAberto,$session.system_date) < 91 and DataRetorno is null and Regio = 'DENTRO')  or
              (dats_days_between(DiasAberto,$session.system_date) < 181 and DataRetorno is null and Regio = 'FORA')
          then 2
         when (dats_days_between(DataRemessa,DataRetorno) > 91 and Regio = 'DENTRO')  or
              (dats_days_between(DataRemessa,DataRetorno) > 181 and Regio = 'FORA')
         then 1
         when (dats_days_between(DiasAberto,$session.system_date) > 91 and DataRetorno is null and Regio = 'DENTRO')  or
              (dats_days_between(DiasAberto,$session.system_date) < 181 and DataRetorno is null and Regio = 'FORA')
         then 1
         else 1
      end                                                          as ColorStatus,

      cast( '' as abap.char(12) )                                  as ContaContabilIcmsRM,
      cast( '' as abap.char(12) )                                  as ContaContabilIcmsRT,
      SaldoFornecedor,
      cast( '' as abap.char(12) )                                  as NumSerie,
      DataDocumentoRM,
      DataLancamentoRM,
      PedidoSub,
      Iva,
      CategoriaNFE,
      GrupoCompra,
      GrupoMercado,
      DataDocumentoRT,
      DataLancamentoRT,
      case when SaldoFornecedor is not null
      then cast ( 'X' as boole_d )
      else cast ( ' ' as boole_d )
      end                                                          as SaldoTerceiro


}

//  as select from           ZI_MM_REL_TERC_MAIN as _Main
//    inner join             ZI_MM_REL_TERC_REM  as _Remessa on  _Remessa.Empresa         = _Main.Empresa
//                                                           and _Remessa.BusinessPartner = _Main.CodFornecedor
//                                                           and _Remessa.Material        = _Main.Material
//                                                           and _Remessa.LocalNegocios   = _Main.LocalNegocio
//                                                           and (
//                                                              _Remessa.TipoImposto      = 'ICM1'
//                                                              or _Remessa.TipoImposto   = 'ICM2'
//                                                              or _Remessa.TipoImposto   = 'ICM3'
//                                                            )
//
//    left outer to one join ZI_MM_REL_TERC_RET  as _Retorno on  _Retorno.Empresa         = _Remessa.Empresa
//                                                           and _Retorno.BusinessPartner = _Remessa.BusinessPartner
//                                                           and _Retorno.Material        = _Remessa.Material
//                                                           and _Retorno.TipoImposto     = _Remessa.TipoImposto
//                                                           and _Retorno.DocRef          = ltrim(
//      _Remessa.DocnumRemessa, '0'
//    )
//
//{
//
//  key _Main.Empresa,
//  key _Main.CodFornecedor,
//  key _Main.Material,
//  key _Main.LocalNegocio,
//  key _Remessa.Centro,
//  key _Remessa.DocnumRemessa,
//  key _Remessa.NfItem                                                       as NfItemRM,
//  key _Retorno.DocnumRetorno,
//  key _Retorno.NfItem,
//      _Remessa.TipoImposto                                                  as TipoImpostoRM,
//      _Retorno.TipoImposto,
//      _Main.DescEmpresa,
//      _Main.DescFornecedor,
//      _Main.DescMaterial,
//      _Remessa.CodFornecedor                                                as CodFornecedorRM,
//      _Remessa.DescFornecedor                                               as DescFornecedorRM,
//      _Remessa.ValorItem                                                    as ValorItemRM,
//      _Remessa.CfopRemessa,
//      _Remessa.Movimento                                                    as MovimentoRM,
//      _Remessa.NFRemessa,
//      _Remessa.DataRemessa,
//      _Remessa.MaterialMovement,
//      _Remessa.CodMaterial                                                  as CodMaterialRM,
//      _Remessa.DescMaterial                                                 as DescMaterialRM,
//      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRM'
//      _Remessa.Qtde                                                         as QtdeRM,
//      _Remessa.UnidMedida                                                   as UnidMedidaRM,
//      _Remessa.Moeda                                                        as MoedaRM,
//      @Semantics.amount.currencyCode: 'MoedaRM'
//      _Remessa.ValorTotal                                                   as ValorTotalRM,
//      _Remessa.Deposito                                                     as DepositoRM,
//      _Remessa.Lote                                                         as LoteRM,
//      _Remessa.Ncm                                                          as NcmRM,
//      @Semantics.amount.currencyCode: 'MoedaRM'
//      _Remessa.MontBasicRetorno                                             as MontBasicRetornoRM,
//      _Remessa.TaxaRetorno                                                  as TaxaRetornoRM,
//      @Semantics.amount.currencyCode: 'MoedaRM'
//      _Remessa.IcmsRetorno                                                  as IcmsRetornoRM,
//      _Retorno.CodFornecedorRT                                              as CodFornecedorRT,
//      _Retorno.DescFornecedor                                               as DescFornecedorRT,
//      _Retorno.ValorItem                                                    as ValorItemRT,
//      _Retorno.CfopRetorno,
//      _Retorno.Movimento                                                    as MovimentoRT,
//      _Retorno.NFRetorno,
//      _Retorno.DataRetorno,
//      _Retorno.DocMaterial,
//      _Retorno.CodMaterial                                                  as CodMaterialRT,
//      _Retorno.DescMaterial                                                 as DescMaterialRT,
//      @Semantics.quantity.unitOfMeasure: 'UnidMedidaRT'
//      _Retorno.Qtde                                                         as QtdeRT,
//      _Retorno.UnidMedida                                                   as UnidMedidaRT,
//      _Retorno.Moeda                                                        as MoedaRT,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      _Retorno.ValorTotal                                                   as ValorTotalRT,
//      _Retorno.Deposito                                                     as DepositoRT,
//      _Retorno.Lote                                                         as LoteRT,
//      _Retorno.Ncm                                                          as NcmRT,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      _Retorno.MontBasicRetorno,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      _Retorno.MontBasicRetorno2,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      _Retorno.MontBasicRetorno3,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      @ObjectModel.virtualElement: true
//      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLMM_CDS_REMRET'
//       cast( 0 as abap.curr(15,2))                                          as MontBasicRetornoRT,
//      _Retorno.TaxaRetorno                                                  as TaxaRetornoRT,
//      @Semantics.amount.currencyCode: 'MoedaRT'
//      _Retorno.IcmsRetorno                                                  as IcmsRetornoRT,
//      cast( '' as abap.char(12) )                                           as Status,
//      case
//      when _Retorno.DocnumRetorno is null
//      then  dats_days_between(_Remessa.DiasAberto,$session.system_date) end as DiasAberto,
//      cast( '' as abap.char(12) )                                           as ContaContabilIcmsRM,
//      cast( '' as abap.char(12) )                                           as ContaContabilIcmsRT,
//      case
//      when _Retorno.QtdeRT is not null
//      then (_Remessa.QtdeRM - _Retorno.QtdeRT )
//      else _Remessa.QtdeRM end as SaldoFornecedor,
//      cast( '' as abap.char(12) )                                           as NumSerie
//
//}
//group by
//  _Main.Empresa,
//  _Main.CodFornecedor,
//  _Main.Material,
//  _Main.LocalNegocio,
//  _Remessa.Centro,
//  _Remessa.NfItem,
//  _Remessa.DocnumRemessa,
//  _Remessa.TipoImposto,
//  _Retorno.NfItem,
//  _Retorno.DocnumRetorno,
//  _Retorno.TipoImposto,
//  _Main.DescEmpresa,
//  _Main.DescFornecedor,
//  _Main.DescMaterial,
//  _Remessa.CodFornecedor,
//  _Remessa.DescFornecedor,
//  _Remessa.ValorItem,
//  _Remessa.CfopRemessa,
//  _Remessa.Movimento,
//  _Remessa.NFRemessa,
//  _Remessa.DataRemessa,
//  _Remessa.MaterialMovement,
//  _Remessa.CodMaterial,
//  _Remessa.DescMaterial,
//  _Remessa.Qtde,
//  _Remessa.UnidMedida,
//  _Remessa.Moeda,
//  _Remessa.ValorTotal,
//  _Remessa.Deposito,
//  _Remessa.Lote,
//  _Remessa.Ncm,
//  _Remessa.MontBasicRetorno,
//  _Remessa.TaxaRetorno,
//  _Remessa.IcmsRetorno,
//  _Retorno.CodFornecedorRT,
//  _Retorno.DescFornecedor,
//  _Retorno.ValorItem,
//  _Retorno.CfopRetorno,
//  _Retorno.Movimento,
//  _Retorno.NFRetorno,
//  _Retorno.DataRetorno,
//  _Retorno.DocMaterial,
//  _Retorno.CodMaterial,
//  _Retorno.DescMaterial,
//  _Retorno.Qtde,
//  _Retorno.UnidMedida,
//  _Retorno.Moeda,
//  _Retorno.ValorTotal,
//  _Retorno.Deposito,
//  _Retorno.Lote,
//  _Retorno.Ncm,
//  _Retorno.MontBasicRetorno,
//  _Retorno.MontBasicRetorno2,
//  _Retorno.MontBasicRetorno3,
//  _Retorno.TaxaRetorno,
//  _Retorno.IcmsRetorno,
//  _Remessa.DiasAberto,
//  _Remessa.QtdeRM,
//  _Retorno.QtdeRT 
