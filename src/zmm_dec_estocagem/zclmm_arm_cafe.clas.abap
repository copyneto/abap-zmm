class ZCLMM_ARM_CAFE definition
  public
  final
  create public .

public section.

  data GS_CAFE type ZI_MM_01_CAFE .
  data GV_WAIT_ASYNC type ABAP_BOOL .
  data GT_BAPIRET2 type BAPIRET2_T .

  methods CONSTRUCTOR
    importing
      !IS_MM_01_CAFE type ZI_MM_01_CAFE optional .
  methods EXECUTE
    returning
      value(RT_BAPIRET2) type BAPIRET2_T .
  methods VALIDA_QTD
    importing
      !IV_ROMANEIO type ZE_ROMANEIO
    returning
      value(RT_BAPIRET2) type BAPIRET2_T .
  methods EXECUTE_PROC_ARMAZ
    importing
      !IV_ROMANEIO type ZE_ROMANEIO
    returning
      value(RT_BAPIRET2) type BAPIRET2_T .
  methods SETUP_MESSAGES
    importing
      !P_TASK type CLIKE .
  methods PROC_ARMAZ
    importing
      !IV_ROMANEIO type ZE_ROMANEIO
    returning
      value(RT_BAPIRET2) type BAPIRET2_T .
  PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    ty_item    TYPE STANDARD TABLE OF bapi2017_gm_item_create .
  TYPES:
    ty_val_tab TYPE STANDARD TABLE OF api_vali .

  CONSTANTS:
    BEGIN OF gc_values,
      zmm_dec_estoc TYPE string           VALUE 'ZMM_DEC_ESTOC',
      e             TYPE c                VALUE 'E',
      s             TYPE c                VALUE 'S',
      z             TYPE c                VALUE 'Z',
      v001          TYPE symsgno          VALUE '001',
      v002          TYPE symsgno          VALUE '002',
      v003          TYPE symsgno          VALUE '003',
      v004          TYPE symsgno          VALUE '004',
      v005          TYPE symsgno          VALUE '005',
      v006          TYPE symsgno          VALUE '006',
      text1         TYPE char25           VALUE 'EM LOTE CLASSIFICADO',
      v04           TYPE bapi2017_gm_code VALUE '04',
      v311          TYPE bwart            VALUE '311',
      kg            TYPE erfme            VALUE 'KG',
      ygv_qtd_kg    TYPE atnam            VALUE 'YGV_QTD_KG',
      ygv_qtd_sacas TYPE atnam            VALUE 'YGV_QTD_SACAS',
      text2         TYPE string           VALUE 'TR estoque lote origem',
      text3         TYPE string           VALUE 'DEP_MATPRIMA',
      text4         TYPE string           VALUE 'DEP_PERDA',
      ch1           TYPE ze_param_chave   VALUE 'DEP_DESTINO',
      ch2           TYPE ze_param_chave   VALUE 'MOVE_STLOC',
      modulo        TYPE ze_param_modulo  VALUE 'MM',
      sts_ord_3     TYPE ze_status_ordem  VALUE '3',
    END OF gc_values .

  METHODS validate_stock
    RETURNING
      VALUE(rt_bapiret2) TYPE bapiret2_t .
  METHODS restricted_lot
    RETURNING
      VALUE(rt_bapiret2) TYPE bapiret2_t .
  METHODS transfer_stock
    RETURNING
      VALUE(rt_bapiret2) TYPE bapiret2_t .
  METHODS fill_header
    EXPORTING
      !es_header TYPE bapi2017_gm_head_01 .
  METHODS fill_item
    EXPORTING
      !et_item           TYPE ty_item
    RETURNING
      VALUE(rt_bapiret2) TYPE bapiret2_t .
  METHODS save .
  METHODS conv
    IMPORTING
      !it_value       TYPE ty_val_tab
      !iv_atnam       TYPE atnam
    RETURNING
      VALUE(rv_valor) TYPE dec16_3 .
  METHODS get_stloc
    RETURNING
      VALUE(rv_result) TYPE umlgo .
ENDCLASS.



