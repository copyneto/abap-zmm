CLASS zclmm_adm_emissao_nf_events DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_historico TYPE ztmm_his_dep_fec .
    TYPES:
      ty_t_historico       TYPE STANDARD TABLE OF ty_historico .
    TYPES ty_serie TYPE ztmm_his_dep_ser .
    TYPES:
      ty_t_serie           TYPE STANDARD TABLE OF ty_serie .
    TYPES:
      ty_reported          TYPE RESPONSE FOR REPORTED EARLY zi_mm_administrar_emissao_nf .
    " Relatório F02
    TYPES ty_emissao_cds TYPE zi_mm_administrar_emissao_nf .
    TYPES:
      ty_t_emissao_cds     TYPE STANDARD TABLE OF ty_emissao_cds .
    TYPES ty_serie_cds TYPE zi_mm_administrar_serie .
    TYPES:
      ty_t_serie_cds       TYPE STANDARD TABLE OF ty_serie_cds .
    TYPES ty_ret_serie_cds TYPE zi_mm_ret_armazenagem_serie .
    TYPES:
      ty_t_ret_serie_cds       TYPE STANDARD TABLE OF ty_ret_serie_cds .
    " Relatório F05
    TYPES ty_armazenagem_cds TYPE zi_mm_ret_armazenagem_app .
    TYPES:
      ty_t_armazenagem_cds TYPE STANDARD TABLE OF ty_armazenagem_cds .
    " Relatório F12
    TYPES ty_pendente_cds TYPE zi_mm_pendente_ordem_frete_app .
    TYPES:
      ty_t_pendente_cds    TYPE STANDARD TABLE OF ty_pendente_cds .
    " Relatório F13
    TYPES ty_reserva_cds TYPE zi_mm_reservas_pendentes_app .
    TYPES:
      ty_t_reserva_cds     TYPE STANDARD TABLE OF ty_reserva_cds .
    TYPES:
      BEGIN OF ty_parameter,
        cfop_rem_est TYPE lips-j_1bcfop,            " Remessa física - CFOP Estadual
        cfop_rem_int TYPE lips-j_1bcfop,            " Remessa física - CFOP Interestadual
        cfop_ent_est TYPE lips-j_1bcfop,            " Entrada física - CFOP Estadual
        cfop_ent_int TYPE lips-j_1bcfop,            " Entrada física - CFOP Interestadual
      END OF ty_parameter .
    TYPES:
      BEGIN OF ty_his_dep_fec_key,
        material                 TYPE matnr,
        plant                    TYPE werks_d,
        storage_location         TYPE lgort_d,
        batch                    TYPE charg_d,
        plant_dest               TYPE werks_d,
        storage_location_dest    TYPE lgort_d,
        guid                     TYPE sysuuid_x16,
        main_purchase_order      TYPE ztmm_his_dep_fec-main_purchase_order,
        main_purchase_order_item TYPE ztmm_his_dep_fec-main_purchase_order_item,
      END OF ty_his_dep_fec_key .

    CONSTANTS:
      BEGIN OF gc_status,
        inicial          TYPE ztmm_his_dep_fec-status VALUE '00', " Inicial
        em_processamento TYPE ztmm_his_dep_fec-status VALUE '01', " Em processamento
        incompleto       TYPE ztmm_his_dep_fec-status VALUE '02', " Incompleto
        completo         TYPE ztmm_his_dep_fec-status VALUE '03', " Completo
        entrada_merc     TYPE ztmm_his_dep_fec-status VALUE '04', " Aguardando job Entrada Mercadoria
        nota_rejeita     TYPE ztmm_his_dep_fec-status VALUE '05', " Nota Rejeitada pela SEFAZ
        erro_nota        TYPE ztmm_his_dep_fec-status VALUE '06', " Erro na composição da Nota
        em_transito      TYPE ztmm_his_dep_fec-status VALUE '07', " Em transito
        nota_input       TYPE ztmm_his_dep_fec-status VALUE '08', " Aguardando nota de entreda
        saida_nota       TYPE ztmm_his_dep_fec-status VALUE '09', " Aguardando Saída de nota
        ordem_frete      TYPE ztmm_his_dep_fec-status VALUE '11', " Aguardando Ordem de Frete
        ordem_frete_job  TYPE ztmm_his_dep_fec-status VALUE '12', " Aguardando Ordem de Frete
        rascunho         TYPE ztmm_his_dep_fec-status VALUE '99', " Rascunho
      END OF gc_status .
    CONSTANTS:
      BEGIN OF gc_etapa,
        f02 TYPE ztmm_his_dep_fec-process_step VALUE 'F02',
        f05 TYPE ztmm_his_dep_fec-process_step VALUE 'F05',
        f12 TYPE ztmm_his_dep_fec-process_step VALUE 'F12',
        f13 TYPE ztmm_his_dep_fec-process_step VALUE 'F13',
        enh TYPE ztmm_his_dep_fec-process_step VALUE 'ENH',
      END OF gc_etapa .
    CONSTANTS:
      BEGIN OF gc_autorizacao,
        criar_nfe TYPE activ_auth VALUE '16' ##NO_TEXT,
      END OF gc_autorizacao .
    DATA gv_timestamp TYPE timestampl .

    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
    "! Inicia processo de criação dos documentos
    "! @parameter it_historico_key | Lista de Linhas a processar
    "! @parameter et_return | Mensagens de retorno
    METHODS bapi_create_documents
      IMPORTING
        !it_historico_key  TYPE ty_t_historico OPTIONAL
        !iv_update_history TYPE flag DEFAULT abap_true
        !iv_status         TYPE ze_mm_df_status OPTIONAL
        !iv_job_centro_fat TYPE abap_bool OPTIONAL
      EXPORTING
        !et_return         TYPE bapiret2_t .
    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING
        !it_return   TYPE bapiret2_t
      EXPORTING
        !es_reported TYPE ty_reported .
    "! Calcula disponibilidade de estoque do material
    "! @parameter it_emissao_cds | Dado de emissão
    "! @parameter et_emissao_cds | Dado de emissão
    METHODS calculate_material_stock
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
      EXPORTING
        !et_emissao_cds TYPE ty_t_emissao_cds .
    "! Salva dados em background
    "! @parameter it_historico | Dados de histórico
    "! @parameter it_serie | Dados de série
    "! @parameter et_return | Mensagens de retorno
    METHODS call_save_background
      IMPORTING
        !it_historico_prev TYPE ty_t_historico OPTIONAL
        !it_historico      TYPE ty_t_historico OPTIONAL
        !it_serie_prev     TYPE ty_t_serie OPTIONAL
        !it_serie          TYPE ty_t_serie OPTIONAL
        !it_msg            TYPE zctgmm_his_dep_msg OPTIONAL
      EXPORTING
        !et_return         TYPE bapiret2_t .
    "! Chama função remota para mudar de status
    "! @parameter iv_actvt | Atividade
    "! @parameter ev_ok | Mensagem de sucesso
    "! @parameter et_return | Mensagens de retorno
    METHODS check_permission
      IMPORTING
        !iv_actvt    TYPE activ_auth
      EXPORTING
        !ev_ok       TYPE flag
        !et_return   TYPE bapiret2_t
      RETURNING
        VALUE(rv_ok) TYPE flag .
    "! Continua processo de criação dos documentos (Enhancements)
    "! @parameter iv_invnumber | Nº de um documento de faturamento de logística
    "! @parameter iv_year | Exercício fiscal da revisão de faturas
    "! @parameter is_header |  NF-e Inbound: Header Data
    "! @parameter it_item | NF-e Inbound: XML Items with Order Details
    "! @parameter et_return | Mensagens de retorno
    METHODS continue_document_creation
      IMPORTING
        !iv_invnumber TYPE /xnfe/invnumber
        !iv_year      TYPE /xnfe/byear
        !is_header    TYPE /xnfe/innfehd
        !it_item      TYPE /xnfe/erp_in_item_t
      EXPORTING
        !et_return    TYPE bapiret2_t .
    "! Converte Dados de emissão
    "! @parameter iv_new_guid | Novo ID, se necessário
    "! @parameter iv_new_status | Novo Status, se necessário
    "! @parameter it_emissao_cds | Dados de emissão
    "! @parameter et_historico | Dados de histórico
    METHODS convert_cds_to_table
      IMPORTING
        !iv_new_guid    TYPE flag OPTIONAL
        !iv_new_status  TYPE ty_historico-status OPTIONAL
        !it_emissao_cds TYPE ty_t_emissao_cds OPTIONAL
        !it_serie_cds   TYPE ty_t_serie_cds OPTIONAL
      EXPORTING
        !et_historico   TYPE ty_t_historico
        !et_serie       TYPE ty_t_serie
        !et_return      TYPE bapiret2_t .
    "! Inicia processo de criação dos documentos
    "! @parameter it_historico_key | Lista de Linhas a processar
    "! @parameter et_return | Mensagens de retorno
    METHODS create_documents
      IMPORTING
        !it_historico_key TYPE ty_t_historico
      EXPORTING
        !et_return        TYPE bapiret2_t .
    "! Gerencia criação de documentos (F02)
    "! @parameter it_emissao_cds | Dados de emissão
    "! @parameter et_return | Mensagens de retorno
    METHODS create_documents_f02
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Gerencia criação de documentos (F05)
    "! @parameter it_armazenagem_cds | Dados retorno armazenagem
    "! @parameter et_return | Mensagens de retorno
    METHODS create_documents_f05
      IMPORTING
        !it_armazenagem_cds TYPE ty_t_armazenagem_cds
      EXPORTING
        !et_return          TYPE bapiret2_t .
    "! Gerencia criação de documentos (F12)
    "! @parameter it_pendente_cds | Dados pendente ordem de frete
    "! @parameter et_return | Mensagens de retorno
    METHODS create_documents_f12
      IMPORTING
        !it_pendente_cds TYPE ty_t_pendente_cds
      EXPORTING
        !et_return       TYPE bapiret2_t .
    "! Gerencia criação de documentos (F13)
    "! @parameter it_reserva_cds | Dados reservas pendentes
    "! @parameter et_return | Mensagens de retorno
    METHODS create_documents_f13
      IMPORTING
        !it_reserva_cds TYPE ty_t_reserva_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Gerar Ordem de frete
    "! @parameter it_emissao_cds | Dados de emissão
    "! @parameter et_return | Mensagens de retorno
    METHODS create_ordem_frete
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Apaga dados de emissão
    "! @parameter it_emissao_cds |  Dados de emissão
    "! @parameter it_serie_cds | Dados de série
    "! @parameter et_return | Mensagen de retorno
    METHODS delete_issue
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
        !it_serie_cds   TYPE ty_t_serie_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Apaga dados de série
    "! @parameter it_emissao_cds | Dados de emissão
    "! @parameter it_serie_cds |  Dados de emissão
    "! @parameter et_return | Mensagen de retorno
    METHODS delete_series
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
        !it_serie_cds   TYPE ty_t_serie_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    METHODS delete_series_retorno
      IMPORTING
        !it_ret_serie_cds TYPE ty_t_ret_serie_cds
      EXPORTING
        !et_return        TYPE bapiret2_t .
    METHODS delivery_update
      IMPORTING
        !iv_delivery       TYPE likp-vbeln
        !is_vbkok          TYPE vbkok
        !it_vbpok          TYPE tab_vbpok
        !it_sernr          TYPE vlc_vlser_t
        !it_item_data      TYPE bapiobdlvitemchg_t
        !it_item_control   TYPE bapiobdlvitemctrlchg_t
        !it_item_data_spl  TYPE spe_bapiobdlvitemchg_tty
        !it_partner_update TYPE shp_partner_update_t
        !it_header_partner TYPE /spe/bapidlvpartnerchg_t
      EXPORTING
        !ev_error          TYPE flag
      CHANGING
        !ct_return         TYPE bapiret2_t .
    "! Formata as mensages de retorno
    "! @parameter iv_change_error_type | Muda o Tipo de mensagem 'E' para 'I'.
    "! @parameter iv_change_warning_type | Muda o Tipo de mensagem 'W' para 'I'.
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      IMPORTING
        !iv_change_error_type   TYPE flag OPTIONAL
        !iv_change_warning_type TYPE flag OPTIONAL
      CHANGING
        !ct_return              TYPE bapiret2_t .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t .
    "! Recupera dados de emissão e série
    "! @parameter it_emissao_cds | Dados de emissão (chave) - F02
    "! @parameter it_pendente_cds | Dados pendente ordem de frete (chave) - F12
    "! @parameter it_reserva_cds | Dados reservas pendentes (chave) - F13
    "! @parameter et_emissao_cds | Dados de emissão
    "! @parameter et_serie_cds | Dados de série
    "! @parameter et_pendente_cds | Dados pendente ordem de frete
    METHODS get_info
      IMPORTING
        !it_emissao_cds  TYPE ty_t_emissao_cds OPTIONAL
        !it_pendente_cds TYPE ty_t_pendente_cds OPTIONAL
        !it_reserva_cds  TYPE ty_t_reserva_cds OPTIONAL
      EXPORTING
        !et_emissao_cds  TYPE ty_t_emissao_cds
        !et_serie_cds    TYPE ty_t_serie_cds
        !et_pendente_cds TYPE ty_t_pendente_cds
        !et_reserva_cds  TYPE ty_t_reserva_cds .
    "! Recupera dados de emissão e série
    "! @parameter it_emissao_cds | Dados de emissão (chave) - F02
    "! @parameter et_armazenagem_cds | Dados de emissão
    METHODS get_info_retorno
      IMPORTING
        !it_emissao_cds     TYPE ty_t_emissao_cds OPTIONAL
      EXPORTING
        !et_armazenagem_cds TYPE ty_t_armazenagem_cds
        !et_ret_serie_cds   TYPE ty_t_ret_serie_cds .
    "! Recupera informações referente ao pedido principal
    "! @parameter iv_invnumber | Nº de um documento de faturamento de logística
    "! @parameter iv_year | Exercício fiscal da revisão de faturas
    "! @parameter et_historico | Dados de histórico
    "! @parameter et_return | Mensagens de retorno
    METHODS get_main_info
      IMPORTING
        !iv_invnumber TYPE /xnfe/invnumber
        !iv_year      TYPE /xnfe/byear
      EXPORTING
        !et_historico TYPE ty_t_historico
        !et_return    TYPE bapiret2_t .
    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter et_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        !is_param TYPE ztca_param_val
      EXPORTING
        !ev_value TYPE any
        !et_value TYPE any .
    METHODS inb_delivery_create
      IMPORTING
        !is_header     TYPE bbp_inbd_l
        !it_detail     TYPE zctgmm_bbp_inbd_d
      EXPORTING
        !ev_error      TYPE flag
        !ev_vbeln      TYPE vbeln_vl
      CHANGING
        !ct_bapireturn TYPE bapiret2_t .
    "! Execução dos registros marcados para entreda de mercadoria
    METHODS job_delivery
      IMPORTING
        !it_historico_key TYPE zclmm_adm_emissao_nf_events=>ty_t_historico OPTIONAL
        !iv_status        TYPE ze_mm_df_status OPTIONAL
        !iv_current_date  TYPE flag OPTIONAL
      EXPORTING
        !et_return        TYPE bapiret2_t .
    "! Execução dos registros marcados para entreda de mercadoria
    METHODS job_entrada_mercadoria
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Preenche tabela de msg
    "! @parameter is_historico | Dados de histórico
    "! @parameter it_return | Mensagens de retorno
    "! @parameter ct_msg | Tabela de msg
    METHODS mapping_msg_table
      IMPORTING
        !is_historico TYPE ty_historico
        !it_return    TYPE bapiret2_t
      CHANGING
        !ct_msg       TYPE zctgmm_his_dep_msg .
    METHODS retry_process
      IMPORTING
        !it_emissao_cds TYPE ty_t_emissao_cds
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Salva dados de emissão
    "! @parameter it_emissao_cds |Dados de emissão
    "! @parameter iv_checkbox | Evento Checkbox
    "! @parameter iv_new_status | Novo status
    "! @parameter et_historico | Dados de histórico
    "! @parameter et_return | Mensagens de retorno
    METHODS save_issue
      IMPORTING
        !it_emissao_cds     TYPE ty_t_emissao_cds
        !iv_checkbox        TYPE flag OPTIONAL
        !iv_new_status      TYPE ty_historico-status OPTIONAL
        !iv_nao_muda_status TYPE abap_bool OPTIONAL
      EXPORTING
        !et_historico       TYPE ty_t_historico
        !et_return          TYPE bapiret2_t .
    "! Salva dados de série
    "! @parameter it_serie_cds | Dados de série
    "! @parameter et_serie | Dados de série
    "! @parameter et_return | Mensagens de retorno
    METHODS save_series
      IMPORTING
        !it_serie_cds TYPE ty_t_serie_cds
      EXPORTING
        !et_serie     TYPE ty_t_serie
        !et_return    TYPE bapiret2_t .
    "! Salva dados de série
    "! @parameter it_serie_cds | Dados de série
    "! @parameter et_serie | Dados de série
    "! @parameter et_return | Mensagens de retorno
    METHODS save_series_retorno
      IMPORTING
        !it_serie_cds TYPE ty_t_serie_cds
      EXPORTING
        !et_serie     TYPE ty_t_serie
        !et_return    TYPE bapiret2_t .
    METHODS substring_msgid
      IMPORTING
        !iv_value       TYPE bapi_rcode
      RETURNING
        VALUE(rv_msgid) TYPE symsgid .
    METHODS substring_msgno
      IMPORTING
        !iv_value       TYPE bapi_rcode
      RETURNING
        VALUE(rv_msgno) TYPE symsgno .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
              "!Armazenamento das mensagens de processamento
      gt_return                   TYPE STANDARD TABLE OF bapiret2 .
    CLASS-DATA:
      gt_bapireturn               TYPE STANDARD TABLE OF bapireturn .
    "!Flag para sincronizar o processamento da função de criação de ordens de produção
    CLASS-DATA gv_wait_async TYPE abap_bool .
    CLASS-DATA gv_wait_async_ws TYPE abap_bool .
    CLASS-DATA:
      gt_prot                     TYPE STANDARD TABLE OF prott .
    CLASS-DATA gv_error_any_0 TYPE xfeld .
    CLASS-DATA gv_error_in_item_deletion_0 TYPE xfeld .
    CLASS-DATA gv_error_in_pod_update_0 TYPE xfeld .
    CLASS-DATA gv_error_in_interface_0 TYPE xfeld .
    CLASS-DATA gv_error_in_goods_issue_0 TYPE xfeld .
    CLASS-DATA gv_error_in_final_check_0 TYPE xfeld .
    CLASS-DATA gv_error_partner_update TYPE xfeld .
    CLASS-DATA gv_error_sernr_update TYPE xfeld .
    "!Remessa de entrada
    CLASS-DATA gv_in_delivery_document TYPE vbeln_vl .
    "!Parâmetros de configuração
    CLASS-DATA gs_parameter TYPE ty_parameter .

    METHODS create_history_guid2
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie .
    "! Atualiza registros com GUID
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_history_guid
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie .
    "! Cria aviso de recebimento (Remessa entrada)
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_in_delivery
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
    "! Cria entrada de mercadoria (Documento de material)
    "! @parameter it_mara | Material
    "! @parameter it_equi | Equipamento - Série
    "! @parameter it_lips | Remessa
    "! @parameter it_eket | Divisão de remessa
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_in_material_document
      IMPORTING
        !it_mara      TYPE ty_t_mara
        !it_equi      TYPE ty_t_equi
        !it_lips      TYPE ty_t_lips
        !it_eket      TYPE ty_t_eket
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
    "! Cria nota fiscal de entrada
    "! @parameter it_mbew | Avaliação do material
    "! @parameter it_mara | Material
    "! @parameter it_marc | Centro de Material
    "! @parameter it_t001k | Área de avaliação
    "! @parameter it_lips | Remessa
    "! @parameter it_lin | Item da Nota Fiscal
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_in_nota_fiscal
      IMPORTING
        !it_mbew      TYPE ty_t_mbew
        !it_mara      TYPE ty_t_mara
        !it_marc      TYPE ty_t_marc
        !it_t001k     TYPE ty_t_t001k
        !it_lips      TYPE ty_t_lips
        !it_lin       TYPE ty_t_lin
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
    "! Cria remessa de saída
    "! @parameter it_mara | Material
    "! @parameter it_equi | Equipamento - Série
    "! @parameter it_eket | Divisão de remessa
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_out_delivery
      IMPORTING
        !it_mara      TYPE ty_t_mara
        !it_equi      TYPE ty_t_equi
        !it_eket      TYPE ty_t_eket
        !iv_status    TYPE ze_mm_df_status OPTIONAL
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
    METHODS create_out_delivery_check
      IMPORTING
        !iv_delivery     TYPE likp-vbeln
        !it_lips         TYPE ty_t_lips
        !iv_current_date TYPE flag OPTIONAL
      RETURNING
        VALUE(rv_ok)     TYPE bool .
    "! Cria saída de mercadoria (Documento de material)
    "! @parameter it_mara | Material
    "! @parameter it_equi | Equipamento - Série
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_out_material_document
      IMPORTING
        !it_mara         TYPE ty_t_mara
        !it_equi         TYPE ty_t_equi
        !it_t001k        TYPE ty_t_t001k
        !it_lips         TYPE ty_t_lips
        !iv_current_date TYPE flag OPTIONAL
      EXPORTING
        !et_return       TYPE bapiret2_t
      CHANGING
        !ct_historico    TYPE ty_t_historico
        !ct_serie        TYPE ty_t_serie
        !ct_msg          TYPE zctgmm_his_dep_msg .
    "! Cria pedido de compra
    "! @parameter it_t001k | Área de avaliação
    "! @parameter it_mbew | Avaliação do material
    "! @parameter it_mara | Material
    "! @parameter it_equi | Equipamento - Série
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS create_purchase_order
      IMPORTING
        !it_t001k     TYPE ty_t_t001k
        !it_mbew      TYPE ty_t_mbew
        !it_mara      TYPE ty_t_mara
        !it_equi      TYPE ty_t_equi
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
    "! Recupera informações para a chamada das BAPIs
    "! @parameter it_historico_key | Dados de histórico (chave)
    "! @parameter et_historico | Dados de histórico
    "! @parameter et_serie | Dados de série
    "! @parameter et_t001k | Área de avaliação
    "! @parameter et_mbew | Avaliação do material
    "! @parameter et_mara | Material
    "! @parameter et_marc | Centro de Material
    "! @parameter et_equi | Equipamento - série
    "! @parameter et_eket | Divisão de remessa
    "! @parameter et_lips | Remessa
    "! @parameter et_mseg | Documento de material
    "! @parameter et_lin | Item da Nota Fiscal
    "! @parameter et_return | Mensagens de retorno
    METHODS get_bapi_info
      IMPORTING
        !it_historico_key  TYPE ty_t_historico
        !iv_status         TYPE ze_mm_df_status OPTIONAL
        !iv_job_centro_fat TYPE abap_bool OPTIONAL
      EXPORTING
        !et_historico      TYPE ty_t_historico
        !et_serie          TYPE ty_t_serie
        !et_t001k          TYPE ty_t_t001k
        !et_mbew           TYPE ty_t_mbew
        !et_mara           TYPE ty_t_mara
        !et_marc           TYPE ty_t_marc
        !et_equi           TYPE ty_t_equi
        !et_eket           TYPE ty_t_eket
        !et_lips           TYPE ty_t_lips
        !et_mseg           TYPE ty_t_mseg
        !et_lin            TYPE ty_t_lin
        !et_ekbe           TYPE ty_t_ekbe
        !et_return         TYPE bapiret2_t .
    "! Recupera próximo número GUID
    "! @parameter ev_guid | Número GUID
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_guid | Número GUID
    METHODS get_next_guid
      EXPORTING
        !ev_guid       TYPE sysuuid_x16
        !et_return     TYPE bapiret2_t
      RETURNING
        VALUE(rv_guid) TYPE sysuuid_x16 .
    METHODS is_max_execution_status
      IMPORTING
        !iv_guid         TYPE sysuuid_x16
      RETURNING
        VALUE(rv_return) TYPE abap_bool .
    "! Salva dados
    "! @parameter it_emissao_cds | Dados de emissão
    "! @parameter it_serie_cds | Dados de emissão
    "! @parameter it_pendente_cds | Dados pendente de ordem de frete (F12)
    "! @parameter it_reserva_cds | Dados reservas pendentes (F13)
    "! @parameter it_historico | Dados de histórico
    "! @parameter it_serie | Dados de série
    "! @parameter et_historico | Dados de histórico
    "! @parameter et_serie | Dados de série
    "! @parameter et_return | Mensagens de retorno
    METHODS save
      IMPORTING
        !iv_background      TYPE flag DEFAULT abap_false
        !it_emissao_cds     TYPE ty_t_emissao_cds OPTIONAL
        !it_serie_cds       TYPE ty_t_serie_cds OPTIONAL
        !it_pendente_cds    TYPE ty_t_pendente_cds OPTIONAL
        !it_reserva_cds     TYPE ty_t_reserva_cds OPTIONAL
        !it_armazenagem_cds TYPE ty_t_armazenagem_cds OPTIONAL
        !it_historico       TYPE ty_t_historico OPTIONAL
        !it_serie           TYPE ty_t_serie OPTIONAL
      EXPORTING
        !et_historico       TYPE ty_t_historico
        !et_serie           TYPE ty_t_serie
        !et_return          TYPE bapiret2_t .
    "! Salva dados em background
    "! @parameter it_historico | Dados de histórico
    "! @parameter it_serie | Dados de série
    "! @parameter et_return | Mensagens de retorno
    METHODS save_background
      IMPORTING
        !it_historico TYPE ty_t_historico OPTIONAL
        !it_serie     TYPE ty_t_serie OPTIONAL
      EXPORTING
        !et_return    TYPE bapiret2_t .
    "! Aplica ordenação
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS sort
      CHANGING
        !ct_historico TYPE ty_t_historico OPTIONAL
        !ct_serie     TYPE ty_t_serie OPTIONAL .
    "! Verifica se documentos já foram criados
    "! @parameter ct_historico | Dados de histórico
    METHODS update_history_documents
      CHANGING
        !ct_historico TYPE ty_t_historico .
    METHODS update_in_billing .
    "! Valida Nota Fiscal de Saída
    "! @parameter it_lin | Item da nota fiscal
    "! @parameter et_return | Mensagens de retorno
    "! @parameter ct_historico | Dados de histórico
    "! @parameter ct_serie | Dados de série
    METHODS validate_out_nota_fiscal
      IMPORTING
        !it_lin       TYPE ty_t_lin
      EXPORTING
        !et_return    TYPE bapiret2_t
      CHANGING
        !ct_historico TYPE ty_t_historico
        !ct_serie     TYPE ty_t_serie
        !ct_msg       TYPE zctgmm_his_dep_msg .
ENDCLASS.



CLASS ZCLMM_ADM_EMISSAO_NF_EVENTS IMPLEMENTATION.


  METHOD get_parameter.

    FREE et_value.

    TRY.
        DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

        " Recupera valor único
        IF ev_value IS SUPPLIED.
          lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                            iv_chave1 = is_param-chave1
                                            iv_chave2 = is_param-chave2
                                            iv_chave3 = is_param-chave3
                                  IMPORTING ev_param  = ev_value ).
        ENDIF.

        " Recupera lista de valores
        IF et_value IS SUPPLIED.
          lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                           iv_chave1 = is_param-chave1
                                           iv_chave2 = is_param-chave2
                                           iv_chave3 = is_param-chave3
                                 IMPORTING et_range  = et_value ).
        ENDIF.

      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD mapping_msg_table.

    ct_msg = VALUE #( BASE ct_msg FOR ls_return IN it_return (  material = is_historico-material
                                                                plant    = is_historico-plant
                                                                storage_location = is_historico-storage_location
                                                                batch            = is_historico-batch
                                                                plant_dest       = is_historico-plant_dest
                                                                storage_location_dest = is_historico-storage_location_dest
                                                                guid             = is_historico-guid
                                                                type             = ls_return-type
                                                                id               = ls_return-id
                                                                number           = ls_return-number
                                                                message_v1       = ls_return-message_v1
                                                                message_v2       = ls_return-message_v2
                                                                message_v3       = ls_return-message_v3
                                                                message_v4       = ls_return-message_v4 ) ).

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro Remessa física - CFOP Estadual
* ---------------------------------------------------------------------------
    IF me->gs_parameter-cfop_rem_est IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_cfop_rem_est-modulo
                                                 chave1 = gc_param_cfop_rem_est-chave1
                                                 chave2 = gc_param_cfop_rem_est-chave2
                                                 chave3 = gc_param_cfop_rem_est-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-cfop_rem_est ).

    ENDIF.

    IF me->gs_parameter-cfop_rem_est  IS INITIAL.
      " Param. 'Remessa física: CFOP Estadual' não cadastrado: [&1/&2/&3/&4]
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '020'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro Remessa física - CFOP Interestadual
* ---------------------------------------------------------------------------
    IF me->gs_parameter-cfop_rem_int IS INITIAL.

      ls_parametro = VALUE ztca_param_val( modulo = gc_param_cfop_rem_int-modulo
                                           chave1 = gc_param_cfop_rem_int-chave1
                                           chave2 = gc_param_cfop_rem_int-chave2
                                           chave3 = gc_param_cfop_rem_int-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-cfop_rem_int ).

    ENDIF.

    IF me->gs_parameter-cfop_rem_int  IS INITIAL.
      " Param. 'Remessa física: CFOP Interestadual' não cadastrado: [&1/&2/&3/&4]
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '021'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro Entrada física - CFOP Estadual
* ---------------------------------------------------------------------------
    IF me->gs_parameter-cfop_ent_est IS INITIAL.

      ls_parametro = VALUE ztca_param_val( modulo = gc_param_cfop_ent_est-modulo
                                           chave1 = gc_param_cfop_ent_est-chave1
                                           chave2 = gc_param_cfop_ent_est-chave2
                                           chave3 = gc_param_cfop_ent_est-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-cfop_ent_est ).

    ENDIF.

    IF me->gs_parameter-cfop_ent_est  IS INITIAL.
      " Param. 'Entrada física: CFOP Estadual' não cadastrado: [&1/&2/&3/&4]
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '022'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro Entrada física - CFOP Interestadual
* ---------------------------------------------------------------------------
    IF me->gs_parameter-cfop_ent_int IS INITIAL.

      ls_parametro = VALUE ztca_param_val( modulo = gc_param_cfop_ent_int-modulo
                                           chave1 = gc_param_cfop_ent_int-chave1
                                           chave2 = gc_param_cfop_ent_int-chave2
                                           chave3 = gc_param_cfop_ent_int-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-cfop_ent_int ).

    ENDIF.

    IF me->gs_parameter-cfop_ent_int  IS INITIAL.
      " Param. 'Entrada física: CFOP Interestadual' não cadastrado: [&1/&2/&3/&4]
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '023'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3 ) ).
    ENDIF.

    me->format_return( CHANGING ct_return = et_return ).

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD get_info.

    FREE: et_emissao_cds,
          et_serie_cds,
          et_pendente_cds.

