class TipoGln < ActiveRecord::Migration
  def change
    rename_column :gln_eliminado, :tipo_gln, :id_tipo_gln
  end
end
