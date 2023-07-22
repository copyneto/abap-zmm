CLASS zclmm_shp_delivery_interc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_le_shp_delivery_proc .

    METHODS cond_st_entrada IMPORTING !is_intercompany TYPE ztsd_intercompan
                                      !it_xvbpa        TYPE shp_vbpavb_t OPTIONAL
                                      !is_lips         TYPE lips
                                      !is_likp         TYPE likp
                                      iv_dynamic       TYPE xfeld OPTIONAL
                            RETURNING VALUE(rv_result) TYPE xfeld.

    METHODS zsub_cst60 IMPORTING !is_intercompany TYPE ztsd_intercompan
                                 !is_lips         TYPE lips
                       RETURNING VALUE(rv_result) TYPE xfeld.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_SHP_DELIVERY_INTERC IMPLEMENTATION.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_item.

    CONSTANTS:
      lc_cond_st_entrada TYPE seocpdname VALUE 'COND_ST_ENTRADA',
      lc_zsub_cst60      TYPE seocpdname VALUE 'ZSUB_CST60'.

    TYPES:
      BEGIN OF ty_det_iva,
        werks_o TYPE werks_d,
        werks_d TYPE werks_d,
        dentro  TYPE ze_dentro_estado,
        fora    TYPE ze_fora_estado,
        mtart   TYPE mtart,
        matorg  TYPE j_1bmatorg,
        bst0    TYPE ze_cond_bst0,
        zsub    TYPE ze_zsub_cst60,
        mwskz   TYPE j_1btxsdc_,
      END OF ty_det_iva.

    DATA:
      ls_intercompany TYPE ztsd_intercompan,
      lt_det_iva      TYPE TABLE OF ty_det_iva,
      lv_has_bst0     TYPE xfeld,
      lv_has_zsub     TYPE xfeld.


    IF if_flag_new_item IS INITIAL.
      RETURN.
    ENDIF.

    IF cs_lips-vgbel IS INITIAL.
      RETURN.
    ENDIF.

    IF cs_likp-lfart NE 'ZNLC'.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM ztsd_intercompan
      FIELDS processo,
             tipooperacao,
             werks_origem,
             lgort_origem,
             werks_destino,
             remessa_origem,
             tpfrete,
             abrvw
      WHERE purchaseorder = @cs_lips-vgbel
      INTO CORRESPONDING FIELDS OF @ls_intercompany.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    cs_likp-lifex = COND #( WHEN ls_intercompany-tipooperacao EQ 'TRA7'
                            THEN ls_intercompany-remessa_origem
                            ELSE cs_likp-lifex ).

    cs_likp-inco1 = SWITCH #( ls_intercompany-tpfrete WHEN '001' THEN 'CIF'
                                                      WHEN '002' THEN 'FOB'
                                                      WHEN '003' THEN 'SFR' ).

    cs_lips-lgort = COND #( WHEN ls_intercompany-lgort_origem IS NOT INITIAL
                            THEN ls_intercompany-lgort_origem
                            ELSE cs_lips-lgort ).

    cs_lips-abrvw = ls_intercompany-abrvw.

    DATA(lv_tabname) = COND tabname16( WHEN ls_intercompany-tipooperacao = 'TRA4'
                                       THEN 'ZTMM_DET_IVA_TRC'
                                       ELSE 'ZTMM_DET_IVA_TRA' ).

    DATA(lr_werks_origem) = VALUE range_t_werks(
      ( sign = 'I' option = 'EQ' low = space )
      ( sign = 'I' option = 'EQ' low = ls_intercompany-werks_origem ) ).

    DATA(lr_werks_destino) = VALUE range_t_werks(
      ( sign = 'I' option = 'EQ' low = space )
      ( sign = 'I' option = 'EQ' low = ls_intercompany-werks_destino ) ).

    SELECT FROM (lv_tabname)
      FIELDS werks_o,
             werks_d,
             dentro,
             fora,
             mtart,
             matorg,
             bst0,
             zsub,
             mwskz
      WHERE werks_o IN @lr_werks_origem
        AND werks_d IN @lr_werks_destino
        AND mwskz   IS NOT INITIAL
      ORDER BY werks_o DESCENDING,
               werks_d DESCENDING,
               dentro  DESCENDING,
               fora    DESCENDING,
               mtart   DESCENDING,
               matorg  DESCENDING,
               bst0    DESCENDING,
               zsub    DESCENDING
      INTO CORRESPONDING FIELDS OF TABLE @lt_det_iva.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT SINGLE regio,
                  bwkey,
                  j_1bbranch AS branch
      FROM t001w
      INTO @DATA(ls_ship_from)
      WHERE werks EQ @ls_intercompany-werks_origem.

    SELECT SINGLE regio,
                  bwkey,
                  j_1bbranch AS branch
      FROM t001w
      INTO @DATA(ls_ship_to)
      WHERE werks EQ @ls_intercompany-werks_destino.

    SELECT SINGLE j_1bmatorg
      FROM ekpo
      INTO @DATA(lv_matorg)
      WHERE ebeln EQ @cs_lips-vgbel
        AND ebelp EQ @cs_lips-vgpos.

    LOOP AT lt_det_iva ASSIGNING FIELD-SYMBOL(<fs_det_iva>).

      IF <fs_det_iva>-dentro IS INITIAL
      OR <fs_det_iva>-fora   IS INITIAL.

        IF <fs_det_iva>-dentro IS NOT INITIAL.
          CHECK ls_ship_from-regio EQ ls_ship_to-regio.
        ENDIF.

        IF <fs_det_iva>-fora IS NOT INITIAL.
          CHECK ls_ship_from-regio NE ls_ship_to-regio.
        ENDIF.

      ENDIF.

      IF <fs_det_iva>-mtart IS NOT INITIAL.
        CHECK <fs_det_iva>-mtart EQ cs_lips-mtart.
      ENDIF.

      IF <fs_det_iva>-matorg IS NOT INITIAL.
        CHECK <fs_det_iva>-matorg EQ lv_matorg.
      ENDIF.

      IF <fs_det_iva>-bst0 IS NOT INITIAL.
        CALL METHOD (lc_cond_st_entrada)
          EXPORTING
            is_intercompany = ls_intercompany
            is_lips         = cs_lips
            is_likp         = cs_likp
            it_xvbpa        = it_xvbpa
          RECEIVING
            rv_result       = lv_has_bst0.

        CHECK <fs_det_iva>-bst0 EQ lv_has_bst0.
      ENDIF.

      IF <fs_det_iva>-zsub IS NOT INITIAL.
        CALL METHOD (lc_zsub_cst60)
          EXPORTING
            is_intercompany = ls_intercompany
            is_lips         = cs_lips
          RECEIVING
            rv_result       = lv_has_zsub.

        CHECK <fs_det_iva>-zsub EQ lv_has_zsub.
      ENDIF.

      cs_lips-j_1btxsdc = <fs_det_iva>-mwskz.
      EXIT.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_delivery_header.