* ---------------------------------------------------------------------------
* Recupera dados de emissão
* ---------------------------------------------------------------------------
    IF it_emissao_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
          FROM zi_mm_administrar_emissao_nf
          FOR ALL ENTRIES IN @it_emissao_cds
          WHERE material              = @it_emissao_cds-material
            AND originplant           = @it_emissao_cds-originplant
            AND originstoragelocation = @it_emissao_cds-originstoragelocation
            AND batch                 = @it_emissao_cds-batch
            AND originunit            = @it_emissao_cds-originunit
            AND unit                  = @it_emissao_cds-unit
            AND guid                  = @it_emissao_cds-guid
            AND processstep           = @it_emissao_cds-processstep
            AND prmdepfecid           = @it_emissao_cds-prmdepfecid
            AND eantype               = @it_emissao_cds-eantype
            INTO TABLE @et_emissao_cds.

      IF sy-subrc EQ 0.
        SORT et_emissao_cds BY material originplant originstoragelocation batch originunit unit guid processstep prmdepfecid eantype.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de série
* ---------------------------------------------------------------------------
    IF it_emissao_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
        FROM zi_mm_administrar_serie
        FOR ALL ENTRIES IN @it_emissao_cds
        WHERE material              = @it_emissao_cds-material
          AND originplant           = @it_emissao_cds-originplant
          AND originstoragelocation = @it_emissao_cds-originstoragelocation
          AND batch                 = @it_emissao_cds-batch
          AND originunit            = @it_emissao_cds-originunit
          AND unit                  = @it_emissao_cds-unit
          AND guid                  = @it_emissao_cds-guid
          AND processstep           = @it_emissao_cds-processstep
          AND prmdepfecid           = @it_emissao_cds-prmdepfecid
          AND eantype               = @it_emissao_cds-eantype
          INTO TABLE @et_serie_cds.

      IF sy-subrc EQ 0.
        SORT et_serie_cds BY material originplant originstoragelocation originunit unit guid processstep prmdepfecid eantype serialno .
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados pendentes de ordem de frete (F12)
* ---------------------------------------------------------------------------
    IF it_pendente_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
        FROM zi_mm_pendente_ordem_frete_app
        FOR ALL ENTRIES IN @it_pendente_cds
        WHERE numeroordemdefrete = @it_pendente_cds-numeroordemdefrete
          AND numerodaremessa    = @it_pendente_cds-numerodaremessa
          AND material           = @it_pendente_cds-material
          AND umborigin          = @it_pendente_cds-umborigin
          AND umbdestino         = @it_pendente_cds-umbdestino
          AND centroremessa      = @it_pendente_cds-centroremessa
          AND deposito           = @it_pendente_cds-deposito
          AND lote               = @it_pendente_cds-lote
          AND centrodestino      = @it_pendente_cds-centrodestino
          AND depositodestino    = @it_pendente_cds-depositodestino
          AND dadosdohistorico   = @it_pendente_cds-dadosdohistorico
          INTO TABLE @et_pendente_cds.

      IF sy-subrc EQ 0.
        SORT et_pendente_cds BY numeroordemdefrete numerodaremessa material umborigin umbdestino centroremessa deposito lote centrodestino depositodestino dadosdohistorico.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados pendentes de ordem de frete (F13)
* ---------------------------------------------------------------------------
    IF it_reserva_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
        FROM zi_mm_reservas_pendentes_app
        FOR ALL ENTRIES IN @it_reserva_cds
        WHERE reservation       = @it_reserva_cds-reservation
          AND dadosdohistorico  = @it_reserva_cds-dadosdohistorico
          AND eantype           = @it_reserva_cds-eantype
          AND dadosdohistorico  = @it_reserva_cds-dadosdohistorico

          INTO TABLE @et_reserva_cds.

      IF sy-subrc EQ 0.
        SORT et_reserva_cds BY reservation dadosdohistorico eantype dadosdohistorico.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_info_retorno.

    FREE: et_armazenagem_cds,
          et_ret_serie_cds.

* ---------------------------------------------------------------------------
* Recupera dados de emissão
* ---------------------------------------------------------------------------
    IF it_emissao_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
          FROM zi_mm_ret_armazenagem_app
          FOR ALL ENTRIES IN @it_emissao_cds
          WHERE guid                   = @it_emissao_cds-guid
            AND material              = @it_emissao_cds-material
            INTO TABLE @et_armazenagem_cds.
*
      IF sy-subrc EQ 0.
        SORT et_armazenagem_cds BY material CentroOrigem DepositoOrigem CentroDestino DepositoDestino lote.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de série
* ---------------------------------------------------------------------------
    IF et_armazenagem_cds[] IS NOT INITIAL.

      SELECT DISTINCT *
        FROM zi_mm_ret_armazenagem_serie
        FOR ALL ENTRIES IN @et_armazenagem_cds
        WHERE   NumeroOrdemDeFrete           = @et_armazenagem_cds-NumeroOrdemDeFrete
          AND      NumeroDaRemessa           = @et_armazenagem_cds-NumeroDaRemessa
          AND      Material                  = @et_armazenagem_cds-Material
          AND      UmbOrigin                 = @et_armazenagem_cds-UmbOrigin
          AND      UmbDestino                = @et_armazenagem_cds-UmbDestino
          AND      CentroOrigem              = @et_armazenagem_cds-CentroOrigem
          AND      DepositoOrigem            = @et_armazenagem_cds-DepositoOrigem
          AND      CentroDestino             = @et_armazenagem_cds-CentroDestino
          AND      DepositoDestino           = @et_armazenagem_cds-DepositoDestino
          AND      Lote                      = @et_armazenagem_cds-Lote
          AND      guid                      = @et_armazenagem_cds-guid
          INTO TABLE @et_ret_serie_cds.

      IF sy-subrc EQ 0.
        SORT et_ret_serie_cds BY Guid Material.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD save_issue.

    FREE: et_historico, et_return.

* ---------------------------------------------------------------------------
* Recupera dados de emissão
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING it_emissao_cds = it_emissao_cds
                  IMPORTING et_emissao_cds = DATA(lt_emissao_cds) ).

* ---------------------------------------------------------------------------
* Atualiza campos editados
* ---------------------------------------------------------------------------
    LOOP AT it_emissao_cds INTO DATA(ls_emissao_cds).

      READ TABLE lt_emissao_cds REFERENCE INTO DATA(ls_emissao) WITH KEY material              = ls_emissao_cds-material
                                                                         originplant           = ls_emissao_cds-originplant
                                                                         originstoragelocation = ls_emissao_cds-originstoragelocation
                                                                         batch                 = ls_emissao_cds-batch
                                                                         originunit            = ls_emissao_cds-originunit
                                                                         unit                  = ls_emissao_cds-unit
                                                                         guid                  = ls_emissao_cds-guid
                                                                         processstep           = ls_emissao_cds-processstep
                                                                         prmdepfecid           = ls_emissao_cds-prmdepfecid
                                                                         eantype               = ls_emissao_cds-eantype
                                                                         BINARY SEARCH.

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      ls_emissao->useavailable       = ls_emissao_cds-useavailable.

      IF iv_checkbox IS INITIAL.
        ls_emissao->availablestock     = ls_emissao_cds-availablestock.
        ls_emissao->carrier            = ls_emissao_cds-carrier.
        ls_emissao->driver             = ls_emissao_cds-driver.
        ls_emissao->equipment          = ls_emissao_cds-equipment.
        ls_emissao->shippingconditions = ls_emissao_cds-shippingconditions.
        ls_emissao->shippingtype       = ls_emissao_cds-shippingtype.
        ls_emissao->equipmenttow1      = ls_emissao_cds-equipmenttow1.
        ls_emissao->equipmenttow2      = ls_emissao_cds-equipmenttow2.
        ls_emissao->equipmenttow3      = ls_emissao_cds-equipmenttow3.
        ls_emissao->freightmode        = ls_emissao_cds-freightmode.
        ls_emissao->batch              = ls_emissao_cds-batch.
        ls_emissao->usedstock          = ls_emissao_cds-usedstock.
        ls_emissao->usedstock_conve    = ls_emissao_cds-usedstock.

      ELSE.
        ls_emissao->usedstock        = ls_emissao->availablestock_conve.
        ls_emissao_cds-usedstock     = ls_emissao->availablestock_conve.
      ENDIF.

    ENDLOOP.

    me->calculate_material_stock( EXPORTING it_emissao_cds = lt_emissao_cds
                                  IMPORTING et_emissao_cds = DATA(lt_emissao_new) ).
    IF iv_nao_muda_status = abap_false.
      DATA(lv_status) = COND #( WHEN iv_new_status IS NOT INITIAL AND iv_new_status NE '00'
                                THEN iv_new_status
                                ELSE gc_status-em_processamento ).
    ENDIF.
    me->convert_cds_to_table( EXPORTING iv_new_status  = lv_status
                                        it_emissao_cds = lt_emissao_new
                              IMPORTING et_historico   = et_historico
                                        et_return      = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados
* --------------------------------------------------------------------- ------
    me->save( EXPORTING it_historico = et_historico
              IMPORTING et_return    = et_return ).

  ENDMETHOD.


  METHOD delete_issue.

    FREE: et_return.

    IF it_emissao_cds[] IS INITIAL.
      " Registro não encontrado.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '003' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    me->convert_cds_to_table( EXPORTING it_emissao_cds = it_emissao_cds
                                        it_serie_cds   = it_serie_cds
                              IMPORTING et_historico   = DATA(lt_historico)
                                        et_serie       = DATA(lt_serie)
                                        et_return      = et_return ).

    IF lt_historico[] IS NOT INITIAL.

      DELETE ztmm_his_dep_fec FROM TABLE lt_historico.

      IF sy-subrc NE 0.
        " Falha ao eliminar o registro.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

    IF lt_serie[] IS NOT INITIAL.

      DELETE ztmm_his_dep_ser FROM TABLE lt_serie.

      IF sy-subrc NE 0.
        " Falha ao eliminar o registro.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD save_series.

    DATA: lt_serie_cds_new TYPE ty_t_serie_cds,
          lt_serie_cds_key TYPE ty_t_serie_cds.

    FREE: et_serie, et_return.

* ---------------------------------------------------------------------------
* Recupera dados de emissão e série
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING it_emissao_cds = CORRESPONDING #( it_serie_cds )
                  IMPORTING et_emissao_cds = DATA(lt_emissao_cds)
                            et_serie_cds   = DATA(lt_serie_cds) ).

* ---------------------------------------------------------------------------
* Valida se é possível adicionar nova Série
* ---------------------------------------------------------------------------
    LOOP AT lt_emissao_cds INTO DATA(ls_emissao_cds).

      IF ls_emissao_cds-materialtype NE gc_tipo_material-zcom.
        " Tipo Material '&1' não habilitado para cadastro de série.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '009'
                                   message_v1 = ls_emissao_cds-materialtype ) ).
        CONTINUE.
      ENDIF.

      " Recupera as Séries cadastradas
      lt_serie_cds_key = VALUE #( FOR ls_ser IN lt_serie_cds WHERE (
                                          material           = ls_emissao_cds-material
                                   AND originplant           = ls_emissao_cds-originplant
                                   AND originstoragelocation = ls_emissao_cds-originstoragelocation
                                   AND batch                 = ls_emissao_cds-batch
                                   AND originunit            = ls_emissao_cds-originunit
                                   AND unit                  = ls_emissao_cds-unit
                                   AND destinyplant          = ls_emissao_cds-destinyplant
                                   AND destinystoragelocation            = ls_emissao_cds-destinystoragelocation
                                   AND guid                  = ls_emissao_cds-guid
                                   AND processstep           = ls_emissao_cds-processstep
                                   AND prmdepfecid           = ls_emissao_cds-prmdepfecid
                                   AND eantype               = ls_emissao_cds-eantype   )
                                   ( CORRESPONDING #( ls_ser ) ) ).

      DATA(lv_lines) = lines(  lt_serie_cds_key[] ).

      READ TABLE it_serie_cds TRANSPORTING NO FIELDS WITH KEY material              = ls_emissao_cds-material
                                                              originplant           = ls_emissao_cds-originplant
                                                              originstoragelocation = ls_emissao_cds-originstoragelocation
                                                              batch                 = ls_emissao_cds-batch
                                                              originunit            = ls_emissao_cds-originunit
                                                              unit                  = ls_emissao_cds-unit
                                                              destinyplant          = ls_emissao_cds-destinyplant
                                                              destinystoragelocation = ls_emissao_cds-destinystoragelocation

                                                              guid                  = ls_emissao_cds-guid
                                                              processstep           = ls_emissao_cds-processstep
                                                              prmdepfecid           = ls_emissao_cds-prmdepfecid
                                                              eantype               = ls_emissao_cds-eantype
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT it_serie_cds REFERENCE INTO DATA(ls_serie_cds) FROM sy-tabix.

        IF ls_serie_cds->material              NE ls_emissao_cds-material
        OR ls_serie_cds->originplant           NE ls_emissao_cds-originplant
        OR ls_serie_cds->originstoragelocation NE ls_emissao_cds-originstoragelocation
        OR ls_serie_cds->batch                 NE ls_emissao_cds-batch
        OR ls_serie_cds->originunit            NE ls_emissao_cds-originunit
        OR ls_serie_cds->unit                  NE ls_emissao_cds-unit
        OR ls_serie_cds->destinyplant          NE ls_emissao_cds-destinyplant
        OR ls_serie_cds->destinystoragelocation   NE ls_emissao_cds-destinystoragelocation
        OR ls_serie_cds->guid                  NE ls_emissao_cds-guid
        OR ls_serie_cds->processstep           NE ls_emissao_cds-processstep
        OR ls_serie_cds->prmdepfecid           NE ls_emissao_cds-prmdepfecid
        OR ls_serie_cds->eantype               NE ls_emissao_cds-eantype.
          EXIT.
        ENDIF.

        IF line_exists( lt_serie_cds[ material              = ls_serie_cds->material
                                      originplant           = ls_serie_cds->originplant
                                      originstoragelocation = ls_serie_cds->originstoragelocation
                                      batch                 = ls_serie_cds->batch
                                      originunit            = ls_serie_cds->originunit
                                      unit                  = ls_serie_cds->unit
                                      destinyplant          = ls_serie_cds->destinyplant
                                      destinystoragelocation = ls_serie_cds->destinystoragelocation
                                      guid                  = ls_serie_cds->guid
                                      processstep           = ls_serie_cds->processstep
                                      prmdepfecid           = ls_serie_cds->prmdepfecid
                                      eantype               = ls_serie_cds->eantype
                                      serialno              = ls_serie_cds->serialno ] ).
          " Série &1 já foi adicionada na lista.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '005'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }| ) ).
          CONTINUE.
        ENDIF.

        IF lv_lines >= ls_emissao_cds-usedstock.
          " Não é possível adicionar &1. Séries ultrapassam qtd. transf. &2.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '004'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }|
                                 message_v2 = ls_emissao_cds-usedstock ) ).
          CONTINUE.
        ENDIF.

        lt_serie_cds_new[] = VALUE #( BASE lt_serie_cds_new ( ls_serie_cds->* ) ).
        lt_serie_cds[] = VALUE #( BASE lt_serie_cds_new ( ls_serie_cds->* ) ).
        lv_lines = lv_lines + 1.

        " Série &1 adicionada com sucesso.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '006'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }| ) ).


      ENDLOOP.

    ENDLOOP.

    me->convert_cds_to_table( EXPORTING it_emissao_cds = lt_emissao_cds
                                        it_serie_cds   = lt_serie_cds_new
                              IMPORTING et_serie       = DATA(lt_serie)
                                        et_return      = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return.

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING it_serie  = lt_serie
              IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return.

    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD save_series_retorno.

    DATA: lt_serie_cds_new TYPE ty_t_serie_cds,
          lt_serie_cds_key TYPE ty_t_ret_serie_cds.

    FREE: et_serie, et_return.

* ---------------------------------------------------------------------------
* Recupera dados de emissão e série
* ---------------------------------------------------------------------------
    me->get_info_retorno( EXPORTING it_emissao_cds = CORRESPONDING #( it_serie_cds )
                          IMPORTING et_armazenagem_cds = DATA(lt_armazenagem_cds)
                                    et_ret_serie_cds   = DATA(lt_ret_serie_cds) ).

* ---------------------------------------------------------------------------
* Valida se é possível adicionar nova Série
* ---------------------------------------------------------------------------
    DATA(lt_serie_sort) = it_serie_cds.
    SORT lt_serie_sort  BY Material Guid EANType.
    SORT lt_ret_serie_cds BY Material Guid SerialNo.

    LOOP AT lt_armazenagem_cds INTO DATA(ls_armazenagem_cds).

      IF ls_armazenagem_cds-MaterialType NE gc_tipo_material-zcom.
        " Tipo Material '&1' não habilitado para cadastro de série.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '009'
                                   message_v1 = ls_armazenagem_cds-materialtype ) ).
        CONTINUE.
      ENDIF.

      " Recupera as Séries cadastradas
      lt_serie_cds_key = VALUE #( FOR ls_ser IN lt_ret_serie_cds WHERE (
                                          material           = ls_armazenagem_cds-Material
                                   AND guid                  = ls_armazenagem_cds-guid
                                   AND eantype               = ls_armazenagem_cds-eantype   )
                                   ( CORRESPONDING #( ls_ser ) ) ).

      DATA(lv_lines) = lines(  lt_serie_cds_key[] ).

      LOOP AT lt_serie_sort REFERENCE INTO DATA(ls_serie_cds) FROM sy-tabix.

        READ TABLE lt_ret_serie_cds TRANSPORTING NO FIELDS WITH KEY material      = ls_serie_cds->Material
                                                            guid                  = ls_serie_cds->Guid
                                                            SerialNo              = ls_serie_cds->SerialNo
                                                            BINARY SEARCH.
        IF sy-subrc = 0.
          CONTINUE.
        ENDIF.

        IF line_exists( lt_ret_serie_cds[ material              = ls_serie_cds->material
                                      guid                  = ls_serie_cds->guid
                                      eantype               = ls_serie_cds->eantype
                                      serialno              = ls_serie_cds->serialno ] ).
          " Série &1 já foi adicionada na lista.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '005'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }| ) ).
          CONTINUE.
        ENDIF.

        IF lv_lines >= ls_armazenagem_cds-UtilizacaoLivre.
          " Não é possível adicionar &1. Séries ultrapassam qtd. transf. &2.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '004'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }|
                                 message_v2 = ls_armazenagem_cds-EstoqueLivreUtilizacao ) ).
          CONTINUE.
        ENDIF.

        lt_serie_cds_new[] = VALUE #( BASE lt_serie_cds_new ( ls_serie_cds->* ) ).
        lt_ret_serie_cds[] = VALUE #( BASE lt_ret_serie_cds ( CORRESPONDING #( ls_serie_cds->* ) ) ).
        lv_lines = lv_lines + 1.

        " Série &1 adicionada com sucesso.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie field = 'SERIALNO' type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '006'
                                 message_v1 = |{ ls_serie_cds->serialno ALPHA = OUT }| ) ).


      ENDLOOP.

    ENDLOOP.

    me->convert_cds_to_table( EXPORTING it_emissao_cds = CORRESPONDING #( lt_armazenagem_cds )
                                        it_serie_cds   = lt_serie_cds_new
                              IMPORTING et_serie       = DATA(lt_serie)
                                        et_return      = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return.

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING it_serie  = lt_serie
              IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return.

    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD delete_series.

    FREE: et_return.

    IF it_serie_cds[] IS INITIAL.
      " Registro não encontrado.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '003' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    me->convert_cds_to_table( EXPORTING it_emissao_cds = it_emissao_cds
                                        it_serie_cds   = it_serie_cds
                              IMPORTING et_serie       = DATA(lt_serie)
                                        et_return      = et_return ).

    IF lt_serie[] IS NOT INITIAL.

      DELETE ztmm_his_dep_ser FROM TABLE lt_serie.

      IF sy-subrc NE 0.
        " Falha ao eliminar o registro.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD delete_series_retorno.

    FREE: et_return.

    IF it_ret_serie_cds[] IS INITIAL.
      " Registro não encontrado.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '003' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.


    SELECT *
     FROM ztmm_his_dep_ser
     FOR ALL ENTRIES IN @it_ret_serie_cds
     WHERE material = @it_ret_serie_cds-Material
       AND guid     = @it_ret_serie_cds-Guid
       AND serialno = @it_ret_serie_cds-SerialNo
       INTO TABLE @DATA(lt_serie).

    CHECK lt_serie IS NOT INITIAL.

    DELETE ztmm_his_dep_ser FROM TABLE lt_serie.

    IF sy-subrc NE 0.
      " Falha ao eliminar o registro.
      et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '002' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_next_guid.

    FREE: ev_guid, et_return.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).

        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD calculate_material_stock.

    DATA: lt_wmdvsx TYPE STANDARD TABLE OF bapiwmdvs,
          lt_wmdvex TYPE STANDARD TABLE OF bapiwmdve,
          ls_return TYPE bapireturn,
          lv_menge  TYPE bstmg.

    FREE: et_emissao_cds.

    et_emissao_cds[] = it_emissao_cds[].

    LOOP AT et_emissao_cds REFERENCE INTO DATA(ls_emissao).

      CHECK ls_emissao->guid IS INITIAL.
      IF ls_emissao->useavailable EQ abap_true.
        ls_emissao->usedstock   = ls_emissao->availablestock.
      ELSE.

        IF ls_emissao->unit NE ls_emissao->originunit.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = ls_emissao->material
              i_in_me              = ls_emissao->unit
              i_out_me             = ls_emissao->originunit
              i_menge              = ls_emissao->usedstock
            IMPORTING
              e_menge              = ls_emissao->usedstock
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.

          IF sy-subrc <> 0.
            ls_emissao->usedstock = -1.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDLOOP.

*
*      FREE: ls_return, lt_wmdvex.
*
** --------------------------------------------------------------------
** Recupera disponibilidade de estoque do material
** --------------------------------------------------------------------
*      TRY.
*          CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
*            EXPORTING
*              plant    = ls_emissao->OriginPlant
*              material = CONV matnr18( ls_emissao->Material )
*              stge_loc = ls_emissao->OriginStorageLocation
*              unit     = ls_emissao->Unit
*            IMPORTING
*              return   = ls_return
*            TABLES
*              wmdvsx   = lt_wmdvsx
*              wmdvex   = lt_wmdvex.
*
*          DATA(ls_wmdvex) = lt_wmdvex[ 1 ].
*        CATCH cx_root.
*          CLEAR ls_wmdvex.
*      ENDTRY.
*
** --------------------------------------------------------------------
** Aplica conversão de unidade de medida, se necessário
** --------------------------------------------------------------------
*      IF ls_emissao->Unit EQ ls_emissao->OriginUnit.
*
*        ls_emissao->UsedStock = ls_wmdvex-com_qty.
*
*      ELSE.
*
*        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
*          EXPORTING
*            i_matnr              = ls_emissao->Material
*            i_in_me              = ls_emissao->OriginUnit
*            i_out_me             = ls_emissao->Unit
*            i_menge              = ls_wmdvex-com_qty
*          IMPORTING
*            e_menge              = ls_emissao->UsedStock
*          EXCEPTIONS
*            error_in_application = 1
*            error                = 2
*            OTHERS               = 3.
*
*        IF sy-subrc <> 0.
*          ls_emissao->UsedStock = -1.
*        ENDIF.
*      ENDIF.





  ENDMETHOD.


  METHOD convert_cds_to_table.

    FREE: et_historico, et_serie, et_return.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    et_historico[] = VALUE #( FOR ls_emissao_cds IN it_emissao_cds (
                              material                            = ls_emissao_cds-material
                              plant                               = ls_emissao_cds-originplant
                              storage_location                    = ls_emissao_cds-originstoragelocation
                              batch                               = ls_emissao_cds-batch
                              origin_unit                         = ls_emissao_cds-originunit
                              unit                                = ls_emissao_cds-unit
                              plant_dest                          = ls_emissao_cds-destinyplant
                              storage_location_dest               = ls_emissao_cds-destinystoragelocation
                              guid                                = COND #( WHEN iv_new_guid IS NOT INITIAL
                                                                            THEN me->get_next_guid( IMPORTING et_return = et_return )
                                                                            ELSE ls_emissao_cds-guid )
*                              guid                                = me->get_next_guid( IMPORTING et_return = et_return )
                              process_step                        = ls_emissao_cds-processstep
                              status                              = COND #( WHEN iv_new_status IS NOT INITIAL
                                                                            THEN iv_new_status
                                                                            ELSE ls_emissao_cds-status )
                              prm_dep_fec_id                      = ls_emissao_cds-prmdepfecid
                              description                         = ls_emissao_cds-description
                              origin_plant                        = ls_emissao_cds-originplant
                              origin_plant_type                   = ls_emissao_cds-originplanttype
                              origin_storage_location             = ls_emissao_cds-originstoragelocation
                              destiny_plant                       = ls_emissao_cds-destinyplant
                              destiny_plant_type                  = ls_emissao_cds-destinyplanttype
                              destiny_storage_location            = ls_emissao_cds-destinystoragelocation
                              use_available                       = ls_emissao_cds-useavailable
                              available_stock                     = ls_emissao_cds-availablestock
                              used_stock                          = ls_emissao_cds-usedstock
                              used_stock_conv                     = ls_emissao_cds-usedstock_conve
                              carrier                             = ls_emissao_cds-carrier
                              driver                              = ls_emissao_cds-driver
                              equipment                           = ls_emissao_cds-equipment
                              shipping_conditions                 = ls_emissao_cds-shippingconditions
                              shipping_type                       = ls_emissao_cds-shippingtype
                              equipment_tow1                      = ls_emissao_cds-equipmenttow1
                              equipment_tow2                      = ls_emissao_cds-equipmenttow2
                              equipment_tow3                      = ls_emissao_cds-equipmenttow3
                              freight_mode                        = ls_emissao_cds-freightmode
                              ean_type                            = ls_emissao_cds-eantype
                              main_plant                          = ls_emissao_cds-mainplant
                              main_purchase_order                 = ls_emissao_cds-mainpurchaseorder
                              main_purchase_order_item            = ls_emissao_cds-mainpurchaseorderitem
                              main_material_document              = ls_emissao_cds-mainmaterialdocument
                              main_material_document_year         = ls_emissao_cds-mainmaterialdocumentyear
                              main_material_document_item         = ls_emissao_cds-mainmaterialdocumentitem
                              order_quantity                      = ls_emissao_cds-orderquantity
                              order_quantity_unit                 = ls_emissao_cds-orderquantityunit
                              purchase_order                      = ls_emissao_cds-purchaseorder
                              purchase_order_item                 = ls_emissao_cds-purchaseorderitem
                              incoterms1                          = ls_emissao_cds-incoterms1
                              incoterms2                          = ls_emissao_cds-incoterms2
                              out_sales_order                     = ls_emissao_cds-outsalesorder
                              out_sales_order_item                = ls_emissao_cds-outsalesorderitem
                              out_delivery_document               = ls_emissao_cds-outdeliverydocument
                              out_delivery_document_item          = ls_emissao_cds-outdeliverydocumentitem
                              out_material_document               = ls_emissao_cds-outmaterialdocument
                              out_material_document_year          = ls_emissao_cds-outmaterialdocumentyear
                              out_material_document_item          = ls_emissao_cds-outmaterialdocumentitem
                              out_br_nota_fiscal                  = ls_emissao_cds-outbr_notafiscal
                              out_br_nota_fiscal_item             = ls_emissao_cds-outbr_notafiscalitem
                              rep_br_nota_fiscal                  = ls_emissao_cds-repbr_notafiscal
                              in_delivery_document                = ls_emissao_cds-indeliverydocument
                              in_delivery_document_item           = ls_emissao_cds-indeliverydocumentitem
                              in_material_document                = ls_emissao_cds-inmaterialdocument
                              in_material_document_year           = ls_emissao_cds-inmaterialdocumentyear
                              in_material_document_item           = ls_emissao_cds-inmaterialdocumentitem
                              in_br_nota_fiscal                   = ls_emissao_cds-inbr_notafiscal
                              in_br_nota_fiscal_item              = ls_emissao_cds-inbr_notafiscalitem
                              created_by                          = COND #( WHEN ls_emissao_cds-createdby IS NOT INITIAL
                                                                            THEN ls_emissao_cds-createdby
                                                                            ELSE sy-uname )
                              created_at                          = COND #( WHEN ls_emissao_cds-createdat IS NOT INITIAL
                                                                            THEN ls_emissao_cds-createdat
                                                                            ELSE lv_timestamp )
                              last_changed_by                     = sy-uname
                              last_changed_at                     = lv_timestamp
                              local_last_changed_at               = lv_timestamp ) ).

    et_serie[] = VALUE #( FOR ls_serie_cds IN it_serie_cds (
                          material                            = ls_serie_cds-material
                          plant                               = ls_serie_cds-originplant
                          storage_location                    = ls_serie_cds-originstoragelocation
                          batch                               = ls_serie_cds-batch
                          guid                                = ls_serie_cds-guid
                          process_step                        = ls_serie_cds-processstep
                          plant_dest                          = ls_serie_cds-destinyplant
                          storage_location_dest               = ls_serie_cds-destinystoragelocation


                          serialno                            = |{ ls_serie_cds-serialno ALPHA = IN }|
                          created_by                          = COND #( WHEN ls_serie_cds-createdby IS NOT INITIAL
                                                                            THEN ls_serie_cds-createdby
                                                                            ELSE sy-uname )
                          created_at                          = COND #( WHEN ls_serie_cds-createdat IS NOT INITIAL
                                                                            THEN ls_serie_cds-createdat
                                                                            ELSE lv_timestamp )
                          last_changed_by                     = sy-uname
                          last_changed_at                     = lv_timestamp
                          local_last_changed_at               = lv_timestamp ) ).

    LOOP AT et_serie REFERENCE INTO DATA(ls_serie).

      READ TABLE et_historico INTO DATA(ls_historico) WITH KEY material         = ls_serie->material
                                                               plant            = ls_serie->plant
                                                               storage_location = ls_serie->storage_location
                                                               process_step     = ls_serie->process_step.
      CHECK sy-subrc EQ 0.

      ls_serie->guid = ls_historico-guid.

    ENDLOOP.

  ENDMETHOD.


  METHOD build_reported.


    DATA: lo_dataref            TYPE REF TO data.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-emissao.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-emissao.
        WHEN gc_cds-serie.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-serie.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-emissao.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg> = new_message( id       = ls_return-id
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
        WHEN gc_cds-emissao.
          es_reported-emissao[]  = VALUE #( BASE es_reported-emissao[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN gc_cds-serie.
          es_reported-serie[]    = VALUE #( BASE es_reported-serie[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-emissao[]  = VALUE #( BASE es_reported-emissao[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_documents_f02.

    DATA: lt_serie_cds_key TYPE ty_t_serie_cds.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorizaçã
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = zclmm_adm_emissao_nf_events=>gc_autorizacao-criar_nfe
                          IMPORTING et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de emissão e série
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING it_emissao_cds = CORRESPONDING #( it_emissao_cds )
                  IMPORTING et_emissao_cds = DATA(lt_emissao_cds)
                            et_serie_cds   = DATA(lt_serie_cds) ).

