class AgragegarCamposEmpresa < ActiveRecord::Migration
  
  add_column :empresa, :tipo_galpon_edificio_quinta, :string
  add_column :empresa, :galpon_edificio_quinta, :string
  add_column :empresa, :tipo_oficina_apartamento, :string
  add_column :empresa, :oficina_apartamento, :string
  add_column :empresa, :tipo_avenida_calle, :string
  add_column :empresa, :avenida_calle, :string
  add_column :empresa, :tipo_urbanizacion_barrio_sector, :string
  add_column :empresa, :urbanizacion_barrio_sector, :string
  add_column :empresa, :tipo_piso_numero, :string
  add_column :empresa, :piso_numero, :string

  add_column :empresa, :tipo_galpon_edificio_quinta_sincronet, :string
  add_column :empresa, :galpon_edificio_quinta_sincronet, :string
  add_column :empresa, :tipo_oficina_apartamento_sincronet, :string
  add_column :empresa, :oficina_apartamento_sincronet, :string
  add_column :empresa, :tipo_avenida_calle_sincronet, :string
  add_column :empresa, :avenida_calle_sincronet, :string
  add_column :empresa, :tipo_urbanizacion_barrio_sector_sincronet, :string
  add_column :empresa, :urbanizacion_barrio_sector_sincronet, :string
  add_column :empresa, :tipo_piso_numero_sincronet, :string
  add_column :empresa, :piso_numero_sincronet, :string

  add_column :empresa, :tipo_galpon_edificio_quinta_seminarios, :string
  add_column :empresa, :galpon_edificio_quinta_seminarios, :string
  add_column :empresa, :tipo_oficina_apartamento_seminarios, :string
  add_column :empresa, :oficina_apartamento_seminarios, :string
  add_column :empresa, :tipo_avenida_calle_seminarios, :string
  add_column :empresa, :avenida_calle_seminarios, :string
  add_column :empresa, :tipo_urbanizacion_barrio_sector_seminarios, :string
  add_column :empresa, :urbanizacion_barrio_sector_seminarios, :string
  add_column :empresa, :tipo_piso_numero_seminarios, :string
  add_column :empresa, :piso_numero_seminarios, :string


  add_column :empresa, :tipo_galpon_edificio_quinta_mercadeo, :string
  add_column :empresa, :galpon_edificio_quinta_mercadeo, :string
  add_column :empresa, :tipo_oficina_apartamento_mercadeo, :string
  add_column :empresa, :oficina_apartamento_mercadeo, :string
  add_column :empresa, :tipo_avenida_calle_mercadeo, :string
  add_column :empresa, :avenida_calle_mercadeo, :string
  add_column :empresa, :tipo_urbanizacion_barrio_sector_mercadeo, :string
  add_column :empresa, :urbanizacion_barrio_sector_mercadeo, :string
  add_column :empresa, :tipo_piso_numero_mercadeo, :string
  add_column :empresa, :piso_numero_mercadeo, :string
  add_column :empresa, :id_estado_mercadeo, :integer
  #add_column :empresa, :id_ciudad_mercadeo, :integer
  #add_column :empresa, :id_municipio_mercadeo, :integer
  add_column :empresa, :parroquia_mercadeo, :string
  add_column :empresa, :punto_ref_mercadeo, :string
  #add_column :empresa, :codigo_postal_mercadeo, :string
  #add_column :empresa, :telefono2_mercadeo, :string
  add_column :empresa, :telefono3_mercadeo, :string

  add_column :empresa, :email2_edi, :string
  add_column :empresa, :email2_recursos, :string
  add_column :empresa, :email2_mercadeo, :string
  add_column :empresa, :email1_recursos, :string
  add_column :empresa, :email1_mercadeo, :string

  #add_column :empresa, :telefono2_recursos, :string
  add_column :empresa, :telefono3_recursos, :string

  add_column :empresa, :id_estado_recursos, :integer
  #add_column :empresa, :id_ciudad_recursos, :integer
  #add_column :empresa, :id_municipio_recursos, :integer
  #add_column :empresa, :parroquia_recursos, :string
  add_column :empresa, :punto_ref_recursos, :string
  #add_column :empresa, :codigo_postal_recursos, :string

  add_column :empresa, :cod_contacto_tlf1, :string
  add_column :empresa, :cod_contacto_tlf3, :string
  add_column :empresa, :cod_contacto_tlf2, :string
  add_column :empresa, :cod_contacto_fax, :string

  add_column :empresa, :cod_tlf1_ean, :string
  add_column :empresa, :cod_tlf2_ean, :string
  add_column :empresa, :cod_tlf3_ean, :string
  add_column :empresa, :cod_fax_ean, :string

  add_column :empresa, :cod_tlf1_sincronet, :string
  add_column :empresa, :cod_tlf2_sincronet, :string
  add_column :empresa, :cod_tlf3_sincronet, :string
  add_column :empresa, :cod_fax_sincronet, :string

  add_column :empresa, :cod_tlf1_seminarios, :string
  add_column :empresa, :cod_tlf2_seminarios, :string
  add_column :empresa, :cod_tlf3_seminarios, :string
  add_column :empresa, :cod_fax_seminarios, :string

  add_column :empresa, :cod_tlf1_mercadeo, :string
  add_column :empresa, :cod_tlf2_mercadeo, :string
  add_column :empresa, :cod_tlf3_mercadeo, :string
  add_column :empresa, :cod_fax_mercadeo, :string

end
