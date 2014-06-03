# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Usuario.create(username: 'admin', password: 'admin', email: 'admin@app.com', nombre_apellido: 'admin', fecha_creacion: Time.now)
#Perfil.create([{descripcion: 'prefil2', detalle: 'detalle2', habilitado: 1},{descripcion: 'prefil3', detalle: 'detalle3', habilitado: 1}])

UsuariosAlcance.create([
	{perfil:'Administrador', alcance:'Listar Empresa'},
	{perfil:'Administrador', alcance:'Modificar Empresa'},
	{perfil:'Administrador', alcance:'Retirar Empresa'},
	{perfil:'Administrador', alcance:'Eliminar Empresa'},
	{perfil:'Administrador', alcance:'Exportar Empresa'},
	{perfil:'Administrador', alcance:'Registrar Empresa'},
	{perfil:'Administrador', alcance:'Reactivar Empresa'},
	{perfil:'Administrador', alcance:'Validar Empresa'},
	{perfil:'Administrador', alcance:'Listar Producto'},
	{perfil:'Administrador', alcance:'Importar Producto'},
	{perfil:'Administrador', alcance:'Registrar Producto'},
	{perfil:'Administrador', alcance:'Modificar Producto'},
	{perfil:'Administrador', alcance:'Retirar Producto'},
	{perfil:'Administrador', alcance:'Eliminar Producto'},
	{perfil:'Administrador', alcance:'Exportar Producto'},
	{perfil:'Administrador', alcance:'Listar Servicio'},
	{perfil:'Administrador', alcance:'Registrar Servicio'},
	{perfil:'Administrador', alcance:'Modificar Servicio'},
	{perfil:'Administrador', alcance:'Eliminar Servicio'},
	{perfil:'Administrador', alcance:'Exportar Servicio'},
	{perfil:'Administrador', alcance:'Listar GLN'},
	{perfil:'Administrador', alcance:'Registrar GLN'},
	{perfil:'Administrador', alcance:'Modificar GLN'},
 	{perfil:'Administrador', alcance:'Eliminar GLN'},
 	{perfil:'Administrador', alcance:'Exportar GLN'},
 	{perfil:'Administrador', alcance:'Ver Etiqueta'},
 	{perfil:'Administrador', alcance:'Modificar Etiqueta'},
 	{perfil:'Administrador', alcance:'Exportar Etiqueta'},
 	{perfil:'Administrador', alcance:'Listar Usuario'},
 	{perfil:'Administrador', alcance:'Registrar Usuario'},
 	{perfil:'Administrador', alcance:'Modificar Usuario'},
 	{perfil:'Administrador', alcance:'Exportar Usuario'},
 	{perfil:'Administrador', alcance:'Eliminar Usuario'},
 	{perfil:'Super Usuario', alcance:'Listar Empresa'},
 	{perfil:'Super Usuario', alcance:'Modificar Empresa'},
 	{perfil:'Super Usuario', alcance:'Retirar Empresa'},
 	{perfil:'Super Usuario', alcance:'Eliminar Empresa'},
 	{perfil:'Super Usuario', alcance:'Exportar Empresa'},
 	{perfil:'Super Usuario', alcance:'Registrar Empresa'},
 	{perfil:'Super Usuario', alcance:'Reactivar Empresa'},
 	{perfil:'Super Usuario', alcance:'Validar Empresa'},
 	{perfil:'Super Usuario', alcance:'Listar Producto'},
 	{perfil:'Super Usuario', alcance:'Importar Producto'},
 	{perfil:'Super Usuario', alcance:'Registrar Producto'},
 	{perfil:'Super Usuario', alcance:'Modificar Producto'},
 	{perfil:'Super Usuario', alcance:'Retirar Producto'},
 	{perfil:'Super Usuario', alcance:'Eliminar Producto'},
 	{perfil:'Super Usuario', alcance:'Exportar Producto'},
 	{perfil:'Super Usuario', alcance:'Listar Servicio'},
 	{perfil:'Super Usuario', alcance:'Registrar Servicio'},
 	{perfil:'Super Usuario', alcance:'Modificar Servicio'},
 	{perfil:'Super Usuario', alcance:'Eliminar Servicio'},
 	{perfil:'Super Usuario', alcance:'Exportar Servicio'},
 	{perfil:'Super Usuario', alcance:'Listar GLN'},
 	{perfil:'Super Usuario', alcance:'Registrar GLN'},
 	{perfil:'Super Usuario', alcance:'Modificar GLN'},
 	{perfil:'Super Usuario', alcance:'Eliminar GLN'},
 	{perfil:'Super Usuario', alcance:'Exportar GLN'},
 	{perfil:'Super Usuario', alcance:'Ver Etiqueta'},
 	{perfil:'Super Usuario', alcance:'Modificar Etiqueta'},
 	{perfil:'Super Usuario', alcance:'Exportar Etiqueta'},
 	{perfil:'Usuario Operativo', alcance:'Listar Empresa'},
 	{perfil:'Usuario Operativo', alcance:'Modificar Empresa'},
 	{perfil:'Usuario Operativo', alcance:'Registrar Empresa'},
 	{perfil:'Usuario Operativo', alcance:'Reactivar Empresa'},
 	{perfil:'Usuario Operativo', alcance:'Listar Producto'},
 	{perfil:'Usuario Operativo', alcance:'Importar Producto'},
 	{perfil:'Usuario Operativo', alcance:'Registrar Producto'},
 	{perfil:'Usuario Operativo', alcance:'Modificar Producto'},
 	{perfil:'Usuario Operativo', alcance:'Exportar Producto'},
 	{perfil:'Usuario Operativo', alcance:'Listar GLN'},
 	{perfil:'Usuario Operativo', alcance:'Registrar GLN'},
 	{perfil:'Usuario Operativo', alcance:'Modificar GLN'},
 	{perfil:'Usuario Operativo', alcance:'Exportar GLN'},
 	{perfil:'Usuario Operativo', alcance:'Ver Etiqueta'},
 	{perfil:'Usuario Operativo', alcance:'Modificar Etiqueta'},
 	{perfil:'Usuario Operativo', alcance:'Exportar Etiqueta'},
 	{perfil:'Usuario Read Only', alcance:'Listar Empresa'},
 	{perfil:'Usuario Read Only', alcance:'Exportar Empresa'},
 	{perfil:'Usuario Read Only', alcance:'Listar Producto'},
 	{perfil:'Usuario Read Only', alcance:'Exportar Producto'},
 	{perfil:'Usuario Read Only', alcance:'Listar Servicio'},
 	{perfil:'Usuario Read Only', alcance:'Listar GLN'},
 	{perfil:'Usuario Read Only', alcance:'Exportar GLN'},
 	{perfil:'Usuario Read Only', alcance:'Ver Etiqueta'},
 	{perfil:'Usuario Read Only', alcance:'Modificar Etiqueta'},
 	{perfil:'Usuario Read Only', alcance:'Exportar Etiqueta'},
 	{perfil:'Usuario Read Only', alcance:'Listar Usuario'},
 	{perfil:'Usuario Read Only', alcance:'Exportar Usuario'},
 	{perfil:'Usuario Validador', alcance:'Listar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Modificar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Exportar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Registrar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Reactivar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Validar Empresa'},
 	{perfil:'Usuario Validador', alcance:'Listar Servicio'},
 	{perfil:'Usuario Validador', alcance:'Registrar Servicio'},
 	{perfil:'Usuario Validador', alcance:'Modificar Servicio'},
 	{perfil:'Usuario Validador', alcance:'Exportar Servicio'},
 	{perfil:'Usuario Validador', alcance:'Ver Etiqueta'},
 	{perfil:'Usuario Validador', alcance:'Modificar Etiqueta'},
 	{perfil:'Usuario Validador', alcance:'Exportar Etiqueta'}
	])

