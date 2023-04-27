"Name: \TY:CL_MM_PUR_SES_UPLOAD\ME:SUBMIT_FOR_APPROVAL\SE:BEGIN\EI
ENHANCEMENT 0 ZMMEI0018.
*Quando vier da função ZMM_PUR_SES_CREATE_BG desconsiderar envio para aprovação.
  DATA lv_only_create(1).

  IMPORT lv_only_create TO lv_only_create FROM MEMORY ID 'ZMM_ONLY_CREATE'. "EXPORT FM ZMM_PUR_SES_CREATE_BG
  IF lv_only_create EQ 'X'.
    EXPORT iv_ses FROM iv_ses TO MEMORY ID 'ZMM_SES'. "IMPORT FM ZMM_PUR_SES_CREATE_BG
    EXIT.
  ENDIF.

ENDENHANCEMENT.
