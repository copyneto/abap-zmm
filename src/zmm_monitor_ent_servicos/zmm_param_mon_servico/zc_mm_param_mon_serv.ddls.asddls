@EndUserText.label: 'Parâmetro determinação IVA/CFOP/CTG'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_MM_PARAM_MON_SERV
  as projection on ZI_MM_PARAM_MON_SERV
{
      @ObjectModel.text.element: ['TextBranch']
  key Branch,
      @ObjectModel.text.element: ['TextWerks']
  key Werks,
      @ObjectModel.text.element: ['TextMatnr']
  key Matnr,
      @ObjectModel.text.element: ['TextMatkl']
  key Matkl,
//      @ObjectModel.text.element: ['TextSkat']
  key Hkont,
      @ObjectModel.text.element: ['TextOperacao']
  key Operacao,
      Mwskz,
      Cfop,
      @ObjectModel.text.element: ['TextNftype']
      J1bnftype,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Branch.BusinessPlaceName as TextBranch,
      _Werks.WerksCodeName      as TextWerks,
      _Matnr.Text               as TextMatnr,
      _Matkl.Text               as TextMatkl,
//      _Skat.Text                as TextSkat,
      _Oper.TextOperacao        as TextOperacao,
      _Nftyp.BR_NFTypeName      as TextNftype

}
