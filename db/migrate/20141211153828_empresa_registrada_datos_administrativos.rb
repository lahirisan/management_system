class EmpresaRegistradaDatosAdministrativos < ActiveRecord::Migration
	add_column :empresas_registradas, :contacto_tlf1_completo, :string
	add_column :empresas_registradas, :contacto_tlf2_completo, :string
	add_column :empresas_registradas, :contacto_tlf3_completo, :string
	add_column :empresas_registradas, :contacto_fax_completo, :string
	add_column :empresas_registradas, :telefono1_ean_completo, :string
	add_column :empresas_registradas, :telefono2_ean_completo, :string
	add_column :empresas_registradas, :telefono3_ean_completo, :string
	add_column :empresas_registradas, :fax_ean_completo, :string

	add_column :empresa, :contacto_tlf1_completo, :string
	#add_column :empresa, :contacto_tlf2_completo, :string
	add_column :empresa, :contacto_tlf3_completo, :string
	add_column :empresa, :contacto_fax_completo, :string
	add_column :empresa, :telefono1_ean_completo, :string
	add_column :empresa, :telefono2_ean_completo, :string
	add_column :empresa, :telefono3_ean_completo, :string
	add_column :empresa, :fax_ean_completo, :string
	
end