* ---------------------------------------------------------------------------
* Atualiza campos editados
* ---------------------------------------------------------------------------
    LOOP AT it_emissao_cds INTO DATA(ls_emissao_cds).

      CHECK ls_emissao_cds-status NE gc_status-incompleto.
      CHECK ls_emissao_cds-status NE gc_status-completo.

      READ TABLE lt_emissao_cds REFERENCE INTO DATA(ls_emissao) WITH KEY material              = ls_emissao_cds-material
                                                                         originplant           = ls_emissao_cds-originplant
                                                                         originstoragelocation = ls_emissao_cds-originstoragelocation
                                                                         batch                 = ls_emissao_cds-batch
                                                                         originunit            = ls_emissao_cds-originunit
                                                                         prmdepfecid           = ls_emissao_cds-prmdepfecid
                                                                         unit                  = ls_emissao_cds-unit
                                                                         guid                  = ls_emissao_cds-guid
                                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      ls_emissao->carrier               = COND #( WHEN ls_emissao_cds-newcarrier IS NOT INITIAL
                                                  THEN ls_emissao_cds-newcarrier
                                                  ELSE ls_emissao->carrier ).
      ls_emissao->driver                = COND #( WHEN ls_emissao_cds-newdriver IS NOT INITIAL
                                                  THEN ls_emissao_cds-newdriver
                                                  ELSE ls_emissao->driver ).
      ls_emissao->equipment             = COND #( WHEN ls_emissao_cds-newequipment IS NOT INITIAL
                                                  THEN ls_emissao_cds-newequipment
                                                  ELSE ls_emissao->equipment ).
      ls_emissao->shippingconditions    = COND #( WHEN ls_emissao_cds-newshippingconditions IS NOT INITIAL
                                                  THEN ls_emissao_cds-newshippingconditions
                                                  ELSE ls_emissao->shippingconditions ).
      ls_emissao->shippingtype          = COND #( WHEN ls_emissao_cds-newshippingtype IS NOT INITIAL
                                                  THEN ls_emissao_cds-newshippingtype
                                                  ELSE ls_emissao->shippingtype ).
      ls_emissao->equipmenttow1         = COND #( WHEN ls_emissao_cds-newequipmenttow1 IS NOT INITIAL
                                                  THEN ls_emissao_cds-newequipmenttow1
                                                  ELSE ls_emissao->equipmenttow1 ).
      ls_emissao->equipmenttow2         = COND #( WHEN ls_emissao_cds-newequipmenttow2 IS NOT INITIAL
                                                  THEN ls_emissao_cds-newequipmenttow2
                                                  ELSE ls_emissao->equipmenttow2 ).
      ls_emissao->equipmenttow3         = COND #( WHEN ls_emissao_cds-newequipmenttow3 IS NOT INITIAL
                                                  THEN ls_emissao_cds-newequipmenttow3
                                                  ELSE ls_emissao->equipmenttow3 ).
      ls_emissao->freightmode           = COND #( WHEN ls_emissao_cds-newfreightmode IS NOT INITIAL
                                                  THEN ls_emissao_cds-newfreightmode
                                                  ELSE ls_emissao->freightmode ).
    ENDLOOP.

    me->save( EXPORTING iv_background  = abap_true
                        it_emissao_cds = lt_emissao_cds
              IMPORTING et_historico   = DATA(lt_historico)
                        et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Aplica validação
* ---------------------------------------------------------------------------
    LOOP AT lt_emissao_cds INTO ls_emissao_cds.

      " Recupera as Séries cadastradas
      lt_serie_cds_key[] = VALUE #( FOR ls_ser IN lt_serie_cds WHERE (
                                          material              = ls_emissao_cds-material
                                      AND originplant           = ls_emissao_cds-originplant
                                      AND originstoragelocation = ls_emissao_cds-originstoragelocation
                                      AND originunit            = ls_emissao_cds-originunit
                                      AND unit                  = ls_emissao_cds-unit
                                      AND destinyplant          = ls_emissao_cds-destinyplant
                                      AND destinystoragelocation = ls_emissao_cds-destinystoragelocation
                                      AND guid                  = ls_emissao_cds-guid
                                      AND processstep           = ls_emissao_cds-processstep )
                                      ( CORRESPONDING #( ls_ser ) ) ).

      DATA(lv_lines) = lines(  lt_serie_cds_key[] ).

      IF ls_emissao_cds-materialtype NE gc_tipo_material-zcom AND lv_lines > 0.
        " Tipo Material '&1' não habilitado para cadastro de série.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '009'
                                                message_v1 = ls_emissao_cds-materialtype ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.

      IF ls_emissao_cds-materialtype EQ gc_tipo_material-zcom AND lv_lines > ls_emissao_cds-usedstock.
        " Quantidade de série ultrapassam quantidade transferida.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '007' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.

      IF ls_emissao_cds-materialtype EQ gc_tipo_material-zcom AND lv_lines < ls_emissao_cds-usedstock.
        " Para Tipo Material '&1', qtd. série deve ser a mesma que qtd. transf.
        et_return[] = VALUE #( BASE et_return ( parameter  = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '008'
                                                message_v1 = ls_emissao_cds-materialtype ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.

    ENDLOOP.

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama processo de criação de documentos
* ---------------------------------------------------------------------------
    me->create_documents( EXPORTING it_historico_key = lt_historico
                          IMPORTING et_return        = et_return ).

    " ---------------------------------------------------------------------------
    " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
    " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
    " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
    " ---------------------------------------------------------------------------
    me->format_return( EXPORTING iv_change_error_type   = abap_true
                                 iv_change_warning_type = abap_true
                       CHANGING  ct_return              = et_return ).

  ENDMETHOD.


  METHOD create_ordem_frete.


    TYPES: BEGIN OF ty_key,
             guid TYPE sysuuid_x16,
           END OF ty_key.

    DATA: lt_key TYPE TABLE OF ty_key.

    lt_key = VALUE #( FOR ls_emissao_cds IN it_emissao_cds ( guid = ls_emissao_cds-guid ) ).

    SORT  lt_key. DELETE ADJACENT DUPLICATES FROM lt_key.

    CHECK lt_key IS NOT INITIAL.

    SELECT *
        FROM ztmm_his_dep_fec
        FOR ALL ENTRIES IN @lt_key
        WHERE guid         = @lt_key-guid
        INTO TABLE @DATA(lt_historico).

    DATA(lt_historico_aux) = lt_historico.
    SORT lt_historico_aux BY out_delivery_document.
    DELETE ADJACENT DUPLICATES FROM lt_historico_aux COMPARING out_delivery_document.

    SORT lt_historico_aux BY origin_plant destiny_plant.

    DATA lv_centro_origem TYPE werks_d.
    DATA lv_centro_destino TYPE werks_d.
    DATA lt_historico_aux2 TYPE STANDARD TABLE OF ztmm_his_dep_fec.
    DATA lt_historico_aux3 TYPE STANDARD TABLE OF ztmm_his_dep_fec.

    LOOP AT lt_historico_aux ASSIGNING FIELD-SYMBOL(<fs_historico_aux>).
      DATA(lv_tabix) = sy-tabix.
      APPEND <fs_historico_aux> TO lt_historico_aux2.
      READ TABLE lt_historico_aux ASSIGNING FIELD-SYMBOL(<fs_hist>) INDEX lv_tabix + 1.
      IF sy-subrc = 0 AND <fs_hist>-origin_plant = <fs_historico_aux>-origin_plant AND <fs_hist>-destiny_plant = <fs_historico_aux>-destiny_plant.
        CONTINUE.
      ENDIF.

      DATA(lo_criar_ordem_frete) = NEW zclmm_criar_ordem_frete( ).

      et_return = VALUE #( BASE et_return
        FOR ls_mensagem IN lo_criar_ordem_frete->executar( it_his_dep_fec = lt_historico_aux2 )
        ( id         = ls_mensagem-msgid
          number     = ls_mensagem-msgno
          type       = ls_mensagem-msgty
          message_v1 = ls_mensagem-msgv1
          message_v2 = ls_mensagem-msgv2
          message_v3 = ls_mensagem-msgv3
          message_v4 = ls_mensagem-msgv4
          message    = ls_mensagem-msg_txt )            "#EC CI_CONV_OK
      ).

      DATA(lv_ordemfrete) = lo_criar_ordem_frete->get_ordemfrete( ).
      LOOP AT lt_historico_aux2 ASSIGNING FIELD-SYMBOL(<fs_historico_aux2>).
        <fs_historico_aux2>-freight_order_id = lv_ordemfrete.
        APPEND <fs_historico_aux2> TO lt_historico_aux3.
      ENDLOOP.

      CLEAR lt_historico_aux2.
    ENDLOOP.

    SORT lt_historico_aux3 BY out_delivery_document.
    LOOP AT lt_historico ASSIGNING FIELD-SYMBOL(<fs_historico>).
      READ TABLE lt_historico_aux3 ASSIGNING <fs_historico_aux>
      WITH KEY out_delivery_document = <fs_historico>-out_delivery_document BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_historico>-freight_order_id = <fs_historico_aux>-freight_order_id.
        IF <fs_historico_aux>-freight_order_id IS NOT INITIAL.
          <fs_historico>-status = gc_status-ordem_frete_job.
        ELSE.
          <fs_historico>-status = gc_status-incompleto.
        ENDIF.
      ENDIF.
    ENDLOOP.

    me->save_background( EXPORTING it_historico = lt_historico
*                                      it_serie     = et_serie
                         IMPORTING et_return    = DATA(lt_return) ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].


  ENDMETHOD.


  METHOD retry_process.

    TYPES: BEGIN OF ty_key,
             guid TYPE sysuuid_x16,
           END OF ty_key.

    DATA: lt_key TYPE TABLE OF ty_key.

    lt_key = VALUE #( FOR ls_emissao_cds IN it_emissao_cds ( guid = ls_emissao_cds-guid ) ).

    SORT  lt_key. DELETE ADJACENT DUPLICATES FROM lt_key.

    CHECK lt_key IS NOT INITIAL.

    SELECT *
        FROM ztmm_his_dep_fec
        FOR ALL ENTRIES IN @lt_key
        WHERE guid         = @lt_key-guid
        INTO TABLE @DATA(lt_historico).


    LOOP AT lt_historico ASSIGNING FIELD-SYMBOL(<fs_historico>).
      IF <fs_historico>-purchase_order IS INITIAL.
        <fs_historico>-status = gc_status-em_processamento. "01-Processamento
      ENDIF.

      IF <fs_historico>-out_delivery_document IS INITIAL AND
         <fs_historico>-purchase_order IS NOT INITIAL.
        <fs_historico>-status = gc_status-saida_nota.  "09-Aguardando Criação de Remessa
      ENDIF.

      IF <fs_historico>-out_material_document IS INITIAL AND
         <fs_historico>-out_delivery_document IS NOT INITIAL AND
         <fs_historico>-carrier IS INITIAL.
        <fs_historico>-status = gc_status-ordem_frete_job.  "12  Aguardando Saída de Mercadoria
      ENDIF.

      IF <fs_historico>-out_material_document IS INITIAL AND
         <fs_historico>-out_delivery_document IS NOT INITIAL AND
         <fs_historico>-carrier IS NOT INITIAL AND
         <fs_historico>-freight_order_id IS INITIAL.
        <fs_historico>-status = gc_status-ordem_frete.  "11  Aguardando Ordem de Frete
      ENDIF.

      IF <fs_historico>-out_material_document IS INITIAL AND
         <fs_historico>-out_delivery_document IS NOT INITIAL AND
         <fs_historico>-carrier IS NOT INITIAL AND
         <fs_historico>-freight_order_id IS NOT INITIAL.
        <fs_historico>-status = gc_status-ordem_frete_job.  "12  Aguardando Ordem de Frete
      ENDIF.

      IF <fs_historico>-in_delivery_document IS INITIAL AND
         <fs_historico>-carrier IS NOT INITIAL AND
         <fs_historico>-out_br_nota_fiscal IS NOT INITIAL.
        <fs_historico>-status = gc_status-nota_input .  "08  Aguardando nota de Entrada
      ENDIF.

      IF ( <fs_historico>-in_delivery_document IS INITIAL OR
           ( <fs_historico>-in_delivery_document IS NOT INITIAL AND <fs_historico>-in_material_document IS INITIAL ) ) AND
         <fs_historico>-carrier IS INITIAL AND
         <fs_historico>-out_br_nota_fiscal IS NOT INITIAL.
        <fs_historico>-status = gc_status-entrada_merc.  "04-Aguardando job Entrada Mercadoria
      ENDIF.

      IF <fs_historico>-status = gc_status-nota_rejeita AND <fs_historico>-out_br_nota_fiscal IS NOT INITIAL.
        SELECT COUNT(*) FROM ekpo WHERE ebeln = @<fs_historico>-purchase_order AND loekz = ''.
        IF sy-subrc = 0.
          DATA(lv_erro) = abap_true.
          EXIT.
        ENDIF.
        SELECT COUNT(*) FROM j_1bnfdoc WHERE docnum = @<fs_historico>-out_br_nota_fiscal AND cancel = ''.
        IF sy-subrc = 0.
          lv_erro = abap_true.
          EXIT.
        ENDIF.
      ENDIF.

*- SE status 05 Nota Rejeitada pela SEFAZ E EKPO-LOEKZ <> "L" E J_1BNFDOC-CANCEL <> "X" E out_delivery_document(preenchido)
*exibir mensagem de validação: "Estornar nota fiscal pela J1BNFE e marcar o pedido para eliminação".

    ENDLOOP.
    IF lv_erro = abap_true.
      APPEND VALUE #(
        type = 'E'
        id   = 'ZMM_DEPOSITO_FECHADO'
        number = '043'
      ) TO et_return.
    ENDIF.

    me->save_background( EXPORTING it_historico = lt_historico
*                                      it_serie     = et_serie
                         IMPORTING et_return    = DATA(lt_return) ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

  ENDMETHOD.


  METHOD create_documents_f05.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    zclmm_aux_ret_armazenagem=>check_permission( EXPORTING iv_actvt  = zclmm_aux_pend_ordem_de_frete=>gc_autorizacao-criar_nfe
                                                 IMPORTING et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING iv_background      = abap_true
                        it_armazenagem_cds = it_armazenagem_cds
              IMPORTING et_historico       = DATA(lt_historico)
                        et_return          = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Chama processo de criação de documentos
* ---------------------------------------------------------------------------
    me->create_documents( EXPORTING it_historico_key = lt_historico
                          IMPORTING et_return        = et_return ).

    " ---------------------------------------------------------------------------
    " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
    " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
    " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
    " ---------------------------------------------------------------------------
    me->format_return( EXPORTING iv_change_error_type   = abap_true
                                 iv_change_warning_type = abap_true
                       CHANGING  ct_return              = et_return ).
  ENDMETHOD.


  METHOD create_documents_f12.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    zclmm_aux_pend_ordem_de_frete=>check_permission( EXPORTING iv_actvt  = zclmm_aux_pend_ordem_de_frete=>gc_autorizacao-criar_nfe
                                                     IMPORTING et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING iv_background   = abap_true
                        it_pendente_cds = it_pendente_cds
              IMPORTING et_historico    = DATA(lt_historico)
                        et_return       = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Chama processo de criação de documentos
* ---------------------------------------------------------------------------
    me->create_documents( EXPORTING it_historico_key = lt_historico
                          IMPORTING et_return        = et_return ).

    " ---------------------------------------------------------------------------
    " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
    " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
    " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
    " ---------------------------------------------------------------------------
    me->format_return( EXPORTING iv_change_error_type   = abap_true
                                 iv_change_warning_type = abap_true
                       CHANGING  ct_return              = et_return ).
  ENDMETHOD.


  METHOD create_documents_f13.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    zclmm_reservas_pendentes=>check_permission( EXPORTING iv_actvt  = zclmm_reservas_pendentes=>gc_autorizacao-criar_nfe
                                                IMPORTING et_return = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de emissão e série
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING it_reserva_cds = CORRESPONDING #( it_reserva_cds )
                  IMPORTING et_reserva_cds = DATA(lt_reserva_cds) ).

* ---------------------------------------------------------------------------
* Atualiza campos editados
* ---------------------------------------------------------------------------
    LOOP AT it_reserva_cds REFERENCE INTO DATA(ls_reserva_cds).

      CHECK ls_reserva_cds->statushistorico NE gc_status-incompleto.
      CHECK ls_reserva_cds->statushistorico NE gc_status-completo.

      READ TABLE lt_reserva_cds REFERENCE INTO DATA(ls_reserva) WITH KEY reservation           = ls_reserva_cds->reservation
                                                                         dadosdohistorico      = ls_reserva_cds->dadosdohistorico
                                                                         BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      ls_reserva->transportador          = ls_reserva_cds->transportador.
      ls_reserva->driver                 = ls_reserva_cds->driver.
      ls_reserva->equipment              = ls_reserva_cds->equipment.
      ls_reserva->shipping_conditions    = ls_reserva_cds->shipping_conditions.
      ls_reserva->shipping_type          = ls_reserva_cds->shipping_type.
      ls_reserva->equipment_tow1         = ls_reserva_cds->equipment_tow1.
      ls_reserva->equipment_tow2         = ls_reserva_cds->equipment_tow2.
      ls_reserva->equipment_tow3         = ls_reserva_cds->equipment_tow3.
      ls_reserva->freight_mode           = ls_reserva_cds->freight_mode.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->save( EXPORTING iv_background  = abap_true
                        it_reserva_cds = lt_reserva_cds
              IMPORTING et_historico   = DATA(lt_historico)
                        et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Chama processo de criação de documentos
* ---------------------------------------------------------------------------
    me->create_documents( EXPORTING it_historico_key = lt_historico
                          IMPORTING et_return        = et_return ).

    " ---------------------------------------------------------------------------
    " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
    " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
    " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
    " ---------------------------------------------------------------------------
    me->format_return( EXPORTING iv_change_error_type   = abap_true
                                 iv_change_warning_type = abap_true
                       CHANGING  ct_return              = et_return ).
  ENDMETHOD.


  METHOD continue_document_creation.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Recupera dados referente ao pedido principal
* ---------------------------------------------------------------------------
    me->get_main_info( EXPORTING iv_invnumber = iv_invnumber
                                 iv_year      = iv_year
                       IMPORTING et_historico = DATA(lt_historico)
                                 et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Não continuar se o processamento estiver completo
    IF line_exists( lt_historico[ status = gc_status-completo ] ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Continua criação de documentos
* ---------------------------------------------------------------------------
    me->bapi_create_documents( EXPORTING it_historico_key  = lt_historico
                                         iv_update_history = abap_false
                               IMPORTING et_return         = et_return ).

  ENDMETHOD.


  METHOD create_documents.

* ---------------------------------------------------------------------------
* Chama evento para criação de documentos
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_DEPOSITO_FECHADO_EMI_NF'
      STARTING NEW TASK 'DEPOSITO_FECHADO_EMI_NF'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        it_historico_key = it_historico_key[].

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'DEPOSITO_FECHADO_EMI_NF'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_DEPOSITO_FECHADO_EMI_NF'
            IMPORTING
                et_messages = gt_return.
        gv_wait_async = abap_true.

      WHEN 'DEPOSITO_FECHADO_SALVAR'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_DEPOSITO_FECHADO_SALVAR'
            IMPORTING
                et_messages = gt_return.
        gv_wait_async = abap_true.

      WHEN 'BBP_INB_DELIVERY_CREATE'.
        RECEIVE RESULTS FROM FUNCTION 'BBP_INB_DELIVERY_CREATE'
            IMPORTING
                ef_delivery  = gv_in_delivery_document
            TABLES
                return       = gt_bapireturn.
        gv_wait_async = abap_true.
      WHEN OTHERS.
        IF p_task(11) = 'WS_DELIVERY'.
          RECEIVE RESULTS FROM FUNCTION 'WS_DELIVERY_UPDATE'
              IMPORTING
                ef_error_any_0              = gv_error_any_0
                ef_error_in_item_deletion_0 = gv_error_in_item_deletion_0
                ef_error_in_pod_update_0    = gv_error_in_pod_update_0
                ef_error_in_interface_0     = gv_error_in_interface_0
                ef_error_in_goods_issue_0   = gv_error_in_goods_issue_0
                ef_error_in_final_check_0   = gv_error_in_final_check_0
                ef_error_partner_update     = gv_error_partner_update
                ef_error_sernr_update       = gv_error_sernr_update
              TABLES
                prot = gt_prot.
          gv_wait_async_ws  = abap_true.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD bapi_create_documents.

    DATA: lt_msg_log TYPE zctgmm_his_dep_msg.

    FREE: et_return[].

* ---------------------------------------------------------------------------
* Recupera parâmetros de configuração
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = me->gs_parameter
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados para as próximas etapas
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key  = it_historico_key
                                 iv_status         = iv_status
                                 iv_job_centro_fat = iv_job_centro_fat
                       IMPORTING et_historico      = DATA(lt_historico)
                                 et_serie          = DATA(lt_serie)
                                 et_t001k          = DATA(lt_t001k)
                                 et_mbew           = DATA(lt_mbew)
                                 et_mara           = DATA(lt_mara)
                                 et_equi           = DATA(lt_equi)
                                 et_return         = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).
      RETURN.
    ENDIF.

    lt_historico = COND #( WHEN lt_historico IS NOT INITIAL
                            THEN lt_historico
                           ELSE it_historico_key ).

* ---------------------------------------------------------------------------
* Cria ID único para execução
* ---------------------------------------------------------------------------
    me->create_history_guid2( IMPORTING et_return    = DATA(lt_return)
                               CHANGING ct_historico = lt_historico
                                        ct_serie     = lt_serie ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].
    FREE: lt_return[].

* ---------------------------------------------------------------------------
* Antes de iniciar, verifica se algum documento já foi criado
* ---------------------------------------------------------------------------
    IF iv_update_history EQ abap_true.
      me->update_history_documents( CHANGING ct_historico = lt_historico ).
    ENDIF.

* ---------------------------------------------------------------------------
* Cria pedido de compra de saída
* ---------------------------------------------------------------------------
    me->create_purchase_order( EXPORTING it_t001k     = lt_t001k
                                         it_mbew      = lt_mbew
                                         it_mara      = lt_mara
                                         it_equi      = lt_equi
                               IMPORTING et_return    = lt_return
                                CHANGING ct_historico = lt_historico
                                         ct_serie     = lt_serie
                                         ct_msg       = lt_msg_log ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].
    FREE: lt_return[].

*    IF line_exists( et_return[ type = 'E' ] ).
*      RETURN.
*    ENDIF.

    me->call_save_background( EXPORTING it_historico_prev = it_historico_key
                                        it_historico      = lt_historico
                                        it_msg            = lt_msg_log
                              IMPORTING et_return         = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].
    FREE: lt_return[].

  ENDMETHOD.


  METHOD get_bapi_info.

    DATA: lt_marc_key TYPE STANDARD TABLE OF ty_marc,
          lt_eket_key TYPE STANDARD TABLE OF ty_eket,
          lt_lips_key TYPE STANDARD TABLE OF ty_lips,
          lt_lin_key  TYPE STANDARD TABLE OF ty_lin.

    FREE: et_historico,
          et_serie,
          et_t001k,
          et_mbew,
          et_mara,
          et_marc,
          et_equi,
          et_eket,
          et_lips,
          et_mseg,
          et_lin,
          et_return.

* ---------------------------------------------------------------------------
* Recupera Histórico para processo de depósito fechado
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    DATA(lt_key) = it_historico_key[].
    SORT lt_key BY material plant storage_location batch plant_dest storage_location_dest freight_order_id delivery_document process_step guid.
    DELETE ADJACENT DUPLICATES FROM lt_key COMPARING material plant storage_location batch plant_dest storage_location_dest freight_order_id delivery_document process_step guid.

    IF lt_key[] IS NOT INITIAL AND iv_status <> '10'.

      SELECT *
          FROM ztmm_his_dep_fec
          INTO TABLE et_historico
          FOR ALL ENTRIES IN lt_key
          WHERE material          = lt_key-material
            AND plant             = lt_key-plant
            AND storage_location  = lt_key-storage_location
            AND plant_dest        = lt_key-plant_dest
            AND storage_location_dest        = lt_key-storage_location_dest
            AND freight_order_id  = lt_key-freight_order_id
            AND delivery_document = lt_key-delivery_document
            AND batch             = lt_key-batch
            AND process_step      = lt_key-process_step
            AND guid              = lt_key-guid.

      IF sy-subrc EQ 0.
        SORT et_historico BY guid material plant batch storage_location plant_dest storage_location_dest freight_order_id delivery_document process_step guid.
      ENDIF.
    ENDIF.

    IF lt_key[] IS NOT INITIAL AND iv_status = '10'.
      SORT lt_key BY material plant storage_location batch plant_dest storage_location_dest process_step guid.
      IF iv_job_centro_fat = abap_true.
        SELECT *
            FROM ztmm_his_dep_fec
            INTO TABLE et_historico
            FOR ALL ENTRIES IN lt_key
            WHERE material              = lt_key-material
              AND plant                 = lt_key-plant
              AND storage_location      = lt_key-storage_location
              AND batch                 = lt_key-batch
              AND plant_dest            = lt_key-plant_dest
              AND storage_location_dest = lt_key-storage_location_dest
              AND process_step          = lt_key-process_step
              AND guid                  = lt_key-guid
              AND status = iv_status.
      ELSE.
        SELECT *
            FROM ztmm_his_dep_fec
            INTO TABLE et_historico
            FOR ALL ENTRIES IN lt_key
            WHERE material              = lt_key-material
              AND plant                 = lt_key-plant
              AND storage_location      = lt_key-storage_location
              AND batch                 = lt_key-batch
              AND plant_dest            = lt_key-plant_dest
              AND storage_location_dest = lt_key-storage_location_dest
              AND process_step          = lt_key-process_step
              AND status = iv_status.
      ENDIF.
      IF sy-subrc EQ 0.
        SORT et_historico BY guid material plant batch storage_location plant_dest storage_location_dest freight_order_id delivery_document process_step guid.
      ENDIF.
    ENDIF.

    IF iv_status IS NOT INITIAL AND lt_key IS INITIAL.

      SELECT *
          FROM ztmm_his_dep_fec
          INTO CORRESPONDING FIELDS OF TABLE et_historico
          WHERE status = iv_status.

      IF sy-subrc EQ 0.
        SORT et_historico BY guid material plant batch storage_location plant_dest storage_location_dest freight_order_id delivery_document process_step guid.
      ENDIF.

      lt_key = et_historico.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Histórico para processo de depósito fechado - Série
* ---------------------------------------------------------------------------
    IF lt_key[] IS NOT INITIAL.

      SELECT *
          FROM ztmm_his_dep_ser
          INTO TABLE et_serie
          FOR ALL ENTRIES IN lt_key
          WHERE material          = lt_key-material
            AND plant             = lt_key-plant
            AND storage_location  = lt_key-storage_location
            AND plant_dest        = lt_key-plant_dest
            AND storage_location_dest        = lt_key-storage_location_dest
            AND batch             = lt_key-batch
            AND guid              = lt_key-guid.

      IF sy-subrc EQ 0.
        SORT et_serie BY material plant storage_location guid serialno.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Área de avaliação
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    DATA(lt_key_plant) = lt_key.
    SORT lt_key_plant BY plant.
    DELETE ADJACENT DUPLICATES FROM lt_key_plant COMPARING plant.

    IF lt_key_plant[] IS NOT INITIAL.

      SELECT t001k~bwkey,
             t001k~bukrs,
             t001w~j_1bbranch
        FROM t001k
        INNER JOIN t001w
            ON t001w~werks = t001k~bwkey
        INTO TABLE @et_t001k
        FOR ALL ENTRIES IN @lt_key_plant
        WHERE t001k~bwkey = @lt_key_plant-plant.

      IF sy-subrc NE 0.
        FREE et_t001k.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Avaliação de material
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    DATA(lt_key1) = VALUE #( BASE lt_key FOR ls_historico_key IN lt_key ( material = ls_historico_key-material destiny_plant = ls_historico_key-plant ) ).

    SORT lt_key1 BY material destiny_plant.
    DELETE ADJACENT DUPLICATES FROM lt_key1 COMPARING material destiny_plant.

    IF lt_key1[] IS NOT INITIAL.

      SELECT matnr bwkey bwtar vprsv stprs verpr peinh mtuse mtorg
        FROM mbew
        INTO TABLE et_mbew
        FOR ALL ENTRIES IN lt_key1
        WHERE matnr = lt_key1-material
          AND bwkey = lt_key1-destiny_plant.

      IF sy-subrc NE 0.
        FREE et_mbew.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Dados de material
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    DATA(lt_key_material) = lt_key.
    SORT lt_key_material BY material.
    DELETE ADJACENT DUPLICATES FROM lt_key_material COMPARING material.

    IF lt_key_material[] IS NOT INITIAL.

      SELECT mara~matnr, mara~mtart, mara~matkl, makt~maktx
        FROM mara
        INNER JOIN makt
            ON  makt~matnr = mara~matnr
            AND makt~spras = @sy-langu
        INTO TABLE @et_mara
        FOR ALL ENTRIES IN @lt_key_material
        WHERE mara~matnr = @lt_key_material-material.

      IF sy-subrc NE 0.
        FREE et_mara.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Dados de Centro de material
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    FREE lt_marc_key.
    lt_marc_key[] = VALUE #( BASE lt_marc_key FOR ls_hist IN lt_key ( matnr = ls_hist-material
                                                                                werks = ls_hist-origin_plant ) ).
    lt_marc_key[] = VALUE #( BASE lt_marc_key FOR ls_hist IN lt_key ( matnr = ls_hist-material
                                                                                werks = ls_hist-destiny_plant ) ).
    lt_marc_key[] = VALUE #( BASE lt_marc_key FOR ls_hist IN lt_key ( matnr = ls_hist-material
                                                                                werks = gc_centro_2000 ) ).
    SORT lt_marc_key BY matnr werks.
    DELETE ADJACENT DUPLICATES FROM lt_marc_key COMPARING matnr werks.
    DELETE lt_marc_key WHERE matnr IS INITIAL.

    IF lt_marc_key[] IS NOT INITIAL.

      SELECT matnr werks steuc
          FROM marc
          INTO TABLE et_marc
          FOR ALL ENTRIES IN lt_marc_key
          WHERE matnr = lt_marc_key-matnr
            AND werks = lt_marc_key-werks.

      IF sy-subrc NE 0.
        FREE et_marc.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Equipamento - Série
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    DATA(lt_key_equi) = lt_key.
    SORT lt_key_equi BY material destiny_plant destiny_storage_location.
    DELETE ADJACENT DUPLICATES FROM lt_key_equi COMPARING material destiny_plant destiny_storage_location.

    IF lt_key_equi[] IS NOT INITIAL.

      SELECT equnr matnr werk lager sernr
        FROM equi
        INTO TABLE et_equi
        FOR ALL ENTRIES IN lt_key_equi
        WHERE matnr = lt_key_equi-material
          AND werk  = lt_key_equi-destiny_plant
          AND lager = lt_key_equi-destiny_storage_location.

      IF sy-subrc NE 0.
        FREE et_equi.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Remessas
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    FREE lt_lips_key.
    lt_lips_key[] = VALUE #( BASE lt_lips_key FOR ls_hist IN lt_key ( vbeln = ls_hist-out_delivery_document ) ).
    lt_lips_key[] = VALUE #( BASE lt_lips_key FOR ls_hist IN lt_key ( vbeln = ls_hist-in_delivery_document ) ).
    SORT lt_lips_key BY vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_lips_key COMPARING vbeln.
    DELETE lt_lips_key WHERE vbeln IS INITIAL.

    IF lt_lips_key[] IS NOT INITIAL.

      SELECT lips~vbeln,
             lips~posnr,
             lips~vgbel,
             lips~vgpos,
             lips~matnr,
             lips~meins,
             lips~charg,
             lips~j_1bcfop,
             lips~j_1btaxlw1,
             lips~j_1btaxlw2,
             lips~j_1btaxlw4,
             j_1batl4a~taxsit,
             lips~j_1btaxlw5,
             j_1batl5~taxsit,
             likp~wadat,
             lips~bwtar
        FROM lips
        LEFT OUTER JOIN likp
            ON likp~vbeln = lips~vbeln
        LEFT OUTER JOIN j_1batl4a
            ON j_1batl4a~taxlaw = lips~j_1btaxlw4
        LEFT OUTER JOIN j_1batl5
            ON j_1batl5~taxlaw = lips~j_1btaxlw5
        INTO TABLE @et_lips
        FOR ALL ENTRIES IN @lt_lips_key
        WHERE lips~vbeln = @lt_lips_key-vbeln.

      IF sy-subrc NE 0.
        FREE et_lips.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Divisões do programa de remessas
