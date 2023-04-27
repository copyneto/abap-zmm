@EndUserText.label: 'CDS CONSUMO - Entrada de Serviço com NBS'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_NBS
  as projection on ZI_MM_NBS_APP
{

  key Matnr,

      Maktx,

      //@ObjectModel.text.element: ['Description']
      Nbs,
      Description,

      CreatedBy,

      CreatedAt,

      LastChangedBy,

      LastChangedAt,

      LocalLastChangedAt
}
