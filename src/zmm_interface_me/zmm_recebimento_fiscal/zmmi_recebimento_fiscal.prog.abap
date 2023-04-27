*&---------------------------------------------------------------------*
*& Include          ZMMI_RECEBIMENTO_FISCAL
*&---------------------------------------------------------------------*

*IF e_belnr IS NOT INITIAL.
*
*  CALL FUNCTION 'ZFMMM_RECEB_FISCAL'
*    DESTINATION 'NONE'
*    STARTING NEW TASK 'MM_SEND_FISCAL'
*    EXPORTING
*      iv_belnr              = e_belnr
*    EXCEPTIONS
*      communication_failure = 1
*      system_failure        = 2
*      resource_failure      = 3.
*
*  IF sy-subrc NE 0.
*    RETURN.
*  ENDIF.
*
*ENDIF.
