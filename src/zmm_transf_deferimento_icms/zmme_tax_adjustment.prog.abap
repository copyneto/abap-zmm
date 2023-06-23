***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Trativa da alíquota do ICMS                            *
*** AUTOR    : Gustavo Santos – META                                  *
*** FUNCIONAL: Luiz Lopes – META                                      *
*** DATA     : 19/10/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMME_TAX_ADJUSTMENT
*&---------------------------------------------------------------------*

  DATA: lt_vbrp  TYPE STANDARD TABLE OF vbrpvb,
        lt_xlips TYPE STANDARD TABLE OF lipsvb.

  DATA: ls_sadr          TYPE sadr,
        ls_item          LIKE LINE OF gbobj_item,
        ls_gbobj_header	 LIKE gbobj_header,
        ls_zregio_diferi TYPE ztmm_regio_difer,
        ls_vbrp          TYPE vbrp,
        ls_konv          TYPE konv,
        ls_lips          TYPE lips.

  DATA: lv_dif_trans(01) TYPE c,
        lv_low           TYPE tvarvc-low,
        lv_knumv         TYPE j_1binterf-nfobjn,
        lv_rate          TYPE j_1btxic1-rate,
        lv_validf        TYPE j_1btxic1-validfrom,
        lv_valida        TYPE boolean_flg. " Variável booleana (X = verdadeiro, espaço = falso)

  FIELD-SYMBOLS: <fs_item_tax> LIKE LINE OF gbobj_item_tax,
                 <fs_item>     LIKE LINE OF gbobj_item,
                 <fs_vbak>     TYPE vbak,
                 <fs_vbrp>     TYPE j_1ivbrp,
                 <fs_lips>     TYPE tab_lipsvb,
                 <fs_likp>     TYPE likp.

  CONSTANTS: lc_modulo      TYPE ze_param_modulo  VALUE 'MM',
             lc_parm_k1_atv TYPE ze_param_chave   VALUE 'XXX',
             lc_parm_k2_atv TYPE ze_param_chave   VALUE 'XXX',
             lc_parm_k3_atv TYPE ze_param_chave_3 VALUE 'ON_OFF',
             lc_parm_k1_uf  TYPE ze_param_chave   VALUE 'Origem PR',
             lc_parm_k2_uf  TYPE ze_param_chave   VALUE 'Destino PR',
             lc_parm_on     TYPE char2            VALUE 'ON',
             lc_vf01        TYPE sy-tcode         VALUE 'VF01',
             lc_vf04        TYPE sy-tcode         VALUE 'VF04',
             lc_vl02        TYPE sy-tcode         VALUE 'VL02',
             lc_cfop_1      TYPE char4            VALUE '5151',
             lc_cfop_2      TYPE char4            VALUE '5152',
             lc_cfop_3      TYPE char4            VALUE '5408',
             lc_cfop_4      TYPE char4            VALUE '5409',
             lc_dif_trans   TYPE char1            VALUE 'S',
             lc_typ_icm3    TYPE j_1btaxtyp       VALUE 'ICM3',
             lc_kondtyp     TYPE kscha            VALUE 'YICD'.

  CONCATENATE sy-datum+6(2)
              sy-datum+4(2)
              sy-datum(4) INTO lv_validf.

  SELECT SINGLE *
    FROM ztca_param_val
   WHERE modulo = @lc_modulo
     AND chave1 = @lc_parm_k1_atv
     AND chave2 = @lc_parm_k2_atv
     AND chave3 = @lc_parm_k3_atv
    INTO @DATA(ls_ativo).

  CHECK ls_ativo-low = lc_parm_on.

  CLEAR ls_ativo.

  SELECT SINGLE *
    FROM ztca_param_val
   WHERE modulo = @lc_modulo
     AND chave1 = @lc_parm_k1_uf
     AND chave2 = @lc_parm_k2_uf
     AND chave3 = @lc_parm_k3_atv
    INTO @ls_ativo.

  CHECK ls_ativo-low = lc_parm_on.

  CLEAR: lv_dif_trans.

  CHECK sy-tcode      EQ lc_vf01
     OR sy-tcode      EQ lc_vf04
     OR sy-tcode+0(4) EQ lc_vl02.

  IF  sy-tcode+0(4) = lc_vl02.
    IF obj_item-cfop+0(4) NE lc_cfop_1
   AND obj_item-cfop+0(4) NE lc_cfop_2
   AND obj_item-cfop+0(4) NE lc_cfop_3
   AND obj_item-cfop+0(4) NE lc_cfop_4.
      EXIT.
    ELSE.
      MOVE lc_dif_trans TO lv_dif_trans.
    ENDIF.
  ENDIF.

  CALL METHOD zclmm_msg_xml_danfe=>validar_icmsdif
    EXPORTING
      iv_branch        = gbobj_header-branch
      iv_bukrs         = gbobj_header-bukrs
      iv_regio         = gbobj_header-regio
      iv_date          = lv_validf
    IMPORTING
      es_sadr          = ls_sadr
      es_zregio_diferi = ls_zregio_diferi
      ev_rate          = lv_rate
    RECEIVING
      rv_return        = lv_valida.

  IF lv_valida EQ abap_true. " Variável booleana (X = verdadeiro, espaço = falso)

    ASSIGN ('(SAPLV60A)VBAK')    TO <fs_vbak>.
    ASSIGN ('(SAPLV60A)XVBRP[]') TO <fs_vbrp>.

    IF lv_dif_trans NE lc_dif_trans.

      IF <fs_vbak> IS ASSIGNED
     AND <fs_vbrp> IS ASSIGNED.

        lt_vbrp[] = <fs_vbrp>.

        IF lt_vbrp[] IS NOT INITIAL.

          SELECT knumv,
                 kposn,
                 kschl
            FROM konv
             FOR ALL ENTRIES IN @lt_vbrp
           WHERE knumv EQ @<fs_vbak>-knumv
             AND kposn EQ @lt_vbrp-aupos
             AND kschl EQ @lc_kondtyp
            INTO TABLE @DATA(lt_konv).

          IF sy-subrc IS INITIAL.
            SORT lt_konv BY knumv
                            kposn
                            kschl.
          ENDIF.
        ENDIF.
      ENDIF.

      LOOP AT gbobj_item_tax ASSIGNING <fs_item_tax> WHERE taxtyp EQ lc_typ_icm3
                                                       AND nfobjn EQ gbobj_item-nfobjn.

        READ TABLE <fs_vbrp> INTO ls_vbrp WITH KEY posnr = <fs_item_tax>-itmnum.
        IF sy-subrc = 0.

          READ TABLE lt_konv TRANSPORTING NO FIELDS
                                           WITH KEY knumv = <fs_vbak>-knumv
                                                    kposn = ls_vbrp-aupos
                                                    kschl = lc_kondtyp
                                                    BINARY SEARCH.
          CHECK sy-subrc EQ 0.
          <fs_item_tax>-rate = lv_rate.

        ENDIF.
      ENDLOOP.
    ENDIF.


    IF lv_dif_trans = lc_dif_trans.

      ASSIGN ('(SAPMV50A)LIKP')    TO <fs_likp>.
      ASSIGN ('(SAPMV50A)XLIPS[]') TO <fs_lips>.

      IF <fs_lips> IS ASSIGNED.

        lt_xlips = <fs_lips>.

        IF lt_xlips[] IS NOT INITIAL.

          SELECT knumv,
                 kposn,
                 kschl
            FROM konv
             FOR ALL ENTRIES IN @lt_xlips
           WHERE knumv EQ @<fs_likp>-knump
             AND kposn EQ @lt_xlips-posnr
             AND kschl EQ @lc_kondtyp
            INTO TABLE @lt_konv.

          IF sy-subrc IS INITIAL.
            SORT lt_konv BY knumv
                            kposn
                            kschl.
          ENDIF.
        ENDIF.
      ENDIF.

      LOOP AT gbobj_item_tax ASSIGNING <fs_item_tax> WHERE taxtyp EQ lc_typ_icm3
                                                       AND nfobjn EQ gbobj_item-nfobjn.

        READ TABLE gbobj_item ASSIGNING <fs_item> WITH KEY nfobjn = gbobj_item-nfobjn
                                                           itmnum = <fs_item_tax>-itmnum.
        IF sy-subrc = 0.

          LOOP AT <fs_lips> INTO ls_lips WHERE vgbel = <fs_item>-xped
                                           AND vgpos = <fs_item>-nitemped.

            READ TABLE lt_konv TRANSPORTING NO FIELDS
                                             WITH KEY knumv = <fs_likp>-knump
                                                      kposn = ls_lips-posnr
                                                      kschl = lc_kondtyp
                                                      BINARY SEARCH.

            CHECK sy-subrc EQ 0.
            <fs_item_tax>-rate = lv_rate.

          ENDLOOP.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
