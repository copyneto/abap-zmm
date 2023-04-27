***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Job Notas Transf. Faturamento                          *
*** AUTOR : Carlos Adriano Garcia – Meta                              *
*** FUNCIONAL: Alcides Ponciano  – Meta                               *
*** DATA :  18.01.2023                                                *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
***      |       |                                                    *
***********************************************************************
REPORT zmmr_notas_transf_faturamento.

TABLES: likp.

DATA: gt_worktab TYPE STANDARD TABLE OF lipov,
      gt_success TYPE STANDARD TABLE OF lipov,
      gt_error   TYPE STANDARD TABLE OF lipov,
      gt_tvst    TYPE STANDARD TABLE OF tvst,
      gt_vbfs    TYPE STANDARD TABLE OF vbfs.

DATA: gv_wait_async    TYPE abap_bool,
      gv_flag_inbound  TYPE c,
      gv_success_count TYPE i,
      gv_error_count   TYPE i,
      gv_wadat_ist     TYPE likp-wadat_ist,
      gv_bitype_dark   TYPE c VALUE 'N',
      gv_subrc         TYPE sy-subrc,
      gv_proc          TYPE char1.

CONSTANTS: gc_job TYPE indx_srtfd VALUE 'JOB_VEZ'.

SELECTION-SCREEN BEGIN OF BLOCK block WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS:
    s_vbeln FOR likp-vbeln,
    s_kostk FOR likp-kostk,
    s_bldat for likp-bldat DEFAULT sy-datum.

  SELECTION-SCREEN SKIP 1.

  PARAMETERS: p_lfart TYPE likp-lfart OBLIGATORY.
  "p_kostk TYPE likp-kostk OBLIGATORY.
SELECTION-SCREEN END OF BLOCK block.


START-OF-SELECTION.
  PERFORM f_vez_processamento CHANGING gv_proc.

  IF gv_proc IS NOT INITIAL.
    EXIT.
  ENDIF.

  CLEAR sy-batch.

  SELECT a~*,
         b~spewa
    FROM likp AS a
    LEFT OUTER JOIN tvls AS b ON b~lifsp = a~lifsk
   WHERE a~vbeln IN @s_vbeln
     AND a~lfart EQ @p_lfart
     AND a~kostk IN @s_kostk
     and a~bldat in @S_bldat
     AND a~wbstk <> 'C'
    INTO TABLE @DATA(gt_likp).                "#EC CI_ALL_FIELDS_NEEDED

  LOOP AT gt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>).

    CHECK <fs_likp>-spewa IS INITIAL.

    CLEAR: gv_wait_async,
           gv_success_count,
           gv_error_count,
           gv_subrc.

    FREE: gt_worktab[],
          gt_success[],
          gt_error[],
          gt_tvst[],
          gt_vbfs[].

    APPEND CORRESPONDING #( <fs_likp>-a ) TO gt_worktab.

    CALL FUNCTION 'ZFMMM_LM_GOODS_MOVEMENT'
      STARTING NEW TASK 'ZMM_LM_GOODS_MOVEMENT'
      PERFORMING f_callback_meth ON END OF TASK
      EXPORTING
        iv_bitype       = gv_bitype_dark
        iv_wadat_ist    = gv_wadat_ist
        iv_flag_inbound = gv_flag_inbound
      TABLES
        ct_worktab      = gt_worktab
        et_success      = gt_success
        et_error        = gt_error
        et_tvst         = gt_tvst
        et_vbfs         = gt_vbfs
      EXCEPTIONS
        no_permission   = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
      sy-subrc = sy-subrc.
    ENDIF.

    WAIT UNTIL gv_wait_async = abap_true.
    CASE sy-subrc.
      WHEN 1.
        WRITE: TEXT-002.
        ULINE.
        WRITE: / TEXT-003.

        LOOP AT gt_tvst ASSIGNING FIELD-SYMBOL(<fs_tvst>). "#EC CI_NESTED
          WRITE <fs_tvst>-vstel.
        ENDLOOP.

        ULINE.
        WRITE: |{ TEXT-004 } { <fs_likp>-a-vbeln }|.

        LOOP AT gt_vbfs ASSIGNING FIELD-SYMBOL(<fs_vbfs>).
          MESSAGE ID <fs_vbfs>-msgid TYPE <fs_vbfs>-msgty NUMBER <fs_vbfs>-msgno WITH <fs_vbfs>-msgv1
                                                                                      <fs_vbfs>-msgv2
                                                                                      <fs_vbfs>-msgv3
                                                                                      <fs_vbfs>-msgv4
                                                                                      INTO DATA(ls_msg).
          ULINE.
          WRITE: / ls_msg.
        ENDLOOP.

      WHEN OTHERS.
        WRITE: TEXT-002.
        ULINE.
        WRITE: |{ TEXT-004 } { <fs_likp>-a-vbeln }|.

        LOOP AT gt_vbfs ASSIGNING <fs_vbfs>.
          MESSAGE ID <fs_vbfs>-msgid TYPE <fs_vbfs>-msgty NUMBER <fs_vbfs>-msgno WITH <fs_vbfs>-msgv1
                                                                                      <fs_vbfs>-msgv2
                                                                                      <fs_vbfs>-msgv3
                                                                                      <fs_vbfs>-msgv4
                                                                                      INTO ls_msg.
          ULINE.
          WRITE: / ls_msg.
        ENDLOOP.

        PERFORM display_log IN PROGRAM saplv50q
                                TABLES gt_success
                                       gt_error
                                       gt_vbfs
                                 USING gv_flag_inbound
                                       space.            "#EC CI_NESTED
    ENDCASE.
  ENDLOOP.

