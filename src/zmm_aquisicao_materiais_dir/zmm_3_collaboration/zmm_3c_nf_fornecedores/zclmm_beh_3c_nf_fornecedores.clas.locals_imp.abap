CLASS lcl_job DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS objeto_subobjeto FOR DETERMINE ON MODIFY
      IMPORTING keys FOR job~objeto_subobjeto.

    METHODS execute FOR MODIFY
      IMPORTING keys FOR ACTION job~execute RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR job RESULT result.

ENDCLASS.

CLASS lcl_job IMPLEMENTATION.

  METHOD objeto_subobjeto.
    READ ENTITIES OF zi_mm_3c_nf_fornecedores IN LOCAL MODE
      ENTITY job
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_job).

    MODIFY ENTITIES OF zi_mm_3c_nf_fornecedores IN LOCAL MODE
      ENTITY job
        UPDATE FIELDS ( object subobject )
        WITH VALUE #( FOR ls_job IN lt_job (
        %key      = ls_job-%key
        object    = 'Z3COLLAB'
        subobject = 'NFFORN' ) )
    REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD execute.
    DATA lv_jobcount TYPE btcjobcnt.

    READ ENTITIES OF zi_mm_3c_nf_fornecedores IN LOCAL MODE
      ENTITY job
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_job).

    READ TABLE lt_job INTO DATA(ls_job) INDEX 1.

    READ ENTITIES OF zi_mm_3c_nf_fornecedores
      ENTITY job BY \_variant
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_variant)
      FAILED failed.


    DATA(lr_pstdat) = VALUE j_1bsped_t_postdate( FOR ls_variant IN lt_variant
      LET lv_low  = condense( ls_variant-low )
          lv_high = condense( ls_variant-high )
      IN ( sign   = ls_variant-sign
           option = ls_variant-opti
           low    = COND #( WHEN strlen( lv_low )  EQ 8 THEN |{ lv_low+4(4) }{ lv_low+2(2) }{ lv_low(2) }| )
           high   = COND #( WHEN strlen( lv_high ) EQ 8 THEN |{ lv_high+4(4) }{ lv_high+2(2) }{ lv_high(2) }| ) ) ).

    "Criação do job
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = ls_job-logexternalid
      IMPORTING
        jobcount         = lv_jobcount
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.
    IF SY-SUBRC NE 0.
      RETURN.
    ENDIF.

    "Chama o programa
    SUBMIT zmmr_3c_nf_fornecedores
      WITH s_pstdat IN lr_pstdat
      WITH p_jobid  EQ ls_job-jobuuid
      VIA JOB ls_job-logexternalid NUMBER lv_jobcount
      AND RETURN.

    "Inicia JOB
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname              = ls_job-logexternalid
        strtimmed            = 'X'
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        OTHERS               = 9.
    IF SY-SUBRC NE 0.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_mm_3c_nf_fornecedores IN LOCAL MODE
      ENTITY job
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result)
      FAILED failed.

    result = VALUE #( FOR ls_result IN lt_result
                       ( %tky   = ls_job-%tky
                         %param = ls_job ) ).

    MESSAGE s003(zmm_3collaboration) INTO DATA(ls_message).
    APPEND VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message( id       = sy-msgid
                                        number   = sy-msgno
                                        v1       = sy-msgv1
                                        v2       = sy-msgv2
                                        v3       = sy-msgv3
                                        v4       = sy-msgv4
                                        severity = CONV #( sy-msgty ) ) )
                    TO reported-job.

  ENDMETHOD.


  METHOD get_features.
    READ ENTITIES OF zi_mm_3c_nf_fornecedores IN LOCAL MODE
      ENTITY job
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_job)
      FAILED failed.

    result = VALUE #( FOR ls_job IN lt_job
            ( %key = ls_job-%key
              %action-execute = COND #( WHEN 1 = 2 THEN if_abap_behv=>fc-o-disabled
                                                   ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

ENDCLASS.
