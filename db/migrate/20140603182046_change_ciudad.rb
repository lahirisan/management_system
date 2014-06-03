class ChangeCiudad < ActiveRecord::Migration
  def change
    change_column :ciudad, :nombre, :string
  end
end
