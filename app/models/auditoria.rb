class Auditoria < ActiveRecord::Base
	self.table_name = 'auditoria'
  	attr_accessible :accion, :fecha_creacion, :tabla, :usuario


	def self.registrar_evento(usuario, tabla, accion,fecha, datos)

	usuario = Usuario.find(:first, :conditions => ["id = ?", usuario])


	nuevo_evento = Auditoria.new
	nuevo_evento.usuario  = usuario.nombre_apellido
	nuevo_evento.tabla = tabla
	nuevo_evento.accion = accion
	nuevo_evento.fecha_accion = fecha
	nuevo_evento.descripcion = datos
	nuevo_evento.save

	end


end

