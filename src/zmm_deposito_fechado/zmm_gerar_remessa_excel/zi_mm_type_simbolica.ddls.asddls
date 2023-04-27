@EndUserText.label: 'Geração Remessa - Excel'
define abstract entity ZI_MM_TYPE_SIMBOLICA
{
  created_date      : abap.dats;
  created_time      : abap.tims;
  created_user      : uname;
  file_directory    : abap.string(256);
  centro_origem     : werkn;
  tipo_remessa      : ze_tipo_remessa;
  tipo_estoque      : numtp;
  deposito_origem   : lgort_s;
  centro_destino    : werkn;
  deposito_destino  : lgort_s;
  material          : matnr;
  qtd_transferencia : abap.dec( 13, 3 );

}