***-------------------------------------------------------------------*
*** FORM F_CALLBACK_METH                                              *
***-------------------------------------------------------------------*
FORM f_callback_meth  USING taskname.

  RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LM_GOODS_MOVEMENT'
     IMPORTING
        ev_success_count       = gv_success_count
        ev_error_count         = gv_error_count
        ev_subrc               = gv_subrc
        TABLES
        ct_worktab             = gt_worktab
        et_success             = gt_success
        et_error               = gt_error
        et_tvst                = gt_tvst
        et_vbfs                = gt_vbfs.

  gv_wait_async = abap_true.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form F_VEZ_PROCESSAMENTO
*&---------------------------------------------------------------------*
FORM f_vez_processamento CHANGING cv_proc TYPE char1.

  DATA: ls_return TYPE bapiret2.

  DATA: lv_jobname  TYPE tbtcp-jobname,
        lv_jobcount TYPE tbtcp-jobcount,
        lv_strtdate TYPE tbtco-strtdate,
        lv_strttime TYPE tbtco-strttime.

  DATA(go_job) = NEW zclmm_valida_job_exec( ).
  DATA(lv_exec) = go_job->valida_exec( EXPORTING iv_program_exec = sy-cprog
                                       IMPORTING ev_jobname      = lv_jobname
                                                 ev_jobcount     = lv_jobcount
                                                 ev_strtdate     = lv_strtdate
                                                 ev_strttime     = lv_strttime
                                                 es_return       = ls_return ).

  IF lv_exec EQ abap_false.
    IF ls_return IS NOT INITIAL.
      MESSAGE ID ls_return-id TYPE 'S' NUMBER ls_return-number WITH ls_return-message_v1
                                                                    ls_return-message_v2
                                                                    ls_return-message_v3
                                                                    ls_return-message_v4
                                                                    DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE s044(zmm_deposito_fechado) WITH lv_jobname
                                              lv_jobcount
                                              lv_strtdate
                                              lv_strttime
                                              DISPLAY LIKE 'E'.
    ENDIF.

    cv_proc = abap_true.
  ENDIF.

*  DATA: lv_vez_proc TYPE string.
*
*  CLEAR cv_proc.
*
*  SELECT COUNT(*)
*    FROM tbtco
*   WHERE status  = 'R'
*     AND jobname = 'ZMM_SAIDA_MERC_COM_TRANSP'
*    INTO @DATA(gv_num).
*
*  IF sy-subrc IS INITIAL.
*    IF gv_num > 1.
*      MESSAGE s044(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*      cv_proc = abap_true.
*      EXIT.
*    ENDIF.
*  ENDIF.
*
*  IMPORT lv_vez_proc TO lv_vez_proc FROM DATABASE indx(zm) ID gc_job.
*  IF sy-subrc IS INITIAL.
*    IF lv_vez_proc EQ 'ZMM_SAIDA_MERC_COM_TRANSP'.
*
*      SELECT COUNT(*)
*        FROM tbtco
*       WHERE status  = 'R'
*         AND jobname = 'ZMMR_MANTEM_DEPOSITO_FECHADO'
*        INTO @DATA(lv_dep_fech).
*
*      IF lv_dep_fech > 1.
*        MESSAGE s046(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*        cv_proc = abap_true.
*        EXIT.
*      ELSE.
*        lv_vez_proc = 'ZMMR_MANTEM_DEPOSITO_FECHADO'.
*        EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID gc_job.
*      ENDIF.
*
*    ELSE.
*
*      " Valida se o outro JOB está escalonado
*      SELECT COUNT(*)
*        FROM tbtco
*       WHERE jobname = 'ZMMR_MANTEM_DEPOSITO_FECHADO'
*         AND status  = 'S'.
*      IF sy-subrc IS INITIAL.
*        MESSAGE s046(zmm_deposito_fechado) DISPLAY LIKE 'E'.
*        cv_proc = abap_true.
*        EXIT.
*      ENDIF.
*
*    ENDIF.
*  ELSE.
*    lv_vez_proc = 'ZMMR_MANTEM_DEPOSITO_FECHADO'.
*    EXPORT lv_vez_proc FROM lv_vez_proc TO DATABASE indx(zm) ID gc_job.
*  ENDIF.

ENDFORM.
