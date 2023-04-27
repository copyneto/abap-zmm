CLASS zclmm_nfe_mdfe_process DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA:
      gt_header     TYPE SORTED TABLE OF j_1bnfdoc
                                WITH UNIQUE KEY docnum .
    DATA:
      gt_active     TYPE HASHED TABLE OF j_1bnfe_active
                                WITH UNIQUE KEY docnum .
    DATA:
      gt_header_rej TYPE SORTED TABLE OF j_1bnfdoc
                                WITH UNIQUE KEY docnum .
    DATA:
      gr_pstdat TYPE RANGE OF j_1bnfdoc-pstdat .
    DATA:
      gr_bukrs  TYPE RANGE OF j_1bnfdoc-bukrs .
    DATA:
      gr_branch TYPE RANGE OF j_1bnfdoc-branch .
    DATA:
      gr_docnum TYPE RANGE OF j_1bnfdoc-docnum .
    DATA gv_acckey TYPE j_1b_nfe_access_key_dtel44 .
    DATA gv_not_code TYPE char8 .   "Rejection Code
    DATA:
      gt_return TYPE STANDARD TABLE OF bapiret2 .
    CONSTANTS:
      BEGIN OF gc_actstat,
        stat01 TYPE char2 VALUE '01',
        stat02 TYPE char2 VALUE '02',
        stat03 TYPE char2 VALUE '03',
        stat04 TYPE char2 VALUE '04',
        stat11 TYPE char2 VALUE '11',
        stat21 TYPE char2 VALUE '21',
        stat22 TYPE char2 VALUE '22',
        stat88 TYPE char2 VALUE '88',
        stat89 TYPE char2 VALUE '89',
        stat98 TYPE char2 VALUE '98',
        stat99 TYPE char2 VALUE '99',
      END OF gc_actstat .
    CONSTANTS:
      BEGIN OF gc_procstep,
        erptasks TYPE char8 VALUE 'ERPTASKS',
        sendopco TYPE char8 VALUE 'SENDOPCO',
      END OF gc_procstep .
    CONSTANTS:
      BEGIN OF gc_direction,
        inbd TYPE char4 VALUE 'INBD',
        outb TYPE char4 VALUE 'OUTB',
      END OF gc_direction .
    CONSTANTS:
      BEGIN OF gc_doctype,
        nfe TYPE char3 VALUE 'NFE',
        cte TYPE char3 VALUE 'CTE',
        mfe TYPE char3 VALUE 'MFE',
        eve TYPE char3 VALUE 'EVE',
        ev2 TYPE char3 VALUE 'EV2',
        ev3 TYPE char3 VALUE 'EV3',
      END OF gc_doctype .
    CONSTANTS:
      BEGIN OF gc_shortterm,
        nfe  TYPE /xnfe/shortterm VALUE 'NFE',
        inbd TYPE /xnfe/shortterm VALUE 'INBD',
      END OF gc_shortterm .
    CONSTANTS: gc_balobj_proc_exec TYPE balobj_d VALUE '/XNFE/PROC_EXEC' ##NO_TEXT.
    CONSTANTS: gc_object TYPE balobj_d VALUE 'ZMM_LOG_NFE'.
    CONSTANTS: gc_subobject TYPE balsubobj VALUE 'LOG_JOB'.

    METHODS constructor
      IMPORTING
        !ir_pstdat LIKE gr_pstdat
        !ir_bukrs  LIKE gr_bukrs
        !ir_branch LIKE gr_branch
        !ir_docnum LIKE gr_docnum .
    METHODS execute .
  PROTECTED SECTION.
private section.

  methods DATA_SELECTION .
  methods GET_NFE_ACCESS_KEY
    importing
      !IS_ACTIVE type J_1BNFE_ACTIVE
    changing
      !CV_ACCKEY type J_1B_NFE_ACCESS_KEY_DTEL44 .
  methods MANIFESTO_AUTOMATICO
    importing
      !IV_NFEID type /XNFE/ID .
  methods ERP_TASK_SET_TO_OK
    importing
      !IV_GUID type /XNFE/GUID_16
    exceptions
      ERROR_READING_NFE
      TECHNICAL_ERROR .
  methods SAVE_LOG .
ENDCLASS.



