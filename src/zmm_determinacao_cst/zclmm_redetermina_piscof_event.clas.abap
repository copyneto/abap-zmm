CLASS zclmm_redetermina_piscof_event DEFINITION INHERITING FROM cl_abap_behv
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_nflin.     "NF line items createt via bseg
             INCLUDE TYPE j_1bnflin.
    TYPES:   msegflag TYPE flag.
    TYPES: END OF ty_nflin.

    TYPES: ty_t_nflin TYPE STANDARD TABLE OF ty_nflin.

    TYPES: ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_mm_redetermina_piscof.

    TYPES: BEGIN OF ty_rule.
             INCLUDE TYPE zi_mm_redetermina_piscof.
    TYPES:   rule_count TYPE i.
    TYPES: END OF ty_rule.

    TYPES: ty_t_rule TYPE STANDARD TABLE OF ty_rule.

    TYPES: ty_data   TYPE zi_mm_dados_nf_redeterm,

           ty_t_data TYPE SORTED TABLE OF ty_data
                     WITH UNIQUE KEY docnum itmnum.

    CONSTANTS:
      "! Campos do Objeto de Autorização
      BEGIN OF gc_auth,
        object TYPE gc_object VALUE 'ZMMMTABLE',
        actvt  TYPE fieldname VALUE 'ACTVT',
        table  TYPE fieldname VALUE 'TABLE',
      END OF gc_auth,

      "! Ações básicas do Objeto de Autorização
      BEGIN OF gc_actvt,
        anexar_criar TYPE char2 VALUE '01',
        modificar    TYPE char2 VALUE '02',
        exibir       TYPE char2 VALUE '03',
        eliminar     TYPE char2 VALUE '06',
      END OF gc_actvt.

    "! Valida campos de redeterminação PIS/COFINS
    "! @parameter is_piscofins | Registro redeterminação PIS/COFINS
    "! @parameter et_return | Mensagens de retorno
    METHODS valida_piscofins
      IMPORTING is_piscofins TYPE zi_mm_redetermina_piscof
      EXPORTING et_return    TYPE bapiret2_t.

    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS reported
      IMPORTING it_return   TYPE bapiret2_t
      EXPORTING es_reported TYPE ty_reported.

    "! Redetermina PIS/COFINS
    "! @parameter is_nfdoc | Cabeçalho da nota fiscal
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_nflin | Tabela dos itens da nota fiscal
    METHODS redetermine_pis_cofins
      IMPORTING is_nfdoc  TYPE j_1bnfdoc
      EXPORTING et_return TYPE bapiret2_t
      CHANGING  ct_nflin  TYPE ANY TABLE.

    "! Recupera os dados para determinação da regra
    "! @parameter it_nflin | Dados utilizados na validação
    "! @parameter et_data | Dados para regra
    METHODS get_data IMPORTING is_nfdoc TYPE j_1bnfdoc
                               it_nflin TYPE ty_t_nflin
                     EXPORTING et_data  TYPE ty_t_data.

    "! Aplica regra de redeterminação PIS/COFINS
    "! @parameter is_data | Dados utilizados na validação
    "! @parameter it_rule | Dados para regra
    "! @parameter et_rule | Dados para regra (atualizados)
    METHODS redetermine_pis_cofins_rule
      IMPORTING is_data TYPE ty_data
                it_rule TYPE ty_t_rule
      EXPORTING et_rule TYPE ty_t_rule.

    "! Verifica se Processo está ativo
    "! @parameter ev_active | Indica se EXIT está ativa
    "! @parameter rv_active | Indica se EXIT está ativa
    METHODS check_active
      EXPORTING
        ev_active        TYPE flag
      RETURNING
        VALUE(rv_active) TYPE flag.

    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter ev_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        is_param TYPE ztca_param_val
      EXPORTING
        ev_value TYPE any.

    "! Verifica autorização pelo Nome da Tabela para ação "Criar"
    "! @parameter iv_table  | Nome da Tabela de Manutenção
    "! @parameter rv_check  | Com Autorização=ABAP_TRUE/ Sem Autorização=ABAP_FALSE
    CLASS-METHODS create
      IMPORTING iv_table        TYPE tabname_auth
      RETURNING VALUE(rv_check) TYPE abap_bool.

    "! Verifica autorização pelo Nome da Tabela para ação "Update"
    "! @parameter iv_table  | Nome da Tabela de Manutenção
    "! @parameter rv_check  | Com Autorização=ABAP_TRUE/ Sem Autorização=ABAP_FALSE
    CLASS-METHODS update
      IMPORTING iv_table        TYPE tabname_auth
      RETURNING VALUE(rv_check) TYPE abap_bool.

    "! Verifica autorização pelo Nome da Tabela para ação "Delete"
    "! @parameter iv_table  | Nome da Tabela de Manutenção
    "! @parameter rv_check  | Com Autorização=ABAP_TRUE/ Sem Autorização=ABAP_FALSE
    CLASS-METHODS delete
      IMPORTING iv_table        TYPE tabname_auth
      RETURNING VALUE(rv_check) TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA:  gv_active TYPE flag.

