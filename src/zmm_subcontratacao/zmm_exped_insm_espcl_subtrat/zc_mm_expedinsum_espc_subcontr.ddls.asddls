@EndUserText.label: 'Exped.Insumos-Especial - Subcontratação'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_EXPEDINSUM_ESPC_SUBCONTR
  as projection on ZI_MM_EXPEDINSUM_ESPC_SUBCONTR

  association [0..1] to ZI_CA_VH_LIFNR      as _VHLifnr on _VHLifnr.LifnrCode = $projection.Transptdr
  association [0..1] to ZI_CA_VH_INCO1_VIEW as _VHInco1 on _VHInco1.inco1 = $projection.Incoterms1

{

  key     Rsnum,
  key     Rspos,
  key     Vbeln,
          Bdart,
          @ObjectModel.text.element: ['DesCentro']
          Werks,
          @ObjectModel.text.element: ['DescMat']
          Matnr,
          Ebeln,
          Ebelp,
          Bdter,
          @ObjectModel.text.element: ['DescFornec']
          Lifnr,
          Meins,
          DescFornec,
          Status,
          StatusCriticality,
          XmlEntrad,
          Mblnr,
          Docnum,
          _URL.Estornar,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO' }
  virtual URL_est     : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO' }
  virtual URL_Docnum  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_ESTORNO' }
  virtual URL_Remessa : eso_longtext,
          Pstdat,
          Nfenum,
          Quantidade,
          _Makt.maktx    as DescMat,
          _T001wsh.name1 as DesCentro,
          XML_Transp,
          Transptdr,
          Incoterms1,
          Incoterms2,
          TRAID,
          txsdc,

          /* Associations */
//          _Makt,
//          _T001wsh,
//          _URL,
          _VHLifnr,
          _VHInco1

}
