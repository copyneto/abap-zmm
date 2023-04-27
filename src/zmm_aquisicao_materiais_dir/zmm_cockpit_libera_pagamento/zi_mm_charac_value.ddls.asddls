@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Caracteísticas Lotes - Valores'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MM_CHARAC_VALUE
  as select from I_BatchCharcValueTP  as CharValue
    inner join   I_ClfnCharacteristic as _CharVal on _CharVal.CharcInternalID = CharValue.CharcInternalID
  //  as select from I_BatchTP_2          as Batch
  //    inner join   I_BatchCharcValueTP  as _CharValue on  _CharValue.Material              = Batch.Material
  //                                                    and _CharValue.BatchIdentifyingPlant = Batch.BatchIdentifyingPlant
  //                                                    and _CharValue.Batch                 = Batch.Batch
{
  key CharValue.Material,
  key CharValue.BatchIdentifyingPlant as Plant,
  key CharValue.Batch,
  key _CharVal.Characteristic,
      CharValue.CharcValue,
      CharValue.CharcFromNumericValue,
      CharValue.CharcToNumericValue,
      CharValue.CharcFromDecimalValue,
      CharValue.CharcToDecimalValue,
      @Semantics.amount.currencyCode: 'Currency'
      CharValue.CharcFromAmount,
      @Semantics.amount.currencyCode: 'Currency'
      CharValue.CharcToAmount,
      CharValue.Currency
}
where
  CharValue.ClassType = '023'