ENDCLASS.



CLASS zclmm_redetermina_piscof_event IMPLEMENTATION.


  METHOD valida_piscofins.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Valida objeto de autorização
* ---------------------------------------------------------------------------
    IF zclmm_redetermina_piscof_event=>create( 'ZTMM_RED_PISCOF' ) NE abap_true.

      " Sem autorização para criar registros!
      et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                            type        = 'E'
                                            id          = 'ZCA_AUTHORITY_CHECK'
                                            number      = '001' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Chave completa
* ---------------------------------------------------------------------------
    IF  is_piscofins-ekorg IS INITIAL
    AND is_piscofins-werks IS INITIAL
    AND is_piscofins-lifnr IS INITIAL
    AND is_piscofins-matnr IS INITIAL
    AND is_piscofins-knttp IS INITIAL
    AND is_piscofins-sakto IS INITIAL
    AND is_piscofins-cfop  IS INITIAL.

      " Campos chave em branco.
      et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                            type        = 'E'
                                            id          = 'ZMM_DETERMINACAO_CST'
                                            number      = '002' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Se chave já foi criada
* ---------------------------------------------------------------------------
    SELECT COUNT(*)
        FROM zi_mm_redetermina_piscof
        WHERE id    NE @is_piscofins-id
          AND ekorg EQ @is_piscofins-ekorg
          AND werks EQ @is_piscofins-werks
          AND lifnr EQ @is_piscofins-lifnr
          AND matnr EQ @is_piscofins-matnr
          AND knttp EQ @is_piscofins-knttp
          AND sakto EQ @is_piscofins-sakto
          AND cfop  EQ @is_piscofins-cfop.

    IF sy-subrc EQ 0.
      " Já existe linha cadastrada com a mesma chave.
      et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                            type        = 'E'
                                            id          = 'ZMM_DETERMINACAO_CST'
                                            number      = '003' ) ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Organização de compras
* ---------------------------------------------------------------------------
    IF is_piscofins-ekorg IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_ekorg
           WHERE PurchasingOrganization = @is_piscofins-ekorg.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'EKORG'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Centro
* ---------------------------------------------------------------------------
    IF is_piscofins-werks IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_werks
           WHERE WerksCode = @is_piscofins-werks.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'WERKS'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Fornecedor
* ---------------------------------------------------------------------------
    IF is_piscofins-lifnr IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_lifnr
           WHERE LifnrCode = @is_piscofins-lifnr.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'LIFNR'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Material
* ---------------------------------------------------------------------------
    IF is_piscofins-matnr IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_material
           WHERE Material = @is_piscofins-matnr.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'MATNR'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Categoria de classificação contábil
