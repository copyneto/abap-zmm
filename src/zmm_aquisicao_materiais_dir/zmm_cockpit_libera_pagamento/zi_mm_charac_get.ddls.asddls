@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes - Busca'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARAC_GET
  as select from    ZI_MM_CHARAC_INTERNAL as Internal
    inner join      I_BatchTP_2           as _Batch            on  _Batch.Material              = Internal.Material
                                                               and _Batch.BatchIdentifyingPlant = Internal.Plant
                                                               and _Batch.Batch                 = Internal.Batch

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_QTD_KG       on  _YGV_QTD_KG.Material       = Internal.Material
                                                               and _YGV_QTD_KG.Plant          = Internal.Plant
                                                               and _YGV_QTD_KG.Batch          = Internal.Batch
                                                               and _YGV_QTD_KG.Characteristic = 'YGV_QTD_KG'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_QTD_SACAS    on  _YGV_QTD_SACAS.Material       = Internal.Material
                                                               and _YGV_QTD_SACAS.Plant          = Internal.Plant
                                                               and _YGV_QTD_SACAS.Batch          = Internal.Batch
                                                               and _YGV_QTD_SACAS.Characteristic = 'YGV_QTD_SACAS'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_QTD_BAG      on  _YGV_QTD_BAG.Material       = Internal.Material
                                                               and _YGV_QTD_BAG.Plant          = Internal.Plant
                                                               and _YGV_QTD_BAG.Batch          = Internal.Batch
                                                               and _YGV_QTD_BAG.Characteristic = 'YGV_QTD_BAG'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P10          on  _YGV_P10.Material       = Internal.Material
                                                               and _YGV_P10.Plant          = Internal.Plant
                                                               and _YGV_P10.Batch          = Internal.Batch
                                                               and _YGV_P10.Characteristic = 'YGV_P10'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P11          on  _YGV_P11.Material       = Internal.Material
                                                               and _YGV_P11.Plant          = Internal.Plant
                                                               and _YGV_P11.Batch          = Internal.Batch
                                                               and _YGV_P11.Characteristic = 'YGV_P11'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P12          on  _YGV_P12.Material       = Internal.Material
                                                               and _YGV_P12.Plant          = Internal.Plant
                                                               and _YGV_P12.Batch          = Internal.Batch
                                                               and _YGV_P12.Characteristic = 'YGV_P12'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P13          on  _YGV_P13.Material       = Internal.Material
                                                               and _YGV_P13.Plant          = Internal.Plant
                                                               and _YGV_P13.Batch          = Internal.Batch
                                                               and _YGV_P13.Characteristic = 'YGV_P13'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P14          on  _YGV_P14.Material       = Internal.Material
                                                               and _YGV_P14.Plant          = Internal.Plant
                                                               and _YGV_P14.Batch          = Internal.Batch
                                                               and _YGV_P14.Characteristic = 'YGV_P14'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P15          on  _YGV_P15.Material       = Internal.Material
                                                               and _YGV_P15.Plant          = Internal.Plant
                                                               and _YGV_P15.Batch          = Internal.Batch
                                                               and _YGV_P15.Characteristic = 'YGV_P15'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P16          on  _YGV_P16.Material       = Internal.Material
                                                               and _YGV_P16.Plant          = Internal.Plant
                                                               and _YGV_P16.Batch          = Internal.Batch
                                                               and _YGV_P16.Characteristic = 'YGV_P16'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P17          on  _YGV_P17.Material       = Internal.Material
                                                               and _YGV_P17.Plant          = Internal.Plant
                                                               and _YGV_P17.Batch          = Internal.Batch
                                                               and _YGV_P17.Characteristic = 'YGV_P17'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P18          on  _YGV_P18.Material       = Internal.Material
                                                               and _YGV_P18.Plant          = Internal.Plant
                                                               and _YGV_P18.Batch          = Internal.Batch
                                                               and _YGV_P18.Characteristic = 'YGV_P18'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_P19          on  _YGV_P19.Material       = Internal.Material
                                                               and _YGV_P19.Plant          = Internal.Plant
                                                               and _YGV_P19.Batch          = Internal.Batch
                                                               and _YGV_P19.Characteristic = 'YGV_P19'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_DEFEITO      on  _YGV_DEFEITO.Material       = Internal.Material
                                                               and _YGV_DEFEITO.Plant          = Internal.Plant
                                                               and _YGV_DEFEITO.Batch          = Internal.Batch
                                                               and _YGV_DEFEITO.Characteristic = 'YGV_DEFEITO'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_IMPUREZAS    on  _YGV_IMPUREZAS.Material       = Internal.Material
                                                               and _YGV_IMPUREZAS.Plant          = Internal.Plant
                                                               and _YGV_IMPUREZAS.Batch          = Internal.Batch
                                                               and _YGV_IMPUREZAS.Characteristic = 'YGV_IMPUREZAS'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_FUNDO        on  _YGV_FUNDO.Material       = Internal.Material
                                                               and _YGV_FUNDO.Plant          = Internal.Plant
                                                               and _YGV_FUNDO.Batch          = Internal.Batch
                                                               and _YGV_FUNDO.Characteristic = 'YGV_FUNDO'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_VERDE        on  _YGV_VERDE.Material       = Internal.Material
                                                               and _YGV_VERDE.Plant          = Internal.Plant
                                                               and _YGV_VERDE.Batch          = Internal.Batch
                                                               and _YGV_VERDE.Characteristic = 'YGV_VERDE'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_PRETO_ARDIDO on  _YGV_PRETO_ARDIDO.Material       = Internal.Material
                                                               and _YGV_PRETO_ARDIDO.Plant          = Internal.Plant
                                                               and _YGV_PRETO_ARDIDO.Batch          = Internal.Batch
                                                               and _YGV_PRETO_ARDIDO.Characteristic = 'YGV_PRETO-ARDIDO'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_CATACAO      on  _YGV_CATACAO.Material       = Internal.Material
                                                               and _YGV_CATACAO.Plant          = Internal.Plant
                                                               and _YGV_CATACAO.Batch          = Internal.Batch
                                                               and _YGV_CATACAO.Characteristic = 'YGV_CATACAO'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_UMIDADE      on  _YGV_UMIDADE.Material       = Internal.Material
                                                               and _YGV_UMIDADE.Plant          = Internal.Plant
                                                               and _YGV_UMIDADE.Batch          = Internal.Batch
                                                               and _YGV_UMIDADE.Characteristic = 'YGV_UMIDADE'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_MK10         on  _YGV_MK10.Material       = Internal.Material
                                                               and _YGV_MK10.Plant          = Internal.Plant
                                                               and _YGV_MK10.Batch          = Internal.Batch
                                                               and _YGV_MK10.Characteristic = 'YGV_MK10'

    left outer join ZI_MM_CHARAC_VALUE    as _YGV_BROCADOS     on  _YGV_DEFEITO.Material        = Internal.Material
                                                               and _YGV_BROCADOS.Plant          = Internal.Plant
                                                               and _YGV_BROCADOS.Batch          = Internal.Batch
                                                               and _YGV_BROCADOS.Characteristic = 'YGV_BROCADOS'


