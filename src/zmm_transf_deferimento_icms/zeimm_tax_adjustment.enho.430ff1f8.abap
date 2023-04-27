"Name: \FU:J_1B_NF_OBJECT_ADD\SE:END\EI
ENHANCEMENT 0 ZEIMM_TAX_ADJUSTMENT.

  DATA: Lv_dif_trans(01)  type c,
        lv_low           TYPE tvarvc-low,
        ls_sadr          TYPE sadr,
        ls_item          LIKE LINE OF gbobj_item,
        lv_knumv           TYPE j_1binterf-nfobjn,
        ls_gbobj_header	 LIKE gbobj_header,
        lv_rate          TYPE j_1btxic1-rate,
        lv_validf        TYPE j_1btxic1-validfrom,
        ls_zregio_diferi TYPE ZTMM_REGIO_DIFER,
        lv_valida        TYPE boolean_flg. "Variável booleana (X=verdadeiro, espaço=falso)

  CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum(4) INTO lv_validf.


  SELECT SINGLE *
    INTO @DATA(ls_ativo)
    FROM ZTCA_PARAM_VAL
    WHERE modulo = 'MM'
      AND CHAVE1 = 'XXX'
      AND CHAVE2 = 'XXX'
      AND CHAVE2 = 'ON_OFF'.

  CHECK ls_ativo-low = 'ON'.

  CLEAR ls_ativo.

  SELECT SINGLE *
    INTO ls_ativo
    FROM ZTCA_PARAM_VAL
    WHERE modulo = 'MM'
      AND CHAVE1 = 'XXX'
      AND CHAVE2 = 'XXX'
      AND CHAVE2 = 'ON_OFF'.

  CHECK ls_ativo-low = 'ON'.

  clear: Lv_dif_trans.

  CHECK sy-tcode EQ 'VF01'     OR
        sy-tcode EQ 'VF04'     or
        sy-tcode+0(4) = 'VL02' .

  if  sy-tcode+0(4) = 'VL02'.
      if obj_item-CFOP+0(4) ne '5151' and
         obj_item-CFOP+0(4) ne '5152' and
         obj_item-CFOP+0(4) ne '5408' and
         obj_item-CFOP+0(4) ne '5409'.
         exit.
      else.
         move 'S'   to Lv_dif_trans.
      endif.
 endif.

  CALL METHOD zclmm_msg_xml_danfe=>validar_icmsdif
    EXPORTING
      iv_branch         = gbobj_header-branch
      iv_bukrs          = gbobj_header-bukrs
      iv_regio          = gbobj_header-regio
      iv_date           = lv_validf
    IMPORTING
      es_sadr          = ls_sadr
      es_zregio_diferi = ls_zregio_diferi
      ev_rate          = lv_rate
      RECEIVING
      rv_return         = lv_valida.

  IF lv_valida EQ 'X'. "Variável booleana (X=verdadeiro, espaço=falso)

    FIELD-SYMBOLS: <fs_item_tax>  LIKE LINE OF GBOBJ_ITEM_TAX,
                   <lt_komv>      TYPE komv_t,
                   <ls_komv>      TYPE komv,
                   <fs_item>      like line of GBOBJ_ITEM.

    FIELD-SYMBOLS: <fs_vbak> TYPE vbak,
                   <fs_vbrp> TYPE j_1ivbrp,
                   <fs_lips> type TAB_LIPSVB,
                   <fs_likp> type likp.

    DATA: ls_vbrp TYPE vbrp,
          ls_konv TYPE konv,
          ls_lips type lips.


    ASSIGN ('(SAPLV60A)VBAK') TO <fs_vbak>.
    ASSIGN ('(SAPLV60A)XVBRP[]') TO <fs_vbrp>.


    if Lv_dif_trans ne 'S'.
       LOOP AT gbobj_item_tax ASSIGNING <fs_item_tax>
                     WHERE taxtyp EQ 'ICM3' AND nfobjn = gbobj_item-nfobjn.

           READ TABLE <fs_vbrp> INTO ls_vbrp WITH KEY posnr = <fs_item_tax>-itmnum.
           IF sy-subrc = 0.
              SELECT SINGLE * FROM konv  INTO ls_konv
                  WHERE knumv EQ <fs_vbak>-knumv AND
                        kposn EQ ls_vbrp-aupos   AND
                         kschl EQ 'YICD'.
               CHECK sy-subrc EQ 0.
               <fs_item_tax>-rate = lv_rate.
           ENDIF.
        ENDLOOP.
    ENDIF.


    if Lv_dif_trans = 'S'.
       ASSIGN ('(SAPMV50A)LIKP') TO <fs_likp>.
       ASSIGN ('(SAPMV50A)XLIPS[]') TO <fs_lips>.
       LOOP AT gbobj_item_tax ASSIGNING <fs_item_tax>
                     WHERE taxtyp EQ 'ICM3' AND nfobjn = gbobj_item-nfobjn.

           read table gbobj_item ASSIGNING <fs_item> with key nfobjn = gbobj_item-nfobjn
                                                              itmnum = <fs_item_tax>-itmnum.
           if sy-subrc = 0.

*             IF gbobj_item-taxsit EQ 'B'.
*               <fs_item_tax>-rate = lv_rate.
*             ENDIF.

              loop at <fs_lips> INTO ls_lips where vgbel = <fs_item>-xped
                                    and           vgpos = <fs_item>-NITEMPED.
                 SELECT SINGLE * FROM konv  INTO ls_konv
                     WHERE knumv EQ <fs_likp>-knump AND
                           kposn EQ ls_lips-posnr   AND
                           kschl EQ 'YICD'.
                 CHECK sy-subrc EQ 0.
                 <fs_item_tax>-rate = lv_rate.
              endloop.
            endif.
        ENDLOOP.
    ENDIF.

 endif.

ENDENHANCEMENT.
