class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :username
      t.string :password
      t.string :nombre_apellido
      t.string :email
      t.integer :id_perfil
      t.integer :id_gerencia
      t.integer :id_cargo
      t.datetime :fecha_creacion

      t.timestamps
    end
  end
end