CLASS ZCLMM_ARM_CAFE IMPLEMENTATION.


  METHOD constructor.
    gs_cafe = is_mm_01_cafe.
  ENDMETHOD.


  METHOD execute.

    rt_bapiret2 = me->validate_stock( ).

    IF rt_bapiret2 IS INITIAL.

      rt_bapiret2 = me->restricted_lot( ).

      IF rt_bapiret2 IS INITIAL.

        rt_bapiret2 = me->transfer_stock( ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_header.

    es_header = VALUE #( pstng_date = sy-datum
                         doc_date   = sy-datum
                         pr_uname   = sy-uname
                         header_txt = gc_values-text1 ).

  ENDMETHOD.


  METHOD fill_item.

    DATA: lt_val_tab       TYPE STANDARD TABLE OF api_vali.

    CALL FUNCTION 'QC01_BATCH_VALUES_READ'
      EXPORTING
        i_val_matnr    = gs_cafe-Material
        i_val_werks    = gs_cafe-Plant
*        i_val_charge   = gs_cafe-charg
      TABLES
        t_val_tab      = lt_val_tab
      EXCEPTIONS
        no_class       = 1
        internal_error = 2
        no_values      = 3
        no_chars       = 4
        OTHERS         = 5.

    IF sy-subrc EQ 0.

      gs_cafe-qtd_total_sacas = conv( EXPORTING it_value = lt_val_tab iv_atnam = gc_values-ygv_qtd_sacas ).
      gs_cafe-qtd_total_kg    = conv( EXPORTING it_value = lt_val_tab iv_atnam = gc_values-ygv_qtd_kg  ).

      IF gs_cafe-qtd_total_kg IS NOT INITIAL.

        CLEAR: lt_val_tab[].

        et_item = VALUE #( BASE et_item (
               material        = gs_cafe-material
               plant           = gs_cafe-plant
               stge_loc        = gs_cafe-lgort
               batch           = gs_cafe-batch
               move_type       = gc_values-v311
               entry_qnt       = gs_cafe-qtd_total_kg
               entry_uom       = gs_cafe-meins
               item_text       = gc_values-text2 && gs_cafe-Batch
               move_mat        = gs_cafe-material
               move_plant      = gs_cafe-plant
               move_stloc      = get_stloc(  )
*               move_batch      = gs_cafe-charg

            ) ).


        gs_cafe-qtd_dif_nf  = gs_cafe-QuantityInBaseUnit - gs_cafe-qtd_total_sacas.

        IF gs_cafe-qtd_dif_nf LT 0.

          gs_cafe-batch_number+8(1) = gc_values-z.

          et_item = VALUE #( BASE et_item (
              material        = gs_cafe-material
              plant           = gs_cafe-plant
              stge_loc        = gs_cafe-lgort
              batch           = gs_cafe-batch
              move_type       = gc_values-v311
              entry_qnt       = gs_cafe-qtd_total_kg
              entry_uom       = gs_cafe-meins
              item_text       = gc_values-text2 && gs_cafe-Batch
              move_mat        = gs_cafe-material
              move_plant      = gs_cafe-plant
              move_stloc      = gc_values-text4
