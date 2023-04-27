CLASS zclmm_recebimento_fiscal DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA: gv_tcode   TYPE syst_tcode,
          gt_mrmrseg TYPE zctgmm_mrmrseg.

    METHODS:
      constructor
        IMPORTING
          iv_tcode   TYPE syst_tcode
          it_mrmrseg TYPE zctgmm_mrmrseg.

    METHODS:
      execute.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 s       TYPE shkzg VALUE 'S',
                 n       TYPE shkzg VALUE 'N',
                 h       TYPE shkzg VALUE 'H',
                 k       TYPE koart VALUE 'K',
                 p       TYPE spras VALUE 'P',
                 miro    TYPE syst_tcode VALUE 'MIRO',
                 mr8m    TYPE syst_tcode VALUE 'MR8M',
                 ipi     TYPE j_1btaxtyp VALUE 'IPI',
                 iss     TYPE j_1btaxtyp VALUE 'ISS',
                 empresa TYPE string VALUE 'EMPRESA',
                 centro  TYPE string VALUE 'CENTRO',
                 br      TYPE land1 VALUE 'BR',
               END OF gc_values.

    TYPES: tt_1bnfstx TYPE STANDARD TABLE OF j_1bnfstx.

    DATA: ls_output    TYPE zclmm_mt_recebimento_fiscal,
          lt_pedido_me TYPE STANDARD TABLE OF ztmm_pedido_me,
          gt_output    TYPE zclfi_dt_contas_apagar_co_tab1 . "zclfi_dt_contas_apagar_con_tab.

    METHODS send_rev.
    METHODS send_fiscal.
    METHODS get_tax
      IMPORTING
        is_1bnflin       TYPE j_1bnflin
        it_1bnfstx       TYPE tt_1bnfstx
      RETURNING
        VALUE(rv_result) TYPE string.
    METHODS send_contap.

ENDCLASS.



CLASS ZCLMM_RECEBIMENTO_FISCAL IMPLEMENTATION.


  METHOD constructor.

    gv_tcode    = iv_tcode.
    gt_mrmrseg  = it_mrmrseg.

  ENDMETHOD.


  METHOD execute.

    IF gv_tcode EQ gc_values-miro.
      me->send_fiscal(  ). " Miro
*      me->send_contap(  ). " Contas a pagar
    ELSEIF gv_tcode EQ gc_values-mr8m.
      me->send_rev(  ).
    ENDIF.

  ENDMETHOD.


  METHOD send_rev.

    IF gt_mrmrseg IS NOT INITIAL.

      SELECT h~docnum,h~nfenum, h~series, h~docdat, z~ebeln, z~ebelp, z~elikz, z~lifnr FROM j_1bnfdoc AS h
        INNER JOIN ztmm_pedido_me AS z
         ON z~docnum = h~docnum
           FOR ALL ENTRIES IN @gt_mrmrseg
         WHERE z~ebeln = @gt_mrmrseg-ebeln
           AND z~ebelp = @gt_mrmrseg-ebelp
           INTO TABLE @DATA(lt_data).

      IF sy-subrc EQ 0.

        LOOP AT gt_mrmrseg ASSIGNING FIELD-SYMBOL(<fs_bseg>).

          DATA(ls_data) = VALUE #( lt_data[ ebeln = <fs_bseg>-ebeln ebelp = <fs_bseg>-ebelp ] OPTIONAL ).

          IF ls_data IS NOT INITIAL.

            DATA(ls_output) = VALUE zclmm_mt_recebimento_fisico(
                    mt_recebimento_fisico-ebeln      = <fs_bseg>-ebeln
                    mt_recebimento_fisico-ebelp      = <fs_bseg>-ebelp
                    mt_recebimento_fisico-lifnr      = ls_data-lifnr
                    mt_recebimento_fisico-budat_mkpf = ls_data-docdat
                    mt_recebimento_fisico-menge      = <fs_bseg>-menge
                    mt_recebimento_fisico-xblnr_mkpf = <fs_bseg>-belnr
                    mt_recebimento_fisico-elikz      = ls_data-elikz
                    mt_recebimento_fisico-shkzg      = COND #( WHEN <fs_bseg>-shkzg EQ gc_values-h  THEN gc_values-s ELSE gc_values-n )
                    mt_recebimento_fisico-nfenum     = ls_data-nfenum
                    mt_recebimento_fisico-series     = ls_data-series
                    mt_recebimento_fisico-sgtxt      = <fs_bseg>-sgtxt ).

            TRY.

                NEW zclmm_co_si_enviar_recebimento( )->si_enviar_recebimento_fisico_o(
                    EXPORTING
                      output = ls_output
                ).

              CATCH cx_ai_system_fault INTO DATA(lo_erro).
                DATA(ls_erro) = VALUE zclmm_exchange_fault_data( fault_text = lo_erro->get_text( ) ).
            ENDTRY.

            CLEAR: ls_data.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD send_fiscal.

    IF gt_mrmrseg IS NOT INITIAL.

      SELECT h~parid, h~docnum,h~nfenum, h~series, h~docdat, h~nftot, h~waerk, h~crenam,
               h~zterm, h~pstdat, h~nfe, h~bukrs, h~vliq, i~*, z~* FROM j_1bnfdoc AS h
        INNER JOIN j_1bnflin AS i
        INNER JOIN ztmm_pedido_me AS z
         ON z~ebeln  = i~xped
        AND z~ebelp  = i~nitemped
         ON h~docnum = i~docnum
         FOR ALL ENTRIES IN @gt_mrmrseg
           WHERE h~belnr = @gt_mrmrseg-belnr
           INTO TABLE @DATA(lt_nf).

      IF sy-subrc EQ 0.

        SELECT * FROM j_1bnfstx
        FOR ALL ENTRIES IN @lt_nf
          WHERE docnum = @lt_nf-i-docnum
            AND itmnum = @lt_nf-i-itmnum
          INTO TABLE @DATA(lt_tax).

        LOOP AT lt_nf ASSIGNING FIELD-SYMBOL(<fs_pedido_me>).

          IF sy-tabix EQ 1.

            ls_output-mt_recebimento_fiscal-parid      = <fs_pedido_me>-parid.
            ls_output-mt_recebimento_fiscal-nfenum     = <fs_pedido_me>-nfenum.
            ls_output-mt_recebimento_fiscal-series     = <fs_pedido_me>-series.
            ls_output-mt_recebimento_fiscal-docdat     = <fs_pedido_me>-docdat.
            ls_output-mt_recebimento_fiscal-nftot      = <fs_pedido_me>-nftot.
