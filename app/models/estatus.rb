class Estatus < ActiveRecord::Base
  attr_accessible :alcance, :descripcion, :habilitado
  self.table_name = "estatus"

  # Devuelve el id de empresa inactiva
  def self.empresa_inactiva()

  	# OJo con la descripcion del estatus, verificar que este sea el string para empresas qeu aun no han diso validadas
  	estatus = Estatus.find(:first, :conditions => ["descripcion like ? and alcance like ?", "No Validado", "Empresa"])
  	return estatus.id

  end
end
