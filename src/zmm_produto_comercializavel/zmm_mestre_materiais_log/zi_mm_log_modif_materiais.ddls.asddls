@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Log de modificações materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_LOG_MODIF_MATERIAIS
  as select from ZI_MM_GET_DATA_CDPOS
{
      @EndUserText.label: 'Material'
  key ltrim(matnr, '0' ) as matnr,
      //  key matnr,
      @EndUserText.label: 'Centro'
  key werks,
      @EndUserText.label: 'Depósito'
  key lgort,
      @EndUserText.label: 'Área de avaliação'
  key bwkey,
      @EndUserText.label: 'Tipo de avaliação'
  key bwtar,
      @EndUserText.label: 'Nºdepósito/complexo de depósito'
  key lgnum,
      @EndUserText.label: 'Organização de vendas'
  key vkorg,
      @EndUserText.label: 'Canal de distribuição'
  key vtweg,
      @EndUserText.label: 'Código modificação'
  key chngind,
      @EndUserText.label: 'Campo Técnico'
  key fname,
  key value_new,
  key value_old,
      @EndUserText.label: 'Data modificação'
  key udate,
  key utime,
  key username,
      mtart,
      spart,

      @EndUserText.label: 'Descrição campo'
      ddtext,
      @EndUserText.label: 'Descrição material'
      maktx,
      @EndUserText.label: 'DescrIndicModif'
      chngindtxt
}