*              move_batch      = gs_cafe-charg

           ) ).

        ENDIF.

      ELSE.
        rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type = gc_values-e id = gc_values-zmm_dec_estoc number = gc_values-v003 ) ).
      ENDIF.

    ELSE.
      rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type = gc_values-e id = gc_values-zmm_dec_estoc number = gc_values-v003 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD restricted_lot.

    DATA: ls_emkpf         TYPE emkpf,
          ls_errortext     TYPE natxt,
          lt_zimseg        TYPE STANDARD TABLE OF imseg,
          lt_char_of_batch TYPE STANDARD TABLE OF clbatch.

    CALL FUNCTION 'VB_CHANGE_BATCH_STATUS'
      EXPORTING
        matnr                   = gs_cafe-material
        charg                   = gs_cafe-batch
        werks                   = gs_cafe-plant
        zustd                   = space
        bypass_post             = space
      IMPORTING
        emkpf                   = ls_emkpf
      TABLES
        zimseg                  = lt_zimseg
        char_of_batch           = lt_char_of_batch
      CHANGING
        errortext               = ls_errortext
      EXCEPTIONS
        no_material             = 1
        no_batch                = 2
        no_plant                = 3
        no_unit                 = 4
        no_status_handling      = 5
        no_batch_handling       = 6
        no_status_to_change     = 7
        no_status_handled_plant = 8
        material_not_found      = 9
        batch_not_found         = 10
        plant_not_found         = 11
        error_in_goods_movement = 12
        lock_on_material        = 13
        lock_on_plant           = 14
        lock_system_error       = 15
        function_not_supported  = 16
        no_authority            = 17
        data_mismatch           = 18
        lock_on_batch           = 19
        OTHERS                  = 20.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSEIF sy-subrc EQ 7.
      " Lote já liberado

    ELSE.
      rt_bapiret2 = VALUE #( BASE rt_bapiret2 (
                              type   = gc_values-e
                              id     = gc_values-zmm_dec_estoc
                              number = gc_values-v002
                              message_v1  = ls_errortext  ) ).
    ENDIF.

  ENDMETHOD.


  METHOD save.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    UPDATE ztmm_romaneio_in SET status_armazenado = @gc_values-s,
                                status_ordem      = @gc_values-sts_ord_3,
                                peso_dif_ori      = @gs_cafe-peso_dif_nf,
                                qtde_dif_ori      = @gs_cafe-qtd_dif_nf
     WHERE sequence =  @gs_cafe-sequence
       AND vbeln    =  @gs_cafe-vbeln
       AND ebeln    =  @gs_cafe-ebeln.

    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.


  METHOD transfer_stock.

    DATA: lt_return TYPE STANDARD TABLE OF bapiret2 .

    me->fill_header( IMPORTING es_header = DATA(ls_header) ).
    me->fill_item(   IMPORTING et_item   = DATA(lt_item)   ).

    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header = ls_header
        goodsmvt_code   = gc_values-v04
      TABLES
        goodsmvt_item   = lt_item
        return          = lt_return.

    IF NOT line_exists( lt_return[ type = gc_values-e ] ).
      me->save(  ).
    ENDIF.

    rt_bapiret2 = VALUE #( BASE rt_bapiret2 (
                        type   = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-s             ELSE gc_values-e )
                        id     = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-zmm_dec_estoc ELSE VALUE #( lt_return[ type = gc_values-e ]-id     OPTIONAL ) )
                        number = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-v001          ELSE VALUE #( lt_return[ type = gc_values-e ]-number OPTIONAL ) ) ) ).


  ENDMETHOD.


  METHOD validate_stock.

    SELECT SINGLE a~clabs FROM mchb AS a
            INNER JOIN I_BR_NFItem_C AS b
                ON a~matnr = b~material
               AND a~werks = b~plant
               AND a~charg = b~batch
               WHERE a~matnr = @gs_cafe-material
                 AND a~werks = @gs_cafe-plant
                 AND a~charg = @gs_cafe-batch
               INTO @DATA(lv_clabs).

    IF sy-subrc EQ 0.

      IF gs_cafe-qtd_total_kg GT lv_clabs.
        rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type = gc_values-e id = gc_values-zmm_dec_estoc number = gc_values-v001 ) ).
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD conv.

    DATA: lv_decimal TYPE p DECIMALS 2,
          lv_int     TYPE i,
          lv_len     TYPE i.

    DATA(lv_value) = VALUE #( it_value[ atnam = iv_atnam ]-atwrt OPTIONAL ).

    IF lv_value IS NOT INITIAL.

      lv_len = strlen( lv_value ).

      CLEAR lv_int.

      WHILE lv_int < lv_len.

        IF NOT  lv_value+lv_int(1) CA '0123456789,'.

          MOVE space TO  lv_value+lv_int(1).

        ENDIF.

        ADD 1 TO lv_int.

      ENDWHILE.

      CONDENSE lv_value NO-GAPS.

    ENDIF.

    TRANSLATE lv_value USING ',.'.
    rv_valor = CONV #( lv_value ).

  ENDMETHOD.


  METHOD get_stloc.

    DATA: lt_param TYPE STANDARD TABLE OF ztca_param_val.

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).      " CHANGE - JWSILVA - 21.07.2023

        lo_param->m_get_range(                                          " CHANGE - JWSILVA - 21.07.2023
         EXPORTING
         iv_modulo = gc_values-modulo
         iv_chave1 = gc_values-ch1
         iv_chave2 = gc_values-ch2
        IMPORTING
        et_range = lt_param ).

        IF lt_param IS NOT INITIAL.
          rv_result = VALUE #( lt_param[ 1 ]-low OPTIONAL ).
        ENDIF.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD proc_armaz.

    DATA: lt_item   TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_return TYPE STANDARD TABLE OF bapiret2.

    DATA: ls_header   TYPE bapi2017_gm_head_01.

    DATA: lv_qtd_rest TYPE ztmm_romaneio_it-qtd_kg_original,
          lv_lote_z   TYPE charg_d,
          lv_matnr    TYPE bapibatchkey-material,
          lv_count    TYPE i.

    rt_bapiret2 = valida_qtd( iv_romaneio = iv_romaneio ).

    IF NOT line_exists( rt_bapiret2[ type = gc_values-e ] ).

      SELECT a~doc_uuid_h,
             a~sequence,
             a~vbeln,
             a~ebeln,
             b~charg,
             b~lgort,
             b~qtd_kg_original,
             c~matnr,
             c~werks,
             c~lgort as lgortorig
        FROM ztmm_romaneio_in AS a
       INNER JOIN ztmm_romaneio_it AS b ON a~doc_uuid_h = b~doc_uuid_h
       INNER JOIN zi_mm_ord_desca_conf_pedido AS c ON b~vbeln = c~vbeln
                                                  AND b~posnr = c~vbelp
       WHERE sequence = @iv_romaneio
        INTO @DATA(ls_roman).
        add 1 to lv_count.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        SELECT doc_uuid_h,
               charg,
               qtde
          FROM ztmm_romaneio_lo
         WHERE doc_uuid_h = @ls_roman-doc_uuid_h
          INTO TABLE @DATA(lt_lotes).

        gs_cafe-sequence = ls_roman-sequence.
        gs_cafe-vbeln    = ls_roman-vbeln.
        gs_cafe-ebeln    = ls_roman-ebeln.
        gs_cafe-material = ls_roman-matnr.
        gs_cafe-plant    = ls_roman-werks.
        gs_cafe-batch    = ls_roman-charg.

        lv_qtd_rest = ls_roman-qtd_kg_original.

        " Desbloqueia lote
        DATA(lt_bapiret2) = me->restricted_lot( ).
        APPEND LINES OF lt_bapiret2 TO rt_bapiret2.

        IF NOT line_exists( lt_bapiret2[ type = gc_values-e ] ).

          LOOP AT lt_lotes ASSIGNING FIELD-SYMBOL(<fs_lotes>).

            CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
              EXPORTING
                input        = ls_roman-matnr
              IMPORTING
                output       = lv_matnr
              EXCEPTIONS
                length_error = 1
                OTHERS       = 2.

            " Criar lote
            CALL FUNCTION 'BAPI_BATCH_CREATE'
              EXPORTING
                material = lv_matnr
                batch    = <fs_lotes>-charg
                plant    = ls_roman-werks
              TABLES
                return   = lt_return.

            IF line_exists( lt_return[ type = gc_values-s ] ).
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ENDIF.

            FREE: lt_return[].

            lv_qtd_rest = lv_qtd_rest - <fs_lotes>-qtde.

            " Realiza Movimentação
            ls_header = VALUE #( pstng_date = sy-datum
                                 doc_date   = sy-datum
                                 pr_uname   = sy-uname
                                 header_txt = gc_values-text1 ).

            lt_item = VALUE #( BASE lt_item ( material   = ls_roman-matnr
                                              plant      = ls_roman-werks
                                              stge_loc   = ls_roman-lgortorig
                                              batch      = ls_roman-charg
                                              move_type  = gc_values-v311 " 311
                                              entry_qnt  = <fs_lotes>-qtde
                                              entry_uom  = gc_values-kg
