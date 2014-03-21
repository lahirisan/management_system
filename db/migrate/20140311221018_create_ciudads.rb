class CreateCiudads < ActiveRecord::Migration
  def change
    create_table :ciudads do |t|
      t.string :nombre
      t.integer :id_estado
      t.integer :habilitado

      t.timestamps
    end
  end
end