* ---------------------------------------------------------------------------
    IF is_piscofins-knttp IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_mm_vh_knttp
           WHERE AccountAssignmentCategory = @is_piscofins-knttp.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'KNTTP'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Nº conta do Razão
* ---------------------------------------------------------------------------
    IF is_piscofins-sakto IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_saknr_pc3c
           WHERE GLAccount = @is_piscofins-sakto.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'SAKTO'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida CFOP
* ---------------------------------------------------------------------------
    IF is_piscofins-cfop IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_cfop
           WHERE Cfop1 = @is_piscofins-cfop.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'CFOP'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Imposto PIS
* ---------------------------------------------------------------------------
    IF is_piscofins-taxlaw_pis IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_taxlaw_pis
           WHERE Taxlaw = @is_piscofins-taxlaw_pis.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'TAXLAW_PIS'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.

    ELSE.
      " Preencher campo obrigatório.
      et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                            field       = 'TAXLAW_PIS'
                                            type        = 'E'
                                            id          = 'ZMM_DETERMINACAO_CST'
                                            number      = '004' ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Valida Imposto COFINS
* ---------------------------------------------------------------------------
    IF is_piscofins-taxlaw_cofins IS NOT INITIAL.

      SELECT COUNT(*)
           FROM zi_ca_vh_taxlaw_cofins
           WHERE Taxlaw = @is_piscofins-taxlaw_cofins.

      IF sy-subrc NE 0.
        " Registro não existe. Favor cadastrar um registro válido.
        et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                              field       = 'TAXLAW_COFINS'
                                              type        = 'E'
                                              id          = 'ZMM_DETERMINACAO_CST'
                                              number      = '001' ) ).
      ENDIF.

    ELSE.
      " Preencher campo obrigatório.
      et_return = VALUE #( BASE et_return ( parameter   = gc_cds-piscofins
                                            field       = 'TAXLAW_COFINS'
                                            type        = 'E'
                                            id          = 'ZMM_DETERMINACAO_CST'
                                            number      = '004' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD reported.

    DATA: lo_dataref TYPE REF TO data.
    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-piscofins.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-piscofins.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-piscofins.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-piscofins.
          es_reported-piscofins[]       = VALUE #( BASE es_reported-piscofins[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-piscofins[]       = VALUE #( BASE es_reported-piscofins[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD redetermine_pis_cofins.

    DATA: lt_data  TYPE ty_t_data,
          lt_rule  TYPE ty_t_rule,
          lt_nflin TYPE ty_t_nflin.

    lt_nflin = ct_nflin.

* ---------------------------------------------------------------------------
* Validação inicial
* ---------------------------------------------------------------------------
    CHECK is_nfdoc-direct = '1'.    " Entrada

* ---------------------------------------------------------------------------
* Verifica se processo está ativo na Tabela de Parâmetros
* ---------------------------------------------------------------------------
    IF me->check_active( ) NE abap_true.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados para redeterminação
* ---------------------------------------------------------------------------
    me->get_data( EXPORTING is_nfdoc = is_nfdoc
                            it_nflin = lt_nflin
                  IMPORTING et_data  = lt_data ).

*    IF lt_nflin[] IS NOT INITIAL.
*
*      SELECT *
*          FROM zi_mm_dados_nf_redeterm
*          FOR ALL ENTRIES IN @lt_nflin
*          WHERE docnum  EQ @lt_nflin-docnum
*            AND itmnum  EQ @lt_nflin-itmnum
*          INTO TABLE @lt_data.
*
*      IF sy-subrc NE 0.
*        RETURN.
*      ENDIF.
*    ENDIF.