* ---------------------------------------------------------------------------

    " Monta tabela de chaves
    FREE lt_eket_key.
    lt_eket_key[] = VALUE #( BASE lt_eket_key FOR ls_hist IN lt_key ( ebeln = ls_hist-main_purchase_order ) ).
    lt_eket_key[] = VALUE #( BASE lt_eket_key FOR ls_hist IN lt_key ( ebeln = ls_hist-purchase_order ) ).
    lt_eket_key[] = VALUE #( BASE lt_eket_key FOR ls_lips IN et_lips ( ebeln = ls_lips-vgbel ) ).
    SORT lt_eket_key BY ebeln.
    DELETE ADJACENT DUPLICATES FROM lt_eket_key COMPARING ebeln.
    DELETE lt_eket_key WHERE ebeln IS INITIAL.

    IF lt_eket_key[] IS NOT INITIAL.

      SELECT eket~ebeln,
             eket~ebelp,
             eket~etenr,
             eket~eindt,
             eket~charg,
             ekko~lifnr,
             ekko~inco1,
             ekko~inco2,
             ekpo~matnr,
             ekpo~werks,
             ekpo~menge,
             ekpo~meins,
             ekpo~netpr,
             ekpo~peinh
        FROM eket
        INNER JOIN ekko
            ON  ekko~ebeln = eket~ebeln
        INNER JOIN ekpo
            ON  ekpo~ebeln = ekpo~ebeln
            AND ekpo~ebelp = ekpo~ebelp
        INTO TABLE @et_eket
        FOR ALL ENTRIES IN @lt_eket_key
        WHERE eket~ebeln = @lt_eket_key-ebeln.

      IF sy-subrc NE 0.
        FREE et_eket.
      ENDIF.
    ENDIF.
* ---------------------------------------------------------------------------
* Recupera Saída de mercadoria (Documento de Material)
* ---------------------------------------------------------------------------

    IF lt_lips_key[] IS NOT INITIAL.

      SELECT mblnr, mjahr, zeile, vbeln_im, vbelp_im, ebeln, ebelp
        FROM mseg
        INTO TABLE @DATA(lt_mseg)
        FOR ALL ENTRIES IN @lt_lips_key
        WHERE vbeln_im = @lt_lips_key-vbeln.

    ENDIF.

    IF lt_eket_key[] IS NOT INITIAL.

      SELECT mblnr, mjahr, zeile, vbeln_im, vbelp_im, ebeln, ebelp
        FROM mseg
        APPENDING TABLE @lt_mseg
        FOR ALL ENTRIES IN @lt_eket_key
        WHERE ebeln = @lt_eket_key-ebeln.

    ENDIF.

    SORT lt_mseg BY mblnr mjahr zeile.
    DELETE ADJACENT DUPLICATES FROM lt_mseg COMPARING mblnr mjahr zeile.
    et_mseg[] = CORRESPONDING #( lt_mseg ).

* ---------------------------------------------------------------------------
* Recupera Notas Fiscais
* ---------------------------------------------------------------------------

    TYPES: BEGIN OF ty_ekbe_key,
             ebeln TYPE ebeln,
           END OF ty_ekbe_key,
           BEGIN OF ty_refkey,
             refkey TYPE j_1brefkey,
             refitm TYPE j_1brefitm,
           END OF ty_refkey.

    DATA: lt_ekbe_key TYPE TABLE OF ty_ekbe_key,
          lt_refkey   TYPE TABLE OF ty_refkey.

    lt_ekbe_key = VALUE #( FOR ls_hist IN lt_key ( ebeln = ls_hist-purchase_order )  ).
    SORT lt_ekbe_key.
    DELETE ADJACENT DUPLICATES FROM lt_ekbe_key.
    DELETE lt_ekbe_key WHERE ebeln IS INITIAL.

    IF lt_ekbe_key[] IS NOT INITIAL.
      SELECT bwart ebeln ebelp vgabe belnr gjahr buzei
        FROM ekbe
        INTO TABLE et_ekbe
        FOR ALL ENTRIES IN lt_ekbe_key
        WHERE ebeln = lt_ekbe_key-ebeln
          AND ( bwart = '862' OR bwart = '861' ).

      lt_refkey = VALUE #( FOR ls_ekbe_data IN et_ekbe ( refkey = |{ ls_ekbe_data-belnr }{ ls_ekbe_data-gjahr }| refitm = ls_ekbe_data-buzei   ) ).

      SORT lt_refkey.
      DELETE ADJACENT DUPLICATES FROM lt_refkey.


      IF lt_refkey[] IS NOT INITIAL.

        SELECT lin~xped,
               lin~nitemped,
               lin~refkey,
               lin~refitm,
               lin~docnum,
               lin~itmnum,
               lin~nfnett,
               lin~matnr,
               doc~docdat,
               doc~nfnum,
               active~direct,
               active~docsta
            FROM j_1bnflin AS lin
            INNER JOIN j_1bnfdoc AS doc
              ON doc~docnum = lin~docnum
            LEFT OUTER JOIN j_1bnfe_active AS active
              ON lin~docnum = active~docnum
            INTO TABLE @DATA(lt_lin)
            FOR ALL ENTRIES IN @lt_refkey
            WHERE lin~refkey = @lt_refkey-refkey
              AND lin~refitm = @lt_refkey-refitm.

      ENDIF.
    ENDIF.

    SORT lt_lin BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_lin COMPARING table_line.
    et_lin[] = CORRESPONDING #( lt_lin ).

  ENDMETHOD.


  METHOD create_history_guid.


    DATA: lt_hist_del  TYPE ty_t_historico,
          ls_hist_key1 TYPE ty_his_dep_fec_key,
          ls_hist_key2 TYPE ty_his_dep_fec_key,
          lv_count     TYPE i,
          lv_max_count TYPE i.


    FREE: et_return.

    CHECK line_exists( ct_historico[ guid = '00000000000000000000000000000000' ] ).



    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).

    lv_max_count = lv_limitador_itens.

* ---------------------------------------------------------------------------
* Prepara registros a serem removidos
* ---------------------------------------------------------------------------
    DATA(lt_historico_old) = ct_historico[].
    DELETE lt_historico_old WHERE guid IS NOT INITIAL.
    DATA(lt_serie_old) = ct_serie[].
    DELETE lt_serie_old WHERE guid IS NOT INITIAL.

    SORT ct_historico BY plant storage_location plant_dest storage_location_dest freight_order_id delivery_document process_step.

    LOOP AT ct_historico REFERENCE INTO DATA(ls_historico).
      ls_hist_key1 = VALUE #( plant    = ls_historico->plant
                              storage_location  = ls_historico->storage_location
*                              batch             = ls_historico->batch
                              plant_dest        = ls_historico->plant_dest
                              storage_location_dest  = ls_historico->storage_location_dest
*                              guid                   = ls_historico->guid
                              ).

      IF ls_hist_key1 <> ls_hist_key2 OR lv_count >= lv_max_count.
        CLEAR lv_count.
        DATA(lv_guid) = me->get_next_guid( IMPORTING et_return = et_return ).

        ls_hist_key2 = VALUE #( plant             = ls_historico->plant
                                storage_location  = ls_historico->storage_location
*                                batch             = ls_historico->batch
                                plant_dest        = ls_historico->plant_dest
                                storage_location_dest  = ls_historico->storage_location_dest
*                                guid                   = ls_historico->guid
                                ).

      ENDIF.
      LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) WHERE material = ls_historico->material
                                                       AND plant    = ls_historico->plant
                                                       AND storage_location  = ls_historico->storage_location
                                                       AND batch             = ls_historico->batch
                                                       AND plant_dest        = ls_historico->plant_dest
                                                       AND storage_location_dest  = ls_historico->storage_location_dest
                                                       AND guid                   = ls_historico->guid.

        ls_serie->guid = lv_guid.

      ENDLOOP.

      ls_historico->guid = lv_guid.
      ADD 1 TO lv_count.

      ls_historico->created_by      = sy-uname.
      ls_historico->last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_historico->created_at.
      GET TIME STAMP FIELD ls_historico->last_changed_at.
      GET TIME STAMP FIELD ls_historico->local_last_changed_at.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Apaga registros antigos
* ---------------------------------------------------------------------------
*    IF lt_historico_old[] IS NOT INITIAL.
*
*      DELETE ztmm_his_dep_fec FROM TABLE lt_historico_old[].
*
*      IF sy-subrc NE 0.
*        " Falha ao salvar os dados.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
*        me->format_return( CHANGING ct_return = et_return ).
*        ROLLBACK WORK.
*        RETURN.
*      ENDIF.
*    ENDIF.
*
*    IF lt_serie_old[] IS NOT INITIAL.
*
*      DELETE ztmm_his_dep_ser FROM TABLE lt_serie_old[].
*
*      IF sy-subrc NE 0.
*        " Falha ao salvar os dados.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
*        me->format_return( CHANGING ct_return = et_return ).
*        ROLLBACK WORK.
*        RETURN.
*      ENDIF.
*    ENDIF.

* ---------------------------------------------------------------------------
* Salva registros
* ---------------------------------------------------------------------------
    CALL METHOD me->call_save_background
      EXPORTING
        it_historico_prev = lt_historico_old
        it_historico      = ct_historico
        it_serie_prev     = lt_serie_old
        it_serie          = ct_serie
      IMPORTING
        et_return         = DATA(lt_return).

  ENDMETHOD.


  METHOD save.

    FREE: et_historico, et_serie, et_return.

* ---------------------------------------------------------------------------
* Prepara os dados para salvar
* ---------------------------------------------------------------------------
    IF it_emissao_cds IS NOT INITIAL.

      me->convert_cds_to_table( EXPORTING it_emissao_cds = it_emissao_cds
                                IMPORTING et_historico   = et_historico
                                          et_return      = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].

    ELSEIF it_historico IS NOT INITIAL.

      et_historico[] = it_historico[].

    ENDIF.

    IF it_serie_cds IS NOT INITIAL.

      me->convert_cds_to_table( EXPORTING it_serie_cds = it_serie_cds
                                IMPORTING et_serie     = et_serie
                                          et_return    = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].

    ELSEIF it_serie IS NOT INITIAL.

      et_serie[] = it_serie[].

    ENDIF.

* ---------------------------------------------------------------------------
* Prepara os dados para salvar - F05
* ---------------------------------------------------------------------------
    IF it_armazenagem_cds IS NOT INITIAL.

      DATA(lo_armz)   = NEW zclmm_aux_ret_armazenagem( ).
      et_historico[] = lo_armz->entity_to_table( EXPORTING it_entity = it_armazenagem_cds ).

    ENDIF.

* ---------------------------------------------------------------------------
* Prepara os dados para salvar - F12
* ---------------------------------------------------------------------------
    IF it_pendente_cds IS NOT INITIAL.

      DATA(lo_pend)   = NEW zclmm_aux_pend_ordem_de_frete( ).
      et_historico[] = lo_pend->entity_to_table( EXPORTING it_entity = it_pendente_cds ).

    ENDIF.

* ---------------------------------------------------------------------------
* Prepara os dados para salvar - F13
* ---------------------------------------------------------------------------
    IF it_reserva_cds IS NOT INITIAL.

      DATA(lo_resv)   = NEW zclmm_reservas_pendentes( ).
      et_historico[] = lo_resv->entity_to_table( EXPORTING it_entity = it_reserva_cds ).

    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de cabeçalho e série em background
* ---------------------------------------------------------------------------
    IF iv_background EQ abap_true.

      me->save_background( EXPORTING it_historico = et_historico
                                     it_serie     = et_serie
                           IMPORTING et_return    = lt_return ).

    ELSE.
* ---------------------------------------------------------------------------
* Salva dados de cabeçalho
* ---------------------------------------------------------------------------
      IF et_historico[] IS NOT INITIAL.

        MODIFY ztmm_his_dep_fec FROM TABLE et_historico.

        IF sy-subrc NE 0.
          " Falha ao salvar os dados.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de série
* ---------------------------------------------------------------------------
      IF et_serie IS NOT INITIAL.

        MODIFY ztmm_his_dep_ser FROM TABLE et_serie.

        IF sy-subrc NE 0.
          " Falha ao salvar os dados.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD save_background.

* ---------------------------------------------------------------------------
* Chama evento para troca de status
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'ZFMMM_DEPOSITO_FECHADO_SALVAR'
      STARTING NEW TASK 'DEPOSITO_FECHADO_SALVAR'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        it_historico = it_historico
        it_serie     = it_serie.

    WAIT UNTIL gv_wait_async = abap_true.
    et_return = gt_return.

  ENDMETHOD.


  METHOD call_save_background.

    DATA: lt_his_dep_msg     TYPE TABLE OF ztmm_his_dep_msg,
          lt_his_dep_fec_key TYPE TABLE OF ty_his_dep_fec_key,
          ls_key1            TYPE ty_his_dep_fec_key,
          ls_key2            TYPE ty_his_dep_fec_key,
          ls_his_dep_msg     TYPE ztmm_his_dep_msg,
          lv_longo           TYPE timestampl.

* ---------------------------------------------------------------------------
* Salva dados de cabeçalho
* ---------------------------------------------------------------------------
    IF it_historico[] IS NOT INITIAL.

      MODIFY ztmm_his_dep_fec FROM TABLE it_historico.

      IF sy-subrc EQ 0.
        IF it_historico_prev[] IS NOT INITIAL.
          DELETE ztmm_his_dep_fec FROM TABLE it_historico_prev.
        ENDIF.

        COMMIT WORK AND WAIT.
      ELSE .
        " Falha ao salvar os dados.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        ROLLBACK WORK.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de série
* ---------------------------------------------------------------------------
    IF it_serie IS NOT INITIAL.
      MODIFY ztmm_his_dep_ser FROM TABLE it_serie.

      IF sy-subrc EQ 0.
        IF it_serie_prev IS NOT INITIAL.
          DELETE ztmm_his_dep_ser FROM TABLE it_serie_prev.
        ENDIF.

        COMMIT WORK.
      ELSE .
        " Falha ao salvar os dados.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        ROLLBACK WORK.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva da msg
* ---------------------------------------------------------------------------
    IF gv_timestamp IS INITIAL.
      GET TIME STAMP FIELD gv_timestamp.
    ENDIF.

    lv_longo = gv_timestamp.

    IF it_msg IS NOT INITIAL.

      LOOP AT it_msg ASSIGNING FIELD-SYMBOL(<fs_msg>).
        ls_key1 = CORRESPONDING #( <fs_msg> ).

        IF ls_key1 <> ls_key2.
          SELECT MAX( sequencial )
            FROM ztmm_his_dep_msg
            WHERE material = @ls_key1-material
              AND plant    = @ls_key1-plant
              AND storage_location = @ls_key1-storage_location
              AND batch = @ls_key1-batch
              AND plant_dest = @ls_key1-plant_dest
              AND storage_location_dest = @ls_key1-storage_location_dest
              AND guid = @ls_key1-guid
             INTO @DATA(lv_sequencial).

          IF sy-subrc <> 0.
            CLEAR lv_sequencial.
          ENDIF.

          ls_key2 = ls_key1.
        ENDIF.

        ADD 1 TO lv_sequencial.

        ls_his_dep_msg = CORRESPONDING #( <fs_msg> ).
        ls_his_dep_msg-sequencial = lv_sequencial.
        ls_his_dep_msg-created_at = lv_longo.
        ls_his_dep_msg-created_by = sy-uname.

        CALL FUNCTION 'MESSAGE_PREPARE'
          EXPORTING
            msg_id                 = <fs_msg>-id
            msg_no                 = CONV msgnr( <fs_msg>-number )
            msg_var1               = <fs_msg>-message_v1
            msg_var2               = <fs_msg>-message_v2
            msg_var3               = <fs_msg>-message_v3
            msg_var4               = <fs_msg>-message_v4
          IMPORTING
            msg_text               = ls_his_dep_msg-msg
          EXCEPTIONS
            function_not_completed = 1
            message_not_found      = 2
            OTHERS                 = 3.

        IF sy-subrc <> 0.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        ENDIF.

        APPEND ls_his_dep_msg TO lt_his_dep_msg.

      ENDLOOP.

      IF lt_his_dep_msg IS NOT INITIAL.
        MODIFY ztmm_his_dep_msg FROM TABLE lt_his_dep_msg.

        IF sy-subrc EQ 0.
          COMMIT WORK.
        ELSE .
          " Falha ao salvar os dados.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-serie type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
          me->format_return( CHANGING ct_return = et_return ).
          ROLLBACK WORK.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_history_documents.

    DATA: ls_lin_key TYPE ty_lin.

    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_lips          = DATA(lt_lips)
                                 et_mseg          = DATA(lt_mseg)
                                 et_lin           = DATA(lt_lin)
                                 et_ekbe          = DATA(lt_ekbe) ).

* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
    LOOP AT ct_historico REFERENCE INTO DATA(ls_historico).

      " Atualiza documento de material entrada do pedido principal
      " ---------------------------------------------------------------------
      IF ls_historico->purchase_order IS NOT INITIAL.
        READ TABLE lt_mseg INTO DATA(ls_mseg_main) WITH KEY pedido COMPONENTS ebeln = ls_historico->purchase_order
                                                                              ebelp = ls_historico->purchase_order_item.
        IF sy-subrc EQ 0.
          ls_historico->main_material_document      = ls_mseg_main-mblnr.
          ls_historico->main_material_document_year = ls_mseg_main-mjahr.
          ls_historico->main_material_document_item = ls_mseg_main-zeile.
        ENDIF.
      ENDIF.

      " Atualiza remessa de saída
      " ---------------------------------------------------------------------
      IF ls_historico->out_delivery_document IS NOT INITIAL.
        READ TABLE lt_lips INTO DATA(ls_lips_out) WITH KEY vbeln = ls_historico->out_delivery_document
                                                           matnr = ls_historico->material.

        IF sy-subrc EQ 0 AND ls_historico->out_delivery_document IS INITIAL.
          ls_historico->out_delivery_document      = ls_lips_out-vbeln.
          ls_historico->out_delivery_document_item = ls_lips_out-posnr.
          ls_historico->out_sales_order            = ls_lips_out-vgbel.
          ls_historico->out_sales_order_item       = ls_lips_out-vgpos.
        ENDIF.
      ENDIF.

      " Atualiza saída de mercadoria
      " ---------------------------------------------------------------------
      IF ls_historico->out_delivery_document IS NOT INITIAL.
        READ TABLE lt_mseg INTO DATA(ls_mseg_out) WITH KEY remessa COMPONENTS vbeln_im = ls_historico->out_delivery_document
                                                                              vbelp_im = ls_historico->out_delivery_document_item.

        IF sy-subrc EQ 0 AND ls_historico->out_material_document IS INITIAL.
          ls_historico->out_material_document      = ls_mseg_out-mblnr.
          ls_historico->out_material_document_year = ls_mseg_out-mjahr.
          ls_historico->out_material_document_item = ls_mseg_out-zeile.
        ENDIF.
      ENDIF.

      READ TABLE lt_mseg INTO ls_mseg_out WITH KEY pedido COMPONENTS ebeln = ls_historico->purchase_order
                                                                     ebelp = ls_historico->purchase_order_item.

      IF sy-subrc EQ 0 AND ls_historico->out_material_document IS INITIAL.
        ls_historico->out_material_document      = ls_mseg_out-mblnr.
        ls_historico->out_material_document_year = ls_mseg_out-mjahr.
        ls_historico->out_material_document_item = ls_mseg_out-zeile.
      ENDIF.

      " Atualiza Nota Fiscal de saída
      " ---------------------------------------------------------------------
      ls_lin_key-refkey   = |{ ls_historico->out_material_document }{ ls_historico->out_material_document_year }|.
      ls_lin_key-refitm   = ls_historico->out_material_document_item.

      READ TABLE lt_lin INTO DATA(ls_lin_out) WITH KEY refkey = ls_lin_key-refkey
                                                       refitm = ls_lin_key-refitm.

      IF sy-subrc EQ 0 AND ls_historico->out_br_nota_fiscal IS INITIAL.
        ls_historico->out_br_nota_fiscal        = ls_lin_out-docnum.
        ls_historico->out_br_nota_fiscal_item   = ls_lin_out-itmnum.
        ls_historico->rep_br_nota_fiscal        = ls_lin_out-nfnum.

      ENDIF.

      " Atualiza entrada de mercadoria
      " ---------------------------------------------------------------------
      READ TABLE lt_lips INTO DATA(ls_lips_in) WITH TABLE KEY vbeln = ls_historico->in_delivery_document
                                                              posnr = ls_historico->in_delivery_document_item.
      IF sy-subrc NE 0.
        CLEAR ls_lips_in.
      ENDIF.

      READ TABLE lt_ekbe INTO DATA(ls_ekbe) WITH KEY bwart = '861'
                                                     ebeln = ls_historico->purchase_order
                                                     ebelp = ls_historico->purchase_order_item BINARY SEARCH.

      IF sy-subrc EQ 0 AND ls_historico->in_material_document IS INITIAL.
        ls_historico->in_material_document        = ls_ekbe-belnr.
        ls_historico->in_material_document_year   = ls_ekbe-gjahr.
        ls_historico->in_material_document_item   = ls_ekbe-buzei.
      ENDIF.

      " Atualiza Nota Fiscal de entrada
      " ---------------------------------------------------------------------
      ls_lin_key-refkey   = |{ ls_historico->in_material_document }{ ls_historico->in_material_document_year }|.
      ls_lin_key-refitm   = ls_historico->in_material_document_item.

      READ TABLE lt_lin INTO DATA(ls_lin_in) WITH KEY refkey = ls_lin_key-refkey
                                                       refitm = ls_lin_key-refitm.

      IF sy-subrc EQ 0.
        ls_historico->in_br_nota_fiscal        = ls_lin_in-docnum.
        ls_historico->in_br_nota_fiscal_item   = ls_lin_in-itmnum.
      ENDIF.

      ls_historico->last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_historico->last_changed_at.
      GET TIME STAMP FIELD ls_historico->local_last_changed_at.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_purchase_order.

    TYPES: BEGIN OF ty_item,
             material   TYPE matnr18,
             plant_dest TYPE ewerk,
             mtuse      TYPE j_1bmatuse,
             mtorg      TYPE j_1bmatorg,
           END OF ty_item,

           ty_tt_item TYPE TABLE OF ty_item,

           BEGIN OF ty_bseg,
             matnr TYPE matnr,
             werks TYPE werks_d,
             charg TYPE charg_d,
           END OF ty_bseg.

    DATA: lt_item              TYPE STANDARD TABLE OF bapimepoitem,
          lt_itemx             TYPE STANDARD TABLE OF bapimepoitemx,
          lt_account           TYPE STANDARD TABLE OF bapimepoaccount,
          lt_accountx          TYPE STANDARD TABLE OF bapimepoaccountx,
          lt_cond              TYPE STANDARD TABLE OF bapimepocond,
          lt_condx             TYPE STANDARD TABLE OF bapimepocondx,
          lt_serialnumber      TYPE STANDARD TABLE OF bapimeposerialno,
          lt_serialnumberx     TYPE STANDARD TABLE OF bapimeposerialnox,
          lt_bseg_key          TYPE TABLE OF ty_bseg,
          lt_mbew              TYPE TABLE OF ty_mbew,
          lt_return            TYPE bapiret2_t,
          lt_return_aux        TYPE bapiret2_t,
          lt_item_add          TYPE ty_tt_item,
          lt_msg_log           TYPE zctgmm_his_dep_msg,

          ls_header            TYPE bapimepoheader,
          ls_headerx           TYPE bapimepoheaderx,
          ls_expheader         TYPE bapimepoheader,
          ls_exppoexpimpheader TYPE bapieikp,

          lv_ebeln             TYPE ebeln,
          lv_itemno            TYPE ebelp,
          lv_serialline        TYPE etenr,
          lv_val_type          TYPE bwtar_d.

    FREE: et_return[].

* ---------------------------------------------------------------------------
* Aplica ordenação
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].

    SORT lt_historico_key BY main_purchase_order
                             guid.
    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING main_purchase_order
                                                               guid.

    SORT ct_historico BY guid
                         main_purchase_order
                         main_purchase_order_item.

    lt_bseg_key = VALUE #(  FOR ls_hist_key IN ct_historico ( matnr = ls_hist_key-material
                                                              werks = ls_hist_key-plant
                                                              charg = ls_hist_key-batch ) ).

    SORT lt_bseg_key.
    DELETE ADJACENT DUPLICATES FROM lt_bseg_key.

    IF lt_bseg_key IS NOT INITIAL.
      SELECT matnr,
             werks,
             charg,
             bwtar
        FROM mseg
         FOR ALL ENTRIES IN @lt_bseg_key
       WHERE matnr = @lt_bseg_key-matnr
         AND werks = @lt_bseg_key-werks
         AND charg = @lt_bseg_key-charg
        INTO TABLE @DATA(lt_mseg_charg).

      SORT lt_mseg_charg BY matnr werks charg.
    ENDIF.

    lt_mbew = it_mbew.

    SORT lt_mbew BY matnr bwkey bwtar.

    DATA: lv_main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order.

* ---------------------------------------------------------------------------
* Prepara dados para criação do Pedido de Compra
* ---------------------------------------------------------------------------

    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      " Verifica se Pedido de compra foi criado
      CHECK ls_historico_key-purchase_order IS INITIAL.

      FREE: lt_item,
            lt_itemx,
            lt_account,
            lt_accountx,
            lt_cond,
            lt_condx,
            lt_serialnumber,
            lt_serialnumberx,
            lt_return,
            lv_itemno.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------

      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------

        " Recupera Área de avaliação
        READ TABLE it_t001k INTO DATA(ls_t001k) WITH TABLE KEY bwkey = ls_historico->plant.

        IF sy-subrc NE 0.
          CLEAR ls_t001k.
        ENDIF.
*
*        " Recupera Avaliação de material
        READ TABLE it_mbew INTO DATA(ls_mbew) WITH TABLE KEY matnr = ls_historico->material
                                                             bwkey = ls_historico->destiny_plant.
        IF sy-subrc NE 0.
          CLEAR ls_mbew.
        ENDIF.

*        " Recupera Avaliação de material
        READ TABLE lt_mbew INTO DATA(ls_mbew_orig) WITH KEY matnr = ls_historico->material
                                                            bwkey = ls_historico->plant BINARY SEARCH.
        "   bwtar .
        IF sy-subrc NE 0.
          CLEAR ls_mbew_orig.
        ENDIF.

        " Recupera dados de material
        READ TABLE it_mara INTO DATA(ls_mara) WITH TABLE KEY matnr = ls_historico->material.

        IF sy-subrc NE 0.
          CLEAR ls_mara.
        ENDIF.

        READ TABLE lt_mseg_charg INTO DATA(ls_mseg_charg) WITH KEY matnr = ls_historico->material
                                                                   werks = ls_historico->plant
                                                                   charg = ls_historico->batch BINARY SEARCH.

        IF sy-subrc NE 0.
          CLEAR ls_mseg_charg.
        ENDIF.

        " Prepara dados de cabeçalho
        " -------------------------------------------------------------------
        ls_header = VALUE #( comp_code  = ls_t001k-bukrs
                             doc_type   = gc_bapi_pedido-tp_doc_compra_zdf
                             creat_date = sy-datum
                             created_by = sy-uname
                             vendor     = |{ ls_historico->origin_plant ALPHA = IN }|
                             langu      = 'PT'
                             langu_iso  = 'PT'
                             purch_org  = gc_bapi_pedido-org_compras_oc01
                             pur_group  = gc_bapi_pedido-grupo_compra_310
                             doc_date   = sy-datum
                             incoterms1 = ls_historico->freight_mode
                             incoterms2 = ls_historico->freight_mode
                             suppl_plnt = ls_historico->origin_plant  ).

        ls_headerx = VALUE #( comp_code  = abap_true
                              doc_type   = abap_true
                              creat_date = abap_true
                              created_by = abap_true
                              vendor     = abap_true
                              langu      = abap_true
                              langu_iso  = abap_true
                              pmnttrms   = abap_true
                              purch_org  = abap_true
                              pur_group  = abap_true
                              doc_date   = abap_true
                              incoterms1 = COND #( WHEN ls_historico->freight_mode IS NOT INITIAL
                                                     THEN abap_true
                                                     ELSE abap_false )
                              incoterms2 = COND #( WHEN ls_historico->freight_mode IS NOT INITIAL
                                                       THEN abap_true
                                                       ELSE abap_false )
                              suppl_plnt = abap_true ).

        " Prepara dados de item
        " -------------------------------------------------------------------
        ADD 10 TO lv_itemno.


        lt_item[] = VALUE #( BASE lt_item ( po_item     = lv_itemno
                                            material    = ls_historico->material
                                            plant       = ls_historico->destiny_plant
                                            po_unit     = ls_historico->unit
                                            po_unit_iso = ls_historico->unit
                                            quantity    = ls_historico->used_stock_conv
                                            stge_loc    = ls_historico->storage_location_dest
                                            gi_based_gr = abap_true
                                            net_price   = COND #( WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_s
                                                                    THEN ls_mbew-stprs
                                                                  WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_v
                                                                    THEN ls_mbew-verpr
                                                                  ELSE 0 )
                                            price_unit  = ls_mbew-peinh
                                            po_price    = gc_bapi_pedido-transf_preco_1
