class ZCLMM_ACCOUNTING_DISTRIBUTE definition
  public
  final
  create public .

public section.

*"* public components of class ZCLMM_ACCOUNTING_DISTRIBUTE
*"* do not include other source files here!!!
  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_MB_ACCOUNTING_DISTRIBUTE .
protected section.
*"* protected components of class ZCLMM_ACCOUNTING_DISTRIBUTE
*"* do not include other source files here!!!
private section.
*"* private components of class ZCLMM_ACCOUNTING_DISTRIBUTE
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCLMM_ACCOUNTING_DISTRIBUTE IMPLEMENTATION.


METHOD if_ex_mb_accounting_distribute~change_distribution.

* improve processing of MAA items with assigned serial numbers "n1788574

  DATA: ls_acc_new         TYPE accounting_badi,

        lt_acc_dyn         TYPE maa_tt_accounting_02,
        ls_acc_dyn         TYPE maa_s_accounting_line_02,

        ls_accounting      TYPE accounting,
        lt_accounting_work TYPE  accounting_t.

* begin -------------------------------------------------------"n1788574
* define working areas for reassigning the serial numbers
  DATA : lv_flag_reassign_serial TYPE  abap_bool,
         lv_flag_test            TYPE  abap_bool,

         lv_menge_serial_1       TYPE  mseg-menge,
         lv_menge_serial_2       TYPE  mseg-menge,

         lv_cnt_serial_assigned  TYPE  i,

         lt_serialnumber_work    TYPE  serialnumber_for_maa_t,
         lt_serialnumber_work_2  TYPE  serialnumber_for_maa_t,

         ls_e_serialnumber       LIKE  LINE OF e_serialnumber_for_maa,
         lv_matdoc_itm           TYPE  serialnumber_for_maa-matdoc_itm.

* working table for the quantities in entry unit before manual changes
  TYPES : BEGIN OF ts_erfmg_before,
            zekkn      TYPE  mseg-zekkn,
            quantity   TYPE  mseg-erfmg,
            share_prop TYPE  accounting-share_prop,
          END OF ts_erfmg_before,
          tt_erfmg_before TYPE STANDARD TABLE OF ts_erfmg_before.

  DATA : lt_erfmg_before TYPE  tt_erfmg_before,
         ls_erfmg_before LIKE  LINE OF lt_erfmg_before.



* working table for the number of required serial number in base unit
  TYPES : BEGIN OF ts_required,
            zekkn    TYPE  mseg-zekkn,
            quantity TYPE  i,
          END OF ts_required,
          tt_required TYPE STANDARD TABLE OF ts_required.

  DATA : lt_required TYPE  tt_required,
         ls_required LIKE  LINE OF lt_required.

  FIELD-SYMBOLS :
    <ls_i_serialnumber> LIKE  LINE OF i_serialnumber_for_maa,
    <ls_e_accounting>   LIKE  LINE OF e_accounting,
    <ls_required>       LIKE  LINE OF lt_required,
    <ls_erfmg_before>   LIKE  LINE OF lt_erfmg_before.

****VALIDAÇÔES PARA BADI
  IF sy-batch IS INITIAL
    AND sy-tcode = 'MIGO'
    AND i_mseg-bwart = 122.

* end ---------------------------------------------------------"78n18574
    CLEAR e_accounting.

* allow tests in debugging mode for incoming GR postings       "78n18574
    BREAK-POINT                ID  mb_maa.                  "78n18574
                                                            "78n18574
    IF  lv_flag_test IS INITIAL.                            "78n18574
* sample implementation only for goods issues (return deliveries)
* and no RETPO purchase order items
      IF i_mseg-shkzg EQ 'S'
       OR i_vm07m-retpo IS NOT INITIAL.
        RETURN.
      ENDIF.
    ENDIF.                                                  "78n18574

* begin -------------------------------------------------------"n1788574
    REFRESH                              e_serialnumber_for_maa.

* copy the input table with the serial numbers for changes, too and
* copy the serial numbers into woring table LT_SERIALNUMBER_WORK
    IF NOT i_serialnumber_for_maa[] IS INITIAL.
      LOOP AT i_serialnumber_for_maa     ASSIGNING  <ls_i_serialnumber>.
        MOVE  <ls_i_serialnumber>-matdoc_itm
                                         TO lv_matdoc_itm.

        IF NOT <ls_i_serialnumber>-serialno IS  INITIAL.
          APPEND <ls_i_serialnumber>     TO  lt_serialnumber_work.
        ENDIF.
      ENDLOOP.
    ENDIF.
* end ---------------------------------------------------------"n1788574