*                                              item_text  = gc_values-text2 && gs_cafe-batch
                                              move_mat   = ls_roman-matnr
                                              move_plant = ls_roman-werks
                                              move_stloc = ls_roman-lgort
                                              move_batch = <fs_lotes>-charg ) ).

            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header = ls_header
                goodsmvt_code   = gc_values-v04 " 04
              TABLES
                goodsmvt_item   = lt_item
                return          = lt_return.

            IF NOT line_exists( lt_return[ type = gc_values-e ] ).
              me->save(  ).
            ENDIF.

            lt_bapiret2 = VALUE #( BASE lt_bapiret2 (
                                type   = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-s             ELSE gc_values-e )
                                id     = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-zmm_dec_estoc ELSE VALUE #( lt_return[ type = gc_values-e ]-id     OPTIONAL ) )
                                number = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-v001          ELSE VALUE #( lt_return[ type = gc_values-e ]-number OPTIONAL ) ) ) ).

            APPEND LINES OF lt_bapiret2 TO rt_bapiret2.
            FREE: lt_bapiret2[],
                  lt_item[].

          ENDLOOP.

          IF lv_qtd_rest GT 0.

            FREE: lt_return[].

            CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
              EXPORTING
                input        = ls_roman-matnr
              IMPORTING
                output       = lv_matnr
              EXCEPTIONS
                length_error = 1
                OTHERS       = 2.

            lv_lote_z = |{ <fs_lotes>-charg(8) }{ gc_values-z }|.

            " Criar lote Z
            CALL FUNCTION 'BAPI_BATCH_CREATE'
              EXPORTING
                material = lv_matnr
                batch    = lv_lote_z
                plant    = ls_roman-werks
              TABLES
                return   = lt_return.

            IF line_exists( lt_return[ type = gc_values-s ] ).
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ENDIF.

            " Realiza Movimentação
            ls_header = VALUE #( pstng_date = sy-datum
                                 doc_date   = sy-datum
                                 pr_uname   = sy-uname
                                 header_txt = gc_values-text1 ).
            FREE: lt_item[].
            lt_item = VALUE #( BASE lt_item ( material   = ls_roman-matnr
                                              plant      = ls_roman-werks
                                              stge_loc   = ls_roman-lgortorig
                                              batch      = ls_roman-charg
                                              move_type  = gc_values-v311 " 311
                                              entry_qnt  = lv_qtd_rest
                                              entry_uom  = gc_values-kg
