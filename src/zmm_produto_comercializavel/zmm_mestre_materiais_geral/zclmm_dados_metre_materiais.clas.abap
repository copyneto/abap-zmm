CLASS zclmm_dados_metre_materiais DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES:
      if_amdp_marker_hdb.

    TYPES:

      BEGIN OF ty_param,
        matnr        TYPE if_rap_query_filter=>tt_range_option,
        werks        TYPE if_rap_query_filter=>tt_range_option,
        bwtar        TYPE if_rap_query_filter=>tt_range_option,
        idrfb        TYPE if_rap_query_filter=>tt_range_option,
        vtweg        TYPE if_rap_query_filter=>tt_range_option,
        vkorg        TYPE if_rap_query_filter=>tt_range_option,
        mtart        TYPE if_rap_query_filter=>tt_range_option,
        ersda        TYPE if_rap_query_filter=>tt_range_option,
        ernam        TYPE if_rap_query_filter=>tt_range_option,
        laeda        TYPE if_rap_query_filter=>tt_range_option,
        aenam        TYPE if_rap_query_filter=>tt_range_option,
        mstae        TYPE if_rap_query_filter=>tt_range_option,
        mmsta        TYPE if_rap_query_filter=>tt_range_option,
        vmsta        TYPE if_rap_query_filter=>tt_range_option,
        vpsta        TYPE if_rap_query_filter=>tt_range_option,
        mstav        TYPE if_rap_query_filter=>tt_range_option,
        lvorm        TYPE if_rap_query_filter=>tt_range_option,
        pstat        TYPE if_rap_query_filter=>tt_range_option,
        mbrsh        TYPE if_rap_query_filter=>tt_range_option,
        matkl        TYPE if_rap_query_filter=>tt_range_option,
        bismt        TYPE if_rap_query_filter=>tt_range_option,
        meins        TYPE if_rap_query_filter=>tt_range_option,
        blanz        TYPE if_rap_query_filter=>tt_range_option,
        groes        TYPE if_rap_query_filter=>tt_range_option,
        wrkst        TYPE if_rap_query_filter=>tt_range_option,
        normt        TYPE if_rap_query_filter=>tt_range_option,
        brgew        TYPE if_rap_query_filter=>tt_range_option,
        ntgew        TYPE if_rap_query_filter=>tt_range_option,
        gewei        TYPE if_rap_query_filter=>tt_range_option,
        volum        TYPE if_rap_query_filter=>tt_range_option,
        raube        TYPE if_rap_query_filter=>tt_range_option,
        tragr        TYPE if_rap_query_filter=>tt_range_option,
        spart        TYPE if_rap_query_filter=>tt_range_option,
        kunnr        TYPE if_rap_query_filter=>tt_range_option,
        eannr        TYPE if_rap_query_filter=>tt_range_option,
        wesch        TYPE if_rap_query_filter=>tt_range_option,
        bwvor        TYPE if_rap_query_filter=>tt_range_option,
        bwscl        TYPE if_rap_query_filter=>tt_range_option,
        saiso        TYPE if_rap_query_filter=>tt_range_option,
        etiar        TYPE if_rap_query_filter=>tt_range_option,
        etifo        TYPE if_rap_query_filter=>tt_range_option,
        entar        TYPE if_rap_query_filter=>tt_range_option,
        ean11        TYPE if_rap_query_filter=>tt_range_option,
        numtp        TYPE if_rap_query_filter=>tt_range_option,
        laeng        TYPE if_rap_query_filter=>tt_range_option,
        breit        TYPE if_rap_query_filter=>tt_range_option,
        hoehe        TYPE if_rap_query_filter=>tt_range_option,
        meabm        TYPE if_rap_query_filter=>tt_range_option,
        prdha        TYPE if_rap_query_filter=>tt_range_option,
        aeklk        TYPE if_rap_query_filter=>tt_range_option,
        cadkz        TYPE if_rap_query_filter=>tt_range_option,
        qmpur        TYPE if_rap_query_filter=>tt_range_option,
        ergew        TYPE if_rap_query_filter=>tt_range_option,
        ergei        TYPE if_rap_query_filter=>tt_range_option,
        ervol        TYPE if_rap_query_filter=>tt_range_option,
        ervoe        TYPE if_rap_query_filter=>tt_range_option,
        gewto        TYPE if_rap_query_filter=>tt_range_option,
        volto        TYPE if_rap_query_filter=>tt_range_option,
        vabme        TYPE if_rap_query_filter=>tt_range_option,
        kzrev        TYPE if_rap_query_filter=>tt_range_option,
        kzkfg        TYPE if_rap_query_filter=>tt_range_option,
        xchpf        TYPE if_rap_query_filter=>tt_range_option,
        vhart        TYPE if_rap_query_filter=>tt_range_option,
        fuelg        TYPE if_rap_query_filter=>tt_range_option,
        stfak        TYPE if_rap_query_filter=>tt_range_option,
        magrv        TYPE if_rap_query_filter=>tt_range_option,
        begru        TYPE if_rap_query_filter=>tt_range_option,
        datab        TYPE if_rap_query_filter=>tt_range_option,
        liqdt        TYPE if_rap_query_filter=>tt_range_option,
        saisj        TYPE if_rap_query_filter=>tt_range_option,
        plgtp        TYPE if_rap_query_filter=>tt_range_option,
        mlgut        TYPE if_rap_query_filter=>tt_range_option,
        extwg        TYPE if_rap_query_filter=>tt_range_option,
        satnr        TYPE if_rap_query_filter=>tt_range_option,
        attyp        TYPE if_rap_query_filter=>tt_range_option,
        kzkup        TYPE if_rap_query_filter=>tt_range_option,
        kznfm        TYPE if_rap_query_filter=>tt_range_option,
        pmata        TYPE if_rap_query_filter=>tt_range_option,
        mstde        TYPE if_rap_query_filter=>tt_range_option,
        mstdv        TYPE if_rap_query_filter=>tt_range_option,
        taklv        TYPE if_rap_query_filter=>tt_range_option,
        rbnrm        TYPE if_rap_query_filter=>tt_range_option,
        mhdrz        TYPE if_rap_query_filter=>tt_range_option,
        mhdhb        TYPE if_rap_query_filter=>tt_range_option,
        mhdlp        TYPE if_rap_query_filter=>tt_range_option,
        inhme        TYPE if_rap_query_filter=>tt_range_option,
        inhal        TYPE if_rap_query_filter=>tt_range_option,
        vpreh        TYPE if_rap_query_filter=>tt_range_option,
        etiag        TYPE if_rap_query_filter=>tt_range_option,
        mtpos_mara   TYPE if_rap_query_filter=>tt_range_option,
        bwtty        TYPE if_rap_query_filter=>tt_range_option,
        xchar        TYPE if_rap_query_filter=>tt_range_option,
        mmstd        TYPE if_rap_query_filter=>tt_range_option,
        maabc        TYPE if_rap_query_filter=>tt_range_option,
        kzkri        TYPE if_rap_query_filter=>tt_range_option,
        ekgrp        TYPE if_rap_query_filter=>tt_range_option,
        ausme        TYPE if_rap_query_filter=>tt_range_option,
        dispr        TYPE if_rap_query_filter=>tt_range_option,
        dismm        TYPE if_rap_query_filter=>tt_range_option,
        dispo        TYPE if_rap_query_filter=>tt_range_option,
        kzdie        TYPE if_rap_query_filter=>tt_range_option,
        plifz        TYPE if_rap_query_filter=>tt_range_option,
        webaz        TYPE if_rap_query_filter=>tt_range_option,
        perkz        TYPE if_rap_query_filter=>tt_range_option,
        ausss        TYPE if_rap_query_filter=>tt_range_option,
        disls        TYPE if_rap_query_filter=>tt_range_option,
        beskz        TYPE if_rap_query_filter=>tt_range_option,
        sobsl        TYPE if_rap_query_filter=>tt_range_option,
        minbe        TYPE if_rap_query_filter=>tt_range_option,
        eisbe        TYPE if_rap_query_filter=>tt_range_option,
        bstmi        TYPE if_rap_query_filter=>tt_range_option,
        bstma        TYPE if_rap_query_filter=>tt_range_option,
        bstfe        TYPE if_rap_query_filter=>tt_range_option,
        bstrf        TYPE if_rap_query_filter=>tt_range_option,
        mabst        TYPE if_rap_query_filter=>tt_range_option,
        losfx        TYPE if_rap_query_filter=>tt_range_option,
        sbdkz        TYPE if_rap_query_filter=>tt_range_option,
        bearz        TYPE if_rap_query_filter=>tt_range_option,
        ruezt        TYPE if_rap_query_filter=>tt_range_option,
        tranz        TYPE if_rap_query_filter=>tt_range_option,
        basmg        TYPE if_rap_query_filter=>tt_range_option,
        dzeit        TYPE if_rap_query_filter=>tt_range_option,
        maxlz        TYPE if_rap_query_filter=>tt_range_option,
        lzeih        TYPE if_rap_query_filter=>tt_range_option,
        kzpro        TYPE if_rap_query_filter=>tt_range_option,
        gpmkz        TYPE if_rap_query_filter=>tt_range_option,
        ueeto        TYPE if_rap_query_filter=>tt_range_option,
        ueetk        TYPE if_rap_query_filter=>tt_range_option,
        uneto        TYPE if_rap_query_filter=>tt_range_option,
        wzeit        TYPE if_rap_query_filter=>tt_range_option,
        atpkz        TYPE if_rap_query_filter=>tt_range_option,
        vzusl        TYPE if_rap_query_filter=>tt_range_option,
        herbl        TYPE if_rap_query_filter=>tt_range_option,
        insmk        TYPE if_rap_query_filter=>tt_range_option,
        sproz        TYPE if_rap_query_filter=>tt_range_option,
        quazt        TYPE if_rap_query_filter=>tt_range_option,
        ssqss        TYPE if_rap_query_filter=>tt_range_option,
        mpdau        TYPE if_rap_query_filter=>tt_range_option,
        kzppv        TYPE if_rap_query_filter=>tt_range_option,
        kzdkz        TYPE if_rap_query_filter=>tt_range_option,
        wstgh        TYPE if_rap_query_filter=>tt_range_option,
        prfrq        TYPE if_rap_query_filter=>tt_range_option,
        nkmpr        TYPE if_rap_query_filter=>tt_range_option,
        umlmc        TYPE if_rap_query_filter=>tt_range_option,
        ladgr        TYPE if_rap_query_filter=>tt_range_option,
        usequ        TYPE if_rap_query_filter=>tt_range_option,
        lgrad        TYPE if_rap_query_filter=>tt_range_option,
        auftl        TYPE if_rap_query_filter=>tt_range_option,
        plvar        TYPE if_rap_query_filter=>tt_range_option,
        otype        TYPE if_rap_query_filter=>tt_range_option,
        objid        TYPE if_rap_query_filter=>tt_range_option,
        mtvfp        TYPE if_rap_query_filter=>tt_range_option,
        vrvez        TYPE if_rap_query_filter=>tt_range_option,
        vbamg        TYPE if_rap_query_filter=>tt_range_option,
        vbeaz        TYPE if_rap_query_filter=>tt_range_option,
        lizyk        TYPE if_rap_query_filter=>tt_range_option,
        prctr        TYPE if_rap_query_filter=>tt_range_option,
        trame        TYPE if_rap_query_filter=>tt_range_option,
        mrppp        TYPE if_rap_query_filter=>tt_range_option,
        sauft        TYPE if_rap_query_filter=>tt_range_option,
        fxhor        TYPE if_rap_query_filter=>tt_range_option,
        vrmod        TYPE if_rap_query_filter=>tt_range_option,
        vint1        TYPE if_rap_query_filter=>tt_range_option,
        vint2        TYPE if_rap_query_filter=>tt_range_option,
        losgr        TYPE if_rap_query_filter=>tt_range_option,
        sobsk        TYPE if_rap_query_filter=>tt_range_option,
        kausf        TYPE if_rap_query_filter=>tt_range_option,
        qzgtp        TYPE if_rap_query_filter=>tt_range_option,
        qmatv        TYPE if_rap_query_filter=>tt_range_option,
        takzt        TYPE if_rap_query_filter=>tt_range_option,
        rwpro        TYPE if_rap_query_filter=>tt_range_option,
        copam        TYPE if_rap_query_filter=>tt_range_option,
        abcin        TYPE if_rap_query_filter=>tt_range_option,
        awsls        TYPE if_rap_query_filter=>tt_range_option,
        sernp        TYPE if_rap_query_filter=>tt_range_option,
        cuobj        TYPE if_rap_query_filter=>tt_range_option,
        vrbfk        TYPE if_rap_query_filter=>tt_range_option,
        cuobv        TYPE if_rap_query_filter=>tt_range_option,
        resvp        TYPE if_rap_query_filter=>tt_range_option,
        plnty        TYPE if_rap_query_filter=>tt_range_option,
        abfac        TYPE if_rap_query_filter=>tt_range_option,
        sfcpf        TYPE if_rap_query_filter=>tt_range_option,
        shflg        TYPE if_rap_query_filter=>tt_range_option,
        shzet        TYPE if_rap_query_filter=>tt_range_option,
        vkumc        TYPE if_rap_query_filter=>tt_range_option,
        vktrw        TYPE if_rap_query_filter=>tt_range_option,
        kzagl        TYPE if_rap_query_filter=>tt_range_option,
        glgmg        TYPE if_rap_query_filter=>tt_range_option,
        vkglg        TYPE if_rap_query_filter=>tt_range_option,
        indus        TYPE if_rap_query_filter=>tt_range_option,
        steuc        TYPE if_rap_query_filter=>tt_range_option,
        dplho        TYPE if_rap_query_filter=>tt_range_option,
        minls        TYPE if_rap_query_filter=>tt_range_option,
        maxls        TYPE if_rap_query_filter=>tt_range_option,
        fixls        TYPE if_rap_query_filter=>tt_range_option,
        ltinc        TYPE if_rap_query_filter=>tt_range_option,
        compl        TYPE if_rap_query_filter=>tt_range_option,
        mcrue        TYPE if_rap_query_filter=>tt_range_option,
        lfmon        TYPE if_rap_query_filter=>tt_range_option,
        lfgja        TYPE if_rap_query_filter=>tt_range_option,
        eislo        TYPE if_rap_query_filter=>tt_range_option,
        ncost        TYPE if_rap_query_filter=>tt_range_option,
        bwesb        TYPE if_rap_query_filter=>tt_range_option,
        gi_pr_time   TYPE if_rap_query_filter=>tt_range_option,
        min_troc     TYPE if_rap_query_filter=>tt_range_option,
        max_troc     TYPE if_rap_query_filter=>tt_range_option,
        target_stock TYPE if_rap_query_filter=>tt_range_option,
        bwkey        TYPE if_rap_query_filter=>tt_range_option,
        lbkum        TYPE if_rap_query_filter=>tt_range_option,
        salk3        TYPE if_rap_query_filter=>tt_range_option,
        vprsv        TYPE if_rap_query_filter=>tt_range_option,
        verpr        TYPE if_rap_query_filter=>tt_range_option,
        stprs        TYPE if_rap_query_filter=>tt_range_option,
        peinh        TYPE if_rap_query_filter=>tt_range_option,
        bklas        TYPE if_rap_query_filter=>tt_range_option,
        salkv        TYPE if_rap_query_filter=>tt_range_option,
        vmkum        TYPE if_rap_query_filter=>tt_range_option,
        vmsal        TYPE if_rap_query_filter=>tt_range_option,
        vmvpr        TYPE if_rap_query_filter=>tt_range_option,
        vmver        TYPE if_rap_query_filter=>tt_range_option,
        vmstp        TYPE if_rap_query_filter=>tt_range_option,
        vmpei        TYPE if_rap_query_filter=>tt_range_option,
        vmbkl        TYPE if_rap_query_filter=>tt_range_option,
        vmsav        TYPE if_rap_query_filter=>tt_range_option,
        vjkum        TYPE if_rap_query_filter=>tt_range_option,
        vjsal        TYPE if_rap_query_filter=>tt_range_option,
        vjvpr        TYPE if_rap_query_filter=>tt_range_option,
        vjver        TYPE if_rap_query_filter=>tt_range_option,
        vjstp        TYPE if_rap_query_filter=>tt_range_option,
        vjbkl        TYPE if_rap_query_filter=>tt_range_option,
        vjsav        TYPE if_rap_query_filter=>tt_range_option,
        stprv        TYPE if_rap_query_filter=>tt_range_option,
        laepr        TYPE if_rap_query_filter=>tt_range_option,
        zkprs        TYPE if_rap_query_filter=>tt_range_option,
        zkdat        TYPE if_rap_query_filter=>tt_range_option,
        timestamp    TYPE if_rap_query_filter=>tt_range_option,
        bwprs        TYPE if_rap_query_filter=>tt_range_option,
        bwprh        TYPE if_rap_query_filter=>tt_range_option,
        vjbws        TYPE if_rap_query_filter=>tt_range_option,
        vjbwh        TYPE if_rap_query_filter=>tt_range_option,
        vvjsl        TYPE if_rap_query_filter=>tt_range_option,
        vvjlb        TYPE if_rap_query_filter=>tt_range_option,
        vvmlb        TYPE if_rap_query_filter=>tt_range_option,
        vvsal        TYPE if_rap_query_filter=>tt_range_option,
        zplpr        TYPE if_rap_query_filter=>tt_range_option,
        zplp1        TYPE if_rap_query_filter=>tt_range_option,
        zplp2        TYPE if_rap_query_filter=>tt_range_option,
        zplp3        TYPE if_rap_query_filter=>tt_range_option,
        zpld1        TYPE if_rap_query_filter=>tt_range_option,
        zpld2        TYPE if_rap_query_filter=>tt_range_option,
        zpld3        TYPE if_rap_query_filter=>tt_range_option,
        kalkz        TYPE if_rap_query_filter=>tt_range_option,
        kalkl        TYPE if_rap_query_filter=>tt_range_option,
        kalkv        TYPE if_rap_query_filter=>tt_range_option,
        kalsc        TYPE if_rap_query_filter=>tt_range_option,
        xlifo        TYPE if_rap_query_filter=>tt_range_option,
        mypol        TYPE if_rap_query_filter=>tt_range_option,
        bwph1        TYPE if_rap_query_filter=>tt_range_option,
        bwps1        TYPE if_rap_query_filter=>tt_range_option,
        abwkz        TYPE if_rap_query_filter=>tt_range_option,
        kaln1        TYPE if_rap_query_filter=>tt_range_option,
        kalnr        TYPE if_rap_query_filter=>tt_range_option,
        bwva1        TYPE if_rap_query_filter=>tt_range_option,
        bwva2        TYPE if_rap_query_filter=>tt_range_option,
        bwva3        TYPE if_rap_query_filter=>tt_range_option,
        vers1        TYPE if_rap_query_filter=>tt_range_option,
        vers2        TYPE if_rap_query_filter=>tt_range_option,
        vers3        TYPE if_rap_query_filter=>tt_range_option,
        hrkft        TYPE if_rap_query_filter=>tt_range_option,
        kosgr        TYPE if_rap_query_filter=>tt_range_option,
        pprdz        TYPE if_rap_query_filter=>tt_range_option,
        pprdl        TYPE if_rap_query_filter=>tt_range_option,
        pprdv        TYPE if_rap_query_filter=>tt_range_option,
        pdatz        TYPE if_rap_query_filter=>tt_range_option,
        pdatl        TYPE if_rap_query_filter=>tt_range_option,
        pdatv        TYPE if_rap_query_filter=>tt_range_option,
        ekalr        TYPE if_rap_query_filter=>tt_range_option,
        vplpr        TYPE if_rap_query_filter=>tt_range_option,
        mlmaa        TYPE if_rap_query_filter=>tt_range_option,
        mlast        TYPE if_rap_query_filter=>tt_range_option,
        lplpr        TYPE if_rap_query_filter=>tt_range_option,
        vksal        TYPE if_rap_query_filter=>tt_range_option,
        hkmat        TYPE if_rap_query_filter=>tt_range_option,
        sperw        TYPE if_rap_query_filter=>tt_range_option,
        kziwl        TYPE if_rap_query_filter=>tt_range_option,
        wlinl        TYPE if_rap_query_filter=>tt_range_option,
        abciw        TYPE if_rap_query_filter=>tt_range_option,
        bwspa        TYPE if_rap_query_filter=>tt_range_option,
        lplpx        TYPE if_rap_query_filter=>tt_range_option,
        vplpx        TYPE if_rap_query_filter=>tt_range_option,
        fplpx        TYPE if_rap_query_filter=>tt_range_option,
        lbwst        TYPE if_rap_query_filter=>tt_range_option,
        vbwst        TYPE if_rap_query_filter=>tt_range_option,
        fbwst        TYPE if_rap_query_filter=>tt_range_option,
        eklas        TYPE if_rap_query_filter=>tt_range_option,
        qklas        TYPE if_rap_query_filter=>tt_range_option,
        mtuse        TYPE if_rap_query_filter=>tt_range_option,
        mtorg        TYPE if_rap_query_filter=>tt_range_option,
        ownpr        TYPE if_rap_query_filter=>tt_range_option,
        xbewm        TYPE if_rap_query_filter=>tt_range_option,
        bwpei        TYPE if_rap_query_filter=>tt_range_option,
        mbrue        TYPE if_rap_query_filter=>tt_range_option,
        oklas        TYPE if_rap_query_filter=>tt_range_option,
        oippinv      TYPE if_rap_query_filter=>tt_range_option,
        versg        TYPE if_rap_query_filter=>tt_range_option,
        bonus        TYPE if_rap_query_filter=>tt_range_option,
        provg        TYPE if_rap_query_filter=>tt_range_option,
        sktof        TYPE if_rap_query_filter=>tt_range_option,
        vmstd        TYPE if_rap_query_filter=>tt_range_option,
        aumng        TYPE if_rap_query_filter=>tt_range_option,
        lfmng        TYPE if_rap_query_filter=>tt_range_option,
        efmng        TYPE if_rap_query_filter=>tt_range_option,
        scmng        TYPE if_rap_query_filter=>tt_range_option,
        schme        TYPE if_rap_query_filter=>tt_range_option,
        vrkme        TYPE if_rap_query_filter=>tt_range_option,
        mtpos        TYPE if_rap_query_filter=>tt_range_option,
        dwerk        TYPE if_rap_query_filter=>tt_range_option,
        prodh        TYPE if_rap_query_filter=>tt_range_option,
        pmatn        TYPE if_rap_query_filter=>tt_range_option,
        kondm        TYPE if_rap_query_filter=>tt_range_option,
        ktgrm        TYPE if_rap_query_filter=>tt_range_option,
        mvgr1        TYPE if_rap_query_filter=>tt_range_option,
        prat1        TYPE if_rap_query_filter=>tt_range_option,
        lfmax        TYPE if_rap_query_filter=>tt_range_option,
        pvmso        TYPE if_rap_query_filter=>tt_range_option,
        bev1         TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_param,

      "Tipo de retorno de dados à custom entity
      ty_mm TYPE STANDARD TABLE OF zc_mm_mestre_material WITH EMPTY KEY.

    DATA gs_param TYPE ty_param.

    CLASS-METHODS:
      "! Cria instancia
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO zclmm_dados_metre_materiais .

    METHODS:
      "! Preenche parametros de entrada para filtrar os selects
      set_ref_data.

    METHODS:
      build
        RETURNING VALUE(rt_mm) TYPE ty_mm.

    DATA gr_matnr           TYPE REF TO data .
    DATA gr_werks           TYPE REF TO data .
    DATA gr_bwtar           TYPE REF TO data .
    DATA gr_idrfb           TYPE REF TO data .
    DATA gr_vtweg           TYPE REF TO data .
    DATA gr_vkorg           TYPE REF TO data .
    DATA gr_mtart           TYPE REF TO data .
    DATA gr_ersda           TYPE REF TO data .
    DATA gr_ernam           TYPE REF TO data .
    DATA gr_laeda           TYPE REF TO data .
    DATA gr_aenam           TYPE REF TO data .
    DATA gr_mstae           TYPE REF TO data .
    DATA gr_mmsta           TYPE REF TO data .
    DATA gr_vmsta           TYPE REF TO data .
    DATA gr_vpsta           TYPE REF TO data .
    DATA gr_mstav           TYPE REF TO data .
    DATA gr_lvorm           TYPE REF TO data .
    DATA gr_pstat           TYPE REF TO data .
    DATA gr_mbrsh           TYPE REF TO data .
    DATA gr_matkl           TYPE REF TO data .
    DATA gr_bismt           TYPE REF TO data .
    DATA gr_meins           TYPE REF TO data .
    DATA gr_blanz           TYPE REF TO data .
    DATA gr_groes           TYPE REF TO data .
    DATA gr_wrkst           TYPE REF TO data .
    DATA gr_normt           TYPE REF TO data .
    DATA gr_brgew           TYPE REF TO data .
    DATA gr_ntgew           TYPE REF TO data .
    DATA gr_gewei           TYPE REF TO data .
    DATA gr_volum           TYPE REF TO data .
    DATA gr_raube           TYPE REF TO data .
    DATA gr_tragr           TYPE REF TO data .
    DATA gr_spart           TYPE REF TO data .
    DATA gr_kunnr           TYPE REF TO data .
    DATA gr_eannr           TYPE REF TO data .
    DATA gr_wesch           TYPE REF TO data .
    DATA gr_bwvor           TYPE REF TO data .
    DATA gr_bwscl           TYPE REF TO data .
    DATA gr_saiso           TYPE REF TO data .
    DATA gr_etiar           TYPE REF TO data .
    DATA gr_etifo           TYPE REF TO data .
    DATA gr_entar           TYPE REF TO data .
    DATA gr_ean11           TYPE REF TO data .
    DATA gr_numtp           TYPE REF TO data .
    DATA gr_laeng           TYPE REF TO data .
    DATA gr_breit           TYPE REF TO data .
    DATA gr_hoehe           TYPE REF TO data .
    DATA gr_meabm           TYPE REF TO data .
    DATA gr_prdha           TYPE REF TO data .
    DATA gr_aeklk           TYPE REF TO data .
    DATA gr_cadkz           TYPE REF TO data .
    DATA gr_qmpur           TYPE REF TO data .
    DATA gr_ergew           TYPE REF TO data .
    DATA gr_ergei           TYPE REF TO data .
    DATA gr_ervol           TYPE REF TO data .
    DATA gr_ervoe           TYPE REF TO data .
    DATA gr_gewto           TYPE REF TO data .
    DATA gr_volto           TYPE REF TO data .
    DATA gr_vabme           TYPE REF TO data .
    DATA gr_kzrev           TYPE REF TO data .
    DATA gr_kzkfg           TYPE REF TO data .
    DATA gr_xchpf           TYPE REF TO data .
    DATA gr_vhart           TYPE REF TO data .
    DATA gr_fuelg           TYPE REF TO data .
    DATA gr_stfak           TYPE REF TO data .
    DATA gr_magrv           TYPE REF TO data .
    DATA gr_begru           TYPE REF TO data .
    DATA gr_datab           TYPE REF TO data .
    DATA gr_liqdt           TYPE REF TO data .
    DATA gr_saisj           TYPE REF TO data .
    DATA gr_plgtp           TYPE REF TO data .
    DATA gr_mlgut           TYPE REF TO data .
    DATA gr_extwg           TYPE REF TO data .
    DATA gr_satnr           TYPE REF TO data .
    DATA gr_attyp           TYPE REF TO data .
    DATA gr_kzkup           TYPE REF TO data .
    DATA gr_kznfm           TYPE REF TO data .
    DATA gr_pmata           TYPE REF TO data .
    DATA gr_mstde           TYPE REF TO data .
    DATA gr_mstdv           TYPE REF TO data .
    DATA gr_taklv           TYPE REF TO data .
    DATA gr_rbnrm           TYPE REF TO data .
    DATA gr_mhdrz           TYPE REF TO data .
    DATA gr_mhdhb           TYPE REF TO data .
    DATA gr_mhdlp           TYPE REF TO data .
    DATA gr_inhme           TYPE REF TO data .
    DATA gr_inhal           TYPE REF TO data .
    DATA gr_vpreh           TYPE REF TO data .
    DATA gr_etiag           TYPE REF TO data .
    DATA gr_mtpos_mara      TYPE REF TO data .
    DATA gr_bwtty           TYPE REF TO data .
    DATA gr_xchar           TYPE REF TO data .
    DATA gr_mmstd           TYPE REF TO data .
    DATA gr_maabc           TYPE REF TO data .
    DATA gr_kzkri           TYPE REF TO data .
    DATA gr_ekgrp           TYPE REF TO data .
    DATA gr_ausme           TYPE REF TO data .
    DATA gr_dispr           TYPE REF TO data .
    DATA gr_dismm           TYPE REF TO data .
    DATA gr_dispo           TYPE REF TO data .
    DATA gr_kzdie           TYPE REF TO data .
    DATA gr_plifz           TYPE REF TO data .
    DATA gr_webaz           TYPE REF TO data .
    DATA gr_perkz           TYPE REF TO data .
    DATA gr_ausss           TYPE REF TO data .
    DATA gr_disls           TYPE REF TO data .
    DATA gr_beskz           TYPE REF TO data .
    DATA gr_sobsl           TYPE REF TO data .
    DATA gr_minbe           TYPE REF TO data .
    DATA gr_eisbe           TYPE REF TO data .
    DATA gr_bstmi           TYPE REF TO data .
    DATA gr_bstma           TYPE REF TO data .
    DATA gr_bstfe           TYPE REF TO data .
    DATA gr_bstrf           TYPE REF TO data .
    DATA gr_mabst           TYPE REF TO data .
    DATA gr_losfx           TYPE REF TO data .
    DATA gr_sbdkz           TYPE REF TO data .
    DATA gr_bearz           TYPE REF TO data .
    DATA gr_ruezt           TYPE REF TO data .
    DATA gr_tranz           TYPE REF TO data .
    DATA gr_basmg           TYPE REF TO data .
    DATA gr_dzeit           TYPE REF TO data .
    DATA gr_maxlz           TYPE REF TO data .
    DATA gr_lzeih           TYPE REF TO data .
    DATA gr_kzpro           TYPE REF TO data .
    DATA gr_gpmkz           TYPE REF TO data .
    DATA gr_ueeto           TYPE REF TO data .
    DATA gr_ueetk           TYPE REF TO data .
    DATA gr_uneto           TYPE REF TO data .
    DATA gr_wzeit           TYPE REF TO data .
    DATA gr_atpkz           TYPE REF TO data .
    DATA gr_vzusl           TYPE REF TO data .
    DATA gr_herbl           TYPE REF TO data .
    DATA gr_insmk           TYPE REF TO data .
    DATA gr_sproz           TYPE REF TO data .
    DATA gr_quazt           TYPE REF TO data .
    DATA gr_ssqss           TYPE REF TO data .
    DATA gr_mpdau           TYPE REF TO data .
    DATA gr_kzppv           TYPE REF TO data .
    DATA gr_kzdkz           TYPE REF TO data .
    DATA gr_wstgh           TYPE REF TO data .
    DATA gr_prfrq           TYPE REF TO data .
    DATA gr_nkmpr           TYPE REF TO data .
    DATA gr_umlmc           TYPE REF TO data .
    DATA gr_ladgr           TYPE REF TO data .
    DATA gr_usequ           TYPE REF TO data .
    DATA gr_lgrad           TYPE REF TO data .
    DATA gr_auftl           TYPE REF TO data .
    DATA gr_plvar           TYPE REF TO data .
    DATA gr_otype           TYPE REF TO data .
    DATA gr_objid           TYPE REF TO data .
    DATA gr_mtvfp           TYPE REF TO data .
    DATA gr_vrvez           TYPE REF TO data .
    DATA gr_vbamg           TYPE REF TO data .
    DATA gr_vbeaz           TYPE REF TO data .
    DATA gr_lizyk           TYPE REF TO data .
    DATA gr_prctr           TYPE REF TO data .
    DATA gr_trame           TYPE REF TO data .
    DATA gr_mrppp           TYPE REF TO data .
    DATA gr_sauft           TYPE REF TO data .
    DATA gr_fxhor           TYPE REF TO data .
    DATA gr_vrmod           TYPE REF TO data .
    DATA gr_vint1           TYPE REF TO data .
    DATA gr_vint2           TYPE REF TO data .
    DATA gr_losgr           TYPE REF TO data .
    DATA gr_sobsk           TYPE REF TO data .
    DATA gr_kausf           TYPE REF TO data .
    DATA gr_qzgtp           TYPE REF TO data .
    DATA gr_qmatv           TYPE REF TO data .
    DATA gr_takzt           TYPE REF TO data .
    DATA gr_rwpro           TYPE REF TO data .
    DATA gr_copam           TYPE REF TO data .
    DATA gr_abcin           TYPE REF TO data .
    DATA gr_awsls           TYPE REF TO data .
    DATA gr_sernp           TYPE REF TO data .
    DATA gr_cuobj           TYPE REF TO data .
    DATA gr_vrbfk           TYPE REF TO data .
    DATA gr_cuobv           TYPE REF TO data .
    DATA gr_resvp           TYPE REF TO data .
    DATA gr_plnty           TYPE REF TO data .
    DATA gr_abfac           TYPE REF TO data .
    DATA gr_sfcpf           TYPE REF TO data .
    DATA gr_shflg           TYPE REF TO data .
    DATA gr_shzet           TYPE REF TO data .
    DATA gr_vkumc           TYPE REF TO data .
    DATA gr_vktrw           TYPE REF TO data .
    DATA gr_kzagl           TYPE REF TO data .
    DATA gr_glgmg           TYPE REF TO data .
    DATA gr_vkglg           TYPE REF TO data .
    DATA gr_indus           TYPE REF TO data .
    DATA gr_steuc           TYPE REF TO data .
    DATA gr_dplho           TYPE REF TO data .
    DATA gr_minls           TYPE REF TO data .
    DATA gr_maxls           TYPE REF TO data .
    DATA gr_fixls           TYPE REF TO data .
    DATA gr_ltinc           TYPE REF TO data .
    DATA gr_compl           TYPE REF TO data .
    DATA gr_mcrue           TYPE REF TO data .
    DATA gr_lfmon           TYPE REF TO data .
    DATA gr_lfgja           TYPE REF TO data .
    DATA gr_eislo           TYPE REF TO data .
    DATA gr_ncost           TYPE REF TO data .
    DATA gr_bwesb           TYPE REF TO data .
    DATA gr_gi_pr_time      TYPE REF TO data .
    DATA gr_min_troc        TYPE REF TO data .
    DATA gr_max_troc        TYPE REF TO data .
    DATA gr_target_stock    TYPE REF TO data .
    DATA gr_bwkey           TYPE REF TO data .
    DATA gr_lbkum           TYPE REF TO data .
    DATA gr_salk3           TYPE REF TO data .
    DATA gr_vprsv           TYPE REF TO data .
    DATA gr_verpr           TYPE REF TO data .
    DATA gr_stprs           TYPE REF TO data .
    DATA gr_peinh           TYPE REF TO data .
    DATA gr_bklas           TYPE REF TO data .
    DATA gr_salkv           TYPE REF TO data .
    DATA gr_vmkum           TYPE REF TO data .
    DATA gr_vmsal           TYPE REF TO data .
    DATA gr_vmvpr           TYPE REF TO data .
    DATA gr_vmver           TYPE REF TO data .
    DATA gr_vmstp           TYPE REF TO data .
    DATA gr_vmpei           TYPE REF TO data .
    DATA gr_vmbkl           TYPE REF TO data .
    DATA gr_vmsav           TYPE REF TO data .
    DATA gr_vjkum           TYPE REF TO data .
    DATA gr_vjsal           TYPE REF TO data .
    DATA gr_vjvpr           TYPE REF TO data .
    DATA gr_vjver           TYPE REF TO data .
    DATA gr_vjstp           TYPE REF TO data .
    DATA gr_vjbkl           TYPE REF TO data .
    DATA gr_vjsav           TYPE REF TO data .
    DATA gr_stprv           TYPE REF TO data .
    DATA gr_laepr           TYPE REF TO data .
    DATA gr_zkprs           TYPE REF TO data .
    DATA gr_zkdat           TYPE REF TO data .
    DATA gr_timestamp       TYPE REF TO data .
    DATA gr_bwprs           TYPE REF TO data .
    DATA gr_bwprh           TYPE REF TO data .
    DATA gr_vjbws           TYPE REF TO data .
    DATA gr_vjbwh           TYPE REF TO data .
    DATA gr_vvjsl           TYPE REF TO data .
    DATA gr_vvjlb           TYPE REF TO data .
    DATA gr_vvmlb           TYPE REF TO data .
    DATA gr_vvsal           TYPE REF TO data .
    DATA gr_zplpr           TYPE REF TO data .
    DATA gr_zplp1           TYPE REF TO data .
    DATA gr_zplp2           TYPE REF TO data .
    DATA gr_zplp3           TYPE REF TO data .
    DATA gr_zpld1           TYPE REF TO data .
    DATA gr_zpld2           TYPE REF TO data .
    DATA gr_zpld3           TYPE REF TO data .
    DATA gr_kalkz           TYPE REF TO data .
    DATA gr_kalkl           TYPE REF TO data .
    DATA gr_kalkv           TYPE REF TO data .
    DATA gr_kalsc           TYPE REF TO data .
    DATA gr_xlifo           TYPE REF TO data .
    DATA gr_mypol           TYPE REF TO data .
    DATA gr_bwph1           TYPE REF TO data .
    DATA gr_bwps1           TYPE REF TO data .
    DATA gr_abwkz           TYPE REF TO data .
    DATA gr_kaln1           TYPE REF TO data .
    DATA gr_kalnr           TYPE REF TO data .
    DATA gr_bwva1           TYPE REF TO data .
    DATA gr_bwva2           TYPE REF TO data .
    DATA gr_bwva3           TYPE REF TO data .
    DATA gr_vers1           TYPE REF TO data .
    DATA gr_vers2           TYPE REF TO data .
    DATA gr_vers3           TYPE REF TO data .
    DATA gr_hrkft           TYPE REF TO data .
    DATA gr_kosgr           TYPE REF TO data .
    DATA gr_pprdz           TYPE REF TO data .
    DATA gr_pprdl           TYPE REF TO data .
    DATA gr_pprdv           TYPE REF TO data .
    DATA gr_pdatz           TYPE REF TO data .
    DATA gr_pdatl           TYPE REF TO data .
    DATA gr_pdatv           TYPE REF TO data .
    DATA gr_ekalr           TYPE REF TO data .
    DATA gr_vplpr           TYPE REF TO data .
    DATA gr_mlmaa           TYPE REF TO data .
    DATA gr_mlast           TYPE REF TO data .
    DATA gr_lplpr           TYPE REF TO data .
    DATA gr_vksal           TYPE REF TO data .
    DATA gr_hkmat           TYPE REF TO data .
    DATA gr_sperw           TYPE REF TO data .
    DATA gr_kziwl           TYPE REF TO data .
    DATA gr_wlinl           TYPE REF TO data .
    DATA gr_abciw           TYPE REF TO data .
    DATA gr_bwspa           TYPE REF TO data .
    DATA gr_lplpx           TYPE REF TO data .
    DATA gr_vplpx           TYPE REF TO data .
    DATA gr_fplpx           TYPE REF TO data .
    DATA gr_lbwst           TYPE REF TO data .
    DATA gr_vbwst           TYPE REF TO data .
    DATA gr_fbwst           TYPE REF TO data .
    DATA gr_eklas           TYPE REF TO data .
    DATA gr_qklas           TYPE REF TO data .
    DATA gr_mtuse           TYPE REF TO data .
    DATA gr_mtorg           TYPE REF TO data .
    DATA gr_ownpr           TYPE REF TO data .
    DATA gr_xbewm           TYPE REF TO data .
    DATA gr_bwpei           TYPE REF TO data .
    DATA gr_mbrue           TYPE REF TO data .
    DATA gr_oklas           TYPE REF TO data .
    DATA gr_oippinv         TYPE REF TO data .
    DATA gr_versg           TYPE REF TO data .
    DATA gr_bonus           TYPE REF TO data .
    DATA gr_provg           TYPE REF TO data .
    DATA gr_sktof           TYPE REF TO data .
    DATA gr_vmstd           TYPE REF TO data .
    DATA gr_aumng           TYPE REF TO data .
    DATA gr_lfmng           TYPE REF TO data .
    DATA gr_efmng           TYPE REF TO data .
    DATA gr_scmng           TYPE REF TO data .
    DATA gr_schme           TYPE REF TO data .
    DATA gr_vrkme           TYPE REF TO data .
    DATA gr_mtpos           TYPE REF TO data .
    DATA gr_dwerk           TYPE REF TO data .
    DATA gr_prodh           TYPE REF TO data .
    DATA gr_pmatn           TYPE REF TO data .
    DATA gr_kondm           TYPE REF TO data .
    DATA gr_ktgrm           TYPE REF TO data .
    DATA gr_mvgr1           TYPE REF TO data .
    DATA gr_prat1           TYPE REF TO data .
    DATA gr_lfmax           TYPE REF TO data .
    DATA gr_pvmso           TYPE REF TO data .
    DATA gr_/bev1/emdrckspl TYPE REF TO data .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_bwkey,
             bwkey TYPE bwkey,
           END OF ty_bwkey.

    CLASS-DATA go_instance TYPE REF TO zclmm_dados_metre_materiais .
    METHODS:
      sel_dados_gerais
        CHANGING ct_mm TYPE ty_mm.

    METHODS:
      sel_dados_centros
        CHANGING ct_mm TYPE ty_mm.

    METHODS:
      sel_dados_vendas
        CHANGING ct_mm TYPE ty_mm.

    METHODS:
      sel_dados_avaliacao
        CHANGING ct_mm TYPE ty_mm.
