class UsuariosAlcance < ActiveRecord::Base
  attr_accessible :alcance, :perfil


def self.verificar_alcance(perfil, funcionalidad)

	return UsuariosAlcance.find(:first, :conditions => ["perfil = ? and alcance = ?",perfil,funcionalidad])

end

end
