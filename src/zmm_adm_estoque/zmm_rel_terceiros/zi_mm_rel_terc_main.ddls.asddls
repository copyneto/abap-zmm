@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View Principal Rel Terceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_REL_TERC_MAIN
  as select from I_BR_NFDocument as Doc
    inner join   I_BR_NFItem     as Item on Doc.BR_NotaFiscal = Item.BR_NotaFiscal
    inner join   ztmm_operacao   as Oper on Item.BR_CFOPCode = Oper.cfop_int
{
  Doc.CompanyCode                                                 as Empresa,
  Doc.CompanyCodeName                                             as DescEmpresa,
  Doc.BR_NFPartner                                                as CodFornecedor,
  Doc.BR_NFPartnerName1                                           as DescFornecedor,
  Doc.BusinessPlace                                               as LocalNegocio,
  Item.Plant                                                      as Centro,
  Item.Material                                                   as Material,
  Item.MaterialName                                               as DescMaterial,
  @Semantics.quantity.unitOfMeasure: 'UnidMedida'
  Item.QuantityInBaseUnit                                         as Qtde,
  Item.BaseUnit                                                   as UnidMedida,
  @Semantics.quantity.unitOfMeasure: 'UnidMedida'
  case Oper.tipo when '1' then sum( Item.QuantityInBaseUnit ) end as QtdeRemessa,
  @Semantics.quantity.unitOfMeasure: 'UnidMedida'
  case Oper.tipo when '2' then sum( Item.QuantityInBaseUnit ) end as QtdeRetorno


}
where
   Doc.BR_NFIsCanceled is initial
group by
  Doc.CompanyCode,
  Doc.CompanyCodeName,
  Doc.BR_NFPartner,
  Doc.BR_NFPartnerName1,
  Doc.BusinessPlace,
  Item.Plant,
  Item.Material,
  Item.MaterialName,
  Item.QuantityInBaseUnit,
  Item.BaseUnit,
  Oper.tipo
