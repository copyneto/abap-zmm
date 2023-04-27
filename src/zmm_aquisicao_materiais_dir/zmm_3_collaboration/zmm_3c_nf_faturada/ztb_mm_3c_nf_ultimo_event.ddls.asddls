@EndUserText.label: 'Table Function Ultimo Evento'
define table function ZTB_MM_3C_NF_ULTIMO_EVENT
returns {  
  key mandt : abap.clnt;
  key guid  : /xnfe/guid_16;
  key chnfe : /xnfe/id;     
  tpevento : /xnfe/ev_tpevento;  
  rank : abap.int8; 
}
implemented by method zcl_mm_nf_ultimo_event=>get_event;