*            ls_output-mt_recebimento_fiscal-pedido_me  = <fs_pedido_me>-z-ped_me.
            ls_output-mt_recebimento_fiscal-pedido_sap = <fs_pedido_me>-z-ebeln.
            ls_output-mt_recebimento_fiscal-vlrliquido = <fs_pedido_me>-vliq.
            ls_output-mt_recebimento_fiscal-qtdeitens  = lines( lt_nf ).

            GET TIME STAMP FIELD DATA(lv_timestamp).
            ls_output-mt_recebimento_fiscal-datahora = lv_timestamp.

            ls_output-mt_recebimento_fiscal-waerk      = <fs_pedido_me>-waerk.
            ls_output-mt_recebimento_fiscal-crenam     = <fs_pedido_me>-crenam.
            ls_output-mt_recebimento_fiscal-zterm      = <fs_pedido_me>-zterm.

            ls_output-mt_recebimento_fiscal-pstdat     = <fs_pedido_me>-pstdat.
            ls_output-mt_recebimento_fiscal-nfe        = <fs_pedido_me>-nfe.
            ls_output-mt_recebimento_fiscal-bukrs      = <fs_pedido_me>-bukrs.

          ENDIF.

          APPEND VALUE #(
              itmnum        = <fs_pedido_me>-i-itmnum
*              pedidoitem_me = <fs_pedido_me>-z-ped_me
              xped          = <fs_pedido_me>-z-ebeln
              matnr         = <fs_pedido_me>-i-matnr
              nitemped      = <fs_pedido_me>-i-nitemped
              menge         = <fs_pedido_me>-i-menge
              elikz         =  <fs_pedido_me>-z-elikz
              nfpri         = <fs_pedido_me>-i-nfpri
              netwrt        = <fs_pedido_me>-i-netwrt
              nfnet         = <fs_pedido_me>-i-nfnet
              mwskz         = <fs_pedido_me>-i-mwskz
              werks         = <fs_pedido_me>-i-werks
              meins         = <fs_pedido_me>-i-meins
              ipi_iss       = get_tax( EXPORTING is_1bnflin = <fs_pedido_me>-i it_1bnfstx = lt_tax )
      ) TO ls_output-mt_recebimento_fiscal-itens.

          <fs_pedido_me>-z-docnum = <fs_pedido_me>-docnum.

          APPEND <fs_pedido_me>-z TO lt_pedido_me.

        ENDLOOP.

        MODIFY ztmm_pedido_me FROM TABLE lt_pedido_me.

        IF sy-subrc EQ 0.
          COMMIT WORK.
        ENDIF.

        TRY.

            NEW zclmm_co_si_enviar_recebiment1( )->si_enviar_recebimento_fiscal_o(
                EXPORTING
                  output = ls_output
            ).

          CATCH cx_ai_system_fault INTO DATA(lo_erro).
            DATA(ls_erro) = VALUE zclmm_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).
        ENDTRY.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_tax.

    rv_result = COND #( WHEN is_1bnflin-srvnr IS NOT INITIAL THEN VALUE #( it_1bnfstx[ docnum    = is_1bnflin-docnum
                                                                                       itmnum    = is_1bnflin-itmnum
                                                                                       taxtyp(3) = gc_values-iss    ]-taxval OPTIONAL )
                                                             ELSE VALUE #( it_1bnfstx[ docnum    = is_1bnflin-docnum
                                                                                       itmnum    = is_1bnflin-itmnum
                                                                                       taxtyp(3) = gc_values-ipi    ]-taxval OPTIONAL ) ).

  ENDMETHOD.


  METHOD send_contap.

    DATA(ls_rseg) = VALUE #( gt_mrmrseg[ 1 ] OPTIONAL ).

    IF ls_rseg IS NOT INITIAL.

      DATA(lv_awkey) = ls_rseg-belnr && ls_rseg-gjahr.

      SELECT SINGLE belnr FROM bkpf
      WHERE awkey = @lv_awkey
      INTO @DATA(lv_belnr).

      IF lv_belnr IS NOT INITIAL.

        SELECT a~ebeln, a~ebelp, a~netdt, a~koart, a~shkzg, b~*, c~textl, d~text2, e~text1  FROM bseg AS a
             INNER JOIN bsik_view AS b
               ON a~belnr = b~belnr
              AND a~bukrs = b~bukrs
              AND a~gjahr = b~gjahr
              LEFT OUTER JOIN t008t AS c
              ON c~spras = @gc_values-p
             AND c~zahls = b~zlspr
             LEFT OUTER JOIN t042zt AS d
             ON  d~spras = @gc_values-p
             AND d~land1 = @gc_values-br
             AND d~zlsch = b~zlsch
             LEFT OUTER JOIN t052u AS e
              ON e~spras = @gc_values-p
             AND e~zterm = b~zterm
        WHERE a~belnr = @lv_belnr
          AND a~bukrs = @ls_rseg-bukrs
          AND a~gjahr = @ls_rseg-gjahr
