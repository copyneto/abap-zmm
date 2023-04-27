@EndUserText.label: 'Projeção ZI'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['sequence','ebeln','ebelp','nfnum','CompanyCode','Material','Plant']
define root view entity ZC_MM_01_CAFE
  as projection on ZI_MM_01_CAFE
{
              @Search.defaultSearchElement: true
  key         sequence,
              @Search.defaultSearchElement: true
  key         ebeln,
              @Search.defaultSearchElement: true
  key         ebelp,
              @Search.defaultSearchElement: true
  key         nfnum,
              @Search.defaultSearchElement: true
  key         CompanyCode,
              @Search.defaultSearchElement: true
  key         Material,
              @Search.defaultSearchElement: true
  key         Plant,
              @Search.defaultSearchElement: true
  key         BR_NotaFiscal,
              @Search.defaultSearchElement: true
  key         BR_NotaFiscalItem,
              status_armazenado,
//              CHARG,
              dt_entrada,
              vbeln,
              peso_dif_ori,
              qtde_dif_ori,
              calc_dif_pesoas,
              calc_dif_qtdeas,
              menge,
              QTD_TOTAL_KG,
              PESO_DIF_NF,
              StatusCriticality,
              QTD_DIF_NF,
              StatusCriticality2,
              BATCH_NUMBER,
              BR_NFIssuerNameFrmtdDesc,
              BR_NFPostingDate,
              BR_NFTotalAmount,
              QuantityInBaseUnit,
              BaseUnit,
              QTD_TOTAL_SACAS,
              @ObjectModel: { virtualElement: true, virtualElementCalculatedBy: 'ABAP:ZCLMM_URL_MAT_ESTOC' }
  virtual     URL_sequence : eso_longtext,
              Batch,
              ceinm,
              lgort,
              meins,
              CreatedBy,
              CreatedAt,
              LastChangedBy,
              LastChangedAt,
              LocalLastChangedAt
}
