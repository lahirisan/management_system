class AgregarCodigosTelefonoEmpresasRegistradas < ActiveRecord::Migration
	add_column :empresas_registradas, :cod_contacto_tlf1, :string
	add_column :empresas_registradas, :cod_contacto_tlf2, :string
	add_column :empresas_registradas, :cod_contacto_tlf3, :string
	add_column :empresas_registradas, :cod_contacto_fax, :string

	add_column :empresas_registradas, :cod_tlf1_ean, :string
	add_column :empresas_registradas, :cod_tlf2_ean, :string
	add_column :empresas_registradas, :cod_tlf3_ean, :string
	add_column :empresas_registradas, :cod_fax_ean, :string

	add_column :empresas_registradas, :cod_tlf1_sincronet, :string
	add_column :empresas_registradas, :cod_tlf2_sincronet, :string
	add_column :empresas_registradas, :cod_tlf3_sincronet, :string
	add_column :empresas_registradas, :cod_fax_sincronet, :string

	add_column :empresas_registradas, :cod_tlf1_seminarios, :string
	add_column :empresas_registradas, :cod_tlf2_seminarios, :string
	add_column :empresas_registradas, :cod_tlf3_seminarios, :string
	add_column :empresas_registradas, :cod_fax_seminarios, :string

	add_column :empresas_registradas, :cod_tlf1_mercadeo, :string
	add_column :empresas_registradas, :cod_tlf2_mercadeo, :string
	add_column :empresas_registradas, :cod_tlf3_mercadeo, :string
	add_column :empresas_registradas, :cod_fax_mercadeo, :string

end
