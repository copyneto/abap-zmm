class ZCLMM_VALIDA_JOB_EXEC definition
  public
  final
  create public .

public section.

  methods VALIDA_EXEC
    importing
      !IV_PROGRAM_EXEC type SY-CPROG
    exporting
      !EV_JOBNAME type TBTCP-JOBNAME
      !EV_JOBCOUNT type TBTCP-JOBCOUNT
      !EV_STRTDATE type TBTCO-STRTDATE
      !EV_STRTTIME type TBTCO-STRTTIME
      !ES_RETURN type BAPIRET2
    returning
      value(RV_EXEC) type ABAP_BOOL .
  PROTECTED SECTION.
private section.

  constants:
    BEGIN OF gc_const,
               msg_id  TYPE sy-msgid VALUE 'ZMM_DEPOSITO_FECHADO',
               sucess  TYPE sy-msgty VALUE 'S',
               error   TYPE sy-msgty VALUE 'E',
               msg_048 TYPE sy-msgno VALUE '048',
               msg_049 TYPE sy-msgno VALUE '049',
             END OF gc_const .

  methods VALIDA_ORDEM
    importing
      !IV_PROGRAM_EXEC type SYST_CPROG
    exporting
      !ES_RETURN type BAPIRET2
    returning
      value(RV_EXEC) type ABAP_BOOL .
  methods VERIF_JOBS_ECOMM
    exporting
      !EV_ECOMM type CHAR1 .
  methods VERIFICA_JOB_LIBERADO
    importing
      !IV_PROGRAM_EXEC type STRING
    returning
      value(RV_OK) type CHAR1 .
  methods PROX_JOB_DISPONIVEL
    importing
      !IV_PROGRAM_EXEC type STRING
    exporting
      !EV_DISPON type STRING .
ENDCLASS.



