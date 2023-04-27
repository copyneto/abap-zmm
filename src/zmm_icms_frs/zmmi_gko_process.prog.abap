***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO:                                                        *
*** AUTOR    : Willian Hazor  – META                                  *
*** FUNCIONAL: Leandro – META                                      	  *
*** DATA     : 06/03/2023                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include ZMMI_ESCRT_NFE_GRAOVERDE
*&---------------------------------------------------------------------*


DATA: lv_acckey      TYPE J_1B_NFE_ACCESS_KEY_DTEL44.

IMPORT gko_acckey to lv_acckey from MEMORY ID zcltm_gko_process=>gc_memory_id-acckey.

IF sy-subrc IS INITIAL.

          DATA(ls_access_key) = CONV j_1b_nfe_access_key( lv_acckey ).
          MOVE-CORRESPONDING ls_access_key TO ls_active.


    IF gbobj_header[] IS NOT INITIAL.

      gbobj_header-authcod  = ls_active-authcod.
      gbobj_header-authdate = ls_active-authdate.
      gbobj_header-authtime = ls_active-authtime.

      gbobj_header[ 1 ]-authcod  = ls_active-authcod.
      gbobj_header[ 1 ]-authdate = ls_active-authdate.
      gbobj_header[ 1 ]-authtime = ls_active-authtime.
    ENDIF.

    CALL FUNCTION 'J_1B_NFE_DATA_READ'
      IMPORTING
        es_active = ls_active.

    ls_active-cdv     = lv_acckey+43(1).
    ls_active-docnum9 = ls_access_key-nfnum9.
    ls_active-tpemis  = ls_access_key-model.

    CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
      EXPORTING
        is_active = ls_active.

  ENDIF.
