*&---------------------------------------------------------------------*
*& Include ZFSCMI_FB05_HID_MSG
*&---------------------------------------------------------------------*

" Na execução da classe pelo WF o programa exibe uma msg que quebra o Batch-Input standard
IF sy-uname EQ 'SAP_WFRT'.
  FREE: auttab[].
ENDIF.
