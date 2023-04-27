FUNCTION zfmmm_po_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_POHEADER) LIKE  BAPIMEPOHEADER STRUCTURE
*"        BAPIMEPOHEADER
*"     VALUE(IS_POHEADERX) LIKE  BAPIMEPOHEADERX STRUCTURE
*"        BAPIMEPOHEADERX OPTIONAL
*"     VALUE(IS_POADDRVENDOR) LIKE  BAPIMEPOADDRVENDOR STRUCTURE
*"        BAPIMEPOADDRVENDOR OPTIONAL
*"     VALUE(IV_TESTRUN) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_MEMORY_UNCOMPLETE) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_MEMORY_COMPLETE) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IS_POEXPIMPHEADER) LIKE  BAPIEIKP STRUCTURE  BAPIEIKP
*"       OPTIONAL
*"     VALUE(IS_POEXPIMPHEADERX) LIKE  BAPIEIKPX STRUCTURE  BAPIEIKPX
*"       OPTIONAL
*"     VALUE(IS_VERSIONS) LIKE  BAPIMEDCM STRUCTURE  BAPIMEDCM OPTIONAL
*"     VALUE(IV_NO_MESSAGING) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_NO_MESSAGE_REQ) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_NO_AUTHORITY) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_NO_PRICE_FROM_PO) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_PARK_COMPLETE) TYPE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_PARK_UNCOMPLETE) TYPE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_TIPO_OPERACAO) TYPE  BSARK OPTIONAL
*"  EXPORTING
*"     VALUE(EV_EXPPURCHASEORDER) LIKE  BAPIMEPOHEADER-PO_NUMBER
*"     VALUE(ES_EXPHEADER) LIKE  BAPIMEPOHEADER STRUCTURE
*"        BAPIMEPOHEADER
*"     VALUE(ES_EXPPOEXPIMPHEADER) LIKE  BAPIEIKP STRUCTURE  BAPIEIKP
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"      IT_POITEM STRUCTURE  BAPIMEPOITEM OPTIONAL
*"      IT_POITEMX STRUCTURE  BAPIMEPOITEMX OPTIONAL
*"      IT_POADDRDELIVERY STRUCTURE  BAPIMEPOADDRDELIVERY OPTIONAL
*"      IT_POSCHEDULE STRUCTURE  BAPIMEPOSCHEDULE OPTIONAL
*"      IT_POSCHEDULEX STRUCTURE  BAPIMEPOSCHEDULX OPTIONAL
*"      IT_POACCOUNT STRUCTURE  BAPIMEPOACCOUNT OPTIONAL
*"      IT_POACCOUNTPROFITSEGMENT STRUCTURE
*"        BAPIMEPOACCOUNTPROFITSEGMENT OPTIONAL
*"      IT_POACCOUNTX STRUCTURE  BAPIMEPOACCOUNTX OPTIONAL
*"      IT_POCONDHEADER STRUCTURE  BAPIMEPOCONDHEADER OPTIONAL
*"      IT_POCONDHEADERX STRUCTURE  BAPIMEPOCONDHEADERX OPTIONAL
*"      IT_POCOND STRUCTURE  BAPIMEPOCOND OPTIONAL
*"      IT_POCONDX STRUCTURE  BAPIMEPOCONDX OPTIONAL
*"      IT_POLIMITS STRUCTURE  BAPIESUHC OPTIONAL
*"      IT_POCONTRACTLIMITS STRUCTURE  BAPIESUCC OPTIONAL
*"      IT_POSERVICES STRUCTURE  BAPIESLLC OPTIONAL
*"      IT_POSRVACCESSVALUES STRUCTURE  BAPIESKLC OPTIONAL
*"      IT_POSERVICESTEXT STRUCTURE  BAPIESLLTX OPTIONAL
*"      IT_EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"      IT_EXTENSIONOUT STRUCTURE  BAPIPAREX OPTIONAL
*"      IT_POEXPIMPITEM STRUCTURE  BAPIEIPO OPTIONAL
*"      IT_POEXPIMPITEMX STRUCTURE  BAPIEIPOX OPTIONAL
*"      IT_POTEXTHEADER STRUCTURE  BAPIMEPOTEXTHEADER OPTIONAL
*"      IT_POTEXTITEM STRUCTURE  BAPIMEPOTEXT OPTIONAL
*"      IT_ALLVERSIONS STRUCTURE  BAPIMEDCM_ALLVERSIONS OPTIONAL
*"      IT_POPARTNER STRUCTURE  BAPIEKKOP OPTIONAL
*"      IT_POCOMPONENTS STRUCTURE  BAPIMEPOCOMPONENT OPTIONAL
*"      IT_POCOMPONENTSX STRUCTURE  BAPIMEPOCOMPONENTX OPTIONAL
*"      IT_POSHIPPING STRUCTURE  BAPIITEMSHIP OPTIONAL
*"      IT_POSHIPPINGX STRUCTURE  BAPIITEMSHIPX OPTIONAL
*"      IT_POSHIPPINGEXP STRUCTURE  BAPIMEPOSHIPPEXP OPTIONAL
*"      IT_SERIALNUMBER STRUCTURE  BAPIMEPOSERIALNO OPTIONAL
*"      IT_SERIALNUMBERX STRUCTURE  BAPIMEPOSERIALNOX OPTIONAL
*"      IT_INVPLANHEADER STRUCTURE  BAPI_INVOICE_PLAN_HEADER OPTIONAL
*"      IT_INVPLANHEADERX STRUCTURE  BAPI_INVOICE_PLAN_HEADERX OPTIONAL
*"      IT_INVPLANITEM STRUCTURE  BAPI_INVOICE_PLAN_ITEM OPTIONAL
*"      IT_INVPLANITEMX STRUCTURE  BAPI_INVOICE_PLAN_ITEMX OPTIONAL
*"      IT_NFMETALLITMS STRUCTURE  /NFM/BAPIDOCITM OPTIONAL
*"----------------------------------------------------------------------
  IF iv_tipo_operacao = 'INT4'.
    DATA(lv_tipo_operacao) = iv_tipo_operacao.
    EXPORT lv_tipo_operacao FROM lv_tipo_operacao TO MEMORY ID 'COCKPIT_TRANS_TP_OPER'.
  ENDIF.

  CALL FUNCTION 'BAPI_PO_CREATE1'
    EXPORTING
      poheader               = is_poheader
      poheaderx              = is_poheaderx
      poaddrvendor           = is_poaddrvendor
      testrun                = iv_testrun
      memory_uncomplete      = iv_memory_uncomplete
      memory_complete        = iv_memory_complete
      poexpimpheader         = is_poexpimpheader
      poexpimpheaderx        = is_poexpimpheaderx
      versions               = is_versions
      no_messaging           = iv_no_messaging
      no_message_req         = iv_no_message_req
      no_authority           = iv_no_authority
      no_price_from_po       = iv_no_price_from_po
      park_complete          = iv_park_complete
      park_uncomplete        = iv_park_uncomplete
    IMPORTING
      exppurchaseorder       = ev_exppurchaseorder
      expheader              = es_expheader
      exppoexpimpheader      = es_exppoexpimpheader
    TABLES
      return                 = et_return
      poitem                 = it_poitem
      poitemx                = it_poitemx
      poaddrdelivery         = it_poaddrdelivery
      poschedule             = it_poschedule
      poschedulex            = it_poschedulex
      poaccount              = it_poaccount
      poaccountprofitsegment = it_poaccountprofitsegment
      poaccountx             = it_poaccountx
      pocondheader           = it_pocondheader
      pocondheaderx          = it_pocondheaderx
      pocond                 = it_pocond
      pocondx                = it_pocondx
      polimits               = it_polimits
      pocontractlimits       = it_pocontractlimits
      poservices             = it_poservices
      posrvaccessvalues      = it_posrvaccessvalues
      poservicestext         = it_poservicestext
      extensionin            = it_extensionin
      extensionout           = it_extensionout
      poexpimpitem           = it_poexpimpitem
      poexpimpitemx          = it_poexpimpitemx
      potextheader           = it_potextheader
      potextitem             = it_potextitem
      allversions            = it_allversions
      popartner              = it_popartner
      pocomponents           = it_pocomponents
      pocomponentsx          = it_pocomponentsx
      poshipping             = it_poshipping
      poshippingx            = it_poshippingx
      poshippingexp          = it_poshippingexp
      serialnumber           = it_serialnumber
      serialnumberx          = it_serialnumberx
      invplanheader          = it_invplanheader
      invplanheaderx         = it_invplanheaderx
      invplanitem            = it_invplanitem
      invplanitemx           = it_invplanitemx
      nfmetallitms           = it_nfmetallitms.

  IF ev_exppurchaseorder IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