* select the entries for the current material document position
    LOOP AT i_accounting INTO  ls_accounting
      WHERE ebeln   = i_mseg-ebeln
        AND ebelp   = i_mseg-ebelp
        AND line_id = i_mseg-line_id.
      clear ls_accounting-share_prop.
      APPEND  ls_accounting    TO  lt_accounting_work.

*   begin -----------------------------------------------------"n1788574
*   calculate the incoming GR quantity in entry unit in a packed field
*   with 3 decimals for each AA and save it in working table
*   LT_ERFMG_BEFORE
      MOVE :  ls_accounting-zekkn        TO  ls_erfmg_before-zekkn,
              ls_accounting-share_prop   TO  ls_erfmg_before-share_prop.
      ls_erfmg_before-quantity = i_mseg-erfmg * ls_accounting-share_prop.
      APPEND  ls_erfmg_before            TO  lt_erfmg_before.
*   end -------------------------------------------------------"n1788574
    ENDLOOP.

    IF lt_accounting_work[] IS INITIAL.
      RETURN.                  " no matching entries found
    ELSE.                                                   "n1788574
      SORT lt_accounting_work            BY  ebeln ebelp zekkn. "n1788574
      SORT lt_erfmg_before               BY  zekkn.         "n1788574
    ENDIF.

    BREAK-POINT                ID  mb_maa.

** process dynpro for each MSEG item
*  CALL FUNCTION 'MBAA_MANUAL_DISTRIBUTE'
*    EXPORTING
*      is_mseg                      = i_mseg
*      is_dm07m                     = i_dm07m
*      is_vm07m                     = i_vm07m
*      is_mkpf                      = i_mkpf
*      it_accounting                = lt_accounting_work
*      it_accounting_back           = i_accounting_back          "1893687
*    IMPORTING
*      et_accounting                = lt_acc_dyn
*    EXCEPTIONS
*      bapi_active                  = 1
*      no_manual_distribution       = 2
*      no_matching_accounting_lines = 3
*      OTHERS                       = 4.

* process dynpro for each MSEG item
    CALL FUNCTION 'ZFMM_MBAA_MANUAL_DISTRIBUTE'
      EXPORTING
        is_mseg                      = i_mseg
        is_dm07m                     = i_dm07m
        is_vm07m                     = i_vm07m
        is_mkpf                      = i_mkpf
        it_accounting                = lt_accounting_work
        it_accounting_back           = i_accounting_back          "1893687
      IMPORTING
        et_accounting                = lt_acc_dyn
      EXCEPTIONS
        bapi_active                  = 1
        no_manual_distribution       = 2
        no_matching_accounting_lines = 3
        OTHERS                       = 4.

* begin -------------------------------------------------------"n1788574

    IF sy-subrc <> 0.
      RETURN.        " error occurred -> leave
    ENDIF.

    BREAK-POINT                          ID  mb_maa.

* the customer can implement specific coding here in order to change the
* assignment of the serial numbers - account assignments. The results
* such reassignments shall be stored in output table
* "E_SERIALNUMBER_FOR_MAA"

* check the changes and calculate new SHARE_PROP
*----------------------------------------------------------------------*
    LOOP AT lt_acc_dyn                   INTO  ls_acc_dyn.
      CLEAR                              ls_acc_new.
      MOVE-CORRESPONDING ls_acc_dyn      TO ls_acc_new.     "#EC ENHOK

*   read the AA entry before the dynpro and check whether the user
*   has changed the quantity
      READ TABLE lt_erfmg_before         ASSIGNING  <ls_erfmg_before>
        WITH KEY zekkn = ls_acc_dyn-zekkn
          BINARY SEARCH.

      IF sy-subrc <> 0.
        MESSAGE  e437(m7)                WITH 'CHANGE_DISTRIBUTION'
                                                'LT_ERFMG_BEFORE'.
        RETURN.      " error detected -> leave
      ENDIF.

      IF  <ls_erfmg_before>-quantity = ls_acc_dyn-quantity.
*     no change, take the old SHARE_PROP
        MOVE  <ls_erfmg_before>-share_prop   TO ls_acc_new-share_prop.
      ELSE.
*     the quantity was changed manually, calculate a new SHARE_PROP
        MOVE : abap_true                 TO  lv_flag_reassign_serial.
        ls_acc_new-share_prop  = ls_acc_dyn-quantity / i_mseg-erfmg.
      ENDIF.

      APPEND  ls_acc_new                 TO  e_accounting.
    ENDLOOP.

