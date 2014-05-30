class CreateUsuariosAlcances < ActiveRecord::Migration
  def change
    create_table :usuarios_alcances do |t|
      t.string :perfil
      t.string :alcance
      t.timestamps
    end
  end
end
