***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Ajustes NFE - Grão Verde                               *
*** AUTOR    : Alysson Anjos – META                                   *
*** FUNCIONAL: Ricardo Meotti – META                               	  *
*** DATA     : 08/08/2022                                             *
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

DATA: ls_hd     TYPE /xnfe/innfehd,
      ls_active TYPE j_1bnfe_active.

DATA: lv_memory_id TYPE indx_srtfd,
      lv_guid      TYPE /xnfe/guid_16.

lv_memory_id = |{ 'GV-' }{ gbobj_header-nfenum }|.
IMPORT lv_guid TO lv_guid FROM DATABASE indx(zm) ID lv_memory_id.
" Export no método ZCLMM_RET_ARM_GV~RETORNO

IF sy-subrc IS INITIAL.

  DATA(lo_object) = NEW cl_abap_expimp_db( ).

  TRY.
      lo_object->delete( EXPORTING tabname          = 'INDX'
                                   client           = sy-mandt
                                   area             = 'ZM'
                                   id               = lv_memory_id
                                   client_specified = abap_true ).

    CATCH cx_sy_client.        " EXPORT/IMPORT: Wrong CLIENT Specification
    CATCH cx_sy_generic_key.   " EXPORT/IMPORT: Incorrect Use of GENERIC
    CATCH cx_sy_incorrect_key. " EXPORT/IMPORT: The Given Key Is not Properly Formed
  ENDTRY.

  CALL FUNCTION '/XNFE/B2BNFE_READ'
    EXPORTING
      iv_guid_header     = lv_guid
      with_enqueue       = space
    IMPORTING
      es_nfehd           = ls_hd
    EXCEPTIONS
      nfe_does_not_exist = 1
      nfe_locked         = 2
      technical_error    = 3
      OTHERS             = 4.

  IF sy-subrc IS INITIAL.
    IF gbobj_header[] IS NOT INITIAL.

      gbobj_header-authcod  = ls_hd-nprot.
      gbobj_header-authdate = ls_hd-dhemi(8).
      gbobj_header-authtime = ls_hd-dhrecbto+8(6).

      gbobj_header[ 1 ]-authcod  = ls_hd-nprot.
      gbobj_header[ 1 ]-authdate = ls_hd-dhemi(8).
      gbobj_header[ 1 ]-authtime = ls_hd-dhrecbto+8(6).
    ENDIF.

    CALL FUNCTION 'J_1B_NFE_DATA_READ'
      IMPORTING
        es_active = ls_active.

    ls_active-cdv     = ls_hd-nfeid+43(1).
    ls_active-docnum9 = |{ ls_hd-tpemis }{ ls_hd-nfeid+35(8) }|.
    ls_active-tpemis  = ls_hd-tpemis.

    CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
      EXPORTING
        is_active = ls_active.

  ENDIF.
ENDIF.
