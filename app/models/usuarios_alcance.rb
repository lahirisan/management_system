class UsuariosAlcance < ActiveRecord::Base
  attr_accessible :alcance, :perfil


	def self.verificar_alcance(perfil, gerencia,  funcionalidad)
		
		return UsuariosAlcance.where(["perfil = ? and gerencia = ? and alcance = ?", perfil, gerencia, funcionalidad]).first
		
	end

end
