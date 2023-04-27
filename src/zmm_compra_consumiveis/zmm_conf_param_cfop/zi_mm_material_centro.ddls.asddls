@AbapCatalog.sqlViewName: 'ZVMM_MAT_CENTRO'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Material Centro'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_MM_MATERIAL_CENTRO
  as select from mbew as _mbew
  association [0..1] to marc as _marc on $projection.Material = _marc.matnr
                                     and $projection.Centro = _marc.werks
{
    key matnr           as Material,
    key bwkey           as Centro,
    key bwtar           as TipoAvaliacao,
    _marc.indus         as CatCfop,
    _mbew.mtuse         as UtiliMaterial,
    _mbew.ownpr         as ProducaoInterna,
    _mbew.mtorg         as Origem,
    _marc.steuc         as CodControle,         
      // Association
      _marc
}
