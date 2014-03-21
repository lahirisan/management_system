class CreateEmpresas < ActiveRecord::Migration
  def change
    create_table :empresas do |t|
      t.string :nombre_empresa
      t.datetime :fecha_inscripcion
      t.string :direccion_empresa
      t.integer :id_estado
      t.integer :id_ciudad
      t.string :rif
      t.integer :id_status
      t.integer :id_tipo_usuario
      t.string :nombre_comercial
      t.integer :id_clasificacion
      t.string :categoria
      t.integer :division
      t.integer :grupo
      t.integer :clase
      t.string :rep_legal
      t.string :cargo_rep_legal

      t.timestamps
    end
  end
end
