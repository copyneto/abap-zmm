@EndUserText.label: 'Geração Remessa - Excel'
define abstract entity ZI_MM_TYPE_TRANSPORTE
{
//  created_date      : abap.dats;
//  created_time      : abap.tims;
//  created_user      : uname;
  file_directory    : abap.string(256);
  centro_origem     : werkn;
  tipo_remessa      : ze_tipo_remessa;
  tipo_estoque      : numtp;
  deposito_origem   : lgort_s;
  centro_destino    : werkn;
  deposito_destino  : lgort_s;
  material          : matnr;
  qtd_transferencia : abap.dec( 13, 3 );    
  modalidadeFrete   : abap.string(256);
  tipo_expedicao    : abap.string(256);
  cond_expedicao    : abap.string(256);
  Transportador     : abap.string(256);
  Motorista         : abap.string(256);
  Veiculo           : abap.string(256);
  SemiReboque1      : abap.string(256);
  SemiReboque2      : abap.string(256);
  SemiReboque3      : abap.string(256);

}
