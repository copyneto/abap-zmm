FUNCTION zfm_read_xml_cte.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM OPTIONAL
*"     VALUE(IV_LOCAL) TYPE  BOOLE_D DEFAULT ABAP_FALSE
*"     VALUE(IV_FILEPATH) TYPE  STRING DEFAULT '/usr/sap/tmp/'
*"  EXPORTING
*"     VALUE(EV_SUBRC) TYPE  NUMC1
*"  TABLES
*"      T_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  DATA lt_nfxml TYPE zctgmm_xml_download.

  ev_subrc = 0.

  SELECT SINGLE j~docnum, j~nfenum, j~pstdat, j~docdat, j~bukrs, j~branch,
         xhd~cnpj_emit AS emissor_nfis, xhd~c_xnome AS emissor, xhd~uf_emit AS emissor_uf,
         xhd~cnpj_dest AS recebe_nfis, xhd~c_xnome AS recebedor, xhd~uf_dest AS recebe_uf,
         concat( a~regio, concat( a~nfyear, concat( a~nfmonth, concat( a~stcd1, concat( a~model, concat( a~serie, concat( a~nfnum9, concat( a~docnum9, a~cdv ) ) ) ) ) ) ) ) AS accesskey
    FROM j_1bnfe_active AS a
   INNER JOIN j_1bnfdoc AS j
      ON a~docnum = j~docnum
   INNER JOIN /xnfe/innfehd AS xhd
      ON j~nfenum = xhd~nnf
   WHERE a~docnum = @iv_docnum
    INTO @DATA(ls_active).

  SELECT SINGLE header~cteid, cte~xmlstring, header~nct
    FROM /xnfe/inctexml AS cte
   INNER JOIN /xnfe/inctehd AS header
      ON cte~guid = header~guid
   WHERE cteid = @ls_active-accesskey
    INTO @DATA(ls_cte).

  IF sy-subrc NE 0.

    APPEND VALUE #( id = 'ZMM_MC_DOWNLOAD_XML' number = 003 type = if_abap_behv_message=>severity-error message_v1 = iv_docnum ) TO t_return.
    ev_subrc = 3.

  ELSE.

    IF iv_local EQ abap_true.

      APPEND INITIAL LINE TO lt_nfxml ASSIGNING FIELD-SYMBOL(<fs_files>).
      CONCATENATE 'CTe_' ls_cte-nct '.XML' INTO <fs_files>-filename.
      CONCATENATE iv_filepath '/' <fs_files>-filename INTO DATA(lv_filename).

      CALL FUNCTION 'ECATT_CONV_XSTRING_TO_STRING'
        EXPORTING
          im_xstring = ls_cte-xmlstring
        IMPORTING
          ex_string  = <fs_files>-filestring.

      OPEN DATASET lv_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

      IF sy-subrc NE 0.
        APPEND VALUE #( BASE t_return id = |ZMM_MC_DOWNLOAD_XML| number = 005 type = if_abap_behv_message=>severity-error message_v1 = iv_docnum message_v2 = iv_filepath ) TO t_return.
        ev_subrc = 5.
      ELSE.
        TRANSFER <fs_files>-filestring TO lv_filename.
        CLOSE DATASET lv_filename.
        APPEND VALUE #( BASE t_return id = |ZMM_MC_DOWNLOAD_XML| number = 006 type = if_abap_behv_message=>severity-success message_v1 = iv_docnum ) TO t_return.
        ev_subrc = 6.
      ENDIF.

    ENDIF.

  ENDIF.

ENDFUNCTION.
