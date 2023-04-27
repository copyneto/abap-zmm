@EndUserText.label: 'Exped. Insumos - Especial - Armazenagem'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_EXPED_ARMAZENAGEM
  as projection on ZI_MM_EXPED_ARMAZENAGEM

  association [0..1] to ZI_CA_VH_LIFNR      as _VHLifnr on _VHLifnr.LifnrCode = $projection.Transptdr
  association [0..1] to ZI_CA_VH_INCO1_VIEW as _VHInco1 on _VHInco1.inco1 = $projection.Incoterms1
  association [0..1] to ZI_MM_VH_ARMZ_TXSDC as _VHTxsdc on _VHTxsdc.taxcode = $projection.txsdc
  association [0..1] to ZI_MM_VH_TXSDC as _VHTxsdc1 on _VHTxsdc1.taxcode = $projection.txsdc
{
  key     Docnum,
  key     Itmnum,
          @ObjectModel.text.element: ['name1']
          Werks,
          Parid,
          @ObjectModel.text.element: ['Maktx']
          Matnr,
          Maktx,
          Menge,
          Meins,
          Charg,
          @ObjectModel.text.element: ['NameFornc']
          Emlif,
          NameFornc,
          Vbeln,
          Status,
          StatusCriticality,
          XML_EntIns,
          Mblnr,
          DocDocnum,
          DocPSTDAT,
          DocNFENUM,
          Transptdr,
          Incoterms1,
          Incoterms2,
          TRAID,
          txsdc,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO_ARMAZ' }
  virtual URL_est     : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO_ARMAZ' }
  virtual URL_Docnum  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO_ARMAZ' }
  virtual URL_Remessa : eso_longtext,
          _URL.Estornar,
          _T001wsh.name1,

          _VHLifnr,
          _VHInco1,
          _VHTxsdc,
          _VHTxsdc1

}
