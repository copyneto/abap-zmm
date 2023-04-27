interface ZIF_ZF_CARGACERTA_VARI_CREATE
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
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
endinterface.