CLASS ZCLMM_NFE_MDFE_PROCESS IMPLEMENTATION.


  METHOD execute.

    data_selection( ).


    LOOP AT gt_header INTO DATA(ls_j_1bnfdoc).

      "  Nao processar notas entradas pelo SAP NFE
      CHECK NOT ( ls_j_1bnfdoc-nftype EQ 'AE'
        AND ls_j_1bnfdoc-autom_incoming EQ 'X' ).

      READ TABLE gt_active INTO DATA(ls_j_1bnfe_active)
              WITH TABLE KEY docnum = ls_j_1bnfdoc-docnum.


      get_nfe_access_key( EXPORTING is_active = ls_j_1bnfe_active
                           CHANGING cv_acckey = gv_acckey ).


      READ TABLE gt_header_rej
          WITH TABLE KEY docnum = ls_j_1bnfdoc-docnum
          TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0. " Reject
        gv_not_code = 'RECJECT2'.
      ELSE.
        CLEAR gv_not_code.
      ENDIF.


      manifesto_automatico( gv_acckey ).

      IF sy-subrc NE 0.
*        MESSAGE ID 'J1B_NFE' TYPE 'E' NUMBER '066' WITH gv_rfcdest.
      ENDIF.

*    ENDIF. " gv_xnfeactive

      CLEAR: gv_acckey, gv_not_code.

    ENDLOOP. " GT_HEADER




  ENDMETHOD.


  METHOD data_selection.

    DATA ls_nfdoc TYPE j_1bnfdoc.

    FIELD-SYMBOLS <fs_header> TYPE j_1bnfdoc.

    SELECT * INTO TABLE @gt_header
      FROM j_1bnfdoc
      WHERE pstdat    IN @gr_pstdat
        AND bukrs     IN @gr_bukrs
        AND branch    IN @gr_branch
        AND docnum    IN @gr_docnum
        AND model     EQ '55'   " Modelo 55 (NF-e)

        AND
        (
          (
            ( doctyp  EQ '1'      " Nota Fiscal
            OR  doctyp  EQ '6' )  " Restituicao
           AND ind_emit  EQ '1'   " Emissao terceiros
          )
        OR
          ( doctyp  EQ '6'         " Restituicao
           AND  ind_emit  EQ '0'   " Emissao propria
          )
        )

        AND nfe       EQ 'X'    " Is NF-e
        AND direct    EQ '1'    " Entrada
        AND docstat   EQ '1'    " Aprovada
        AND cancel    EQ ' '.   " Nao estornada


    IF gt_header IS NOT INITIAL.

      SELECT * INTO TABLE @DATA(lt_docs)
        FROM j_1bnfdoc
        FOR ALL ENTRIES IN @gt_header
        WHERE docnum IN ( SELECT docref
                            FROM j_1bnflin
                            WHERE docnum EQ @gt_header-docnum ).

    ENDIF.


    LOOP AT gt_header ASSIGNING <fs_header>.

      CHECK <fs_header>-doctyp EQ '6'
        AND <fs_header>-ind_emit EQ '0'.

      IF <fs_header>-docref IS INITIAL.

        ls_nfdoc = VALUE #( lt_docs[ docnum = <fs_header>-docnum ] OPTIONAL ).

        IF sy-subrc EQ 0.
          <fs_header>-docref = ls_nfdoc-docnum.
        ENDIF.

      ELSE.

        CALL FUNCTION 'J_1B_NF_READ_HEADER'
          EXPORTING
            docnum   = <fs_header>-docref
          IMPORTING
            f_header = ls_nfdoc
          EXCEPTIONS
            OTHERS   = 1.

      ENDIF.

      IF sy-subrc EQ 0 AND ls_nfdoc-ind_emit EQ '0'.
        INSERT ls_nfdoc     INTO TABLE gt_header.
        INSERT ls_nfdoc     INTO TABLE gt_header_rej.
        INSERT <fs_header>  INTO TABLE gt_header_rej.
      ELSE.
        DELETE gt_header  WHERE docnum EQ <fs_header>-docnum.
      ENDIF.


    ENDLOOP. " gt_header


    IF gt_header IS NOT INITIAL.

      SELECT * INTO TABLE gt_active
        FROM j_1bnfe_active
        FOR ALL ENTRIES IN gt_header
        WHERE docnum EQ gt_header-docnum.

    ENDIF.

  ENDMETHOD.


  METHOD get_nfe_access_key.
    DATA ls_acckey TYPE j_1b_nfe_access_key.

    MOVE-CORRESPONDING is_active TO ls_acckey.

    cv_acckey = ls_acckey.
  ENDMETHOD.


  METHOD constructor.

    gr_pstdat =  ir_pstdat.
    gr_bukrs  =  ir_bukrs .
    gr_branch =  ir_branch.
    gr_docnum =  ir_docnum.


  ENDMETHOD.


  METHOD manifesto_automatico.

    DATA ls_nfehd TYPE /xnfe/innfehd.

    DATA ls_action TYPE /xnfe/action_allowed_s.


    CALL FUNCTION '/XNFE/B2BNFE_READ_NFE_FOR_UPD'
      EXPORTING
        iv_nfe_id          = iv_nfeid
      IMPORTING
        es_nfehd           = ls_nfehd
      EXCEPTIONS
        nfe_does_not_exist = 1
        nfe_locked         = 2
        technical_error    = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
      EXIT. " Do nothing
    ENDIF.


