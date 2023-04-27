FUNCTION zfmm_call_transaction.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_OUT) TYPE  ZSMM_ALIVIUM
*"     VALUE(IV_COLUNA) TYPE  CHAR30
*"----------------------------------------------------------------------
  CASE iv_coluna.
    WHEN 'MBLNR'.
      CHECK is_out-mblnr IS NOT INITIAL AND is_out-gjahr IS NOT INITIAL.
      SET PARAMETER ID 'MBN' FIELD is_out-mblnr.
      SET PARAMETER ID 'MJA' FIELD is_out-gjahr.
      CALL TRANSACTION 'MB03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    WHEN 'DOCNUM_ENTRADA'.
      CHECK is_out-docnum_entrada IS NOT INITIAL.
      SET PARAMETER ID 'JEF' FIELD is_out-docnum_entrada.
      CALL TRANSACTION 'J1B3N' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    WHEN 'DOCNUM_SAIDA'.
      CHECK is_out-docnum_saida IS NOT INITIAL.
      SET PARAMETER ID 'JEF' FIELD is_out-docnum_saida.
      CALL TRANSACTION 'J1B3N' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    WHEN 'BELNR'.
      CHECK is_out-belnr IS NOT INITIAL AND is_out-bukrs IS NOT INITIAL AND is_out-gjahr IS NOT INITIAL.
      SET PARAMETER ID 'BLN' FIELD is_out-belnr.
      SET PARAMETER ID 'BUK' FIELD is_out-bukrs.
      SET PARAMETER ID 'GJR' FIELD is_out-gjahr.
      CALL TRANSACTION 'FB03' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    WHEN 'IBLNR'.
      CHECK is_out-iblnr IS NOT INITIAL AND is_out-gjahr IS NOT INITIAL.
      SET PARAMETER ID 'IBN' FIELD is_out-iblnr.
      SET PARAMETER ID 'GJA' FIELD is_out-gjahr.
      CALL TRANSACTION 'MI06' WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.


ENDFUNCTION.
