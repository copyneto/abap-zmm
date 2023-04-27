***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Deposito fechado, centro faturamento                   *
*** AUTOR : Carlos Garcia  – Meta                                     *
*** FUNCIONAL: Alcides Ponciano  – Meta                               *
*** DATA :  07.10.2022                                                *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
***      |       |                                                    *
***********************************************************************
REPORT zmmr_dep_fechado_centro_fat.

TABLES ztmm_prm_dep_fec.

SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_cent_o FOR ztmm_prm_dep_fec-origin_plant,
                  s_dep_o  FOR ztmm_prm_dep_fec-origin_storage_location MATCHCODE OBJECT mmpur_ui_elm_lgort ,
                  s_cent_d FOR ztmm_prm_dep_fec-destiny_plant,
                  s_dep_d  FOR ztmm_prm_dep_fec-destiny_storage_location MATCHCODE OBJECT mmpur_ui_elm_lgort.
  PARAMETERS: p_prstep TYPE ze_mm_df_process_step OBLIGATORY.

  PARAMETERS: p_msg TYPE char1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK block.

START-OF-SELECTION.
  PERFORM f_vez_processamento.

  DATA(lt_mensagens_exec) = NEW zclmm_dep_fechado_centro_fat( )->executar( is_dados_filtro = VALUE #(
                                                                           origin_plant             = s_cent_o[]
                                                                           origin_storage_location  = s_dep_o[]
                                                                           destiny_plant            = s_cent_d[]
                                                                           destiny_storage_location = s_dep_d[]
                                                                           process_step             = p_prstep ) ).

  IF p_msg = abap_false.
    MESSAGE s037(zmm_deposito_fechado).
  ELSE.
    cl_rmsl_message=>display( lt_mensagens_exec ).
  ENDIF.

*&---------------------------------------------------------------------*
*& Form F_VEZ_PROCESSAMENTO
*&---------------------------------------------------------------------*
FORM f_vez_processamento.
*  DATA(go_job) = NEW zclmm_valida_job_exec( ).
*  DATA(lv_exec) = go_job->valida_exec( iv_program_exec = sy-cprog ).
*
*  IF lv_exec EQ abap_false.
*    MESSAGE s044(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*    cv_proc = abap_true.
*  ENDIF.

  "Programas dos jobs
  CONSTANTS: BEGIN OF lc_programs,
               p1 TYPE tbtcp-progname VALUE 'ZMMR_MANTEM_DEPOSITO_FECHADO',
               p2 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FEC_NF_WRITER',
               p3 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FEC_REPROC_PEDIDO',
               p4 TYPE tbtcp-progname VALUE 'ZMMR_DEP_FECHADO_CENTRO_FAT',
               p5 TYPE tbtcp-progname VALUE 'ZMMR_NOTAS_TRANSF_FATURAMENTO',
             END OF lc_programs.

  CONSTANTS: gc_job_exec  TYPE btcstatus VALUE 'R'.

  DATA: lr_programs TYPE RANGE OF tbtcp-progname.

  lr_programs = VALUE #( ( sign = 'I' option = 'EQ' low = lc_programs-p1 )
                         ( sign = 'I' option = 'EQ' low = lc_programs-p2 )
                         ( sign = 'I' option = 'EQ' low = lc_programs-p3 )
                         ( sign = 'I' option = 'EQ' low = lc_programs-p4 )
                         ( sign = 'I' option = 'EQ' low = lc_programs-p5 ) ).

  " Como esse JOB só executa 1 vez de dia e outra a noite, ele tem prioridade
  " Deve ficar aguardando a finalização dos outros
  " Aguardar até 1 hora
  DO 360 TIMES.

    SELECT _tbtcp~jobname,
           _tbtcp~jobcount,
           _tbtcp~progname,
           _tbtco~strtdate,
           _tbtco~strttime,
           _tbtco~enddate,
           _tbtco~endtime
      FROM tbtcp AS _tbtcp
     INNER JOIN tbtco AS _tbtco ON _tbtcp~jobname = _tbtco~jobname
                               AND _tbtcp~jobcount = _tbtco~jobcount
     WHERE _tbtcp~progname   IN @lr_programs
       AND _tbtco~status     EQ @gc_job_exec
      INTO TABLE @DATA(lt_jobs).

    DELETE lt_jobs WHERE enddate IS NOT INITIAL
                     AND enddate NE '        '          "#EC CI_SEL_DEL
                     AND enddate NE '00000000'.          "#EC CI_STDSEQ

    IF lt_jobs[] IS INITIAL OR lines( lt_jobs ) <= 1. " Job atual fica no log
      "Pode executar
      EXIT.
    ELSE.
      " Aguardar para verificar novamente se pode executar
      " Pois os outros JOBs bloqueiam os dados executados aqui
      WAIT UP TO 10 SECONDS.
    ENDIF.
  ENDDO.

ENDFORM.