ENDCLASS.



CLASS zclmm_dados_metre_materiais IMPLEMENTATION.
  METHOD get_instance.
    IF ( go_instance IS INITIAL ).
      go_instance = NEW zclmm_dados_metre_materiais( ).
    ENDIF.

    ro_instance = go_instance.
  ENDMETHOD.

  METHOD build.
*  DATA lt_mm type ty_mm.
** ---------------------------------------------------------------------------
** Tabela MARA  - Dados Gerais
** ---------------------------------------------------------------------------
    IF line_exists( gs_param-vpsta[ low = gc_k ] ).      "#EC CI_STDSEQ
      me->sel_dados_gerais( CHANGING ct_mm = rt_mm ).
    ENDIF.
** ---------------------------------------------------------------------------
** Tabela MBEW - Dados de Avaliação
** ---------------------------------------------------------------------------
    IF line_exists( gs_param-vpsta[ low = gc_b ] ).      "#EC CI_STDSEQ
      me->sel_dados_avaliacao( CHANGING ct_mm = rt_mm ).
    ENDIF.
** ---------------------------------------------------------------------------
** Tabela MARC  - Dados de Centros - Engloba MRP/Qualidade/Compras
** ---------------------------------------------------------------------------
    IF line_exists( gs_param-vpsta[ low = gc_d ] ) OR
       line_exists( gs_param-vpsta[ low = gc_q ] ) OR
       line_exists( gs_param-vpsta[ low = gc_e ] ) OR
       line_exists( gs_param-vpsta[ low = gc_c ] ).      "#EC CI_STDSEQ
      me->sel_dados_centros( CHANGING ct_mm = rt_mm ).
    ENDIF.
