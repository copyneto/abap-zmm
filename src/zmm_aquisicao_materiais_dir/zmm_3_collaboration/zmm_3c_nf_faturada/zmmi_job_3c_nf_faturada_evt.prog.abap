*&---------------------------------------------------------------------*
*& Include          ZMMI_JOB_3C_NF_FATURADA_EVT
*&---------------------------------------------------------------------*
* ======================================================================
* Events
* ======================================================================
AT SELECTION-SCREEN OUTPUT.
  PERFORM f_manage_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_search_file_f4 USING    p_locl
                                    p_serv
                           CHANGING p_file.

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_tipo.
*  PERFORM f_search_file_f4_tipo.

INITIALIZATION.

  PERFORM f_init.

START-OF-SELECTION.

  PERFORM f_start.