CLASS ZCLMM_VALIDA_JOB_EXEC IMPLEMENTATION.


  METHOD valida_exec.

    " Programas dos jobs
    CONSTANTS: BEGIN OF lc_programs,
                 p1 TYPE tbtcp-progname VALUE 'ZMMR_MANTEM_DEPOSITO_FECHADO',
                 p2 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FEC_NF_WRITER',
                 p3 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FEC_REPROC_PEDIDO',
                 p4 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FECHADO_CENTRO_FAT',
                 p5 TYPE tbtcp-progname VALUE 'ZMMR_NOTAS_TRANSF_FATURAMENTO',
               END OF lc_programs.

    CONSTANTS: lc_job_exec TYPE btcstatus  VALUE 'R',
               lc_job      TYPE indx_srtfd VALUE 'JOB_VEZ'.

    DATA: lv_vez_proc  TYPE string.

    DATA: lr_programs TYPE RANGE OF tbtcp-progname.

    FREE: ev_jobname, ev_jobcount, ev_strtdate, ev_strttime.

    SELECT _tbtcp~jobname,
           _tbtcp~jobcount,
           _tbtcp~progname,
           _tbtco~strtdate,
           _tbtco~strttime,
           _tbtco~enddate,
           _tbtco~endtime
      FROM tbtcp AS _tbtcp
     INNER JOIN tbtco AS _tbtco ON _tbtcp~jobname  = _tbtco~jobname
                               AND _tbtcp~jobcount = _tbtco~jobcount
     WHERE _tbtcp~progname = @iv_program_exec
       AND _tbtco~status   EQ @lc_job_exec
      INTO TABLE @DATA(lt_jobs).

    DELETE lt_jobs WHERE enddate IS NOT INITIAL
                     AND enddate NE '        '          "#EC CI_SEL_DEL
                     AND enddate NE '00000000'.          "#EC CI_STDSEQ

    IF lt_jobs[] IS INITIAL OR lines( lt_jobs ) <= 1. " Job atual fica no log
      " Pode executar
      TRY.
          SORT lt_jobs BY strtdate ASCENDING
                          strttime ASCENDING.
          ev_jobname  = lt_jobs[ 1 ]-jobname.
          ev_jobcount = lt_jobs[ 1 ]-jobcount.
          ev_strtdate = lt_jobs[ 1 ]-strtdate.
          ev_strttime = lt_jobs[ 1 ]-strttime.
        CATCH cx_root.
      ENDTRY.
    ELSE.
      "Não pode executar
      rv_exec = abap_false.
      EXIT.
    ENDIF.

    " Valida ordem.

    CASE iv_program_exec.
      WHEN lc_programs-p1.
        "Como ZMMR_MANTEM_DEPOSITO_FECHADO é um job recorrente a execução dele pode ser
        "a execução dele será cancelada se tiver execução da ZMMR_DEP_FEC_REPROC_PEDIDO (p3)
        "ou ZMMR_DEP_FECHADO_CENTRO_FAT (p4) ou ZMMR_DEP_FEC_NF_WRITER (p2) em andamento.

        lr_programs = VALUE #( ( sign = 'I' option = 'EQ' low = lc_programs-p2 )
                               ( sign = 'I' option = 'EQ' low = lc_programs-p3 )
                               ( sign = 'I' option = 'EQ' low = lc_programs-p4 ) ).

        FREE: ev_jobname, ev_jobcount, ev_strtdate, ev_strttime.

        SELECT _tbtcp~jobname,
               _tbtcp~jobcount,
               _tbtcp~progname,
               _tbtco~strtdate,
               _tbtco~strttime,
               _tbtco~enddate,
               _tbtco~endtime
          FROM tbtcp AS _tbtcp
         INNER JOIN tbtco AS _tbtco ON _tbtcp~jobname  = _tbtco~jobname
                                   AND _tbtcp~jobcount = _tbtco~jobcount
         WHERE _tbtcp~progname = @iv_program_exec
           AND _tbtco~status   EQ @lc_job_exec
          INTO TABLE @DATA(lt_jobs1).

        DELETE lt_jobs1 WHERE enddate IS NOT INITIAL
                         AND enddate NE '        '      "#EC CI_SEL_DEL
                         AND enddate NE '00000000'.      "#EC CI_STDSEQ

        IF lt_jobs1[] IS INITIAL OR lines( lt_jobs1 ) <= 1. " Job atual fica no log
          " Pode executar
          rv_exec = abap_true.
          EXIT.
        ELSE.
          "Não pode executar
          rv_exec = abap_false.

          TRY.
              SORT lt_jobs BY strtdate ASCENDING
                              strttime ASCENDING.
              ev_jobname  = lt_jobs[ 1 ]-jobname.
              ev_jobcount = lt_jobs[ 1 ]-jobcount.
              ev_strtdate = lt_jobs[ 1 ]-strtdate.
              ev_strttime = lt_jobs[ 1 ]-strttime.
            CATCH cx_root.
          ENDTRY.

        ENDIF.
      WHEN lc_programs-p5.
        rv_exec = abap_true.
        EXIT.
      WHEN OTHERS.
        "Para os demais vamos colocar um wait para aguardar a execução daqueles
        "que estão em andamento

        lr_programs = VALUE #( ( sign = 'I' option = 'EQ' low = lc_programs-p1 )
                               ( sign = 'I' option = 'EQ' low = lc_programs-p2 )
                               ( sign = 'I' option = 'EQ' low = lc_programs-p3 )
                               ( sign = 'I' option = 'EQ' low = lc_programs-p4 ) ).

        DO 10 TIMES.
          IF sy-index <> 1.
            WAIT UP TO 60 SECONDS.
          ENDIF.

          FREE: ev_jobname, ev_jobcount, ev_strtdate, ev_strttime.

          SELECT _tbtcp~jobname,
                 _tbtcp~jobcount,
                 _tbtcp~progname,
                 _tbtco~strtdate,
                 _tbtco~strttime,
                 _tbtco~enddate,
                 _tbtco~endtime
            FROM tbtcp AS _tbtcp
           INNER JOIN tbtco AS _tbtco ON _tbtcp~jobname  = _tbtco~jobname
                                     AND _tbtcp~jobcount = _tbtco~jobcount
           WHERE _tbtcp~progname = @iv_program_exec
             AND _tbtco~status   EQ @lc_job_exec
            INTO TABLE @DATA(lt_jobs2).

          DELETE lt_jobs2 WHERE enddate IS NOT INITIAL
                           AND enddate NE '        '    "#EC CI_SEL_DEL
                           AND enddate NE '00000000'.    "#EC CI_STDSEQ

          IF lt_jobs2[] IS INITIAL OR lines( lt_jobs2 ) <= 1. " Job atual fica no log
            " Pode executar
            rv_exec = abap_true.
            EXIT.
          ELSE.
            "Não pode executar
            rv_exec = abap_false.
            MESSAGE s044(zmm_deposito_fechado) WITH lt_jobs2[ 1 ]-jobname
                                            lt_jobs2[ 1 ]-jobcount
                                            lt_jobs2[ 1 ]-strtdate
                                            lt_jobs2[ 1 ]-strttime
                                        DISPLAY LIKE 'E'.
            MESSAGE s050(zmm_deposito_fechado) DISPLAY LIKE 'E'.
          ENDIF.
        ENDDO.

    ENDCASE.

  ENDMETHOD.


  METHOD valida_ordem.

    DATA: lv_vez_proc  TYPE string,
          lv_job_ecomm TYPE char1,
          lv_ok        TYPE char1.

    CONSTANTS: lc_job TYPE indx_srtfd VALUE 'JOB_VEZ'.

    IMPORT lv_vez_proc TO lv_vez_proc FROM DATABASE indx(zm) ID lc_job.

    IF sy-subrc    IS NOT INITIAL
    OR lv_vez_proc IS INITIAL.

      lv_vez_proc = 'ZMMR_MANTEM_DEPOSITO_FECHADO'.
      EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID lc_job.
      COMMIT WORK AND WAIT.

      IF lv_vez_proc EQ iv_program_exec.
        " Pode executar
        rv_exec = abap_true.
      ELSE.
        " Não pode executar
        rv_exec = abap_false.
      ENDIF.

    ELSE.

      " Verifica se o JOB do E-Commerce está aguardando execução
      verif_jobs_ecomm( IMPORTING ev_ecomm = lv_job_ecomm ).
      IF lv_job_ecomm IS NOT INITIAL.

        " Não pode executar, aguardar o E-commerce finalizar
        rv_exec = abap_false.

        es_return-id         = gc_const-msg_id.
        es_return-type       = gc_const-error.
        es_return-number     = gc_const-msg_049.
        es_return-message_v1 = lv_vez_proc.

        EXIT.

      ENDIF.

      IF lv_vez_proc EQ iv_program_exec.
        " Pode executar
        rv_exec = abap_true.

        prox_job_disponivel( EXPORTING iv_program_exec = lv_vez_proc
                             IMPORTING ev_dispon       = lv_vez_proc ).

        IF lv_vez_proc IS NOT INITIAL.
          EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID lc_job.
          COMMIT WORK AND WAIT.
        ELSE.
          FREE MEMORY ID lc_job.
          COMMIT WORK AND WAIT.
        ENDIF.

      ELSE.

        lv_ok = verifica_job_liberado( iv_program_exec = lv_vez_proc ).

        " Job da vez não está liberado para executar
        IF lv_ok IS INITIAL.
          " Pode executar
          rv_exec = abap_true.

          prox_job_disponivel( EXPORTING iv_program_exec = lv_vez_proc
                               IMPORTING ev_dispon       = lv_vez_proc ).

          EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID lc_job.
          COMMIT WORK AND WAIT.

        ELSE.

          es_return-id         = gc_const-msg_id.
          es_return-type       = gc_const-error.
          es_return-number     = gc_const-msg_048.
          es_return-message_v1 = lv_vez_proc.

          " Não pode executar
          rv_exec = abap_false.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD verif_jobs_ecomm.

    " Esse JOB só executa 2x por dia, as 05:00 e as 22:00
    " Verifica se o JOB já teve a primeira execução do dia
    SELECT COUNT(*)
      FROM tbtco
     WHERE jobname  = 'ZMM_ECOMMERCE RETORNO'
       AND strtdate = @sy-datum
       AND status   = 'F'.

    IF sy-subrc IS INITIAL.

      " Verifica se a segunda execução já finalizou no dia
      SELECT COUNT(*)
        FROM tbtco
       WHERE jobname  = 'ZMM_ECOMMERCE_REMESSA'
         AND strtdate = @sy-datum
         AND status   = 'F'.

      " Se não ainda não executou hoje, verifica se ele está aguardando a vez para iniciar
      IF sy-subrc IS NOT INITIAL.
        SELECT COUNT(*)
          FROM tbtco
         WHERE jobname  = 'ZMM_ECOMMERCE_REMESSA'
           AND strtdate = @sy-datum
           AND status   = 'R'.

        " Se estiver executando, a prioridade é dele
        IF sy-subrc IS INITIAL.
          ev_ecomm = abap_true.
        ENDIF.
      ENDIF.

      " Ainda não teve a primeira execução do dia
    ELSE.

      " Verifica se o JOB está executando
      SELECT COUNT(*)
        FROM tbtco
       WHERE jobname  = 'ZMM_ECOMMERCE RETORNO'
         AND strtdate = @sy-datum
         AND status   = 'R'.

      " Se estiver executando, a prioridade é dele
      IF sy-subrc IS INITIAL.
        ev_ecomm = abap_true.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD prox_job_disponivel.

    DATA: lv_ok TYPE char1.

    DO 4 TIMES.

      CLEAR lv_ok.

      " Verifica o proximo a ser executado
      CASE iv_program_exec.
        WHEN 'ZMMR_MANTEM_DEPOSITO_FECHADO'.
          ev_dispon = 'ZMMR_NOTAS_TRANSF_FATURAMENTO'.

          lv_ok = verifica_job_liberado( iv_program_exec = ev_dispon ).
          IF lv_ok IS NOT INITIAL.
            EXIT.
          ENDIF.

        WHEN 'ZMMR_NOTAS_TRANSF_FATURAMENTO'.
          ev_dispon = 'ZMMR_DEP_FEC_NF_WRITER'.

          lv_ok = verifica_job_liberado( iv_program_exec = ev_dispon ).
          IF lv_ok IS NOT INITIAL.
            EXIT.
          ENDIF.

        WHEN 'ZMMR_DEP_FEC_NF_WRITER'.
          ev_dispon = 'ZMMR_DEP_FEC_REPROC_PEDIDO'.

          lv_ok = verifica_job_liberado( iv_program_exec = ev_dispon ).
          IF lv_ok IS NOT INITIAL.
            EXIT.
          ENDIF.

        WHEN 'ZMMR_DEP_FEC_REPROC_PEDIDO'.
          ev_dispon = 'ZMMR_MANTEM_DEPOSITO_FECHADO'.

          lv_ok = verifica_job_liberado( iv_program_exec = ev_dispon ).
          IF lv_ok IS NOT INITIAL.
            EXIT.
          ENDIF.

        WHEN OTHERS.
      ENDCASE.
    ENDDO.

    IF lv_ok IS INITIAL.
      CLEAR ev_dispon.
    ENDIF.

  ENDMETHOD.


  METHOD verifica_job_liberado.

    CONSTANTS: lc_status TYPE tbtcp-status VALUE 'S'. " Liberado

    CHECK iv_program_exec IS NOT INITIAL.

    SELECT COUNT(*)
      FROM tbtc_job_data
     WHERE progname = @iv_program_exec
       AND status   = @lc_status.
    IF sy-subrc IS INITIAL.
      " Job está liberado
      rv_ok = abap_true.
    ELSE.
      " Job está escalonado/pausado
      rv_ok = abap_false.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
