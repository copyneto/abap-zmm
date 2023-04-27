@EndUserText.label: 'Emissão de NF de Inventário'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_MM_INVENTARIO_NFE_EMISSAO
  as projection on ZI_MM_INVENTARIO_NFE_EMISSAO
{
  key iblnr,
  key gjahr,
  key Bukrs,
  key werks,
  key lgort,
  key bldat,
  key Mblnr,
  key zeili,
  key NodeID       as ID,
  key ParentNodeID as ParentID,
  key HierLevel,
  key DrillState   as DrillDownState,
      WerksName,
      LgortName,
      budat,
      usnam,
      DocnumEntrada,
      DocnumSaida,
      Belnr,
      Belnr_estorn,
      Status_belnr,
      BukrsName,
      Nfenum_en,
      status_nf_en,
      nfenum,
      Docstat_icon,
      status_nf,
      docstat_icon_en,
      matnr,
      Maktx,
      buchm,
      menge,
      meins,
      Difmg
}
