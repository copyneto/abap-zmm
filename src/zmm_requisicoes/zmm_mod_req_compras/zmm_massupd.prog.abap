***********************************************************************
***                           © 3corações                           ***
***********************************************************************
*** DESCRIÇÃO: ZMM_MASSUPD                                            *
*** AUTOR : Thiago Lopes – 3corações                                  *
*** FUNCIONAL: Johnatan Cruz – DK                                     *
*** DATA : 31.05.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
REPORT zmm_massupd.

TABLES: eban.

TYPES: BEGIN OF ty_eban,
         banfn        TYPE banfn,
         bnfpo        TYPE bnfpo,
         estkz        TYPE estkz,
         frgzu        TYPE frgzu,
         loekz        TYPE loekz,
         banpr        TYPE banpr,
         lfdat        TYPE lfdat,
         creationdate TYPE creationdate,
       END OF ty_eban.

DATA: gs_eban TYPE ty_eban,
      gt_eban TYPE TABLE OF ty_eban.

SELECT-OPTIONS: s_banfn FOR gs_eban-banfn,
s_crtdat FOR gs_eban-creationdate.
PARAMETERS: p_teste TYPE testrun DEFAULT abap_true.

* SELECT * FROM eban
* INTO CORRESPONDING FIELDS OF TABLE it_eban
* WHERE banfn IN s_banfn.

SELECT * FROM eban
 INTO CORRESPONDING FIELDS OF TABLE gt_eban
 WHERE ( estkz = 'B' OR estkz = 'U' )
 AND frgzu = ''
 AND loekz = ''
 AND banpr = '02'
 AND banfn IN s_banfn
 AND creationdate IN s_crtdat.

IF p_teste = abap_true.

  PERFORM f_exibir_tabela USING gt_eban.

ELSE.

  PERFORM f_atualizar_dados.

ENDIF.

*&---------------------------------------------------------------------*
*&      Form ATUALIZAR_DADOS
*&---------------------------------------------------------------------*
FORM f_atualizar_dados.
  LOOP AT gt_eban INTO gs_eban.                    "#EC CI_LOOP_INTO_WA
    DATA: ls_start_info TYPE cl_apj_rt_job_scheduling_api=>ty_start_info.

    DATA: ls_parameters TYPE if_apj_rt_types=>tt_job_parameter_value.
    DATA: ls_parameter TYPE if_apj_rt_types=>ty_job_parameter_value.

*  DATA: ls_range TYPE if_apj_rt_types=>tt_value_range.

    DATA: lr_xis TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_ekorg TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_inclsn TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_select TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_comm TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_lfdat TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lr_banfn TYPE  if_apj_rt_types=>tt_value_range.
    DATA: lv_aux TYPE lfdat.

    ls_start_info-start_immediately = abap_true.
*  ls_range = VALUE #( ( sign = 'I' option = 'EQ' low = '321' high = '' ) ).


    lr_xis    = VALUE #( ( sign = 'I' option = 'EQ' low = 'X' high = '' ) ).
    lr_ekorg = VALUE #( ( sign = 'I' option = 'EQ' low = 'OC01' ) ).
    lr_inclsn = VALUE #( ( sign = 'I' option = 'EQ' low = |{ gs_eban-banfn }/{ gs_eban-bnfpo }| ) ).
    lr_select = VALUE #( ( sign = 'I' option = 'EQ' low = ' ' ) ).
    lr_comm   = VALUE #( ( sign = 'I' option = 'EQ' low = 'Job modificação em massa' ) ) ##NO_TEXT.
    lv_aux = gs_eban-lfdat - 1.
    lr_lfdat  = VALUE #( ( sign = 'I' option = 'EQ' low = lv_aux ) ).
    lr_banfn  = VALUE #( ( sign = 'I' option = 'EQ' low = gs_eban-banfn ) ).

    ls_parameters = VALUE #(
     ( name = 'P_EKORG' t_value = lr_ekorg )
     ( name = 'P_EKORGX' t_value = lr_xis )
     ( name = 'S_INCLSN' t_value = lr_inclsn )
     ( name = 'P_SELECT' t_value = lr_select )
     ( name = 'P_COMM'   t_value = lr_comm )
     ( name = 'P_COMMX'  t_value = lr_xis )
     ( name = 'P_LFDAT'  t_value = lr_lfdat )
     ( name = 'P_LFDATX'  t_value = lr_xis )
     ( name = 'S_BANFN'  t_value = lr_banfn )
    ).

    TRY.
        CALL METHOD cl_apj_rt_job_scheduling_api=>schedule_job "#EC CI_SROFC_NESTED
          EXPORTING                                            "#EC CI_IMUD_NESTED
            iv_job_template_name   = 'SAP_MM_PUR_MASSPRBG_T'   "#EC CI_EXEC_SQL_NESTED
            iv_job_text            = |Modificação na RC { gs_eban-banfn } no item { gs_eban-bnfpo }| ##NO_TEXT
            is_start_info          = ls_start_info
*           is_end_info            =
*           is_scheduling_info     =
            it_job_parameter_value = ls_parameters
*           iv_adjust_start_info   =
            iv_username            = sy-uname
*           iv_test_mode           =
          IMPORTING
            et_message             = DATA(lt_messages)
            es_job_details         = DATA(ls_job_details).


*        cl_demo_output=>write( lt_messages ).
*        cl_demo_output=>write( ts_job_details ).
*        cl_demo_output=>display( ).
        WRITE:/ |Modificação na RC { gs_eban-banfn } no item { gs_eban-bnfpo }| ##NO_TEXT.

      CATCH cm_apj_base.
*        cl_demo_output=>write( 'Catch' ).
*        cl_demo_output=>display( ).
    ENDTRY.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form EXIBIR_TABELA
*&---------------------------------------------------------------------*
FORM f_exibir_tabela USING ut_tabela TYPE any .
  DATA: lr_table     TYPE REF TO cl_salv_table.

  TRY.
      cl_salv_table=>factory( IMPORTING r_salv_table = lr_table
                              CHANGING t_table = ut_tabela ).
    CATCH cx_salv_msg  ##NO_HANDLER.
  ENDTRY.

  DATA: lr_functions  TYPE REF TO cl_salv_functions_list,
        lr_display    TYPE REF TO cl_salv_display_settings,
        lr_selections TYPE REF TO cl_salv_selections.

  lr_functions = lr_table->get_functions( ).
  lr_functions->set_all( abap_true ).

  lr_display = lr_table->get_display_settings( ).
  lr_display->set_striped_pattern( abap_true ).

  lr_selections = lr_table->get_selections( ).
  lr_selections->set_selection_mode( if_salv_c_selection_mode=>cell ).

*... §4 set layout
  DATA: lr_layout TYPE REF TO cl_salv_layout,
        ls_key    TYPE salv_s_layout_key.

  lr_layout = lr_table->get_layout( ).

*... §4.1 set the Layout Key
  ls_key-report = sy-repid.
  lr_layout->set_key( ls_key ).


*... §4.2 set usage of default Layouts
*  lr_layout->set_default( gs_test-default ).

*... §4.3 set Layout save restriction
  lr_layout->set_save_restriction( cl_salv_layout=>restrict_none ).

*  lr_sel_mult  = lr_table->get_selections( ).
*  lr_sel_mult->set_selection_mode( if_salv_c_selection_mode=>row_column ).

  lr_table->display( ).

ENDFORM.
