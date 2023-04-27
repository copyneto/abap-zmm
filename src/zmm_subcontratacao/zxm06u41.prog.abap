*&---------------------------------------------------------------------*
*& Include          ZXM06U41
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF gc_param,
             modulo	TYPE ze_param_modulo VALUE 'MM',
             chave1	TYPE ze_param_chave VALUE 'GAP_292',
             chave2	TYPE ze_param_chave VALUE 'BSART',
             chave3	TYPE ze_param_chave_3 VALUE 'TP_PEDID',
           END OF gc_param.

SELECT sign, opt, low, high
  FROM ztca_param_val
  WHERE modulo = @gc_param-modulo
    AND chave1 = @gc_param-chave1
    AND chave2 = @gc_param-chave2
    AND chave3 = @gc_param-chave3
  INTO TABLE @DATA(lt_bsart).

gv_campos_sub = 2.

IF i_ekko-bsart IN lt_bsart.
  CASE i_aktyp.
    WHEN 'A'.
      gv_campos_sub = 0.
    WHEN 'V'.
      gv_campos_sub = 1. "Modify
  ENDCASE.
ENDIF.

if ci_ekpodb is INITIAL.
  MOVE-CORRESPONDING i_ci_ekpo TO ci_ekpodb.
ENDIF.

ekpo_ci = ci_ekpodb.
ekpo = i_ekpo.
