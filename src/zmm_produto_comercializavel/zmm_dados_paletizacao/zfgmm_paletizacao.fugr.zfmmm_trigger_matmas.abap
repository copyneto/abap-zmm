FUNCTION zfmmm_trigger_matmas.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MATNR) TYPE  MATNR
*"     VALUE(IV_MTART) TYPE  MTART
*"     VALUE(IV_TCODE) TYPE  SYST_TCODE OPTIONAL
*"----------------------------------------------------------------------

  CONSTANTS: BEGIN OF lc_values,
               name   TYPE btcjob     VALUE 'IDOCMATMAS',
               matmas TYPE edi_mestyp VALUE 'MATMAS',
               i      TYPE c          VALUE 'I',
               eq(2)  TYPE c          VALUE 'EQ',
               mm01   TYPE syst_tcode VALUE 'MM01',
               mm02   TYPE syst_tcode VALUE 'MM02',
               mm06   TYPE syst_tcode VALUE 'MM06',
             END OF lc_values.

  DATA: lr_matnr TYPE RANGE OF matnr.

  DATA: lv_number           TYPE btcjobcnt,
        lv_job_was_released TYPE btcchar1,
        lv_found            TYPE char1.

  CHECK iv_matnr IS NOT INITIAL.

  lr_matnr = VALUE #( BASE lr_matnr ( sign   = lc_values-i
                                      option = lc_values-eq
                                      low    = iv_matnr     ) ).

  IF iv_tcode EQ lc_values-mm02
  OR iv_tcode EQ lc_values-mm06.

    WAIT UP TO 5 SECONDS.
    lv_found = abap_true.

  ELSEIF iv_tcode EQ lc_values-mm01.

    WAIT UP TO 5 SECONDS.

    " Necessário para confirmar que o Material seja criado
    DO 5 TIMES.

      SELECT matnr
        FROM mara
       WHERE matnr IN @lr_matnr
        INTO TABLE @DATA(lt_mara).

      IF sy-subrc IS INITIAL.
        lv_found = abap_true.
        EXIT.
      ELSE.
        WAIT UP TO 3 SECONDS.
      ENDIF.

    ENDDO.
  ELSE.
    lv_found = abap_true.
    WAIT UP TO 5 SECONDS.
  ENDIF.

  IF lv_found IS NOT INITIAL.

    FREE MEMORY ID 'TCODE_PALETIZACAO'.
    EXPORT iv_tcode TO MEMORY ID 'TCODE_PALETIZACAO'. " ZMMI_PALETIZACAO

    " Lógica transferida para o JOB ZMMR_SAGA_ATUALIZA_HIERARQUIA
*    DATA(lo_process) = NEW zclmm_saga_atualiz_hierarquia( ).
*    lo_process->process( iv_matnr = iv_matnr ).

    " Idoc MATMAS
    SUBMIT rbdsemat
      WITH matsel IN lr_matnr
      WITH mestyp EQ lc_values-matmas
      WITH nomsg  EQ abap_true
*            USER sy-uname
*        VIA JOB lc_values-name NUMBER lv_number
       AND RETURN.
  ENDIF.

*  ENDIF.
*
*  CALL FUNCTION 'JOB_OPEN'
*    EXPORTING
*      jobname          = lc_values-name
*    IMPORTING
*      jobcount         = lv_number
*    EXCEPTIONS
*      cant_create_job  = 1
*      invalid_job_data = 2
*      jobname_missing  = 3
*      OTHERS           = 4.
*
*  IF sy-subrc IS INITIAL.
*    " Idoc MATMAS
*    SUBMIT rbdsemat
*      WITH matsel IN lr_matnr
*      WITH mestyp EQ lc_values-matmas
*      WITH nomsg  EQ abap_true
*      USER sy-uname
*       VIA JOB lc_values-name NUMBER lv_number
*      AND RETURN.
*
*    CALL FUNCTION 'JOB_CLOSE'
*      EXPORTING
*        jobcount             = lv_number
*        jobname              = lc_values-name
*        strtimmed            = abap_true
*      IMPORTING
*        job_was_released     = lv_job_was_released
*      EXCEPTIONS
*        cant_start_immediate = 1
*        invalid_startdate    = 2
*        jobname_missing      = 3
*        job_close_failed     = 4
*        job_nosteps          = 5
*        job_notex            = 6
*        lock_failed          = 7
*        OTHERS               = 8.
*
*    IF sy-subrc NE 0.
*      EXIT.
*    ENDIF.
*
*  ENDIF.

ENDFUNCTION.
