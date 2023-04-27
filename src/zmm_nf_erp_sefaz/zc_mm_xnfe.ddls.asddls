@AbapCatalog.sqlViewName: 'ZVMM_C_XNFE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de Nota Fiscal - GRC'
define view ZC_MM_XNFE
  as select distinct from ZI_MM_XNFE
{
  key GuidHeader,
      NfeID,
      Nnf,
      CnpjDest,
      CnpjEmit,
      PoNumber,
      PoItem,
      Cprod,
      CFOP,
      Xprod,
      NCM,
      Nitem
//      lpad( cast(cast(cast( item as abap.quan( 3, 0 ) ) * 10 as abap.char( 10 ) ) as abap.numc( 5 ) ), 5, '0' )  as item2
}