*                                            conf_ctrl   = gc_bapi_pedido-chv_ctrl_conf_0004
*                                            val_type    = lv_val_type
                                            batch       = ls_historico->batch
                                            part_deliv  = COND #( WHEN ls_header-vendor = '0000002003' THEN space ELSE 'A' ) ) ).

        ls_historico->val_type =  COND #(  WHEN ls_mseg_charg-bwtar IS INITIAL
                                            THEN |{ ls_t001k-bukrs }{ ls_historico->destiny_plant }IN|
                                           ELSE ls_mseg_charg-bwtar ).


        lt_item_add[] = VALUE #( BASE lt_item_add ( material   = ls_historico->material
                                                    plant_dest = ls_historico->destiny_plant
                                                    mtorg      = ls_mbew_orig-mtorg
                                                    mtuse      = ls_mbew_orig-mtuse ) ).

        lt_itemx[] = VALUE #( BASE lt_itemx ( po_item     = lv_itemno
                                              po_itemx    = abap_true
                                              material    = abap_true
                                              plant       = abap_true
                                              po_unit     = abap_true
                                              po_unit_iso = abap_true
                                              quantity    = abap_true
                                              stge_loc    = abap_true
                                              net_price   = abap_true
                                              price_unit  = abap_true
                                              gi_based_gr = abap_true
*                                              tax_code    = abap_true
                                              po_price    = abap_true
*                                              conf_ctrl   = abap_true
*                                              val_type    =  COND #( WHEN lv_val_type IS NOT INITIAL THEN abap_true
*                                                                     ELSE abap_false )
                                              batch       = abap_true
                                              part_deliv  = abap_true ) ).
        " Prepara dados de condição
        " -------------------------------------------------------------------
        lt_cond[] = VALUE #( BASE lt_cond (
                             condition_no  = gc_bapi_pedido-cond_0000000001
                             itm_number    = lv_itemno
                             cond_st_no    = 0
                             cond_type     = gc_bapi_pedido-tp_cond_p101
                             cond_value    = COND #( WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_s
                                                      THEN ls_mbew-stprs
                                                     WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_v
                                                      THEN ls_mbew-verpr
                                                     ELSE 0 )
                             currency      = gc_bapi_pedido-moeda_brl
                             currency_iso  = gc_bapi_pedido-moeda_brl
                             cond_unit     = ls_historico->unit
                             cond_unit_iso = ls_historico->unit
                             cond_p_unt    = ls_mbew-peinh
                             calctypcon    = gc_bapi_pedido-regra_calc_cond_a
                             conbaseval    = COND #( WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_s
                                                      THEN ls_mbew-stprs
                                                     WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_v
                                                      THEN ls_mbew-verpr
                                                     ELSE 0 ) ) ).

        lt_condx[] = VALUE #( BASE lt_condx ( condition_no  = gc_bapi_pedido-cond_0000000001
                                              itm_number    = lv_itemno
                                              cond_st_no    = 0
                                              condition_nox = abap_true
                                              itm_numberx   = abap_true
                                              cond_st_nox   = abap_true
                                              cond_count    = abap_true
                                              cond_type     = abap_true
                                              cond_value    = abap_true
                                              currency      = abap_true
                                              currency_iso  = abap_true
                                              cond_unit     = abap_true
                                              cond_unit_iso = abap_true
                                              cond_p_unt    = abap_true
                                              calctypcon    = abap_true
                                              conbaseval    = abap_true ) ).

        " Prepara dados de série - Processo manual
        " -------------------------------------------------------------------
        FREE: lv_serialline.

        IF ls_mara-mtart EQ gc_tipo_material-zcom.

          READ TABLE ct_serie TRANSPORTING NO FIELDS WITH KEY material              = ls_historico->material
                                                              plant                 = ls_historico->plant
                                                              storage_location      = ls_historico->storage_location
                                                              batch                 = ls_historico->batch
                                                              plant_dest            = ls_historico->plant_dest
                                                              storage_location_dest = ls_historico->storage_location_dest
                                                              freight_order_id      = ls_historico->freight_order_id
                                                              delivery_document     = ls_historico->delivery_document
                                                              process_step          = ls_historico->process_step
                                                              guid                  = ls_historico->guid
                                                              BINARY SEARCH.

          IF sy-subrc EQ 0.

            LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) FROM sy-tabix.

              IF  ls_serie->material                 <> ls_historico->material
                 OR ls_serie->plant                  <> ls_historico->plant
                 OR ls_serie->storage_location       <> ls_historico->storage_location
                 OR ls_serie->batch                  <> ls_historico->batch
                 OR ls_serie->plant_dest             <> ls_historico->plant_dest
                 OR ls_serie->storage_location_dest  <> ls_historico->storage_location_dest
                 OR ls_serie->freight_order_id       <> ls_historico->freight_order_id
                 OR ls_serie->delivery_document      <> ls_historico->delivery_document
                 OR ls_serie->process_step           <> ls_historico->process_step
                 OR ls_serie->guid                   <> ls_historico->guid.
                EXIT.
              ENDIF.

              lt_account[] = VALUE #( BASE lt_account ( po_item   = lv_itemno
                                                        serial_no = ls_serie->serialno
                                                        quantity  = 1 ) ).

              lt_accountx[] = VALUE #( BASE lt_accountx ( po_item    = lv_itemno
                                                          serial_no  = ls_serie->serialno
                                                          po_itemx   = abap_true
                                                          serial_nox = abap_true
                                                          quantity   = abap_true ) ).

              ADD 10 TO lv_serialline.
              lt_serialnumber[] = VALUE #( BASE lt_serialnumber ( po_item    = lv_itemno
                                                                  sched_line = lv_serialline
                                                                  serialno   = ls_serie->serialno ) ).

              lt_serialnumberx[] = VALUE #( BASE lt_serialnumberx ( po_item     = lv_itemno
                                                                    sched_line  = lv_serialline
                                                                    po_itemx    = abap_true
                                                                    sched_linex = abap_true
                                                                    serialno    = abap_true ) ).

            ENDLOOP.
          ENDIF.

        ELSE.

          " Prepara dados de série - Processo automático
          " -----------------------------------------------------------------
          LOOP AT it_equi REFERENCE INTO DATA(ls_equi) WHERE matnr = ls_historico->material
                                                         AND werk  = ls_historico->destiny_plant
                                                         AND lager = ls_historico->destiny_storage_location.

            lt_account[]  = VALUE #( BASE lt_account ( po_item   = lv_itemno
                                                       serial_no = ls_equi->sernr
                                                       quantity  = 1 ) ).

            lt_accountx[] = VALUE #( BASE lt_accountx ( po_item    = lv_itemno
                                                        serial_no  = ls_equi->sernr
                                                        po_itemx   = abap_true
                                                        serial_nox = abap_true
                                                        quantity   = abap_true ) ).

            ADD 1 TO lv_serialline.
            lt_serialnumber[] = VALUE #( BASE lt_serialnumber ( po_item    = lv_itemno
                                                                sched_line = lv_serialline
                                                                serialno   = ls_equi->sernr ) ).

            lt_serialnumberx[] = VALUE #( BASE lt_serialnumberx ( po_item     = lv_itemno
                                                                  sched_line  = lv_serialline
                                                                  po_itemx    = abap_true
                                                                  sched_linex = abap_true
                                                                  serialno    = abap_true ) ).
          ENDLOOP.
        ENDIF.

      ENDLOOP.

      CLEAR lv_ebeln.

* ---------------------------------------------------------------------------
* Chama BAPI de criação do Pedido de Compra
* ---------------------------------------------------------------------------
      CALL FUNCTION 'BAPI_PO_CREATE1'
        EXPORTING
          poheader          = ls_header
          poheaderx         = ls_headerx
        IMPORTING
          exppurchaseorder  = lv_ebeln
          expheader         = ls_expheader
          exppoexpimpheader = ls_exppoexpimpheader
        TABLES
          return            = lt_return
          poitem            = lt_item
          poitemx           = lt_itemx
          poaccount         = lt_account
          poaccountx        = lt_accountx
          pocond            = lt_cond
          pocondx           = lt_condx
          serialnumber      = lt_serialnumber
          serialnumberx     = lt_serialnumberx.

      IF line_exists( lt_return[ type = 'E' ] ).

        " Iniciando criação do Pedido de Compra...
        et_return[] = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '024' ) ).
        INSERT LINES OF lt_return INTO TABLE et_return[].

        me->mapping_msg_table( EXPORTING is_historico = ls_historico_key
                                         it_return    = lt_return
                                CHANGING ct_msg       = ct_msg ).

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
        READ TABLE ct_historico TRANSPORTING NO FIELDS
                                              WITH KEY guid = ls_historico_key-guid
                                              BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.

        LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
          IF ls_historico_key-main_purchase_order IS NOT INITIAL.
            IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
              EXIT.
            ENDIF.
          ELSE.
            IF ls_historico->guid NE ls_historico_key-guid.
              EXIT.
            ENDIF.
          ENDIF.
* ---------------------------------------------------------------------------

          ls_historico->status = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                           THEN gc_status-incompleto
                                         ELSE ls_historico->status ).
        ENDLOOP.
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      " Pedido de compra &1 criado com sucesso.
      et_return[] = VALUE #( BASE et_return ( type       = 'S'
                                              id         = 'ZMM_DEPOSITO_FECHADO'
                                              number     = '025'
                                              message_v1 = |{ lv_ebeln ALPHA = OUT }| ) ).
      FREE: lt_return_aux[].
      lt_return_aux = VALUE #( BASE lt_return_aux ( type       = 'S'
                                                    id         = 'ZMM_DEPOSITO_FECHADO'
                                                    number     = '025'
                                                    message_v1 = |{ lv_ebeln ALPHA = OUT }| ) ).

      me->mapping_msg_table( EXPORTING is_historico = ls_historico_key
                                       it_return    = lt_return_aux[]
                              CHANGING ct_msg       = ct_msg ).

      SELECT ebeln,
             ebelp,
             matnr,
             werks
        FROM ekpo
       WHERE ebeln = @lv_ebeln
        INTO TABLE @DATA(lt_ekpo).

      SORT lt_item_add BY material
                          plant_dest.

      LOOP AT lt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

        READ TABLE lt_item_add INTO DATA(ls_item_add)
                                WITH KEY material   = <fs_ekpo>-matnr
                                         plant_dest = <fs_ekpo>-werks
                                         BINARY SEARCH.
        IF sy-subrc = 0.
          UPDATE ekpo
           SET j_1bmatuse = ls_item_add-mtuse
               j_1bmatorg = ls_item_add-mtorg
           WHERE ebeln  = <fs_ekpo>-ebeln
             AND ebelp  = <fs_ekpo>-ebelp.
        ENDIF.

      ENDLOOP.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS
                                            WITH KEY guid = ls_historico_key-guid
                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          READ TABLE lt_item INTO DATA(ls_item) WITH KEY material = ls_historico->material
                                                         plant    = ls_historico->destiny_plant
                                                         stge_loc = ls_historico->destiny_storage_location
                                                         batch    = ls_historico->batch
                                                         po_item  = ls_historico->main_purchase_order_item.
        ELSE.
          READ TABLE lt_item INTO ls_item WITH KEY material = ls_historico->material
                                                   plant    = ls_historico->destiny_plant
                                                   stge_loc = ls_historico->destiny_storage_location
                                                   batch    = ls_historico->batch.
        ENDIF.
        IF sy-subrc NE 0.
          CLEAR ls_item.
        ENDIF.

        ls_historico->status                    = COND #( WHEN ls_historico->status = '10'
                                                          THEN ls_historico->status
                                                          ELSE gc_status-saida_nota ).
        ls_historico->main_plant                = ls_item-plant.
        ls_historico->purchase_order            = lv_ebeln.
        ls_historico->purchase_order_item       = ls_item-po_item.
        ls_historico->incoterms1                = ls_item-incoterms1.
        ls_historico->incoterms2                = ls_item-incoterms2.
        ls_historico->order_quantity            = ls_item-quantity.
        ls_historico->order_quantity_unit       = ls_item-po_unit.

        ls_historico->last_changed_by = sy-uname.
        GET TIME STAMP FIELD ls_historico->last_changed_at.
        GET TIME STAMP FIELD ls_historico->local_last_changed_at.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_out_delivery.

    DATA: lt_stock          TYPE STANDARD TABLE OF bapidlvreftosto,
          lt_serial_number  TYPE STANDARD TABLE OF bapidlvserialnumber,
          lt_return         TYPE bapiret2_t,
          lv_due_date       TYPE ledat,
          lv_delivery       TYPE vbeln_vl,
          lv_num_deliveries TYPE vbnum,
          lt_created_items  TYPE STANDARD TABLE OF bapidlvitemcreated,
          ls_historico_a    TYPE ty_historico.

    DATA: lv_guid                TYPE sysuuid_x16,
          lv_main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order.

    FREE: et_return[].

* ---------------------------------------------------------------------------
* Aplica ordenação
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].

    SORT lt_historico_key BY main_purchase_order DESCENDING
                             main_purchase_order_item
                             guid.

    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING main_purchase_order
                                                               main_purchase_order_item
                                                               guid.

    SORT ct_historico BY guid
                         main_purchase_order
                         main_purchase_order_item.

* ---------------------------------------------------------------------------
* Prepara dados para criação da Remessa de Saída
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      CHECK ls_historico_key-out_delivery_document IS INITIAL.
      CHECK ls_historico_key-purchase_order IS NOT INITIAL.
* ---------------------------------------------------------------------------
* Verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------

      FREE: lt_stock[],
            lt_serial_number[],
            lt_return[],
            lt_created_items[].

      CLEAR: lv_delivery,
             lv_due_date.

      READ TABLE ct_historico TRANSPORTING NO FIELDS
                                            WITH KEY guid = ls_historico_key-guid
                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.

* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        " Recupera dados de material
        READ TABLE it_mara INTO DATA(ls_mara) WITH TABLE KEY matnr = ls_historico->material.

        IF sy-subrc NE 0.
          CLEAR ls_mara.
        ENDIF.

        " Recupera divisão de remessa
        READ TABLE it_eket INTO DATA(ls_eket) WITH TABLE KEY ebeln = ls_historico->purchase_order
                                                             ebelp = ls_historico->purchase_order_item.
        IF sy-subrc NE 0.
          CLEAR ls_eket.
        ENDIF.

        " Prepara dados de referencia
        " -------------------------------------------------------------------
        lv_due_date  = COND #( WHEN lv_due_date IS NOT INITIAL
                                 THEN lv_due_date
                               ELSE ls_eket-eindt ).

        lt_stock[]  = VALUE #( BASE lt_stock (
                               ref_doc    = ls_historico->purchase_order
                               ref_item   = ls_historico->purchase_order_item
                               deliv_numb = ls_historico->delivery_document
                               dlv_qty    = ls_historico->used_stock_conv
                               sales_unit = ls_historico->unit
                               ) ).

        " Prepara dados de série - Processo manual
        " -------------------------------------------------------------------
        IF ls_mara-mtart EQ gc_tipo_material-zcom.

          READ TABLE ct_serie TRANSPORTING NO FIELDS WITH KEY material         = ls_historico->material
                                                              plant            = ls_historico->plant
                                                              storage_location = ls_historico->storage_location
                                                              guid             = ls_historico->guid
                                                              process_step     = ls_historico->process_step
                                                              BINARY SEARCH.
          IF sy-subrc EQ 0.

            LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) FROM sy-tabix.

              IF ls_serie->material         <> ls_historico->material
              OR ls_serie->plant            <> ls_historico->plant
              OR ls_serie->storage_location <> ls_historico->storage_location
              OR ls_serie->guid             <> ls_historico->guid
              OR ls_serie->process_step     <> ls_historico->process_step.
                EXIT.
              ENDIF.

              lt_serial_number[] = VALUE #( BASE lt_serial_number ( ref_doc  = ls_historico->purchase_order
                                                                    ref_item = ls_historico->purchase_order_item
                                                                    serialno = ls_serie->serialno ) ).
            ENDLOOP.
          ENDIF.

        ELSE.

          " Prepara dados de série - Processo automático
          " -----------------------------------------------------------------
          LOOP AT it_equi REFERENCE INTO DATA(ls_equi) WHERE matnr = ls_historico->material
                                                         AND werk  = ls_historico->destiny_plant
                                                         AND lager = ls_historico->destiny_storage_location.

            lt_serial_number[]  = VALUE #( BASE lt_serial_number (
                                           ref_doc  = ls_historico->purchase_order
                                           ref_item = ls_historico->purchase_order_item
                                           serialno = ls_equi->sernr ) ).
          ENDLOOP.
        ENDIF.
      ENDLOOP.

* ---------------------------------------------------------------------------
* Chama BAPI de criação de Remessa de Saída
* ---------------------------------------------------------------------------

      lv_due_date = COND #( WHEN lv_due_date IS NOT INITIAL
                            THEN lv_due_date
                            ELSE sy-datum ).

      lv_guid = ls_historico->guid.
      EXPORT lv_guid FROM lv_guid TO MEMORY ID 'MM_REMESTRP'.
      " Export para ZCLMM_REMES_DEP_FECHADO~FILL_DELIVERY_HEADER / SAVE_DOCUMENT_PREPARE

      CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_STO'
        EXPORTING
          due_date          = lv_due_date
        IMPORTING
          delivery          = lv_delivery
          num_deliveries    = lv_num_deliveries
        TABLES
          created_items     = lt_created_items
          stock_trans_items = lt_stock
          serial_numbers    = lt_serial_number
          return            = lt_return.

      FREE MEMORY ID 'MM_REMESTRP'.

      IF line_exists( lt_return[ type = 'E' ] ).
        " Iniciando criação do Remessa de Saída...
        et_return[] = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '026' ) ).
        INSERT LINES OF lt_return INTO TABLE et_return[].

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.

        LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* Verifica se item de pedido principal
* ---------------------------------------------------------------------------
          IF ls_historico_key-main_purchase_order IS NOT INITIAL.
            IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
              EXIT.
            ENDIF.
          ELSE.
            IF ls_historico->guid NE ls_historico_key-guid.
              EXIT.
            ENDIF.
          ENDIF.

          CHECK ls_historico->status = gc_status-saida_nota
             OR ls_historico->status = iv_status.
* ---------------------------------------------------------------------------
          ls_historico->status                        = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                                            THEN gc_status-incompleto
*                                                            ELSE ls_historico->status ).
                                                            ELSE gc_status-saida_nota ).

          me->mapping_msg_table(
           EXPORTING
             is_historico = VALUE ty_historico( material = ls_historico->material
                                                plant    = ls_historico->plant
                                                storage_location = ls_historico->storage_location
                                                batch            = ls_historico->batch
                                                plant_dest       = ls_historico->plant_dest
                                                storage_location_dest = ls_historico->storage_location_dest
                                                guid             = ls_historico->guid )
             it_return    = lt_return
           CHANGING
             ct_msg       = ct_msg ).

        ENDLOOP.
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      " Remessa de saída &1 criada com sucesso.
      et_return[] = VALUE #( BASE et_return ( type       = 'S'
                                              id         = 'ZMM_DEPOSITO_FECHADO'
                                              number     = '027'
                                              message_v1 = |{ lv_delivery ALPHA = OUT }| ) ).

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS
                                            WITH KEY guid = ls_historico_key-guid
                                            BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* Verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------

        CHECK ls_historico->status = gc_status-saida_nota
           OR ls_historico->status = iv_status.

        READ TABLE lt_created_items REFERENCE INTO DATA(ls_created_items)
                                               WITH KEY ref_doc = ls_historico->purchase_order
                                                        ref_item = ls_historico->purchase_order_item.

        IF sy-subrc = 0.

          IF ls_historico->carrier IS INITIAL.
            ls_historico->status = gc_status-ordem_frete_job.
          ELSE.
            ls_historico->status = gc_status-ordem_frete.
          ENDIF.

          ls_historico->out_delivery_document      = ls_created_items->deliv_numb.
          ls_historico->out_delivery_document_item = ls_created_items->deliv_item.

        ELSE.
          ls_historico->status = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                           THEN gc_status-incompleto
*                                             ELSE ls_historico->status ).
                                           ELSE gc_status-saida_nota ).

          me->mapping_msg_table( EXPORTING
                                  is_historico = VALUE ty_historico( material              = ls_historico->material
                                                                     plant                 = ls_historico->plant
                                                                     storage_location      = ls_historico->storage_location
                                                                     batch                 = ls_historico->batch
                                                                     plant_dest            = ls_historico->plant_dest
                                                                     storage_location_dest = ls_historico->storage_location_dest
                                                                     guid                  = ls_historico->guid )
                                  it_return    = lt_return
                                 CHANGING
                                     ct_msg    = ct_msg ).

        ENDIF.

        ls_historico->last_changed_by = sy-uname.
        GET TIME STAMP FIELD ls_historico->last_changed_at.
        GET TIME STAMP FIELD ls_historico->local_last_changed_at.

      ENDLOOP.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Verifica se numeração do item está correta
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_lips          = DATA(lt_lips) ).

    SORT ct_historico BY guid.

    LOOP AT lt_historico_key INTO ls_historico_key.

      CHECK ls_historico_key-out_delivery_document IS INITIAL.
      CHECK ls_historico_key-purchase_order IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        CHECK ls_historico->status NE gc_status-incompleto.

        READ TABLE lt_lips INTO DATA(ls_lips) WITH KEY vbeln = ls_historico->out_delivery_document
                                                       posnr = ls_historico->out_delivery_document_item
                                                       matnr = ls_historico->material.
        IF sy-subrc EQ 0.
          IF ls_historico->carrier IS INITIAL.
            ls_historico->status = gc_status-ordem_frete_job.
          ELSE.
            ls_historico->status = gc_status-ordem_frete.
          ENDIF.

          ls_historico->out_delivery_document_item = COND #( WHEN ls_historico->out_delivery_document_item EQ ls_lips-posnr
                                                              THEN ls_historico->out_delivery_document_item
                                                             ELSE ls_lips-posnr ).
          ls_historico->out_sales_order      = ls_lips-vgbel.
          ls_historico->out_sales_order_item = ls_lips-vgpos.

          ls_historico->last_changed_by = sy-uname.
          GET TIME STAMP FIELD ls_historico->last_changed_at.
          GET TIME STAMP FIELD ls_historico->local_last_changed_at.

        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD create_out_delivery_check.

    IF iv_current_date IS INITIAL.
      rv_ok = abap_true.
      RETURN.
    ENDIF.

    READ TABLE it_lips INTO DATA(ls_lips) WITH KEY vbeln = iv_delivery BINARY SEARCH.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    IF ls_lips-wadat = sy-datum.
      rv_ok = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD create_out_material_document.

    TYPES: BEGIN OF ty_vbeln,
             vbeln TYPE lips-vbeln,
           END OF ty_vbeln,

           BEGIN OF ty_partner,
             partner TYPE bu_partner,
           END OF ty_partner.

    TYPES: BEGIN OF ty_ordem,
             vbeln TYPE /scmtms/base_btd_id,
           END OF ty_ordem,

           ty_tt_ordens TYPE SORTED TABLE OF ty_ordem WITH UNIQUE KEY vbeln.

    DATA: lt_vbpok                    TYPE STANDARD TABLE OF vbpok,
          lt_sernr                    TYPE STANDARD TABLE OF vlser,
          lt_prot                     TYPE STANDARD TABLE OF prott,
*          lt_return                   TYPE bapiret2_t,
          lt_mseg_aux                 TYPE STANDARD TABLE OF ty_mseg,
          lt_lips_key                 TYPE TABLE OF ty_vbeln,
          lt_partner                  TYPE TABLE OF ty_partner,
          lt_item_data                TYPE STANDARD TABLE OF bapiobdlvitemchg,
          lt_item_control             TYPE STANDARD TABLE OF bapiobdlvitemctrlchg,
          lt_item_data_spl            TYPE STANDARD TABLE OF /spe/bapiobdlvitemchg,
          lt_partner_update           TYPE shp_partner_update_t,
          lt_header_partner           TYPE /spe/bapidlvpartnerchg_t,
          lt_historico_msg            TYPE ty_t_historico,
          lt_return1                  TYPE bapiret2_t,

          ls_vbkok                    TYPE vbkok,
          ls_lin_key                  TYPE ty_lin,
          ls_header_data              TYPE bapiobdlvhdrchg,
          ls_header_control           TYPE bapiobdlvhdrctrlchg,
          ls_delivery                 TYPE vbeln_vl,
          ls_techn_control            TYPE bapidlvcontrol,

          lv_serialline               TYPE posnr,
          lv_error_any_0              TYPE xfeld,
          lv_error_in_item_deletion_0 TYPE xfeld,
          lv_error_in_pod_update_0    TYPE xfeld,
          lv_error_in_interface_0     TYPE xfeld,
          lv_error_in_goods_issue_0   TYPE xfeld,
          lv_error_in_final_check_0   TYPE xfeld,
          lv_error_partner_update     TYPE xfeld,
          lv_error_sernr_update       TYPE xfeld,
          lv_nitemped                 TYPE j_1b_purch_ord_item_ext,
          lv_vbeln                    TYPE lips-vbeln.

    FREE: et_return[].

* ---------------------------------------------------------------------------
* Aplica ordenação aquiaqui
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].

    SORT lt_historico_key BY guid
                             out_delivery_document DESCENDING.

    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING guid
                                                               out_delivery_document.

    lt_lips_key = VALUE #( FOR ls_historico_key1 IN ct_historico WHERE ( out_delivery_document IS NOT INITIAL ) ( vbeln = ls_historico_key1-out_delivery_document ) ).

    SORT lt_lips_key.
    DELETE ADJACENT DUPLICATES FROM lt_lips_key.

    IF lt_lips_key[] IS NOT INITIAL.

      SELECT vbeln,
             vgbel,
             vgpos,
             posnr,
             matnr,
             umvkz,
             umvkn,
             meins,
             vrkme,
             werks,
             lgpla,
             lgtyp,
             bwlvs,
             bwtar,
             insmk
        FROM lips
         FOR ALL ENTRIES IN @lt_lips_key
       WHERE vbeln = @lt_lips_key-vbeln
        INTO TABLE @DATA(lt_lips).

    ENDIF.

    SORT lt_lips BY vbeln
                    vgbel
                    vgpos
                    posnr.

    lt_partner = VALUE #( FOR ls_historico_key1 IN ct_historico WHERE ( driver IS NOT INITIAL ) ( partner = ls_historico_key1-driver ) ).

    SORT lt_partner. DELETE ADJACENT DUPLICATES FROM lt_partner.

    IF lt_partner IS NOT INITIAL.
      SELECT partner,
             idnumber
        FROM but0id
         FOR ALL ENTRIES IN @lt_partner
       WHERE partner = @lt_partner-partner
         AND type = 'HCM001'
        INTO TABLE @DATA(lt_but0id).

    ENDIF.

    DATA(lt_historico_aux) = CORRESPONDING ty_tt_ordens( lt_historico_key  DISCARDING DUPLICATES MAPPING vbeln = out_delivery_document ).

    IF lt_historico_aux[] IS NOT INITIAL.
      SELECT _rot~base_btd_id
        FROM /scmtms/d_torrot AS _rot
       INNER JOIN @lt_historico_aux AS _hist_aux
               ON concat( '0000000000000000000000000', _hist_aux~vbeln ) = _rot~base_btd_id
        INTO TABLE @DATA(lt_rot_base).
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara dados para criação da Saída de Mercadoria (Documento Material Saída)
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      CHECK ls_historico_key-out_material_document IS INITIAL.
      CHECK ls_historico_key-out_delivery_document IS NOT INITIAL.

      FREE: lt_vbpok[],
            lt_sernr[],
            lt_return1[],
            lt_item_data[],
            lt_item_control[],
            lt_item_data_spl[],
            lt_partner_update[],
            lt_header_partner[],
            lt_historico_msg[].

      CLEAR: ls_header_data,
             ls_header_control,
             ls_delivery,
             ls_techn_control.

      CLEAR: lv_vbeln.

      DATA(lv_error) = abap_false.

      SORT ct_historico BY guid
                           out_delivery_document
                           out_delivery_document_item.

      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid                  = ls_historico_key-guid
                                                              out_delivery_document = ls_historico_key-out_delivery_document
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.

        IF ls_historico->guid                  NE ls_historico_key-guid
        OR ls_historico->out_delivery_document NE ls_historico_key-out_delivery_document.
          EXIT.
        ENDIF.

        IF ls_historico->out_delivery_document IS INITIAL.
          CONTINUE.
        ENDIF.

        IF lv_vbeln IS INITIAL.
          lv_vbeln = ls_historico->out_delivery_document.
        ENDIF.

        IF lv_vbeln <> ls_historico->out_delivery_document.

          SORT lt_partner_update. DELETE ADJACENT DUPLICATES FROM lt_partner_update COMPARING parvw.
          SORT lt_header_partner. DELETE ADJACENT DUPLICATES FROM lt_header_partner COMPARING partn_role.
          CLEAR lt_return1.

          DATA(lv_remessa_conv) = CONV /scmtms/base_btd_id( |{ lv_vbeln ALPHA = IN }| ).
          IF line_exists( lt_partner_update[ parvw = 'SP' ] ) AND line_exists( lt_rot_base[ base_btd_id = lv_remessa_conv ] ) .
            CONTINUE.
          ENDIF.

* BEGIN OF INSERT - JWSILVA - 19.02.2023
          " Somente executar processo para dia atual
          DATA(lv_delivery_update) = me->create_out_delivery_check( EXPORTING iv_delivery     = lv_vbeln
                                                                              it_lips         = it_lips
                                                                              iv_current_date = iv_current_date ).


          IF lv_delivery_update EQ abap_true.
* END OF INSERT - JWSILVA - 19.02.2023

            delivery_update( EXPORTING iv_delivery       = lv_vbeln
                                       is_vbkok          = ls_vbkok
                                       it_vbpok          = lt_vbpok
                                       it_sernr          = lt_sernr
                                       it_item_control   = lt_item_control
                                       it_item_data      = lt_item_data
                                       it_item_data_spl  = lt_item_data_spl
                                       it_partner_update = lt_partner_update
                                       it_header_partner = lt_header_partner
                             IMPORTING ev_error          = lv_error
                              CHANGING ct_return         = lt_return1 ).

            APPEND LINES OF lt_return1 TO et_return.

* BEGIN OF INSERT - JWSILVA - 19.02.2023
          ENDIF.
