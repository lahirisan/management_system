class AgregarCampoNoValidaRifAEmpresa < ActiveRecord::Migration
  def change
  	add_column :empresa, :no_rif_validation, :boolean
  end
end
