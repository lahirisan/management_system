class ChangeTextMunicipio < ActiveRecord::Migration
  def change
    change_column :municipio, :ciudad_sede, :string
    change_column :municipio, :nombre, :string

  end
end
