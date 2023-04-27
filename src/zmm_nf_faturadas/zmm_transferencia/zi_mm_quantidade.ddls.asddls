@AbapCatalog.sqlViewName: 'ZVMM_QUANTIDADE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca a Quantidade x Fator de conversão'
define view ZI_MM_QUANTIDADE
  as select from I_BR_NFItem     as NFItem
    inner join   I_BR_NFDocument as NF on NF.BR_NotaFiscal = NFItem.BR_NotaFiscal

  association [1..1] to marm as _UnidadeMedida on  _UnidadeMedida.matnr = $projection.Material
                                               and _UnidadeMedida.meinh = $projection.UnidadePeso
{
  key NFItem.BR_NotaFiscal     as NumeroDocumento,
  key NFItem.BR_NotaFiscalItem as NumeroDocumentoItem,
      NFItem.Material          as Material,
      NFItem.BaseUnit          as UnidadeMedida,
      NF.HeaderWeightUnit      as UnidadePeso,
      _UnidadeMedida.umrez     as FatorConversao,

      _UnidadeMedida
}
