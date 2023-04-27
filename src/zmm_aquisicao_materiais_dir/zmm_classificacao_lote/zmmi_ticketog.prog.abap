*&---------------------------------------------------------------------*
*& Include zmmi_ticketog
*&---------------------------------------------------------------------*

    CONSTANTS: BEGIN OF gc_values,
                 b01           TYPE tdid     VALUE 'B01',
                 f01           TYPE tdid     VALUE 'F01',
                 item          TYPE decv5    VALUE '00010',
                 eban          TYPE tdobject VALUE 'EBAN',
                 ekko          TYPE tdobject VALUE 'EKKO',
                 v8            TYPE i        VALUE '8',
                 objeto        TYPE balobj_d VALUE 'ZMM_MONIT_OS_ENVTICK',
                 subobjeto     TYPE balsubobj VALUE 'PEDIDO_TICK',
                 zmm_ticketlog TYPE string VALUE 'ZMM_TICKETLOG',
                 e             TYPE char1 VALUE 'E',
                 s             TYPE char1 VALUE 'S',
                 v005          TYPE char3 VALUE '005',
                 v004          TYPE char3 VALUE '004',
               END OF gc_values.

    DATA: lt_lines   TYPE STANDARD TABLE OF tline.

    IF im_ebeln IS NOT INITIAL.

      DATA(lt_item) = im_header->get_items( ).

      IF lt_item IS NOT INITIAL.
        DATA(ls_item) = lt_item[ 1 ]-item->get_data( ).
      ENDIF.

      IF ls_item IS NOT INITIAL.

        SELECT SINGLE b~aufnr, b~trackingno, preq_name FROM ztpm_desc_ticlog AS a
          INNER JOIN  ztpm_ticktlog002 AS b
           ON  a~trackingno = b~trackingno
           AND a~aufnr      = b~aufnr
        WHERE a~banfn EQ @ls_item-banfn
        INTO @DATA(ls_ticlog).

        IF sy-subrc EQ 0.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = gc_values-b01
              language                = sy-langu
              name                    = CONV tdobname( ls_item-banfn && ls_item-bnfpo )
              object                  = gc_values-eban
              archive_handle          = 0
              local_cat               = space
            TABLES
              lines                   = lt_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.

          IF sy-subrc EQ 0 AND
             lt_lines IS NOT INITIAL.

            CALL FUNCTION 'CREATE_TEXT'
              EXPORTING
                fid         = gc_values-f01
                flanguage   = sy-langu
                fname       = CONV tdobname( im_ebeln )
                fobject     = gc_values-ekko
                save_direct = abap_true
              TABLES
                flines      = lt_lines
              EXCEPTIONS
                no_init     = 1
                no_save     = 2
                OTHERS      = 3.

            IF sy-subrc NE 0.
              RETURN.
            ENDIF.

            TRY.

                NEW zclpm_co_si_atualizar_numero_p( )->si_atualizar_numero_pedido_out( VALUE zclpm_mt_numero_pedido( mt_numero_pedido-aufnr      = ls_ticlog-aufnr
                                                                                                                     mt_numero_pedido-trackingno = ls_ticlog-trackingno
                                                                                                                     mt_numero_pedido-afnam      = ls_ticlog-preq_name
                                                                                                                     mt_numero_pedido-ebeln      = ls_item-ebeln ) ).

                DATA(lv_ok) = abap_true.

              CATCH cx_ai_system_fault INTO DATA(lo_error).

                DATA(ls_message) = VALUE zsmm_exchange_fault_data1( fault_text = lo_error->get_text( ) ).

                IF ls_message IS NOT INITIAL.
                  DATA(lv_error) = ls_message-fault_text.
                ENDIF.

            ENDTRY.

            DATA(ls_log) = VALUE bal_s_log(
                    aluser    = sy-uname
                    alprog    = sy-repid
                    object    = gc_values-objeto
                    subobject = gc_values-subobjeto
                    extnumber = sy-timlo ).

            CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
              STARTING NEW TASK 'SAVE_LOG'
              EXPORTING
                is_log = ls_log
                is_msg = VALUE bapiret2(
                             type       = COND #( WHEN lv_ok EQ abap_true THEN gc_values-s ELSE gc_values-e )
                             id         = gc_values-zmm_ticketlog
                             number     = COND #( WHEN lv_ok EQ abap_true THEN gc_values-v004 ELSE gc_values-v005 )
                             message_v1 = ls_item-ebeln
                             message_v2 = lv_error ).

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