** ---------------------------------------------------------------------------
** Tabela MVKE - Dados de Vendas
** ---------------------------------------------------------------------------
    IF line_exists( gs_param-vpsta[ low = gc_v ] ).      "#EC CI_STDSEQ
      me->sel_dados_vendas( CHANGING ct_mm = rt_mm ).
    ENDIF.
  ENDMETHOD.

  METHOD sel_dados_avaliacao.

    DATA lt_dados TYPE TABLE OF zc_mm_mestre_material.

    DATA: lt_bwkey TYPE TABLE OF ty_bwkey,
          ls_bwkey TYPE ty_bwkey.

    SELECT mbew~matnr AS Product, mbew~bwkey,  mbew~lbkum, mbew~salk3, mbew~vprsv,
           mbew~verpr, mbew~stprs, mbew~peinh, mbew~bklas, mbew~salkv, mbew~bwtar,
           mbew~vmkum, mbew~vmsal, mbew~vmvpr, mbew~vmver, mbew~vmstp,
           mbew~vmpei, mbew~vmbkl, mbew~vmsav, mbew~vjkum, mbew~vjsal,
           mbew~vjvpr, mbew~vjver, mbew~vjstp, mbew~vjpei, mbew~vjbkl,
           mbew~vjsav, mbew~stprv, mbew~laepr, mbew~zkprs, mbew~zkdat,
           mbew~timestamp, mbew~bwprs, mbew~bwprh, mbew~vjbws, mbew~vjbwh,
           mbew~vvjsl, mbew~vvjlb, mbew~vvmlb, mbew~vvsal, mbew~zplpr,
           mbew~zplp1, mbew~zplp2, mbew~zplp3, mbew~zpld1, mbew~zpld2,
           mbew~zpld3, mbew~kalkz,
           mbew~kalkl, mbew~kalkv, mbew~kalsc, mbew~xlifo, mbew~mypol,
           mbew~bwph1, mbew~bwps1, mbew~abwkz, mbew~kaln1, mbew~kalnr,
           mbew~bwva1, mbew~bwva2, mbew~bwva3, mbew~vers1, mbew~vers2,
           mbew~vers3, mbew~hrkft, mbew~kosgr, mbew~pprdz, mbew~pprdl,
           mbew~pprdv, mbew~pdatz, mbew~pdatl, mbew~pdatv, mbew~ekalr,
           mbew~vplpr, mbew~mlmaa, mbew~mlast, mbew~lplpr, mbew~vksal,
           mbew~hkmat, mbew~sperw, mbew~kziwl, mbew~wlinl, mbew~abciw,
           mbew~bwspa, mbew~lplpx, mbew~vplpx, mbew~fplpx, mbew~lbwst,
           mbew~vbwst, mbew~fbwst, mbew~eklas, mbew~qklas, mbew~mtuse,
           mbew~mtorg, mbew~ownpr, mbew~xbewm, mbew~bwpei, mbew~mbrue,
           mbew~oklas, mbew~oippinv,

           mara~ersda, mara~ernam, mara~laeda,
           mara~aenam, mara~vpsta, mara~pstat, mara~lvorm, mara~mtart,
           mara~mbrsh, mara~matkl, mara~bismt, mara~meins, mara~blanz,
           mara~groes, mara~wrkst, mara~normt, mara~brgew, mara~ntgew,
           mara~gewei, mara~volum, mara~raube, mara~tragr, mara~spart,
           mara~kunnr, mara~eannr, mara~wesch, mara~bwvor, mara~bwscl,
           mara~saiso, mara~etiar, mara~etifo, mara~entar, mara~ean11,
           mara~numtp, mara~laeng, mara~breit, mara~hoehe, mara~meabm,
           mara~prdha, mara~aeklk, mara~cadkz, mara~qmpur, mara~ergew,
           mara~ergei, mara~ervol, mara~ervoe, mara~gewto, mara~volto,
           mara~vabme, mara~kzrev, mara~kzkfg, mara~xchpf, mara~vhart,
           mara~fuelg, mara~stfak, mara~magrv, mara~begru, mara~datab,
           mara~liqdt, mara~saisj, mara~plgtp, mara~mlgut, mara~extwg,
           mara~satnr, mara~attyp, mara~kzkup, mara~kznfm, mara~pmata,
           mara~mstae, mara~mstav, mara~mstde, mara~mstdv, mara~taklv,
           mara~rbnrm, mara~mhdrz, mara~mhdhb, mara~mhdlp, mara~inhme,
           mara~inhal, mara~vpreh, mara~etiag, mara~mtpos_mara,

           makt_pt~maktx, makt_en~maktx AS maktx2, makt_es~maktx AS maktx3,

           ztmm_catalogorfb~idrfb,

           t134t~mtbez

           FROM mbew

           LEFT OUTER JOIN   makt  AS makt_pt ON mbew~matnr = makt_pt~matnr  AND makt_pt~spras = 'P'
           LEFT OUTER JOIN   makt  AS makt_en ON mbew~matnr = makt_en~matnr  AND makt_en~spras = 'E'
           LEFT OUTER JOIN   makt  AS makt_es ON mbew~matnr = makt_es~matnr  AND makt_es~spras = 'S'
           LEFT OUTER JOIN   ztmm_catalogorfb  ON ztmm_catalogorfb~material = mbew~matnr
           INNER JOIN mara ON mbew~matnr = mara~matnr
           LEFT OUTER JOIN   t134t ON t134t~mtart = mara~mtart AND t134t~spras = @sy-langu "#EC CI_BUFFJOIN

           WHERE mbew~matnr IN @gs_param-matnr
           AND   mbew~bwkey IN @gs_param-bwkey
           AND   mbew~bwtar IN @gs_param-bwtar
           AND   mbew~lbkum IN @gs_param-lbkum
           AND   mbew~salk3 IN @gs_param-salk3
           AND   mbew~vprsv IN @gs_param-vprsv
           AND   mbew~verpr IN @gs_param-verpr
           AND   mbew~stprs IN @gs_param-stprs
           AND   mbew~peinh IN @gs_param-peinh
           AND   mbew~bklas IN @gs_param-bklas
           AND   mbew~salkv IN @gs_param-salkv
           AND   mbew~vmkum IN @gs_param-vmkum
           AND   mbew~vmsal IN @gs_param-vmsal
           AND   mbew~vmvpr IN @gs_param-vmvpr
           AND   mbew~vmver IN @gs_param-vmver
           AND   mbew~vmstp IN @gs_param-vmstp
           AND   mbew~vmpei IN @gs_param-vmpei
           AND   mbew~vmbkl IN @gs_param-vmbkl
           AND   mbew~vmsav IN @gs_param-vmsav
           AND   mbew~vjkum IN @gs_param-vjkum
           AND   mbew~vjsal IN @gs_param-vjsal
           AND   mbew~vjvpr IN @gs_param-vjvpr
           AND   mbew~vjver IN @gs_param-vjver
           AND   mbew~vjstp IN @gs_param-vjstp
           AND   mbew~vjbkl IN @gs_param-vjbkl
           AND   mbew~vjsav IN @gs_param-vjsav
           AND   mbew~stprv IN @gs_param-stprv
           AND   mbew~laepr IN @gs_param-laepr
           AND   mbew~zkprs IN @gs_param-zkprs
           AND   mbew~zkdat IN @gs_param-zkdat
           AND   mbew~bwprs IN @gs_param-bwprs
           AND   mbew~bwprh IN @gs_param-bwprh
           AND   mbew~vjbws IN @gs_param-vjbws
           AND   mbew~vjbwh IN @gs_param-vjbwh
           AND   mbew~vvjsl IN @gs_param-vvjsl
           AND   mbew~vvjlb IN @gs_param-vvjlb
           AND   mbew~vvmlb IN @gs_param-vvmlb
           AND   mbew~vvsal IN @gs_param-vvsal
           AND   mbew~zplpr IN @gs_param-zplpr
           AND   mbew~zplp1 IN @gs_param-zplp1
           AND   mbew~zplp2 IN @gs_param-zplp2
           AND   mbew~zplp3 IN @gs_param-zplp3
           AND   mbew~zpld1 IN @gs_param-zpld1
           AND   mbew~zpld2 IN @gs_param-zpld2
           AND   mbew~zpld3 IN @gs_param-zpld3
           AND   mbew~kalkz IN @gs_param-kalkz
           AND   mbew~kalkl IN @gs_param-kalkl
           AND   mbew~kalkv IN @gs_param-kalkv
           AND   mbew~kalsc IN @gs_param-kalsc
           AND   mbew~xlifo IN @gs_param-xlifo
           AND   mbew~mypol IN @gs_param-mypol
           AND   mbew~bwph1 IN @gs_param-bwph1
           AND   mbew~bwps1 IN @gs_param-bwps1
           AND   mbew~abwkz IN @gs_param-abwkz
           AND   mbew~kaln1 IN @gs_param-kaln1
           AND   mbew~kalnr IN @gs_param-kalnr
           AND   mbew~bwva1 IN @gs_param-bwva1
           AND   mbew~bwva2 IN @gs_param-bwva2
           AND   mbew~bwva3 IN @gs_param-bwva3
           AND   mbew~vers1 IN @gs_param-vers1
           AND   mbew~vers2 IN @gs_param-vers2
           AND   mbew~vers3 IN @gs_param-vers3
           AND   mbew~hrkft IN @gs_param-hrkft
           AND   mbew~kosgr IN @gs_param-kosgr
           AND   mbew~pprdz IN @gs_param-pprdz
           AND   mbew~pprdl IN @gs_param-pprdl
           AND   mbew~pprdv IN @gs_param-pprdv
           AND   mbew~pdatz IN @gs_param-pdatz
           AND   mbew~pdatl IN @gs_param-pdatl
           AND   mbew~pdatv IN @gs_param-pdatv
           AND   mbew~ekalr IN @gs_param-ekalr
           AND   mbew~vplpr IN @gs_param-vplpr
           AND   mbew~mlmaa IN @gs_param-mlmaa
           AND   mbew~mlast IN @gs_param-mlast
           AND   mbew~lplpr IN @gs_param-lplpr
           AND   mbew~vksal IN @gs_param-vksal
           AND   mbew~hkmat IN @gs_param-hkmat
           AND   mbew~sperw IN @gs_param-sperw
           AND   mbew~kziwl IN @gs_param-kziwl
           AND   mbew~wlinl IN @gs_param-wlinl
           AND   mbew~abciw IN @gs_param-abciw
           AND   mbew~bwspa IN @gs_param-bwspa
           AND   mbew~lplpx IN @gs_param-lplpx
           AND   mbew~vplpx IN @gs_param-vplpx
           AND   mbew~fplpx IN @gs_param-fplpx
           AND   mbew~lbwst IN @gs_param-lbwst
           AND   mbew~vbwst IN @gs_param-vbwst
           AND   mbew~fbwst IN @gs_param-fbwst
           AND   mbew~eklas IN @gs_param-eklas
           AND   mbew~qklas IN @gs_param-qklas
           AND   mbew~mtuse IN @gs_param-mtuse
           AND   mbew~mtorg IN @gs_param-mtorg
           AND   mbew~ownpr IN @gs_param-ownpr
           AND   mbew~xbewm IN @gs_param-xbewm
           AND   mbew~bwpei IN @gs_param-bwpei
           AND   mbew~mbrue IN @gs_param-mbrue
           AND   ztmm_catalogorfb~idrfb IN @gs_param-idrfb

           AND  mara~vpsta IN @gs_param-vpsta
           AND  mara~ersda IN @gs_param-ersda
           AND  mara~lvorm IN @gs_param-lvorm
           AND  mara~matnr IN @gs_param-matnr
           AND  mara~mstae IN @gs_param-mstae
           AND  mara~mstav IN @gs_param-mstav
           AND  mara~mtart IN @gs_param-mtart
           AND  mara~ernam IN @gs_param-ernam
           AND  mara~laeda IN @gs_param-laeda
           AND  mara~aenam IN @gs_param-aenam
           AND  mara~pstat IN @gs_param-pstat
           AND  mara~mbrsh IN @gs_param-mbrsh
           AND  mara~matkl IN @gs_param-matkl
           AND  mara~bismt IN @gs_param-bismt
           AND  mara~meins IN @gs_param-meins
           AND  mara~blanz IN @gs_param-blanz
           AND  mara~groes IN @gs_param-groes
           AND  mara~wrkst IN @gs_param-wrkst
           AND  mara~normt IN @gs_param-normt
           AND  mara~brgew IN @gs_param-brgew
           AND  mara~ntgew IN @gs_param-ntgew
           AND  mara~gewei IN @gs_param-gewei
           AND  mara~volum IN @gs_param-volum
           AND  mara~raube IN @gs_param-raube
           AND  mara~tragr IN @gs_param-tragr
           AND  mara~spart IN @gs_param-spart
           AND  mara~kunnr IN @gs_param-kunnr
           AND  mara~eannr IN @gs_param-eannr
           AND  mara~wesch IN @gs_param-wesch
           AND  mara~bwvor IN @gs_param-bwvor
           AND  mara~bwscl IN @gs_param-bwscl
           AND  mara~saiso IN @gs_param-saiso
           AND  mara~etiar IN @gs_param-etiar
           AND  mara~etifo IN @gs_param-etifo
           AND  mara~entar IN @gs_param-entar
           AND  mara~ean11 IN @gs_param-ean11
           AND  mara~numtp IN @gs_param-numtp
           AND  mara~laeng IN @gs_param-laeng
           AND  mara~breit IN @gs_param-breit
           AND  mara~hoehe IN @gs_param-hoehe
           AND  mara~meabm IN @gs_param-meabm
           AND  mara~prdha IN @gs_param-prdha
           AND  mara~aeklk IN @gs_param-aeklk
           AND  mara~cadkz IN @gs_param-cadkz
           AND  mara~qmpur IN @gs_param-qmpur
           AND  mara~ergew IN @gs_param-ergew
           AND  mara~ergei IN @gs_param-ergei
           AND  mara~ervol IN @gs_param-ervol
           AND  mara~ervoe IN @gs_param-ervoe
           AND  mara~gewto IN @gs_param-gewto
           AND  mara~volto IN @gs_param-volto
           AND  mara~vabme IN @gs_param-vabme
           AND  mara~kzrev IN @gs_param-kzrev
           AND  mara~kzkfg IN @gs_param-kzkfg
           AND  mara~xchpf IN @gs_param-xchpf
           AND  mara~vhart IN @gs_param-vhart
           AND  mara~fuelg IN @gs_param-fuelg
           AND  mara~stfak IN @gs_param-stfak
           AND  mara~magrv IN @gs_param-magrv
           AND  mara~begru IN @gs_param-begru
           AND  mara~datab IN @gs_param-datab
           AND  mara~liqdt IN @gs_param-liqdt
           AND  mara~saisj IN @gs_param-saisj
           AND  mara~plgtp IN @gs_param-plgtp
           AND  mara~mlgut IN @gs_param-mlgut
           AND  mara~extwg IN @gs_param-extwg
           AND  mara~satnr IN @gs_param-satnr
           AND  mara~attyp IN @gs_param-attyp
           AND  mara~kzkup IN @gs_param-kzkup
           AND  mara~kznfm IN @gs_param-kznfm
           AND  mara~pmata IN @gs_param-pmata
           AND  mara~mstde IN @gs_param-mstde
           AND  mara~mstdv IN @gs_param-mstdv
           AND  mara~taklv IN @gs_param-taklv
           AND  mara~rbnrm IN @gs_param-rbnrm
           AND  mara~mhdrz IN @gs_param-mhdrz
           AND  mara~mhdhb IN @gs_param-mhdhb
           AND  mara~mhdlp IN @gs_param-mhdlp
           AND  mara~inhme IN @gs_param-inhme
           AND  mara~inhal IN @gs_param-inhal
           AND  mara~vpreh IN @gs_param-vpreh
           AND  mara~etiag IN @gs_param-etiag
           AND  mara~mtpos_mara IN @gs_param-mtpos_mara
           INTO CORRESPONDING FIELDS OF TABLE @lt_dados.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      ls_bwkey-bwkey = <fs_dados>-bwkey.

      APPEND ls_bwkey TO lt_bwkey.
      CLEAR ls_bwkey.

      APPEND <fs_dados> TO ct_mm.
    ENDLOOP.

    SORT lt_bwkey BY bwkey.
    DELETE ADJACENT DUPLICATES FROM lt_bwkey COMPARING bwkey.

    SELECT bukrs, bwkey
    FROM t001k
    INTO TABLE @DATA(lt_t001k)
    FOR ALL ENTRIES IN @lt_bwkey
    WHERE bwkey = @lt_bwkey-bwkey.

    IF lt_t001k IS NOT INITIAL.

      SELECT waers, bukrs
      FROM t001
      INTO TABLE @DATA(lt_t001)
      FOR ALL ENTRIES IN @lt_t001k
      WHERE bukrs = @lt_t001k-bukrs.

      SORT lt_t001k BY bukrs.
      SORT lt_t001  BY waers.

      LOOP AT ct_mm ASSIGNING FIELD-SYMBOL(<fs_mm>).
        READ TABLE lt_t001k ASSIGNING FIELD-SYMBOL(<fs_t001k>) WITH KEY bwkey = <fs_mm>-bwkey BINARY SEARCH.
        IF sy-subrc = 0.
          READ TABLE lt_t001 ASSIGNING FIELD-SYMBOL(<fs_t001>) WITH KEY bukrs = <fs_t001k>-bukrs BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_mm>-waers = <fs_t001>-waers.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD sel_dados_centros.

    DATA lt_dados TYPE TABLE OF zc_mm_mestre_material.

    SELECT   marc~matnr AS Product, marc~bwtty, marc~xchar, marc~mmsta, marc~mmstd,
             marc~maabc, marc~kzkri, marc~ekgrp, marc~ausme, marc~dispr,
             marc~dismm, marc~dispo, marc~kzdie, marc~plifz, marc~webaz,
             marc~perkz, marc~ausss, marc~disls, marc~beskz, marc~sobsl,
             marc~minbe, marc~eisbe, marc~bstmi, marc~bstma, marc~bstfe,
             marc~bstrf, marc~mabst, marc~sbdkz, marc~bearz, marc~werks,
             marc~ruezt, marc~tranz, marc~basmg, marc~dzeit, marc~maxlz,
             marc~lzeih, marc~kzpro, marc~gpmkz, marc~ueeto, marc~ueetk,
             marc~uneto, marc~wzeit, marc~atpkz, marc~vzusl, marc~herbl,
             marc~insmk, marc~sproz, marc~quazt, marc~ssqss, marc~mpdau,
             marc~kzppv, marc~kzdkz, marc~wstgh, marc~prfrq, marc~nkmpr,
             marc~umlmc, marc~ladgr, marc~usequ, marc~lgrad, marc~auftl,
             marc~plvar, marc~otype, marc~objid, marc~mtvfp, marc~vrvez,
             marc~vbamg, marc~vbeaz, marc~lizyk, marc~prctr, marc~trame,
             marc~mrppp, marc~sauft, marc~fxhor, marc~vrmod, marc~vint1,
             marc~vint2, marc~losgr, marc~sobsk, marc~kausf, marc~qzgtp,
             marc~qmatv, marc~takzt, marc~rwpro, marc~copam, marc~abcin,
             marc~awsls, marc~sernp, marc~cuobj, marc~vrbfk, marc~cuobv,
             marc~resvp, marc~plnty, marc~abfac, marc~sfcpf, marc~shflg,
             marc~shzet, marc~kzagl, marc~glgmg, marc~vkglg,
             marc~indus, marc~steuc, marc~dplho, marc~minls,
             marc~maxls, marc~fixls, marc~ltinc, marc~compl, marc~mcrue,
             marc~lfmon, marc~lfgja, marc~eislo, marc~ncost, marc~bwesb,
             marc~gi_pr_time, marc~min_troc, marc~max_troc, marc~target_stock,

             mara~ersda, mara~ernam, mara~laeda,
             mara~aenam, mara~vpsta, mara~pstat, mara~lvorm, mara~mtart,
             mara~mbrsh, mara~matkl, mara~bismt, mara~meins, mara~blanz,
             mara~groes, mara~wrkst, mara~normt, mara~brgew, mara~ntgew,
             mara~gewei, mara~volum, mara~raube, mara~tragr, mara~spart,
             mara~kunnr, mara~eannr, mara~wesch, mara~bwvor, mara~bwscl,
             mara~saiso, mara~etiar, mara~etifo, mara~entar, mara~ean11,
             mara~numtp, mara~laeng, mara~breit, mara~hoehe, mara~meabm,
             mara~prdha, mara~aeklk, mara~cadkz, mara~qmpur, mara~ergew,
             mara~ergei, mara~ervol, mara~ervoe, mara~gewto, mara~volto,
             mara~vabme, mara~kzrev, mara~kzkfg, mara~xchpf, mara~vhart,
             mara~fuelg, mara~stfak, mara~magrv, mara~begru, mara~datab,
             mara~liqdt, mara~saisj, mara~plgtp, mara~mlgut, mara~extwg,
             mara~satnr, mara~attyp, mara~kzkup, mara~kznfm, mara~pmata,
             mara~mstae, mara~mstav, mara~mstde, mara~mstdv, mara~taklv,
             mara~rbnrm, mara~mhdrz, mara~mhdhb, mara~mhdlp, mara~inhme,
             mara~inhal, mara~vpreh, mara~etiag, mara~mtpos_mara,

             makt_pt~maktx, makt_en~maktx AS maktx2, makt_es~maktx AS maktx3,

             ztmm_catalogorfb~idrfb,

             t134t~mtbez

             FROM marc
             LEFT OUTER JOIN   makt  AS makt_pt ON marc~matnr = makt_pt~matnr  AND makt_pt~spras = 'P'
             LEFT OUTER JOIN   makt  AS makt_en ON marc~matnr = makt_en~matnr  AND makt_en~spras = 'E'
             LEFT OUTER JOIN   makt  AS makt_es ON marc~matnr = makt_es~matnr  AND makt_es~spras = 'S'
             LEFT OUTER JOIN   ztmm_catalogorfb  ON ztmm_catalogorfb~material = marc~matnr
             INNER JOIN mara ON marc~matnr = mara~matnr
             LEFT OUTER JOIN   t134t ON t134t~mtart = mara~mtart AND t134t~spras = @sy-langu "#EC CI_BUFFJOIN

             WHERE marc~matnr IN @gs_param-matnr
             AND marc~werks IN @gs_param-werks
             AND marc~mmsta IN @gs_param-mmsta
             AND marc~bwtty IN @gs_param-bwtty
             AND marc~xchar IN @gs_param-xchar
             AND marc~mmstd IN @gs_param-mmstd
             AND marc~maabc IN @gs_param-maabc
             AND marc~kzkri IN @gs_param-kzkri
             AND marc~ekgrp IN @gs_param-ekgrp
             AND marc~ausme IN @gs_param-ausme
             AND marc~dispr IN @gs_param-dispr
             AND marc~dismm IN @gs_param-dismm
             AND marc~dispo IN @gs_param-dispo
             AND marc~kzdie IN @gs_param-kzdie
             AND marc~plifz IN @gs_param-plifz
             AND marc~webaz IN @gs_param-webaz
             AND marc~perkz IN @gs_param-perkz
             AND marc~ausss IN @gs_param-ausss
             AND marc~disls IN @gs_param-disls
             AND marc~beskz IN @gs_param-beskz
             AND marc~sobsl IN @gs_param-sobsl
             AND marc~minbe IN @gs_param-minbe
             AND marc~eisbe IN @gs_param-eisbe
             AND marc~bstmi IN @gs_param-bstmi
             AND marc~bstma IN @gs_param-bstma
             AND marc~bstfe IN @gs_param-bstfe
             AND marc~bstrf IN @gs_param-bstrf
             AND marc~mabst IN @gs_param-mabst
             AND marc~losfx IN @gs_param-losfx
             AND marc~sbdkz IN @gs_param-sbdkz
             AND marc~bearz IN @gs_param-bearz
             AND marc~ruezt IN @gs_param-ruezt
             AND marc~tranz IN @gs_param-tranz
             AND marc~basmg IN @gs_param-basmg
             AND marc~dzeit IN @gs_param-dzeit
             AND marc~maxlz IN @gs_param-maxlz
             AND marc~lzeih IN @gs_param-lzeih
             AND marc~kzpro IN @gs_param-kzpro
             AND marc~gpmkz IN @gs_param-gpmkz
             AND marc~ueeto IN @gs_param-ueeto
             AND marc~ueetk IN @gs_param-ueetk
             AND marc~uneto IN @gs_param-uneto
             AND marc~wzeit IN @gs_param-wzeit
             AND marc~atpkz IN @gs_param-atpkz
             AND marc~vzusl IN @gs_param-vzusl
             AND marc~herbl IN @gs_param-herbl
             AND marc~insmk IN @gs_param-insmk
             AND marc~sproz IN @gs_param-sproz
             AND marc~quazt IN @gs_param-quazt
             AND marc~ssqss IN @gs_param-ssqss
             AND marc~mpdau IN @gs_param-mpdau
             AND marc~kzppv IN @gs_param-kzppv
             AND marc~kzdkz IN @gs_param-kzdkz
             AND marc~wstgh IN @gs_param-wstgh
             AND marc~prfrq IN @gs_param-prfrq
             AND marc~nkmpr IN @gs_param-nkmpr
             AND marc~umlmc IN @gs_param-umlmc
             AND marc~ladgr IN @gs_param-ladgr
             AND marc~usequ IN @gs_param-usequ
             AND marc~lgrad IN @gs_param-lgrad
             AND marc~auftl IN @gs_param-auftl
             AND marc~plvar IN @gs_param-plvar
             AND marc~otype IN @gs_param-otype
             AND marc~objid IN @gs_param-objid
             AND marc~mtvfp IN @gs_param-mtvfp
             AND marc~vrvez IN @gs_param-vrvez
             AND marc~vbamg IN @gs_param-vbamg
             AND marc~vbeaz IN @gs_param-vbeaz
             AND marc~lizyk IN @gs_param-lizyk
             AND marc~prctr IN @gs_param-prctr
             AND marc~trame IN @gs_param-trame
             AND marc~mrppp IN @gs_param-mrppp
             AND marc~sauft IN @gs_param-sauft
             AND marc~fxhor IN @gs_param-fxhor
             AND marc~vrmod IN @gs_param-vrmod
             AND marc~vint1 IN @gs_param-vint1
             AND marc~vint2 IN @gs_param-vint2
             AND marc~losgr IN @gs_param-losgr
             AND marc~sobsk IN @gs_param-sobsk
             AND marc~kausf IN @gs_param-kausf
             AND marc~qzgtp IN @gs_param-qzgtp
             AND marc~qmatv IN @gs_param-qmatv
             AND marc~takzt IN @gs_param-takzt
             AND marc~rwpro IN @gs_param-rwpro
             AND marc~copam IN @gs_param-copam
             AND marc~abcin IN @gs_param-abcin
             AND marc~awsls IN @gs_param-awsls
             AND marc~sernp IN @gs_param-sernp
             AND marc~cuobj IN @gs_param-cuobj
             AND marc~vrbfk IN @gs_param-vrbfk
             AND marc~cuobv IN @gs_param-cuobv
             AND marc~resvp IN @gs_param-resvp
             AND marc~plnty IN @gs_param-plnty
             AND marc~abfac IN @gs_param-abfac
             AND marc~sfcpf IN @gs_param-sfcpf
             AND marc~shflg IN @gs_param-shflg
             AND marc~shzet IN @gs_param-shzet
             AND marc~vkumc IN @gs_param-vkumc
             AND marc~vktrw IN @gs_param-vktrw
             AND marc~kzagl IN @gs_param-kzagl
             AND marc~glgmg IN @gs_param-glgmg
             AND marc~vkglg IN @gs_param-vkglg
             AND marc~indus IN @gs_param-indus
             AND marc~steuc IN @gs_param-steuc
             AND marc~dplho IN @gs_param-dplho
             AND marc~minls IN @gs_param-minls
             AND marc~maxls IN @gs_param-maxls
             AND marc~fixls IN @gs_param-fixls
             AND marc~ltinc IN @gs_param-ltinc
             AND marc~compl IN @gs_param-compl
             AND marc~mcrue IN @gs_param-mcrue
             AND marc~lfmon IN @gs_param-lfmon
             AND marc~lfgja IN @gs_param-lfgja
             AND marc~eislo IN @gs_param-eislo
             AND marc~ncost IN @gs_param-ncost
             AND marc~bwesb IN @gs_param-bwesb
             AND marc~gi_pr_time   IN @gs_param-gi_pr_time
             AND marc~min_troc     IN @gs_param-min_troc
             AND marc~max_troc     IN @gs_param-max_troc
             AND marc~target_stock IN @gs_param-target_stock

             AND  mara~vpsta IN @gs_param-vpsta
             AND  mara~ersda IN @gs_param-ersda
             AND  mara~lvorm IN @gs_param-lvorm
             AND  mara~matnr IN @gs_param-matnr
             AND  mara~mstae IN @gs_param-mstae
             AND  mara~mstav IN @gs_param-mstav
             AND  mara~mtart IN @gs_param-mtart
             AND  mara~ernam IN @gs_param-ernam
             AND  mara~laeda IN @gs_param-laeda
             AND  mara~aenam IN @gs_param-aenam
             AND  mara~pstat IN @gs_param-pstat
             AND  mara~mbrsh IN @gs_param-mbrsh
             AND  mara~matkl IN @gs_param-matkl
             AND  mara~bismt IN @gs_param-bismt
             AND  mara~meins IN @gs_param-meins
             AND  mara~blanz IN @gs_param-blanz
             AND  mara~groes IN @gs_param-groes
             AND  mara~wrkst IN @gs_param-wrkst
             AND  mara~normt IN @gs_param-normt
             AND  mara~brgew IN @gs_param-brgew
             AND  mara~ntgew IN @gs_param-ntgew
             AND  mara~gewei IN @gs_param-gewei
             AND  mara~volum IN @gs_param-volum
             AND  mara~raube IN @gs_param-raube
             AND  mara~tragr IN @gs_param-tragr
             AND  mara~spart IN @gs_param-spart
             AND  mara~kunnr IN @gs_param-kunnr
             AND  mara~eannr IN @gs_param-eannr
             AND  mara~wesch IN @gs_param-wesch
             AND  mara~bwvor IN @gs_param-bwvor
             AND  mara~bwscl IN @gs_param-bwscl
             AND  mara~saiso IN @gs_param-saiso
             AND  mara~etiar IN @gs_param-etiar
             AND  mara~etifo IN @gs_param-etifo
             AND  mara~entar IN @gs_param-entar
             AND  mara~ean11 IN @gs_param-ean11
             AND  mara~numtp IN @gs_param-numtp
             AND  mara~laeng IN @gs_param-laeng
             AND  mara~breit IN @gs_param-breit
             AND  mara~hoehe IN @gs_param-hoehe
             AND  mara~meabm IN @gs_param-meabm
             AND  mara~prdha IN @gs_param-prdha
             AND  mara~aeklk IN @gs_param-aeklk
             AND  mara~cadkz IN @gs_param-cadkz
             AND  mara~qmpur IN @gs_param-qmpur
             AND  mara~ergew IN @gs_param-ergew
             AND  mara~ergei IN @gs_param-ergei
             AND  mara~ervol IN @gs_param-ervol
             AND  mara~ervoe IN @gs_param-ervoe
             AND  mara~gewto IN @gs_param-gewto
             AND  mara~volto IN @gs_param-volto
             AND  mara~vabme IN @gs_param-vabme
             AND  mara~kzrev IN @gs_param-kzrev
             AND  mara~kzkfg IN @gs_param-kzkfg
             AND  mara~xchpf IN @gs_param-xchpf
             AND  mara~vhart IN @gs_param-vhart
             AND  mara~fuelg IN @gs_param-fuelg
             AND  mara~stfak IN @gs_param-stfak
             AND  mara~magrv IN @gs_param-magrv
             AND  mara~begru IN @gs_param-begru
             AND  mara~datab IN @gs_param-datab
             AND  mara~liqdt IN @gs_param-liqdt
             AND  mara~saisj IN @gs_param-saisj
             AND  mara~plgtp IN @gs_param-plgtp
             AND  mara~mlgut IN @gs_param-mlgut
             AND  mara~extwg IN @gs_param-extwg
             AND  mara~satnr IN @gs_param-satnr
             AND  mara~attyp IN @gs_param-attyp
             AND  mara~kzkup IN @gs_param-kzkup
             AND  mara~kznfm IN @gs_param-kznfm
             AND  mara~pmata IN @gs_param-pmata
             AND  mara~mstde IN @gs_param-mstde
             AND  mara~mstdv IN @gs_param-mstdv
             AND  mara~taklv IN @gs_param-taklv
             AND  mara~rbnrm IN @gs_param-rbnrm
             AND  mara~mhdrz IN @gs_param-mhdrz
             AND  mara~mhdhb IN @gs_param-mhdhb
             AND  mara~mhdlp IN @gs_param-mhdlp
             AND  mara~inhme IN @gs_param-inhme
             AND  mara~inhal IN @gs_param-inhal
             AND  mara~vpreh IN @gs_param-vpreh
             AND  mara~etiag IN @gs_param-etiag
             AND  mara~mtpos_mara IN @gs_param-mtpos_mara

             INTO CORRESPONDING FIELDS OF TABLE @lt_dados.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      APPEND <fs_dados> TO ct_mm.
    ENDLOOP.
  ENDMETHOD.

  METHOD sel_dados_gerais.

    DATA lt_dados TYPE TABLE OF zc_mm_mestre_material.

    SELECT mara~matnr AS product, ztmm_catalogorfb~idrfb, mara~ersda, mara~ernam, mara~laeda,
           mara~aenam, mara~vpsta, mara~pstat, mara~lvorm, mara~mtart,
           mara~mbrsh, mara~matkl, mara~bismt, mara~meins, mara~blanz,
           mara~groes, mara~wrkst, mara~normt, mara~brgew, mara~ntgew,
           mara~gewei, mara~volum, mara~raube, mara~tragr, mara~spart,
           mara~kunnr, mara~eannr, mara~wesch, mara~bwvor, mara~bwscl,
           mara~saiso, mara~etiar, mara~etifo, mara~entar, mara~ean11,
           mara~numtp, mara~laeng, mara~breit, mara~hoehe, mara~meabm,
           mara~prdha, mara~aeklk, mara~cadkz, mara~qmpur, mara~ergew,
           mara~ergei, mara~ervol, mara~ervoe, mara~gewto, mara~volto,
           mara~vabme, mara~kzrev, mara~kzkfg, mara~xchpf, mara~vhart,
           mara~fuelg, mara~stfak, mara~magrv, mara~begru, mara~datab,
           mara~liqdt, mara~saisj, mara~plgtp, mara~mlgut, mara~extwg,
           mara~satnr, mara~attyp, mara~kzkup, mara~kznfm, mara~pmata,
           mara~mstae, mara~mstav, mara~mstde, mara~mstdv, mara~taklv,
           mara~rbnrm, mara~mhdrz, mara~mhdhb, mara~mhdlp, mara~inhme,
           mara~inhal, mara~vpreh, mara~etiag, mara~mtpos_mara,

           makt_pt~maktx, makt_en~maktx AS maktx2, makt_es~maktx AS maktx3,

           t134t~mtbez

           FROM mara
           LEFT OUTER JOIN   makt  AS makt_pt ON mara~matnr = makt_pt~matnr  AND makt_pt~spras = 'P'
           LEFT OUTER JOIN   makt  AS makt_en ON mara~matnr = makt_en~matnr  AND makt_en~spras = 'E'
           LEFT OUTER JOIN   makt  AS makt_es ON mara~matnr = makt_es~matnr  AND makt_es~spras = 'S'
           LEFT OUTER JOIN   ztmm_catalogorfb  ON ztmm_catalogorfb~material = mara~matnr
           LEFT OUTER JOIN   t134t ON t134t~mtart = mara~mtart AND t134t~spras = @sy-langu "#EC CI_BUFFJOIN

           WHERE  mara~vpsta IN @gs_param-vpsta
             AND  mara~ersda IN @gs_param-ersda
             AND  mara~lvorm IN @gs_param-lvorm
             AND  mara~matnr IN @gs_param-matnr
             AND  mara~mstae IN @gs_param-mstae
             AND  mara~mstav IN @gs_param-mstav
             AND  mara~mtart IN @gs_param-mtart
             AND  mara~ernam IN @gs_param-ernam
             AND  mara~laeda IN @gs_param-laeda
             AND  mara~aenam IN @gs_param-aenam
             AND  mara~pstat IN @gs_param-pstat
             AND  mara~mbrsh IN @gs_param-mbrsh
             AND  mara~matkl IN @gs_param-matkl
             AND  mara~bismt IN @gs_param-bismt
             AND  mara~meins IN @gs_param-meins
             AND  mara~blanz IN @gs_param-blanz
             AND  mara~groes IN @gs_param-groes
             AND  mara~wrkst IN @gs_param-wrkst
             AND  mara~normt IN @gs_param-normt
             AND  mara~brgew IN @gs_param-brgew
             AND  mara~ntgew IN @gs_param-ntgew
             AND  mara~gewei IN @gs_param-gewei
             AND  mara~volum IN @gs_param-volum
             AND  mara~raube IN @gs_param-raube
             AND  mara~tragr IN @gs_param-tragr
             AND  mara~spart IN @gs_param-spart
             AND  mara~kunnr IN @gs_param-kunnr
             AND  mara~eannr IN @gs_param-eannr
             AND  mara~wesch IN @gs_param-wesch
             AND  mara~bwvor IN @gs_param-bwvor
             AND  mara~bwscl IN @gs_param-bwscl
             AND  mara~saiso IN @gs_param-saiso
             AND  mara~etiar IN @gs_param-etiar
             AND  mara~etifo IN @gs_param-etifo
             AND  mara~entar IN @gs_param-entar
             AND  mara~ean11 IN @gs_param-ean11
             AND  mara~numtp IN @gs_param-numtp
             AND  mara~laeng IN @gs_param-laeng
             AND  mara~breit IN @gs_param-breit
             AND  mara~hoehe IN @gs_param-hoehe
             AND  mara~meabm IN @gs_param-meabm
             AND  mara~prdha IN @gs_param-prdha
             AND  mara~aeklk IN @gs_param-aeklk
             AND  mara~cadkz IN @gs_param-cadkz
             AND  mara~qmpur IN @gs_param-qmpur
             AND  mara~ergew IN @gs_param-ergew
             AND  mara~ergei IN @gs_param-ergei
             AND  mara~ervol IN @gs_param-ervol
             AND  mara~ervoe IN @gs_param-ervoe
             AND  mara~gewto IN @gs_param-gewto
             AND  mara~volto IN @gs_param-volto
             AND  mara~vabme IN @gs_param-vabme
             AND  mara~kzrev IN @gs_param-kzrev
             AND  mara~kzkfg IN @gs_param-kzkfg
             AND  mara~xchpf IN @gs_param-xchpf
             AND  mara~vhart IN @gs_param-vhart
             AND  mara~fuelg IN @gs_param-fuelg
             AND  mara~stfak IN @gs_param-stfak
             AND  mara~magrv IN @gs_param-magrv
             AND  mara~begru IN @gs_param-begru
             AND  mara~datab IN @gs_param-datab
             AND  mara~liqdt IN @gs_param-liqdt
             AND  mara~saisj IN @gs_param-saisj
             AND  mara~plgtp IN @gs_param-plgtp
             AND  mara~mlgut IN @gs_param-mlgut
             AND  mara~extwg IN @gs_param-extwg
             AND  mara~satnr IN @gs_param-satnr
             AND  mara~attyp IN @gs_param-attyp
             AND  mara~kzkup IN @gs_param-kzkup
             AND  mara~kznfm IN @gs_param-kznfm
             AND  mara~pmata IN @gs_param-pmata
             AND  mara~mstde IN @gs_param-mstde
             AND  mara~mstdv IN @gs_param-mstdv
             AND  mara~taklv IN @gs_param-taklv
             AND  mara~rbnrm IN @gs_param-rbnrm
             AND  mara~mhdrz IN @gs_param-mhdrz
             AND  mara~mhdhb IN @gs_param-mhdhb
             AND  mara~mhdlp IN @gs_param-mhdlp
             AND  mara~inhme IN @gs_param-inhme
             AND  mara~inhal IN @gs_param-inhal
             AND  mara~vpreh IN @gs_param-vpreh
             AND  mara~etiag IN @gs_param-etiag
             AND  mara~mtpos_mara IN @gs_param-mtpos_mara

             INTO CORRESPONDING FIELDS OF TABLE @lt_dados.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      APPEND <fs_dados> TO ct_mm.
    ENDLOOP.

  ENDMETHOD.

  METHOD sel_dados_vendas.

    DATA lt_dados TYPE TABLE OF zc_mm_mestre_material.

    SELECT mvke~matnr AS Product, mvke~versg, mvke~bonus, mvke~provg, mvke~vtweg, mvke~vkorg,
           mvke~sktof, mvke~vmsta, mvke~vmstd, mvke~aumng, mvke~lfmng,
           mvke~efmng, mvke~scmng, mvke~schme, mvke~vrkme, mvke~mtpos,
           mvke~dwerk, mvke~prodh, mvke~pmatn, mvke~kondm, mvke~ktgrm,
           mvke~mvgr1, mvke~prat1, mvke~lfmax, mvke~pvmso, mvke~/bev1/emdrckspl,

           makt_pt~maktx, makt_en~maktx AS maktx2, makt_es~maktx AS maktx3,

           ztmm_catalogorfb~idrfb,

           t134t~mtbez,

           mara~ersda, mara~ernam, mara~laeda,
           mara~aenam, mara~vpsta, mara~pstat, mara~lvorm, mara~mtart,
           mara~mbrsh, mara~matkl, mara~bismt, mara~meins, mara~blanz,
           mara~groes, mara~wrkst, mara~normt, mara~brgew, mara~ntgew,
           mara~gewei, mara~volum, mara~raube, mara~tragr, mara~spart,
           mara~kunnr, mara~eannr, mara~wesch, mara~bwvor, mara~bwscl,
           mara~saiso, mara~etiar, mara~etifo, mara~entar, mara~ean11,
           mara~numtp, mara~laeng, mara~breit, mara~hoehe, mara~meabm,
           mara~prdha, mara~aeklk, mara~cadkz, mara~qmpur, mara~ergew,
           mara~ergei, mara~ervol, mara~ervoe, mara~gewto, mara~volto,
           mara~vabme, mara~kzrev, mara~kzkfg, mara~xchpf, mara~vhart,
           mara~fuelg, mara~stfak, mara~magrv, mara~begru, mara~datab,
           mara~liqdt, mara~saisj, mara~plgtp, mara~mlgut, mara~extwg,
           mara~satnr, mara~attyp, mara~kzkup, mara~kznfm, mara~pmata,
           mara~mstae, mara~mstav, mara~mstde, mara~mstdv, mara~taklv,
           mara~rbnrm, mara~mhdrz, mara~mhdhb, mara~mhdlp, mara~inhme,
           mara~inhal, mara~vpreh, mara~etiag, mara~mtpos_mara

           FROM mvke
           LEFT OUTER JOIN   makt  AS makt_pt ON mvke~matnr = makt_pt~matnr  AND makt_pt~spras = 'P'
           LEFT OUTER JOIN   makt  AS makt_en ON mvke~matnr = makt_en~matnr  AND makt_en~spras = 'E'
           LEFT OUTER JOIN   makt  AS makt_es ON mvke~matnr = makt_es~matnr  AND makt_es~spras = 'S'
           LEFT OUTER JOIN   ztmm_catalogorfb ON ztmm_catalogorfb~material = mvke~matnr
           INNER JOIN mara ON mvke~matnr = mara~matnr
           LEFT OUTER JOIN   t134t ON t134t~mtart = mara~mtart AND t134t~spras = @sy-langu "#EC CI_BUFFJOIN

           WHERE mvke~matnr IN @gs_param-matnr
           AND mvke~vkorg   IN @gs_param-vkorg
           AND mvke~vtweg   IN @gs_param-vtweg
           AND mvke~versg   IN @gs_param-versg
           AND mvke~bonus   IN @gs_param-bonus
           AND mvke~provg   IN @gs_param-provg
           AND mvke~sktof   IN @gs_param-sktof
           AND mvke~vmsta   IN @gs_param-vmsta
           AND mvke~vmstd   IN @gs_param-vmstd
           AND mvke~aumng   IN @gs_param-aumng
           AND mvke~lfmng   IN @gs_param-lfmng
           AND mvke~efmng   IN @gs_param-efmng
           AND mvke~scmng   IN @gs_param-scmng
           AND mvke~schme   IN @gs_param-schme
           AND mvke~vrkme   IN @gs_param-vrkme
           AND mvke~mtpos   IN @gs_param-mtpos
           AND mvke~dwerk   IN @gs_param-dwerk
           AND mvke~prodh   IN @gs_param-prodh
           AND mvke~pmatn   IN @gs_param-pmatn
           AND mvke~kondm   IN @gs_param-kondm
           AND mvke~ktgrm   IN @gs_param-ktgrm
           AND mvke~mvgr1   IN @gs_param-mvgr1
           AND mvke~prat1   IN @gs_param-prat1
           AND mvke~lfmax   IN @gs_param-lfmax
           AND mvke~pvmso   IN @gs_param-pvmso

           AND  mara~vpsta IN @gs_param-vpsta
           AND  mara~ersda IN @gs_param-ersda
           AND  mara~lvorm IN @gs_param-lvorm
           AND  mara~matnr IN @gs_param-matnr
           AND  mara~mstae IN @gs_param-mstae
           AND  mara~mstav IN @gs_param-mstav
           AND  mara~mtart IN @gs_param-mtart
           AND  mara~ernam IN @gs_param-ernam
           AND  mara~laeda IN @gs_param-laeda
           AND  mara~aenam IN @gs_param-aenam
           AND  mara~pstat IN @gs_param-pstat
           AND  mara~mbrsh IN @gs_param-mbrsh
           AND  mara~matkl IN @gs_param-matkl
           AND  mara~bismt IN @gs_param-bismt
           AND  mara~meins IN @gs_param-meins
           AND  mara~blanz IN @gs_param-blanz
           AND  mara~groes IN @gs_param-groes
           AND  mara~wrkst IN @gs_param-wrkst
           AND  mara~normt IN @gs_param-normt
           AND  mara~brgew IN @gs_param-brgew
           AND  mara~ntgew IN @gs_param-ntgew
           AND  mara~gewei IN @gs_param-gewei
           AND  mara~volum IN @gs_param-volum
           AND  mara~raube IN @gs_param-raube
           AND  mara~tragr IN @gs_param-tragr
           AND  mara~spart IN @gs_param-spart
           AND  mara~kunnr IN @gs_param-kunnr
           AND  mara~eannr IN @gs_param-eannr
           AND  mara~wesch IN @gs_param-wesch
           AND  mara~bwvor IN @gs_param-bwvor
           AND  mara~bwscl IN @gs_param-bwscl
           AND  mara~saiso IN @gs_param-saiso
           AND  mara~etiar IN @gs_param-etiar
           AND  mara~etifo IN @gs_param-etifo
           AND  mara~entar IN @gs_param-entar
           AND  mara~ean11 IN @gs_param-ean11
           AND  mara~numtp IN @gs_param-numtp
           AND  mara~laeng IN @gs_param-laeng
           AND  mara~breit IN @gs_param-breit
           AND  mara~hoehe IN @gs_param-hoehe
           AND  mara~meabm IN @gs_param-meabm
           AND  mara~prdha IN @gs_param-prdha
           AND  mara~aeklk IN @gs_param-aeklk
           AND  mara~cadkz IN @gs_param-cadkz
           AND  mara~qmpur IN @gs_param-qmpur
           AND  mara~ergew IN @gs_param-ergew
           AND  mara~ergei IN @gs_param-ergei
           AND  mara~ervol IN @gs_param-ervol
           AND  mara~ervoe IN @gs_param-ervoe
           AND  mara~gewto IN @gs_param-gewto
           AND  mara~volto IN @gs_param-volto
           AND  mara~vabme IN @gs_param-vabme
           AND  mara~kzrev IN @gs_param-kzrev
           AND  mara~kzkfg IN @gs_param-kzkfg
           AND  mara~xchpf IN @gs_param-xchpf
           AND  mara~vhart IN @gs_param-vhart
           AND  mara~fuelg IN @gs_param-fuelg
           AND  mara~stfak IN @gs_param-stfak
           AND  mara~magrv IN @gs_param-magrv
           AND  mara~begru IN @gs_param-begru
           AND  mara~datab IN @gs_param-datab
           AND  mara~liqdt IN @gs_param-liqdt
           AND  mara~saisj IN @gs_param-saisj
           AND  mara~plgtp IN @gs_param-plgtp
           AND  mara~mlgut IN @gs_param-mlgut
           AND  mara~extwg IN @gs_param-extwg
           AND  mara~satnr IN @gs_param-satnr
           AND  mara~attyp IN @gs_param-attyp
           AND  mara~kzkup IN @gs_param-kzkup
           AND  mara~kznfm IN @gs_param-kznfm
           AND  mara~pmata IN @gs_param-pmata
           AND  mara~mstde IN @gs_param-mstde
           AND  mara~mstdv IN @gs_param-mstdv
           AND  mara~taklv IN @gs_param-taklv
           AND  mara~rbnrm IN @gs_param-rbnrm
           AND  mara~mhdrz IN @gs_param-mhdrz
           AND  mara~mhdhb IN @gs_param-mhdhb
           AND  mara~mhdlp IN @gs_param-mhdlp
           AND  mara~inhme IN @gs_param-inhme
           AND  mara~inhal IN @gs_param-inhal
           AND  mara~vpreh IN @gs_param-vpreh
           AND  mara~etiag IN @gs_param-etiag
           AND  mara~mtpos_mara IN @gs_param-mtpos_mara

           INTO CORRESPONDING FIELDS OF TABLE @lt_dados.

    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
      APPEND <fs_dados> TO ct_mm.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_ref_data.
    ASSIGN gr_matnr->*           TO FIELD-SYMBOL(<fs_matnr>).
    ASSIGN gr_werks->*           TO FIELD-SYMBOL(<fs_werks>).
    ASSIGN gr_bwtar->*           TO FIELD-SYMBOL(<fs_bwtar>).
    ASSIGN gr_idrfb->*           TO FIELD-SYMBOL(<fs_idrfb>).
    ASSIGN gr_vtweg->*           TO FIELD-SYMBOL(<fs_vtweg>).
    ASSIGN gr_vkorg->*           TO FIELD-SYMBOL(<fs_vkorg>).
    ASSIGN gr_mtart->*           TO FIELD-SYMBOL(<fs_mtart>).
    ASSIGN gr_ersda->*           TO FIELD-SYMBOL(<fs_ersda>).
    ASSIGN gr_ernam->*           TO FIELD-SYMBOL(<fs_ernam>).
    ASSIGN gr_laeda->*           TO FIELD-SYMBOL(<fs_laeda>).
    ASSIGN gr_aenam->*           TO FIELD-SYMBOL(<fs_aenam>).
    ASSIGN gr_mstae->*           TO FIELD-SYMBOL(<fs_mstae>).
    ASSIGN gr_mmsta->*           TO FIELD-SYMBOL(<fs_mmsta>).
    ASSIGN gr_vmsta->*           TO FIELD-SYMBOL(<fs_vmsta>).
    ASSIGN gr_vpsta->*           TO FIELD-SYMBOL(<fs_vpsta>).
    ASSIGN gr_mstav->*           TO FIELD-SYMBOL(<fs_mstav>).
    ASSIGN gr_lvorm->*           TO FIELD-SYMBOL(<fs_lvorm>).
    ASSIGN gr_pstat->*           TO FIELD-SYMBOL(<fs_pstat>).
    ASSIGN gr_mbrsh->*           TO FIELD-SYMBOL(<fs_mbrsh>).
    ASSIGN gr_matkl->*           TO FIELD-SYMBOL(<fs_matkl>).
    ASSIGN gr_bismt->*           TO FIELD-SYMBOL(<fs_bismt>).
    ASSIGN gr_meins->*           TO FIELD-SYMBOL(<fs_meins>).
    ASSIGN gr_blanz->*           TO FIELD-SYMBOL(<fs_blanz>).
    ASSIGN gr_groes->*           TO FIELD-SYMBOL(<fs_groes>).
    ASSIGN gr_wrkst->*           TO FIELD-SYMBOL(<fs_wrkst>).
    ASSIGN gr_normt->*           TO FIELD-SYMBOL(<fs_normt>).
    ASSIGN gr_brgew->*           TO FIELD-SYMBOL(<fs_brgew>).
    ASSIGN gr_ntgew->*           TO FIELD-SYMBOL(<fs_ntgew>).
    ASSIGN gr_gewei->*           TO FIELD-SYMBOL(<fs_gewei>).
    ASSIGN gr_volum->*           TO FIELD-SYMBOL(<fs_volum>).
    ASSIGN gr_raube->*           TO FIELD-SYMBOL(<fs_raube>).
    ASSIGN gr_tragr->*           TO FIELD-SYMBOL(<fs_tragr>).
    ASSIGN gr_spart->*           TO FIELD-SYMBOL(<fs_spart>).
    ASSIGN gr_kunnr->*           TO FIELD-SYMBOL(<fs_kunnr>).
    ASSIGN gr_eannr->*           TO FIELD-SYMBOL(<fs_eannr>).
    ASSIGN gr_wesch->*           TO FIELD-SYMBOL(<fs_wesch>).
    ASSIGN gr_bwvor->*           TO FIELD-SYMBOL(<fs_bwvor>).
    ASSIGN gr_bwscl->*           TO FIELD-SYMBOL(<fs_bwscl>).
    ASSIGN gr_saiso->*           TO FIELD-SYMBOL(<fs_saiso>).
    ASSIGN gr_etiar->*           TO FIELD-SYMBOL(<fs_etiar>).
    ASSIGN gr_etifo->*           TO FIELD-SYMBOL(<fs_etifo>).
    ASSIGN gr_entar->*           TO FIELD-SYMBOL(<fs_entar>).
    ASSIGN gr_ean11->*           TO FIELD-SYMBOL(<fs_ean11>).
    ASSIGN gr_numtp->*           TO FIELD-SYMBOL(<fs_numtp>).
    ASSIGN gr_laeng->*           TO FIELD-SYMBOL(<fs_laeng>).
    ASSIGN gr_breit->*           TO FIELD-SYMBOL(<fs_breit>).
    ASSIGN gr_hoehe->*           TO FIELD-SYMBOL(<fs_hoehe>).
    ASSIGN gr_meabm->*           TO FIELD-SYMBOL(<fs_meabm>).
    ASSIGN gr_prdha->*           TO FIELD-SYMBOL(<fs_prdha>).
    ASSIGN gr_aeklk->*           TO FIELD-SYMBOL(<fs_aeklk>).
    ASSIGN gr_cadkz->*           TO FIELD-SYMBOL(<fs_cadkz>).
    ASSIGN gr_qmpur->*           TO FIELD-SYMBOL(<fs_qmpur>).
    ASSIGN gr_ergew->*           TO FIELD-SYMBOL(<fs_ergew>).
    ASSIGN gr_ergei->*           TO FIELD-SYMBOL(<fs_ergei>).
    ASSIGN gr_ervol->*           TO FIELD-SYMBOL(<fs_ervol>).
    ASSIGN gr_ervoe->*           TO FIELD-SYMBOL(<fs_ervoe>).
    ASSIGN gr_gewto->*           TO FIELD-SYMBOL(<fs_gewto>).
    ASSIGN gr_volto->*           TO FIELD-SYMBOL(<fs_volto>).
    ASSIGN gr_vabme->*           TO FIELD-SYMBOL(<fs_vabme>).
    ASSIGN gr_kzrev->*           TO FIELD-SYMBOL(<fs_kzrev>).
    ASSIGN gr_kzkfg->*           TO FIELD-SYMBOL(<fs_kzkfg>).
    ASSIGN gr_xchpf->*           TO FIELD-SYMBOL(<fs_xchpf>).
    ASSIGN gr_vhart->*           TO FIELD-SYMBOL(<fs_vhart>).
    ASSIGN gr_fuelg->*           TO FIELD-SYMBOL(<fs_fuelg>).
    ASSIGN gr_stfak->*           TO FIELD-SYMBOL(<fs_stfak>).
    ASSIGN gr_magrv->*           TO FIELD-SYMBOL(<fs_magrv>).
    ASSIGN gr_begru->*           TO FIELD-SYMBOL(<fs_begru>).
    ASSIGN gr_datab->*           TO FIELD-SYMBOL(<fs_datab>).
    ASSIGN gr_liqdt->*           TO FIELD-SYMBOL(<fs_liqdt>).
    ASSIGN gr_saisj->*           TO FIELD-SYMBOL(<fs_saisj>).
    ASSIGN gr_plgtp->*           TO FIELD-SYMBOL(<fs_plgtp>).
    ASSIGN gr_mlgut->*           TO FIELD-SYMBOL(<fs_mlgut>).
    ASSIGN gr_extwg->*           TO FIELD-SYMBOL(<fs_extwg>).
    ASSIGN gr_satnr->*           TO FIELD-SYMBOL(<fs_satnr>).
    ASSIGN gr_attyp->*           TO FIELD-SYMBOL(<fs_attyp>).
    ASSIGN gr_kzkup->*           TO FIELD-SYMBOL(<fs_kzkup>).
    ASSIGN gr_kznfm->*           TO FIELD-SYMBOL(<fs_kznfm>).
    ASSIGN gr_pmata->*           TO FIELD-SYMBOL(<fs_pmata>).
    ASSIGN gr_mstde->*           TO FIELD-SYMBOL(<fs_mstde>).
    ASSIGN gr_mstdv->*           TO FIELD-SYMBOL(<fs_mstdv>).
    ASSIGN gr_taklv->*           TO FIELD-SYMBOL(<fs_taklv>).
    ASSIGN gr_rbnrm->*           TO FIELD-SYMBOL(<fs_rbnrm>).
    ASSIGN gr_mhdrz->*           TO FIELD-SYMBOL(<fs_mhdrz>).
    ASSIGN gr_mhdhb->*           TO FIELD-SYMBOL(<fs_mhdhb>).
    ASSIGN gr_mhdlp->*           TO FIELD-SYMBOL(<fs_mhdlp>).
    ASSIGN gr_inhme->*           TO FIELD-SYMBOL(<fs_inhme>).
    ASSIGN gr_inhal->*           TO FIELD-SYMBOL(<fs_inhal>).
    ASSIGN gr_vpreh->*           TO FIELD-SYMBOL(<fs_vpreh>).
    ASSIGN gr_etiag->*           TO FIELD-SYMBOL(<fs_etiag>).
    ASSIGN gr_mtpos_mara->*      TO FIELD-SYMBOL(<fs_mtpos_mara>).
    ASSIGN gr_bwtty->*           TO FIELD-SYMBOL(<fs_bwtty>).
    ASSIGN gr_xchar->*           TO FIELD-SYMBOL(<fs_xchar>).
    ASSIGN gr_mmstd->*           TO FIELD-SYMBOL(<fs_mmstd>).
    ASSIGN gr_maabc->*           TO FIELD-SYMBOL(<fs_maabc>).
    ASSIGN gr_kzkri->*           TO FIELD-SYMBOL(<fs_kzkri>).
    ASSIGN gr_ekgrp->*           TO FIELD-SYMBOL(<fs_ekgrp>).
    ASSIGN gr_ausme->*           TO FIELD-SYMBOL(<fs_ausme>).
    ASSIGN gr_dispr->*           TO FIELD-SYMBOL(<fs_dispr>).
    ASSIGN gr_dismm->*           TO FIELD-SYMBOL(<fs_dismm>).
    ASSIGN gr_dispo->*           TO FIELD-SYMBOL(<fs_dispo>).
    ASSIGN gr_kzdie->*           TO FIELD-SYMBOL(<fs_kzdie>).
    ASSIGN gr_plifz->*           TO FIELD-SYMBOL(<fs_plifz>).
    ASSIGN gr_webaz->*           TO FIELD-SYMBOL(<fs_webaz>).
    ASSIGN gr_perkz->*           TO FIELD-SYMBOL(<fs_perkz>).
    ASSIGN gr_ausss->*           TO FIELD-SYMBOL(<fs_ausss>).
    ASSIGN gr_disls->*           TO FIELD-SYMBOL(<fs_disls>).
    ASSIGN gr_beskz->*           TO FIELD-SYMBOL(<fs_beskz>).
    ASSIGN gr_sobsl->*           TO FIELD-SYMBOL(<fs_sobsl>).
    ASSIGN gr_minbe->*           TO FIELD-SYMBOL(<fs_minbe>).
    ASSIGN gr_eisbe->*           TO FIELD-SYMBOL(<fs_eisbe>).
    ASSIGN gr_bstmi->*           TO FIELD-SYMBOL(<fs_bstmi>).
    ASSIGN gr_bstma->*           TO FIELD-SYMBOL(<fs_bstma>).
    ASSIGN gr_bstfe->*           TO FIELD-SYMBOL(<fs_bstfe>).
    ASSIGN gr_bstrf->*           TO FIELD-SYMBOL(<fs_bstrf>).
    ASSIGN gr_mabst->*           TO FIELD-SYMBOL(<fs_mabst>).
    ASSIGN gr_losfx->*           TO FIELD-SYMBOL(<fs_losfx>).
    ASSIGN gr_sbdkz->*           TO FIELD-SYMBOL(<fs_sbdkz>).
    ASSIGN gr_bearz->*           TO FIELD-SYMBOL(<fs_bearz>).
    ASSIGN gr_ruezt->*           TO FIELD-SYMBOL(<fs_ruezt>).
    ASSIGN gr_tranz->*           TO FIELD-SYMBOL(<fs_tranz>).
    ASSIGN gr_basmg->*           TO FIELD-SYMBOL(<fs_basmg>).
    ASSIGN gr_dzeit->*           TO FIELD-SYMBOL(<fs_dzeit>).
    ASSIGN gr_maxlz->*           TO FIELD-SYMBOL(<fs_maxlz>).
    ASSIGN gr_lzeih->*           TO FIELD-SYMBOL(<fs_lzeih>).
    ASSIGN gr_kzpro->*           TO FIELD-SYMBOL(<fs_kzpro>).
    ASSIGN gr_gpmkz->*           TO FIELD-SYMBOL(<fs_gpmkz>).
    ASSIGN gr_ueeto->*           TO FIELD-SYMBOL(<fs_ueeto>).
    ASSIGN gr_ueetk->*           TO FIELD-SYMBOL(<fs_ueetk>).
    ASSIGN gr_uneto->*           TO FIELD-SYMBOL(<fs_uneto>).
    ASSIGN gr_wzeit->*           TO FIELD-SYMBOL(<fs_wzeit>).
    ASSIGN gr_atpkz->*           TO FIELD-SYMBOL(<fs_atpkz>).
    ASSIGN gr_vzusl->*           TO FIELD-SYMBOL(<fs_vzusl>).
    ASSIGN gr_herbl->*           TO FIELD-SYMBOL(<fs_herbl>).
    ASSIGN gr_insmk->*           TO FIELD-SYMBOL(<fs_insmk>).
    ASSIGN gr_sproz->*           TO FIELD-SYMBOL(<fs_sproz>).
    ASSIGN gr_quazt->*           TO FIELD-SYMBOL(<fs_quazt>).
    ASSIGN gr_ssqss->*           TO FIELD-SYMBOL(<fs_ssqss>).
    ASSIGN gr_mpdau->*           TO FIELD-SYMBOL(<fs_mpdau>).
    ASSIGN gr_kzppv->*           TO FIELD-SYMBOL(<fs_kzppv>).
    ASSIGN gr_kzdkz->*           TO FIELD-SYMBOL(<fs_kzdkz>).
    ASSIGN gr_wstgh->*           TO FIELD-SYMBOL(<fs_wstgh>).
    ASSIGN gr_prfrq->*           TO FIELD-SYMBOL(<fs_prfrq>).
    ASSIGN gr_nkmpr->*           TO FIELD-SYMBOL(<fs_nkmpr>).
    ASSIGN gr_umlmc->*           TO FIELD-SYMBOL(<fs_umlmc>).
    ASSIGN gr_ladgr->*           TO FIELD-SYMBOL(<fs_ladgr>).
    ASSIGN gr_usequ->*           TO FIELD-SYMBOL(<fs_usequ>).
    ASSIGN gr_lgrad->*           TO FIELD-SYMBOL(<fs_lgrad>).
    ASSIGN gr_auftl->*           TO FIELD-SYMBOL(<fs_auftl>).
    ASSIGN gr_plvar->*           TO FIELD-SYMBOL(<fs_plvar>).
    ASSIGN gr_otype->*           TO FIELD-SYMBOL(<fs_otype>).
    ASSIGN gr_objid->*           TO FIELD-SYMBOL(<fs_objid>).
    ASSIGN gr_mtvfp->*           TO FIELD-SYMBOL(<fs_mtvfp>).
    ASSIGN gr_vrvez->*           TO FIELD-SYMBOL(<fs_vrvez>).
    ASSIGN gr_vbamg->*           TO FIELD-SYMBOL(<fs_vbamg>).
    ASSIGN gr_vbeaz->*           TO FIELD-SYMBOL(<fs_vbeaz>).
    ASSIGN gr_lizyk->*           TO FIELD-SYMBOL(<fs_lizyk>).
    ASSIGN gr_prctr->*           TO FIELD-SYMBOL(<fs_prctr>).
    ASSIGN gr_trame->*           TO FIELD-SYMBOL(<fs_trame>).
    ASSIGN gr_mrppp->*           TO FIELD-SYMBOL(<fs_mrppp>).
    ASSIGN gr_sauft->*           TO FIELD-SYMBOL(<fs_sauft>).
    ASSIGN gr_fxhor->*           TO FIELD-SYMBOL(<fs_fxhor>).
    ASSIGN gr_vrmod->*           TO FIELD-SYMBOL(<fs_vrmod>).
    ASSIGN gr_vint1->*           TO FIELD-SYMBOL(<fs_vint1>).
    ASSIGN gr_vint2->*           TO FIELD-SYMBOL(<fs_vint2>).
    ASSIGN gr_losgr->*           TO FIELD-SYMBOL(<fs_losgr>).
    ASSIGN gr_sobsk->*           TO FIELD-SYMBOL(<fs_sobsk>).
    ASSIGN gr_kausf->*           TO FIELD-SYMBOL(<fs_kausf>).
    ASSIGN gr_qzgtp->*           TO FIELD-SYMBOL(<fs_qzgtp>).
    ASSIGN gr_qmatv->*           TO FIELD-SYMBOL(<fs_qmatv>).
    ASSIGN gr_takzt->*           TO FIELD-SYMBOL(<fs_takzt>).
    ASSIGN gr_rwpro->*           TO FIELD-SYMBOL(<fs_rwpro>).
    ASSIGN gr_copam->*           TO FIELD-SYMBOL(<fs_copam>).
    ASSIGN gr_abcin->*           TO FIELD-SYMBOL(<fs_abcin>).
    ASSIGN gr_awsls->*           TO FIELD-SYMBOL(<fs_awsls>).
    ASSIGN gr_sernp->*           TO FIELD-SYMBOL(<fs_sernp>).
    ASSIGN gr_cuobj->*           TO FIELD-SYMBOL(<fs_cuobj>).
    ASSIGN gr_vrbfk->*           TO FIELD-SYMBOL(<fs_vrbfk>).
    ASSIGN gr_cuobv->*           TO FIELD-SYMBOL(<fs_cuobv>).
    ASSIGN gr_resvp->*           TO FIELD-SYMBOL(<fs_resvp>).
    ASSIGN gr_plnty->*           TO FIELD-SYMBOL(<fs_plnty>).
    ASSIGN gr_abfac->*           TO FIELD-SYMBOL(<fs_abfac>).
    ASSIGN gr_sfcpf->*           TO FIELD-SYMBOL(<fs_sfcpf>).
    ASSIGN gr_shflg->*           TO FIELD-SYMBOL(<fs_shflg>).
    ASSIGN gr_shzet->*           TO FIELD-SYMBOL(<fs_shzet>).
    ASSIGN gr_vkumc->*           TO FIELD-SYMBOL(<fs_vkumc>).
    ASSIGN gr_vktrw->*           TO FIELD-SYMBOL(<fs_vktrw>).
    ASSIGN gr_kzagl->*           TO FIELD-SYMBOL(<fs_kzagl>).
    ASSIGN gr_glgmg->*           TO FIELD-SYMBOL(<fs_glgmg>).
    ASSIGN gr_vkglg->*           TO FIELD-SYMBOL(<fs_vkglg>).
    ASSIGN gr_indus->*           TO FIELD-SYMBOL(<fs_indus>).
    ASSIGN gr_steuc->*           TO FIELD-SYMBOL(<fs_steuc>).
    ASSIGN gr_dplho->*           TO FIELD-SYMBOL(<fs_dplho>).
    ASSIGN gr_minls->*           TO FIELD-SYMBOL(<fs_minls>).
    ASSIGN gr_maxls->*           TO FIELD-SYMBOL(<fs_maxls>).
    ASSIGN gr_fixls->*           TO FIELD-SYMBOL(<fs_fixls>).
    ASSIGN gr_ltinc->*           TO FIELD-SYMBOL(<fs_ltinc>).
    ASSIGN gr_compl->*           TO FIELD-SYMBOL(<fs_compl>).
    ASSIGN gr_mcrue->*           TO FIELD-SYMBOL(<fs_mcrue>).
    ASSIGN gr_lfmon->*           TO FIELD-SYMBOL(<fs_lfmon>).
    ASSIGN gr_lfgja->*           TO FIELD-SYMBOL(<fs_lfgja>).
    ASSIGN gr_eislo->*           TO FIELD-SYMBOL(<fs_eislo>).
    ASSIGN gr_ncost->*           TO FIELD-SYMBOL(<fs_ncost>).
    ASSIGN gr_bwesb->*           TO FIELD-SYMBOL(<fs_bwesb>).
    ASSIGN gr_gi_pr_time->*      TO FIELD-SYMBOL(<fs_gi_pr_time>).
    ASSIGN gr_min_troc->*        TO FIELD-SYMBOL(<fs_min_troc>).
    ASSIGN gr_max_troc->*        TO FIELD-SYMBOL(<fs_max_troc>).
    ASSIGN gr_target_stock->*    TO FIELD-SYMBOL(<fs_target_stock>).
    ASSIGN gr_bwkey->*           TO FIELD-SYMBOL(<fs_bwkey>).
    ASSIGN gr_lbkum->*           TO FIELD-SYMBOL(<fs_lbkum>).
    ASSIGN gr_salk3->*           TO FIELD-SYMBOL(<fs_salk3>).
    ASSIGN gr_vprsv->*           TO FIELD-SYMBOL(<fs_vprsv>).
    ASSIGN gr_verpr->*           TO FIELD-SYMBOL(<fs_verpr>).
    ASSIGN gr_stprs->*           TO FIELD-SYMBOL(<fs_stprs>).
    ASSIGN gr_peinh->*           TO FIELD-SYMBOL(<fs_peinh>).
    ASSIGN gr_bklas->*           TO FIELD-SYMBOL(<fs_bklas>).
    ASSIGN gr_salkv->*           TO FIELD-SYMBOL(<fs_salkv>).
    ASSIGN gr_vmkum->*           TO FIELD-SYMBOL(<fs_vmkum>).
    ASSIGN gr_vmsal->*           TO FIELD-SYMBOL(<fs_vmsal>).
    ASSIGN gr_vmvpr->*           TO FIELD-SYMBOL(<fs_vmvpr>).
    ASSIGN gr_vmver->*           TO FIELD-SYMBOL(<fs_vmver>).
    ASSIGN gr_vmstp->*           TO FIELD-SYMBOL(<fs_vmstp>).
    ASSIGN gr_vmpei->*           TO FIELD-SYMBOL(<fs_vmpei>).
    ASSIGN gr_vmbkl->*           TO FIELD-SYMBOL(<fs_vmbkl>).
    ASSIGN gr_vmsav->*           TO FIELD-SYMBOL(<fs_vmsav>).
    ASSIGN gr_vjkum->*           TO FIELD-SYMBOL(<fs_vjkum>).
    ASSIGN gr_vjsal->*           TO FIELD-SYMBOL(<fs_vjsal>).
    ASSIGN gr_vjvpr->*           TO FIELD-SYMBOL(<fs_vjvpr>).
    ASSIGN gr_vjver->*           TO FIELD-SYMBOL(<fs_vjver>).
    ASSIGN gr_vjstp->*           TO FIELD-SYMBOL(<fs_vjstp>).
    ASSIGN gr_vjbkl->*           TO FIELD-SYMBOL(<fs_vjbkl>).
    ASSIGN gr_vjsav->*           TO FIELD-SYMBOL(<fs_vjsav>).
    ASSIGN gr_stprv->*           TO FIELD-SYMBOL(<fs_stprv>).
    ASSIGN gr_laepr->*           TO FIELD-SYMBOL(<fs_laepr>).
    ASSIGN gr_zkprs->*           TO FIELD-SYMBOL(<fs_zkprs>).
    ASSIGN gr_zkdat->*           TO FIELD-SYMBOL(<fs_zkdat>).
    ASSIGN gr_timestamp->*       TO FIELD-SYMBOL(<fs_timestamp>).
    ASSIGN gr_bwprs->*           TO FIELD-SYMBOL(<fs_bwprs>).
    ASSIGN gr_bwprh->*           TO FIELD-SYMBOL(<fs_bwprh>).
    ASSIGN gr_vjbws->*           TO FIELD-SYMBOL(<fs_vjbws>).
    ASSIGN gr_vjbwh->*           TO FIELD-SYMBOL(<fs_vjbwh>).
    ASSIGN gr_vvjsl->*           TO FIELD-SYMBOL(<fs_vvjsl>).
    ASSIGN gr_vvjlb->*           TO FIELD-SYMBOL(<fs_vvjlb>).
    ASSIGN gr_vvmlb->*           TO FIELD-SYMBOL(<fs_vvmlb>).
    ASSIGN gr_vvsal->*           TO FIELD-SYMBOL(<fs_vvsal>).
    ASSIGN gr_zplpr->*           TO FIELD-SYMBOL(<fs_zplpr>).
    ASSIGN gr_zplp1->*           TO FIELD-SYMBOL(<fs_zplp1>).
    ASSIGN gr_zplp2->*           TO FIELD-SYMBOL(<fs_zplp2>).
    ASSIGN gr_zplp3->*           TO FIELD-SYMBOL(<fs_zplp3>).
    ASSIGN gr_zpld1->*           TO FIELD-SYMBOL(<fs_zpld1>).
    ASSIGN gr_zpld2->*           TO FIELD-SYMBOL(<fs_zpld2>).
    ASSIGN gr_zpld3->*           TO FIELD-SYMBOL(<fs_zpld3>).
    ASSIGN gr_kalkz->*           TO FIELD-SYMBOL(<fs_kalkz>).
    ASSIGN gr_kalkl->*           TO FIELD-SYMBOL(<fs_kalkl>).
    ASSIGN gr_kalkv->*           TO FIELD-SYMBOL(<fs_kalkv>).
    ASSIGN gr_kalsc->*           TO FIELD-SYMBOL(<fs_kalsc>).
    ASSIGN gr_xlifo->*           TO FIELD-SYMBOL(<fs_xlifo>).
    ASSIGN gr_mypol->*           TO FIELD-SYMBOL(<fs_mypol>).
    ASSIGN gr_bwph1->*           TO FIELD-SYMBOL(<fs_bwph1>).
    ASSIGN gr_bwps1->*           TO FIELD-SYMBOL(<fs_bwps1>).
    ASSIGN gr_abwkz->*           TO FIELD-SYMBOL(<fs_abwkz>).
    ASSIGN gr_kaln1->*           TO FIELD-SYMBOL(<fs_kaln1>).
    ASSIGN gr_kalnr->*           TO FIELD-SYMBOL(<fs_kalnr>).
    ASSIGN gr_bwva1->*           TO FIELD-SYMBOL(<fs_bwva1>).
    ASSIGN gr_bwva2->*           TO FIELD-SYMBOL(<fs_bwva2>).
    ASSIGN gr_bwva3->*           TO FIELD-SYMBOL(<fs_bwva3>).
    ASSIGN gr_vers1->*           TO FIELD-SYMBOL(<fs_vers1>).
    ASSIGN gr_vers2->*           TO FIELD-SYMBOL(<fs_vers2>).
    ASSIGN gr_vers3->*           TO FIELD-SYMBOL(<fs_vers3>).
    ASSIGN gr_hrkft->*           TO FIELD-SYMBOL(<fs_hrkft>).
    ASSIGN gr_kosgr->*           TO FIELD-SYMBOL(<fs_kosgr>).
    ASSIGN gr_pprdz->*           TO FIELD-SYMBOL(<fs_pprdz>).
    ASSIGN gr_pprdl->*           TO FIELD-SYMBOL(<fs_pprdl>).
    ASSIGN gr_pprdv->*           TO FIELD-SYMBOL(<fs_pprdv>).
    ASSIGN gr_pdatz->*           TO FIELD-SYMBOL(<fs_pdatz>).
    ASSIGN gr_pdatl->*           TO FIELD-SYMBOL(<fs_pdatl>).
    ASSIGN gr_pdatv->*           TO FIELD-SYMBOL(<fs_pdatv>).
    ASSIGN gr_ekalr->*           TO FIELD-SYMBOL(<fs_ekalr>).
    ASSIGN gr_vplpr->*           TO FIELD-SYMBOL(<fs_vplpr>).
    ASSIGN gr_mlmaa->*           TO FIELD-SYMBOL(<fs_mlmaa>).
    ASSIGN gr_mlast->*           TO FIELD-SYMBOL(<fs_mlast>).
    ASSIGN gr_lplpr->*           TO FIELD-SYMBOL(<fs_lplpr>).
    ASSIGN gr_vksal->*           TO FIELD-SYMBOL(<fs_vksal>).
    ASSIGN gr_hkmat->*           TO FIELD-SYMBOL(<fs_hkmat>).
    ASSIGN gr_sperw->*           TO FIELD-SYMBOL(<fs_sperw>).
    ASSIGN gr_kziwl->*           TO FIELD-SYMBOL(<fs_kziwl>).
    ASSIGN gr_wlinl->*           TO FIELD-SYMBOL(<fs_wlinl>).
    ASSIGN gr_abciw->*           TO FIELD-SYMBOL(<fs_abciw>).
    ASSIGN gr_bwspa->*           TO FIELD-SYMBOL(<fs_bwspa>).
    ASSIGN gr_lplpx->*           TO FIELD-SYMBOL(<fs_lplpx>).
    ASSIGN gr_vplpx->*           TO FIELD-SYMBOL(<fs_vplpx>).
    ASSIGN gr_fplpx->*           TO FIELD-SYMBOL(<fs_fplpx>).
    ASSIGN gr_lbwst->*           TO FIELD-SYMBOL(<fs_lbwst>).
    ASSIGN gr_vbwst->*           TO FIELD-SYMBOL(<fs_vbwst>).
    ASSIGN gr_fbwst->*           TO FIELD-SYMBOL(<fs_fbwst>).
    ASSIGN gr_eklas->*           TO FIELD-SYMBOL(<fs_eklas>).
    ASSIGN gr_qklas->*           TO FIELD-SYMBOL(<fs_qklas>).
    ASSIGN gr_mtuse->*           TO FIELD-SYMBOL(<fs_mtuse>).
    ASSIGN gr_mtorg->*           TO FIELD-SYMBOL(<fs_mtorg>).
    ASSIGN gr_ownpr->*           TO FIELD-SYMBOL(<fs_ownpr>).
    ASSIGN gr_xbewm->*           TO FIELD-SYMBOL(<fs_xbewm>).
    ASSIGN gr_bwpei->*           TO FIELD-SYMBOL(<fs_bwpei>).
    ASSIGN gr_mbrue->*           TO FIELD-SYMBOL(<fs_mbrue>).
    ASSIGN gr_oklas->*           TO FIELD-SYMBOL(<fs_oklas>).
    ASSIGN gr_oippinv->*         TO FIELD-SYMBOL(<fs_oippinv>).
    ASSIGN gr_versg->*           TO FIELD-SYMBOL(<fs_versg>).
    ASSIGN gr_bonus->*           TO FIELD-SYMBOL(<fs_bonus>).
    ASSIGN gr_provg->*           TO FIELD-SYMBOL(<fs_provg>).
    ASSIGN gr_sktof->*           TO FIELD-SYMBOL(<fs_sktof>).
    ASSIGN gr_vmstd->*           TO FIELD-SYMBOL(<fs_vmstd>).
    ASSIGN gr_aumng->*           TO FIELD-SYMBOL(<fs_aumng>).
    ASSIGN gr_lfmng->*           TO FIELD-SYMBOL(<fs_lfmng>).
    ASSIGN gr_efmng->*           TO FIELD-SYMBOL(<fs_efmng>).
    ASSIGN gr_scmng->*           TO FIELD-SYMBOL(<fs_scmng>).
    ASSIGN gr_schme->*           TO FIELD-SYMBOL(<fs_schme>).
    ASSIGN gr_vrkme->*           TO FIELD-SYMBOL(<fs_vrkme>).
    ASSIGN gr_mtpos->*           TO FIELD-SYMBOL(<fs_mtpos>).
    ASSIGN gr_dwerk->*           TO FIELD-SYMBOL(<fs_dwerk>).
    ASSIGN gr_prodh->*           TO FIELD-SYMBOL(<fs_prodh>).
    ASSIGN gr_pmatn->*           TO FIELD-SYMBOL(<fs_pmatn>).
    ASSIGN gr_kondm->*           TO FIELD-SYMBOL(<fs_kondm>).
    ASSIGN gr_ktgrm->*           TO FIELD-SYMBOL(<fs_ktgrm>).
    ASSIGN gr_mvgr1->*           TO FIELD-SYMBOL(<fs_mvgr1>).
    ASSIGN gr_prat1->*           TO FIELD-SYMBOL(<fs_prat1>).
    ASSIGN gr_lfmax->*           TO FIELD-SYMBOL(<fs_lfmax>).
    ASSIGN gr_pvmso->*           TO FIELD-SYMBOL(<fs_pvmso>).
    ASSIGN gr_/bev1/emdrckspl->* TO FIELD-SYMBOL(<fs_bev1>).

    gs_param-matnr           = <fs_matnr>.
    gs_param-werks           = <fs_werks>.
    gs_param-bwtar           = <fs_bwtar>.
    gs_param-idrfb           = <fs_idrfb>.
    gs_param-vtweg           = <fs_vtweg>.
    gs_param-vkorg           = <fs_vkorg>.
    gs_param-mtart           = <fs_mtart>.
    gs_param-ersda           = <fs_ersda>.
    gs_param-ernam           = <fs_ernam>.
    gs_param-laeda           = <fs_laeda>.
    gs_param-aenam           = <fs_aenam>.
    gs_param-mstae           = <fs_mstae>.
    gs_param-mmsta           = <fs_mmsta>.
    gs_param-vmsta           = <fs_vmsta>.
    gs_param-vpsta           = <fs_vpsta>.
    gs_param-mstav           = <fs_mstav>.
    gs_param-lvorm           = <fs_lvorm>.
    gs_param-pstat           = <fs_pstat>.
    gs_param-mbrsh           = <fs_mbrsh>.
    gs_param-matkl           = <fs_matkl>.
    gs_param-bismt           = <fs_bismt>.
    gs_param-meins           = <fs_meins>.
    gs_param-blanz           = <fs_blanz>.
    gs_param-groes           = <fs_groes>.
    gs_param-wrkst           = <fs_wrkst>.
    gs_param-normt           = <fs_normt>.
    gs_param-brgew           = <fs_brgew>.
    gs_param-ntgew           = <fs_ntgew>.
    gs_param-gewei           = <fs_gewei>.
    gs_param-volum           = <fs_volum>.
    gs_param-raube           = <fs_raube>.
    gs_param-tragr           = <fs_tragr>.
    gs_param-spart           = <fs_spart>.
    gs_param-kunnr           = <fs_kunnr>.
    gs_param-eannr           = <fs_eannr>.
    gs_param-wesch           = <fs_wesch>.
    gs_param-bwvor           = <fs_bwvor>.
    gs_param-bwscl           = <fs_bwscl>.
    gs_param-saiso           = <fs_saiso>.
    gs_param-etiar           = <fs_etiar>.
    gs_param-etifo           = <fs_etifo>.
    gs_param-entar           = <fs_entar>.
    gs_param-ean11           = <fs_ean11>.
    gs_param-numtp           = <fs_numtp>.
    gs_param-laeng           = <fs_laeng>.
    gs_param-breit           = <fs_breit>.
    gs_param-hoehe           = <fs_hoehe>.
    gs_param-meabm           = <fs_meabm>.
    gs_param-prdha           = <fs_prdha>.
    gs_param-aeklk           = <fs_aeklk>.
    gs_param-cadkz           = <fs_cadkz>.
    gs_param-qmpur           = <fs_qmpur>.
    gs_param-ergew           = <fs_ergew>.
    gs_param-ergei           = <fs_ergei>.
    gs_param-ervol           = <fs_ervol>.
    gs_param-ervoe           = <fs_ervoe>.
    gs_param-gewto           = <fs_gewto>.
    gs_param-volto           = <fs_volto>.
    gs_param-vabme           = <fs_vabme>.
    gs_param-kzrev           = <fs_kzrev>.
    gs_param-kzkfg           = <fs_kzkfg>.
    gs_param-xchpf           = <fs_xchpf>.
    gs_param-vhart           = <fs_vhart>.
    gs_param-fuelg           = <fs_fuelg>.
    gs_param-stfak           = <fs_stfak>.
    gs_param-magrv           = <fs_magrv>.
    gs_param-begru           = <fs_begru>.
    gs_param-datab           = <fs_datab>.
    gs_param-liqdt           = <fs_liqdt>.
    gs_param-saisj           = <fs_saisj>.
    gs_param-plgtp           = <fs_plgtp>.
    gs_param-mlgut           = <fs_mlgut>.
    gs_param-extwg           = <fs_extwg>.
    gs_param-satnr           = <fs_satnr>.
    gs_param-attyp           = <fs_attyp>.
    gs_param-kzkup           = <fs_kzkup>.
    gs_param-kznfm           = <fs_kznfm>.
    gs_param-pmata           = <fs_pmata>.
    gs_param-mstde           = <fs_mstde>.
    gs_param-mstdv           = <fs_mstdv>.
    gs_param-taklv           = <fs_taklv>.
    gs_param-rbnrm           = <fs_rbnrm>.
    gs_param-mhdrz           = <fs_mhdrz>.
    gs_param-mhdhb           = <fs_mhdhb>.
    gs_param-mhdlp           = <fs_mhdlp>.
    gs_param-inhme           = <fs_inhme>.
    gs_param-inhal           = <fs_inhal>.
    gs_param-vpreh           = <fs_vpreh>.
    gs_param-etiag           = <fs_etiag>.
    gs_param-mtpos_mara      = <fs_mtpos_mara>.
    gs_param-bwtty           = <fs_bwtty>.
    gs_param-xchar           = <fs_xchar>.
    gs_param-mmstd           = <fs_mmstd>.
    gs_param-maabc           = <fs_maabc>.
    gs_param-kzkri           = <fs_kzkri>.
    gs_param-ekgrp           = <fs_ekgrp>.
    gs_param-ausme           = <fs_ausme>.
    gs_param-dispr           = <fs_dispr>.
    gs_param-dismm           = <fs_dismm>.
    gs_param-dispo           = <fs_dispo>.
    gs_param-kzdie           = <fs_kzdie>.
    gs_param-plifz           = <fs_plifz>.
    gs_param-webaz           = <fs_webaz>.
    gs_param-perkz           = <fs_perkz>.
    gs_param-ausss           = <fs_ausss>.
    gs_param-disls           = <fs_disls>.
    gs_param-beskz           = <fs_beskz>.
    gs_param-sobsl           = <fs_sobsl>.
    gs_param-minbe           = <fs_minbe>.
    gs_param-eisbe           = <fs_eisbe>.
    gs_param-bstmi           = <fs_bstmi>.
    gs_param-bstma           = <fs_bstma>.
    gs_param-bstfe           = <fs_bstfe>.
    gs_param-bstrf           = <fs_bstrf>.
    gs_param-mabst           = <fs_mabst>.
    gs_param-losfx           = <fs_losfx>.
    gs_param-sbdkz           = <fs_sbdkz>.
    gs_param-bearz           = <fs_bearz>.
    gs_param-ruezt           = <fs_ruezt>.
    gs_param-tranz           = <fs_tranz>.
    gs_param-basmg           = <fs_basmg>.
    gs_param-dzeit           = <fs_dzeit>.
    gs_param-maxlz           = <fs_maxlz>.
    gs_param-lzeih           = <fs_lzeih>.
    gs_param-kzpro           = <fs_kzpro>.
    gs_param-gpmkz           = <fs_gpmkz>.
    gs_param-ueeto           = <fs_ueeto>.
    gs_param-ueetk           = <fs_ueetk>.
    gs_param-uneto           = <fs_uneto>.
    gs_param-wzeit           = <fs_wzeit>.
    gs_param-atpkz           = <fs_atpkz>.
    gs_param-vzusl           = <fs_vzusl>.
    gs_param-herbl           = <fs_herbl>.
    gs_param-insmk           = <fs_insmk>.
    gs_param-sproz           = <fs_sproz>.
    gs_param-quazt           = <fs_quazt>.
    gs_param-ssqss           = <fs_ssqss>.
    gs_param-mpdau           = <fs_mpdau>.
    gs_param-kzppv           = <fs_kzppv>.
    gs_param-kzdkz           = <fs_kzdkz>.
    gs_param-wstgh           = <fs_wstgh>.
    gs_param-prfrq           = <fs_prfrq>.
    gs_param-nkmpr           = <fs_nkmpr>.
    gs_param-umlmc           = <fs_umlmc>.
    gs_param-ladgr           = <fs_ladgr>.
    gs_param-usequ           = <fs_usequ>.
    gs_param-lgrad           = <fs_lgrad>.
    gs_param-auftl           = <fs_auftl>.
    gs_param-plvar           = <fs_plvar>.
    gs_param-otype           = <fs_otype>.
    gs_param-objid           = <fs_objid>.
    gs_param-mtvfp           = <fs_mtvfp>.
    gs_param-vrvez           = <fs_vrvez>.
    gs_param-vbamg           = <fs_vbamg>.
    gs_param-vbeaz           = <fs_vbeaz>.
    gs_param-lizyk           = <fs_lizyk>.
    gs_param-prctr           = <fs_prctr>.
    gs_param-trame           = <fs_trame>.
    gs_param-mrppp           = <fs_mrppp>.
    gs_param-sauft           = <fs_sauft>.
    gs_param-fxhor           = <fs_fxhor>.
    gs_param-vrmod           = <fs_vrmod>.
    gs_param-vint1           = <fs_vint1>.
    gs_param-vint2           = <fs_vint2>.
    gs_param-losgr           = <fs_losgr>.
    gs_param-sobsk           = <fs_sobsk>.
    gs_param-kausf           = <fs_kausf>.
    gs_param-qzgtp           = <fs_qzgtp>.
    gs_param-qmatv           = <fs_qmatv>.
    gs_param-takzt           = <fs_takzt>.
    gs_param-rwpro           = <fs_rwpro>.
    gs_param-copam           = <fs_copam>.
    gs_param-abcin           = <fs_abcin>.
    gs_param-awsls           = <fs_awsls>.
    gs_param-sernp           = <fs_sernp>.
    gs_param-cuobj           = <fs_cuobj>.
    gs_param-vrbfk           = <fs_vrbfk>.
    gs_param-cuobv           = <fs_cuobv>.
    gs_param-resvp           = <fs_resvp>.
    gs_param-plnty           = <fs_plnty>.
    gs_param-abfac           = <fs_abfac>.
    gs_param-sfcpf           = <fs_sfcpf>.
    gs_param-shflg           = <fs_shflg>.
    gs_param-shzet           = <fs_shzet>.
    gs_param-vkumc           = <fs_vkumc>.
    gs_param-vktrw           = <fs_vktrw>.
    gs_param-kzagl           = <fs_kzagl>.
    gs_param-glgmg           = <fs_glgmg>.
    gs_param-vkglg           = <fs_vkglg>.
    gs_param-indus           = <fs_indus>.
    gs_param-steuc           = <fs_steuc>.
    gs_param-dplho           = <fs_dplho>.
    gs_param-minls           = <fs_minls>.
    gs_param-maxls           = <fs_maxls>.
    gs_param-fixls           = <fs_fixls>.
    gs_param-ltinc           = <fs_ltinc>.
    gs_param-compl           = <fs_compl>.
    gs_param-mcrue           = <fs_mcrue>.
    gs_param-lfmon           = <fs_lfmon>.
    gs_param-lfgja           = <fs_lfgja>.
    gs_param-eislo           = <fs_eislo>.
    gs_param-ncost           = <fs_ncost>.
    gs_param-bwesb           = <fs_bwesb>.
    gs_param-gi_pr_time      = <fs_gi_pr_time>.
    gs_param-min_troc        = <fs_min_troc>.
    gs_param-max_troc        = <fs_max_troc>.
    gs_param-target_stock    = <fs_target_stock>.
    gs_param-bwkey           = <fs_bwkey>.
    gs_param-lbkum           = <fs_lbkum>.
    gs_param-salk3           = <fs_salk3>.
    gs_param-vprsv           = <fs_vprsv>.
    gs_param-verpr           = <fs_verpr>.
    gs_param-stprs           = <fs_stprs>.
    gs_param-peinh           = <fs_peinh>.
    gs_param-bklas           = <fs_bklas>.
    gs_param-salkv           = <fs_salkv>.
    gs_param-vmkum           = <fs_vmkum>.
    gs_param-vmsal           = <fs_vmsal>.
    gs_param-vmvpr           = <fs_vmvpr>.
    gs_param-vmver           = <fs_vmver>.
    gs_param-vmstp           = <fs_vmstp>.
    gs_param-vmpei           = <fs_vmpei>.
    gs_param-vmbkl           = <fs_vmbkl>.
    gs_param-vmsav           = <fs_vmsav>.
    gs_param-vjkum           = <fs_vjkum>.
    gs_param-vjsal           = <fs_vjsal>.
    gs_param-vjvpr           = <fs_vjvpr>.
    gs_param-vjver           = <fs_vjver>.
    gs_param-vjstp           = <fs_vjstp>.
    gs_param-vjbkl           = <fs_vjbkl>.
    gs_param-vjsav           = <fs_vjsav>.
    gs_param-stprv           = <fs_stprv>.
    gs_param-laepr           = <fs_laepr>.
    gs_param-zkprs           = <fs_zkprs>.
    gs_param-zkdat           = <fs_zkdat>.
    gs_param-timestamp       = <fs_timestamp>.
    gs_param-bwprs           = <fs_bwprs>.
    gs_param-bwprh           = <fs_bwprh>.
    gs_param-vjbws           = <fs_vjbws>.
    gs_param-vjbwh           = <fs_vjbwh>.
    gs_param-vvjsl           = <fs_vvjsl>.
    gs_param-vvjlb           = <fs_vvjlb>.
    gs_param-vvmlb           = <fs_vvmlb>.
    gs_param-vvsal           = <fs_vvsal>.
    gs_param-zplpr           = <fs_zplpr>.
    gs_param-zplp1           = <fs_zplp1>.
    gs_param-zplp2           = <fs_zplp2>.
    gs_param-zplp3           = <fs_zplp3>.
    gs_param-zpld1           = <fs_zpld1>.
    gs_param-zpld2           = <fs_zpld2>.
    gs_param-zpld3           = <fs_zpld3>.
    gs_param-kalkz           = <fs_kalkz>.
    gs_param-kalkl           = <fs_kalkl>.
    gs_param-kalkv           = <fs_kalkv>.
    gs_param-kalsc           = <fs_kalsc>.
    gs_param-xlifo           = <fs_xlifo>.
    gs_param-mypol           = <fs_mypol>.
    gs_param-bwph1           = <fs_bwph1>.
    gs_param-bwps1           = <fs_bwps1>.
    gs_param-abwkz           = <fs_abwkz>.
    gs_param-kaln1           = <fs_kaln1>.
    gs_param-kalnr           = <fs_kalnr>.
    gs_param-bwva1           = <fs_bwva1>.
    gs_param-bwva2           = <fs_bwva2>.
    gs_param-bwva3           = <fs_bwva3>.
    gs_param-vers1           = <fs_vers1>.
    gs_param-vers2           = <fs_vers2>.
    gs_param-vers3           = <fs_vers3>.
    gs_param-hrkft           = <fs_hrkft>.
    gs_param-kosgr           = <fs_kosgr>.
    gs_param-pprdz           = <fs_pprdz>.
    gs_param-pprdl           = <fs_pprdl>.
    gs_param-pprdv           = <fs_pprdv>.
    gs_param-pdatz           = <fs_pdatz>.
    gs_param-pdatl           = <fs_pdatl>.
    gs_param-pdatv           = <fs_pdatv>.
    gs_param-ekalr           = <fs_ekalr>.
    gs_param-vplpr           = <fs_vplpr>.
    gs_param-mlmaa           = <fs_mlmaa>.
    gs_param-mlast           = <fs_mlast>.
    gs_param-lplpr           = <fs_lplpr>.
    gs_param-vksal           = <fs_vksal>.
    gs_param-hkmat           = <fs_hkmat>.
    gs_param-sperw           = <fs_sperw>.
    gs_param-kziwl           = <fs_kziwl>.
    gs_param-wlinl           = <fs_wlinl>.
    gs_param-abciw           = <fs_abciw>.
    gs_param-bwspa           = <fs_bwspa>.
    gs_param-lplpx           = <fs_lplpx>.
    gs_param-vplpx           = <fs_vplpx>.
    gs_param-fplpx           = <fs_fplpx>.
    gs_param-lbwst           = <fs_lbwst>.
    gs_param-vbwst           = <fs_vbwst>.
    gs_param-fbwst           = <fs_fbwst>.
    gs_param-eklas           = <fs_eklas>.
    gs_param-qklas           = <fs_qklas>.
    gs_param-mtuse           = <fs_mtuse>.
    gs_param-mtorg           = <fs_mtorg>.
    gs_param-ownpr           = <fs_ownpr>.
    gs_param-xbewm           = <fs_xbewm>.
    gs_param-bwpei           = <fs_bwpei>.
    gs_param-mbrue           = <fs_mbrue>.
    gs_param-oklas           = <fs_oklas>.
    gs_param-oippinv         = <fs_oippinv>.
    gs_param-versg           = <fs_versg>.
    gs_param-bonus           = <fs_bonus>.
    gs_param-provg           = <fs_provg>.
    gs_param-sktof           = <fs_sktof>.
    gs_param-vmstd           = <fs_vmstd>.
    gs_param-aumng           = <fs_aumng>.
    gs_param-lfmng           = <fs_lfmng>.
    gs_param-efmng           = <fs_efmng>.
    gs_param-scmng           = <fs_scmng>.
    gs_param-schme           = <fs_schme>.
    gs_param-vrkme           = <fs_vrkme>.
    gs_param-mtpos           = <fs_mtpos>.
    gs_param-dwerk           = <fs_dwerk>.
    gs_param-prodh           = <fs_prodh>.
    gs_param-pmatn           = <fs_pmatn>.
    gs_param-kondm           = <fs_kondm>.
    gs_param-ktgrm           = <fs_ktgrm>.
    gs_param-mvgr1           = <fs_mvgr1>.
    gs_param-prat1           = <fs_prat1>.
    gs_param-lfmax           = <fs_lfmax>.
    gs_param-pvmso           = <fs_pvmso>.
    gs_param-bev1            = <fs_bev1>.

    UNASSIGN <fs_matnr>.
    UNASSIGN <fs_werks>.
    UNASSIGN <fs_bwtar>.
    UNASSIGN <fs_idrfb>.
    UNASSIGN <fs_vtweg>.
    UNASSIGN <fs_vkorg>.
    UNASSIGN <fs_mtart>.
    UNASSIGN <fs_ersda>.
    UNASSIGN <fs_ernam>.
    UNASSIGN <fs_laeda>.
    UNASSIGN <fs_aenam>.
    UNASSIGN <fs_mstae>.
    UNASSIGN <fs_mmsta>.
    UNASSIGN <fs_vmsta>.
    UNASSIGN <fs_vpsta>.
    UNASSIGN <fs_mstav>.
    UNASSIGN <fs_lvorm>.
    UNASSIGN <fs_pstat>.
    UNASSIGN <fs_mbrsh>.
    UNASSIGN <fs_matkl>.
    UNASSIGN <fs_bismt>.
    UNASSIGN <fs_meins>.
    UNASSIGN <fs_blanz>.
    UNASSIGN <fs_groes>.
    UNASSIGN <fs_wrkst>.
    UNASSIGN <fs_normt>.
    UNASSIGN <fs_brgew>.
    UNASSIGN <fs_ntgew>.
    UNASSIGN <fs_gewei>.
    UNASSIGN <fs_volum>.
    UNASSIGN <fs_raube>.
    UNASSIGN <fs_tragr>.
    UNASSIGN <fs_spart>.
    UNASSIGN <fs_kunnr>.
    UNASSIGN <fs_eannr>.
    UNASSIGN <fs_wesch>.
    UNASSIGN <fs_bwvor>.
    UNASSIGN <fs_bwscl>.
    UNASSIGN <fs_saiso>.
    UNASSIGN <fs_etiar>.
    UNASSIGN <fs_etifo>.
    UNASSIGN <fs_entar>.
    UNASSIGN <fs_ean11>.
    UNASSIGN <fs_numtp>.
    UNASSIGN <fs_laeng>.
    UNASSIGN <fs_breit>.
    UNASSIGN <fs_hoehe>.
    UNASSIGN <fs_meabm>.
    UNASSIGN <fs_prdha>.
    UNASSIGN <fs_aeklk>.
    UNASSIGN <fs_cadkz>.
    UNASSIGN <fs_qmpur>.
    UNASSIGN <fs_ergew>.
    UNASSIGN <fs_ergei>.
    UNASSIGN <fs_ervol>.
    UNASSIGN <fs_ervoe>.
    UNASSIGN <fs_gewto>.
    UNASSIGN <fs_volto>.
    UNASSIGN <fs_vabme>.
    UNASSIGN <fs_kzrev>.
    UNASSIGN <fs_kzkfg>.
    UNASSIGN <fs_xchpf>.
    UNASSIGN <fs_vhart>.
    UNASSIGN <fs_fuelg>.
    UNASSIGN <fs_stfak>.
    UNASSIGN <fs_magrv>.
    UNASSIGN <fs_begru>.
    UNASSIGN <fs_datab>.
    UNASSIGN <fs_liqdt>.
    UNASSIGN <fs_saisj>.
    UNASSIGN <fs_plgtp>.
    UNASSIGN <fs_mlgut>.
    UNASSIGN <fs_extwg>.
    UNASSIGN <fs_satnr>.
    UNASSIGN <fs_attyp>.
    UNASSIGN <fs_kzkup>.
    UNASSIGN <fs_kznfm>.
    UNASSIGN <fs_pmata>.
    UNASSIGN <fs_mstde>.
    UNASSIGN <fs_mstdv>.
    UNASSIGN <fs_taklv>.
    UNASSIGN <fs_rbnrm>.
    UNASSIGN <fs_mhdrz>.
    UNASSIGN <fs_mhdhb>.
    UNASSIGN <fs_mhdlp>.
    UNASSIGN <fs_inhme>.
    UNASSIGN <fs_inhal>.
    UNASSIGN <fs_vpreh>.
    UNASSIGN <fs_etiag>.
    UNASSIGN <fs_mtpos_mara>.
    UNASSIGN <fs_bwtty>.
    UNASSIGN <fs_xchar>.
    UNASSIGN <fs_mmstd>.
    UNASSIGN <fs_maabc>.
    UNASSIGN <fs_kzkri>.
    UNASSIGN <fs_ekgrp>.
    UNASSIGN <fs_ausme>.
    UNASSIGN <fs_dispr>.
    UNASSIGN <fs_dismm>.
    UNASSIGN <fs_dispo>.
    UNASSIGN <fs_kzdie>.
    UNASSIGN <fs_plifz>.
    UNASSIGN <fs_webaz>.
    UNASSIGN <fs_perkz>.
    UNASSIGN <fs_ausss>.
    UNASSIGN <fs_disls>.
    UNASSIGN <fs_beskz>.
    UNASSIGN <fs_sobsl>.
    UNASSIGN <fs_minbe>.
    UNASSIGN <fs_eisbe>.
    UNASSIGN <fs_bstmi>.
    UNASSIGN <fs_bstma>.
    UNASSIGN <fs_bstfe>.
    UNASSIGN <fs_bstrf>.
    UNASSIGN <fs_mabst>.
    UNASSIGN <fs_losfx>.
    UNASSIGN <fs_sbdkz>.
    UNASSIGN <fs_bearz>.
    UNASSIGN <fs_ruezt>.
    UNASSIGN <fs_tranz>.
    UNASSIGN <fs_basmg>.
    UNASSIGN <fs_dzeit>.
    UNASSIGN <fs_maxlz>.
    UNASSIGN <fs_lzeih>.
    UNASSIGN <fs_kzpro>.
    UNASSIGN <fs_gpmkz>.
    UNASSIGN <fs_ueeto>.
    UNASSIGN <fs_ueetk>.
    UNASSIGN <fs_uneto>.
    UNASSIGN <fs_wzeit>.
    UNASSIGN <fs_atpkz>.
    UNASSIGN <fs_vzusl>.
    UNASSIGN <fs_herbl>.
    UNASSIGN <fs_insmk>.
    UNASSIGN <fs_sproz>.
    UNASSIGN <fs_quazt>.
    UNASSIGN <fs_ssqss>.
    UNASSIGN <fs_mpdau>.
    UNASSIGN <fs_kzppv>.
    UNASSIGN <fs_kzdkz>.
    UNASSIGN <fs_wstgh>.
    UNASSIGN <fs_prfrq>.
    UNASSIGN <fs_nkmpr>.
    UNASSIGN <fs_umlmc>.
    UNASSIGN <fs_ladgr>.
    UNASSIGN <fs_usequ>.
    UNASSIGN <fs_lgrad>.
    UNASSIGN <fs_auftl>.
    UNASSIGN <fs_plvar>.
    UNASSIGN <fs_otype>.
    UNASSIGN <fs_objid>.
    UNASSIGN <fs_mtvfp>.
    UNASSIGN <fs_vrvez>.
    UNASSIGN <fs_vbamg>.
    UNASSIGN <fs_vbeaz>.
    UNASSIGN <fs_lizyk>.
    UNASSIGN <fs_prctr>.
    UNASSIGN <fs_trame>.
    UNASSIGN <fs_mrppp>.
    UNASSIGN <fs_sauft>.
    UNASSIGN <fs_fxhor>.
    UNASSIGN <fs_vrmod>.
    UNASSIGN <fs_vint1>.
    UNASSIGN <fs_vint2>.
    UNASSIGN <fs_losgr>.
    UNASSIGN <fs_sobsk>.
    UNASSIGN <fs_kausf>.
    UNASSIGN <fs_qzgtp>.
    UNASSIGN <fs_qmatv>.
    UNASSIGN <fs_takzt>.
    UNASSIGN <fs_rwpro>.
    UNASSIGN <fs_copam>.
    UNASSIGN <fs_abcin>.
    UNASSIGN <fs_awsls>.
    UNASSIGN <fs_sernp>.
    UNASSIGN <fs_cuobj>.
    UNASSIGN <fs_vrbfk>.
    UNASSIGN <fs_cuobv>.
    UNASSIGN <fs_resvp>.
    UNASSIGN <fs_plnty>.
    UNASSIGN <fs_abfac>.
    UNASSIGN <fs_sfcpf>.
    UNASSIGN <fs_shflg>.
    UNASSIGN <fs_shzet>.
    UNASSIGN <fs_vkumc>.
    UNASSIGN <fs_vktrw>.
    UNASSIGN <fs_kzagl>.
    UNASSIGN <fs_glgmg>.
    UNASSIGN <fs_vkglg>.
    UNASSIGN <fs_indus>.
    UNASSIGN <fs_steuc>.
    UNASSIGN <fs_dplho>.
    UNASSIGN <fs_minls>.
    UNASSIGN <fs_maxls>.
    UNASSIGN <fs_fixls>.
    UNASSIGN <fs_ltinc>.
    UNASSIGN <fs_compl>.
    UNASSIGN <fs_mcrue>.
    UNASSIGN <fs_lfmon>.
    UNASSIGN <fs_lfgja>.
    UNASSIGN <fs_eislo>.
    UNASSIGN <fs_ncost>.
    UNASSIGN <fs_bwesb>.
    UNASSIGN <fs_gi_pr_time>.
    UNASSIGN <fs_min_troc>.
    UNASSIGN <fs_max_troc>.
    UNASSIGN <fs_target_stock>.
    UNASSIGN <fs_bwkey>.
    UNASSIGN <fs_lbkum>.
    UNASSIGN <fs_salk3>.
    UNASSIGN <fs_vprsv>.
    UNASSIGN <fs_verpr>.
    UNASSIGN <fs_stprs>.
    UNASSIGN <fs_peinh>.
    UNASSIGN <fs_bklas>.
    UNASSIGN <fs_salkv>.
    UNASSIGN <fs_vmkum>.
    UNASSIGN <fs_vmsal>.
    UNASSIGN <fs_vmvpr>.
    UNASSIGN <fs_vmver>.
    UNASSIGN <fs_vmstp>.
    UNASSIGN <fs_vmpei>.
    UNASSIGN <fs_vmbkl>.
    UNASSIGN <fs_vmsav>.
    UNASSIGN <fs_vjkum>.
    UNASSIGN <fs_vjsal>.
    UNASSIGN <fs_vjvpr>.
    UNASSIGN <fs_vjver>.
    UNASSIGN <fs_vjstp>.
    UNASSIGN <fs_vjbkl>.
    UNASSIGN <fs_vjsav>.
    UNASSIGN <fs_stprv>.
    UNASSIGN <fs_laepr>.
    UNASSIGN <fs_zkprs>.
    UNASSIGN <fs_zkdat>.
    UNASSIGN <fs_timestamp>.
    UNASSIGN <fs_bwprs>.
    UNASSIGN <fs_bwprh>.
    UNASSIGN <fs_vjbws>.
    UNASSIGN <fs_vjbwh>.
    UNASSIGN <fs_vvjsl>.
    UNASSIGN <fs_vvjlb>.
    UNASSIGN <fs_vvmlb>.
    UNASSIGN <fs_vvsal>.
    UNASSIGN <fs_zplpr>.
    UNASSIGN <fs_zplp1>.
    UNASSIGN <fs_zplp2>.
    UNASSIGN <fs_zplp3>.
    UNASSIGN <fs_zpld1>.
    UNASSIGN <fs_zpld2>.
    UNASSIGN <fs_zpld3>.
    UNASSIGN <fs_kalkz>.
    UNASSIGN <fs_kalkl>.
    UNASSIGN <fs_kalkv>.
    UNASSIGN <fs_kalsc>.
    UNASSIGN <fs_xlifo>.
    UNASSIGN <fs_mypol>.
    UNASSIGN <fs_bwph1>.
    UNASSIGN <fs_bwps1>.
    UNASSIGN <fs_abwkz>.
    UNASSIGN <fs_kaln1>.
    UNASSIGN <fs_kalnr>.
    UNASSIGN <fs_bwva1>.
    UNASSIGN <fs_bwva2>.
    UNASSIGN <fs_bwva3>.
    UNASSIGN <fs_vers1>.
    UNASSIGN <fs_vers2>.
    UNASSIGN <fs_vers3>.
    UNASSIGN <fs_hrkft>.
    UNASSIGN <fs_kosgr>.
    UNASSIGN <fs_pprdz>.
    UNASSIGN <fs_pprdl>.
    UNASSIGN <fs_pprdv>.
    UNASSIGN <fs_pdatz>.
    UNASSIGN <fs_pdatl>.
    UNASSIGN <fs_pdatv>.
    UNASSIGN <fs_ekalr>.
    UNASSIGN <fs_vplpr>.
    UNASSIGN <fs_mlmaa>.
    UNASSIGN <fs_mlast>.
    UNASSIGN <fs_lplpr>.
    UNASSIGN <fs_vksal>.
    UNASSIGN <fs_hkmat>.
    UNASSIGN <fs_sperw>.
    UNASSIGN <fs_kziwl>.
    UNASSIGN <fs_wlinl>.
    UNASSIGN <fs_abciw>.
    UNASSIGN <fs_bwspa>.
    UNASSIGN <fs_lplpx>.
    UNASSIGN <fs_vplpx>.
    UNASSIGN <fs_fplpx>.
    UNASSIGN <fs_lbwst>.
    UNASSIGN <fs_vbwst>.
    UNASSIGN <fs_fbwst>.
    UNASSIGN <fs_eklas>.
    UNASSIGN <fs_qklas>.
    UNASSIGN <fs_mtuse>.
    UNASSIGN <fs_mtorg>.
    UNASSIGN <fs_ownpr>.
    UNASSIGN <fs_xbewm>.
    UNASSIGN <fs_bwpei>.
    UNASSIGN <fs_mbrue>.
    UNASSIGN <fs_oklas>.
    UNASSIGN <fs_oippinv>.
    UNASSIGN <fs_versg>.
    UNASSIGN <fs_bonus>.
    UNASSIGN <fs_provg>.
    UNASSIGN <fs_sktof>.
    UNASSIGN <fs_vmstd>.
    UNASSIGN <fs_aumng>.
    UNASSIGN <fs_lfmng>.
    UNASSIGN <fs_efmng>.
    UNASSIGN <fs_scmng>.
    UNASSIGN <fs_schme>.
    UNASSIGN <fs_vrkme>.
    UNASSIGN <fs_mtpos>.
    UNASSIGN <fs_dwerk>.
    UNASSIGN <fs_prodh>.
    UNASSIGN <fs_pmatn>.
    UNASSIGN <fs_kondm>.
    UNASSIGN <fs_ktgrm>.
    UNASSIGN <fs_mvgr1>.
    UNASSIGN <fs_prat1>.
    UNASSIGN <fs_lfmax>.
    UNASSIGN <fs_pvmso>.
    UNASSIGN <fs_bev1>.
  ENDMETHOD.
ENDCLASS.