* END OF INSERT - JWSILVA - 19.02.2023

          IF lv_error = abap_true.

            LOOP AT lt_historico_msg ASSIGNING FIELD-SYMBOL(<fs_hist_msg>).

              me->mapping_msg_table( EXPORTING is_historico = CORRESPONDING ty_historico(  <fs_hist_msg> )
                                               it_return    = lt_return1
                                      CHANGING ct_msg       = ct_msg ).

            ENDLOOP.
          ENDIF.

          IF lv_error = abap_true.
            EXIT.
          ENDIF.


          FREE: lt_vbpok[],
                lt_sernr[],
                lt_return1[],
                lt_item_data[],
                lt_item_control[],
                lt_item_data_spl[],
                lt_partner_update[],
                lt_header_partner[],
                lt_historico_msg[].

          CLEAR: ls_header_data,
                 ls_header_control,
                 ls_delivery,
                 ls_techn_control.

          lv_vbeln = ls_historico->out_delivery_document.
        ENDIF.

        APPEND VALUE ty_historico( material              = ls_historico->material
                                   plant                 = ls_historico->plant
                                   storage_location      = ls_historico->storage_location
                                   batch                 = ls_historico->batch
                                   plant_dest            = ls_historico->plant_dest
                                   storage_location_dest = ls_historico->storage_location_dest
                                   guid                  = ls_historico->guid ) TO lt_historico_msg.

        IF lt_partner_update IS INITIAL AND ls_historico->carrier IS NOT INITIAL.
          lt_partner_update = VALUE #( ( vbeln_vl = lv_vbeln  parvw = 'SP' parnr = ls_historico->carrier  updkz_par = abap_true ) ).
        ENDIF.

        IF ls_historico->driver IS NOT INITIAL.
          READ TABLE lt_but0id INTO DATA(ls_but0id) WITH KEY partner = ls_historico->driver BINARY SEARCH.

          IF sy-subrc = 0.
            lt_partner_update = VALUE #( BASE lt_partner_update ( vbeln_vl = lv_vbeln  parvw = 'YM' parnr = ls_but0id-idnumber  updkz_par = abap_true ) ).
          ENDIF.
        ENDIF.

        " Recupera dados de material
        READ TABLE it_mara INTO DATA(ls_mara) WITH TABLE KEY matnr = ls_historico->material.

        IF sy-subrc NE 0.
          CLEAR ls_mara.
        ENDIF.

        " Recupera Área de avaliação
        READ TABLE it_t001k INTO DATA(ls_t001k) WITH TABLE KEY bwkey = ls_historico->plant.

        IF sy-subrc NE 0.
          CLEAR ls_t001k.
        ENDIF.

        READ TABLE lt_lips INTO DATA(ls_lips) WITH KEY vbeln = ls_historico->out_delivery_document
                                                       posnr = ls_historico->out_delivery_document_item
                                                       vgbel = ls_historico->purchase_order
                                                       vgpos = ls_historico->purchase_order_item BINARY SEARCH.


        ls_vbkok = VALUE #( vbeln_vl = ls_historico->out_delivery_document
                            vbeln    = ls_historico->out_delivery_document
                            kzntg    = abap_true
                            wabuc    = abap_true
                            vsart    = ls_historico->shipping_type
                            kzvsart  = abap_true
                            inco1    = COND #( WHEN ls_historico->freight_mode IS INITIAL
                                                 THEN 'SFR'
                                               ELSE ls_historico->freight_mode )
                            kzinco1  = abap_true
                            inco2    = COND #( WHEN ls_historico->freight_mode IS INITIAL
                                                 THEN 'SFR'
                                               ELSE ls_historico->freight_mode )
                            kzinco2  = abap_true
                            traid    = ls_historico->equipment
                            traty    = 'SP11'
                            xwmpp    = abap_true
                            vsbed    = ls_historico->shipping_conditions
                            kzvsbed  = abap_true ).

        lt_vbpok[] = VALUE #( BASE lt_vbpok ( vbeln_vl = ls_lips-vbeln
                                              posnr_vl = ls_lips-posnr
                                              vbeln    = ls_lips-vbeln
                                              posnn    = ls_lips-posnr
                                              lgort    = ls_historico->storage_location
                                              werks    = ls_historico->plant
                                              charg    = ls_historico->batch
*                                              charg    = '0000001765'
                                              pikmg    = ls_historico->order_quantity
*                                              meins    = ls_historico->order_quantity_unit
                                              lfimg    = ls_historico->order_quantity
                                              meins    = ls_lips-meins
*                                              KZLGO    = abap_true
*                                              werks    = ls_lips-werks
                                              lgpla    = ls_lips-lgpla
                                              lgtyp    = ls_lips-lgtyp
                                              bwlvs    = ls_lips-bwlvs
                                              bwtar    = |{ ls_t001k-bukrs }{ ls_historico->plant }IN| ) ).

        lt_item_data = VALUE #( BASE lt_item_data ( deliv_numb      = ls_lips-vbeln
                                                    deliv_item      = ls_lips-posnr
                                                    material        = ls_lips-matnr
                                                    fact_unit_nom   = ls_lips-umvkz
                                                    fact_unit_denom = ls_lips-umvkn
                                                    base_uom        = ls_lips-meins
                                                    sales_unit      = ls_lips-vrkme
                                                    batch           = ls_historico->batch
*                                                    batch      = '0000001765'
                                                    val_type        = |{ ls_t001k-bukrs }{ ls_historico->plant }IN|
                                                    stock_type      = ls_lips-insmk
                                                    dlv_qty         = ls_historico->used_stock ) ).

        lt_item_control = VALUE #( BASE lt_item_control ( deliv_numb = ls_lips-vbeln
                                                          deliv_item = ls_lips-posnr ) ).

        lt_item_data_spl = VALUE #( BASE lt_item_data_spl ( deliv_numb = ls_lips-vbeln
                                                            deliv_item = ls_lips-posnr
                                                            pick_denial = abap_true
                                                            stge_loc = ls_historico->storage_location ) ).

        IF ls_historico->carrier IS NOT INITIAL AND lt_header_partner IS INITIAL.
          lt_header_partner = VALUE #( ( upd_mode_partn = 'U'
                                         deliv_numb     = ls_lips-vbeln
                                         itm_number     = ls_lips-posnr
                                         partn_role     = 'SP'
                                         partner_no     = ls_historico->carrier ) ).
        ENDIF.

        IF ls_historico->driver IS NOT INITIAL AND ls_but0id-partner = ls_historico->driver.
          lt_header_partner = VALUE #( BASE lt_header_partner ( upd_mode_partn = 'U'
                                                                deliv_numb     = ls_lips-vbeln
                                                                itm_number     = ls_lips-posnr
                                                                partn_role     = 'YM'
                                                                partner_no     = ls_but0id-idnumber ) ).
        ENDIF.

        " Prepara dados de série - Processo manual
        " -------------------------------------------------------------------
        FREE: lv_serialline.

        IF ls_mara-mtart EQ gc_tipo_material-zcom.

          READ TABLE ct_serie TRANSPORTING NO FIELDS WITH KEY material         = ls_historico->material
                                                              plant            = ls_historico->plant
                                                              storage_location = ls_historico->storage_location
                                                              guid             = ls_historico->guid
                                                              process_step     = ls_historico->process_step
                                                              BINARY SEARCH.
          IF sy-subrc EQ 0.

            LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) FROM sy-tabix.

              IF ls_serie->material         <> ls_historico->material
              OR ls_serie->plant            <> ls_historico->plant
              OR ls_serie->storage_location <> ls_historico->storage_location
              OR ls_serie->guid             <> ls_historico->guid
              OR ls_serie->process_step     <> ls_historico->process_step.
                EXIT.
              ENDIF.

              ADD 10 TO lv_serialline.
              lt_sernr[]  = VALUE #( BASE lt_sernr (
                                     posnr  = lv_serialline
                                     sernr  = ls_serie->serialno ) ).
            ENDLOOP.
          ENDIF.

        ELSE.

          " Prepara dados de série - Processo automático
          " -----------------------------------------------------------------
          LOOP AT it_equi REFERENCE INTO DATA(ls_equi) WHERE matnr = ls_historico->material
                                                         AND werk  = ls_historico->destiny_plant
                                                         AND lager = ls_historico->destiny_storage_location.

            ADD 10 TO lv_serialline.
            lt_sernr[]  = VALUE #( BASE lt_sernr (
                                   posnr  = lv_serialline
                                   sernr  = ls_equi->sernr ) ).
          ENDLOOP.

        ENDIF.

      ENDLOOP.


      CHECK lv_error = abap_false.

      SORT lt_partner_update. DELETE ADJACENT DUPLICATES FROM lt_partner_update COMPARING parvw.
      SORT lt_header_partner. DELETE ADJACENT DUPLICATES FROM lt_header_partner COMPARING partn_role.

      FREE: lt_return1[].
      CLEAR lv_remessa_conv.

      lv_remessa_conv = |{ lv_vbeln ALPHA = IN }|.

      IF line_exists( lt_partner_update[ parvw = 'SP' ] ) AND line_exists( lt_rot_base[ base_btd_id = lv_remessa_conv ] ) .
        CONTINUE.
      ENDIF.

      delivery_update( EXPORTING iv_delivery       = lv_vbeln
                                 is_vbkok          = ls_vbkok
                                 it_vbpok          = lt_vbpok
                                 it_sernr          = lt_sernr
                                 it_item_control   = lt_item_control
                                 it_item_data      = lt_item_data
                                 it_item_data_spl  = lt_item_data_spl
                                 it_partner_update = lt_partner_update
                                 it_header_partner = lt_header_partner
                       IMPORTING ev_error          = lv_error
                        CHANGING ct_return         = lt_return1 ).

      APPEND LINES OF lt_return1 TO et_return.

      lv_vbeln = ls_historico->out_delivery_document.

      IF lv_error = abap_true.

        READ TABLE ct_historico REFERENCE INTO DATA(ls_historico_aux)
                                           WITH KEY material              = ls_historico_key-material
                                                    plant                 = ls_historico_key-plant
                                                    storage_location      = ls_historico_key-storage_location
                                                    batch                 = ls_historico_key-batch
                                                    plant_dest            = ls_historico_key-plant_dest
                                                    storage_location_dest = ls_historico_key-storage_location_dest
                                                    guid                  = ls_historico_key-guid.

        IF sy-subrc = 0.
          ls_historico_aux->status = COND #( WHEN is_max_execution_status( ls_historico_aux->guid ) = abap_true
                                               THEN gc_status-incompleto
                                             ELSE ls_historico_aux->status ).
        ENDIF.

        LOOP AT lt_historico_msg ASSIGNING <fs_hist_msg>.

          me->mapping_msg_table( EXPORTING is_historico = CORRESPONDING ty_historico( <fs_hist_msg> )
                                           it_return    = lt_return1
                                  CHANGING ct_msg       = ct_msg ).

        ENDLOOP.
      ENDIF.
    ENDLOOP.

*    IF line_exists( lt_partner_update[ parvw = 'SP' ] ) .
*      RETURN.
*    ENDIF.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_mseg          = DATA(lt_mseg)
                                 et_lin           = DATA(lt_lin) ).

    LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).
      <fs_lin>-nitemped = |{ <fs_lin>-nitemped ALPHA = IN }|  .
    ENDLOOP.

    SORT lt_lin BY xped
                   nitemped
                   matnr.

    lt_mseg_aux[] = lt_mseg[].

    SORT lt_mseg_aux BY vbeln_im
                        vbelp_im
                        zeile.

    SORT ct_historico BY guid.

    LOOP AT lt_historico_key INTO ls_historico_key.

      CHECK ls_historico_key-out_material_document IS INITIAL.
      CHECK ls_historico_key-out_delivery_document IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                        BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.

        IF ls_historico->guid NE ls_historico_key-guid.
          EXIT.
        ENDIF.

        READ TABLE lt_mseg_aux INTO DATA(ls_mseg) WITH KEY vbeln_im = ls_historico->out_delivery_document
                                                           vbelp_im = ls_historico->out_delivery_document_item
                                                           BINARY SEARCH.
*        WITH KEY remessa COMPONENTS vbeln_im = ls_historico->out_delivery_document
*                                                                              vbelp_im = ls_historico->out_delivery_document_item.
        IF sy-subrc EQ 0.
          ls_historico->status                     = COND #( WHEN ls_historico->carrier IS NOT INITIAL THEN gc_status-em_transito ELSE gc_status-entrada_merc ).
          ls_historico->out_material_document      = ls_mseg-mblnr.
          ls_historico->out_material_document_year = ls_mseg-mjahr.
          ls_historico->out_material_document_item = ls_mseg-zeile.
        ELSE.
          ls_historico->status = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                          THEN gc_status-incompleto
                                         ELSE ls_historico->status ).
        ENDIF.

        ls_lin_key-refkey = |{ ls_historico->out_material_document }{ ls_historico->out_material_document_year }|.
        ls_lin_key-refitm = ls_historico->out_material_document_item.

        lv_nitemped = ls_historico->purchase_order_item.
        lv_nitemped = |{ lv_nitemped ALPHA = IN }|.

        READ TABLE lt_lin INTO DATA(ls_lin) WITH KEY xped     = ls_historico->purchase_order
                                                     nitemped = lv_nitemped
                                                     matnr    = ls_historico->material
                                                     BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_historico->out_br_nota_fiscal      = ls_lin-docnum.
          ls_historico->out_br_nota_fiscal_item = ls_lin-itmnum.

        ELSE.

          lv_nitemped = ls_historico->purchase_order_item / 10.
          lv_nitemped = |{ lv_nitemped ALPHA = IN }|.

          READ TABLE lt_lin INTO ls_lin WITH KEY xped     = ls_historico->purchase_order
                                                 nitemped = lv_nitemped
                                                 matnr    = ls_historico->material
                                                 BINARY SEARCH.
          IF sy-subrc EQ 0.
            ls_historico->out_br_nota_fiscal      = ls_lin-docnum.
            ls_historico->out_br_nota_fiscal_item = ls_lin-itmnum.
          ENDIF.

        ENDIF.

        ls_historico->last_changed_by = sy-uname.
        GET TIME STAMP FIELD ls_historico->last_changed_at.
        GET TIME STAMP FIELD ls_historico->local_last_changed_at.

      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_in_delivery.

    TYPES: BEGIN OF ty_return_list,
             out_delivery_document TYPE vbeln_vl,
             in_delivery_document  TYPE vbeln_vl,
           END OF ty_return_list.

    DATA: lt_detail                TYPE STANDARD TABLE OF bbp_inbd_d,
          lt_bapireturn            TYPE  bapiret2_t,
          lt_return_list           TYPE TABLE OF ty_return_list,

          ls_header                TYPE bbp_inbd_l,
          lv_vbeln                 TYPE vbeln_vl,
          lv_out_delivery_document TYPE vbeln_vl,
          lT_HISTORICO_msg         TYPE ty_t_historico.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Aplica ordenação teste
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].
    SORT lt_historico_key BY main_purchase_order guid.
    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING main_purchase_order guid.

    SORT ct_historico BY guid main_purchase_order main_purchase_order_item out_delivery_document.

    DATA: lv_main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order.
* ---------------------------------------------------------------------------
* Prepara dados para criação do aviso de recebimento (Remessa entrada)
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      CHECK ls_historico_key-in_delivery_document IS INITIAL.
      CHECK ls_historico_key-purchase_order IS NOT INITIAL.
      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.

* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------

      FREE: lt_detail,
            lt_bapireturn,
            lv_vbeln.
      DATA(lv_error) = abap_false.

      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        IF lv_out_delivery_document IS INITIAL.
          lv_out_delivery_document = ls_historico->out_delivery_document.
        ENDIF.

        IF lv_out_delivery_document NE ls_historico->out_delivery_document.

          inb_delivery_create(
            EXPORTING
              is_header     = ls_header
              it_detail     = lt_detail
            IMPORTING
              ev_error      = lv_error
              ev_vbeln      = lv_vbeln
            CHANGING
              ct_bapireturn = lt_bapireturn ).

          et_return = VALUE #( FOR ls_bapireturn IN lt_bapireturn (
                               type  = ls_bapireturn-type
                              id     = ls_bapireturn-id
                              number = ls_bapireturn-number
                              message_v1  = ls_bapireturn-message_v1
                              message_v2 = ls_bapireturn-message_v2
                              message_v3 = ls_bapireturn-message_v3
                              message_v4 = ls_bapireturn-message_v4 ) ).

          IF lv_error = abap_true.
            LOOP AT lt_historico_msg ASSIGNING FIELD-SYMBOL(<fs_hist_msg>).

              me->mapping_msg_table(
               EXPORTING
                 is_historico = CORRESPONDING ty_historico(  <fs_hist_msg> )
                 it_return    = lt_bapireturn
               CHANGING
                 ct_msg       = ct_msg ).

            ENDLOOP.

            EXIT.
          ENDIF.

          APPEND VALUE #( out_delivery_document = lv_out_delivery_document
                          in_delivery_document  = lv_vbeln ) TO lt_return_list.

          FREE: lt_detail,
                lt_bapireturn,
                lv_vbeln,
                lT_HISTORICO_msg.


          lv_out_delivery_document = ls_historico->out_delivery_document.

        ENDIF.

        APPEND VALUE ty_historico( material = ls_historico->material
                                          plant    = ls_historico->plant
                                          storage_location = ls_historico->storage_location
                                          batch            = ls_historico->batch
                                          plant_dest       = ls_historico->plant_dest
                                          storage_location_dest = ls_historico->storage_location_dest
                                          guid             = ls_historico->guid ) TO lt_HISTORICO_msg.



        ls_header      = VALUE #( deliv_date = sy-datum ).

        lt_detail[]    = VALUE #( BASE lt_detail (
                                  material     = ls_historico->material
                                  deliv_qty    = ls_historico->order_quantity
                                  unit         = ls_historico->order_quantity_unit
                                  po_number    = ls_historico->purchase_order
                                  po_item      = ls_historico->purchase_order_item ) ).
      ENDLOOP.

      CHECK lv_error = abap_false.

      inb_delivery_create(
        EXPORTING
          is_header     = ls_header
          it_detail     = lt_detail
        IMPORTING
          ev_error      = lv_error
          ev_vbeln      = lv_vbeln
        CHANGING
          ct_bapireturn = lt_bapireturn ).


      et_return = VALUE #( FOR ls_bapireturn IN lt_bapireturn (
                           type  = ls_bapireturn-type
                          id     = ls_bapireturn-id
                          number = ls_bapireturn-number
                          message_v1  = ls_bapireturn-message_v1
                          message_v2 = ls_bapireturn-message_v2
                          message_v3 = ls_bapireturn-message_v3
                          message_v4 = ls_bapireturn-message_v4 ) ).

      APPEND VALUE #( out_delivery_document = lv_out_delivery_document
                      in_delivery_document  = lv_vbeln ) TO lt_return_list.

      IF lv_error = abap_true.
        LOOP AT lt_historico_msg ASSIGNING <fs_hist_msg>.

          me->mapping_msg_table(
           EXPORTING
             is_historico = CORRESPONDING ty_historico(  <fs_hist_msg> )
             it_return    = lt_bapireturn
           CHANGING
             ct_msg       = ct_msg ).

        ENDLOOP.

      ENDIF.

    ENDLOOP.

    SORT lt_return_list BY out_delivery_document.

    LOOP AT ct_historico REFERENCE INTO ls_historico.
      READ TABLE lt_return_list ASSIGNING FIELD-SYMBOL(<fs_return_list>) WITH KEY out_delivery_document = ls_historico->out_delivery_document BINARY SEARCH.

      IF sy-subrc = 0.
        ls_historico->in_delivery_document = <fs_return_list>-in_delivery_document.
*        ls_historico->status                       = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
*                                                            THEN gc_status-incompleto
*                                                            ELSE ls_historico->status ).
      ENDIF.
    ENDLOOP.


* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_lips          = DATA(lt_lips) ).


    SORT ct_historico BY guid.

    LOOP AT lt_historico_key INTO ls_historico_key.

      CHECK ls_historico_key-in_delivery_document IS INITIAL.
      CHECK ls_historico_key-purchase_order IS NOT INITIAL.
      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          READ TABLE lt_lips INTO DATA(ls_lips) WITH KEY vbeln = ls_historico->in_delivery_document
                                                         matnr = ls_historico->material
                                                         posnr = ls_historico->main_purchase_order_item.
        ELSE.
          READ TABLE lt_lips INTO ls_lips WITH KEY vbeln = ls_historico->in_delivery_document
                                                   matnr = ls_historico->material.
        ENDIF.
        IF sy-subrc EQ 0.
          ls_historico->status                     = gc_status-entrada_merc.
          ls_historico->in_delivery_document_item  = ls_lips-posnr.
        ENDIF.
      ENDLOOP.

    ENDLOOP.

    me->call_save_background( EXPORTING it_historico = ct_historico
                                        it_serie     = ct_serie
                              IMPORTING et_return    = DATA(lt_return) ).
  ENDMETHOD.


  METHOD validate_out_nota_fiscal.

    DATA: lv_item TYPE j_1bnflin-itmnum.

    FREE: et_return.

    DATA: ls_msg  TYPE zsmm_df_his_dep_msg.

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].
    DATA(lt_lin) = it_lin.
    SORT lt_lin BY docnum
                   itmnum
                   matnr.

* ---------------------------------------------------------------------------
* Prepara dados para criação do aviso de recebimento (Remessa entrada)
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).
      DATA(lv_tabix) = sy-tabix.

      ls_msg = CORRESPONDING #( ls_historico_key ).

      IF ls_historico_key-out_material_document IS INITIAL.

        " Nota Fiscal de saída não foi criado/encontrado. Não é possível continuar.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '045' ) ).
        ls_msg-type = 'I'.
        ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
        ls_msg-number = '045'.
        APPEND ls_msg TO ct_msg.

        ls_historico_key-status = COND #( WHEN is_max_execution_status( ls_historico_key-guid ) = abap_true
       THEN gc_status-incompleto
       ELSE ls_historico_key-status  ).

        MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.
        CONTINUE.
      ENDIF.


      IF ls_historico_key-out_br_nota_fiscal IS INITIAL.
        " Nota Fiscal de saída não foi criado/encontrado. Não é possível continuar.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '011' ) ).
        ls_msg-type = 'I'.
        ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
        ls_msg-number = '011'.
        APPEND ls_msg TO ct_msg.

        " Nota Fiscal de saída não foi criado/encontrado. Não é possível continuar.
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'V1' number = '302' message_v1 = ls_historico_key-out_delivery_document ) ).
        ls_msg-type = 'I'.
        ls_msg-id   =  'V1'.
        ls_msg-number = '302'.
        ls_msg-message_v1 = ls_historico_key-out_delivery_document.
        APPEND ls_msg TO ct_msg.

        ls_historico_key-status = gc_status-incompleto.

        MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.
        CONTINUE.
      ENDIF.

      READ TABLE lt_lin INTO DATA(ls_lin) WITH KEY docnum = ls_historico_key-out_br_nota_fiscal
                                                   itmnum = ls_historico_key-out_br_nota_fiscal_item
                                                   matnr  = ls_historico_key-material
                                                   BINARY SEARCH.
      IF sy-subrc NE 0.
        lv_item = ls_historico_key-out_br_nota_fiscal_item / 10.
        READ TABLE lt_lin INTO ls_lin WITH KEY docnum = ls_historico_key-out_br_nota_fiscal
                                               itmnum = lv_item
                                               matnr  = ls_historico_key-material
                                               BINARY SEARCH.
        IF sy-subrc NE 0.
          " Nota Fiscal de saída não foi criado/encontrado. Não é possível continuar.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '011' ) ).
          ls_msg-type = 'I'.
          ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
          ls_msg-number = '011'.
          APPEND ls_msg TO ct_msg.

          ls_historico_key-status = gc_status-incompleto.

          MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.
          CONTINUE.
        ENDIF.
      ENDIF.

      IF ls_lin-direct NE gc_dir_movimento-saida.
        " Nota Fiscal de saída &1 com direção de movimento incorreto..
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '012'
                                                message_v1 = ls_lin-docnum ) ).
        ls_msg-type = 'I'.
        ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
        ls_msg-number = '012'.
        ls_msg-message_v1 = ls_lin-docnum.
        APPEND ls_msg TO ct_msg.

        ls_historico_key-status = gc_status-incompleto.

        MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.
        CONTINUE.
      ENDIF.

      IF ls_lin-direct NE gc_dir_movimento-saida.
        " Nota Fiscal de saída &1 com direção de movimento incorreto..
        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '012'
                                                message_v1 = ls_lin-docnum ) ).
        ls_msg-type = 'I'.
        ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
        ls_msg-number = '012'.
        ls_msg-message_v1 = ls_lin-docnum.
        APPEND ls_msg TO ct_msg.
        ls_historico_key-status = gc_status-incompleto.

        MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.
        CONTINUE.
      ENDIF.

      CASE ls_lin-docsta.
        WHEN gc_status_documento-1_tela.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '038'
                                                  message_v1 = ls_lin-docnum ) ).
          ls_msg-type = 'I'.
          ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
          ls_msg-number = '038'.
          ls_msg-message_v1 = ls_lin-docnum.
          APPEND ls_msg TO ct_msg.
          CONTINUE.
        WHEN gc_status_documento-autorizado.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '039'
                                                  message_v1 = ls_lin-docnum ) ).
          ls_historico_key-status = gc_status-nota_input.
          ls_msg-type = 'I'.
          ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
          ls_msg-number = '039'.
          ls_msg-message_v1 = ls_lin-docnum.
          APPEND ls_msg TO ct_msg.
        WHEN OTHERS.
          et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '040'
                                                  message_v1 = ls_lin-docnum ) ).
          ls_historico_key-status = gc_status-nota_rejeita.
          ls_msg-type = 'I'.
          ls_msg-id   =  'ZMM_DEPOSITO_FECHADO'.
          ls_msg-number = '040'.
          ls_msg-message_v1 = ls_lin-docnum.

          ls_historico_key-status = gc_status-incompleto.
          APPEND ls_msg TO ct_msg.
      ENDCASE.

      MODIFY ct_historico FROM ls_historico_key INDEX lv_tabix.

    ENDLOOP.

    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD create_in_material_document.

    TYPES: BEGIN OF ty_docnum,
             docnum TYPE j_1bdocnum,
           END OF ty_docnum.

    DATA: lt_item             TYPE STANDARD TABLE OF bapi2017_gm_item_create,
          lt_serialnumber     TYPE STANDARD TABLE OF bapi2017_gm_serialnumber,
          lt_return           TYPE bapiret2_t,

          ls_header           TYPE bapi2017_gm_head_01,
          ls_headret          TYPE bapi2017_gm_head_ret,

          lv_code             TYPE bapi2017_gm_code,
          lv_materialdocument TYPE mblnr,
          lv_matdocumentyear  TYPE mjahr,
          lv_serialline       TYPE mblpo,
          ls_imkpf            TYPE imkpf,
          lt_emseg            TYPE STANDARD TABLE OF emseg,
          lt_imseg            TYPE STANDARD TABLE OF imseg,
          ls_emkpf            TYPE emkpf,
          ls_e_lvs_tafkz,
          ls_es_mkpf          TYPE mkpf,

          lt_docnum           TYPE TABLE OF ty_docnum,
          lt_historico_msg    TYPE ty_t_historico.

    CONSTANTS: lc_sepr TYPE char1 VALUE '-'.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Aplica ordenação
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].
    SORT lt_historico_key BY main_purchase_order main_purchase_order_item guid.
    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING main_purchase_order main_purchase_order_item guid.

    SORT ct_historico BY guid main_purchase_order main_purchase_order_item.


    lt_docnum = VALUE #( FOR ls_hist IN lt_historico_key ( docnum = ls_hist-out_br_nota_fiscal ) ).

    SORT lt_docnum. DELETE ADJACENT DUPLICATES FROM lt_docnum.

    DELETE lt_docnum WHERE docnum IS INITIAL.

    IF lt_docnum IS NOT INITIAL.

      SELECT docnum,
             nfnum9,
             docnum9,
             serie
        FROM j_1bnfe_active
         FOR ALL ENTRIES IN @lt_docnum
       WHERE docnum =  @lt_docnum-docnum
        INTO TABLE @DATA(lt_j_1bnfe_active).

    ENDIF.

    DATA: lv_main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order.
* ---------------------------------------------------------------------------
* Prepara dados para criação da Saída de Mercadoria (Documento Material Saída)
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      CHECK ls_historico_key-status EQ gc_status-nota_input.
      CHECK ls_historico_key-carrier IS INITIAL.
      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.
      CHECK ls_historico_key-in_material_document IS INITIAL.
      CHECK ls_historico_key-out_delivery_document IS NOT INITIAL.

* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------

      FREE: lt_item,
            lt_serialnumber,
            lt_return,
            ls_headret,
            lv_materialdocument,
            lv_matdocumentyear,
            lt_imseg,
            lt_historico_msg.

      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.
      CLEAR lv_serialline.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------

        APPEND VALUE ty_historico( material = ls_historico->material
                                          plant    = ls_historico->plant
                                          storage_location = ls_historico->storage_location
                                          batch            = ls_historico->batch
                                          plant_dest       = ls_historico->plant_dest
                                          storage_location_dest = ls_historico->storage_location_dest
                                          guid             = ls_historico->guid ) TO lt_historico_msg.


        " Recupear material
        READ TABLE it_mara INTO DATA(ls_mara) WITH TABLE KEY matnr = ls_historico->material.

        IF sy-subrc NE 0.
          CLEAR ls_mara.
        ENDIF.

        " Recupera remessa
        READ TABLE it_lips INTO DATA(ls_lips) WITH TABLE KEY vbeln = ls_historico->out_delivery_document
                                                             posnr = ls_historico->out_delivery_document_item.
        IF sy-subrc NE 0.
          CLEAR ls_lips.
        ENDIF.

        " Recupera divisão da remessa
        READ TABLE it_eket INTO DATA(ls_eket) WITH TABLE KEY ebeln = ls_lips-vgbel
                                                             ebelp = ls_lips-vgpos.
        IF sy-subrc NE 0.
          CLEAR ls_eket.
        ENDIF.

        READ TABLE lt_j_1bnfe_active INTO DATA(ls_j_1bnfe_active) WITH KEY docnum = ls_historico->out_br_nota_fiscal.

