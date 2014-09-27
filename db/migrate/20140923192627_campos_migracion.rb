class CamposMigracion < ActiveRecord::Migration

#<<<<<<< HEAD
	  #add_column :empresa, :contacto_tlf2, :string
  #add_column :empresa, :contacto_tlf3, :string
  #add_column :empresa, :contacto_fax,  :string
  #add_column :empresa, :contacto_email1, :string
  #add_column :empresa, :contacto_email2, :string
  #add_column :empresa, :user_ult_modificacion, :integer
  #add_column :empresa, :fecha_ultima_modificacion, :datetime
  #add_column :empresa, :user_crea, :datetime
  #add_column :empresa, :rep_ean, :string
  #add_column :empresa, :rep_ean_cargo, :string
  #add_column :empresa, :direccion_ean1, :string
  #add_column :empresa, :direccion_ean2, :string
  #add_column :empresa, :direccion_ean3, :string
  #add_column :empresa, :direccion_ean4, :string
  #add_column :empresa, :punto_ref_ean, :string
  #add_column :empresa, :id_estado_ean, :integer
  #add_column :empresa, :id_ciudad_ean, :integer
  #add_column :empresa, :id_parroquia_ean, :integer
  #add_column :empresa, :parroquia_ean, :string
  #add_column :empresa, :cod_postal_ean, :integer
  #add_column :empresa, :codigo_postal_empresa, :integer
  #add_column :empresa, :telefono1_ean, :string
  #add_column :empresa, :telefono2_ean, :string
  #add_column :empresa, :telefono3_ean, :string
  #add_column :empresa, :fax_ean, :string
  #add_column :empresa, :email1_ean, :string
  #add_column :empresa, :email2_ean, :string
  #add_column :empresa, :rep_edi, :string
  #add_Column :empresa, :rep_edi_cargo, :string
  #add_column :empresa, :direccion_edi1, :string
  #add_column :empresa, :direccion_edi2, :string
 # add_column :empresa, :direccion_edi3, :string
 # add_column :empresa, :id_ciudad_edi, :integer
 # add_column :empresa, :punto_ref_edi, :string
 # add_column :empresa, :codifo_postal_edi, :string
 # add_column :empresa, :telefono1_edi, :string
 # add_column :empresa, :telefono2_edi, :string
 # add_column :empresa, :telefono3_edi, :string
 # add_column :empresa, :fax_edi, :string
 # add_column :empresa, :email1_edi, :string
 # add_column :empresa, :usuario_ultima_modificacion_edi, :integer
 # add_column :empresa, :fecha_ultima_modificacion_edi, :datetime
 # add_column :empresa, :user_crea_edi, :integer
 # add_column :empresa, :aporte_mantenimiento, :float
 # add_column :empresa, :id_municipio_ean, :integer
  #add_column :empresa, :id_municipio_edi, :integer
  #add_column :empresa, :id_parroquia_edi, :integer
  #add_column :empresa, :parroquia, :string
  #add_column :empresa, :rep_mercadeo, :string
  #add_column :empresa, :rep_mercadeo_cargo, :string
 # add_column :empresa, :direccion_mercadeo1, :string
