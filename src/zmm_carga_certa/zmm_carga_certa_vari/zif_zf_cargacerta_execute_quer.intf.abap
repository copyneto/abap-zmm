interface ZIF_ZF_CARGACERTA_EXECUTE_QUER
  public .


  types:
    BALFIELD type C length 000100 .
  types:
    TVARV_OPTI type C length 000002 .
  types:
    begin of ZSPLANLOG_VARI,
      REPORT type C length 000030,
      VARI type C length 000030,
      FIELD type C length 000030,
      CONT type C length 000005,
      LOW type BALFIELD,
      OPTI type TVARV_OPTI,
      HIGH type BALFIELD,
      OPTI_DESC type C length 000030,
    end of ZSPLANLOG_VARI .
  types:
    ZTTPLANLOG_VARI                type standard table of ZSPLANLOG_VARI                 with non-unique default key .
  types:
    CHAR30 type C length 000030 .
endinterface.
