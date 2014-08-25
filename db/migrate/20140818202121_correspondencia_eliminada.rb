class CorrespondenciaEliminada < ActiveRecord::Migration
  add_column :empresa_correspondencia_eliminada, :tipo_correspondencia, :string
  add_column :empresa_correspondencia_eliminada, :telefono1, :string
  add_column :empresa_correspondencia_eliminada, :telefono2, :string
  add_column :empresa_correspondencia_eliminada, :telefono3, :string
  add_column :empresa_correspondencia_eliminada, :fax, :string
  add_column :empresa_correspondencia_eliminada, :email, :string
  add_column :empresa_correspondencia_eliminada, :direccion, :string
  add_column :empresa_correspondencia_eliminada, :piso, :string
  add_column :empresa_correspondencia_eliminada, :detalle_piso, :string
  add_column :empresa_correspondencia_eliminada, :detalle_calle, :string
  add_column :empresa_correspondencia_eliminada, :detalle_urbanizacion, :string
  add_column :empresa_correspondencia_eliminada, :oficina, :string
  add_column :empresa_correspondencia_eliminada, :detalle_oficina, :string
  add_column :empresa_correspondencia_eliminada, :nombre_parroquia, :string
  
end
