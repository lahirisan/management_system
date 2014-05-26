# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Usuario.create(username: 'admin', password: 'admin', email: 'admin@app.com', nombre_apellido: 'admin', fecha_creacion: Time.now)
Perfil.create([{descripcion: 'prefil2', detalle: 'detalle2', habilitado: 1},{descripcion: 'prefil3', detalle: 'detalle3', habilitado: 1}])
Cargo.create([{descripcion: 'cargo1',  habilitado: 1},{descripcion: 'cargo2',  habilitado: 1}])
Gerencia.create([{nombre: 'nombre1',  habilitado: 1},{nombre: 'nombre2',  habilitado: 1}])




