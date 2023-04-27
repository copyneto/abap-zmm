@EndUserText.label: 'Exped. Insumos - Subcontratação'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_EXPED_SUBCONTRAT
  as projection on ZI_MM_EXPED_SUBCONTRAT

  association [0..1] to ZI_CA_VH_LIFNR      as _VHLifnr on _VHLifnr.LifnrCode = $projection.Transptdr
  association [0..1] to ZI_CA_VH_INCO1_VIEW as _VHInco1 on _VHInco1.inco1 = $projection.Incoterms1

{
  key     Rsnum,
  key     Rspos,
  key     Item, 
  key     Vbeln,
          Ebeln,
          Ebelp,
          BDTER,
          @ObjectModel.text.element: ['WerksName']
          Werks,
          _Werks.WerksCodeName as WerksName,
          @ObjectModel.text.element: ['DescForn']
          Lifnr,
          DescForn,
          @ObjectModel.text.element: ['MatnrName']
          Matnr,
          _Makt.maktx          as MatnrName,
          Meins,
          Charg,
          Picking,
          NewPicking, 
          Status,
          StatusCriticality,
          Mblnr,
          //          Docnum,
          BR_NotaFiscal,
          PSTDAT,
          NFENUM,
          Quantidade,
          _URL.Estornar,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_SUBCT_ESTORNO' }
  virtual URL_est     : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_SUBCT_ESTORNO' }
  virtual URL_Docnum  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_SUBCT_ESTORNO' }
  virtual URL_Remessa : eso_longtext,
          //          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } }]
          Transptdr,
          @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_CA_VH_INCO1_VIEW', element: 'inco1' } }]
          Incoterms1,
          Incoterms2,
          TRAID,
          txsdc,
          
          _VHLifnr,
          _VHInco1
          
//          _Item : redirected to composition child Zc_MM_EXPED_SUBCONTRAT_ITEM

          //      /* Associations */
          //      _Makt
          
          
}
