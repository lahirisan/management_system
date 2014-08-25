class ModificarEmpresa < ActiveRecord::Migration
  def change
    add_column :empresa, :circunscripcion_judicial, :string
    add_column :empresa, :numero_registro_mercantil, :integer
    add_column :empresa, :tomo_registro_mercantil, :string
    add_column :empresa, :nit_registro_mercantil, :string
    add_column :empresa, :nacionalidad_responsable_legal, :string
    add_column :empresa, :domicilio_responsable_legal, :string
    add_column :empresa, :cedula_responsable_legal, :string
    add_column :empresa, :ventas_brutas_anuales, :string

    add_column :empresa, :created_at, :datetime
    add_column :empresa, :updated_at, :datetime

  end
end
