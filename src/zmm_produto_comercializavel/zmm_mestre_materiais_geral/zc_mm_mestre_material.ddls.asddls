@EndUserText.label: 'Projeção Dados Mestre de Materiais'
@ObjectModel.query.implementedBy: 'ABAP:ZCLMM_MESTRE_MATERIAIS'

@UI: {
  headerInfo: {
  typeName: 'Material',
  typeNamePlural: 'Materiais'
  }
}
define custom entity ZC_MM_MESTRE_MATERIAL
{
      @UI.facet       : [
        {
          targetQualifier: 'DadosGerais',
          type        : #FIELDGROUP_REFERENCE,
          purpose     : #FILTER
        }
      ]
      @Consumption.semanticObject: 'zMaterial'
      @UI             : { lineItem:       [{ position: 10, type: #WITH_INTENT_BASED_NAVIGATION, semanticObjectAction: 'zzdisplay', importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_MATERIAL', element: 'Product' } }]
  key Product         : matnr;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_CENTRO', element: 'Plant' } }]
  key werks           : werks_d;

  key bwtar           : bwtar_d;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_IDRFB', element: 'Idrfb' } }]
  key idrfb           : ze_id_rfb;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
  key vtweg           : vtweg;

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } }]
  key vkorg           : vkorg;

  key bwkey           : bwkey;

      @UI             : {lineItem:       [{position: 20, importance: #HIGH}] }
      @EndUserText.label: 'Descrição PT'
      maktx           : maktx; //MAKT

      @EndUserText.label: 'Descrição EN'
      maktx2          : maktx; //MAKT

      @EndUserText.label: 'Descrição ES'
      maktx3          : maktx; //MAKT

      @UI             : { lineItem:       [ { position: 30, importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_TIPO_MATERIAL', element: 'ProductType' } }]
      mtart           : mtart;

      @UI             : { lineItem:       [ { position: 35, importance: #HIGH } ] }
      mtbez           : mtbez;

      @UI             : { lineItem:       [ { position: 40, importance: #HIGH } ] }
      @Consumption.filter.selectionType: #INTERVAL
      ersda           : ersda;

      @UI             : { lineItem:       [{ position: 50, importance: #HIGH}],
                          fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ernam           : ernam;

      @UI             : { lineItem:       [{ position: 60, importance: #HIGH}],
                          fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      laeda           : laeda;

      @UI             : { lineItem:       [{ position: 70, importance: #HIGH}],
                          fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      aenam           : aenam;

      @UI             : {lineItem:       [{position: 80, importance: #HIGH}] }
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_ProductStatus', element: 'Status'} }]
      mstae           : mstae;

      @UI             : {lineItem:       [{position: 90, importance: #HIGH}] }
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_ProductStatus', element: 'Status'}}]
      mmsta           : mmsta; //MARC
      @UI             : {lineItem:       [{position: 100, importance: #HIGH}] }
      vmsta           : vmsta; //MVKE

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_VISAO', element: 'VisionId' } }]
      @Consumption.filter: { selectionType: #SINGLE }
      @EndUserText.label: '20'
      vpsta           : vpsta;

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_MSTAV', element: 'StatusMaterial'}}]
      mstav           : mstav;

      @Consumption.filter.selectionType: #SINGLE
      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }

      lvorm           : lvoma;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      pstat           : pstat_d;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mbrsh           : mbrsh;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      matkl           : matkl;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      bismt           : bismt;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      meins           : meins;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      blanz           : blanz;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      groes           : groes;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      wrkst           : wrkst;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      normt           : normt;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      brgew           : brgew;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ntgew           : ntgew;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      @Semantics.unitOfMeasure: true
      gewei           : gewei;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      volum           : volum;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      raube           : raube;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      tragr           : tragr;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      spart           : spart;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      kunnr           : kunnr;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      eannr           : eannr;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      wesch           : wesch;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      bwvor           : bwvor;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      bwscl           : bwscl;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      saiso           : saiso;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      etiar           : etiar;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      etifo           : etifo;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      entar           : entar;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ean11           : ean11;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      numtp           : numtp;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      laeng           : laeng;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      breit           : breit;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      hoehe           : hoehe;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      meabm           : meabm;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      prdha           : prodh_d;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      aeklk           : ck_aeklk;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      cadkz           : cadkz;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      qmpur           : qmpur;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ergew           : ergew;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ergei           : ergei;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ervol           : ervol;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      ervoe           : ervoe;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      gewto           : gewto;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      volto           : volto;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      vabme           : vabme;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      kzrev           : kzrev;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      kzkfg           : kzkfg;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      @EndUserText.label: 'Admin.lotes - Dados gerais'
      xchpf           : xchpf;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      vhart           : vhart;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      fuelg           : fuelg;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      stfak           : stfak;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      magrv           : magrv;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      begru           : begru;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      datab           : datab;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      liqdt           : liqdt;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      saisj           : saisj;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      plgtp           : plgtp;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mlgut           : w_mitleerg;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      extwg           : extwg;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      satnr           : satnr;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      attyp           : attyp;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      kzkup           : kzkup;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      kznfm           : kznfm;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      pmata           : pmata;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mstde           : mstde;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mstdv           : mstdv;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      taklv           : taklv;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      rbnrm           : rbnr;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mhdrz           : mhdrz;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mhdhb           : mhdhb;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      mhdlp           : mhdlp;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      inhme           : inhme;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      inhal           : inhal;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      vpreh           : vpreh;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      etiag           : etiag;

      @UI             : { fieldGroup:     [{ qualifier: 'DadosGerais', groupLabel: 'Dados Gerais' } ] }
      //      iprkz      : dattp;
      mtpos_mara      : mtpos_mara;

      //      marc.pstat,
      //      marc.lvorm,
      bwtty           : bwtty_d;
      @EndUserText.label: 'Admin.lotes - Dados de centro'
      xchar           : xchar;
      mmstd           : mmstd;
      maabc           : maabc;
      kzkri           : kzkri;
      ekgrp           : ekgrp;
      ausme           : ausme;
      dispr           : dispr;
      dismm           : dismm;
      dispo           : dispo;
      kzdie           : kzdie;
      plifz           : plifz;
      webaz           : webaz;
      perkz           : perkz;
      ausss           : ausss;
      disls           : disls;
      beskz           : beskz;
      sobsl           : sobsl;
      minbe           : minbe;
      eisbe           : eisbe;
      bstmi           : bstmi;
      bstma           : bstma;
      bstfe           : bstfe;
      bstrf           : bstrf;
      mabst           : mabst;
      @Semantics.amount.currencyCode: 'waers'
      losfx           : losfx;
      sbdkz           : sbdkz;
      bearz           : bearz;
      ruezt           : ruezt;
      tranz           : tranz;
      basmg           : basmg;
      dzeit           : dzeit;
      maxlz           : maxlz;
      lzeih           : lzeih;
      kzpro           : kzpro;
      gpmkz           : gpmkz;
      ueeto           : ueeto;
      ueetk           : ueetk;
      uneto           : uneto;
      wzeit           : wzeit;
      atpkz           : atpkz;
      vzusl           : vzusl;
      herbl           : herbl;
      insmk           : insmk;
      sproz           : sproz;
      quazt           : quazt;
      ssqss           : ssqss;
      mpdau           : mpdau;
      kzppv           : kzppv;
      kzdkz           : kzdkz;
      wstgh           : wstgh;
      prfrq           : prfrq;
      nkmpr           : nkmpr;
      umlmc           : umlme;
      ladgr           : ladgr;
      //      marc.xchpf,
      usequ           : usequ;
      lgrad           : lgrad;
      auftl           : auftl;
      plvar           : plvar;
      otype           : otype;
      objid           : objid;
      mtvfp           : mtvfp;
      vrvez           : vrvez;
      vbamg           : vbamg;
      vbeaz           : vbeaz;
      lizyk           : lizyk;
      prctr           : prctr;
      trame           : trame;
      mrppp           : mrppp;
      sauft           : sa_sauft;
      fxhor           : fxhor;
      vrmod           : vrmod;
      vint1           : vint1;
      vint2           : vint2;
      losgr           : losgr;
      sobsk           : ck_sobsl;
      kausf           : kausf;
      qzgtp           : qzgtyp;
      qmatv           : qmatv;
      takzt           : takzt;
      rwpro           : rwpro;
      copam           : copam;
      @EndUserText.label: 'Cód.inv.físico IR - Dados de centros'
      abcin           : abcin;
      awsls           : awsls;
      sernp           : serail;
      cuobj           : cuobj;
      vrbfk           : vrbfk;
      cuobv           : cuobv;
      resvp           : resvp;
      plnty           : plnty;
      abfac           : oil_abfac;
      sfcpf           : co_prodprf;
      shflg           : shflg;
      shzet           : shzet;
      @Semantics.amount.currencyCode: 'waers'
      vkumc           : vkumc;
      @Semantics.amount.currencyCode: 'waers'
      vktrw           : vktrw;
      kzagl           : kzagl;
      glgmg           : glgmg;
      @Semantics.amount.currencyCode: 'waers'
      vkglg           : vkglg;
      indus           : j_1bindus3;
      steuc           : steuc;
      dplho           : dplho;
      minls           : minls;
      maxls           : maxls;
      fixls           : cscp_fixlotsize;
      ltinc           : cscp_lotincrement;
      compl           : compl;
      mcrue           : mcrue;
      lfmon           : lfmon;
      lfgja           : lfgja;
      eislo           : eislo;
      ncost           : ck_no_costing;
      bwesb           : bwesb;
      gi_pr_time      : wrf_pscd_wabaz;
      min_troc        : wrf_fre_troc_min;
      max_troc        : wrf_fre_troc_max;
      target_stock    : wrf_fre_target_stock;

      waers           : waers;


      //mbew.LVORM,
      lbkum           : lbkum;
      @Semantics.amount.currencyCode: 'waers'
      salk3           : salk3;
      vprsv           : vprsv;
      @Semantics.amount.currencyCode: 'waers'
      verpr           : verpr;
      @Semantics.amount.currencyCode: 'waers'
      stprs           : stprs;
      peinh           : peinh;

      bklas           : bklas;

      @Semantics.amount.currencyCode: 'waers'
      salkv           : salkv;
      vmkum           : vmkum;
      @Semantics.amount.currencyCode: 'waers'
      vmsal           : vmsal;
      vmvpr           : vmvpr;
      @Semantics.amount.currencyCode: 'waers'
      vmver           : vmver;
      @Semantics.amount.currencyCode: 'waers'
      vmstp           : vmstp;
      vmpei           : vmpei;
      vmbkl           : vmbkl;
      @Semantics.amount.currencyCode: 'waers'
      vmsav           : vmsav;
      vjkum           : vjkum;
      @Semantics.amount.currencyCode: 'waers'
      vjsal           : vjsal;
      vjvpr           : vjvpr;
      @Semantics.amount.currencyCode: 'waers'
      vjver           : vjver;
      @Semantics.amount.currencyCode: 'waers'
      vjstp           : vjstp;
      vjpei           : vjpei;
      vjbkl           : vjbkl;
      @Semantics.amount.currencyCode: 'waers'
      vjsav           : vjsav;
      //mbew.LFGJA,
      //mbew.LFMON,
      //mbew.BWTTY,
      @Semantics.amount.currencyCode: 'waers'
      stprv           : stprv;
      laepr           : laepr;
      @Semantics.amount.currencyCode: 'waers'
      zkprs           : dzkprs;
      zkdat           : dzkdat;
      timestamp       : timestamp;
      @Semantics.amount.currencyCode: 'waers'
      bwprs           : bwprs;
      @Semantics.amount.currencyCode: 'waers'
      bwprh           : bwprh;
      @Semantics.amount.currencyCode: 'waers'
      vjbws           : vjbws;
      @Semantics.amount.currencyCode: 'waers'
      vjbwh           : vjbwh;
      @Semantics.amount.currencyCode: 'waers'
      vvjsl           : vvjsl;
      vvjlb           : vvjlb;
      vvmlb           : vvmlb;
      @Semantics.amount.currencyCode: 'waers'
      vvsal           : vvsal;
      @Semantics.amount.currencyCode: 'waers'
      zplpr           : dzplpr;
      @Semantics.amount.currencyCode: 'waers'
      zplp1           : dzplp1;
      @Semantics.amount.currencyCode: 'waers'
      zplp2           : dzplp2;
      @Semantics.amount.currencyCode: 'waers'
      zplp3           : dzplp3;
      zpld1           : dzpld1;
      zpld2           : dzpld2;
      zpld3           : dzpld3;
      //      pperz        : pperz;
      //      pperl        : pperl;
      //      pperv        : pperv;
      kalkz           : kalkz;
      kalkl           : kalkl;
      kalkv           : kalkv;
      kalsc           : kalsc;
      xlifo           : xlifo;
      mypol           : mypool;
      @Semantics.amount.currencyCode: 'waers'
      bwph1           : bwph1;
      @Semantics.amount.currencyCode: 'waers'
      bwps1           : bwps1;
      abwkz           : abwkz;
      //mbew.PSTAT,
      kaln1           : ck_kalnr1;
      kalnr           : kalnr;
      bwva1           : ck_bwva1;
      bwva2           : ck_bwva2;
      bwva3           : ck_bwva3;
      vers1           : ck_tvers1;
      vers2           : ck_tvers2;
      vers3           : ck_tvers3;
      hrkft           : hrkft;
      kosgr           : ck_kosgr;
      pprdz           : pprdz;
      pprdl           : ck_pprdl;
      pprdv           : ck_pprdv;
      pdatz           : ck_pdatz;
      pdatl           : ck_pdatl;
      pdatv           : ck_pdatv;
      ekalr           : ck_ekalrel;
      @Semantics.amount.currencyCode: 'waers'
      vplpr           : vplpr;
      mlmaa           : mlmaa;
      mlast           : ck_ml_abst;
      @Semantics.amount.currencyCode: 'waers'
      lplpr           : ck_lplpr;
      @Semantics.amount.currencyCode: 'waers'
      vksal           : vksal;
      hkmat           : hkmat;
      sperw           : sperr;
      kziwl           : kziwl;
      wlinl           : dlinl;
      @EndUserText.label: 'Cód.inv.físico IR - Dados de avaliação'
      abciw           : abcin;
      bwspa           : bwspa;
      @Semantics.amount.currencyCode: 'waers'
      lplpx           : ck_lplpx;
      @Semantics.amount.currencyCode: 'waers'
      vplpx           : ck_vplpx;
      @Semantics.amount.currencyCode: 'waers'
      fplpx           : ck_zplpx;
      lbwst           : ck_lbwst;
      vbwst           : ck_vbwst;
      fbwst           : ck_zbwst;
      eklas           : eklas;
      qklas           : qklas;
      mtuse           : j_1bmatuse;
      mtorg           : j_1bmatorg;
      ownpr           : j_1bownpro;
      xbewm           : xbeww;
      bwpei           : bwpei;
      mbrue           : mbrue;
      oklas           : oklas;
      oippinv         : jv_ppinv;
      versg           : versg;
      bonus           : bonus;
      provg           : provg;
      sktof           : sktof;
      vmstd           : vmstd;
      aumng           : aumng;
      lfmng           : minlf;
      efmng           : efmng;
      scmng           : scmng;
      schme           : schme;
      vrkme           : vrkme;
      mtpos           : mtpos;
      dwerk           : dwerk;
      prodh           : prodh_d;
      pmatn           : pmatn;
      kondm           : kondm;
      ktgrm           : ktgrm;
      mvgr1           : mvgr1;
      prat1           : prat1;
      lfmax           : maxlf;
      pvmso           : pvmso;
      /bev1/emdrckspl : /bev1/emprtcol;

}