* Check if process is completed or canceled
    IF  ls_nfehd-actstat EQ gc_actstat-stat89
     OR ls_nfehd-actstat EQ gc_actstat-stat88
     OR ls_nfehd-actstat EQ gc_actstat-stat99
     OR ls_nfehd-actstat EQ gc_actstat-stat98.
      EXIT. " Do nothing
    ENDIF.


    IF ls_nfehd-last_step EQ gc_procstep-sendopco. " Ja manifestado
      EXIT. " Do nothing
    ENDIF.



    CALL FUNCTION '/XNFE/GET_NEXT_STEP'
      EXPORTING
        iv_guid                = ls_nfehd-guid_header
        iv_doctype             = gc_doctype-nfe
        iv_direction           = gc_direction-inbd
      IMPORTING
        es_action              = ls_action
      EXCEPTIONS
        error_reading_document = 1
        OTHERS                 = 2.
    IF sy-subrc <> 0.
      DATA(lv_flag_error) = abap_true.
    ENDIF.


    IF ls_nfehd-proctyp EQ 'BUPRODET'. "NF-e sem atrib.processo empresarial
      gv_not_code = 'SIGNATUR'.
    ENDIF.

    IF gv_not_code IS INITIAL. " Completed

      IF ls_action-procstep EQ gc_procstep-erptasks. " Verificar atividades manuais

        TRY .
            erp_task_set_to_ok( iv_guid           =   ls_nfehd-guid_header ).
          CATCH cx_root.

        ENDTRY.
        IF sy-subrc <> 0.
          lv_flag_error = abap_true.
        ENDIF.

      ELSE. " Encerrar others

        CALL FUNCTION '/XNFE/NFE_SET_COMPLETED'
          EXPORTING
            iv_guid_header       = ls_nfehd-guid_header
            iv_infotext          = text-t01
            iv_trig_opco_evnt    = abap_true
          EXCEPTIONS
            no_proc_allowed      = 1
            error_reading_nfe    = 2
            error_creating_event = 3
            technical_error      = 4
            OTHERS               = 5.

        IF sy-subrc <> 0.
          lv_flag_error = abap_true.

        else.
          APPEND VALUE bapiret2( id = 'ZMM_NFE_MDE' number = 000 type = 'S' message_v1 = iv_nfeid ) TO gt_return.

          me->save_log( ).
        ENDIF.

      ENDIF.

    ELSE.                      " Rejected

      CALL FUNCTION '/XNFE/NFE_SET_REJECTED'
        EXPORTING
          iv_guid_header       = ls_nfehd-guid_header
          iv_not_code          = gv_not_code
