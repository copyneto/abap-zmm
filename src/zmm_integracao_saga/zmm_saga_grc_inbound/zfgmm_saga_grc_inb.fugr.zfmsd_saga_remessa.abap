FUNCTION zfmsd_saga_remessa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_MKPF) TYPE  MKPF OPTIONAL
*"     VALUE(IS_HEADER) TYPE  J_1BNFDOC
*"----------------------------------------------------------------------


  TYPES: ty_receb TYPE STANDARD TABLE OF ztmm_wms_receb WITH DEFAULT KEY,
         ty_ref   TYPE RANGE OF vbeln.

  CONSTANTS:
    "! Constantes para tabela de parâmetros
    BEGIN OF lc_parametro,
      modulo TYPE ze_param_modulo VALUE 'SD',
      chave1 TYPE ztca_param_par-chave1 VALUE 'SAGA',
      chave2 TYPE ztca_param_par-chave2 VALUE 'WERKS',
      v100   TYPE j_1bstatuscode  VALUE '100',
      il     TYPE j_1bnftype VALUE 'IK',
      ik     TYPE j_1bnftype VALUE 'IL',
    END OF lc_parametro,

    lc_direct1 TYPE j_1bdirect VALUE '1'.

  DATA lr_vstel TYPE RANGE OF j_1bnfdoc-vstel.

  IF is_header-code EQ lc_parametro-v100.

    DATA(lo_tabela_parametros_vstel) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros_vstel->m_get_range(
      EXPORTING
            iv_modulo = lc_parametro-modulo
            iv_chave1 = lc_parametro-chave1
            iv_chave2 = lc_parametro-chave2
      IMPORTING
            et_range  =  lr_vstel
      ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

    IF    is_header-direct = lc_direct1
    AND ( is_header-nftype = lc_parametro-il OR
          is_header-nftype = lc_parametro-ik ).

      SELECT itmnum,
             charg,
             werks,
             matnr,
             menge,
             refkey
        FROM j_1bnflin
       WHERE docnum = @is_header-docnum
        INTO TABLE @DATA(lt_nflin).

      IF sy-subrc IS INITIAL.

        DATA(lt_refkey) = VALUE ty_ref( FOR ls_ref IN lt_nflin ( sign   = 'I'
                                                                 option = 'EQ'
                                                                 low    = ls_ref-refkey(10) ) ).
        IF lt_refkey IS NOT INITIAL.

          SELECT a~vbeln, a~vbelv, b~lfart FROM vbfa AS a
            INNER JOIN likp AS b
            ON a~vbelv = b~vbeln
            WHERE a~vbeln IN @lt_refkey
              AND vbtyp_v EQ 'T'
            INTO TABLE @DATA(lt_vbfa).

        ENDIF.

        DATA(lt_receb) = VALUE ty_receb( FOR ls_item IN lt_nflin (   nfenum     = is_header-nfenum
                                                                     lifnr      = is_header-parid
                                                                     stcd1      = is_header-cgc
                                                                     itmnum     = ls_item-itmnum
                                                                     charg      = ls_item-charg
                                                                     werks      = ls_item-werks
                                                                     matnr      = ls_item-matnr
                                                                     zqtde_nf   = ls_item-menge
                                                                     zqtde_cont = ls_item-menge
                                                                     zconcl     = abap_true
                                                                     lfart      = VALUE #( lt_vbfa[ vbeln = ls_item-refkey ]-lfart OPTIONAL )
                                                                     vbeln      = VALUE #( lt_vbfa[ vbeln = ls_item-refkey ]-vbelv OPTIONAL ) ) ).
      ENDIF.

    ENDIF.

    IF lt_receb[] IS NOT INITIAL.

      MODIFY ztmm_wms_receb FROM TABLE lt_receb.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

    LOOP AT lr_vstel ASSIGNING FIELD-SYMBOL(<fs_vstel>).
      IF <fs_vstel>-low EQ is_header-vstel.

        SELECT SINGLE a~docnum,
                      a~nfenum
          FROM j_1bnfdoc AS a
         INNER JOIN mkpf AS b ON a~nfenum = b~xblnr
                             AND a~parid  = @is_header-parid
         WHERE b~le_vbeln = @is_mkpf-xblnr
          INTO @DATA(ls_1bnfdoc).

        SELECT SINGLE *
                 FROM likp
                 WHERE vbeln = @is_mkpf-xblnr
                 INTO @DATA(ls_likp).

        IF sy-subrc EQ 0.

          DATA lr_proxy TYPE REF TO zclsd_saga_remessa.
          lr_proxy ?= zclsd_saga_integracoes=>factory( iv_kind = |U| ).

          lr_proxy->gs_badi_nfe = abap_true.

          lr_proxy->gs_nfenum = ls_1bnfdoc-nfenum.

          lr_proxy->set_data( iv_likp = ls_likp ).
          lr_proxy->zifsd_saga_integracoes~build( ).

          lr_proxy->zifsd_saga_integracoes~execute( ).

          IF sy-subrc EQ 0.
            COMMIT WORK.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.


ENDFUNCTION.
