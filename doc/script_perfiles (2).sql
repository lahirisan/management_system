
delete gerencias;
DBCC CHECKIDENT (gerencias, RESEED, 0);
insert into gerencias (nombre) values ('Comercial');
insert into gerencias (nombre) values ('Estándares y Consultoría');
insert into gerencias (nombre) values ('Administración');
insert into gerencias (nombre) values ('Presidencia Ejecutiva - Gerencia General');
insert into gerencias (nombre) values ('Talento Humano');
insert into gerencias (nombre) values ('Sistemas');
	

delete perfil_usuario_int;
DBCC CHECKIDENT (perfil_usuario_int, RESEED, 0);	

insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Gerente y Mercadeo', 1)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Ventas / Rel. Inst. / At. Cliente', 1)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Gerente', 2)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 2)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Especialista de E&C', 2)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Soporte Técnico', 2)	
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Gerente',3)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Asistente Contable',3)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Cobranzas y Asistente Administrativo',3)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Presidente y Gerente',4)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Asistente', 4)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Gerente', 5)
insert into perfil_usuario_int (descripcion, id_gerencia) VALUES ('Administrador Sist.',6)


delete usuarios_alcances;
DBCC CHECKIDENT (usuarios_alcances, RESEED, 0);	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Registrar Empresa', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Modificar Empresa Registrada', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Empresas No Activas', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Modificar Empresa', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Exportar Empresa', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Exportar Producto', 'Comercial', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Exportar GLN', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Exportar Servicio', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Ver Etiqueta', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Modificar Etiqueta', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente y Mercadeo', 'Exportar Etiqueta', 'Comercial', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Empresas No Activas', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Modificar Empresa', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Exportar Empresa', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Exportar Producto', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Exportar GLN', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Exportar Servicio', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Ver Etiqueta', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Modificar Etiqueta', 'Comercial', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Ventas / Rel. Inst. / At. Cliente', 'Exportar Etiqueta', 'Comercial', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Generar Código', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Empresas No Activas', 'Estándares y Consultoría', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Retirar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Eliminar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Activar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Reactivar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Registrar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Eliminar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Importar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Listado GTIN-8', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Registrar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Eliminar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Importar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Registrar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Eliminar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Ver Usuarios', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Registrar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Eliminar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Ver Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Empresas No Activas', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Exportar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Activar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Registrar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Exportar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Importar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Generar Código', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Listado GTIN-8', 'Estándares y Consultoría', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Registrar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Modificar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Eliminar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Exportar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Importar GLN', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Registrar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Modificar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Exportar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Ver Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Modificar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Estándares y Soluciones Técnicas / Consultorías y Servicios', 'Exportar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())

insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Empresas No Activas', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Modificar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Exportar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Activar Empresa', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Registrar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Exportar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Importar Producto', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Generar Código', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Listado GTIN-8', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Registrar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Modificar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Exportar Servicio', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Ver Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Modificar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Especialista de E&C', 'Exportar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Empresas No Activas', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Registrar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Ver Usuarios', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Modificar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Eliminar Usuario', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Ver Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Modificar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Soporte Técnico', 'Exportar Etiqueta', 'Estándares y Consultoría', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Empresas No Activas', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Empresa', 'Administración', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Empresa', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Validar Empresa', 'Administración', getdate(), getdate())		
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Generar Código', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Ver Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Etiqueta', 'Administración', getdate(), getdate())

insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Empresas No Activas', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Exportar Empresa', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Validar Empresa', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Ver Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Modificar Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente Contable', 'Exportar Etiqueta', 'Administración', getdate(), getdate())

insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Empresas No Activas', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Modificar Empresa', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Exportar Empresa', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Ver Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Modificar Etiqueta', 'Administración', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Cobranzas y Asistente Administrativo', 'Exportar Etiqueta', 'Administración', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Registrar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar Empresa Registrada', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())		
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Empresas No Activas', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Retirar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Eliminar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Exportar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Validar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Activar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Reactivar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Registrar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Eliminar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Exportar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Importar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Listado GTIN-8', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Generar Código', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())		
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Registrar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Eliminar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Exportar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Importar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Registrar Servicio', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar Servicio', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Eliminar Servicio', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Exportar Servicio', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Ver Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Modificar Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Presidente y Gerente', 'Exportar Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())

insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Empresas No Activas', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Modificar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Exportar Empresa', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Exportar Producto', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Exportar GLN', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Exportar Servicio', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Ver Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Modificar Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Asistente', 'Exportar Etiqueta', 'Presidencia Ejecutiva - Gerencia General', getdate(), getdate())

insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Empresas No Activas', 'Talento Humano', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Ver Etiqueta', 'Talento Humano', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Modificar Etiqueta', 'Talento Humano', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Gerente', 'Exportar Etiqueta', 'Talento Humano', getdate(), getdate())


insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist', 'Registrar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Empresa Registrada', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Empresas No Activas', 'Sistemas', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Retirar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Eliminar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Exportar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Activar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Reactivar Empresa', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Registrar Producto', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Producto', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Eliminar Producto', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Exportar Producto', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Importar Producto', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Listado GTIN-8', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist', 'Generar Código', 'Sistemas', getdate(), getdate())	
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Registrar GLN', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar GLN', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Eliminar GLN', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Exportar GLN', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Importar GLN', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Registrar Servicio', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Servicio', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Eliminar Servicio', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Exportar Servicio', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Ver Usuarios', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Registrar Usuario', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Usuario', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Eliminar Usuario', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Ver Etiqueta', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Modificar Etiqueta', 'Sistemas', getdate(), getdate())
insert into usuarios_alcances (perfil, alcance, gerencia, created_at, updated_at) VALUES ('Administrador Sist.', 'Exportar Etiqueta', 'Sistemas', getdate(), getdate())



delete usuario_interno;
DBCC CHECKIDENT (usuario_interno, RESEED, 0);	
INSERT INTO usuario_interno ([username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia], [fecha_creacion], [password_salt]) VALUES ('chernandez', '$2a$10$WSYkMoQhqy4oOPLzuehbTOIgzNxzz.BOMQipPkFHiQHQMgiFWJOAG', 'Claudio Hernández', 'chernandez@gs1ve.org', 1, 1, '2015-01-27 22:20:12.547', '$2a$10$WSYkMoQhqy4oOPLzuehbTO')
INSERT INTO usuario_interno ([username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia], [fecha_creacion], [password_salt]) VALUES ('yfreitas', '$2a$10$a6Z32WrQj90hw.hoWYj/j.DYFhImrkjB9k7GjRbngoblCWUa3oC06', 'Yuly de Freitas', 'yfreitas@gs1org.ve', 1, 1, '2015-01-27 22:20:41.863', '$2a$10$a6Z32WrQj90hw.hoWYj/j.')
INSERT INTO usuario_interno ([username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('yabad', '$2a$10$qVvHFTan2IVe/XgNqcDjluPDBa.9NRF71KfsxihMDHEALweCsJBD.', 'Yilibeth Abad','yabad@gs1org.ve', 2, 1, '2015-01-27 22:21:12.327', '$2a$10$qVvHFTan2IVe/XgNqcDjlu')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('cgimenez', '$2a$10$/Wy96z.4zacWYqi4y3pTqO8VsrrupcnmPM72MNwRdkUwBScDq2fru', 'Carolina Giménez', 'cgimenez@gs1ve.org', 4, 2,  '2015-01-27 22:21:44.320', '$2a$10$/Wy96z.4zacWYqi4y3pTqO')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('kfiguera', '$2a$10$z90/9SsupqrWa54ot6kl0u7DwUUW0d5Q9ThoQFiTcXurcTwQVPt6a', 'Katherine Figuera', 'kfiguera@gs1org.ve', 4, 2,  '2015-01-27 22:22:19.930', '$2a$10$z90/9SsupqrWa54ot6kl0u')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('mtorrealba', '$2a$10$VXQtpfU2Rvh5/VtsDoI4NewytK5yuc4Dadne.DcccFZgVUxNJezqG', 'Maria Torrealba', 'mtorrealba@gs1org.ve', 5, 2, '2015-01-27 22:22:49.907', '$2a$10$VXQtpfU2Rvh5/VtsDoI4Ne')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('aduben', '$2a$10$DzjXe7SGOVrHw3AKJmV.SOdn9jcCK6k4rYB0Z0FBmk6ky6.MqWpGK', 'Alicia Duben', 'aduben@gs1org.ve', 4, 2,'2015-01-27 22:23:22.327', '$2a$10$DzjXe7SGOVrHw3AKJmV.SO')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('sbarreto', '$2a$10$Hof4NkBm3/YoMWokZuAL1.GyhJ5yLZOrJFyfp4jfMzrfM4kf/inTW', 'Susana Barreto', 'sbarreto@gs1org.ve', 4, 2, '2015-01-27 22:23:50.837','$2a$10$Hof4NkBm3/YoMWokZuAL1.')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('rcalderon', '$2a$10$zbkmF1JwF9wp9lhd/WkmN.FzDCputV1/dxsTfrXqvJ2b/QF4O8LB6', 'Ricardo Calderón', 'rcalderon@gs1org.ve', 4, 2,  '2015-01-27 22:24:19.700', '$2a$10$zbkmF1JwF9wp9lhd/WkmN.')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('jgonzalez', '$2a$10$aD9rGV7M2gTyFrujzl/LAukYoaM8ObWCpf7MbNslI1UEF2vZepEJW', 'Jose Gonzalez', 'jgonzalez@gs1org.ve', 6, 2, '2015-01-27 22:24:55.807', '$2a$10$aD9rGV7M2gTyFrujzl/LAu')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('prodriguez', '$2a$10$vXCNvfauQcyseOTtEPg5MeunGyNB34XLmzNjfGI5D5FzFc.49tIEW', 'Pilar Rodríguez', 'prodriguez@gs1org.ve', 7, 3, '2015-01-27 22:25:28.140', '$2a$10$vXCNvfauQcyseOTtEPg5Me')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('ymadriz', '$2a$10$zF1FF1t4yx/pDNhfeHFJde4ieyQBfcC8vSCPJe11xN3ORpBdh7FtG', 'Yannet Madriz', 'ymadriz@gs1org.ve', 8, 3,  '2015-01-27 22:26:08.140', '$2a$10$zF1FF1t4yx/pDNhfeHFJde')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('abaduy', '$2a$10$shPLe/pSh.NSyoobN4xVPu9vxp8P3OhUdsnh.4AFIC3Dfy/MYKC2K', 'Agustina Baduy', 'abaduy@gs1org.ve', 8, 3,  '2015-01-27 22:26:42.263', '$2a$10$shPLe/pSh.NSyoobN4xVPu')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('imejias', '$2a$10$hC6l1ygEY4aNSnNnyLvHD.Oknf7SAImJgQ2PfDF.YCMieJ0ZHxzvu', 'Ibelisse Mejias', 'imejias@gs1org.ve', 9, 3,  '2015-01-27 22:27:17.480', '$2a$10$hC6l1ygEY4aNSnNnyLvHD.')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('wrodriguez', '$2a$10$j6wAvwgvoYW6ryaCUu00yunrj75npHe.7ykvfN8TCW9IVHPLzSG9e', 'Wallis Rodriguez', 'wrodriguez@gs1org.ve', 9, 3, '2015-01-27 22:27:56.860', '$2a$10$j6wAvwgvoYW6ryaCUu00yu')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('jmejia', '$2a$10$eIiSb4CTeIy.tbiHRsjHSOXW.DCGPDmcWscFCTqsNNFL6UVk7ldXi', 'Jose Luis Mejia', 'jmejia@gs1org.ve', 10, 4, '2015-01-27 22:28:40.277','$2a$10$eIiSb4CTeIy.tbiHRsjHSO')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('dcubillan', '$2a$10$Jd/VAV/AMiy3KrPaVPOBruf4V3oPPYHXTdmC9EQp1naOvEYnpaLz6', 'Denisse Cubillán', 'dcubillan@gs1org.ve', 11, 4,  '2015-01-27 22:29:13.580','$2a$10$Jd/VAV/AMiy3KrPaVPOBru')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('jbellorin', '$2a$10$h/OVjqdP0uWkFcJvNdj0/uJi82CZg1v0VTpdq0UV1TWY4p5uUj1KW','Johanna Bellorín', 'jbellorin@gs1ve.org', 12, 5,  '2015-01-27 22:29:42.690', '$2a$10$h/OVjqdP0uWkFcJvNdj0/u')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('gtecnico', '$2a$10$u92g/hbRn7Cjk0.Bqh9MV.RL68WIqXkihwYGxaocI7rTUtPhC5SXy', 'Gerente Técnico', 'gtecnico@gs1ve.org', 3, 2,  '2015-01-27 22:30:17.617', '$2a$10$u92g/hbRn7Cjk0.Bqh9MV.')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('admin', '$2a$10$jlnZ7o11D6UoiNaKkRQLIOKaFH5ciKcO.eTX/4DuICr53kM66kdOu', 'Administrador de Sistema', 'administrador@gs1ve.org', 13, 6,  '2015-01-27 22:31:36.713', '$2a$10$jlnZ7o11D6UoiNaKkRQLIO')
INSERT INTO usuario_interno ( [username], [password], [nombre_apellido], [email], [id_perfil], [id_gerencia],  [fecha_creacion], [password_salt]) VALUES ('Kmarrero', '$2a$10$a39v0hmzbOtgctKL67jjn.3Oklr.kkjncy0Zf861p6rhX4hGffIAG', 'Keila Marrero', 'kmarrero@gs1ve.org', 5, 2, '2015-02-02 15:01:15.670', '$2a$10$a39v0hmzbOtgctKL67jjn.')




























