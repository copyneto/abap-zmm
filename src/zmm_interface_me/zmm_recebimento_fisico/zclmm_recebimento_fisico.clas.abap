CLASS zclmm_recebimento_fisico DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: tt_mseg TYPE TABLE OF mseg.

    DATA: gt_mseg   TYPE tt_mseg,
          gs_output TYPE zclmm_mt_recebimento_fisico.

    METHODS:
      constructor
        IMPORTING
          it_mseg TYPE tt_mseg OPTIONAL.

    METHODS: process_data.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 migo TYPE syst_tcode VALUE 'MIGO',
                 v0   TYPE itl_nfnum  VALUE '000000',
                 s    TYPE shkzg VALUE 'S',
                 h    TYPE shkzg VALUE 'H',
                 n    TYPE shkzg VALUE 'N',
               END OF gc_values.

ENDCLASS.



CLASS ZCLMM_RECEBIMENTO_FISICO IMPLEMENTATION.


  METHOD constructor.
    gt_mseg[] = it_mseg[].
  ENDMETHOD.


  METHOD process_data.

    TYPES: ty_pedido TYPE STANDARD TABLE OF ztmm_pedido_me WITH DEFAULT KEY.

    DATA: lv_nf_number TYPE itl_nfnum,
          lv_series    TYPE itl_series.

    SELECT * FROM ztmm_pedido_me
    FOR ALL ENTRIES IN @gt_mseg
           WHERE ebeln EQ @gt_mseg-ebeln
           INTO TABLE @DATA(lt_pedido_me).

    IF sy-subrc EQ 0.

      DATA(lt_pedido_save) = VALUE ty_pedido( FOR ls_ped IN lt_pedido_me (
                    docnum = ls_ped-docnum
                    ebeln  = ls_ped-ebeln
                    ebelp  = ls_ped-ebelp
                    lifnr  = ls_ped-lifnr
                    ped_me = ls_ped-ped_me
                    mblnr  = VALUE #( gt_mseg[ ebeln = ls_ped-ebeln ebelp = ls_ped-ebelp ]-mblnr OPTIONAL )
                    elikz  = VALUE #( gt_mseg[ ebeln = ls_ped-ebeln ebelp = ls_ped-ebelp ]-elikz OPTIONAL ) )  ).

      IF lt_pedido_save IS NOT INITIAL.
        MODIFY ztmm_pedido_me FROM TABLE lt_pedido_save.
      ENDIF.

      LOOP AT gt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).

        CALL FUNCTION 'ITL_NF_NUMBER_SEPARATE'
          EXPORTING
            iv_ref_number = <fs_mseg>-xblnr_mkpf " xblnr - Reference Document Number
          IMPORTING
            ev_nf_number  = lv_nf_number
            ev_series     = lv_series
          EXCEPTIONS
            number_error  = 1.

        IF sy-subrc NE 0.
          EXIT.
        ENDIF.

        gs_output-mt_recebimento_fisico-ebeln      = <fs_mseg>-ebeln.
        gs_output-mt_recebimento_fisico-ebelp      = <fs_mseg>-ebelp.
        gs_output-mt_recebimento_fisico-lifnr      = <fs_mseg>-lifnr.
        gs_output-mt_recebimento_fisico-budat_mkpf = <fs_mseg>-budat_mkpf.
        gs_output-mt_recebimento_fisico-menge      = <fs_mseg>-menge.
        gs_output-mt_recebimento_fisico-xblnr_mkpf = <fs_mseg>-xblnr_mkpf.
        gs_output-mt_recebimento_fisico-elikz      = COND #( WHEN <fs_mseg>-elikz EQ abap_true    THEN gc_values-s ELSE gc_values-n ).
        gs_output-mt_recebimento_fisico-shkzg      = COND #( WHEN <fs_mseg>-shkzg EQ gc_values-h  THEN gc_values-s ELSE gc_values-n ).
        gs_output-mt_recebimento_fisico-nfenum     = COND #( WHEN lv_nf_number    NE gc_values-v0 THEN lv_nf_number ).
        gs_output-mt_recebimento_fisico-series     = lv_series.
        gs_output-mt_recebimento_fisico-sgtxt      = <fs_mseg>-sgtxt.

        TRY.

            NEW zclmm_co_si_enviar_recebimento( )->si_enviar_recebimento_fisico_o(
                EXPORTING
                  output = gs_output
            ).

          CATCH cx_ai_system_fault INTO DATA(lo_erro).

            DATA(ls_erro) = VALUE zclmm_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        ENDTRY.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