* ---------------------------------------------------------------------------
* Recupera as regras para redeterminação
* ---------------------------------------------------------------------------
    IF lt_data[] IS NOT INITIAL.

      SELECT DISTINCT *
          FROM zi_mm_redetermina_piscof
          FOR ALL ENTRIES IN @lt_data
          WHERE ekorg EQ @lt_data-ekorg
             OR werks EQ @lt_data-werks
             OR lifnr EQ @lt_data-lifnr
             OR matnr EQ @lt_data-matnr
             OR knttp EQ @lt_data-knttp
             OR sakto EQ @lt_data-sakto
             OR cfop  EQ @lt_data-cfop
          INTO CORRESPONDING FIELDS OF TABLE @lt_rule.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Compara e determina os campos com maior número de ocorrências
* ---------------------------------------------------------------------------
    LOOP AT lt_nflin REFERENCE INTO DATA(ls_nflin).

      " Recupera linha com os dados para redeterminação
      READ TABLE lt_data INTO DATA(ls_data) WITH TABLE KEY docnum = ls_nflin->docnum
                                                           itmnum = ls_nflin->itmnum.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      " Aplica regra de redeterminação
      me->redetermine_pis_cofins_rule( EXPORTING is_data = ls_data
                                                 it_rule = lt_rule
                                       IMPORTING et_rule = DATA(lt_rule_ok) ).

      " Recupera primeira linha (com maior número de valores batendo)
      READ TABLE lt_rule_ok REFERENCE INTO DATA(ls_rule_ok) INDEX 1.

      IF sy-subrc EQ 0.
        ls_nflin->taxlw4 = ls_rule_ok->taxlaw_pis.
        ls_nflin->taxsi4 = ls_rule_ok->taxsit_pis.
        ls_nflin->taxlw5 = ls_rule_ok->taxlaw_cofins.
        ls_nflin->taxsi5 = ls_rule_ok->taxsit_cofins.
      ENDIF.

    ENDLOOP.

    ct_nflin[] = lt_nflin[].

  ENDMETHOD.


  METHOD redetermine_pis_cofins_rule.

    FREE: et_rule.

    et_rule = it_rule.

* ---------------------------------------------------------------------------
* Compara e determina os campos com maior número de ocorrências
* ---------------------------------------------------------------------------
    LOOP AT et_rule REFERENCE INTO DATA(ls_rule).

      CLEAR ls_rule->rule_count.

      " Verifica Organização de compras
      ls_rule->rule_count = COND #( WHEN ls_rule->ekorg IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->ekorg EQ is_data-ekorg
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica Centro
      ls_rule->rule_count = COND #( WHEN ls_rule->werks IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->werks EQ is_data-werks
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica Fornecedor
      ls_rule->rule_count = COND #( WHEN ls_rule->lifnr IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->lifnr EQ is_data-lifnr
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica Material
      ls_rule->rule_count = COND #( WHEN ls_rule->matnr IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->matnr EQ is_data-matnr
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica Categoria de classificação contábil
      ls_rule->rule_count = COND #( WHEN ls_rule->knttp IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->knttp EQ is_data-knttp
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica Número da conta do Razão
      ls_rule->rule_count = COND #( WHEN ls_rule->sakto IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->sakto EQ is_data-sakto
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

      " Verifica CFOP
      ls_rule->rule_count = COND #( WHEN ls_rule->cfop IS INITIAL
                                    THEN ls_rule->rule_count
                                    WHEN ls_rule->cfop EQ is_data-cfop
                                    THEN ls_rule->rule_count + 1
                                    ELSE ls_rule->rule_count - 99 ).

    ENDLOOP.

* ---------------------------------------------------------------------------
* Ordena pela regra mais utilizada
* ---------------------------------------------------------------------------
    DELETE et_rule WHERE rule_count <= 0.

    SORT et_rule BY rule_count DESCENDING.

  ENDMETHOD.


  METHOD get_data.

    FREE: et_data.