cargos = Cargo.all
cargos.collect{|cargo| cargo.destroy}

Cargo.create([{descripcion: 'Coordinador',  habilitado: 1},{descripcion: 'Asistente',  habilitado: 1},{descripcion: 'Administrador Sistema',  habilitado: 1}])

gerencias = Gerencia.all
gerencias.collect{|gerencia|gerencia.destroy}

Gerencia.create([{nombre: 'Comercial',  habilitado: 1},{nombre: 'Administrativa',  habilitado: 1},{nombre: 'Tecnica',  habilitado: 1}, {nombre: 'General',  habilitado: 1}])

perfiles = Perfil.all
perfiles.collect{|perfil| perfil.destroy}
Perfil.create([{descripcion: 'Administrador', detalle: '', habilitado: 1},{descripcion: 'Super Usuario', detalle: '', habilitado: 1},{descripcion: 'Usuario Operativo', detalle: '', habilitado: 1},{descripcion: 'Usuario Read Only', detalle: '', habilitado: 1},{descripcion: 'Usuario Validador', detalle: '', habilitado: 1}])

usuarios = Usuario.all
usuarios.collect{|usuario| usuario.destroy}
perfil_administrador = Perfil.find(:first, :conditions => ["descripcion = ?", "Administrador"])
gerencia_tecnica = Gerencia.find(:first, :conditions => ["nombre = ?", "Tecnica"])
cargo_administrador = Cargo.find(:first, :conditions => ["descripcion = ?", "Administrador Sistema"])
Usuario.create(username: 'admin', password: 'admin', email: 'admin@app.com', nombre_apellido: 'admin', fecha_creacion: Time.now, id_perfil:perfil_administrador.id, id_gerencia:gerencia_tecnica.id, id_cargo:cargo_administrador.id)
















