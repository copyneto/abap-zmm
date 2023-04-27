@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS ADM Ret de Insumos Div'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_INSUMOS_DIV
  as select from    matdoc                  as _mat
    inner join      ZI_MM_RET_INSUMOS_DIV2  as _mat2 on  _mat.key1 = _mat2.Key1
                                                     and _mat.key2 = _mat2.Key2
                                                     and _mat.key3 = _mat2.Key3
                                                     and _mat.key4 = _mat2.Key4
                                                     and _mat.key5 = _mat2.Key5
                                                     and _mat.key6 = _mat2.Key6
                                                     and _mat2.Teste != 'X'

    left outer join ZI_MM_CALCULO_DIV as _mat3 on  _mat2.Key1 = _mat3.Key1
                                                     and _mat2.Key2 = _mat3.Key2
                                                     and _mat2.Key3 = _mat3.Key3
                                                     and _mat2.Key4 = _mat3.Key4
                                                     and _mat2.Key5 = _mat3.Key5
                                                     and _mat2.Key6 = _mat3.Key6

    left outer join ZI_MM_INSUMOS_DOC       as _doc  on  _mat2.Key1 = _doc.Key1
                                                     and _mat2.Key2 = _doc.Key2
                                                     and _mat2.Key3 = _doc.Key3
                                                     and _mat2.Key4 = _doc.Key4
                                                     and _mat2.Key5 = _doc.Key5
                                                     and _mat2.Key6 = _doc.Key6

  association [0..1] to ZI_MM_MATNR_VH as _Makt  on _Makt.MatnrCode = $projection.matnr

  association [0..1] to ZI_CA_VH_LIFNR as _Lifnr on _Lifnr.LifnrCode = $projection.lifnr

  association [0..1] to ZI_CA_VH_WERKS as _Werks on _Werks.WerksCode = $projection.werks
{

  key _mat.key1                           as Key1,
  key _mat.key2                           as Key2,
  key _mat.key3                           as Key3,
  key _mat.key4                           as Key4,
  key _mat.key5                           as Key5,
  key _mat.key6                           as Key6,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
  key _mat3.lifnr,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
  key _mat.werks,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_MM_MATNR_VH', element: 'MatnrCode' } }]
  key _mat3.matnr,
  key _mat.ebeln,
  key _mat.ebelp,
  key _mat.mblnr,
    cast( _mat3.LvQtdePed as abap.dec( 13, 3 ) )  as LvQtdePed,
    cast( _mat3.LvQtdeRet as abap.dec( 13, 3 ) )  as LvQtdeRet,
    cast( _mat3.Divergencia as abap.dec( 13, 3 ) ) as Divergencia,
      
      //_mat3.LvQtdePed,
      //_mat3.LvQtdeRet,
      _doc.docnum,
      _doc.nfenum,
      _mat.budat,
      _Lifnr.LifnrCodeName,
      _Werks.WerksCodeName,
      _Makt.MatnrCodeName as maktx,
      _mat.shkzg,
      _mat.zeile,
      _mat.mjahr,

      //_mat3.Divergencia,
      
      case
      when _mat3.Divergencia < 0
      then 1 
      else 1 end as Criticality,
   
      _mat3.meins,


      case
      when _mat3.LvQtdePed = _mat3.LvQtdeRet
      then ' '
      else 'X' end                        as Marca,
      _Makt,
      _Lifnr,
      _Werks
}
where
       _mat.record_type = 'MDOC'
  and(
       _mat.bwart       = '543'
    or _mat.bwart       = '544'
  )
  and  _mat3.bwart      = '101'
and _mat.cancelled <> 'X'
