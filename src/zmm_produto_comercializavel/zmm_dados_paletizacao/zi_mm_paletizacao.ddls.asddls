

@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface Paletização'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.modelCategory: #BUSINESS_OBJECT
define root view entity ZI_MM_PALETIZACAO
  as select from ztmm_paletizacao as _Paletizacao
    inner join   I_Material       as _Material on _Material.Material = _Paletizacao.material

  association [1..1] to I_MaterialText     as _MaterialText      on  _MaterialText.Material = $projection.Product
                                                                 and _MaterialText.Language = $session.system_language
  association [1..1] to I_UnitOfMeasure    as _BaseUnitOfMeasure on  _BaseUnitOfMeasure.UnitOfMeasure = $projection.Unit
  association [1..1] to I_MaterialTypeText as _MaterialTypeText  on  _MaterialTypeText.MaterialType = $projection.TipoMaterial
                                                                 and _MaterialTypeText.Language     = $session.system_language
  //  association [0..*] to I_UnitOfMeasureText as _BaseUnitOfMeasureText on $projection.Unit = _BaseUnitOfMeasureText.UnitOfMeasure
{
  key _Paletizacao.material                      as Product,
  key _Paletizacao.centro                        as Centro,
      _MaterialText.MaterialName                 as DescricaoMaterial,
      _Material.MaterialType                     as TipoMaterial,
      _MaterialTypeText.MaterialTypeName         as DescricaoTipoMaterial,
      @EndUserText.label: 'Lastro'
      cast( _Paletizacao.z_lastro as abap.dec( 13, 3 ) ) as Lastro,
      @EndUserText.label: 'Altura'
      cast(_Paletizacao.z_altura as abap.dec( 13, 3 ) )   as Altura,
      @ObjectModel.foreignKey.association: '_BaseUnitOfMeasure'
      //      @ObjectModel.text.association: '_BaseUnitOfMeasureText'
      @EndUserText.label: 'Embalagem secundária'
      _Paletizacao.z_unit                        as Unit,
      @Semantics.user.createdBy: true
      _Paletizacao.created_by                    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Paletizacao.created_at                    as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Paletizacao.last_changed_by               as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Paletizacao.last_changed_at               as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Paletizacao.local_last_changed_at         as LocalLastChangedAt,

      _MaterialText,
      _BaseUnitOfMeasure,
      _MaterialTypeText
      //      _BaseUnitOfMeasureText

}
