@EndUserText.label: 'Projection ADM Ret de Arm Grao Verde'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//@UI.presentationVariant: [{ sortOrder: [ { by: 'MaterialAtribuido', direction: #DESC } ] } ]
define root view entity ZC_MM_RET_ARM_GRAOVERDE
  as projection on ZI_MM_RET_ARM_GRAOVERDE

  association [0..1] to ZI_CA_VH_MATERIAL as _VhMaterial on _VhMaterial.Material = $projection.MaterialAtribuido

{
                       @EndUserText.label: 'Fornecedor'
                       @ObjectModel.text.element: ['TextLifnr']
  key                  LifnrCode,
                       @ObjectModel.text.element: ['TextWerks']
                       @EndUserText.label: 'Centro'
  key                  WerksCode,
  key                  Cfop,
  key                  Nnf,
                       @EndUserText.label: 'XML'
  key                  XML,
                       @EndUserText.label: 'Data Emissão'
                       @Consumption.filter.selectionType: #INTERVAL
  key                  DataEmissao,
  key                  Nitem,
                       // BR_NotaFiscal,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              Credat            : j_1bcredat,
                       //      @ObjectModel.text.element: ['MatnrName']
                       //      Material,
                       //      _Makt.maktx          as MatnrName,
                       //      Material,
                       @ObjectModel.text.element: ['MaterialText']
                       MaterialAtribuido,
                       @ObjectModel.text.element: ['MatRemText']
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              MaterialRemess    : matnr,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              MatRemText        : maktx,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              charg             : charg_d,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              ERFME             : erfme,
                       @Semantics.quantity.unitOfMeasure: 'ERFME'
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              qtde              : labst,
                       //      _Makt2.maktx         as MatnrName2,
                       @ObjectModel.text.element: ['ProcDesc']
                       @UI.textArrangement: #TEXT_LAST
                       Processo,
                       DocNum,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              DocNum2           : j_1bdocnum,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              DocMaterial       : mblnr,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              Status            : char12,
                       @ObjectModel: { virtualElement: true,
                                       virtualElementCalculatedBy: 'ABAP:ZCLMM_VIRTL_GRAO_VERDE' }
  virtual              StatusCriticality : int1,
                       //      LifnrCodeName,
                       //      Xprod,
                       Qcom,
                       Ucom,
                       Vprod,
                       Cprod,
                       Serie,
  virtual              Lote              : charg_d,
                       //                  MatRetorno,

                       _WERKS.WerksCodeName as TextWerks,
                       _LIFNR.LifnrCodeName as TextLifnr,
                       //_Matnr.Text          as TextMatnr,
                       //Material,
                       MaterialText,
                       _Process.Descricao   as ProcDesc,

                       /* Associations */
                       _LIFNR,
                       _NNF,
                       //                  _STATUS,
                       _WERKS,
                       _VhMaterial
}
