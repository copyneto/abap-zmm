interface ZIF_ZF_CARGACERTA_PARAM_QUERY
  public .


  types:
    MANDT type C length 000003 .
  types:
    begin of ZST_PLANLOG_PARAM,
      MANDT type MANDT,
      REPORT type C length 000040,
      PARAM type C length 000040,
      ZDESC type C length 000150,
    end of ZST_PLANLOG_PARAM .
  types:
    ZTTPLANLOG_PARAM               type standard table of ZST_PLANLOG_PARAM              with non-unique default key .
  types:
    CHAR30 type C length 000030 .
endinterface.
