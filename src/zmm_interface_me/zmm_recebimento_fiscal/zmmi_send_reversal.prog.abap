*&---------------------------------------------------------------------*
*& Include          ZMMI_SEND_REVERSAL
*&---------------------------------------------------------------------*

CALL FUNCTION 'ZFMMM_RECEB_FISCAL'
  DESTINATION 'NONE'
  STARTING NEW TASK 'MM_SEND_FISCAL'
  EXPORTING
    iv_tcode              = sy-tcode
    it_mrmrseg            = ti_mrmrseg
  EXCEPTIONS
    communication_failure = 1
    system_failure        = 2
    resource_failure      = 3.

IF sy-subrc NE 0.
  RETURN.
ENDIF.
