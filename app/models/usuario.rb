class Usuario < ActiveRecord::Base
  self.table_name = "usuario_interno" # nombre de la tabla asociadoa en el sistema administrativo
  attr_accessible :email, :fecha_creacion, :id_cargo, :id_gerencia, :id_perfil, :password, :password_salt,  :nombre_apellido, :username, :password_confirmation
  validates :password, :email, :username,  :presence => {:message => "No puede estar en blanco"}, :on => :create
  validates :password, :confirmation => true
  before_save :encriptar_password

  def self.authenticate(usuario, password)
    user = find_by_username(usuario)

    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encriptar_password
  	if password.present?
  		self.password_salt = BCrypt::Engine.generate_salt  # Semilla aletaoria
  		self.password = BCrypt::Engine.hash_secret(password, password_salt)

  		
  	end
  end
  
end
