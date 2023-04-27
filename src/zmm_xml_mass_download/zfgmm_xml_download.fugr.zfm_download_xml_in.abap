FUNCTION zfm_download_xml_in.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"     VALUE(IV_CNPJ_EMIT) TYPE  /XNFE/C_CNPJ OPTIONAL
*"     VALUE(IV_CNPJ_DEST) TYPE  /XNFE/E_CNPJ_CPF OPTIONAL
*"     VALUE(IV_UF_EMIT) TYPE  /XNFE/UF_EMIT OPTIONAL
*"     VALUE(IV_UF_DEST) TYPE  /XNFE/UF_DEST OPTIONAL
*"  TABLES
*"      T_NFEID TYPE  EFG_TAB_RANGES OPTIONAL
*"      T_NFXML TYPE  ZCTGMM_XML_DOWNLOAD OPTIONAL
*"      T_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  SELECT SINGLE header~nfeid, xml~xmlstring, header~nnf
    FROM /xnfe/innfehd AS header
   INNER JOIN /xnfe/inxml AS xml
      ON header~guid_header = xml~guid_header
   WHERE cnpj_emit EQ @iv_cnpj_emit AND
         cnpj_dest EQ @iv_cnpj_dest AND
         uf_emit   EQ @iv_uf_emit   AND
         uf_dest   EQ @iv_uf_dest   AND
         nfeid     IN @t_nfeid
    INTO @DATA(ls_inxml).

  IF sy-subrc EQ 0.

    APPEND INITIAL LINE TO t_nfxml ASSIGNING FIELD-SYMBOL(<fs_files>).
    CONCATENATE 'NFe_' ls_inxml-nfeid '.XML' INTO <fs_files>-filename.
    <fs_files>-filestring = ls_inxml-xmlstring.

  ELSE.

    APPEND VALUE #( BASE t_return id = |ZMM_MC_DOWNLOAD_XML| number = 002 type = if_abap_behv_message=>severity-error message_v1 = iv_docnum ) TO t_return. "ls_inxml-nnf

  ENDIF.

ENDFUNCTION.
