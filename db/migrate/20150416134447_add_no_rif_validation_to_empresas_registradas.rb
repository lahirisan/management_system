class AddNoRifValidationToEmpresasRegistradas < ActiveRecord::Migration
  def change
    add_column :empresas_registradas, :no_rif_validation, :boolean
  end
end