* ---------------------------------------------------------------------------
* Recupera os dados do pedido
* ---------------------------------------------------------------------------
    DATA(lt_ekpo_key) = VALUE me_ekpo( FOR ls_nf IN it_nflin ( ebeln = ls_nf-xped
                                                               ebelp = ls_nf-nitemped ) ).

    IF lt_ekpo_key[] IS NOT INITIAL.

      SELECT ekpo~ebeln,
             ekpo~ebelp,
             ekko~ekorg,
             ekpo~knttp,
             ekpo~sakto
          FROM ekpo
          INNER JOIN ekko
            ON ekko~ebeln = ekpo~ebeln
          FOR ALL ENTRIES IN @lt_ekpo_key
          WHERE ekpo~ebeln EQ @lt_ekpo_key-ebeln
            AND ekpo~ebelp EQ @lt_ekpo_key-ebelp
          INTO TABLE @DATA(lt_ekpo).

      IF sy-subrc EQ 0.
        SORT lt_ekpo BY ebeln ebelp.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Monta os dados utilizados na regra
* ---------------------------------------------------------------------------
    LOOP AT it_nflin REFERENCE INTO DATA(ls_nflin).

      READ TABLE lt_ekpo INTO DATA(ls_ekpo) WITH KEY ebeln = ls_nflin->xped
                                                     ebelp = ls_nflin->nitemped
                                                     BINARY SEARCH.
      IF sy-subrc NE 0.
        CLEAR ls_ekpo.
      ENDIF.

      et_data[] = VALUE #( BASE et_data ( docnum = ls_nflin->docnum
                                          itmnum = ls_nflin->itmnum
                                          ebeln  = ls_nflin->xped
                                          ebelp  = ls_nflin->nitemped
                                          ekorg  = ls_ekpo-ekorg
                                          werks  = ls_nflin->werks
                                          lifnr  = is_nfdoc-parid
                                          matnr  = ls_nflin->matnr
                                          knttp  = ls_ekpo-knttp
                                          sakto  = ls_ekpo-sakto
                                          cfop   = ls_nflin->cfop ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD check_active.

    FREE: ev_active.

* ---------------------------------------------------------------------------
* Não validar novamente
* ---------------------------------------------------------------------------
    IF me->gv_active IS NOT INITIAL.
      rv_active = ev_active = me->gv_active.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de ativação/desativação
* ---------------------------------------------------------------------------
    DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_ativo-modulo
                                               chave1 = gc_param_ativo-chave1
                                               chave2 = gc_param_ativo-chave2
                                               chave3 = gc_param_ativo-chave3 ).

    me->get_parameter( EXPORTING is_param = ls_parametro
                       IMPORTING ev_value = ev_active ).

    IF ev_active IS INITIAL.
      ev_active = 'N'.
    ENDIF.

    me->gv_active = rv_active = ev_active.

  ENDMETHOD.


  METHOD get_parameter.

    FREE ev_value.

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

        lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                          iv_chave1 = is_param-chave1
                                          iv_chave2 = is_param-chave2
                                          iv_chave3 = is_param-chave3
                                IMPORTING ev_param  = ev_value ).
      CATCH zcxca_tabela_parametros.
        FREE ev_value.
    ENDTRY.

  ENDMETHOD.


  METHOD create.

    AUTHORITY-CHECK OBJECT gc_auth-object
      ID gc_auth-actvt FIELD gc_actvt-anexar_criar
      ID gc_auth-table FIELD iv_table.

    IF sy-subrc IS INITIAL.
      rv_check = abap_true.
    ELSE.
      rv_check = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD update.

    AUTHORITY-CHECK OBJECT gc_auth-object
      ID gc_auth-actvt FIELD gc_actvt-modificar
      ID gc_auth-table FIELD iv_table.

    IF sy-subrc IS INITIAL.
      rv_check = abap_true.
    ELSE.
      rv_check = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD delete.

    AUTHORITY-CHECK OBJECT gc_auth-object
      ID gc_auth-actvt FIELD gc_actvt-eliminar
      ID gc_auth-table FIELD iv_table.

    IF sy-subrc IS INITIAL.
      rv_check = abap_true.
    ELSE.
      rv_check = abap_false.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
