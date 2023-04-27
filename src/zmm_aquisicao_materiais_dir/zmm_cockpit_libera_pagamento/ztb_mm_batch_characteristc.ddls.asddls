@EndUserText.label: 'AMDP - Get Batch Characteristic'
define table function ZTB_MM_BATCH_CHARACTERISTC
returns
{
  key mandt               : abap.clnt;
  key objek               : cuobn;
      Characteristic      : atnam;
      CharacteristicValue : abap.dec(23,6);
}
implemented by method
  zcl_mm_batch_charac=>get_gv_charac;
