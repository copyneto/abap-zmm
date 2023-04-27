@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nome do usuário'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_VH_V_USR_NAME as select from 
  usr21 as _USR21
  inner join adrp as _ADRP on _ADRP.persnumber = _USR21.persnumber 
{

key _USR21.bname as Bname,
key _ADRP.name_first as NameFirst,
key _ADRP.name_last as NameLast,
key _ADRP.name_text as NameText
    
}
