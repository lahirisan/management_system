class FormatoDireccionCorrespondencia < ActiveRecord::Migration
  
  add_column :empresas_registradas, :tipo_galpon_edificio_quinta_sincronet, :string
  add_column :empresas_registradas, :galpon_edificio_quinta_sincronet, :string
  add_column :empresas_registradas, :tipo_oficina_apartamento_sincronet, :string
  add_column :empresas_registradas, :oficina_apartamento_sincronet, :string
  add_column :empresas_registradas, :tipo_avenida_calle_sincronet, :string
  add_column :empresas_registradas, :avenida_calle_sincronet, :string
  add_column :empresas_registradas, :tipo_urbanizacion_barrio_sector_sincronet, :string
  add_column :empresas_registradas, :urbanizacion_barrio_sector_sincronet, :string
  add_column :empresas_registradas, :tipo_piso_numero_sincronet, :string
  add_column :empresas_registradas, :piso_numero_sincronet, :string

  add_column :empresas_registradas, :tipo_galpon_edificio_quinta_seminarios, :string
  add_column :empresas_registradas, :galpon_edificio_quinta_seminarios, :string
  add_column :empresas_registradas, :tipo_oficina_apartamento_seminarios, :string
  add_column :empresas_registradas, :oficina_apartamento_seminarios, :string
  add_column :empresas_registradas, :tipo_avenida_calle_seminarios, :string
  add_column :empresas_registradas, :avenida_calle_seminarios, :string
  add_column :empresas_registradas, :tipo_urbanizacion_barrio_sector_seminarios, :string
  add_column :empresas_registradas, :urbanizacion_barrio_sector_seminarios, :string
  add_column :empresas_registradas, :tipo_piso_numero_seminarios, :string
  add_column :empresas_registradas, :piso_numero_seminarios, :string


  add_column :empresas_registradas, :tipo_galpon_edificio_quinta_mercadeo, :string
  add_column :empresas_registradas, :galpon_edificio_quinta_mercadeo, :string
  add_column :empresas_registradas, :tipo_oficina_apartamento_mercadeo, :string
  add_column :empresas_registradas, :oficina_apartamento_mercadeo, :string
  add_column :empresas_registradas, :tipo_avenida_calle_mercadeo, :string
  add_column :empresas_registradas, :avenida_calle_mercadeo, :string
  add_column :empresas_registradas, :tipo_urbanizacion_barrio_sector_mercadeo, :string
  add_column :empresas_registradas, :urbanizacion_barrio_sector_mercadeo, :string
  add_column :empresas_registradas, :tipo_piso_numero_mercadeo, :string
  add_column :empresas_registradas, :piso_numero_mercadeo, :string
  add_column :empresas_registradas, :id_estado_mercadeo, :integer
  add_column :empresas_registradas, :id_ciudad_mercadeo, :integer
  add_column :empresas_registradas, :id_municipio_mercadeo, :integer
  add_column :empresas_registradas, :parroquia_mercadeo, :string
  add_column :empresas_registradas, :punto_ref_mercadeo, :string
  add_column :empresas_registradas, :codigo_postal_mercadeo, :string
  add_column :empresas_registradas, :telefono2_mercadeo, :string
  add_column :empresas_registradas, :telefono3_mercadeo, :string

  add_column :empresas_registradas, :email2_edi, :string
  add_column :empresas_registradas, :email2_recursos, :string
  add_column :empresas_registradas, :email2_mercadeo, :string
  add_column :empresas_registradas, :email1_recursos, :string
  add_column :empresas_registradas, :email1_mercadeo, :string

  add_column :empresas_registradas, :telefono2_recursos, :string
  add_column :empresas_registradas, :telefono3_recursos, :string

  add_column :empresas_registradas, :id_estado_recursos, :integer
  add_column :empresas_registradas, :id_ciudad_recursos, :integer
  add_column :empresas_registradas, :id_municipio_recursos, :integer
  add_column :empresas_registradas, :parroquia_recursos, :string
  add_column :empresas_registradas, :punto_ref_recursos, :string
  add_column :empresas_registradas, :codigo_postal_recursos, :string
  

end
