FUNCTION zfm_download_xml_cte.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM
*"  TABLES
*"      T_NFEID STRUCTURE  EFG_RANGES OPTIONAL
*"      T_NFXML TYPE  ZCTGMM_XML_DOWNLOAD OPTIONAL
*"      T_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  SELECT SINGLE header~cteid, cte~xmlstring, header~nct
    FROM /xnfe/inctexml AS cte
   INNER JOIN /xnfe/inctehd AS header
      ON cte~guid = header~guid
    INTO @DATA(ls_inxml)
   WHERE cteid IN @t_nfeid.

  IF sy-subrc EQ 0.

    APPEND INITIAL LINE TO t_nfxml ASSIGNING FIELD-SYMBOL(<fs_files>).
    CONCATENATE 'CTe_' ls_inxml-nct '.XML' INTO <fs_files>-filename.
    <fs_files>-filestring = ls_inxml-xmlstring.

  ELSE.

    APPEND VALUE #( BASE t_return id = |ZMM_MC_DOWNLOAD_XML| number = 003 type = if_abap_behv_message=>severity-warning message_v1 = iv_docnum ) TO t_return. "ls_inxml-nct

  ENDIF.

ENDFUNCTION.