*                                              item_text  = gc_values-text2 && gs_cafe-batch
                                              move_mat   = ls_roman-matnr
                                              move_plant = ls_roman-werks
                                              move_stloc = get_stloc( )
                                              move_batch = lv_lote_z ) ).

            CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
              EXPORTING
                goodsmvt_header = ls_header
                goodsmvt_code   = gc_values-v04 " 04
              TABLES
                goodsmvt_item   = lt_item
                return          = lt_return.

            IF NOT line_exists( lt_return[ type = gc_values-e ] ).
              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                EXPORTING
                  wait = abap_true.
            ENDIF.

            lt_bapiret2 = VALUE #( BASE rt_bapiret2 (
                                type   = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-s             ELSE gc_values-e )
                                id     = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-zmm_dec_estoc ELSE VALUE #( lt_return[ type = gc_values-e ]-id     OPTIONAL ) )
                                number = COND #( WHEN NOT line_exists( lt_return[ type = gc_values-e ] ) THEN gc_values-v001          ELSE VALUE #( lt_return[ type = gc_values-e ]-number OPTIONAL ) ) ) ).

            APPEND LINES OF lt_bapiret2 TO rt_bapiret2.
            FREE: lt_bapiret2[].
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD valida_qtd.

    DATA: lv_qtd_rest TYPE zi_mm_romaneio_compl-qtdkgoriginal.

    SELECT SINGLE docuuidh,
                  romaneio,
                  quantidade,
                  qtdkgoriginal
      FROM zi_mm_romaneio_compl
     WHERE romaneio = @iv_romaneio
      INTO @DATA(ls_romaneio).

    IF sy-subrc IS INITIAL.

      SELECT doc_uuid_lot,
             qtde
        FROM ztmm_romaneio_lo
       WHERE doc_uuid_h = @ls_romaneio-docuuidh
        INTO TABLE @DATA(lt_lotes).

      IF sy-subrc IS INITIAL.

        lv_qtd_rest = ls_romaneio-qtdkgoriginal.

        LOOP AT lt_lotes ASSIGNING FIELD-SYMBOL(<fs_lotes>).

          lv_qtd_rest = lv_qtd_rest - <fs_lotes>-qtde.

        ENDLOOP.

        IF lv_qtd_rest LT 0.
          " Quantidade superior a quantidade disponível
          rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type   = gc_values-e
                                                    id     = gc_values-zmm_dec_estoc
                                                    number = gc_values-v004 ) ).

        ELSEIF lv_qtd_rest = ls_romaneio-qtdkgoriginal.
          " Lotes não possuem valores
          rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type   = gc_values-e
                                                    id     = gc_values-zmm_dec_estoc
                                                    number = gc_values-v005 ) ).
        ENDIF.

      ELSE.
        " Lotes não definidos
        rt_bapiret2 = VALUE #( BASE rt_bapiret2 ( type   = gc_values-e
                                                  id     = gc_values-zmm_dec_estoc
                                                  number = gc_values-v006 ) ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_proc_armaz.

    CALL FUNCTION 'ZFMMM_DECIS_ARM_CAFE'
      STARTING NEW TASK 'MM_ARM_CAFE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        iv_romaneio = iv_romaneio.

    WAIT UNTIL gv_wait_async = abap_true.

    rt_bapiret2 = gt_bapiret2.

    FREE gv_wait_async.

  ENDMETHOD.


  METHOD setup_messages.

    RECEIVE RESULTS FROM FUNCTION 'MM_ARM_CAFE'
     IMPORTING
       et_return = gt_bapiret2.

    gv_wait_async = abap_true.

  ENDMETHOD.
ENDCLASS.
