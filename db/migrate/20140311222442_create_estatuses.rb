class CreateEstatuses < ActiveRecord::Migration
  def change
    create_table :estatuses do |t|
      t.string :descripcion
      t.string :sub_estatus
      t.integer :id_motivo_retiro
      t.integer :habilitado
      t.string :tipo

      t.timestamps
    end
  end
end
