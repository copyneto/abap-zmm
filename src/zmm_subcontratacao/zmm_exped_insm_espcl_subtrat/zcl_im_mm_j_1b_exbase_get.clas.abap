class ZCL_IM_MM_J_1B_EXBASE_GET definition
  public
  final
  create public .

public section.

  interfaces IF_EX_J_1B_EXBASE_GET .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MM_J_1B_EXBASE_GET IMPLEMENTATION.


  METHOD if_ex_j_1b_exbase_get~get_price.

    FIELD-SYMBOLS:
    <fs_armaz_key> TYPE zsmm_armaz_key,
    <fs_msegdmbtr> type mseg,
    <fs_DM07Mdmbtr> type DM07M.

    ASSIGN ('(SAPLZFGMM_PICKING)GS_ARMAZ_KEY') TO <fs_armaz_key>.
    ASSIGN ('(SAPLJ1BN)MSEG') TO <fs_msegdmbtr>.
    ASSIGN ('(SAPLMBGB)DM07M') TO <fs_DM07Mdmbtr>.


    IF <fs_armaz_key> IS ASSIGNED.

      SELECT SINGLE nfnett FROM j_1bnflin
        WHERE docnum EQ @<fs_armaz_key>-docnum
          AND itmnum EQ @<fs_armaz_key>-itmnum
        INTO @DATA(lv_nfnett).

      IF sy-subrc EQ 0.
        e_exbase = lv_nfnett.
        if <fs_msegdmbtr> is ASSIGNED.
           <fs_msegdmbtr>-DMBTR = lv_nfnett.
        endif.
        if <fs_DM07Mdmbtr> is ASSIGNED.
          <fs_DM07Mdmbtr>-exwrt = lv_nfnett.
        endif.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