*        ls_imkpf   = value #( BLDAT = sy-datum
*                              BUDAT = sy-datum
*                              XBLNR = CONV num9( ls_J_1BNFE_ACTIVE-nfnum9 )
*                              usnam = sy-uname
*                              PR_PRINT = '0'
*                              WEVER    = '1'
*                              WEVERX   = abap_true ).
*
*       lt_imseg = value #( base lt_imseg (
*       "LINE_ID = lines( lt_imseg ) + 1
*       "CALLED_BY = 'MIGO'
*        BWART     = '861'
*        MATNR     = ls_historico->material
*        WERKS     = ls_historico->plant
*        LGORT     = ls_historico->storage_location
*        CHARG     = ls_historico->batch
*        KZBEW     = 'B'
*        ERFMG     = ls_historico->order_quantity
*        ERFME     = ls_historico->order_quantity_unit
*        MENGE     = ls_historico->order_quantity
*        MEINS     = ls_historico->order_quantity_unit
*        EBELN     = ls_historico->purchase_order
*        EBELP     = ls_historico->purchase_order_item
*        elikz     = abap_true
*        vbeln     = ls_historico->OUT_DELIVERY_DOCUMENT
*        posnr     = ls_historico->out_delivery_document_item
*        lifnr     = ls_historico->ORIGIN_PLANT ) ).

        ls_header = VALUE #( pstng_date = sy-datum
                             doc_date   = sy-datum
                             ref_doc_no = |{ CONV num9( ls_j_1bnfe_active-nfnum9 ) }{ lc_sepr }{ ls_j_1bnfe_active-serie }|
                             header_txt = |{ CONV num9( ls_j_1bnfe_active-nfnum9 ) }{ lc_sepr }{ ls_j_1bnfe_active-serie }|
                             ).

        lv_code = '01'.

        lt_item = VALUE #( BASE lt_item ( material      = ls_historico->material
                                          plant         = ls_historico->destiny_plant
                                          stge_loc      = ls_historico->storage_location_dest
                                          batch         = ls_historico->batch
                                          move_type     = gc_bapi_entrada_merc-tipo_mov_z61
                                          val_type      = ls_lips-bwtar
                                          vendor        = |{ ls_historico->origin_plant ALPHA = IN }|
                                          entry_qnt     = ls_historico->order_quantity
                                          entry_uom     = ls_historico->order_quantity_unit
                                          entry_uom_iso = ls_historico->order_quantity_unit
                                          po_number     = ls_historico->purchase_order
                                          po_item       = ls_historico->purchase_order_item
                                          no_more_gr    = abap_true
                                          mvt_ind       = gc_bapi_entrada_merc-cod_mov_b
                                          deliv_numb    = ls_historico->out_delivery_document
                                          deliv_item    = ls_historico->out_delivery_document_item
                                          ) ).
        IF lines( lt_item ) > 1.
          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
            CLEAR <fs_item>-vendor.
          ENDLOOP.
        ENDIF.

        " Prepara dados de série - Processo manual
        " -------------------------------------------------------------------
        ADD 1 TO lv_serialline.

        IF ls_mara-mtart EQ gc_tipo_material-zcom.

          READ TABLE ct_serie TRANSPORTING NO FIELDS WITH KEY material         = ls_historico->material
                                                              plant            = ls_historico->plant
                                                              storage_location = ls_historico->storage_location
                                                              guid             = ls_historico->guid
                                                              BINARY SEARCH.
          IF sy-subrc EQ 0.

            LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) FROM sy-tabix.

              IF ls_serie->material         <> ls_historico->material
              OR ls_serie->plant            <> ls_historico->plant
              OR ls_serie->storage_location <> ls_historico->storage_location
              OR ls_serie->guid             <> ls_historico->guid.
                EXIT.
              ENDIF.

              lt_serialnumber[]   = VALUE #( BASE lt_serialnumber (
                                             matdoc_itm = lv_serialline
                                             serialno   = ls_serie->serialno ) ).
            ENDLOOP.
          ENDIF.

        ELSE.

*          " Prepara dados de série - Processo automático
*          " -----------------------------------------------------------------
*          LOOP AT it_equi REFERENCE INTO DATA(ls_equi) WHERE matnr = ls_historico->material
*                                                         AND werk  = ls_historico->destiny_plant
*                                                         AND lager = ls_historico->destiny_storage_location.
*
*            lt_serialnumber[]   = VALUE #( BASE lt_serialnumber (
*                                           matdoc_itm = lv_serialline
*                                           serialno   = ls_equi->sernr ) ).
*          ENDLOOP.

        ENDIF.

      ENDLOOP.

* ---------------------------------------------------------------------------
* Chama BAPI de criação de Entrada de Mercadoria (Documento de Material entrada)
* ---------------------------------------------------------------------------
      CLEAR lt_return.
      DATA lt_goodsmvt_item_cwm  TYPE STANDARD TABLE OF /cwm/bapi2017_gm_item_create.
      CLEAR lt_goodsmvt_item_cwm.
      CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
        EXPORTING
          goodsmvt_header       = ls_header
          goodsmvt_code         = lv_code
        IMPORTING
          goodsmvt_headret      = ls_headret
          materialdocument      = lv_materialdocument
          matdocumentyear       = lv_matdocumentyear
        TABLES
          goodsmvt_item         = lt_item
          goodsmvt_item_cwm     = lt_goodsmvt_item_cwm
          goodsmvt_serialnumber = lt_serialnumber
          return                = lt_return.

      IF line_exists( lt_return[ type = 'E' ] ).
        " Iniciando criação de Entrada de Mercadoria...
        ls_historico->status = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                       THEN gc_status-incompleto
                                       ELSE ls_historico->status ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '032' ) ).
        INSERT LINES OF lt_return INTO TABLE et_return[].
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        LOOP AT lt_historico_msg ASSIGNING FIELD-SYMBOL(<fs_hist_msg>).

          me->mapping_msg_table(
            EXPORTING
              is_historico = CORRESPONDING ty_historico( <fs_hist_msg> )
              it_return    = lt_return
            CHANGING
              ct_msg       = ct_msg ).

        ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
        READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                                BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.

        LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
          IF ls_historico_key-main_purchase_order IS NOT INITIAL.
            IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
              EXIT.
            ENDIF.
          ELSE.
            IF ls_historico->guid NE ls_historico_key-guid.
              EXIT.
            ENDIF.
          ENDIF.
* ---------------------------------------------------------------------------

          ls_historico->status                       = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                                               THEN gc_status-incompleto
                                                               ELSE gc_status-entrada_merc ).
        ENDLOOP.


      ELSE.
        DATA lv_indice TYPE i.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        ls_headret-mat_doc    = COND #( WHEN ls_headret-mat_doc IS NOT INITIAL
                                        THEN ls_headret-mat_doc
                                        ELSE lv_materialdocument ).

        ls_headret-doc_year   = COND #( WHEN ls_headret-doc_year IS NOT INITIAL
                                        THEN ls_headret-doc_year
                                        ELSE lv_matdocumentyear ).

        " Entrada de mercadoria &1 criada com sucesso.
        et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '033'
                                                message_v1 = |{ ls_headret-mat_doc ALPHA = OUT }| ) ).
* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
        READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                                BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.
        CLEAR lv_indice.
        LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
          ADD 1 TO lv_indice.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
          IF ls_historico_key-main_purchase_order IS NOT INITIAL.
            IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
              EXIT.
            ENDIF.
          ELSE.
            IF ls_historico->guid NE ls_historico_key-guid.
              EXIT.
            ENDIF.
          ENDIF.
* ---------------------------------------------------------------------------
          ls_historico->status                       = COND #( WHEN is_max_execution_status( ls_historico->guid ) = abap_true
                                                               THEN gc_status-incompleto
                                                               ELSE ls_historico->status ).
          ls_historico->in_material_document         = ls_headret-mat_doc.
          ls_historico->in_material_document_year    = ls_headret-doc_year.
*          ls_historico->in_material_document_item    = VALUE #( lt_goodsmvt_item_cwm[ lv_indice ]-matdoc_itm OPTIONAL ).
          ls_historico->in_material_document_item    = ls_historico->main_purchase_order_item(4).
        ENDLOOP.
      ENDIF.
    ENDLOOP.
*
** ---------------------------------------------------------------------------
** Atualiza dados de histórico
** ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_lips          = DATA(lt_lips)
                                 et_mseg          = DATA(lt_mseg)
                                 et_ekbe          = DATA(lt_ekbe) ).

    SORT ct_historico BY guid main_purchase_order main_purchase_order_item.
    CLEAR lv_main_purchase_order.

    LOOP AT lt_historico_key INTO ls_historico_key.

      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.
      CHECK ls_historico_key-in_material_document IS INITIAL.
      CHECK ls_historico_key-in_delivery_document IS NOT INITIAL.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------

* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        " Recupera remessa
        READ TABLE it_lips INTO ls_lips WITH TABLE KEY vbeln = ls_historico->in_delivery_document
                                                       posnr = ls_historico->in_delivery_document_item.
        IF sy-subrc NE 0.
          CLEAR ls_lips.
        ENDIF.

        " Recupera documento de material aquiaqui

        READ TABLE lt_ekbe INTO DATA(ls_ekbe) WITH KEY bwart = '861'
                                                       ebeln = ls_historico->purchase_order
                                                       ebelp = ls_historico->purchase_order_item BINARY SEARCH.

        IF sy-subrc EQ 0 AND ls_ekbe-belnr IS NOT INITIAL. " AND ls_historico->in_material_document IS INITIAL.

          ls_historico->in_material_document        = ls_ekbe-belnr.
          ls_historico->in_material_document_year   = ls_ekbe-gjahr.
          ls_historico->in_material_document_item   = ls_ekbe-buzei.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD create_in_nota_fiscal.

    DATA: lt_return     TYPE bapiret2_t,
          lt_partner    TYPE STANDARD TABLE OF bapi_j_1bnfnad,
          lt_item       TYPE STANDARD TABLE OF bapi_j_1bnflin,
          lt_item_tax   TYPE STANDARD TABLE OF bapi_j_1bnfstx,
          lt_header_msg TYPE STANDARD TABLE OF bapi_j_1bnfftx,

          ls_header     TYPE bapi_j_1bnfdoc,
          ls_header_add TYPE bapi_j_1bnfdoc_add,
          ls_nfcheck    TYPE bapi_j_1bnfcheck,
          ls_lin_key    TYPE ty_lin,

          lv_docnum     TYPE j_1bnfdoc-docnum,
          lv_itmnum     TYPE j_1bnflin-itmnum.


    FREE: et_return.

* ---------------------------------------------------------------------------
* Aplica ordenação
* ---------------------------------------------------------------------------
    me->sort( CHANGING ct_historico = ct_historico
                       ct_serie     = ct_serie ).

    " Monta tabela de chaves
    DATA(lt_historico_key) = ct_historico[].
    SORT lt_historico_key BY main_purchase_order main_purchase_order_item guid.
    DELETE ADJACENT DUPLICATES FROM lt_historico_key COMPARING main_purchase_order main_purchase_order_item guid.



    DATA(lt_lin1) = it_lin.

    SORT lt_lin1 BY docnum itmnum.
    SORT ct_historico BY guid.

** ---------------------------------------------------------------------------
** Prepara dados para criação da Saída de Mercadoria (Documento Material Saída)
** ---------------------------------------------------------------------------
*    LOOP AT lt_historico_key INTO DATA(ls_historico_key).
*
*      CHECK ls_historico_key-status = gc_status-incompleto.
*      CHECK ls_historico_key-carrier IS INITIAL.
*
*      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.
*      CHECK ls_historico_key-in_br_nota_fiscal IS INITIAL.
*      CHECK ls_historico_key-in_material_document IS NOT INITIAL.
*
*      FREE: lt_return,
*            lt_partner,
*            lt_item,
*            lt_item_tax,
*            lt_header_msg,
*            ls_header,
*            ls_header_add,
*            ls_nfcheck,
*            lv_docnum,
*            lv_itmnum.
*
*      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
*                                                              BINARY SEARCH.
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*
*      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.
*
*        IF ls_historico->guid NE ls_historico_key-guid.
*          EXIT.
*        ENDIF.
*
*        " Recupera Avaliação de material
*        READ TABLE it_mbew INTO DATA(ls_mbew) WITH TABLE KEY matnr = ls_historico->material
*                                                             bwkey = ls_historico->destiny_plant.
*        IF sy-subrc NE 0.
*          CLEAR ls_mbew.
*        ENDIF.
*
*        " Recupera Material
*        READ TABLE it_mara INTO DATA(ls_mara) WITH TABLE KEY matnr = ls_historico->material.
*
*        IF sy-subrc NE 0.
*          CLEAR ls_mara.
*        ENDIF.
*
*        " Recupear Centro de Material (2000)
*        READ TABLE it_marc INTO DATA(ls_marc) WITH TABLE KEY matnr = ls_historico->material
*                                                             werks = gc_centro_2000.
*        IF sy-subrc NE 0.
*          CLEAR ls_marc.
*        ENDIF.
*
*        " Recupera Empresa
*        READ TABLE it_t001k INTO DATA(ls_t001k) WITH TABLE KEY bwkey = ls_historico->destiny_plant.
*
*        IF sy-subrc NE 0.
*          CLEAR ls_t001k.
*        ENDIF.
*
*        " Recupera remessa de saída
*        READ TABLE it_lips INTO DATA(ls_lips_out) WITH TABLE KEY vbeln = ls_historico->out_delivery_document
*                                                                 posnr = ls_historico->out_delivery_document_item.
*        IF sy-subrc NE 0.
*          CLEAR ls_lips_out.
*        ENDIF.
*
*
*        " Recupera Nota Fiscal de saída
*        READ TABLE lt_lin1 INTO DATA(ls_lin_out) WITH KEY docnum = ls_historico->out_br_nota_fiscal
*                                                         itmnum = ls_historico->out_br_nota_fiscal_item BINARY SEARCH.
*        IF sy-subrc NE 0.
*          CLEAR ls_lin_out.
*        ENDIF.
*
*        ls_header       = VALUE #( nftype   = gc_bapi_nf_entrada-ctg_nf_ic
*                                   doctyp   = gc_bapi_nf_entrada-tp_doc_1
*                                   direct   = gc_bapi_nf_entrada-dir_mov_1
*                                   docdat   = ls_lin_out-docdat
*                                   pstdat   = sy-datum
*                                   model    = gc_bapi_nf_entrada-modelo_55
*                                   entrad   = abap_true
*                                   fatura   = abap_true
*                                   manual   = abap_true
*                                   waerk    = gc_bapi_nf_entrada-moeda_brl
*                                   bukrs    = ls_t001k-bukrs
*                                   branch   = ls_t001k-branch
*                                   parvw    = gc_bapi_nf_entrada-func_parceiro_br
*                                   parid    = |{ ls_t001k-bukrs }{ ls_t001k-branch }|
*                                   partyp   = gc_bapi_nf_entrada-tp_parc_b
*                                   inco1    = ls_historico->incoterms1
*                                   inco2    = ls_historico->incoterms2
*                                   nfe      = abap_true ).
*
*        ls_header_add  = VALUE #( nfdec     = 2 ).
*
*        ls_nfcheck     = VALUE #( chekcon   = abap_true ).
*
*        lt_partner     = VALUE #( BASE lt_partner (
*                                  parvw     = gc_bapi_nf_entrada-func_parceiro_br
*                                  parid     = |{ ls_t001k-bukrs }{ ls_t001k-branch }|
*                                  partyp    = gc_bapi_nf_entrada-tp_parc_b
*                                  xcpdk     = abap_true ) ).
*
*        ADD 10 TO lv_itmnum.
*
*        lt_item         = VALUE #( BASE lt_item (
*                                   itmnum       = lv_itmnum
*                                   matnr        = ls_historico->material
*                                   bwkey        = ls_historico->destiny_plant
*                                   matkl        = ls_mara-matkl
*                                   maktx        = ls_mara-maktx
*                                   cfop         = COND #( WHEN ls_lips_out-cfop = me->gs_parameter-cfop_rem_est
*                                                          THEN me->gs_parameter-cfop_ent_est+0(4)
*                                                          WHEN ls_lips_out-cfop = me->gs_parameter-cfop_rem_int
*                                                          THEN me->gs_parameter-cfop_ent_int+0(4)
*                                                          ELSE '' )
*                                   nbm          = ls_marc-steuc
*                                   matorg       = ls_mbew-mtorg
*                                   taxsit       = ls_lips_out-taxlw1
*                                   taxsi2       = ls_lips_out-taxlw2
*                                   matuse       = ls_mbew-mtuse
*                                   menge        = ls_historico->order_quantity
*                                   meins        = ls_historico->order_quantity_unit
*                                   netpr        = COND #( WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_s
*                                                          THEN ls_mbew-stprs
*                                                          WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_v
*                                                          THEN ls_mbew-verpr
*                                                          ELSE 0 )
*                                   netwr        = COND #( WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_s
*                                                          THEN ls_mbew-stprs
*                                                          WHEN ls_mbew-vprsv = gc_bapi_pedido-controle_preco_v
*                                                          THEN ls_mbew-verpr
*                                                          ELSE 0 )
*                                   taxlw1       = ls_lips_out-taxlw1
*                                   taxlw2       = ls_lips_out-taxlw2
*                                   itmtyp       = gc_bapi_nf_entrada-tp_item_01
*                                   werks        = ls_historico->destiny_plant
*                                   cfop_10      = COND #( WHEN ls_lips_out-cfop = me->gs_parameter-cfop_rem_est
*                                                          THEN me->gs_parameter-cfop_ent_est+0(4)
*                                                          WHEN ls_lips_out-cfop = me->gs_parameter-cfop_rem_int
*                                                          THEN me->gs_parameter-cfop_ent_int+0(4)
*                                                          ELSE '' )
*                                   taxlw4       = ls_lips_out-taxlw4
*                                   taxsi4       = ls_lips_out-taxsi4
*                                   taxlw5       = ls_lips_out-taxlw5
*                                   taxsi5       = ls_lips_out-taxsi5
*                                   meins_trib   = ls_lips_out-meins ) ).
*
*        lt_item_tax     = VALUE #( BASE lt_item_tax (
*                                   itmnum       = lv_itmnum
*                                   taxtyp       = gc_bapi_nf_entrada-tp_imposto_icm0
*                                   othbas       = ls_lin_out-nfnett ) ).
*
*        lt_item_tax     = VALUE #( BASE lt_item_tax (
*                                   itmnum       = lv_itmnum
*                                   taxtyp       = gc_bapi_nf_entrada-tp_imposto_ipi0
*                                   excbas       = ls_lin_out-nfnett ) ).
*
*        lt_header_msg   = VALUE #( ( seqnum     = 01
*                                     linnum     = 01 ) ).
*
*      ENDLOOP.
*
** ---------------------------------------------------------------------------
** Chama BAPI de criação de Nota Fiscal de Entrada
** ---------------------------------------------------------------------------
*      CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
*        EXPORTING
*          obj_header     = ls_header
*          obj_header_add = ls_header_add
*          nfcheck        = ls_nfcheck
*        IMPORTING
*          e_docnum       = lv_docnum
*        TABLES
*          obj_partner    = lt_partner
*          obj_item       = lt_item
*          obj_item_tax   = lt_item_tax
*          obj_header_msg = lt_header_msg
*          return         = lt_return.
*
*      IF line_exists( lt_return[ type = 'E' ] ).
*        " Iniciando criação da Nota Fiscal de Entrada...
*        et_return[] = VALUE #( BASE et_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '034' ) ).
*        INSERT LINES OF lt_return INTO TABLE et_return[].
*        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
*        CONTINUE.
*      ENDIF.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = abap_true.
*
*      " Nota Fiscal de Entrada &1 criada com sucesso.
*      et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '035'
*                                              message_v1 = |{ lv_docnum ALPHA = OUT }| ) ).

** ---------------------------------------------------------------------------
** Atualiza dados de histórico
** ---------------------------------------------------------------------------
*      FREE: lv_itmnum.
*
*
*      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
*                                                              BINARY SEARCH.
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*
*      LOOP AT ct_historico REFERENCE INTO ls_historico FROM sy-tabix.
*
*        IF ls_historico->guid NE ls_historico_key-guid.
*          EXIT.
*        ENDIF.
*
*        ADD 10 TO lv_itmnum.
*        ls_historico->status                       = gc_status-completo.
*        ls_historico->in_br_nota_fiscal            = lv_docnum.
*        ls_historico->in_br_nota_fiscal_item       = lv_itmnum.     " Temporário
*      ENDLOOP.
*
*    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza dados de histórico
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = ct_historico
                       IMPORTING et_lin           = DATA(lt_lin) ).

    SORT ct_historico BY guid main_purchase_order main_purchase_order_item.
    SORT lt_lin BY refkey refitm.
    DATA: lv_main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order.
    LOOP AT lt_historico_key INTO DATA(ls_historico_key).

      CHECK ls_historico_key-out_br_nota_fiscal IS NOT INITIAL.
      CHECK ls_historico_key-in_br_nota_fiscal IS INITIAL.
      CHECK ls_historico_key-in_material_document IS NOT INITIAL.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
      IF ls_historico_key-main_purchase_order IS NOT INITIAL.
        IF lv_main_purchase_order = ls_historico_key-main_purchase_order.
          CONTINUE.
        ENDIF.
        lv_main_purchase_order = ls_historico_key-main_purchase_order.
      ELSE.
        CLEAR lv_main_purchase_order.
      ENDIF.
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* Atualiza dados de histórico novamente
* ---------------------------------------------------------------------------
      READ TABLE ct_historico TRANSPORTING NO FIELDS WITH KEY guid = ls_historico_key-guid
                                                              BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      LOOP AT ct_historico REFERENCE INTO DATA(ls_historico) FROM sy-tabix.
* ---------------------------------------------------------------------------
* verifica se item de pedido principal
* ---------------------------------------------------------------------------
        IF ls_historico_key-main_purchase_order IS NOT INITIAL.
          IF ls_historico->guid NE ls_historico_key-guid AND ls_historico->main_purchase_order <> ls_historico_key-main_purchase_order.
            EXIT.
          ENDIF.
        ELSE.
          IF ls_historico->guid NE ls_historico_key-guid.
            EXIT.
          ENDIF.
        ENDIF.
* ---------------------------------------------------------------------------
        ls_lin_key-refkey   = |{ ls_historico->in_material_document }{ ls_historico->in_material_document_year }|.
        ls_lin_key-refitm   = ls_historico->in_material_document_item.

        READ TABLE lt_lin INTO DATA(ls_lin_in) WITH KEY
        refkey = ls_lin_key-refkey refitm = ls_lin_key-refitm BINARY SEARCH.

        IF sy-subrc EQ 0.
          ls_historico->in_br_nota_fiscal        = ls_lin_in-docnum.
          ls_historico->in_br_nota_fiscal_item   = ls_lin_in-itmnum.
          ls_historico->status                   = gc_status-completo.
        ENDIF.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_main_info.

    DATA: lt_configuracao_key TYPE STANDARD TABLE OF ztmm_prm_dep_fec,
          lt_historico_key    TYPE ty_t_historico,
          lt_wmdvsx           TYPE STANDARD TABLE OF bapiwmdvs,
          lt_wmdvex           TYPE STANDARD TABLE OF bapiwmdve,
          ls_return           TYPE bapireturn,
          lv_menge            TYPE bstmg.

    FREE: et_historico, et_return.

* ---------------------------------------------------------------------------
* Verifica e recupera dados de histórico para este pedido principal
* ---------------------------------------------------------------------------
    SELECT material,
           plant,
           batch,
           plant_dest,
           storage_location_dest,
           freight_order_id,
           delivery_document,
           process_step,
           guid,
           used_stock_conv
        FROM ztmm_his_dep_fec
        INTO CORRESPONDING FIELDS OF TABLE @et_historico
        WHERE main_purchase_order       EQ @iv_invnumber
          AND main_purchase_order_item  EQ @iv_year
          AND process_step              EQ @gc_etapa-enh.


    IF sy-subrc EQ 0.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados para montagem das novas chaves
* ---------------------------------------------------------------------------
    lt_historico_key = VALUE #( ( main_purchase_order      = iv_invnumber
                                  main_purchase_order_item = iv_year ) ) .

    me->get_bapi_info( EXPORTING it_historico_key = lt_historico_key
                       IMPORTING et_eket          = DATA(lt_eket)
                                 et_mseg          = DATA(lt_mseg) ).

* ---------------------------------------------------------------------------
* Recupera configuração de depósito fechado.
* ---------------------------------------------------------------------------
* Somente proseguir quando encontrado configuração
* ---------------------------------------------------------------------------
    lt_configuracao_key = VALUE #( FOR ls_eket_key IN lt_eket (
                                   origin_plant  = ls_eket_key-lifnr+6(4)
                                   destiny_plant = ls_eket_key-werks ) ).

    IF lt_configuracao_key[] IS NOT INITIAL.

      SELECT *
          FROM ztmm_prm_dep_fec
          INTO TABLE @DATA(lt_configuracao)
          FOR ALL ENTRIES IN @lt_configuracao_key
          WHERE origin_plant  = @lt_configuracao_key-origin_plant
            AND destiny_plant = @lt_configuracao_key-destiny_plant.

      IF sy-subrc EQ 0.
        SORT lt_configuracao BY origin_plant destiny_plant.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Monta novas chaves de histórico
* ---------------------------------------------------------------------------
    GET TIME STAMP FIELD DATA(lv_timestamp).

    LOOP AT lt_eket REFERENCE INTO DATA(ls_eket).

      READ TABLE lt_configuracao INTO DATA(ls_configuracao) WITH KEY origin_plant  = ls_eket->lifnr+6(4)
                                                                     destiny_plant = ls_eket->werks
                                                                     BINARY SEARCH.
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      READ TABLE lt_mseg INTO DATA(ls_mseg) WITH KEY pedido COMPONENTS ebeln = ls_eket->ebeln
                                                                       ebelp = ls_eket->ebelp.
      IF sy-subrc NE 0.
        CLEAR ls_mseg.
      ENDIF.

      FREE: ls_return, lt_wmdvex.

* --------------------------------------------------------------------
* Recupera disponibilidade de estoque do material
* --------------------------------------------------------------------
      TRY.
          CALL FUNCTION 'BAPI_MATERIAL_AVAILABILITY'
            EXPORTING
              plant    = ls_configuracao-origin_plant
              material = CONV matnr18( ls_eket->matnr )
              stge_loc = ls_configuracao-origin_storage_location
              unit     = ls_eket->meins
            IMPORTING
              return   = ls_return
            TABLES
              wmdvsx   = lt_wmdvsx
              wmdvex   = lt_wmdvex.

          DATA(ls_wmdvex) = lt_wmdvex[ 1 ].
        CATCH cx_root.
          CLEAR ls_wmdvex.
      ENDTRY.

* --------------------------------------------------------------------
* Prepara dados de histórico
* --------------------------------------------------------------------
      et_historico = VALUE #( BASE et_historico (
                              material                      = ls_eket->matnr
                              plant                         = ls_eket->lifnr+6(4)
                              storage_location              = ls_configuracao-origin_storage_location
*                              freight_order_id             = space
*                              delivery_document            = space
                              process_step                  = gc_etapa-enh
*                              guid                         = space
                              status                        = gc_status-inicial
                              prm_dep_fec_id                = ls_configuracao-guid
                              description                   = ls_configuracao-description
                              origin_plant                  = ls_configuracao-origin_plant
                              origin_plant_type             = ls_configuracao-origin_plant_type
                              origin_storage_location       = ls_configuracao-origin_storage_location
                              destiny_plant                 = ls_configuracao-destiny_plant
                              destiny_plant_type            = ls_configuracao-destiny_plant_type
                              destiny_storage_location      = ls_configuracao-destiny_storage_location
                              origin_unit                   = ls_eket->meins
                              unit                          = ls_eket->meins
                              use_available                 = abap_false
                              available_stock               = ls_wmdvex-com_qty
                              used_stock                    = ls_eket->menge
                              main_plant                    = ls_eket->werks
                              main_purchase_order           = ls_eket->ebeln
                              main_purchase_order_item      = ls_eket->ebelp
                              main_material_document        = ls_mseg-mblnr
                              main_material_document_year   = ls_mseg-mjahr
                              main_material_document_item   = ls_mseg-zeile
                              order_quantity                = ls_eket->menge
                              order_quantity_unit           = ls_eket->meins
*                              batch                         = ls_eket->charg
                              created_by                    = sy-uname
                              created_at                    = lv_timestamp
                              local_last_changed_at         = lv_timestamp ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD check_permission.

    FREE: et_return, ev_ok.

* ---------------------------------------------------------------------------
* Botões mapeados no objeto de autorização
* ---------------------------------------------------------------------------
* 16 - Botão Criar NFe
* ---------------------------------------------------------------------------
*    AUTHORITY-CHECK OBJECT 'ZMM376F02'
*     ID 'ACTVT' FIELD iv_actvt.
*
*    IF sy-subrc NE 0.
*      " Sem autorização para acessar esta funcionalidade.
*      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '036' ) ).
*    ELSE.
    rv_ok = ev_ok = abap_true.
*    ENDIF.

    me->format_return( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD sort.

    SORT ct_historico BY guid material plant storage_location freight_order_id delivery_document process_step main_purchase_order.
    SORT ct_serie BY material plant storage_location freight_order_id delivery_document process_step guid serialno.

  ENDMETHOD.


  METHOD job_entrada_mercadoria.

    DATA lt_historico_key TYPE ty_t_historico.
    DATA: lt_msg_log TYPE zctgmm_his_dep_msg.

    get_bapi_info(
      EXPORTING
        it_historico_key = lt_historico_key
        iv_status        = gc_status-entrada_merc
      IMPORTING
        et_historico     = DATA(lt_historico) ).


    update_history_documents(
      CHANGING
        ct_historico = lt_historico ).

    me->call_save_background( EXPORTING it_historico = lt_historico ).

    get_bapi_info(
      EXPORTING
        it_historico_key = lt_historico_key
        iv_status        = gc_status-entrada_merc
      IMPORTING
        et_historico     = lt_historico
        et_lin           = DATA(lt_lin)
        et_return        = DATA(lt_return)
        et_serie         = DATA(lt_serie) ).

    INSERT LINES OF lt_return[] INTO TABLE et_return.

    me->validate_out_nota_fiscal( EXPORTING it_lin       = lt_lin
                                  IMPORTING et_return    = lt_return
                                  CHANGING  ct_historico = lt_historico
                                            ct_serie     = lt_serie
                                            ct_msg       = lt_msg_log ).

    INSERT LINES OF lt_return[] INTO TABLE et_return.


    me->call_save_background( EXPORTING it_historico = lt_historico
                                        it_serie     = lt_serie
                                        it_msg       = lt_msg_log
                              IMPORTING et_return    = lt_return ).


* ---------------------------------------------------------------------------
* Cria entrada de mercadoria ( Documento de material )
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = lt_historico
                                 iv_status        = gc_status-nota_input
                       IMPORTING et_mara          = DATA(lt_mara)
                                 et_equi          = DATA(lt_equi)
                                 et_lips          = DATA(lt_lips)
                                 et_eket          = DATA(lt_eket)
                                    et_historico     = lt_historico
                                    et_lin           = lt_lin
                                    et_return        = lt_return
                                    et_serie         = lt_serie ).

    me->create_in_material_document( EXPORTING it_mara      = lt_mara
                                               it_equi      = lt_equi
                                               it_lips      = lt_lips
                                               it_eket      = lt_eket
                                     IMPORTING et_return    = lt_return
                                     CHANGING  ct_historico = lt_historico
                                               ct_serie     = lt_serie
                                               ct_msg       = lt_msg_log ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Cria entrada de Nota Fiscal
* ---------------------------------------------------------------------------
    me->get_bapi_info( EXPORTING it_historico_key = lt_historico
                       IMPORTING et_mbew          = DATA(lt_mbew)
                                 et_mara          = lt_mara
                                 et_marc          = DATA(lt_marc)
                                 et_t001k         = DATA(lt_t001k)
                                 et_lips          = lt_lips
                                 et_lin           = lt_lin ).

    me->create_in_nota_fiscal( EXPORTING it_mbew      = lt_mbew
                                         it_mara      = lt_mara
                                         it_marc      = lt_marc
                                         it_t001k     = lt_t001k
                                         it_lips      = lt_lips
                                         it_lin       = lt_lin
                               IMPORTING et_return    = lt_return
                               CHANGING  ct_historico = lt_historico
                                         ct_serie     = lt_serie
                                         ct_msg       = lt_msg_log ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Salva dados
* ---------------------------------------------------------------------------
    me->call_save_background( EXPORTING it_historico = lt_historico
                                        it_serie     = lt_serie
                                        it_msg       = lt_msg_log
                              IMPORTING et_return    = lt_return ).

    me->update_in_billing( ).

  ENDMETHOD.


  METHOD delivery_update.

    DATA: ls_vbkok          TYPE vbkok,
          lt_vbpok          TYPE STANDARD TABLE OF vbpok,
          lt_sernr          TYPE STANDARD TABLE OF vlser,
          lt_prot           TYPE STANDARD TABLE OF prott,
          lt_return         TYPE bapiret2_t,
          ls_header_data    TYPE bapiobdlvhdrchg,
          ls_header_control TYPE bapiobdlvhdrctrlchg,
          ls_techn_control  TYPE bapidlvcontrol,
          lt_item_data      TYPE STANDARD TABLE OF bapiobdlvitemchg,
          lt_item_control   TYPE STANDARD TABLE OF bapiobdlvitemctrlchg,
          lt_item_data_spl  TYPE STANDARD TABLE OF /spe/bapiobdlvitemchg,
          lv_vbeln          TYPE lips-vbeln,
          lt_partner_update TYPE shp_partner_update_t,
          lt_header_partner TYPE /spe/bapidlvpartnerchg_t.


    ls_vbkok          = is_vbkok.
    lt_vbpok          = it_vbpok.
    lt_sernr          = it_sernr.
    lt_item_control   = it_item_control.
    lt_item_data      = it_item_data.
    lt_item_data_spl  = it_item_data_spl.
    lt_partner_update = it_partner_update.
    lt_header_partner = it_header_partner.

    IF NOT line_exists( lt_partner_update[ parvw = 'SP' ] ).
      CLEAR ls_header_data-dlv_block.
      ls_header_control-dlv_block_flg = abap_true.
    ENDIF.

    ls_header_data-deliv_numb    = iv_delivery.
    ls_header_control-deliv_numb = iv_delivery.
    ls_techn_control-upd_ind     = 'U'.

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = iv_delivery
        techn_control  = ls_techn_control
      TABLES
        item_data      = lt_item_data
        item_control   = lt_item_control
        return         = lt_return
        item_data_spl  = lt_item_data_spl
        header_partner = lt_header_partner.


    IF line_exists( lt_return[ type = 'E' ] ).
      " Iniciando criação da Saída de Mercadoria...
      ct_return = VALUE #( BASE ct_return ( type   = 'I'
                                            id     = 'ZMM_DEPOSITO_FECHADO'
                                            number = '028' ) ).
      APPEND LINES OF lt_return TO ct_return.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ev_error = abap_true.
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


    REFRESH lt_return.
    ls_header_data-deliv_numb    = iv_delivery.
    ls_header_control-deliv_numb = iv_delivery.
    ls_techn_control-upd_ind     = 'U'.
    lt_header_partner            = it_header_partner.

    IF NOT line_exists( lt_partner_update[ parvw = 'SP' ] ).
      CLEAR ls_header_data-dlv_block.
      ls_header_control-dlv_block_flg = abap_true.
    ENDIF.

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = iv_delivery
        techn_control  = ls_techn_control
      TABLES
        item_data      = lt_item_data
        item_control   = lt_item_control
        return         = lt_return
        item_data_spl  = lt_item_data_spl
        header_partner = lt_header_partner.


    IF line_exists( lt_return[ type = 'E' ] ).
      " Iniciando criação da Saída de Mercadoria...
      ct_return[] = VALUE #( BASE ct_return ( type   = 'I'
                                              id     = 'ZMM_DEPOSITO_FECHADO'
                                              number = '028' ) ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      APPEND LINES OF lt_return TO ct_return.
      ev_error = abap_true.
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.


    CLEAR gt_prot.
