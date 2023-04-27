@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Redeterminação PIS COFINS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MM_REDETERMINA_PISCOF
  as select from ztmm_red_piscof

  association [0..1] to ZI_CA_VH_EKORG         as _ekorg         on _ekorg.PurchasingOrganization = $projection.ekorg
  association [0..1] to ZI_CA_VH_WERKS         as _werks         on _werks.WerksCode = $projection.werks
  association [0..1] to ZI_CA_VH_LIFNR         as _lifnr         on _lifnr.LifnrCode = $projection.lifnr
  association [0..1] to ZI_CA_VH_MATERIAL      as _matnr         on _matnr.Material = $projection.matnr
  association [0..1] to ZI_MM_VH_KNTTP         as _knttp         on _knttp.AccountAssignmentCategory = $projection.knttp
  association [0..1] to ZI_CA_VH_SAKNR_PC3C    as _skat          on _skat.GLAccount = $projection.sakto
  association [0..1] to ZI_CA_VH_CFOP          as _cfop          on _cfop.Cfop = $projection.cfop
  association [0..1] to ZI_CA_VH_TAXLAW_PIS    as _taxlaw_pis    on _taxlaw_pis.Taxlaw = $projection.taxlaw_pis
  association [0..1] to ZI_CA_VH_TAXLAW_COFINS as _taxlaw_cofins on _taxlaw_cofins.Taxlaw = $projection.taxlaw_cofins

{
  key id                                   as id,
      ekorg                                as ekorg,
      _ekorg.PurchasingOrganizationText    as ekorg_txt,
      werks                                as werks,
      _werks.WerksCodeName                 as werks_txt,
      lifnr                                as lifnr,
      _lifnr.LifnrCodeName                 as lifnr_txt,
      matnr                                as matnr,
      _matnr.Text                          as matnr_txt,
      knttp                                as knttp,
      _knttp.AccountAssignmentCategoryName as knttp_txt,
      sakto                                as sakto,
      _skat.GLAccountLongName              as sakto_txt,
      cast( cfop as abap.char(10) )        as cfop,

      cast( case when cfop is not initial
                 then concat( substring(cfop, 1, 4),
                      concat('/', substring(cfop, 5, 2) ) )
                 else cfop end
                 as abap.char(10) )        as cfop_mask,
      _cfop,
      taxlaw_pis                           as taxlaw_pis,
      _taxlaw_pis.Descrip                  as taxlaw_pis_txt,
      _taxlaw_pis.Taxsit                   as taxsit_pis,
      _taxlaw_pis.DescripTaxsit            as taxsit_pis_txt,
      taxlaw_cofins                        as taxlaw_cofins,
      _taxlaw_cofins.Descrip               as taxlaw_cofins_txt,
      _taxlaw_cofins.Taxsit                as taxsit_cofins,
      _taxlaw_cofins.DescripTaxsit         as taxsit_cofins_txt,
      @Semantics.user.createdBy: true
      created_by                           as createdby,
      @Semantics.systemDateTime.createdAt: true
      created_at                           as createdat,
      @Semantics.user.lastChangedBy: true
      last_changed_by                      as lastchangedby,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                      as lastchangedat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                as locallastchangedat

}
