@AbapCatalog.sqlViewName: 'ZVMM_DF_MAT_UNI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Materiais com unidades de medida'
define view ZI_MM_DF_MATERIAL_UNIDADE
  as select from marc as CentroMaterial
    inner join   mara as _Material on _Material.matnr = CentroMaterial.matnr
    inner join   mean as _Unidade  on _Unidade.matnr = CentroMaterial.matnr
    left outer join   marm as _marm     on _marm.matnr = CentroMaterial.matnr
                                       and _marm.meinh = _Unidade.meinh  
    
{
  key CentroMaterial.matnr as Material,
  key CentroMaterial.werks as Plant,
  key _Material.meins      as OriginUnit,
  key _Unidade.meinh      as Unit,
      _Unidade.eantp       as EANType,
      _marm.umrez          as MarmUmrez, 
      _marm.umren          as Marmumren
}
union select from marc as CentroMaterial
  inner join      mara as _Material on _Material.matnr = CentroMaterial.matnr
  left outer join   marm as _marm     on _marm.matnr = CentroMaterial.matnr
                                     and _marm.meinh = _Material.meins   
{
 key CentroMaterial.matnr as Material,
  key CentroMaterial.werks as Plant,
  key _Material.meins      as OriginUnit,
  key _Material.meins     as Unit,
      cast( '00' as numtp ) as EANType,
      _marm.umrez          as MarmUmrez, 
      _marm.umren          as Marmumren

}
