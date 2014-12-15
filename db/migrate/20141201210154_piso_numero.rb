class PisoNumero < ActiveRecord::Migration
	
	add_column :empresas_registradas, :tipo_piso_numero, :string
	add_column :empresas_registradas, :piso_numero, :string

end
