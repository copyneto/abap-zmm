"Name: \TY:CL_LOGBR_ABRASF_DET\ME:DETERMINE_LC116_BY_MAT_NUMBER\SE:BEGIN\EI
ENHANCEMENT 0 ZMMEI0025.
*Determinação do tipo de serviço pelo NCM (LC_)

 DATA: lv_steuc        TYPE marc-steuc,
       lv_lc116        TYPE fist-searchw,
       lv_lc116_aux(4).

 SELECT SINGLE steuc INTO lv_steuc
 FROM marc WHERE matnr = material_number AND
                 steuc <> space.

 IF lv_steuc(3) = 'LC_'.

   lv_lc116 = lv_steuc+3(5).

   CALL FUNCTION 'SF_SPECIALCHAR_DELETE'
     EXPORTING
       with_specialchar    = lv_lc116
     IMPORTING
       without_specialchar = lv_lc116.

   lv_lc116_aux = lv_lc116(4).

   CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
     EXPORTING
       input  = lv_lc116_aux
     IMPORTING
       output = lv_lc116_aux.

   CONCATENATE lv_lc116_aux(2) '.' lv_lc116_aux+2(2) INTO lc116_service_code.

 ENDIF.

ENDENHANCEMENT.
