@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissão de NF de Inventário'

define root view entity ZI_MM_INVENTARIO_NFE_EMISSAO
  as select from ZC_MM_ALIVIUM as _Alivium
  association to ZI_CA_VH_COMPANY  as _Bukrs on  $projection.Bukrs = _Bukrs.CompanyCode
  association to ZI_CA_VH_WERKS    as _Werks on  $projection.werks = _Werks.WerksCode
  association to ZI_CA_VH_DEPOSITO as _Lgort on  $projection.lgort = _Lgort.Lgort
                                             and $projection.werks = _Lgort.Werks
  association to ZI_CA_VH_MATERIAL as _Matnr on  $projection.matnr = _Matnr.Material
{
  key iblnr,
      //      @Consumption.filter.mandatory: true
      @Semantics.fiscal.year: true
      @Consumption.filter.selectionType: #SINGLE
  key gjahr,
      @Consumption.valueHelpDefinition: [{ entity:{ element: 'CompanyCode', name: 'ZI_CA_VH_COMPANY' } }]
  key Bukrs,
      @Consumption.valueHelpDefinition: [{ entity:{ element: 'WerksCode', name: 'ZI_CA_VH_WERKS' } }]
      @ObjectModel.text.element: ['WerksName']
  key werks,
      @Consumption.valueHelpDefinition: [{ entity:{ element: 'Lgort', name: 'ZI_CA_VH_DEPOSITO' },
                   additionalBinding: [{ localElement: 'werks', element: 'Werks', usage: #FILTER_AND_RESULT }] }]
      @ObjectModel.text.element: ['LgortName']
  key lgort,
      @Consumption.filter.selectionType: #INTERVAL
  key cast(
        case
          when dats_is_valid(bldat) = 0
            then '00010101'
          else
            bldat
        end as bldat )        as bldat,
  key Mblnr,
  key zeili,
      key _Alivium.NodeID,
      key _Alivium.ParentNodeID,
      key _Alivium.HierarchyLevel as HierLevel,
      key _Alivium.DrillState,
      _Werks.WerksCodeName    as WerksName,
      _Lgort.Lgobe            as LgortName,
      @Consumption.filter.selectionType: #INTERVAL
      cast(
        case
          when dats_is_valid(budat) = 0
            then '19000101'
        else
          budat
        end as budat )        as budat,
      usnam,
      DocnumEntrada,
      DocnumSaida,
      Belnr,
      Belnr_estorn,
      Status_belnr,
      @ObjectModel.text.element: ['BukrsName']
      _Bukrs.CompanyCodeName  as BukrsName,
      Nfenum_en,

      nfenum,
      Docstat_icon,

      case
        when status_nf_en is not initial
          then ''
        else
          status_nf
      end                     as status_nf,

      case
        when DocnumEntrada is initial
          then ''
        when nfenum is initial
          then 'sap-icon://warning2'    // '-1'
        when nfenum is not initial and docstat is initial
          then 'sap-icon://activities'  // '0'
        when ( docstat = '1' and code <> '100' ) or cancel = 'X'
          then 'sap-icon://complete'    // '1'
        when docstat = '2'
         then 'sap-icon://alert'        // '2'
        else
          'sap-icon://error'            // '3'
      end                     as docstat_icon_en,

      case
        when DocnumEntrada is not initial and ( code <> '100' and docstat = '1' ) or cancel = 'X'
          then 'sap-icon://undo'        // 'X'
        else
          ''
      end                     as status_nf_en,

      @Consumption.valueHelpDefinition: [{ entity:{ element: 'Material', name: 'ZI_CA_VH_MATERIAL' } }]
      @ObjectModel.text.element: ['Maktx']
      matnr,
      _Matnr.Text             as Maktx,
      buchm,
      @Semantics.quantity.unitOfMeasure: 'meins'
      menge,
      meins,
      Difmg,

      _Werks,
      _Lgort,
      _Bukrs,
      _Matnr,

      _Alivium.last_changed_at,
      _Alivium.last_changed_by,
      _Alivium.created_at,
      _Alivium.created_by,
      _Alivium.local_last_changed_at
}
