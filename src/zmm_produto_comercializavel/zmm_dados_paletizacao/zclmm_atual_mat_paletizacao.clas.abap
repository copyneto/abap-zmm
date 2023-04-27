class ZCLMM_ATUAL_MAT_PALETIZACAO definition
  public
  final
  create public .

public section.

  methods ATUALIZA_MAT
    importing
      !IS_PALET type ZTMM_PALETIZACAO
    exporting
      !ES_RETURN type BAPIRET2 .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_ATUAL_MAT_PALETIZACAO IMPLEMENTATION.


  METHOD atualiza_mat.

    DATA: ls_header TYPE bapimathead,
          ls_plant  TYPE bapi_marc,
          ls_plantx TYPE bapi_marcx,
          ls_return TYPE bapiret2.

    DATA: lv_memory_id TYPE indx_srtfd.

    CONSTANTS: lc_sucess      TYPE sy-msgty VALUE 'S',
               lc_msg_mm      TYPE sy-msgid VALUE 'MM',
               lc_msg_nbm_suc TYPE sy-msgno VALUE '356'.

    SELECT matnr,
           werks,
           kautb
      FROM marc
      WHERE matnr = @is_palet-material
        AND werks = @is_palet-centro
       INTO @DATA(ls_marc)
         UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      ls_header-material      = ls_marc-matnr.
      ls_header-purchase_view = abap_true.
      ls_plant-plant          = ls_marc-werks.

*      IF ls_marc-kautb IS NOT INITIAL.
*        ls_plant-auto_p_ord = space.
*      ELSE.
*        ls_plant-auto_p_ord = abap_true.
*      ENDIF.
      IF ls_marc-kautb IS NOT INITIAL.
        ls_plant-auto_p_ord = abap_true.
      ELSE.
        ls_plant-auto_p_ord = space.
      ENDIF.

      ls_plantx-plant      = ls_marc-werks.
      ls_plantx-auto_p_ord = abap_true.

      lv_memory_id = |{ is_palet-material }{ sy-uname(4) }|.
      DATA(lv_werks) = is_palet-centro.
      EXPORT lv_werks FROM lv_werks TO DATABASE indx(zp) ID lv_memory_id.
      " Import na include ZXMGVU03

      CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
        EXPORTING
          headdata   = ls_header
          plantdata  = ls_plant
          plantdatax = ls_plantx
        IMPORTING
          return     = ls_return.

      IF ls_return-type   = lc_sucess
     AND ls_return-id     = lc_msg_mm
     AND ls_return-number = lc_msg_nbm_suc.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

*        ls_plant-auto_p_ord = ls_marc-kautb.
*        CLEAR ls_return.
*
*        CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
*          EXPORTING
*            headdata   = ls_header
*            plantdata  = ls_plant
*            plantdatax = ls_plantx
*          IMPORTING
*            return     = ls_return.
*
*        WAIT UP TO 3 SECONDS.
*
*        IF ls_return-type   = lc_sucess
*       AND ls_return-id     = lc_msg_mm
*       AND ls_return-number = lc_msg_nbm_suc.
*
*          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*            EXPORTING
*              wait = abap_true.
*
*        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