* ---------------------------------------------------------------------------
* Chama BAPI de criação da Saída de Mercadoria (Documento Material Saída)
* ---------------------------------------------------------------------------
    TRY.

        gv_wait_async_ws  = abap_false.

        DATA(lv_task) = |WS_DELIVERY_{ sy-uzeit }|.
        DATA lv_update_picking TYPE abap_bool.

        IF line_exists( lt_partner_update[ parvw = 'SP' ] ).
          lv_update_picking = abap_false.

          CALL FUNCTION 'WS_DELIVERY_UPDATE' "#EC CI_SUBRC
*             STARTING NEW TASK lv_task
*             CALLING setup_messages ON END OF TASK
            EXPORTING
              vbkok_wa                    = ls_vbkok
              synchron                    = abap_true
              delivery                    = iv_delivery
              update_picking              = lv_update_picking
*             nicht_sperren               = abap_true
              commit                      = abap_true
              if_error_messages_send_0    = abap_true
*             no_messages_update          = abap_true
              it_partner_update           = lt_partner_update
            IMPORTING
              ef_error_any_0              = gv_error_any_0
              ef_error_in_item_deletion_0 = gv_error_in_item_deletion_0
              ef_error_in_pod_update_0    = gv_error_in_pod_update_0
              ef_error_in_interface_0     = gv_error_in_interface_0
              ef_error_in_goods_issue_0   = gv_error_in_goods_issue_0
              ef_error_in_final_check_0   = gv_error_in_final_check_0
              ef_error_partner_update     = gv_error_partner_update
              ef_error_sernr_update       = gv_error_sernr_update
            TABLES
              prot                        = gt_prot
            EXCEPTIONS
              error_message               = 4. "#EC CI_SUBRC ##FM_SUBRC_OK

          IF sy-subrc <> 0.
            ct_return[] = VALUE #( BASE ct_return ( parameter  = gc_cds-emissao
                                                    type       = sy-msgty
                                                    id         = sy-msgid
                                                    number     = sy-msgno
                                                    message_v1 = sy-msgv1
                                                    message_v2 = sy-msgv2
                                                    message_v3 = sy-msgv3
                                                    message_v4 = sy-msgv4 ) ).
          ENDIF.

          RETURN.

        ELSE.
          lv_update_picking = abap_true.
          ls_vbkok-lifsk    = space.

          CALL FUNCTION 'WS_DELIVERY_UPDATE' "#EC CI_SUBRC
            EXPORTING
              vbkok_wa                    = ls_vbkok
              synchron                    = abap_true
              delivery                    = iv_delivery
              update_picking              = lv_update_picking
*             nicht_sperren               = abap_true
              commit                      = abap_true
              if_error_messages_send_0    = abap_true
*             no_messages_update          = abap_true
              it_partner_update           = lt_partner_update
            IMPORTING
              ef_error_any_0              = gv_error_any_0
              ef_error_in_item_deletion_0 = gv_error_in_item_deletion_0
              ef_error_in_pod_update_0    = gv_error_in_pod_update_0
              ef_error_in_interface_0     = gv_error_in_interface_0
              ef_error_in_goods_issue_0   = gv_error_in_goods_issue_0
              ef_error_in_final_check_0   = gv_error_in_final_check_0
              ef_error_partner_update     = gv_error_partner_update
              ef_error_sernr_update       = gv_error_sernr_update
            TABLES
              prot                        = gt_prot
              vbpok_tab                   = lt_vbpok
            EXCEPTIONS
              error_message               = 4. "#EC CI_SUBRC ##FM_SUBRC_OK

          IF sy-subrc <> 0.
            ct_return[] = VALUE #( BASE ct_return ( parameter  = gc_cds-emissao
                                                    type       = sy-msgty
                                                    id         = sy-msgid
                                                    number     = sy-msgno
                                                    message_v1 = sy-msgv1
                                                    message_v2 = sy-msgv2
                                                    message_v3 = sy-msgv3
                                                    message_v4 = sy-msgv4 ) ).
          ENDIF.
        ENDIF.

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV char200( lo_root->get_longtext( ) ).
        ct_return[] = VALUE #( BASE ct_return ( parameter  = gc_cds-emissao
                                                type       = 'E'
                                                id         = 'ZMM_DEPOSITO_FECHADO'
                                                number     = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).
    ENDTRY.

    IF gv_error_any_0              IS NOT INITIAL
    OR gv_error_in_item_deletion_0 IS NOT INITIAL
    OR gv_error_in_pod_update_0    IS NOT INITIAL
    OR gv_error_in_interface_0     IS NOT INITIAL
    OR gv_error_in_goods_issue_0   IS NOT INITIAL
    OR gv_error_in_final_check_0   IS NOT INITIAL
    OR gv_error_partner_update     IS NOT INITIAL
    OR gv_error_sernr_update       IS NOT INITIAL.

      IF sy-msgid IS NOT INITIAL
     AND sy-msgno IS NOT INITIAL
     AND sy-msgty IS NOT INITIAL.

        ct_return[] = VALUE #( BASE ct_return ( parameter  = gc_cds-emissao
                                                type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
      ELSE.
        " Falha ao gerar saída de mercadoria.
        ct_return[] = VALUE #( BASE ct_return ( parameter = gc_cds-emissao
                                                type      = 'E'
                                                id        = 'ZMM_DEPOSITO_FECHADO'
                                                number    = '010' ) ).
      ENDIF.
    ENDIF.

    IF line_exists( gt_prot[ msgty = 'E' ] ).
      " Iniciando criação da Saída de Mercadoria...
      ct_return = VALUE #( BASE ct_return ( type = 'I' id = 'ZMM_DEPOSITO_FECHADO' number = '028' ) ).
      ct_return = VALUE #( BASE ct_return FOR ls_prot IN gt_prot ( type       = ls_prot-msgty
                                                                   message_v1 = ls_prot-msgv1
                                                                   message_v2 = ls_prot-msgv2
                                                                   message_v3 = ls_prot-msgv3
                                                                   message_v4 = ls_prot-msgv4
                                                                   id         = ls_prot-msgid
                                                                   number     = ls_prot-msgno ) ).

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ev_error = abap_true.
      RETURN.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    " Saída de Mercadoria criada com sucesso.
    ct_return[] = VALUE #( BASE ct_return ( type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '029' ) ).
  ENDMETHOD.


  METHOD inb_delivery_create.

    DATA: lt_bapireturn TYPE STANDARD TABLE OF bapireturn.

* ---------------------------------------------------------------------------
* Chama BAPI de criação do Aviso de Recebimento (Remessa entrada)
* ---------------------------------------------------------------------------
    gv_wait_async = abap_false.

    CALL FUNCTION 'BBP_INB_DELIVERY_CREATE'
      STARTING NEW TASK 'BBP_INB_DELIVERY_CREATE'
      CALLING setup_messages ON END OF TASK
      EXPORTING
        is_inb_delivery_header = is_header
      TABLES
        it_inb_delivery_detail = it_detail
        return                 = lt_bapireturn.

    WAIT UNTIL gv_wait_async = abap_true.
    lt_bapireturn = gt_bapireturn.
    ev_vbeln      = gv_in_delivery_document.

    IF line_exists( lt_bapireturn[ type = 'E' ] ).
      " Iniciando criação do Aviso de Recebimento...
      ct_bapireturn[] = VALUE #( BASE ct_bapireturn ( type = 'I'  id = 'ZMM_DEPOSITO_FECHADO' number = '030' ) ).
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ev_error = abap_true.
      EXIT.
    ENDIF.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    " Aviso de recebimento &1 criado com sucesso.
    ct_bapireturn[] = VALUE #( BASE ct_bapireturn ( type = 'S' id = 'ZMM_DEPOSITO_FECHADO' number = '031'
                                                    message_v1 = |{ ev_vbeln ALPHA = OUT }| ) ).


    ct_bapireturn = VALUE #( BASE ct_bapireturn FOR ls_bapireturn IN lt_bapireturn (
                         id         = substring_msgid( ls_bapireturn-code )
                         type       = ls_bapireturn-type
                         number     = substring_msgno( ls_bapireturn-code )
                         message_v1 = ls_bapireturn-message_v1
                         message_v2 = ls_bapireturn-message_v2
                         message_v3 = ls_bapireturn-message_v3
                         message_v4 = ls_bapireturn-message_v4 ) ).

  ENDMETHOD.


  METHOD substring_msgid.

    DATA(lv_string) = strlen( iv_value ).
    lv_string = lv_string - 3.

    rv_msgid = iv_value(lv_string).

  ENDMETHOD.


  METHOD substring_msgno.

    DATA(lv_string) = strlen( iv_value ).
    lv_string = lv_string - 3.

    rv_msgno = iv_value+lv_string.
  ENDMETHOD.


  METHOD update_in_billing.

    TYPES: BEGIN OF ty_docnum,
             docnum TYPE j_1bdocnum,
           END OF ty_docnum,
           ty_t_docnum TYPE TABLE OF ty_docnum WITH EMPTY KEY,
           BEGIN OF ty_nfeid,
             nfeid TYPE /xnfe/id,
           END OF ty_nfeid,
           ty_t_nfeid TYPE TABLE OF ty_nfeid WITH EMPTY KEY,
           BEGIN OF ty_guid_header,
             guid_header TYPE /xnfe/guid_16,
           END OF ty_guid_header,
           ty_t_guid_header TYPE TABLE OF ty_guid_header WITH EMPTY KEY,
           BEGIN OF ty_ponumber,
             ponumber TYPE /xnfe/ponum,
             poitem   TYPE /xnfe/poitem,
             matnr    TYPE matnr,
           END OF ty_ponumber,
           ty_t_ponumber TYPE TABLE OF ty_ponumber WITH EMPTY KEY,
           BEGIN OF ty_refkey,
             refkey TYPE j_1brefkey,
           END OF ty_refkey,
           ty_t_refkey TYPE TABLE OF ty_refkey WITH EMPTY KEY.

    WAIT UP TO 2 SECONDS.

    SELECT *
      FROM ztmm_his_dep_fec
     WHERE ( status = @gc_status-nota_input AND carrier IS INITIAL )
        OR   status = @gc_status-em_transito
      INTO TABLE @DATA(lt_his_dep_fec).

    DATA(lt_docnum_list) = VALUE ty_t_docnum( FOR ls_hip_dep_fec IN lt_his_dep_fec ( docnum = ls_hip_dep_fec-out_br_nota_fiscal ) ).

    SORT lt_docnum_list BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_docnum_list COMPARING table_line.

    CHECK lt_docnum_list IS NOT INITIAL.

    SELECT docnum, regio, nfyear, nfmonth, stcd1, model, serie, nfnum9, docnum9, cdv
      FROM j_1bnfe_active
       FOR ALL ENTRIES IN @lt_docnum_list
       WHERE docnum = @lt_docnum_list-docnum
       INTO TABLE @DATA(lt_j_1bnfe_active).

    DATA(lt_nfeid_list) = VALUE ty_t_nfeid( FOR ls_j_1bnfe_active IN lt_j_1bnfe_active ( nfeid = |{ ls_j_1bnfe_active-regio }{ ls_j_1bnfe_active-nfyear }| &&
                                                                                                 |{ ls_j_1bnfe_active-nfmonth }{ ls_j_1bnfe_active-stcd1 }{  ls_j_1bnfe_active-model }| &&
                                                                                                 |{ ls_j_1bnfe_active-serie }{  ls_j_1bnfe_active-nfnum9 }{  ls_j_1bnfe_active-docnum9 }| &&
                                                                                                 |{  ls_j_1bnfe_active-cdv }| ) ).

    SORT lt_nfeid_list BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_nfeid_list COMPARING table_line.

    CHECK lt_nfeid_list IS NOT INITIAL.

    SELECT nfeid, guid_header
      FROM /xnfe/innfehd
      FOR ALL ENTRIES IN @lt_nfeid_list
      WHERE nfeid = @lt_nfeid_list-nfeid
      INTO TABLE @DATA(lt_innfehd).


    DATA(lt_guid_header) = VALUE ty_t_guid_header( FOR ls_innfehd IN lt_innfehd ( guid_header = ls_innfehd-guid_header )  ).
    SORT lt_guid_header BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_guid_header COMPARING table_line.

    CHECK  lt_guid_header IS NOT INITIAL.

    SELECT guid_header,
           ponumber,
           poitem,
           cprod
      FROM /xnfe/innfeit
       FOR ALL ENTRIES IN @lt_guid_header
     WHERE guid_header = @lt_guid_header-guid_header
      INTO TABLE @DATA(lt_innfeit).

    DATA(lt_ponumber) = VALUE ty_t_ponumber( FOR ls_innfeit IN lt_innfeit ( ponumber = ls_innfeit-ponumber
                                                                            poitem   = ls_innfeit-poitem * 10
                                                                            matnr    = ls_innfeit-cprod ) ).

    DATA(lt_ponumber_aux) = VALUE ty_t_ponumber( FOR ls_innfeit IN lt_innfeit ( ponumber = ls_innfeit-ponumber
                                                                               poitem    = ls_innfeit-poitem
                                                                               matnr     = ls_innfeit-cprod ) ).

    APPEND LINES OF lt_ponumber_aux TO lt_ponumber.
    FREE: lt_ponumber_aux[].

    SORT lt_ponumber BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_ponumber COMPARING table_line.

    SELECT ebeln,
           ebelp,
           bwart,
           belnr,
           gjahr,
           matnr,
           buzei
      FROM ekbe
       FOR ALL ENTRIES IN @lt_ponumber
     WHERE ebeln = @lt_ponumber-ponumber
       AND ebelp = @lt_ponumber-poitem
       AND matnr = @lt_ponumber-matnr
       AND ( bwart = '861' OR bwart = 'Z61' )
      INTO TABLE @DATA(lt_ekbe).

    IF sy-subrc IS INITIAL.
      SORT lt_ekbe BY ebeln
                      ebelp
                      matnr.
    ENDIF.

    DATA(lt_refkey) = VALUE ty_t_refkey( FOR ls_ekbe IN lt_ekbe ( refkey = |{ ls_ekbe-belnr }{ ls_ekbe-gjahr }| ) ).

    SORT lt_refkey BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_refkey COMPARING table_line.
    CHECK lt_refkey IS NOT INITIAL.

    SELECT refkey,refitm, docnum, itmnum
      FROM j_1bnflin
      FOR ALL ENTRIES IN @lt_refkey
      WHERE refkey = @lt_refkey-refkey
      INTO TABLE @DATA(lt_j_1bnflin).

    SORT lt_j_1bnflin BY refkey refitm.

    SORT lt_innfehd BY nfeid.
    SORT lt_innfeit BY guid_header poitem.

    DATA lv_poitem TYPE /XNFE/POITEM.

    LOOP AT lt_his_dep_fec REFERENCE INTO DATA(ls_his_dep_fec).
      READ TABLE lt_j_1bnfe_active REFERENCE INTO DATA(ls_j_1bnfe_act) WITH KEY docnum = ls_his_dep_fec->out_br_nota_fiscal BINARY SEARCH.

      CHECK sy-subrc = 0.

      DATA(lv_nfeid) = |{ ls_j_1bnfe_act->regio   }{ ls_j_1bnfe_act->nfyear }| &&
                       |{ ls_j_1bnfe_act->nfmonth }{ ls_j_1bnfe_act->stcd1  }{ ls_j_1bnfe_act->model }| &&
                       |{ ls_j_1bnfe_act->serie   }{ ls_j_1bnfe_act->nfnum9 }{ ls_j_1bnfe_act->docnum9 }{ ls_j_1bnfe_act->cdv }|.

      READ TABLE lt_innfehd REFERENCE INTO DATA(ls_innfeh) WITH KEY nfeid = lv_nfeid BINARY SEARCH.

      CHECK sy-subrc = 0.

      READ TABLE lt_innfeit REFERENCE INTO DATA(ls_innfei) WITH KEY guid_header = ls_innfeh->guid_header poitem = ls_his_dep_fec->PURCHASE_ORDER_ITEM
                                                           BINARY SEARCH.

      CHECK sy-subrc = 0.

      READ TABLE lt_ekbe REFERENCE INTO DATA(ls_ekbe1) WITH KEY ebeln = ls_innfei->ponumber
                                                                ebelp = ls_innfei->poitem
                                                                matnr = ls_innfei->cprod
                                                                BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        CLear lv_poitem.
        lv_poitem = ls_innfei->poitem * 10.
        READ TABLE lt_ekbe REFERENCE INTO ls_ekbe1 WITH KEY ebeln = ls_innfei->ponumber
                                                            ebelp = lv_poitem
                                                            matnr = ls_innfei->cprod
                                                            BINARY SEARCH.
      ENDIF.

      CHECK sy-subrc = 0.

      ls_his_dep_fec->in_material_document      = ls_ekbe1->belnr.
      ls_his_dep_fec->in_material_document_year = ls_ekbe1->gjahr.
      ls_his_dep_fec->in_material_document_item = ls_ekbe1->buzei.

      DATA(lv_refkey) = |{ ls_ekbe1->belnr }{ ls_ekbe1->gjahr }|.
      DATA lv_refitm TYPE j_1bnflin-refitm.
      lv_refitm = ls_ekbe1->buzei.

      READ TABLE lt_j_1bnflin REFERENCE INTO DATA(ls_j_1bnflin) WITH KEY refkey = lv_refkey refitm = lv_refitm BINARY SEARCH.

      CHECK sy-subrc = 0.

      ls_his_dep_fec->in_br_nota_fiscal = ls_j_1bnflin->docnum.
      ls_his_dep_fec->in_br_nota_fiscal_item = ls_j_1bnflin->itmnum.
      ls_his_dep_fec->status = gc_status-completo.

    ENDLOOP.

    MODIFY ztmm_his_dep_fec FROM TABLE lt_his_dep_fec.

    COMMIT WORK.

  ENDMETHOD.


  METHOD job_delivery.

    DATA(lv_status) = COND #( WHEN iv_status IS INITIAL
                                THEN gc_status-saida_nota
                              ELSE iv_status ).
* ---------------------------------------------------------------------------
* Cria Remessa de saída
* ---------------------------------------------------------------------------

*    DATA lt_historico_key TYPE ty_t_historico.
    DATA: lt_msg_log TYPE zctgmm_his_dep_msg.

    get_bapi_info( EXPORTING
                     it_historico_key     = it_historico_key
                     iv_status            = lv_status
                   IMPORTING
                     et_historico     = DATA(lt_historico)
                     et_lin           = DATA(lt_lin)
                     et_return        = DATA(lt_return)
                     et_serie         = DATA(lt_serie)
                     et_mara          = DATA(lt_mara)
                     et_equi          = DATA(lt_equi)
                     et_eket          = DATA(lt_eket)
                     et_t001k         = DATA(lt_t001k)
                     et_lips          = DATA(lt_lips) ).

    INSERT LINES OF lt_return[] INTO TABLE et_return.

    IF lv_status = gc_status-saida_nota OR lv_status = '10'. "Aguardando Criação de Aguardando Criação de Remessa

      me->create_out_delivery( EXPORTING it_mara      = lt_mara
                                         it_equi      = lt_equi
                                         it_eket      = lt_eket
                                         iv_status    = iv_status
                               IMPORTING et_return    = lt_return
                               CHANGING  ct_historico = lt_historico
                                         ct_serie     = lt_serie
                                         ct_msg       = lt_msg_log ).


      INSERT LINES OF lt_return[] INTO TABLE et_return[].

      me->call_save_background( EXPORTING it_historico = lt_historico
                                          it_serie     = lt_serie
                                          it_msg       = lt_msg_log
                                IMPORTING et_return    = lt_return ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].

*      DELETE lt_historico WHERE carrier IS INITIAL.

    ENDIF.

* ---------------------------------------------------------------------------
* Cria Saída de mercadoria ( Documento de material )
* ---------------------------------------------------------------------------
    DATA: lt_msg_log2 TYPE zctgmm_his_dep_msg.
    me->create_out_material_document( EXPORTING it_mara      = lt_mara
                                                it_equi      = lt_equi
                                                it_t001k     = lt_t001k
                                                it_lips      = lt_lips
                                                iv_current_date = iv_current_date
                                      IMPORTING et_return    = lt_return
                                      CHANGING  ct_historico = lt_historico
                                                ct_serie     = lt_serie
                                                ct_msg       = lt_msg_log2 ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

*    DELETE lt_historico WHERE carrier IS NOT INITIAL.
    DATA(lt_historico_sem_transp) = lt_historico.
    DATA(lt_historico_com_transp) = lt_historico.
    DELETE lt_historico_sem_transp WHERE carrier IS NOT INITIAL.
    DELETE lt_historico_com_transp WHERE carrier IS INITIAL.

* ---------------------------------------------------------------------------
* Cria aviso de recebimento ( Remessa entrada )
* ---------------------------------------------------------------------------
*    me->create_in_delivery( IMPORTING et_return    = lt_return
*                            CHANGING  ct_historico = lt_historico_sem_transp
*                                      ct_serie     = lt_serie
*                                      ct_msg       = lt_msg_log2 ).
*
*    INSERT LINES OF lt_return[] INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Cria ID único para execução
* ---------------------------------------------------------------------------
    me->create_history_guid( IMPORTING et_return    = lt_return
                             CHANGING  ct_historico = lt_historico_sem_transp
                                       ct_serie     = lt_serie ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Salva dados job_saida_mercadoria
* ---------------------------------------------------------------------------
    LOOP AT lt_historico_com_transp ASSIGNING FIELD-SYMBOL(<fs_historico_com_transp>).

      IF <fs_historico_com_transp>-status = gc_status-ordem_frete_job
     AND <fs_historico_com_transp>-out_delivery_document IS NOT INITIAL.

        SELECT COUNT(*) FROM vbuk
          WHERE vbeln = @<fs_historico_com_transp>-out_delivery_document
            AND kostk = 'C'.

        IF sy-subrc = 0.
          <fs_historico_com_transp>-status          = gc_status-em_transito.
          <fs_historico_com_transp>-last_changed_by = sy-uname.
          GET TIME STAMP FIELD <fs_historico_com_transp>-last_changed_at.
          GET TIME STAMP FIELD <fs_historico_com_transp>-local_last_changed_at.
        ENDIF.
      ENDIF.
    ENDLOOP.

    CLEAR lt_historico.
    APPEND LINES OF lt_historico_sem_transp TO lt_historico.
    APPEND LINES OF lt_historico_com_transp TO lt_historico.

    me->call_save_background( EXPORTING it_historico = lt_historico
                                        it_serie     = lt_serie
                                        it_msg       = lt_msg_log2
                              IMPORTING et_return    = lt_return ).

    INSERT LINES OF lt_return[] INTO TABLE et_return[].

  ENDMETHOD.


  METHOD is_max_execution_status.
    SELECT SINGLE valor
    FROM zi_mm_limite_processa_registro
    WHERE guid = @iv_guid
    INTO @DATA(lv_passou_limite).
    IF sy-subrc = 0 AND lv_passou_limite = abap_true.
      rv_return = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD create_history_guid2.

    DATA: lt_hist_del  TYPE ty_t_historico.

    DATA: ls_hist_key1 TYPE ty_his_dep_fec_key,
          ls_hist_key2 TYPE ty_his_dep_fec_key.

    DATA: lv_count     TYPE i,
          lv_max_count TYPE i.

    FREE: et_return.

    SELECT SINGLE low
      FROM ztca_param_val
     WHERE modulo = 'MM'
       AND chave1 = 'LIMITADOR_ITENS'
       AND chave2 = 'QTDE_ITENS_NF'
       AND chave3 IS INITIAL
      INTO @DATA(lv_limitador_itens).

    lv_max_count = lv_limitador_itens.

* ---------------------------------------------------------------------------
* Prepara registros a serem removidos
* ---------------------------------------------------------------------------
    DATA(lt_historico_old) = ct_historico[].
    DELETE lt_historico_old WHERE guid IS INITIAL.

    DATA(lt_serie_old) = ct_serie[].
    DELETE lt_serie_old WHERE guid IS INITIAL.

    SORT ct_historico BY material
                         plant
                         storage_location
                         batch
                         plant_dest
                         storage_location_dest.

    DELETE ADJACENT DUPLICATES FROM ct_historico COMPARING material
                                                           plant
                                                           storage_location
                                                           batch
                                                           plant_dest
                                                           storage_location_dest.

    SORT ct_historico BY plant
                         storage_location
                         plant_dest
                         storage_location_dest
                         freight_order_id
                         delivery_document
                         process_step
                         main_purchase_order
                         main_purchase_order_item.

    LOOP AT ct_historico REFERENCE INTO DATA(ls_historico).

      ls_hist_key1 = VALUE #( plant                    = ls_historico->plant
                              storage_location         = ls_historico->storage_location
                              plant_dest               = ls_historico->plant_dest
                              storage_location_dest    = ls_historico->storage_location_dest
                              main_purchase_order      = ls_historico->main_purchase_order
                              main_purchase_order_item = ls_historico->main_purchase_order_item ).

      IF ls_hist_key1 <> ls_hist_key2
      OR lv_count     >= lv_max_count.

        CLEAR lv_count.
        DATA(lv_guid) = me->get_next_guid( IMPORTING et_return = et_return ).

        ls_hist_key2 = VALUE #( plant                    = ls_historico->plant
                                storage_location         = ls_historico->storage_location
                                plant_dest               = ls_historico->plant_dest
                                storage_location_dest    = ls_historico->storage_location_dest
                                main_purchase_order      = ls_historico->main_purchase_order
                                main_purchase_order_item = ls_historico->main_purchase_order_item ).

      ENDIF.

      LOOP AT ct_serie REFERENCE INTO DATA(ls_serie) WHERE material              = ls_historico->material
                                                       AND plant                 = ls_historico->plant
                                                       AND storage_location      = ls_historico->storage_location
                                                       AND batch                 = ls_historico->batch
                                                       AND plant_dest            = ls_historico->plant_dest
                                                       AND storage_location_dest = ls_historico->storage_location_dest
                                                       AND guid                  = ls_historico->guid.

        ls_serie->guid = lv_guid.

      ENDLOOP.

      ls_historico->guid = lv_guid.
      ADD 1 TO lv_count.

      ls_historico->created_by      = sy-uname.
      ls_historico->last_changed_by = sy-uname.
      GET TIME STAMP FIELD ls_historico->created_at.
      GET TIME STAMP FIELD ls_historico->last_changed_at.
      GET TIME STAMP FIELD ls_historico->local_last_changed_at.

      CLEAR: ls_historico->purchase_order,
             ls_historico->purchase_order_item,
             ls_historico->out_delivery_document,
             ls_historico->out_delivery_document_item.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Apaga registros antigos
* ---------------------------------------------------------------------------
*    IF lt_historico_old[] IS NOT INITIAL.
*
*      DELETE ztmm_his_dep_fec FROM TABLE lt_historico_old[].
*
*      IF sy-subrc NE 0.
*        " Falha ao salvar os dados.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
*        me->format_return( CHANGING ct_return = et_return ).
*        ROLLBACK WORK.
*        RETURN.
*      ENDIF.
*    ENDIF.
*
*    IF lt_serie_old[] IS NOT INITIAL.
*
*      DELETE ztmm_his_dep_ser FROM TABLE lt_serie_old[].
*
*      IF sy-subrc NE 0.
*        " Falha ao salvar os dados.
*        et_return[] = VALUE #( BASE et_return ( parameter = gc_cds-emissao type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '001' ) ).
*        me->format_return( CHANGING ct_return = et_return ).
*        ROLLBACK WORK.
*        RETURN.
*      ENDIF.
*    ENDIF.

* ---------------------------------------------------------------------------
* Salva registros
* ---------------------------------------------------------------------------
    CALL METHOD me->call_save_background
      EXPORTING
        it_historico_prev = lt_historico_old
        it_historico      = ct_historico
        it_serie_prev     = lt_serie_old
        it_serie          = ct_serie
      IMPORTING
        et_return         = DATA(lt_return).

  ENDMETHOD.
ENDCLASS.
