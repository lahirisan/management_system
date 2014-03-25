class CreateMotivoRetiros < ActiveRecord::Migration
  def change
    create_table :motivo_retiros do |t|
      t.string :descripcion
      t.integer :habilitado

      t.timestamps
    end
  end
end