*    IF sy-uname = 'CGARCIA' OR sy-uname = 'MSPEREIRA'.
      FIELD-SYMBOLS: <fs_trsta> TYPE likp-trsta.
      ASSIGN ('(SAPLV50S)VBKOK_WA-TRSTA') TO <fs_trsta>.
      CHECK sy-subrc = 0.
      IF ( <fs_trsta> = 'C' OR <fs_trsta> = 'B' ) AND ( cs_likp-lifsk <> '44' AND cs_likp-lifsk <> '45' ) AND cs_likp-vbeln IS NOT INITIAL.
      "IF ( cs_likp-trsta = 'C' OR cs_likp-trsta = 'B' ) AND ( cs_likp-lifsk <> '44' AND cs_likp-lifsk <> '45' ) AND cs_likp-vbeln IS NOT INITIAL.

        DATA:
          lv_remessa TYPE likp-vbeln,
          ls_indx    TYPE indx.
        CLEAR lv_remessa.
        IMPORT remessa = lv_remessa FROM DATABASE indx(zt) TO ls_indx CLIENT sy-mandt ID cs_likp-vbeln.
        IF sy-subrc = 0 AND lv_remessa IS NOT INITIAL.
          DELETE FROM DATABASE indx(zt) CLIENT sy-mandt ID cs_likp-vbeln.
          cs_likp-lifsk = COND #( WHEN cs_likp-lprio = '04' OR cs_likp-lprio = '06'
            THEN '45'
            ELSE '44'
          ).
        ENDIF.
      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_fcode_attributes.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~change_field_attributes.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~check_item_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~delivery_final_check.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~document_number_publish.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~fill_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~initialize_delivery.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~item_deletion.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~publish_delivery_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~read_delivery.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_before_output.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_and_publish_document.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_le_shp_delivery_proc~save_document_prepare.

    FIELD-SYMBOLS <fs_bloqueio> TYPE lifsk.
    ASSIGN ('(SAPLZFGSD_COCKPIT_FATURAMENTO)GV_BLOQUEIO') TO <fs_bloqueio>.
    IF <fs_bloqueio> IS ASSIGNED AND <fs_bloqueio> IS NOT INITIAL.
      LOOP AT ct_xlikp ASSIGNING FIELD-SYMBOL(<fs_xlikp>).
        <fs_xlikp>-lifsk = <fs_bloqueio>.
      ENDLOOP.
    ELSE.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD cond_st_entrada.

    CONSTANTS:
      lc_kappl_tx              TYPE t683-kappl VALUE 'TX',
      lc_ibrx                  TYPE knvi-tatyp VALUE 'IBRX',
      lc_bst0                  TYPE t685-kschl VALUE 'BST0',
      lc_condition_record_read TYPE rs38l_fnam VALUE 'CONDITION_RECORD_READ'.

    DATA:
      ls_t001w TYPE t001w,
      ls_tvak  TYPE tvak.

    FIELD-SYMBOLS:
      <fs_structure> TYPE any.


    DATA(ls_komk) = CORRESPONDING komk( is_likp
      MAPPING prsdt    = erdat
              vkorgau  = vkorg
              kunnr_tx = kunnr ).

    DATA(ls_komp) = CORRESPONDING komp( is_lips
      MAPPING taxps = posnr
              pmatn = matnr
              mglme = lfimg
              lagme = meins
              mgame = lfimg
              prdha = prodh ).