*         IV_OVERWRITE         =
        EXCEPTIONS
          no_proc_allowed      = 1
          error_reading_nfe    = 2
          error_creating_event = 3
          technical_error      = 4
          OTHERS               = 5.

      IF sy-subrc <> 0.
        lv_flag_error = abap_true.
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD erp_task_set_to_ok.

    DATA:
      ls_innfehd    TYPE /xnfe/innfehd,
      lv_step       TYPE /xnfe/proc_step,
      lv_stepstat   TYPE /xnfe/stepstat,
      ls_stepresult TYPE /xnfe/step_result_s,
      lv_calls_erp  TYPE abap_bool,
      lv_is_manual  TYPE abap_bool,
      ls_action     TYPE /xnfe/action_allowed_s,
      ls_balmsg     TYPE bal_s_msg.


    CALL FUNCTION '/XNFE/B2BNFE_READ_NFE_FOR_UPD'
      EXPORTING
        iv_guid_header     = iv_guid
      IMPORTING
        es_nfehd           = ls_innfehd
      EXCEPTIONS
        nfe_does_not_exist = 1
        nfe_locked         = 2
        technical_error    = 3
        OTHERS             = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error_reading_nfe.
    ENDIF.

    CALL FUNCTION '/XNFE/GET_NEXT_STEP'
      EXPORTING
        iv_guid                = ls_innfehd-guid_header
        iv_doctype             = gc_doctype-nfe
        iv_direction           = gc_direction-inbd
      IMPORTING
        es_action              = ls_action
      EXCEPTIONS
        error_reading_document = 1
        OTHERS                 = 2.

    IF sy-subrc <> 0.
      DATA(lv_flag_error) = abap_true.
    ENDIF.

    IF ls_action-procstep NE gc_procstep-erptasks.
      RAISE technical_error.
    ENDIF.

    lv_step     = gc_procstep-erptasks. " Atividades manuais no ERP
    lv_stepstat = /xnfe/if_wd_constants=>cv_procstep_status-ok.


    ls_stepresult = /xnfe/cl_wd_util=>get_infotext_nfe(
        iv_proc_step    = lv_step
        iv_status_value = lv_stepstat
        iv_manual       = abap_true ).

    CALL FUNCTION '/XNFE/B2BNFE_SET_STEPRESULT'
      EXPORTING
        iv_guid_header       = ls_innfehd-guid_header
        iv_proc_step         = lv_step
        is_step_result       = ls_stepresult
      EXCEPTIONS
        nfe_does_not_exist   = 1
        nfe_locked           = 2
        procstep_not_allowed = 3
        no_proc_allowed      = 4
        technical_error      = 5
        OTHERS               = 6.

    IF sy-subrc <> 0.
      CALL FUNCTION '/XNFE/B2BNFE_DB_REVERT'.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING technical_error.
    ENDIF.

* store updated data to DB
    CALL FUNCTION '/XNFE/B2BNFE_SAVE_TO_DB'.
    CALL FUNCTION '/XNFE/COMMIT_WORK'.

* trigger follow up process steps
    CALL FUNCTION '/XNFE/NFE_PROCFLOW_EXECUTION'
      EXPORTING
        iv_guid_header    = ls_innfehd-guid_header
      EXCEPTIONS
        no_proc_allowed   = 1
        error_in_process  = 2
        technical_error   = 3
        error_reading_nfe = 4
        no_logsys         = 5
        OTHERS            = 6.

    CASE sy-subrc.
      WHEN 0.
      WHEN 1.
*     nothing to do
      WHEN OTHERS.
*--- To be treated in the monitor
*--- Write application log
        MOVE-CORRESPONDING sy TO ls_balmsg.
        ls_balmsg-detlevel  = '1'.
        ls_balmsg-probclass = '2'.
        CALL FUNCTION '/XNFE/BALLOG_CREATE_ADD_SAVE'
          EXPORTING
            iv_balobj = gc_balobj_proc_exec
            iv_sterm1 = gc_shortterm-nfe
            iv_sterm2 = gc_shortterm-inbd
            iv_guid   = ls_innfehd-guid_header
            is_msg    = ls_balmsg.
    ENDCASE.


  ENDMETHOD.


  METHOD save_log.

    DATA(ls_log) = VALUE bal_s_log( aluser    = sy-uname
                                    alprog    = sy-repid
                                    aldate    = sy-datum
                                    object    = gc_object
                                    subobject = gc_subobject
                                    ).
    CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
      EXPORTING
        is_log  = ls_log
*       IS_MSG  =
        it_msgs = gt_return.

    FREE: gt_return.

  ENDMETHOD.
ENDCLASS.
