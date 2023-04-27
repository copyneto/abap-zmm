class ZCLMM_ANEXO_MONIT_SERV definition
  public
  final
  create public .

public section.

  methods ANEXAR
    importing
      !IV_FILENAME type STRING
      !IS_MEDIA type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MEDIA_RESOURCE
      !IS_KEY type ZTMM_ANEXO_NF
    exporting
      !EV_LINHA type ZE_NRO_LINHA
      !ET_RETURN type BAPIRET2_T .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_ANEXO_MONIT_SERV IMPLEMENTATION.


  METHOD anexar.

    DATA: ls_key TYPE ztmm_anexo_nf.

    CHECK is_key IS NOT INITIAL.

    SELECT MAX( linha )
      FROM ztmm_anexo_nf
     WHERE nr_nf    = @is_key-nr_nf
       AND cnpj_cpf = @is_key-cnpj_cpf
      INTO @DATA(lv_anexo).

    IF sy-subrc IS NOT INITIAL.
      lv_anexo = 0.
    ENDIF.

    ls_key-nr_nf    = is_key-nr_nf.
    ls_key-cnpj_cpf = is_key-cnpj_cpf.
    ls_key-linha    = lv_anexo + 1.
    ev_linha        = ls_key-linha.

    ls_key-filename = iv_filename.
    ls_key-mimetype = is_media-mime_type.
    ls_key-conteudo = is_media-value.

    ls_key-created_by      = sy-uname.
    ls_key-last_changed_by = sy-uname.

    GET TIME STAMP FIELD DATA(lv_ts).
    ls_key-created_at            = lv_ts.
    ls_key-last_changed_at       = lv_ts.
    ls_key-local_last_changed_at = lv_ts.

    MODIFY ztmm_anexo_nf FROM ls_key.
    IF sy-subrc IS INITIAL.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