*          AND a~koart = 'S'
        INTO TABLE @DATA(lt_bseg).

        IF sy-subrc EQ 0.

          SELECT z~ebeln FROM ztmm_pedido_me AS z
               FOR ALL ENTRIES IN @lt_bseg
             WHERE z~ebeln = @lt_bseg-ebeln
               AND z~ebelp = @lt_bseg-ebelp
                INTO TABLE @DATA(lt_resul) UP TO 1 ROWS.

          IF sy-subrc EQ 0.

            LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>) WHERE koart = 'S'
                                                                AND shkzg = 'H'.

              DATA(ls_bseg_h_netdt) = VALUE #( lt_bseg[ koart = gc_values-k  ]-netdt OPTIONAL ).

              DATA(ls_contas_apagar_borgs) = VALUE zclfi_dt_contas_apagar_borgs1(
               wrbtr      = <fs_bseg>-b-wrbtr
               zlsch      = COND #( WHEN <fs_bseg>-b-zlsch IS INITIAL THEN <fs_bseg>-text2 ELSE <fs_bseg>-b-zlsch && '-' && <fs_bseg>-text2 )
               zlspr      = COND #( WHEN <fs_bseg>-b-zlspr IS INITIAL THEN <fs_bseg>-textl ELSE <fs_bseg>-b-zlspr && '-' && <fs_bseg>-textl )
               borg_empresa = VALUE #( ( codigo_borg = <fs_bseg>-b-bukrs  codigo_vent = gc_values-empresa ) )
               borg_centro  = VALUE #( ( codigo_borg = ls_rseg-werks      codigo_vent = gc_values-centro  ) )
               ).

              APPEND VALUE #(
                  lifnr = <fs_bseg>-b-lifnr
                  xblnr = <fs_bseg>-b-xblnr
                  belnr = <fs_bseg>-b-belnr
                  fdtag = ls_bseg_h_netdt
                  bldat = <fs_bseg>-b-bldat
                  budat = <fs_bseg>-b-budat
                  blart = <fs_bseg>-b-blart
                  zterm = COND #( WHEN <fs_bseg>-b-zterm IS INITIAL THEN <fs_bseg>-text1 ELSE <fs_bseg>-b-zterm && '-' && <fs_bseg>-text1 )
                  skfbt = COND #( WHEN <fs_bseg>-b-skfbt NE 0 THEN <fs_bseg>-b-skfbt ELSE <fs_bseg>-b-wrbtr )
                  sgtxt = <fs_bseg>-b-sgtxt
                  ebeln = ls_rseg-ebeln
                  borgs = ls_contas_apagar_borgs
              ) TO gt_output.

            ENDLOOP.
          ENDIF.

          IF gt_output IS NOT INITIAL.

            TRY.

                NEW zclfi_co_si_enviar_contas_apag(  )->si_enviar_contas_apagar_out(
                    EXPORTING
                       output = VALUE zclfi_mt_contas_apagar( mt_contas_apagar-msg_contas_apagar_list-itens-conta_apagar = gt_output )
                 ).

                IF sy-subrc EQ 0.
                  COMMIT WORK.
                ENDIF.

              CATCH cx_ai_system_fault.
            ENDTRY.

          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
