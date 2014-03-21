class CreateEstados < ActiveRecord::Migration
  def change
    create_table :estados do |t|
      t.text :nombre
      t.integer :habilitado
      t.integer :id_pais

      t.timestamps
    end
  end
end
