*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

    TYPES:
      ty_tt_bapiret TYPE SORTED TABLE OF bapiret2 WITH NON-UNIQUE KEY type id number,

      BEGIN OF ty_retorno_bapi,
        delivery      TYPE vbeln_vl,
        created_items TYPE /syclo/sd_dlvitemcreated_tab,
        mensagens     TYPE ty_tt_bapiret,
      END OF ty_retorno_bapi,

*      ty_tt_retorno_bapi TYPE SORTED TABLE OF ty_retorno_bapi WITH NON-UNIQUE KEY delivery,

      BEGIN OF ty_retorno_out_delivery,
        purchase_order      TYPE ztmm_his_dep_fec-purchase_order,
        retorno_bapi        TYPE ty_retorno_bapi,
      END OF ty_retorno_out_delivery,
      ty_tt_retorno_out_delivery TYPE SORTED TABLE OF ty_retorno_out_delivery
      WITH NON-UNIQUE KEY purchase_order,

      BEGIN OF ty_eket,
        ebeln TYPE eket-ebeln,
        ebelp TYPE eket-ebelp,
        eindt TYPE eket-eindt,
      END OF ty_eket,
      ty_tt_eket TYPE SORTED TABLE OF ty_eket WITH NON-UNIQUE KEY ebeln ebelp,

      BEGIN OF ty_equi,
        equnr TYPE equi-equnr,
        matnr TYPE equi-matnr,
        werk  TYPE equi-werk,
        lager TYPE equi-lager,
        sernr TYPE equi-sernr,
      END OF ty_equi,

      ty_tt_equi TYPE SORTED TABLE OF ty_equi
      WITH NON-UNIQUE KEY equnr
      WITH NON-UNIQUE SORTED KEY sec_key COMPONENTS matnr werk lager,

      BEGIN OF ty_mara,
        matnr TYPE mara-matnr,
        mtart TYPE mara-mtart,
      END OF ty_mara,

      ty_tt_mara        TYPE SORTED TABLE OF ty_mara WITH NON-UNIQUE KEY matnr,

      ty_tt_serie       TYPE SORTED TABLE OF ztmm_his_dep_ser
      WITH NON-UNIQUE KEY client material plant storage_location batch plant_dest storage_location_dest guid serialno
      WITH NON-UNIQUE SORTED KEY sec_key COMPONENTS
      material
      plant
      storage_location
      guid
      process_step,

      ty_tt_his_dep_fec TYPE SORTED TABLE OF ztmm_his_dep_fec WITH
      NON-UNIQUE KEY client material plant storage_location batch plant_dest storage_location_dest guid,

      BEGIN OF ty_criar_out_delivery,
        purchase_order      TYPE ztmm_his_dep_fec-purchase_order,
        purchase_order_item TYPE ztmm_his_dep_fec-purchase_order_item,
        his_dep_fec         TYPE ty_tt_his_dep_fec,
        eket                TYPE ty_tt_eket,
        equi                TYPE ty_tt_equi,
        mara                TYPE ty_tt_mara,
        serie               TYPE ty_tt_serie,
      END OF ty_criar_out_delivery,
      ty_tt_criar_out_delivery TYPE SORTED TABLE OF ty_criar_out_delivery
      WITH NON-UNIQUE KEY purchase_order purchase_order_item.
