@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Regra para cálculo DIFAL/ST - Base Dupla'
define root view entity ZI_MM_ZMMT003
  as select from zmmt003 as _Z003
  association [0..1] to ZI_CA_VH_SHIPTO as _ShipTo on $projection.Shipto = _ShipTo.Region
  association [0..1] to ZI_SD_STEUC     as _Steuc  on $projection.J1bnbm = _Steuc.Steuc
{
      @ObjectModel.text.element: ['ShipToText']
  key shipto                as Shipto,
      @ObjectModel.text.element: ['J_1bnbmText']
  key j_1bnbm               as J1bnbm,
  key mwskz,
      @Semantics.text: true
      _ShipTo.Text          as ShipToText,
      @Semantics.text: true
      _Steuc.Text           as J_1bnbmText,
      flag                  as Flag,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,

      _ShipTo,
      _Steuc
}
