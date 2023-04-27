@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Conversão J_1BNFLIN e EKPO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CONV_LIN_EKPO
  as select from j_1bnflin
{
  key docnum                                     as Docnum,
  key itmnum                                     as Itmnum,
      substring(xped, 1, 10)                     as Xped,

      case 
      when length(nitemped) = 6 then
        substring( cast( nitemped as abap.char( 10 )) , 2, 5)
      else
         nitemped 
      end as Nitemped

}
where
  j_1bnflin.nitemped is not initial
