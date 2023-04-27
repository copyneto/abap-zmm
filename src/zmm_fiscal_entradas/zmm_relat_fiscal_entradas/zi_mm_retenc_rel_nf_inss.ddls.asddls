@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro REL_NF_INSS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_RETENC_REL_NF_INSS
  as select from ztca_param_val
{
  key case low
         when '' then ''
            else 'X' end    as Active,
  key substring(low, 1, 4)  as CollIR,
  key substring(low, 6, 16) as Hkont
}
where
      modulo = 'MM'
  and chave1 = 'REL_NF_INSS'
  and sign   = 'I'
  and opt    = 'EQ'