* are there serial numbers assigned to this GR PO ?
*----------------------------------------------------------------------*
    IF  i_serialnumber_for_maa[] IS INITIAL.
      RETURN.        " no serial numbers -> leave
    ENDIF.


* has the user filled the serial numbers manually directly into the
* output table table E_SERIALNUMBER_FOR_MAA ? consider these as results
*----------------------------------------------------------------------*
    IF NOT e_serialnumber_for_maa[] IS INITIAL.
      RETURN.        " serial numbers has been changed -> leave
    ENDIF.


* has the user changed the quantities manually ?
*----------------------------------------------------------------------*
    IF lv_flag_reassign_serial = abap_false.
*   the user has not changed the quantity, copy the serial numbers
      MOVE i_serialnumber_for_maa[]      TO  e_serialnumber_for_maa[].

      RETURN.   " no quantites changed, copy the serial numbers -> leave
    ENDIF.


* the serial number or XSAUT data have to be adapted automatically
* to the changed quantities and * the user did not change the serial
* numbers in this BAdI

    BREAK-POINT                          ID  mb_maa.

* calculate the new quantities in base unit on AA level for reassigning
* and save these in working table LT_REQUIRED
*----------------------------------------------------------------------*
    LOOP AT e_accounting                 ASSIGNING  <ls_e_accounting>
      WHERE  share_prop > 0.

*   calculate quantity in base unit for this AA line
      lv_menge_serial_1  = i_mseg-menge  * <ls_e_accounting>-share_prop.

*   check whether the GR quantities in base unit have decimals
      lv_menge_serial_2                  = lv_menge_serial_1 / 1000.
      lv_menge_serial_2                  = lv_menge_serial_2 * 1000.

      IF  lv_menge_serial_1 = lv_menge_serial_2.
*     quantity in base uint has no decimals
        MOVE :  <ls_e_accounting>-zekkn  TO  ls_required-zekkn,
                lv_menge_serial_2        TO  ls_required-quantity.
        APPEND  ls_required              TO  lt_required.
      ELSE.
        RETURN.      " error dected -> leave this method
      ENDIF.
    ENDLOOP.

    BREAK-POINT                          ID  mb_maa.

* try to reassign the available serial number to the new AA lines and
* set indicator XSAUT if there are not enough serial numbers
*----------------------------------------------------------------------*

    LOOP AT lt_required                  ASSIGNING  <ls_required>.
      CLEAR : lv_cnt_serial_assigned,    ls_e_serialnumber.
      REFRESH                            lt_serialnumber_work_2.

      IF  NOT lt_serialnumber_work[] IS INITIAL.
*     there are some serial numbers -> take them first
        DO  <ls_required>-quantity TIMES.

          READ TABLE lt_serialnumber_work
            INTO  ls_e_serialnumber
              INDEX  1.

          IF sy-subrc IS INITIAL.
*         serial number found -> assign it
            CLEAR                        ls_e_serialnumber-xsaut.
            MOVE    <ls_required>-zekkn  TO  ls_e_serialnumber-zekkn.
            APPEND  ls_e_serialnumber    TO  lt_serialnumber_work_2.
            ADD     1                    TO  lv_cnt_serial_assigned.
            DELETE  lt_serialnumber_work INDEX  1.
          ELSE.
            EXIT.    " no more serial numbers -> leave this DO ENDDO loop
          ENDIF.
        ENDDO.
      ENDIF.

*   evaluate the numner of assigned serial numbers
      IF      lv_cnt_serial_assigned = 0.
*     no serial numbers assigned
        MOVE : <ls_required>-zekkn       TO  ls_e_serialnumber-zekkn,
               lv_matdoc_itm             TO  ls_e_serialnumber-matdoc_itm,
               abap_true                 TO  ls_e_serialnumber-xsaut.
        APPEND  ls_e_serialnumber        TO  e_serialnumber_for_maa.

      ELSEIF  lv_cnt_serial_assigned = <ls_required>-quantity.
*     all required serial numbers could be assigned
        APPEND LINES OF lt_serialnumber_work_2
                                         TO  e_serialnumber_for_maa.

      ELSEIF  lv_cnt_serial_assigned < <ls_required>-quantity.
*     only some required serial numbers could be assigned
        LOOP AT lt_serialnumber_work_2   INTO  ls_e_serialnumber.
          MOVE : abap_true               TO  ls_e_serialnumber-xsaut.
          APPEND  ls_e_serialnumber      TO  e_serialnumber_for_maa.
        ENDLOOP.
      ENDIF.
    ENDLOOP.
* end ---------------------------------------------------------"n1788574
  ENDIF.
ENDMETHOD.
ENDCLASS.
