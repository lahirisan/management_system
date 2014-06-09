class CrearTablaSecuenciaPrefijo < ActiveRecord::Migration
  def change
    create_table :secuencia_prefijo do |t|
      t.integer :secuencia_prefijo
      t.timestamps
    end
  end
end