*   Selecionar campos do cliente relevantes para processo Zona Franca e área de livre comércio
    SELECT SINGLE kunnr,
                  land1,
                  regio,
                  brsch,
                  txjcd,
                  xicms,
                  xxipi,
                  xsubt,
                  suframa,
                  cnae,
                  crtn,
                  icmstaxpay,
                  indtyp,
                  tdt
      FROM kna1
      INTO @DATA(ls_kna1)
      WHERE kunnr = @is_likp-kunnr.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

*   Selecionar classificação fiscal do cliente
    SELECT SINGLE taxkd
      FROM knvi
      INTO @DATA(lv_taxkd)
      WHERE kunnr = @is_likp-kunnr
        AND aland = @ls_kna1-land1
        AND tatyp = @lc_ibrx.

*   Atribuir T001W
    ASSIGN ('(SAPFV50P)T001W') TO <fs_structure>.
    IF <fs_structure> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    ls_t001w = <fs_structure>.
    UNASSIGN <fs_structure>.

*   Atribuir TVAK
    ASSIGN ('(SAPFV50P)TVAK') TO <fs_structure>.
    IF <fs_structure> IS ASSIGNED.
      ls_tvak = <fs_structure>.
      UNASSIGN <fs_structure>.
    ENDIF.

*   Selecionar empresa
    SELECT SINGLE bukrs
      FROM j_1bbranch
      INTO @DATA(lv_bukrs)
      WHERE branch = @ls_t001w-j_1bbranch.

*   Buscar dados do centro do material
    SELECT SINGLE steuc
      FROM marc
      INTO @DATA(lv_steuc)
      WHERE matnr = @is_lips-matnr
        AND werks = @is_lips-werks.

*   Buscar dados da avaliação do material
    SELECT SINGLE bwkey,
                  mtuse,
                  mtorg
      FROM mbew
      INTO @DATA(ls_mbew)
      WHERE matnr = @is_lips-matnr
        AND bwkey = @ls_t001w-bwkey
        AND bwtar = @is_lips-bwtar.

