@EndUserText.label: 'Search Help Shipfrom'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_MM_VH_SHIPFROM as select from ztmm_dirfiscais{
    key shipfrom as Shipfrom
}group by shipfrom;
    
