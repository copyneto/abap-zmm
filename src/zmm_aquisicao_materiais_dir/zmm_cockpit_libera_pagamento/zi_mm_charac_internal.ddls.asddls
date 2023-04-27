@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARAC_INTERNAL
  as select from I_BatchTP_2          as Batch

//    inner join   I_BatchCharcValueTP  as _CharValueOrd on  _CharValueOrd.Material              = Batch.Material
//                                                       and _CharValueOrd.BatchIdentifyingPlant = Batch.BatchIdentifyingPlant
//                                                       and _CharValueOrd.Batch                 = Batch.Batch
//    inner join   I_ClfnCharacteristic as _CharOrd      on _CharOrd.CharcInternalID = _CharValueOrd.CharcInternalID

    inner join   I_BatchCharcValueTP  as _CharValuePed on  _CharValuePed.Material              = Batch.Material
                                                       and _CharValuePed.BatchIdentifyingPlant = Batch.BatchIdentifyingPlant
                                                       and _CharValuePed.Batch                 = Batch.Batch
    inner join   I_ClfnCharacteristic as _CharPed      on _CharPed.CharcInternalID = _CharValuePed.CharcInternalID

{
  key Batch.Material,
  key Batch.BatchIdentifyingPlant                                    as Plant,
  key Batch.Batch,
      _CharValuePed.CharcValue                                       as Pedido 
//      lpad( cast(_CharValueOrd.CharcValue as ze_romaneio), 10, '0' ) as Ordem
}
where
      _CharValuePed.ClassType = '023'
  and _CharPed.Characteristic = 'YGV_PEDIDO'
//  and _CharValueOrd.ClassType = '023'
//  and _CharOrd.Characteristic = 'YGV_ORDEM'