*   Buscar dados da categoria de item
    SELECT SINGLE pstyv,
                  prsfd,
                  evrwr
      FROM tvap
      INTO @DATA(ls_tvap)
      WHERE pstyv = @is_lips-pstyv.

*   Determinar recebedor de mercadoria
    DATA(lt_xvbpa) = it_xvbpa.
    SORT lt_xvbpa BY parvw.
    READ TABLE lt_xvbpa INTO DATA(ls_vbpa)
      WITH KEY parvw = 'WE' BINARY SEARCH.

*   Montar estruturas de comunicação - Cabeçalho
    ls_komk-brsch      = ls_kna1-brsch.
    ls_komk-aland      = ls_t001w-land1.
    ls_komk-wkreg      = ls_t001w-regio.
    ls_komk-bukrs      = lv_bukrs.
    ls_komk-kunwe      = ls_vbpa-kunnr.
    ls_komk-land1_we   = ls_vbpa-land1.
    ls_komk-land1      = ls_kna1-land1.
    ls_komk-regio      = ls_kna1-regio.
    ls_komk-txjcd      = ls_kna1-txjcd.
    ls_komk-taxk1      = lv_taxkd.
    ls_komk-werks      = is_lips-werks.
    ls_komk-aland_werk = ls_t001w-land1.
    ls_komk-auart_sd   = ls_tvak-auart.
    ls_komk-xsubt      = ls_kna1-xsubt.
    ls_komk-cnae       = ls_kna1-cnae.
    ls_komk-crtn       = ls_kna1-crtn.
    ls_komk-icmstaxpay = ls_kna1-icmstaxpay.
    ls_komk-indtyp     = ls_kna1-indtyp.
    ls_komk-tdt        = ls_kna1-tdt.

*   Isenção de IPI
    IF NOT ls_kna1-xxipi IS INITIAL.
      ls_komk-taxk2 = abap_true.
    ENDIF.

*   Isenção de ICMS
    IF NOT ls_kna1-xicms IS INITIAL.
      ls_komk-taxk3 = abap_true.
    ENDIF.

*   Montar estruturas de comunicação - Itens
    ls_komp-prodh1     = is_lips-prodh(5).
    ls_komp-prodh2     = is_lips-prodh+5(5).
    ls_komp-prodh3     = is_lips-prodh+10(8).
    ls_komp-wkreg      = ls_t001w-regio.
    ls_komp-bwkey      = ls_mbew-bwkey.
    ls_komp-prsfd      = ls_tvap-prsfd.
    ls_komp-evrwr      = ls_tvap-evrwr.
    ls_komp-txreg_sf   = ls_t001w-regio.
    ls_komp-txreg_st   = ls_kna1-regio.
    ls_komp-mtuse      = ls_mbew-mtuse.
    ls_komp-mtorg      = ls_mbew-mtorg.
    ls_komp-loc_pr     = ls_t001w-txjcd.
    ls_komp-loc_se     = ls_kna1-txjcd.
    ls_komp-steuc      = lv_steuc.

    DATA(ls_vake) = VALUE vakekond( ).
    CALL FUNCTION lc_condition_record_read
      EXPORTING
        pi_kappl        = lc_kappl_tx  "Aplicação
        pi_kschl        = lc_bst0 "Tipo de Condição
        pi_i_komk       = ls_komk "Estrutura de comunicação - Cabeçalho
        pi_i_komp       = ls_komp "Estrutura de comunicação - Item
      IMPORTING
        pe_i_vake       = ls_vake "Estrura de registro de condições
      EXCEPTIONS
        no_record_found = 1
        OTHERS          = 2.
    IF  sy-subrc IS INITIAL
    AND ls_vake  IS NOT INITIAL.
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD zsub_cst60.

    SELECT COUNT( * ) FROM ztsd_material
      WHERE centro   EQ @is_intercompany-werks_origem
        AND material EQ @is_lips-matnr.
    IF sy-subrc EQ 0.
      rv_result = abap_true.
      RETURN.
    ENDIF.

    SELECT COUNT( * ) FROM ztsd_gp_mercador
      WHERE centro        EQ @is_intercompany-werks_origem
        AND grpmercadoria EQ @is_lips-matkl.
    IF sy-subrc EQ 0.
      rv_result = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
