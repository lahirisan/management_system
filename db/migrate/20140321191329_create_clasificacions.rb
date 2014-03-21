class CreateClasificacions < ActiveRecord::Migration
  def change
    create_table :clasificacions do |t|
      t.string :categoria
      t.integer :division
      t.integer :grupo
      t.integer :clase
      t.string :descripcion
      t.boolean :habilitado

      t.timestamps
    end
  end
end
