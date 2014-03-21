class CreateEmpresaCorrespondencia < ActiveRecord::Migration
  def change
    create_table :empresa_correspondencia do |t|
      t.string :rep_tecnico
      t.string :cargo_rep_tecnico
      t.string :edificio
      t.string :calle
      t.string :urbanizacion
      t.integer :id_estado
      t.integer :id_ciudad
      t.integer :id_municipio
      t.integer :cod_postal
      t.string :punto_referencia
      t.integer :id_parroquia

      t.timestamps
    end
  end
end