{
  key Internal.Pedido,
  key Internal.Material,
  key Internal.Plant,
  key Internal.Batch,
      //  key Internal.Ordem,
      _YGV_QTD_KG.CharcFromNumericValue       as YGV_QTD_KG,
      _YGV_QTD_SACAS.CharcFromNumericValue    as YGV_QTD_SACAS,
      _YGV_QTD_BAG.CharcFromNumericValue      as YGV_QTD_BAG,
      _YGV_P10.CharcFromNumericValue          as YGV_P10,
      _YGV_P11.CharcFromNumericValue          as YGV_P11,
      _YGV_P12.CharcFromNumericValue          as YGV_P12,
      _YGV_P13.CharcFromNumericValue          as YGV_P13,
      _YGV_P14.CharcFromNumericValue          as YGV_P14,
      _YGV_P15.CharcFromNumericValue          as YGV_P15,
      _YGV_P16.CharcFromNumericValue          as YGV_P16,
      _YGV_P17.CharcFromNumericValue          as YGV_P17,
      _YGV_P18.CharcFromNumericValue          as YGV_P18,
      _YGV_P19.CharcFromNumericValue          as YGV_P19,
      _YGV_DEFEITO.CharcFromNumericValue      as YGV_DEFEITO,
      _YGV_IMPUREZAS.CharcFromNumericValue    as YGV_IMPUREZAS,
      _YGV_MK10.CharcFromNumericValue         as YGV_MK10,
      _YGV_FUNDO.CharcFromNumericValue        as YGV_FUNDO,
      _YGV_VERDE.CharcFromNumericValue        as YGV_VERDE,
      _YGV_PRETO_ARDIDO.CharcFromNumericValue as YGV_PRETO_ARDIDO,
      _YGV_CATACAO.CharcFromNumericValue      as YGV_CATACAO,
      _YGV_UMIDADE.CharcFromNumericValue      as YGV_UMIDADE,
      _YGV_BROCADOS.CharcFromNumericValue     as YGV_BROCADOS
}
