class AgregarCamposCorrespondencia < ActiveRecord::Migration
  
  add_column :empresas_registradas, :tipo_galpon_edificio_quinta, :string
  add_column :empresas_registradas, :galpon_edificio_quinta, :string
  add_column :empresas_registradas, :tipo_oficina_apartamento, :string
  add_column :empresas_registradas, :oficina_apartamento, :string
  add_column :empresas_registradas, :tipo_avenida_calle, :string
  add_column :empresas_registradas, :avenida_calle, :string
  add_column :empresas_registradas, :tipo_urbanizacion_barrio_sector, :string
  add_column :empresas_registradas, :urbanizacion_barrio_sector, :string
  add_column :empresas_registradas, :tipo_piso_numero, :string
  add_column :empresas_registradas, :piso_numero, :string

end