#=======
  add_column :empresa, :contacto_tlf2, :string
  add_column :empresa, :contacto_tlf3, :string
  add_column :empresa, :contacto_fax,  :string
  add_column :empresa, :contacto_email1, :string
  add_column :empresa, :contacto_email2, :string
  add_column :empresa, :user_ult_modificacion, :integer
  add_column :empresa, :fecha_ultima_modificacion, :datetime
  add_column :empresa, :user_crea, :datetime
  add_column :empresa, :rep_ean, :string
  add_column :empresa, :rep_ean_cargo, :string
  add_column :empresa, :direccion_ean1, :string
  add_column :empresa, :direccion_ean2, :string
  add_column :empresa, :direccion_ean3, :string
  add_column :empresa, :direccion_ean4, :string
  add_column :empresa, :punto_ref_ean, :string
  add_column :empresa, :id_estado_ean, :integer
  add_column :empresa, :id_ciudad_ean, :integer
  add_column :empresa, :id_parroquia_ean, :integer
  add_column :empresa, :parroquia_ean, :string
  add_column :empresa, :cod_postal_ean, :integer
  add_column :empresa, :codigo_postal_empresa, :integer
  add_column :empresa, :telefono1_ean, :string
  add_column :empresa, :telefono2_ean, :string
  add_column :empresa, :telefono3_ean, :string
  add_column :empresa, :fax_ean, :string
  add_column :empresa, :email1_ean, :string
  add_column :empresa, :email2_ean, :string
  add_column :empresa, :rep_edi, :string
  add_Column :empresa, :rep_edi_cargo, :string
  add_column :empresa, :direccion_edi1, :string
  add_column :empresa, :direccion_edi2, :string
  add_column :empresa, :direccion_edi3, :string
  add_column :empresa, :id_ciudad_edi, :integer
  add_column :empresa, :punto_ref_edi, :string
  add_column :empresa, :codifo_postal_edi, :string
  add_column :empresa, :telefono1_edi, :string
  add_column :empresa, :telefono2_edi, :string
  add_column :empresa, :telefono3_edi, :string
  add_column :empresa, :fax_edi, :string
  add_column :empresa, :email1_edi, :string
  add_column :empresa, :usuario_ultima_modificacion_edi, :integer
  add_column :empresa, :fecha_ultima_modificacion_edi, :datetime
  add_column :empresa, :user_crea_edi, :integer
  add_column :empresa, :aporte_mantenimiento, :float
  add_column :empresa, :id_municipio_ean, :integer
  add_column :empresa, :id_municipio_edi, :integer
  add_column :empresa, :id_parroquia_edi, :integer
  add_column :empresa, :parroquia, :string
  add_column :empresa, :rep_mercadeo, :string
  add_column :empresa, :rep_mercadeo_cargo, :string
  add_column :empresa, :direccion_mercadeo1, :string
#>>>>>>> a617fb73a0ebba886a5e64cb8611cc0fc4201441
  add_column :empresa, :direccion_mercadeo2, :string
  add_column :empresa, :direccion_mercadeo3, :string
  add_column :empresa, :punto_referencia_mercadeo, :string
  add_column :empresa, :id_ciudad_mercadeo, :integer
  add_column :empresa, :codigo_postal_mercadeo, :integer
  add_column :empresa, :telefono1_mercadeo, :string
  add_column :empresa, :telefono2_mercadeo, :string
  add_column :empresa, :fax_mercadeo, :string
  add_column :empresa, :email_mercadeo, :string
  add_column :empresa, :id_municipio_mercadeo, :string
  add_column :empresa, :rep_recursos, :string
  add_column :empresa, :rep_recursos_cargo, :string
  add_column :empresa, :direccion_recursos1, :string
  add_column :empresa, :direccion_recursos2, :string
  add_column :empresa, :direccion_recursos3, :string
  add_column :empresa, :punto_referencia_recursos, :string
  add_column :empresa, :id_ciudad_recursos, :integer
  add_column :empresa, :codigo_postal_recursos, :integer
  add_column :empresa, :telefono1_recursos, :string
  add_column :empresa, :telefono2_recursos, :string
  add_column :empresa, :fax_recursos, :string
  add_column :empresa, :email_recursos, :string
  add_column :empresa, :id_municipio_recursos, :integer
  add_column :empresa, :id_parroquia_recursos, :integer
  add_column :empresa, :parroquia_recursos, :string
  add_column :empresa, :punto_referencia_empresa, :string
  add_column :empresa, :fecha_ultima_modificacion_ean, :datetime
 # add_column :empresa, :fecha_ultima_modificacion_edi, :datetime
  add_column :empresa, :fecha_ultima_modificacion_recursos, :datetime
  add_column :empresa, :fecha_ultima_modificacion_mercadeo, :datetime
 
end
