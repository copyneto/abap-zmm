interface ZIFMM_LIB_PGTO_GRAOVERDE_DESC
  public .


  methods BUILD
    importing
      !IV_TIPO type CHAR1 optional .
  methods CREATE
    importing
      !IV_TIPO type CHAR1
    returning
      value(RO_REF) type ref to ZIFMM_LIB_PGTO_GRAOVERDE_DESC .
endinterface.
